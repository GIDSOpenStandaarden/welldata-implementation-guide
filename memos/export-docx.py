#!/usr/bin/env python3
"""Exporteer een memo naar Word (.docx), om in Google Docs te openen voor review.

Gebruik: python3 memos/export-docx.py [memos/memo-persoonlijke-gegevenskluis.md]
Uitvoer: memos/export/<memo>.docx, opgemaakt als de PDF van export-pdf.py.
Vereist: pandoc, rsvg-convert en mmdc (mermaid-cli).

Naar Google Docs: sleep het bestand naar de map in Google Drive, open het met Google
Documenten en kies Bestand > Opslaan als Google Documenten.

Google Docs kent geen SVG, dus illustraties en diagrammen gaan er als PNG in. Opmaak die
bij het importeren uit een tabelstijl kan wegvallen (randen, kopregel, lettergrootte en
kolombreedtes) staat direct op elke tabel.

Elke pagina krijgt een voettekst: links de regel "Licentie" uit de kop van de memo, rechts
het paginanummer.
"""
import io
import json
import os
import re
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path
from xml.sax.saxutils import escape

IG_URL = "https://gidsopenstandaarden.github.io/welldata-implementation-guide/"
FONT = "Arial"  # de PDF gebruikt Helvetica; Arial is de variant die Google Docs kent
MONO = "Consolas"
IMAGE_PX = 1680  # twee keer de breedte waarop de illustraties zijn getekend
PAGE = (11906, 16838)  # A4, in twips (1/20 pt)
MARGIN = (1134, 1020)  # boven en onder 20 mm, links en rechts 18 mm, zoals de PDF
TEXT_WIDTH = PAGE[0] - 2 * MARGIN[1]
W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"

FOOTER_ID = "rId900"
FOOTER_TYPE = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer"
SECTION = (f'<w:sectPr><w:footerReference w:type="default" r:id="{FOOTER_ID}"/>'
           f'<w:pgSz w:w="{PAGE[0]}" w:h="{PAGE[1]}"/>'
           f'<w:pgMar w:top="{MARGIN[0]}" w:right="{MARGIN[1]}" w:bottom="{MARGIN[0]}" w:left="{MARGIN[1]}"'
           ' w:header="567" w:footer="567" w:gutter="0"/></w:sectPr>')
DEFAULTS = (f'<w:docDefaults><w:rPrDefault><w:rPr><w:rFonts w:ascii="{FONT}" w:hAnsi="{FONT}" w:eastAsia="{FONT}" w:cs="{FONT}"/>'
            '<w:color w:val="1E1E1E"/><w:sz w:val="21"/><w:szCs w:val="21"/><w:lang w:val="nl-NL"/></w:rPr></w:rPrDefault>'
            '<w:pPrDefault><w:pPr><w:spacing w:after="0" w:line="300" w:lineRule="auto"/></w:pPr></w:pPrDefault></w:docDefaults>')
TABLE_BORDERS = "<w:tblBorders>" + "".join(
    f'<w:{side} w:val="single" w:sz="4" w:space="0" w:color="BBBBBB"/>'
    for side in ("top", "left", "bottom", "right", "insideH", "insideV")) + "</w:tblBorders>"
TABLE_MARGINS = ('<w:tblCellMar><w:top w:w="60" w:type="dxa"/><w:left w:w="100" w:type="dxa"/>'
                 '<w:bottom w:w="60" w:type="dxa"/><w:right w:w="100" w:type="dxa"/></w:tblCellMar>')
HEADER_FILL = '<w:shd w:val="clear" w:color="auto" w:fill="F1F3F5"/>'
TABLE_STYLE = ('<w:style w:type="table" w:default="1" w:styleId="Table"><w:name w:val="Table"/><w:basedOn w:val="TableNormal"/>'
               f'<w:qFormat/><w:tblPr><w:tblInd w:w="0" w:type="dxa"/>{TABLE_BORDERS}{TABLE_MARGINS}</w:tblPr>'
               f'<w:tblStylePr w:type="firstRow"><w:rPr><w:b/><w:bCs/></w:rPr><w:tcPr>{HEADER_FILL}</w:tcPr></w:tblStylePr></w:style>')

SINGLE = 'w:line="240" w:lineRule="auto"'
BOLD = "<w:b/><w:bCs/>"


def size(pt):
    return f'<w:sz w:val="{round(pt * 2)}"/><w:szCs w:val="{round(pt * 2)}"/>'


# Per stijl de alinea- en tekeneigenschappen, met de maten uit de CSS van export-pdf.py.
STYLES = {
    # Ook op Normal, voor importeurs die de documentstandaard overslaan.
    "Normal": ("", f'<w:rFonts w:ascii="{FONT}" w:hAnsi="{FONT}" w:eastAsia="{FONT}" w:cs="{FONT}"/><w:color w:val="1E1E1E"/>'
               + size(10.5)),
    "BodyText": ('<w:spacing w:before="0" w:after="140"/>', ""),
    "Compact": ('<w:spacing w:before="20" w:after="20"/>', ""),
    "Title": (f'<w:keepNext/><w:spacing w:before="0" w:after="120" {SINGLE}/>', BOLD + size(20)),
    "Heading1": ('<w:keepNext/><w:keepLines/><w:pBdr><w:bottom w:val="single" w:sz="4" w:space="2" w:color="CCCCCC"/></w:pBdr>'
                 f'<w:spacing w:before="360" w:after="140" {SINGLE}/><w:outlineLvl w:val="0"/>', BOLD + size(14)),
    "Heading2": (f'<w:keepNext/><w:keepLines/><w:spacing w:before="240" w:after="100" {SINGLE}/><w:outlineLvl w:val="1"/>',
                 BOLD + size(11.5)),
    "Heading3": (f'<w:keepNext/><w:keepLines/><w:spacing w:before="200" w:after="80" {SINGLE}/><w:outlineLvl w:val="2"/>',
                 BOLD + size(10.5)),
    "BlockText": ('<w:pBdr><w:left w:val="single" w:sz="18" w:space="8" w:color="1971C2"/></w:pBdr>'
                  '<w:shd w:val="clear" w:color="auto" w:fill="F8F9FA"/><w:spacing w:before="120" w:after="200"/>'
                  '<w:ind w:left="200" w:right="0" w:firstLine="0"/>', '<w:color w:val="495057"/>'),
    "Caption": ('<w:spacing w:before="80" w:after="240"/><w:jc w:val="center"/>', '<w:color w:val="555555"/>' + size(9)),
    "Figure": (f'<w:spacing w:before="200" w:after="0" {SINGLE}/><w:jc w:val="center"/>', ""),
    "CaptionedFigure": (f'<w:keepNext/><w:spacing w:before="200" w:after="0" {SINGLE}/><w:jc w:val="center"/>', ""),
    "VerbatimChar": ("", f'<w:rFonts w:ascii="{MONO}" w:hAnsi="{MONO}" w:cs="{MONO}"/>' + size(9)
                     + '<w:shd w:val="clear" w:color="auto" w:fill="F1F3F5"/>'),
    "Hyperlink": ("", '<w:color w:val="1971C2"/><w:u w:val="none"/>'),
}


def restyle(styles):
    """Zet in de styles.xml van pandoc de stijlen van de memo."""
    styles = re.sub(r"<w:docDefaults>.*?</w:docDefaults>", DEFAULTS, styles, flags=re.S)
    styles, n = re.subn(r'<w:style [^>]*w:styleId="Table"[^>]*>.*?</w:style>', TABLE_STYLE, styles, flags=re.S)
    assert n == 1, "tabelstijl niet gevonden"
    for style_id, (paragraph, run) in STYLES.items():
        def replace(m):
            kept = re.sub(r"<w:([pr])Pr>.*?</w:\1Pr>", "", m.group(2), flags=re.S)
            return (m.group(1) + kept + (f"<w:pPr>{paragraph}</w:pPr>" if paragraph else "")
                    + (f"<w:rPr>{run}</w:rPr>" if run else "") + m.group(3))
        styles, n = re.subn(rf'(<w:style [^>]*w:styleId="{style_id}"[^>]*>)(.*?)(</w:style>)', replace, styles, flags=re.S)
        assert n == 1, f"stijl {style_id} niet gevonden"
    return styles


def rewrite(src, dst, changes, added=None):
    """Kopieer een docx, pas de genoemde onderdelen aan en voeg nieuwe onderdelen toe."""
    with zipfile.ZipFile(src) as zin, zipfile.ZipFile(dst, "w", zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            if item.filename in changes:
                data = changes[item.filename](data.decode()).encode()
            zout.writestr(item, data)
        for name, text in (added or {}).items():
            zout.writestr(name, text.encode())


def licentieregel(md):
    """De regel 'Licentie' uit de kop van de memo als platte tekst; leeg als die ontbreekt."""
    m = re.search(r"^- \*\*Licentie:\*\*[ \t]*(.+)$", md, flags=re.M)
    return re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", m.group(1)).strip() if m else ""


def footer_part(tekst):
    """De voettekst: links de licentieregel, rechts het paginanummer (achter een tab naar de rechtermarge)."""
    props = f'<w:rPr><w:color w:val="666666"/>{size(8)}</w:rPr>'

    def run(t):
        return f'<w:r>{props}<w:t xml:space="preserve">{escape(t)}</w:t></w:r>'

    def veld(naam):
        return f'<w:fldSimple w:instr=" {naam} "><w:r>{props}<w:t>1</w:t></w:r></w:fldSimple>'

    return ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
            f'<w:ftr xmlns:w="{W}"><w:p><w:pPr><w:tabs><w:tab w:val="right" w:pos="{TEXT_WIDTH}"/></w:tabs>'
            f'<w:spacing w:before="0" w:after="0" {SINGLE}/></w:pPr>'
            + run(tekst) + f'<w:r>{props}<w:tab/></w:r>' + run("Pagina ") + veld("PAGE")
            + run(" van ") + veld("NUMPAGES") + '</w:p></w:ftr>')


def reference_doc(work, voettekst):
    """De standaardsjabloon van pandoc, met de stijlen, het paginaformaat en de voettekst van de PDF."""
    default, ref = work / "pandoc-reference.docx", work / "reference.docx"
    default.write_bytes(subprocess.run(["pandoc", "--print-default-data-file", "reference.docx"],
                                       check=True, capture_output=True).stdout)
    relation = f'<Relationship Type="{FOOTER_TYPE}" Id="{FOOTER_ID}" Target="footer1.xml"/>'
    content_type = ('<Override PartName="/word/footer1.xml" ContentType='
                    '"application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml"/>')
    # Pandoc neemt de voettekst over uit de sjabloon: het onderdeel zelf, de relatie en de verwijzing in de sectie.
    rewrite(default, ref, {
        "word/styles.xml": restyle,
        "word/document.xml": lambda xml: re.sub(r"<w:sectPr>.*?</w:sectPr>", SECTION, xml, flags=re.S),
        "word/_rels/document.xml.rels": lambda xml: xml.replace("</Relationships>", relation + "</Relationships>"),
        "[Content_Types].xml": lambda xml: xml.replace("</Types>", content_type + "</Types>"),
    }, added={"word/footer1.xml": footer_part(voettekst)})
    return ref


def w(tag):
    return f"{{{W}}}{tag}"


def parts(xml):
    return list(ET.fromstring(f'<x xmlns:w="{W}">{xml}</x>'))


def child(parent, tag, index=0):
    """Het kindelement met deze naam; maak het aan als het ontbreekt."""
    el = parent.find(w(tag))
    if el is None:
        el = ET.Element(w(tag))
        parent.insert(index, el)
    return el


def set_spacing(p, **values):
    ppr = child(p, "pPr")
    # In een pPr staat w:spacing na de stijl en de lijstnummering.
    spacing = child(ppr, "spacing", sum(1 for el in ppr if el.tag in (w("pStyle"), w("keepNext"), w("numPr"))))
    for key, value in values.items():
        spacing.set(w(key), str(value))


def format_table(tbl):
    rows = tbl.findall(w("tr"))
    # Kolombreedte naar de hoeveelheid tekst, zoals een browser dat in de PDF doet.
    text = [0] * max(len(row.findall(w("tc"))) for row in rows)
    for row in rows:
        for i, cell in enumerate(row.findall(w("tc"))):
            text[i] += len("".join(cell.itertext()))
    share = [max(n, 1) ** 0.5 for n in text]
    share = [max(s / sum(share), 0.15) for s in share]
    widths = [round(TEXT_WIDTH * s / sum(share)) for s in share]

    props = tbl.find(w("tblPr"))
    look = props.find(w("tblLook"))
    props[:] = parts(f'<w:tblStyle w:val="Table"/><w:tblW w:w="{sum(widths)}" w:type="dxa"/>{TABLE_BORDERS}'
                     f'<w:tblLayout w:type="fixed"/>{TABLE_MARGINS}') + ([look] if look is not None else [])
    tbl.find(w("tblGrid"))[:] = parts("".join(f'<w:gridCol w:w="{x}"/>' for x in widths))
    for row in rows:
        row_props = child(row, "trPr")
        header = row_props.find(w("tblHeader")) is not None
        row_props.insert(0, ET.Element(w("cantSplit")))  # een rij breekt niet over twee pagina's
        for i, cell in enumerate(row.findall(w("tc"))):
            child(cell, "tcPr")[:] = parts(f'<w:tcW w:w="{widths[i]}" w:type="dxa"/>' + (HEADER_FILL if header else ""))
            for p in cell.iter(w("p")):
                set_spacing(p, before=0, after=0, line=264, lineRule="auto")
            for run in cell.iter(w("r")):
                run_props = child(run, "rPr")
                if header and run_props.find(w("b")) is None:
                    at = 1 if len(run_props) and run_props[0].tag == w("rStyle") else 0
                    run_props[at:at] = parts(BOLD)
                # De lettergrootte hoort voor de taal die pandoc op elke run zet.
                lang = run_props.find(w("lang"))
                at = len(run_props) if lang is None else list(run_props).index(lang)
                run_props[at:at] = parts(size(9))


def finish(xml):
    """Tabellen opmaken en wit zetten na een lijst en na een tabel."""
    for _, namespace in ET.iterparse(io.BytesIO(xml.encode()), events=["start-ns"]):
        ET.register_namespace(*namespace)
    root = ET.fromstring(xml)
    blocks = list(root.find(w("body")))

    def style(block):
        el = None if block is None else block.find(f"{w('pPr')}/{w('pStyle')}")
        return None if el is None else el.get(w("val"))

    def in_list(block):
        return block is not None and block.find(f"{w('pPr')}/{w('numPr')}") is not None

    for block, following in zip(blocks, blocks[1:] + [None]):
        if block.tag == w("tbl"):
            format_table(block)
            if style(following) in ("BodyText", "FirstParagraph", "Compact"):
                set_spacing(following, before=160)
        elif in_list(block) and not in_list(following):
            set_spacing(block, after=140)
    return '<?xml version="1.0" encoding="UTF-8"?>\n' + ET.tostring(root, encoding="unicode")


def headless_browser():
    """chrome-headless-shell van puppeteer, als die er is (zie export-pdf.py)."""
    shells = sorted(Path.home().glob(".cache/puppeteer/chrome-headless-shell/*/*/chrome-headless-shell"))
    return {"PUPPETEER_EXECUTABLE_PATH": str(shells[-1])} if shells else {}


def main():
    memo = Path(sys.argv[1] if len(sys.argv) > 1 else "memos/memo-persoonlijke-gegevenskluis.md").resolve()
    outdir = memo.parent / "export"
    outdir.mkdir(exist_ok=True)
    md = memo.read_text()
    voettekst = licentieregel(md)

    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)

        def illustratie(m):
            png = work / (Path(m.group(2)).stem + ".png")
            subprocess.run(["rsvg-convert", "-w", str(IMAGE_PX), "-b", "white", str(memo.parent / m.group(2)),
                            "-o", str(png)], check=True)
            return f"![{m.group(1)}]({png.name})"
        md = re.sub(r'^!\[([^\]]*)\]\(((?!https?:)[^)\s]+\.svg)\)[ \t]*$', illustratie, md, flags=re.M)

        counter = iter(range(1, 100))
        def mermaid(m):
            n = next(counter)
            src, png, cfg = work / f"mermaid-{n}.mmd", work / f"mermaid-{n}.png", work / "mermaid-config.json"
            src.write_text(m.group(1))
            cfg.write_text(json.dumps({"fontFamily": FONT, "themeVariables": {"fontFamily": FONT}}))
            cmd = ["mmdc", "-i", str(src), "-o", str(png), "-b", "white", "-c", str(cfg), "-s", "2"]
            for poging in (1, 2):  # mmdc blijft soms hangen bij het starten van Chrome
                try:
                    subprocess.run(cmd, check=True, capture_output=True, env={**os.environ, **headless_browser()}, timeout=90)
                    break
                except subprocess.TimeoutExpired:
                    if poging == 2:
                        raise SystemExit("mmdc reageert niet; probeer het later opnieuw")
            # Een accTitle in het diagram wordt het bijschrift.
            titel = re.search(r"^\s*accTitle:\s*(.+)$", m.group(1), flags=re.M)
            return f"![{titel.group(1).strip() if titel else ''}]({png.name})"
        md = re.sub(r"```mermaid\n(.*?)```", mermaid, md, flags=re.S)

        # IG-pagina's naar de gepubliceerde IG; andere lokale .md-links worden platte tekst.
        md = re.sub(r"\]\(\.\./input/pagecontent/([\w-]+)\.md\)", lambda m: f"]({IG_URL}{m.group(1)}.html)", md)
        md = re.sub(r"\[([^\]]+)\]\((?!https?:)[^)]+\.md\)", r"\1", md)
        md = md.replace("> [!NOTE]\n> ", "> **Noot:** ")

        source, draft = work / "memo.md", work / "memo.docx"
        source.write_text(md)
        # De titel (kop 1) wordt de documenttitel; hoofdstukken worden Kop 1, paragrafen Kop 2.
        subprocess.run(["pandoc", str(source), "-f", "gfm+implicit_figures", "-t", "docx", "--shift-heading-level-by=-1",
                        "--reference-doc", str(reference_doc(work, voettekst)), "--resource-path", str(work),
                        "-M", "lang=nl-NL", "-o", str(draft)], check=True)
        docx = outdir / (memo.stem + ".docx")
        rewrite(draft, docx, {"word/document.xml": finish})
    print(docx)


if __name__ == "__main__":
    main()
