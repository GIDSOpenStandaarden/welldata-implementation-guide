#!/usr/bin/env python3
"""Exporteer een memo (Markdown met SVG-illustraties, Excalidraw-platen en Mermaid) naar PDF.

Gebruik: python3 memos/export-pdf.py [memos/memo-persoonlijke-gegevenskluis.md]
Uitvoer: memos/export/<memo>.pdf (plus de gerenderde platen en diagrammen als SVG).
Vereist: pandoc, mmdc (mermaid-cli) en Google Chrome.
"""
import base64
import html
import json
import math
import os
import re
import subprocess
import sys
from pathlib import Path

IG_URL = "https://gidsopenstandaarden.github.io/welldata-implementation-guide/"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"


def headless_browser():
    """chrome-headless-shell van puppeteer werkt het betrouwbaarst; anders de gewone Chrome."""
    shells = sorted(Path.home().glob(".cache/puppeteer/chrome-headless-shell/*/*/chrome-headless-shell"))
    return str(shells[-1]) if shells else CHROME
FONT = "Helvetica, Arial, sans-serif"

CSS = """
@page { size: A4; margin: 20mm 18mm; }
body { font-family: Helvetica, Arial, sans-serif; font-size: 10.5pt; line-height: 1.45; color: #1e1e1e; }
h1 { font-size: 20pt; margin-bottom: 4pt; }
h2 { font-size: 14pt; margin-top: 18pt; border-bottom: 1px solid #ccc; padding-bottom: 2pt; }
h3 { font-size: 11.5pt; margin-top: 12pt; }
h1, h2, h3 { break-after: avoid; page-break-after: avoid; }
p:has(+ ul), p:has(+ ol), p:has(+ table) { break-after: avoid; page-break-after: avoid; }
table { border-collapse: collapse; width: 100%; font-size: 9pt; margin: 8pt 0; page-break-inside: auto; }
th, td { border: 1px solid #bbb; padding: 4pt 5pt; vertical-align: top; text-align: left; }
th { background: #f1f3f5; }
tr { page-break-inside: avoid; }
code { font-size: 8.5pt; background: #f1f3f5; padding: 0 2px; }
pre { background: #f1f3f5; padding: 6pt 8pt; line-height: 1.35; page-break-inside: avoid; }
pre code { background: none; padding: 0; }
blockquote { border-left: 3px solid #1971c2; margin-left: 0; padding: 2pt 10pt; color: #495057; background: #f8f9fa; }
@page wide { size: A4 landscape; margin: 15mm; }
figure { margin: 10pt 0; text-align: center; page-break-inside: avoid; }
figure img, figure svg { width: 100%; height: auto; max-height: 200mm; }
figure.wide { page: wide; }
figure.wide img, figure.wide svg { max-height: 165mm; }
figcaption { font-size: 9pt; color: #555; }
a { color: #1971c2; text-decoration: none; }
"""


def esc(s):
    return html.escape(s, quote=True)


def excalidraw_to_svg(src: Path, dst: Path):
    els = [e for e in json.loads(src.read_text())["elements"] if not e.get("isDeleted")]
    if not els:
        raise SystemExit(f"Plaat is leeg: {src} (herstel eerst, bijvoorbeeld met git restore)")
    by_id = {e["id"]: e for e in els}
    out, xs, ys = [], [], []

    def bounds(x, y, w, h):
        xs.extend([x, x + w]); ys.extend([y, y + h])

    def stroke(e):
        c = e.get("strokeColor", "#1e1e1e")
        return "none" if c == "transparent" else c

    for e in els:
        t, x, y = e["type"], e["x"], e["y"]
        w, h = e.get("width", 0), e.get("height", 0)
        dash = ' stroke-dasharray="10 8"' if e.get("strokeStyle") == "dashed" else ""
        if t == "frame":
            out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" fill="none" stroke="#adb5bd" stroke-width="2"/>')
            out.append(f'<text x="{x}" y="{y - 10}" font-family="{FONT}" font-size="16" fill="#868e96">{esc(e.get("name") or "")}</text>')
            bounds(x, y - 30, w, h + 30)
        elif t == "rectangle":
            bg = e.get("backgroundColor", "transparent")
            fill = "none" if bg == "transparent" else bg
            rx = min(32, 0.25 * min(w, h)) if e.get("roundness") else 0
            out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx:.1f}" fill="{fill}" stroke="{stroke(e)}" stroke-width="{e.get("strokeWidth", 2)}"{dash}/>')
            bounds(x, y, w, h)
        elif t == "arrow":
            pts = [(x + px, y + py) for px, py in e["points"]]
            path = " ".join(f"{px:.1f},{py:.1f}" for px, py in pts)
            out.append(f'<polyline points="{path}" fill="none" stroke="{stroke(e)}" stroke-width="2"{dash}/>')
            if e.get("endArrowhead"):
                (x1, y1), (x2, y2) = pts[-2], pts[-1]
                a = math.atan2(y2 - y1, x2 - x1)
                for d in (0.45, -0.45):
                    hx, hy = x2 - 16 * math.cos(a + d), y2 - 16 * math.sin(a + d)
                    out.append(f'<line x1="{x2:.1f}" y1="{y2:.1f}" x2="{hx:.1f}" y2="{hy:.1f}" stroke="{stroke(e)}" stroke-width="2"/>')
            for px, py in pts:
                bounds(px, py, 0, 0)
    # Tekst als laatste, zodat labels boven pijlen en kaders liggen.
    for e in els:
        if e["type"] != "text":
            continue
        x, y, w, h = e["x"], e["y"], e["width"], e["height"]
        fs = e.get("fontSize", 20)
        lh = fs * e.get("lineHeight", 1.25)
        lines = e["text"].split("\n")
        container = by_id.get(e.get("containerId"))
        align = e.get("textAlign", "left")
        anchor, tx = {"center": ("middle", x + w / 2), "right": ("end", x + w)}.get(align, ("start", x))
        if container and container["type"] == "arrow":
            out.append(f'<rect x="{x - 4}" y="{y - 2}" width="{w + 8}" height="{h + 4}" fill="#ffffff"/>')
        color = e.get("strokeColor", "#1e1e1e")
        for i, line in enumerate(lines):
            ly = y + (i + 0.5) * lh
            out.append(f'<text x="{tx:.1f}" y="{ly:.1f}" text-anchor="{anchor}" dominant-baseline="central" font-family="{FONT}" font-size="{fs}" fill="{color}">{esc(line)}</text>')
        bounds(x, y, w, h)
    pad = 20
    minx, miny = min(xs) - pad, min(ys) - pad
    vw, vh = max(xs) - minx + pad, max(ys) - miny + pad
    dst.write_text(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{minx:.0f} {miny:.0f} {vw:.0f} {vh:.0f}" width="100%">'
                   f'<rect x="{minx:.0f}" y="{miny:.0f}" width="{vw:.0f}" height="{vh:.0f}" fill="#ffffff"/>' + "".join(out) + "</svg>")
    return vw / vh


def main():
    memo = Path(sys.argv[1] if len(sys.argv) > 1 else "memos/memo-persoonlijke-gegevenskluis.md").resolve()
    base, outdir = memo.parent, memo.parent / "export"
    outdir.mkdir(exist_ok=True)
    md = memo.read_text()

    def plaat(m):
        label, fname = m.group(1), m.group(2)
        svg = outdir / (Path(fname).stem + ".svg")
        ratio = excalidraw_to_svg(base / fname, svg)
        caption = label.replace("Plaat: ", "")
        caption = esc(caption[:1].upper() + caption[1:])
        cls = "wide" if ratio > 2 else ""
        return f'<figure class="{cls}"><img src="{svg.name}" alt="{caption}"><figcaption>{caption}</figcaption></figure>'
    md = re.sub(r'^\[([^\]]+)\]\(([^)\s]+\.excalidraw)(?:\s+"[^"]*")?\)[ \t]*$', plaat, md, flags=re.M)

    def illustratie(m):
        # Als data-URI, zodat de stijl en de iconen van elke SVG op zichzelf blijven staan.
        caption, fname = esc(m.group(1)), m.group(2)
        data = base64.b64encode((base / fname).read_bytes()).decode()
        return (f'<figure><img src="data:image/svg+xml;base64,{data}" alt="{caption}">'
                f'<figcaption>{caption}</figcaption></figure>')
    md = re.sub(r'^!\[([^\]]*)\]\(((?!https?:)[^)\s]+\.svg)\)[ \t]*$', illustratie, md, flags=re.M)

    counter = iter(range(1, 100))
    def mermaid(m):
        n = next(counter)
        src, svg = outdir / f"mermaid-{n}.mmd", outdir / f"mermaid-{n}.svg"
        src.write_text(m.group(1))
        cfg = outdir / "mermaid-config.json"
        cfg.write_text(json.dumps({"fontFamily": FONT, "themeVariables": {"fontFamily": FONT}}))
        env = {**os.environ, "PUPPETEER_EXECUTABLE_PATH": headless_browser()}
        cmd = ["mmdc", "-i", str(src), "-o", str(svg), "-b", "white", "-c", str(cfg)]
        for poging in (1, 2):  # mmdc blijft soms hangen bij het starten van Chrome
            try:
                subprocess.run(cmd, check=True, capture_output=True, env=env, timeout=90)
                break
            except subprocess.TimeoutExpired:
                if poging == 2:
                    raise SystemExit("mmdc reageert niet; probeer het later opnieuw")
        src.unlink(); cfg.unlink()
        # Een accTitle in het diagram wordt het bijschrift.
        titel = re.search(r"^\s*accTitle:\s*(.+)$", m.group(1), flags=re.M)
        caption = f"<figcaption>{esc(titel.group(1).strip())}</figcaption>" if titel else ""
        return f'<figure><img src="{svg.name}" alt="">{caption}</figure>'
    md = re.sub(r"```mermaid\n(.*?)```", mermaid, md, flags=re.S)

    # IG-pagina's naar de gepubliceerde IG; andere lokale .md-links worden platte tekst.
    md = re.sub(r"\]\(\.\./input/pagecontent/([\w-]+)\.md\)", lambda m: f"]({IG_URL}{m.group(1)}.html)", md)
    md = re.sub(r"\[([^\]]+)\]\((?!https?:)[^)]+\.md\)", r"\1", md)
    md = md.replace("> [!NOTE]\n> ", "> **Noot:** ")

    html_file = outdir / (memo.stem + ".html")
    css_file = outdir / "memo.css"
    css_file.write_text(CSS)
    tmp_md = outdir / (memo.stem + ".export.md")
    tmp_md.write_text(md)
    subprocess.run(["pandoc", str(tmp_md), "-f", "gfm", "-t", "html5", "--standalone", "--embed-resources",
                    "--css", str(css_file), "--metadata", f"pagetitle={memo.stem}", "-o", str(html_file)],
                   check=True, cwd=outdir)
    pdf = outdir / (memo.stem + ".pdf")
    pdf.unlink(missing_ok=True)
    # Chrome eindigt soms met een foutcode of sluit niet af, ook als de PDF goed is geschreven.
    try:
        subprocess.run([headless_browser(), "--headless", "--disable-gpu", "--no-pdf-header-footer",
                        f"--print-to-pdf={pdf}", html_file.as_uri()], capture_output=True, timeout=120)
    except subprocess.TimeoutExpired:
        pass
    if not pdf.exists() or pdf.stat().st_size == 0:
        raise SystemExit(f"Chrome heeft geen PDF geschreven: {pdf}")
    for f in (tmp_md, css_file, html_file):
        f.unlink()
    # Alleen-lezen: een editor die de PDF als tekst opent en opslaat, maakt hem anders onleesbaar.
    pdf.chmod(0o444)
    print(pdf)


if __name__ == "__main__":
    main()
