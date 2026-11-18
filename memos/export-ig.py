#!/usr/bin/env python3
"""Zet een memo (Markdown met SVG-illustraties en Mermaid) om naar een pagina van de Implementation Guide.

Gebruik: python3 memos/export-ig.py [memos/memo-persoonlijke-gegevenskluis.md]
Uitvoer: input/pagecontent/<memo>.md, de illustraties als input/images/<memo>-*.svg en de
diagrammen als input/images-source/<memo>-*.plantuml.
Vereist: alleen Python 3.

De memo in memos/ blijft de bron. De uitvoer is gegenereerd, staat in .gitignore en wordt door de
Makefile voor elke build opnieuw gemaakt: bewerk dus de memo en niet de pagina. Dat de pagina
bestaat, staat in sushi-config.yaml (pages en menu).

Wat er verandert ten opzichte van de memo:
- de titel vervalt, want de IG zet de titel uit sushi-config.yaml boven de pagina, en de koppen
  schuiven een niveau op; de eigen nummering van de memo blijft, die van de IG-template gaat uit;
- een illustratie wordt een figuur met bijschrift;
- een Mermaid-sequentiediagram wordt PlantUML, dat de IG Publisher zelf tekent;
- links naar de IG worden relatief, links naar andere bestanden in de repository gaan naar GitHub.
"""
import html
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
IG_URL = "https://gidsopenstandaarden.github.io/welldata-implementation-guide/"
REPO_URL = "https://github.com/GIDSOpenStandaarden/welldata-implementation-guide/blob/main/"
# De memo nummert zijn eigen koppen en verwijst daarnaar ("zie 4.2"); de nummering die de
# IG-template voor elke kop zet, zou er dubbel voor staan. Dit geldt alleen voor deze pagina.
OPMAAK = """{::nomarkdown}
<style>
h3:before, h4:before, h5:before, h6:before { content: none !important; }
figure { margin: 1.2em 0 1.6em; }
figcaption { margin-top: 0.4em; font-size: 0.9em; color: #555; }
</style>
{:/}

"""
PIJLEN = {"->>": "->", "-->>": "-->"}
STIJL = """skinparam shadowing false
skinparam sequence {
  ArrowColor #495057
  LifeLineBorderColor #ADB5BD
  ParticipantBorderColor #868E96
  ParticipantBackgroundColor #F8F9FA
  BoxBorderColor #CED4DA
}"""


def kleur(css):
    """Een CSS-kleur (#rgb, #rrggbb of rgb(r, g, b)) in de schrijfwijze van PlantUML; leeg als het geen kleur is."""
    css = css.strip()
    m = re.fullmatch(r"rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)", css)
    if m:
        return "#%02X%02X%02X" % tuple(int(g) for g in m.groups())
    if re.fullmatch(r"#[0-9a-fA-F]{6}", css):
        return css.upper()
    if re.fullmatch(r"#[0-9a-fA-F]{3}", css):
        return "#" + "".join(c * 2 for c in css[1:]).upper()
    return ""


def mermaid_naar_plantuml(src):
    """Zet een Mermaid-sequentiediagram om naar PlantUML; geeft het diagram en de accTitle terug.

    Ondersteund is wat de memo gebruikt: participant, actor, box, autonumber en de pijlen ->> en -->>,
    plus de vulkleur per deelnemer uit themeCSS. Bij al het andere stopt de export met een melding,
    zodat een diagram niet ongemerkt onvolledig in de IG komt.
    """
    vulling = {}
    themecss = re.search(r'"themeCSS"\s*:\s*"([^"]*)"', src)
    for selectors, regels in re.findall(r"([^{}]+)\{([^}]*)\}", themecss.group(1) if themecss else ""):
        fill = re.search(r"fill:\s*([^;]+)", regels)
        for naam in re.findall(r"name=(\w+)", selectors):
            if fill and kleur(fill.group(1)):
                vulling[naam] = " " + kleur(fill.group(1))

    def label(tekst):
        return tekst.replace("<br/>", "\\n").replace('"', "'")

    regels = [r.strip() for r in re.sub(r"%%\{.*?\}%%", "", src, flags=re.S).splitlines()]
    regels = [r for r in regels if r and not r.startswith("%%")]
    if not regels or regels[0] != "sequenceDiagram":
        raise SystemExit("export-ig: alleen een Mermaid-sequentiediagram kan naar de IG; gebruik anders een illustratie")
    uit, titel, in_box = ["@startuml", STIJL], "", False
    for r in regels[1:]:
        if m := re.fullmatch(r"accTitle:\s*(.+)", r):
            titel = m.group(1)
        elif r.startswith("accDescr:"):
            continue
        elif r == "autonumber":
            uit.append(r)
        elif m := re.fullmatch(r"(participant|actor)\s+(\w+)(?:\s+as\s+(.+))?", r):
            soort, naam, tekst = m.groups()
            uit.append(f'{soort} "{label(tekst or naam)}" as {naam}{vulling.get(naam, "")}')
        elif m := re.fullmatch(r"box(?:\s+(rgb\([^)]*\)|#\w+))?(?:\s+(.+))?", r):
            vul = kleur(m.group(1) or "")
            uit.append(f'box "{label(m.group(2) or "")}"' + (f" {vul}" if vul else ""))
            in_box = True
        elif r == "end" and in_box:
            uit.append("end box")
            in_box = False
        elif m := re.fullmatch(r"(\w+)\s*(-->>|->>)\s*(\w+)\s*:\s*(.*)", r):
            van, pijl, naar, tekst = m.groups()
            uit.append(f"{van} {PIJLEN[pijl]} {naar} : {label(tekst)}")
        else:
            raise SystemExit(f"export-ig: deze regel in een Mermaid-diagram wordt niet ondersteund: {r}")
    return "\n".join(uit + ["@enduml"]) + "\n", titel


def liquid_veilig(tekst):
    """Jekyll leest {{ en {% als Liquid; zet ze zo neer dat ze letterlijk in de pagina komen."""
    return re.sub(r"\{\{|\{%", lambda m: "{% raw %}" + m.group(0) + "{% endraw %}", tekst)


def figuur(inhoud, bijschrift):
    onder = f"<figcaption>{html.escape(bijschrift)}</figcaption>\n" if bijschrift else ""
    return f"<figure>\n{inhoud}\n{onder}</figure>"


def main():
    memo = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / "memos/memo-persoonlijke-gegevenskluis.md").resolve()
    naam = memo.stem
    beelden, bronnen = ROOT / "input/images", ROOT / "input/images-source"
    for oud in [*beelden.glob(naam + "-*"), *bronnen.glob(naam + "-*")]:
        oud.unlink()

    def illustratie(m):
        bijschrift, bron = m.group(1), memo.parent / m.group(2)
        doel = beelden / f"{naam}-{bron.name}"
        shutil.copyfile(bron, doel)
        # Niet breder dan de tekening zelf; "float: none" zoals de andere pagina's van de IG.
        breedte = re.search(r'<svg[^>]*\swidth="(\d+)"', bron.read_text(encoding="utf-8"))
        grens = f" max-width: {breedte.group(1)}px;" if breedte else ""
        return figuur(f'<img src="{doel.name}" alt="{html.escape(bijschrift, quote=True)}"'
                      f' style="width: 100%;{grens} float: none;"/>', bijschrift)

    def repo_link(m):
        pad = (memo.parent / m.group(1)).resolve().relative_to(ROOT).as_posix()
        return f"]({REPO_URL}{pad}{m.group(2) or ''})"

    def tekst(deel):
        deel = re.sub(r"^(#{2,5}) ", r"#\1 ", deel, flags=re.M)
        deel = deel.replace("> [!NOTE]\n> ", "> **Noot:** ")
        deel = re.sub(r"^!\[([^\]]*)\]\(((?!https?:)[^)\s]+\.svg)\)[ \t]*$", illustratie, deel, flags=re.M)
        deel = re.sub(r"\]\(" + re.escape(IG_URL) + r"([^)]*)\)", lambda m: f"]({m.group(1) or 'index.html'})", deel)
        deel = re.sub(r"\]\(\.\./input/pagecontent/([\w-]+)\.md\)", r"](\1.html)", deel)
        return re.sub(r"\]\((?!https?:|mailto:)([^)\s#]+\.md)(#[^)]*)?\)", repo_link, deel)

    md = re.sub(r"\A# .*\n+", "", memo.read_text(encoding="utf-8"))
    # Oneven delen zijn codeblokken: die blijven zoals ze zijn, behalve Mermaid.
    delen = re.split(r"(^```[^\n]*\n.*?^```[ \t]*\n)", md, flags=re.M | re.S)
    diagrammen = 0
    for i, deel in enumerate(delen):
        if i % 2 == 0:
            delen[i] = tekst(liquid_veilig(deel))
        elif deel.startswith("```mermaid"):
            diagrammen += 1
            plantuml, titel = mermaid_naar_plantuml(deel.split("\n", 1)[1].rsplit("```", 1)[0])
            (bronnen / f"{naam}-{diagrammen}.plantuml").write_text(plantuml, encoding="utf-8")
            include = "{% include " + f"{naam}-{diagrammen}.svg" + " %}"
            delen[i] = "{::nomarkdown}\n" + figuur(include, titel) + "\n{:/}\n"
        else:
            delen[i] = liquid_veilig(deel)

    pagina = ROOT / "input/pagecontent" / f"{naam}.md"
    herkomst = f"<!-- Gegenereerd uit {memo.relative_to(ROOT).as_posix()} door memos/export-ig.py. Bewerk de memo, niet deze pagina. -->\n\n"
    pagina.write_text(herkomst + OPMAAK + "".join(delen), encoding="utf-8")
    print(pagina)


if __name__ == "__main__":
    main()
