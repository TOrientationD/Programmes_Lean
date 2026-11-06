#!/usr/bin/env python3
"""Programme complet en PDF : un programme du dépôt, toutes ses mesures.

Lit l'export de `Rapport.lean --synthese` et le README du programme, et
produit un PDF : chiffres clés et trajectoires (scénario central),
propriétés vérifiées, points à arbitrer et pistes (sections du README de
ces noms, s'il y en a), catalogue de toutes les mesures avec leur source et
leur effet isolé (déficit, chômage, emplois, IDH), variantes évaluées, puis
le reste du README (justification des chiffrages, sources, mécanismes).

Aucun calcul économique ici : le script met en forme des chiffres produits
par le modèle commun.

Usage :
    lake env lean --run Rapport.lean --synthese out/synthese.json
    python3 scripts/programme_pdf.py out/synthese.json TexteOrientationD out/programme.pdf

Dépendances : matplotlib, reportlab (comme scripts/synthese_pdf.py, dont la
charte et les fonctions de mise en page sont reprises).
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from synthese_pdf import (  # noqa: E402
    A4, BASE, FOND, GRID, INK, INK2, LARGEUR, MUTED, NBSP, STYLES, TENDANCIEL,
    CondPageBreak, Donnees, PageBreak, Paragraph, SimpleDocTemplate, Spacer, Table,
    TableStyle, colorer_parts, colors, echap, figure, legende_degrade, mm, nombre, png, score, style,
    INTRO_COHERENCE, coherence_paragraphes, section_glossaire)
from reportlab.pdfbase.pdfmetrics import stringWidth  # noqa: E402

VERT, ROUGE = "#008300", "#c62f2e"

STYLES.update({
    "h3": style("h3", "Sans-Bold", 8.8, 12, spaceBefore=6, spaceAfter=3, couleur=INK2),
    "chapitre": style("chapitre", "Sans-Bold", 17, 21, spaceBefore=0, spaceAfter=8),
    "mesure": style("mesure", taille=7.2, interligne=9.2),
    "groupe": style("groupe", "Sans-Bold", 8.6, 11),
    "cellc": style("cellc", taille=7.2, interligne=9.0, alignment=1),
    "cellgc": style("cellgc", "Sans-Bold", 7.2, 9.0, couleur=INK2, alignment=1),
    "num": style("num", taille=8.6, interligne=12, leftIndent=14, spaceAfter=3),
    "souspuce": style("souspuce", taille=8.2, interligne=11.4, leftIndent=22, spaceAfter=2),
})

# Sections du README placées en tête (après les propriétés) plutôt qu'avec
# les explications : ce qu'il reste à décider et à compléter.
SECTIONS_EN_TETE = ("Points à arbitrer", "Pistes pour compléter")


def P(texte: str, nom: str = "corps") -> Paragraph:
    return Paragraph(texte, STYLES[nom])


# ---------------------------------------------------------------------------
# Formats
# ---------------------------------------------------------------------------

def pt(pb: int) -> str:
    """Écart en points de pourcentage, deux décimales (pb → pt)."""
    if pb == 0:
        return "0"
    return ("+" if pb > 0 else "−") + nombre(abs(pb) / 100, 2) + NBSP + "pt"


def pct(pb: int, dec: int = 2) -> str:
    return nombre(pb / 100, dec) + NBSP + "%"


def emplois(n: int) -> str:
    r = int(round(n / 100.0)) * 100
    if r == 0:
        return "≈ 0"
    return ("+" if r > 0 else "−") + nombre(abs(r))


def idh_ecart(m: int) -> str:
    """Écart d'IDH en dix-millièmes (millionièmes / 100)."""
    v = round(m / 100)
    if v == 0:
        return "≈ 0"
    return ("+" if v > 0 else "−") + nombre(abs(v))


def signe(v: float, dec: int) -> str:
    return ("+" if v > 0 else "−" if v < 0 else "") + nombre(abs(v), dec)


def inline(t: str) -> str:
    """Markdown en ligne → balises reportlab (après échappement)."""
    t = echap(t)
    t = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<link href="\2" color="#2a78d6">\1</link>', t)
    t = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", t)
    t = re.sub(r"(?<![\w*])\*(?!\s)(.+?)(?<!\s)\*(?![\w*])", r"<i>\1</i>", t)
    t = re.sub(r"`([^`]+)`", r'<font color="#52514e">\1</font>', t)
    return t


def brut(t: str) -> str:
    """Texte sans balisage Markdown (pour mesurer les largeurs)."""
    t = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", t)
    return t.replace("**", "").replace("`", "").replace("*", "")


def tableau(entetes, lignes, largeurs, styles_cols=None, surligner=()) -> Table:
    """Tableau sobre (charte de la synthèse). `styles_cols` : style des
    cellules par colonne ('cell', 'celld', 'cellc') ; `surligner` : indices
    des lignes de données sur fond clair."""
    styles_cols = styles_cols or ["cell"] + ["celld"] * (len(entetes) - 1)
    entete = {"cell": "cellg", "celld": "cellgd", "cellc": "cellgc"}

    def cellule(c, j, en_tete):
        if isinstance(c, Paragraph):
            return c
        return P(str(c), entete[styles_cols[j]] if en_tete else styles_cols[j])

    data = [[cellule(inline(h), j, True) for j, h in enumerate(entetes)]]
    data += [[cellule(c, j, False) for j, c in enumerate(ln)] for ln in lignes]
    t = Table(data, colWidths=[w * LARGEUR for w in largeurs], repeatRows=1)
    st = [("VALIGN", (0, 0), (-1, -1), "TOP"),
          ("VALIGN", (0, 0), (-1, 0), "BOTTOM"),
          ("LINEBELOW", (0, 0), (-1, 0), 0.7, colors.HexColor(BASE)),
          ("LINEBELOW", (0, 1), (-1, -1), 0.3, colors.HexColor(GRID)),
          ("TOPPADDING", (0, 0), (-1, -1), 2.4), ("BOTTOMPADDING", (0, 0), (-1, -1), 2.4),
          ("LEFTPADDING", (0, 0), (-1, -1), 3), ("RIGHTPADDING", (0, 0), (-1, -1), 3)]
    for i in surligner:
        st.append(("BACKGROUND", (0, i + 1), (-1, i + 1), colors.HexColor(FOND)))
    t.setStyle(TableStyle(st))
    return t


# ---------------------------------------------------------------------------
# Markdown (README) → éléments reportlab
# ---------------------------------------------------------------------------

def largeurs_auto(entetes: list[str], lignes: list[list[str]]) -> list[float]:
    """Largeurs de colonnes : chaque colonne au moins aussi large que son mot
    le plus long (pas de coupure dans un nombre), le reste réparti selon la
    longueur des contenus."""
    n = len(entetes)
    pad = 7.0
    mini, nat = [], []
    for j in range(n):
        cel = [(entetes[j], "Sans-Bold")] + [(l[j] if j < len(l) else "", "Sans") for l in lignes]
        # une cellule numérique (« +0,01 pt ») ne se coupe pas
        mots = [stringWidth(m, police, 7.2) for c, police in cel
                for m in ([brut(c)] if numerique(c) else brut(c).split())] or [10.0]
        mini.append(max(mots) + pad)
        nat.append(max(stringWidth(brut(c), police, 7.2) for c, police in cel) + pad)
    if sum(nat) <= LARGEUR:
        w = [x * LARGEUR / sum(nat) for x in nat]
    elif sum(mini) >= LARGEUR:
        w = [x * LARGEUR / sum(mini) for x in mini]
    else:
        reste = LARGEUR - sum(mini)
        besoin = [max(a - b, 0.0) for a, b in zip(nat, mini)]
        tot = sum(besoin) or 1.0
        w = [m + reste * b / tot for m, b in zip(mini, besoin)]
    return [x / LARGEUR for x in w]


_NUM = r"[\s≈+−\-–0-9,.% ptMd€k/×]*"


def numerique(c: str) -> bool:
    return bool(re.fullmatch(_NUM + r"\d" + _NUM, brut(c)))


def markdown(texte: str, niveau_min: int = 2, style_min: str = "h1") -> list:
    """Convertit le Markdown du README : titres, paragraphes, listes à puces
    (deux niveaux) et numérotées, tableaux, gras, italique, code, liens."""
    out: list = []
    lignes = texte.split("\n")
    i = 0
    para: list[str] = []

    def vider():
        if para:
            out.append(P(inline(" ".join(s.strip() for s in para))))
            para.clear()

    while i < len(lignes):
        l = lignes[i]
        s = l.strip()
        if not s:
            vider()
            i += 1
            continue
        if s.startswith("```"):
            vider()
            i += 1
            bloc = []
            while i < len(lignes) and not lignes[i].strip().startswith("```"):
                bloc.append(echap(lignes[i]))
                i += 1
            i += 1
            out.append(P("<br/>".join(bloc), "note"))
            continue
        m = re.match(r"^(#{1,6})\s+(.*)$", s)
        if m:
            vider()
            n = len(m.group(1))
            nom = style_min if n <= niveau_min else "h2" if n == niveau_min + 1 else "h3"
            out.append(CondPageBreak(30 * mm))
            out.append(P(inline(m.group(2)), nom))
            i += 1
            continue
        if s.startswith("|"):
            vider()
            bloc = []
            while i < len(lignes) and lignes[i].strip().startswith("|"):
                bloc.append(lignes[i].strip())
                i += 1
            cellules = [[c.strip() for c in b.strip("|").split("|")] for b in bloc]
            cellules = [c for c in cellules if not all(re.fullmatch(r":?-{2,}:?", x or "--") for x in c)]
            if not cellules:
                continue
            ent, rows = cellules[0], cellules[1:]
            n = len(ent)
            rows = [(r + [""] * n)[:n] for r in rows]
            larg = largeurs_auto(ent, rows)
            # colonnes numériques (toutes les cellules) alignées à droite
            cols = ["celld" if j > 0 and rows and all(numerique(r[j]) or not r[j] for r in rows)
                    else "cell" for j in range(n)]
            out.append(tableau(ent, [[P(inline(c.replace(" ", NBSP) if numerique(c) else c), cols[j])
                                      for j, c in enumerate(r)] for r in rows], larg, cols))
            out.append(Spacer(1, 6))
            continue
        m = re.match(r"^(\s*)([*-]|\d+\.)\s+(.*)$", l)
        if m:
            vider()
            retrait = len(m.group(1).expandtabs(2))
            marque = m.group(2)
            item = [m.group(3)]
            i += 1
            # lignes de continuation : indentées au-delà de la marque
            while i < len(lignes) and lignes[i].strip() and not re.match(r"^\s*([*-]|\d+\.)\s+", lignes[i]) \
                    and not lignes[i].strip().startswith("|") \
                    and len(lignes[i]) - len(lignes[i].lstrip()) > retrait:
                item.append(lignes[i].strip())
                i += 1
            if marque[-1] == ".":
                out.append(Paragraph(inline(" ".join(item)), STYLES["num"], bulletText=marque))
            else:
                out.append(Paragraph(inline(" ".join(item)), STYLES["puce" if retrait < 2 else "souspuce"],
                                     bulletText="•" if retrait < 2 else "–"))
            continue
        para.append(s)
        i += 1
    vider()
    return out


def sections_readme(readme: str) -> tuple[str, list[tuple[str, str]]]:
    """Découpe le README en (préambule, [(titre de niveau 2, texte)])."""
    preambule: list[str] = []
    sections: list[tuple[str, list[str]]] = []
    for l in readme.split("\n"):
        m = re.match(r"^##\s+(.*)$", l)
        if m:
            sections.append((m.group(1).strip(), [l]))
        elif not sections:
            preambule.append(l)
        else:
            sections[-1][1].append(l)
    return "\n".join(preambule), [(t, "\n".join(ls)) for t, ls in sections]


# ---------------------------------------------------------------------------
# Regroupement des mesures selon les titres du README
# ---------------------------------------------------------------------------

def numero(mid: str) -> int:
    m = re.search(r"(\d+)", mid)
    return int(m.group(1)) if m else 0


def groupes_readme(readme: str, ids: list[str]) -> list[tuple[str, list[str]]]:
    """Titres « ### O-xx … » du README → groupes de mesures : chaque mesure va
    au titre de plus grand numéro qui ne la dépasse pas (O-15b avec O-15)."""
    m0 = re.match(r"^([A-Za-z]+-)", ids[0]) if ids else None
    if not m0:
        return [("Mesures", ids)]
    prefixe = m0.group(1)
    titres = []
    for l in readme.split("\n"):
        m = re.match(r"^#{2,4}\s+(" + re.escape(prefixe) + r"(\d+).*)$", l.strip())
        if m:
            titres.append((int(m.group(2)), m.group(1)))
    if not titres:
        return [("Mesures", ids)]
    titres.sort(key=lambda x: x[0])
    groupes: dict[str, list[str]] = {t: [] for _, t in titres}
    for mid in ids:
        k = numero(mid)
        choix = titres[0][1]
        for n, t in titres:
            if n <= k:
                choix = t
        groupes[choix].append(mid)
    return [(t, groupes[t]) for _, t in titres if groupes[t]]


# ---------------------------------------------------------------------------
# Sections
# ---------------------------------------------------------------------------

def courbes_programme(D: Donnees, pid: str):
    """Quatre petits graphes : déficit, dette, chômage, IDH ; programme et
    tendanciel, scénario central, moteur standard."""
    fig, axes = figure(4.0, 2, 2)
    x = D.annees
    couleur = D.couleur[pid]
    specs = [("Déficit public (% du PIB)", lambda e: e["deficitPb"] / 100, 1, " %"),
             ("Dette publique (% du PIB)", lambda e: e["dettePb"] / 100, 0, " %"),
             ("Chômage (%)", lambda e: e["chomagePb"] / 100, 1, " %"),
             ("Indice de développement humain", lambda e: e["idhMillioniemes"] / 1e6, 3, "")]
    for k, (ax, (titre, f, dec, suf)) in enumerate(zip(axes.flat, specs)):
        yt = [f(e) for e in D.traj("central", None)]
        yp = [f(e) for e in D.traj("central", pid)]
        ax.plot(x, yt, color=TENDANCIEL, lw=1.2, ls="--", label="Sans programme")
        ax.plot(x, yp, color=couleur, lw=1.8, label="Programme")
        ax.plot([x[-1]], [yp[-1]], "o", ms=4, color=couleur, mec="white", mew=0.8)
        ax.plot([x[-1]], [yt[-1]], "o", ms=3.5, color=TENDANCIEL, mec="white", mew=0.8)
        haut = yp[-1] >= yt[-1]
        for y, c, dy in ((yp[-1], INK, 4 if haut else -4), (yt[-1], MUTED, -4 if haut else 4)):
            ax.annotate(nombre(y, dec) + suf, (x[-1], y), xytext=(5, dy), textcoords="offset points",
                        fontsize=6.5, color=c, va="center")
        ax.set_title(titre)
        ax.set_xlim(x[0], x[-1] + 2.2)
        ax.set_xticks([x[0], x[0] + 2, x[0] + 5, x[-1]])
        if k == 1:
            ax.legend(loc="lower right", fontsize=6.5)
    return png(fig)


def annee_entree(D: Donnees, p: dict) -> int:
    """Année d'entrée en vigueur du programme : exportée par Rapport.lean,
    sinon première année où la trajectoire quitte le tendanciel."""
    if "entreeEnVigueur" in p:
        return D.annees[0] + p["entreeEnVigueur"]
    t, s = D.traj("central", None), D.traj("central", p["id"])
    for a, x, y in zip(D.annees, t, s):
        if x["deficitPb"] != y["deficitPb"] or x["emploiTotal"] != y["emploiTotal"]:
            return a
    return D.annees[0]


def section_cle(D: Donnees, p: dict, meta: dict) -> list:
    a1 = D.annees[-1]
    # Une mesure en plusieurs étapes (O-117 et O-117b) compte une fois, comme
    # dans le classement et le livret ; les lignes du programme sont précisées.
    nb = len({re.sub(r"[a-z]+$", "", m["id"]) for m in p["mesures"]})
    lignes = f" ({p['nbMesures']} lignes avec leurs étapes)" if nb != p["nbMesures"] else ""
    out = [P(echap(p["nom"]), "titre"),
           P(f"Programme complet · {nb} mesures{lignes} chiffrées et évaluées par le modèle commun "
             f"du dépôt TOrientationD/Programmes_Lean · projection {D.annees[0]}–{a1} · "
             f"{meta['date']}{meta['commit']}", "soustitre"),
           P("Chiffres du <b>modèle commun</b> du dépôt, sous des hypothèses partagées par tous les "
             "programmes : scénario central, moteur « " + echap(D.nom_moteur(D.standard)) + " » sauf "
             "mention contraire. Ils sont indicatifs. Chaque mesure cite sa source et son chiffrage ; "
             "les valeurs marquées « hypothèse » restent à sourcer ou à arbitrer.", "note"),
           P(f"Chiffres clés en {a1}", "h1")]
    return out + chiffres_cles(D, p)


def chiffres_cles(D: Donnees, p: dict) -> list:
    """Tableau des chiffres clés à l'horizon, courbes et déficit par moteur
    (scénario central) ; repris par le livret (scripts/livret_pdf.py)."""
    pid = p["id"]
    a1 = D.annees[-1]
    t = D.fin("central", None)
    s = D.fin("central", pid)
    out = []
    pib = (s["pib"] - t["pib"]) * 10000 / t["pib"]
    lignes = [
        ["Déficit public (% du PIB)", pct(t["deficitPb"]), pct(s["deficitPb"]), pt(s["deficitPb"] - t["deficitPb"])],
        ["Dette publique (% du PIB)", pct(t["dettePb"], 1), pct(s["dettePb"], 1), pt(s["dettePb"] - t["dettePb"])],
        ["Chômage (%)", pct(t["chomagePb"]), pct(s["chomagePb"]), pt(s["chomagePb"] - t["chomagePb"])],
        ["Emploi (millions)", nombre(t["emploiTotal"] / 1e6, 2), nombre(s["emploiTotal"] / 1e6, 2),
         emplois(s["emploiTotal"] - t["emploiTotal"])],
        ["PIB (Md€ courants)", nombre(t["pib"] / 1000), nombre(s["pib"] / 1000),
         signe(pib / 100, 2) + NBSP + "%"],
        ["Indice de développement humain", nombre(t["idhMillioniemes"] / 1e6, 4),
         nombre(s["idhMillioniemes"] / 1e6, 4), signe((s["idhMillioniemes"] - t["idhMillioniemes"]) / 1e6, 4)],
        ["Émissions (Mt CO₂e)", nombre(t["emissionsMt"]), nombre(s["emissionsMt"]),
         signe(s["emissionsMt"] - t["emissionsMt"], 0)],
    ]
    if "productionGwh" in s and "surfacesHa" in s:
        def gw(e, cle):
            return (sum(e[cle].values()) if isinstance(e[cle], dict) else e[cle]) / 8760

        def enaf(q):
            tr = D.traj("central", q)
            return sum(tr[-1]["surfacesHa"][x] - tr[0]["surfacesHa"][x] for x in tr[0]["surfacesHa"] if x != "energie")

        def energie(q):
            tr = D.traj("central", q)
            return tr[-1]["surfacesHa"]["energie"] - tr[0]["surfacesHa"]["energie"]
        lignes += [
            ["Électricité produite (GW moyens)", nombre(gw(t, "productionGwh"), 1), nombre(gw(s, "productionGwh"), 1),
             signe(gw(s, "productionGwh") - gw(t, "productionGwh"), 1)],
            ["Électricité consommée (GW moyens)", nombre(gw(t, "consommationGwh"), 1),
             nombre(gw(s, "consommationGwh"), 1), signe(gw(s, "consommationGwh") - gw(t, "consommationGwh"), 1)],
            [f"Espaces consommés {D.annees[0] + 1}-{a1} (ha" + NBSP + "; ZAN" + (" abrogé" if s.get("ecartZanPm", 0) >= 1000 else "") + ")",
             nombre(enaf(None)), nombre(enaf(pid)), signe(enaf(pid) - enaf(None), 0)],
            [f"Emprise énergétique {D.annees[0] + 1}-{a1} (ha)", nombre(energie(None)), nombre(energie(pid)),
             signe(energie(pid) - energie(None), 0)],
        ]
    out.append(tableau(["Scénario central", "Sans programme", "Programme", "Écart"], lignes,
                       [0.43, 0.19, 0.19, 0.19]))
    out.append(Spacer(1, 8))
    out.append(courbes_programme(D, pid))
    ans = D.annees[1:]
    rows = []
    for m in D.moteurs:
        tr = D.traj("central", pid, m["id"])[1:]
        rows.append([m["nom"]] + [nombre(e["deficitPb"] / 100, 2) for e in tr])
    rows.append(["Sans programme"] + [nombre(e["deficitPb"] / 100, 2) for e in D.traj("central", None)[1:]])
    out.append(Spacer(1, 6))
    out.append(tableau(["Déficit (% du PIB)"] + [str(a) for a in ans], rows,
                       [0.19] + [0.81 / len(ans)] * len(ans)))
    out.append(P("Déficit public selon le moteur macroéconomique (scénario central). Les trois moteurs "
                 "partagent les hypothèses ; ils diffèrent par la réponse de l'activité aux mesures.", "note"))
    return out


def section_proprietes(D: Donnees, p: dict) -> list:
    n = D.d["nbScenarios"]
    std = D.standard
    out = [P("Propriétés vérifiées", "h1"),
           P(f"Chaque propriété est décidée par le noyau Lean pour le programme, sous chaque moteur et "
             f"dans chacun des {n} scénarios. Pour chaque moteur : statut au scénario central "
             f"(<font color='{VERT}'>✓</font> tenue, <font color='{ROUGE}'>✗</font> non tenue) et nombre "
             f"de scénarios où elle tient. Classement selon le moteur « {echap(D.nom_moteur(std))} ».")]
    cases = n * len(D.props)
    tous = D.d["programmes"]
    lignes_score = []
    for m in D.moteurs:
        k = score(p, m["id"])
        rang = 1 + sum(1 for x in tous if score(x, m["id"]) > k)
        lignes_score.append(f"{echap(m['nom'])} : {k}/{cases} ({nombre(100 * k / cases)} %), "
                            f"rang {rang} sur {len(tous)}")
    out.append(P("<b>Score global</b> (somme, sur les " f"{len(D.props)} propriétés, du nombre de "
                 "scénarios où chacune tient) — " + " ; ".join(lignes_score) + ".", "corps"))
    tenues = [q for q in D.props if p["central"][std][q["id"]]]
    non = [q for q in D.props if not p["central"][std][q["id"]]]
    for titre, qs in ((f"Tenues au scénario central ({len(tenues)})", tenues),
                      (f"Non tenues au scénario central ({len(non)})", non)):
        if not qs:
            continue
        rows = []
        for q in qs:
            cel = []
            for m in D.moteurs:
                ok = p["central"][m["id"]][q["id"]]
                nb = p["matrice"][m["id"]][q["id"]]
                cel.append(P(f"<font color='{VERT if ok else ROUGE}'>{'✓' if ok else '✗'}</font>"
                             f"{NBSP}{NBSP}{nb}/{n}", "cellc"))
            rows.append([P(f"<b>{echap(q['titre'])}</b> — <font color='{INK2}'>{echap(q['description'])}"
                           f"</font>", "cell")] + cel)
        out.append(CondPageBreak(30 * mm))
        out.append(P(titre, "h2"))
        t = tableau(["Propriété"] + [m["nom"] for m in D.moteurs], rows,
                    [0.67] + [0.33 / len(D.moteurs)] * len(D.moteurs),
                    ["cell"] + ["cellc"] * len(D.moteurs))
        out.append(colorer_parts(t, {(j + 1, i + 1): p["matrice"][m["id"]][q["id"]] / n
                                     for i, q in enumerate(qs) for j, m in enumerate(D.moteurs)}))
    out.append(Spacer(1, 3))
    out.append(legende_degrade(n))
    return out


def section_coherence_programme(p: dict) -> list:
    """Cohérence interne : paires de mesures contradictoires (Modele/Coherence.lean)."""
    corps = coherence_paragraphes(p)
    if not corps:
        return []
    return [CondPageBreak(40 * mm), P("Cohérence interne", "h2"), P(INTRO_COHERENCE, "note")] + corps


STATUTS_ORDRE = ("rubicon", "parametrable", "negociable")
LIBELLE_NOTE = {"parametrable": "Réglage", "negociable": "Discutée"}


def classee(p: dict) -> bool:
    """Le programme classe-t-il ses mesures (statut et domaine) ?"""
    return any(m.get("statut", "nonClasse") != "nonClasse" for m in p["mesures"])


def groupes_classement(d: dict, p: dict) -> list[tuple[str, str, list[str]]]:
    """(statut, domaine, mesures) dans l'ordre des statuts puis des domaines du
    modèle commun (`Statut.tous`, `Domaine.tous`)."""
    ordre_dom = [x["id"] for x in d.get("domaines", [])]
    out = []
    for st in STATUTS_ORDRE + ("nonClasse",):
        ms = [m for m in p["mesures"] if m.get("statut", "nonClasse") == st]
        for dom in ordre_dom:
            ids = [m["id"] for m in ms if m.get("domaine", "nonClasse") == dom]
            if ids:
                out.append((st, dom, ids))
    return out


def section_classement(d: dict, p: dict) -> list:
    """Tableau de synthèse : nombre de mesures par domaine et par statut, puis
    la liste des mesures négociables et paramétrables avec leur note."""
    if not classee(p):
        return []
    noms_st = {x["id"]: x["nom"] for x in d.get("statuts", [])}
    noms_dom = {x["id"]: x["nom"] for x in d.get("domaines", [])}
    bases = [m for m in p["mesures"] if not re.search(r"[a-z]$", m["id"])]
    n = {st: sum(1 for m in bases if m["statut"] == st) for st in STATUTS_ORDRE}
    out = [P("Rubicons, paramétrables, négociables", "chapitre"),
           P(f"Classement de l'auteur, pour une négociation : <b>{n['rubicon']} rubicons</b> (non "
             f"négociables), <b>{n['parametrable']} paramétrables</b> (principe acquis, paramètres à "
             f"régler : taux, montant, calendrier) et <b>{n['negociable']} négociables</b> (cessibles "
             f"en échange d'autre chose), sur {len(bases)} mesures (les étapes d'une même mesure, "
             "O-117 et O-117b, comptent une fois). Le classement ne change rien aux chiffres.")]
    ent = ["Domaine"] + [noms_st[s].split(" (")[0] for s in STATUTS_ORDRE] + ["Total"]
    rows = []
    for dom in [x["id"] for x in d.get("domaines", [])]:
        c = [sum(1 for m in bases if m["domaine"] == dom and m["statut"] == s) for s in STATUTS_ORDRE]
        if sum(c):
            rows.append([noms_dom[dom]] + [str(x) if x else "—" for x in c] + [str(sum(c))])
    rows.append(["Total"] + [str(n[s]) for s in STATUTS_ORDRE] + [str(len(bases))])
    out.append(tableau(ent, rows, [0.44, 0.14, 0.14, 0.14, 0.14],
                       ["cell", "celld", "celld", "celld", "celld"], surligner=(len(rows) - 1,)))
    for st in ("negociable", "parametrable"):
        out.append(P(noms_st[st], "h2" if "h2" in STYLES else "h3"))
        for dom in [x["id"] for x in d.get("domaines", [])]:
            ms = [m for m in bases if m["statut"] == st and m["domaine"] == dom]
            if not ms:
                continue
            out.append(P(echap(noms_dom[dom]), "h3"))
            for m in ms:
                out.append(P(f"<b>{echap(m['id'])}</b> {echap(m['titre'])}"
                             + (f" — <i>{LIBELLE_NOTE[st].lower()} : {echap(m['noteStatut'])}</i>"
                                if m.get("noteStatut") else ""), "num"))
    return out


def section_mesures(D: Donnees, p: dict, readme: str) -> list:
    std = D.standard
    eff = {(e["mesure"], e["moteur"]): e for e in p["effetsMesures"]}
    mesures = {m["id"]: m for m in p["mesures"]}
    entree = annee_entree(D, p)
    out = [P("Les mesures", "chapitre"),
           P(f"Effet de chaque mesure <b>prise seule</b> (avec ses lignes liées : O-150 et O-150b…) en {D.annees[-1]}, par rapport au tendanciel "
             f"(scénario central, moteur « {echap(D.nom_moteur(std))} ») : déficit et chômage en points, "
             "emplois en personnes, IDH en dix-millièmes. Les effets ne s'additionnent pas exactement "
             "(interactions, seuils, charge d'intérêts). « Entrée » : année d'entrée en vigueur et, pour "
             "les mesures répétées, nombre d'années d'application. Sous chaque titre : source et "
             "chiffrage, puis les variantes évaluées.", "note")]
    largeurs = [0.55, 0.07, 0.09, 0.095, 0.11, 0.085]
    cols = ["cell", "cellc", "celld", "celld", "celld", "celld"]
    entete = ["Mesure, chiffrage et source", "Entrée", "Déficit", "Chômage", "Emplois", "IDH"]
    entete_cel = [P(h, {"cell": "cellg", "celld": "cellgd", "cellc": "cellgc"}[c])
                  for h, c in zip(entete, cols)]
    if classee(p):
        noms_st = {x["id"]: x["nom"] for x in D.d.get("statuts", [])}
        noms_dom = {x["id"]: x["nom"] for x in D.d.get("domaines", [])}
        groupes = [(f"{noms_st[st]} · {noms_dom[dom]}", ids) for st, dom, ids in groupes_classement(D.d, p)]
    else:
        groupes = groupes_readme(readme, [m["id"] for m in p["mesures"]])
    for titre, ids in groupes:
        rows = [[P(inline(titre), "groupe")] + [""] * 5, entete_cel]
        for mid in ids:
            m = mesures[mid]
            e = eff.get((mid, std), {})
            an = str(entree + m["debut"])
            if m["repetitions"] > 1:
                an += f"<br/>×{m['repetitions']}"
            txt = (f"<b>{echap(mid)}</b> {echap(m['titre'])}<br/>"
                   f"<font size=6.4 color='{INK2}'>{inline(m.get('source', ''))}</font>")
            if m.get("noteStatut") and m.get("statut") in LIBELLE_NOTE:
                txt += (f"<br/><font size=6.4 color='{INK2}'><i>{LIBELLE_NOTE[m['statut']]} : "
                        f"{echap(m['noteStatut'])}</i></font>")
            if m.get("variantes"):
                txt += (f"<br/><font size=6.4 color='{MUTED}'>Variantes : "
                        + echap(" ; ".join(m["variantes"])) + "</font>")
            liees = [x for x in e.get("lignes", []) if x != mid]
            if liees:
                txt += (f"<br/><font size=6.4 color='{MUTED}'>Effet compté avec "
                        + echap(", ".join(liees)) + "</font>")
            if e.get("compteAvec"):
                valeurs = [f"avec {e['compteAvec']}", "", "", ""]
            else:
                valeurs = [pt(e.get("deficitPb", 0)), pt(e.get("chomagePb", 0)),
                           emplois(e.get("emplois", 0)), idh_ecart(e.get("idhMillioniemes", 0))]
            rows.append([P(txt, "mesure"), P(an, "cellc")] + [P(echap(v), "celld") for v in valeurs])
        t = Table(rows, colWidths=[w * LARGEUR for w in largeurs], repeatRows=2)
        t.setStyle(TableStyle([
            ("SPAN", (0, 0), (-1, 0)),
            ("VALIGN", (0, 0), (-1, -1), "TOP"),
            ("VALIGN", (0, 1), (-1, 1), "BOTTOM"),
            ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor(FOND)),
            ("LINEBELOW", (0, 1), (-1, 1), 0.7, colors.HexColor(BASE)),
            ("LINEBELOW", (0, 2), (-1, -1), 0.3, colors.HexColor(GRID)),
            ("TOPPADDING", (0, 0), (-1, -1), 2.4), ("BOTTOMPADDING", (0, 0), (-1, -1), 2.4),
            ("TOPPADDING", (0, 0), (-1, 0), 4), ("BOTTOMPADDING", (0, 0), (-1, 0), 4),
            ("LEFTPADDING", (0, 0), (-1, -1), 3), ("RIGHTPADDING", (0, 0), (-1, -1), 3)]))
        out.append(CondPageBreak(32 * mm))
        out.append(t)
        out.append(Spacer(1, 7))
    return out


def section_variantes(D: Donnees, p: dict) -> list:
    v = p.get("effetsVariantes", [])
    if not v:
        return []
    rows = [[x["mesure"], P(echap(x["variante"]), "cell"), pct(x["deficitPb"]), pt(x["ecartDeficitPb"]),
             pct(x["chomagePb"]), emplois(x.get("ecartEmplois", 0)),
             nombre(x["idhMillioniemes"] / 1e6, 4) if "idhMillioniemes" in x else "—"]
            for x in v]
    return [P("Variantes évaluées", "h1"),
            P(f"Chaque variante remplace la mesure retenue, toutes choses égales par ailleurs : résultats "
              f"du programme complet en {D.annees[-1]} (scénario central, moteur standard) et écarts au "
              "programme retenu."),
            tableau(["Mesure", "Variante", "Déficit", "Écart", "Chômage", "Écart emplois", "IDH"], rows,
                    [0.085, 0.415, 0.09, 0.1, 0.09, 0.12, 0.1],
                    ["cell", "cell", "celld", "celld", "celld", "celld", "celld"])]


def construire(d: dict, pid: str, readme_path: Path, sortie: Path, commit: str | None) -> None:
    D = Donnees(d)
    p = next((x for x in d["programmes"] if x["id"] == pid), None)
    if p is None:
        raise SystemExit(f"Programme inconnu : {pid} (connus : {', '.join(x['id'] for x in d['programmes'])})")
    readme = readme_path.read_text(encoding="utf-8") if readme_path.exists() else ""
    meta = {"date": dt.date.today().strftime("%d/%m/%Y"),
            "commit": f" · version {commit[:7]}" if commit else ""}
    _, sections = sections_readme(readme)
    en_tete = [(t, x) for t, x in sections if t in SECTIONS_EN_TETE]
    # le classement des mesures et la cohérence interne sont mis en page à
    # part (section_classement, section_coherence_programme)
    reste = [(t, x) for t, x in sections if t not in SECTIONS_EN_TETE
             and not (classee(p) and t == "Rubicons, paramétrables, négociables")
             and not ("coherence" in p and t == "Cohérence interne")]

    story = section_cle(D, p, meta)
    story.append(PageBreak())
    story.append(P("Le programme en bref", "h1"))
    story.append(P(inline(p["description"])))
    story += section_proprietes(D, p)
    story += section_coherence_programme(p)
    for k, (_, x) in enumerate(en_tete):
        story.append(PageBreak() if k == 0 else CondPageBreak(90 * mm))
        story += markdown(x, style_min="chapitre")
    classement = section_classement(d, p)
    if classement:
        story.append(PageBreak())
        story += classement
    story.append(PageBreak())
    story += section_mesures(D, p, readme)
    story.append(CondPageBreak(60 * mm))
    story += section_variantes(D, p)
    if reste:
        story.append(PageBreak())
        story.append(P("Explications et sources", "chapitre"))
        story.append(P("Texte du README du programme dans le dépôt : justification des chiffrages, sources, "
                       "mécanismes du modèle commun. Les chiffres cités dans une section décrivent en général "
                       "l'effet de l'étape correspondante au moment de son ajout ; les chiffres à jour sont "
                       "ceux des pages précédentes.", "note"))
        for _, x in reste:
            story += markdown(x)
    story.append(PageBreak())
    story += section_glossaire("Annexe — Concepts et définitions Lean")

    nom = p["nom"]

    # pied de page : le nom du programme, raccourci si besoin pour laisser
    # la place au numéro de page
    dispo = A4[0] - 36 * mm - 20
    pied_txt = ""
    for txt in (f"{nom} — programme complet · TOrientationD/Programmes_Lean{meta['commit']} · "
                "modèle commun, chiffres indicatifs",
                f"{nom} — programme complet · TOrientationD/Programmes_Lean{meta['commit']}"):
        if stringWidth(txt, "Sans", 6.8) <= dispo:
            pied_txt = txt
            break
    if not pied_txt:
        court = nom
        while court and stringWidth(f"{court}… — programme complet", "Sans", 6.8) > dispo:
            court = court[:-1]
        pied_txt = f"{court.rstrip()}… — programme complet"

    def pied(canvas, doc):
        canvas.saveState()
        canvas.setFont("Sans", 6.8)
        canvas.setFillColor(colors.HexColor(MUTED))
        canvas.drawString(18 * mm, 10 * mm, pied_txt)
        canvas.drawRightString(A4[0] - 18 * mm, 10 * mm, str(doc.page))
        canvas.restoreState()

    doc = SimpleDocTemplate(str(sortie), pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm,
                            topMargin=16 * mm, bottomMargin=17 * mm,
                            title=f"{nom} — programme complet", author="TOrientationD",
                            subject=f"Mesures, chiffrages et effets, {D.annees[0]}–{D.annees[-1]}")
    doc.build(story, onFirstPage=pied, onLaterPages=pied)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("entree", help="JSON produit par Rapport.lean --synthese")
    ap.add_argument("programme", help="identifiant du programme (ex. TexteOrientationD)")
    ap.add_argument("sortie", help="PDF à écrire")
    ap.add_argument("--readme", help="README du programme (défaut : Programmes/<id>/README.md)")
    ap.add_argument("--commit", default=os.environ.get("GITHUB_SHA"))
    a = ap.parse_args()
    d = json.loads(Path(a.entree).read_text(encoding="utf-8"))
    if d.get("version") != 1:
        print(f"Version de synthèse inattendue : {d.get('version')}", file=sys.stderr)
        return 1
    racine = Path(__file__).resolve().parent.parent
    readme = Path(a.readme) if a.readme else racine / "Programmes" / a.programme / "README.md"
    construire(d, a.programme, readme, Path(a.sortie), a.commit)
    print(f"Programme PDF écrit : {a.sortie}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
