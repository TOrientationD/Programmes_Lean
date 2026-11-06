#!/usr/bin/env python3
"""Livret de campagne d'un programme : préambule, texte détaillé des mesures
par thématique (rubicons, paramétrables, négociables), bilan chiffré.

Lit l'export de `Rapport.lean --synthese`, la section « Grands principes »
du README du programme et son `LIVRET.md` (texte de campagne de chaque
mesure, en blocs « ### O-xx »). Le classement (statut, domaine, note) vient
des champs des mesures ; les chiffres, du modèle commun. Aucun calcul
économique ici.

Usage :
    lake build rapport && .lake/build/bin/rapport --synthese out/synthese.json
    python3 scripts/livret_pdf.py out/synthese.json TexteOrientationD out/livret.pdf

Dépendances : matplotlib, reportlab (comme scripts/synthese_pdf.py).
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from synthese_pdf import (  # noqa: E402
    A4, BASE, GRID, INK, INK2, LARGEUR, MUTED, CondPageBreak, Donnees, KeepTogether, PageBreak,
    Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle, charger_preambule, colors, echap, mm,
    style)
from programme_pdf import (  # noqa: E402
    STYLES, annee_entree, chiffres_cles, emplois, pt, section_coherence_programme, section_proprietes,
    tableau)

RACINE = Path(__file__).resolve().parent.parent

BLEU = "#1d3557"
COULEUR = {"rubicon": BLEU, "parametrable": "#1f8a7a", "negociable": "#d0603f"}
ORDRE = ("rubicon", "parametrable", "negociable")
TITRE_STATUT = {
    "rubicon": "Nos engagements · rubicons",
    "parametrable": "Les curseurs · paramétrables",
    "negociable": "Ouvert à la discussion · négociables",
}
SOUS_TITRE_STATUT = {
    "rubicon": "Non négociables : ces mesures font le programme.",
    "parametrable": "Le principe est acquis ; taux, montants et calendrier se règlent.",
    "negociable": "Les plus discutées : elles peuvent être cédées en échange d'autre chose.",
}
LIBELLE_NOTE = {"parametrable": "Ce qui se règle", "negociable": "Pourquoi c'est discuté"}

STYLES.update({
    "l_chapitre": style("l_chapitre", "Sans-Bold", 20, 24, couleur=colors.white),
    "l_chapitre_sous": style("l_chapitre_sous", "Sans", 9, 12, couleur=colors.white),
    "l_h1": style("l_h1", "Sans-Bold", 16, 20, spaceBefore=2, spaceAfter=8, couleur=BLEU),
    "l_statut": style("l_statut", "Sans-Bold", 11, 14, spaceBefore=10, spaceAfter=1),
    "l_statut_sous": style("l_statut_sous", "Sans", 7.6, 10, couleur=INK2, spaceAfter=5),
    "l_titre_mesure": style("l_titre_mesure", "Sans-Bold", 9.2, 12, spaceAfter=3),
    "l_corps": style("l_corps", "Serif", 8.6, 12.4, spaceAfter=4),
    "l_principe": style("l_principe", "Serif", 9.0, 13.4, spaceAfter=7),
    "l_meta": style("l_meta", "Sans", 6.8, 9, couleur=MUTED),
    "l_note": style("l_note", "Sans-Italic", 7.4, 9.8, couleur=INK2, spaceBefore=1),
    "l_sommaire": style("l_sommaire", "Sans", 9, 13),
})


def P(texte: str, nom: str = "corps") -> Paragraph:
    return Paragraph(texte, STYLES[nom])


def base(mid: str) -> str:
    return re.sub(r"[a-z]+$", "", mid)


def inline(t: str) -> str:
    """Markdown minimal (gras, italique, code) vers le balisage de reportlab."""
    t = echap(t)
    t = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", t)
    t = re.sub(r"(?<![*\w])\*(?!\s)(.+?)(?<!\s)\*(?![*\w])", r"<i>\1</i>", t)
    return re.sub(r"`([^`]+)`", r"\1", t)


def charger_livret(chemin: Path) -> dict[str, list[str]]:
    """Blocs « ### O-xx » de LIVRET.md → paragraphes du texte de chaque mesure."""
    textes: dict[str, list[str]] = {}
    if not chemin.is_file():
        return textes
    courant = None
    for bloc in re.split(r"\n(?=### )", chemin.read_text(encoding="utf-8")):
        m = re.match(r"### (\S+)\s*\n(.*)", bloc, re.S)
        if not m:
            continue
        courant = m.group(1)
        paras = [" ".join(x.split()) for x in m.group(2).strip().split("\n\n") if x.strip()]
        textes[courant] = paras
    return textes


# ---------------------------------------------------------------------------
# Mesures regroupées : une entrée par mesure de base (O-117 et O-117b ensemble)
# ---------------------------------------------------------------------------

def mesures_de_base(D: Donnees, p: dict) -> list[dict]:
    eff = {(e["mesure"], e["moteur"]): e for e in p["effetsMesures"]}
    entree = annee_entree(D, p)
    out: dict[str, dict] = {}
    for m in p["mesures"]:
        b = base(m["id"])
        if b not in out:
            out[b] = {"id": b, "titre": m["titre"], "statut": m.get("statut", "nonClasse"),
                      "domaine": m.get("domaine", "nonClasse"), "note": m.get("noteStatut", ""),
                      "annee": entree + m["debut"], "variantes": [], "deficitPb": 0, "emplois": 0}
        o = out[b]
        o["variantes"] += m.get("variantes", [])
        e = eff.get((m["id"], D.standard), {})
        o["deficitPb"] += e.get("deficitPb", 0)
        o["emplois"] += e.get("emplois", 0)
    return list(out.values())


# ---------------------------------------------------------------------------
# Sections
# ---------------------------------------------------------------------------

def bandeau(titre: str, sous_titre: str, couleur: str = BLEU) -> Table:
    t = Table([[P(echap(titre), "l_chapitre")], [P(sous_titre, "l_chapitre_sous")]],
              colWidths=[LARGEUR])
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor(couleur)),
        ("LEFTPADDING", (0, 0), (-1, -1), 12), ("RIGHTPADDING", (0, 0), (-1, -1), 12),
        ("TOPPADDING", (0, 0), (-1, 0), 14), ("BOTTOMPADDING", (0, -1), (-1, -1), 12),
        ("TOPPADDING", (0, 1), (-1, 1), 2)]))
    return t


def carte(m: dict, textes: dict[str, list[str]]) -> Table:
    """Une mesure : titre, texte de campagne, entrée en vigueur et effet isolé,
    note de réglage ou de discussion, variantes chiffrées."""
    contenu = [P(f"<font color='{COULEUR.get(m['statut'], BLEU)}'>{echap(m['id'])}</font>"
                 f"  {echap(m['titre'])}", "l_titre_mesure")]
    for para in textes.get(m["id"], []):
        contenu.append(P(inline(para), "l_corps"))
    if m.get("note") and m["statut"] in LIBELLE_NOTE:
        contenu.append(P(f"{LIBELLE_NOTE[m['statut']]} : {echap(m['note'])}", "l_note"))
    if m["variantes"]:
        contenu.append(P("Variantes chiffrées : " + echap(" ; ".join(m["variantes"])), "l_meta"))
    contenu.append(P(f"Entrée en vigueur {m['annee']} · effet de la mesure seule en 2035 : déficit "
                     f"{pt(m['deficitPb'])}, emplois {emplois(m['emplois'])}", "l_meta"))
    t = Table([[contenu]], colWidths=[LARGEUR])
    t.setStyle(TableStyle([
        ("LINEBEFORE", (0, 0), (0, -1), 2.4, colors.HexColor(COULEUR.get(m["statut"], BLEU))),
        ("LEFTPADDING", (0, 0), (-1, -1), 9), ("RIGHTPADDING", (0, 0), (-1, -1), 4),
        ("TOPPADDING", (0, 0), (-1, -1), 3), ("BOTTOMPADDING", (0, 0), (-1, -1), 5)]))
    return t


def section_sommaire(d: dict, ms: list[dict]) -> list:
    noms_dom = {x["id"]: x["nom"] for x in d["domaines"]}
    out = [P("Sommaire", "l_h1"),
           P("Le livret présente les mesures par thématique. Dans chaque thématique, elles sont "
             "séparées en trois groupes :", "l_principe")]
    for st in ORDRE:
        out.append(P(f"<font color='{COULEUR[st]}'><b>■ {TITRE_STATUT[st]}</b></font> — "
                     f"{SOUS_TITRE_STATUT[st]}", "l_sommaire"))
    out.append(Spacer(1, 8))
    rows = []
    for dom in [x["id"] for x in d["domaines"]]:
        c = [sum(1 for m in ms if m["domaine"] == dom and m["statut"] == s) for s in ORDRE]
        if sum(c):
            rows.append([noms_dom[dom]] + [str(x) if x else "—" for x in c] + [str(sum(c))])
    tot = [sum(1 for m in ms if m["statut"] == s) for s in ORDRE]
    rows.append(["Ensemble du programme"] + [str(x) for x in tot] + [str(len(ms))])
    out.append(tableau(["Thématique", "Rubicons", "Paramétrables", "Négociables", "Mesures"], rows,
                       [0.43, 0.13, 0.16, 0.15, 0.13], surligner=(len(rows) - 1,)))
    out.append(Spacer(1, 6))
    out.append(P("Puis le <b>bilan</b> : ce que le programme change en 2035, chiffré par le modèle "
                 "commun du dépôt (déficit, dette, chômage, emploi, PIB, émissions), thématique par "
                 "thématique, et les engagements juridiques et climatiques qu'il tient.", "l_principe"))
    return out


def section_preambule(p: dict) -> list:
    paras = charger_preambule(p["id"])
    if not paras:
        return []
    out = [P("Préambule · nos grands principes", "l_h1")]
    for x in paras:
        out.append(P(x, "l_principe"))
    return out


def section_thematique(d: dict, dom: str, ms: list[dict], textes: dict[str, list[str]]) -> list:
    noms_dom = {x["id"]: x["nom"] for x in d["domaines"]}
    ici = [m for m in ms if m["domaine"] == dom]
    if not ici:
        return []
    c = {s: sum(1 for m in ici if m["statut"] == s) for s in ORDRE}
    sous = " · ".join(f"{c[s]} {TITRE_STATUT[s].split(' · ')[1][:-1] + ('s' if c[s] > 1 else '')}"
                      for s in ORDRE if c[s])
    out = [PageBreak(), bandeau(noms_dom[dom], f"{len(ici)} mesures · {sous}"), Spacer(1, 6)]
    for st in ORDRE:
        groupe = [m for m in ici if m["statut"] == st]
        if not groupe:
            continue
        entete = [P(f"<font color='{COULEUR[st]}'>{TITRE_STATUT[st]}</font>", "l_statut"),
                  P(SOUS_TITRE_STATUT[st], "l_statut_sous")]
        out.append(KeepTogether(entete + [carte(groupe[0], textes)]))
        for m in groupe[1:]:
            out.append(Spacer(1, 4))
            out.append(carte(m, textes))
    return out


def section_bilan(D: Donnees, d: dict, p: dict, ms: list[dict]) -> list:
    a1 = D.annees[-1]
    noms_dom = {x["id"]: x["nom"] for x in d["domaines"]}
    out = [PageBreak(), bandeau("Bilan", f"Ce que le programme change d'ici {a1}, chiffré par le "
                                "modèle commun du dépôt"), Spacer(1, 8),
           P(f"Les chiffres sont ceux du modèle commun d'TOrientationD/Programmes_Lean, le même pour "
             f"tous les programmes, sous des hypothèses partagées (scénario central, moteur « "
             f"{echap(D.nom_moteur(D.standard))} »). Ils sont indicatifs ; chaque mesure cite sa "
             "source dans le programme complet.", "l_principe"),
           P(f"Chiffres clés en {a1}", "h1")]
    out += chiffres_cles(D, p)
    out.append(CondPageBreak(90 * mm))
    out.append(P("Bilan par thématique", "h1"))
    rows = []
    for dom in [x["id"] for x in d["domaines"]]:
        ici = [m for m in ms if m["domaine"] == dom]
        if ici:
            rows.append([noms_dom[dom], str(len(ici)), pt(sum(m["deficitPb"] for m in ici)),
                         emplois(sum(m["emplois"] for m in ici))])
    for st in ORDRE:
        ici = [m for m in ms if m["statut"] == st]
        rows.append([TITRE_STATUT[st].split(" · ")[1].capitalize(), str(len(ici)),
                     pt(sum(m["deficitPb"] for m in ici)), emplois(sum(m["emplois"] for m in ici))])
    out.append(tableau(["Thématique", "Mesures", f"Déficit {a1}", f"Emplois {a1}"], rows,
                       [0.52, 0.12, 0.18, 0.18], surligner=tuple(range(len(rows) - 3, len(rows)))))
    out.append(P("Somme des effets de chaque mesure prise seule, par rapport à la trajectoire sans "
                 "programme : déficit en points de PIB (négatif : le déficit baisse), emplois en "
                 "personnes. Les effets ne s'additionnent pas exactement (interactions, seuils, charge "
                 "d'intérêts) ; l'effet d'ensemble est celui du tableau des chiffres clés. Les trois "
                 "dernières lignes regroupent les mêmes mesures par statut.", "note"))
    out.append(CondPageBreak(90 * mm))
    out += section_proprietes(D, p)
    out += section_coherence_programme(p)
    return out


# ---------------------------------------------------------------------------

def construire(d: dict, pid: str, sortie: Path, commit: str | None) -> None:
    D = Donnees(d)
    p = next((x for x in d["programmes"] if x["id"] == pid), None)
    if p is None:
        raise SystemExit(f"Programme inconnu : {pid}")
    ms = mesures_de_base(D, p)
    if all(m["statut"] == "nonClasse" for m in ms):
        raise SystemExit(f"{pid} ne classe pas ses mesures (statut, domaine) : pas de livret.")
    textes = charger_livret(RACINE / "Programmes" / pid / "LIVRET.md")
    manquants = [m["id"] for m in ms if m["id"] not in textes]
    if manquants:
        print(f"Attention : {len(manquants)} mesures sans texte dans LIVRET.md : {', '.join(manquants)}",
              file=sys.stderr)
    date = dt.date.today().strftime("%d/%m/%Y")
    version = f" · version {commit[:7]}" if commit else ""
    nom = p["nom"]
    principes = [re.split(r"\s:\s|\.", re.sub(r"<[^>]+>", "", x), maxsplit=2)[1].strip()
                 for x in charger_preambule(pid) if re.match(r"<b>\d+\.", x)]

    story = [Spacer(1, 1), PageBreak()]
    story += section_sommaire(d, ms)
    story.append(PageBreak())
    story += section_preambule(p)
    for dom in [x["id"] for x in d["domaines"]]:
        story += section_thematique(d, dom, ms, textes)
    story += section_bilan(D, d, p, ms)

    def couverture(canvas, doc):
        w, h = A4
        canvas.saveState()
        canvas.setFillColor(colors.HexColor(BLEU))
        canvas.rect(0, 0, w, h, stroke=0, fill=1)
        for k, st in enumerate(ORDRE):
            canvas.setFillColor(colors.HexColor(COULEUR[st] if st != "rubicon" else "#457b9d"))
            canvas.rect(0, h * 0.36 - k * 7 * mm, w * (0.62 - 0.16 * k), 4.2 * mm, stroke=0, fill=1)
        canvas.setFillColor(colors.white)
        canvas.setFont("Sans-Bold", 34)
        canvas.drawString(20 * mm, h * 0.70, nom)
        canvas.setFont("Sans", 17)
        canvas.drawString(20 * mm, h * 0.70 - 13 * mm, "Livret des mesures")
        canvas.setFont("Sans", 10.5)
        canvas.drawString(20 * mm, h * 0.70 - 25 * mm,
                          f"{len(ms)} mesures · {len({m['domaine'] for m in ms})} thématiques · "
                          f"chiffrées de {D.annees[0]} à {D.annees[-1]}")
        y = h * 0.52
        canvas.setFont("Sans", 9.5)
        for x in principes:
            canvas.drawString(20 * mm, y, f"—  {x}")
            y -= 5.6 * mm
        canvas.setFont("Sans", 7.5)
        canvas.drawString(20 * mm, 16 * mm, f"TOrientationD/Programmes_Lean{version} · {date} · "
                          "chiffres du modèle commun, indicatifs")
        canvas.restoreState()

    def pied(canvas, doc):
        canvas.saveState()
        canvas.setFont("Sans", 6.8)
        canvas.setFillColor(colors.HexColor(MUTED))
        canvas.drawString(18 * mm, 10 * mm, f"{nom} — livret des mesures{version}")
        canvas.drawRightString(A4[0] - 18 * mm, 10 * mm, str(doc.page))
        canvas.restoreState()

    doc = SimpleDocTemplate(str(sortie), pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm,
                            topMargin=16 * mm, bottomMargin=17 * mm,
                            title=f"{nom} — livret des mesures", author="TOrientationD",
                            subject=f"Préambule, mesures par thématique et bilan, {D.annees[0]}–{D.annees[-1]}")
    doc.build(story, onFirstPage=couverture, onLaterPages=pied)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("synthese", type=Path, help="export de Rapport.lean --synthese")
    ap.add_argument("programme", help="identifiant du programme (ex. TexteOrientationD)")
    ap.add_argument("sortie", type=Path)
    ap.add_argument("--commit", default=None)
    a = ap.parse_args()
    construire(json.loads(a.synthese.read_text(encoding="utf-8")), a.programme, a.sortie, a.commit)
    print(f"Livret PDF écrit : {a.sortie}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
