#!/usr/bin/env python3
"""Synthèse PDF des programmes : tableaux et courbes sur dix ans.

Lit l'export de `Rapport.lean --synthese` (trajectoires calculées par le
modèle commun du dépôt) et produit un PDF : PIB, déficit et dette publics,
chômage, population active, emploi par secteur, impôts et taxes majeurs,
sensibilité au prix du pétrole et à la natalité, propriétés et engagements,
hypothèses et sources.

Aucun calcul économique ici : le script met en forme des chiffres produits
par le modèle (écarts et ratios d'affichage exceptés).

Usage :
    lake env lean --run Rapport.lean --synthese out/synthese.json
    python3 scripts/synthese_pdf.py out/synthese.json out/synthese.pdf [--commit SHA]

Dépendances : matplotlib, reportlab.
"""

from __future__ import annotations

import argparse
import colorsys
import datetime as dt
import io
import json
import os
import sys
from collections import OrderedDict
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.ticker import FuncFormatter, MaxNLocator  # noqa: E402
from reportlab.lib import colors  # noqa: E402
from reportlab.lib.pagesizes import A4  # noqa: E402
from reportlab.lib.styles import ParagraphStyle  # noqa: E402
from reportlab.lib.units import mm  # noqa: E402
from reportlab.pdfbase import pdfmetrics  # noqa: E402
from reportlab.pdfbase.ttfonts import TTFont  # noqa: E402
from reportlab.platypus import (  # noqa: E402
    CondPageBreak, Image, KeepTogether, PageBreak, Paragraph, SimpleDocTemplate,
    Spacer, Table, TableStyle)

# ---------------------------------------------------------------------------
# Charte : palette catégorielle validée (ordre fixe), encres, police
# ---------------------------------------------------------------------------

SERIES = ["#2a78d6", "#eb6834", "#1baf7a", "#eda100", "#e87ba4",
          "#008300", "#6250d6", "#e34948"]
ORDINAL = ["#86b6ef", "#2a78d6", "#104281"]   # bas → haut, une seule teinte
TENDANCIEL = "#4d4c48"
# Couleurs des partis, au plus près des conventions des médias (rose PS,
# rouges LFI et PCF, vert écologiste, jaune-orangé Ensemble, bleus de la
# droite, bleu marine RN). Contraintes par l'usage, elles ne passent pas
# toutes les seuils de séparation du validateur (trois bleus, deux rouges) :
# l'identité est donc doublée par la forme du marqueur, une étiquette en bout
# de courbe et le tableau sous chaque figure. Programme absent du tableau :
# palette catégorielle par défaut.
COULEURS_PARTIS = {
    "TexteOrientationD": "#C0158A", "PS": "#E86D9A", "LFI": "#D9502D", "PCF": "#A51C1F",
    "Ecologistes": "#2E9E50", "Renaissance": "#D99100", "Horizons": "#1AABC4",
    "LR": "#2F62C2", "RN": "#283C8C", "PlacePublique": "#7B3FA0",
    "RevolutionPermanente": "#7A0F2E", "Reconquete": "#3D3D3D", "NouvelleEnergie": "#5B8FD9",
    "ExempleRelance": "#a3a29b", "ExempleConsolidation": "#77766f"}
MARQUEURS = ["o", "s", "^", "D", "v", "P", "X", "h", "<", ">", "p", "*"]
FICTIFS = {"ExempleRelance", "ExempleConsolidation"}
INK, INK2, MUTED = "#0b0b0b", "#52514e", "#898781"
GRID, BASE, FOND = "#e1e0d9", "#c3c2b7", "#f4f3ef"
PAR_FIGURE = 99         # un seul graphe par indicateur, tous programmes confondus

FONT_DIR = Path(matplotlib.get_data_path()) / "fonts" / "ttf"
pdfmetrics.registerFont(TTFont("Sans", str(FONT_DIR / "DejaVuSans.ttf")))
pdfmetrics.registerFont(TTFont("Sans-Bold", str(FONT_DIR / "DejaVuSans-Bold.ttf")))
pdfmetrics.registerFont(TTFont("Sans-Italic", str(FONT_DIR / "DejaVuSans-Oblique.ttf")))
pdfmetrics.registerFont(TTFont("Sans-BoldItalic", str(FONT_DIR / "DejaVuSans-BoldOblique.ttf")))
pdfmetrics.registerFontFamily("Sans", normal="Sans", bold="Sans-Bold", italic="Sans-Italic",
                              boldItalic="Sans-BoldItalic")
pdfmetrics.registerFont(TTFont("Mono", str(FONT_DIR / "DejaVuSansMono.ttf")))
pdfmetrics.registerFont(TTFont("Serif", str(FONT_DIR / "DejaVuSerif.ttf")))
pdfmetrics.registerFont(TTFont("Serif-Bold", str(FONT_DIR / "DejaVuSerif-Bold.ttf")))
pdfmetrics.registerFont(TTFont("Serif-Italic", str(FONT_DIR / "DejaVuSerif-Italic.ttf")))
pdfmetrics.registerFont(TTFont("Serif-BoldItalic", str(FONT_DIR / "DejaVuSerif-BoldItalic.ttf")))
pdfmetrics.registerFontFamily("Serif", normal="Serif", bold="Serif-Bold", italic="Serif-Italic",
                              boldItalic="Serif-BoldItalic")

plt.rcParams.update({
    "font.family": "DejaVu Sans", "font.size": 7.5,
    "axes.edgecolor": BASE, "axes.labelcolor": INK2, "axes.titlecolor": INK,
    "axes.titlesize": 8.5, "axes.titleweight": "bold", "axes.titlelocation": "left",
    "axes.titlepad": 7,
    "axes.spines.top": False, "axes.spines.right": False, "axes.spines.left": False,
    "axes.grid": True, "axes.grid.axis": "y", "axes.axisbelow": True,
    "grid.color": GRID, "grid.linewidth": 0.6, "grid.linestyle": "-",
    "xtick.color": BASE, "ytick.color": BASE,
    "xtick.labelcolor": MUTED, "ytick.labelcolor": MUTED,
    "xtick.labelsize": 7, "ytick.labelsize": 7,
    "ytick.major.size": 0, "xtick.major.size": 3,
    "legend.frameon": False, "legend.fontsize": 7, "legend.labelcolor": INK2,
    "figure.facecolor": "white", "axes.facecolor": "white",
    "savefig.facecolor": "white", "lines.solid_capstyle": "round",
    "lines.solid_joinstyle": "round",
    "figure.constrained_layout.h_pad": 0.03, "figure.constrained_layout.w_pad": 0.03,
})

LARGEUR = A4[0] - 36 * mm       # largeur utile (marges de 18 mm), en points
POUCES = LARGEUR / 72           # idem en pouces : les figures sont tracées à l'échelle 1

# ---------------------------------------------------------------------------
# Formats français
# ---------------------------------------------------------------------------

NBSP = " "


def nombre(v: float, dec: int = 0) -> str:
    s = f"{abs(v):,.{dec}f}".replace(",", NBSP).replace(".", ",")
    return ("−" if v < 0 and round(abs(v), dec) != 0 else "") + s


def signe(v: float, dec: int = 1) -> str:
    if round(v, dec) == 0:
        return nombre(0, dec)
    return ("+" if v > 0 else "−") + nombre(abs(v), dec)


def pct_pb(pb: int, dec: int = 1) -> str:
    return nombre(pb / 100, dec) + NBSP + "%"


def md(meur: int, dec: int = 0) -> str:
    return nombre(meur / 1000, dec)


def fmt_axe(dec: int, suffixe: str = ""):
    return FuncFormatter(lambda v, _: nombre(v, dec) + suffixe)


# ---------------------------------------------------------------------------
# Données
# ---------------------------------------------------------------------------

def nom_court(nom: str) -> str:
    """« La France insoumise — Mélenchon 2027 (…) » → « La France insoumise »."""
    return nom.split(" — ")[0]


class Donnees:
    def __init__(self, d: dict, moteur: str | None = None, programmes: list[str] | None = None):
        self.d = d
        self.annees = d["annees"]
        self.var = {v["id"]: v for v in d["variantes"]}
        self.progs = d["programmes"]
        if programmes:
            inconnus = [x for x in programmes if x not in {p["id"] for p in self.progs}]
            if inconnus:
                raise SystemExit(f"Programmes inconnus : {', '.join(inconnus)}")
            self.progs = [p for p in self.progs if p["id"] in programmes]
        self.personnalisee = bool(moteur or programmes)
        # la couleur suit le programme (couleur du parti, sinon ordre du
        # registre), jamais son rang ; idem pour la forme du marqueur
        self.couleur = {p["id"]: COULEURS_PARTIS.get(p["id"], SERIES[i % len(SERIES)])
                        for i, p in enumerate(d["programmes"])}
        self.marqueur = {p["id"]: MARQUEURS[i % len(MARQUEURS)] for i, p in enumerate(d["programmes"])}
        self.style = {p["id"]: (":" if p["id"] in FICTIFS else "-") for p in d["programmes"]}
        nb = -(-len(self.progs) // PAR_FIGURE) or 1            # groupes de tailles équilibrées
        taille = -(-len(self.progs) // nb)
        self.groupes = [self.progs[i:i + taille] for i in range(0, len(self.progs), taille)]
        self.secteurs = d["secteurs"]
        self.impots = d["impots"]
        self.secteurs_ges = d.get("secteursGes", [])
        self.moteurs = d["moteurs"]
        self.fonctions = d["fonctions"]
        self.standard = d["moteurStandard"]
        if moteur:
            if moteur not in {m["id"] for m in self.moteurs}:
                raise SystemExit(f"Moteur inconnu : {moteur} (disponibles : "
                                 + ", ".join(m["id"] for m in self.moteurs) + ")")
            self.standard = moteur     # le moteur choisi devient celui des courbes et tableaux
        self.props = d["proprietes"]

    def traj(self, variante: str, prog: str | None, moteur: str | None = None) -> list[dict]:
        v = self.var[variante]["moteurs"][moteur or self.standard]
        return v["tendanciel"] if prog is None else v["programmes"][prog]

    def fin(self, variante: str, prog: str | None, moteur: str | None = None) -> dict:
        return self.traj(variante, prog, moteur)[-1]

    def nom_moteur(self, mid: str) -> str:
        return next(m["nom"] for m in self.moteurs if m["id"] == mid)

    def brent(self, variante: str) -> int:
        return self.var[variante]["prixBrentDollars"]

    def icf(self, variante: str) -> str:
        return nombre(self.var[variante]["icfCentiemes"] / 100, 2)

    def lignes(self):
        """(id, nom court) : tendanciel puis programmes."""
        return [(None, "Tendanciel (sans programme)")] + [(p["id"], nom_court(p["nom"])) for p in self.progs]


def impots_total(e: dict) -> int:
    return sum(e["impots"].values())


def po_pb(e: dict) -> int:
    return impots_total(e) * 10000 // e["pib"]


# ---------------------------------------------------------------------------
# Figures (tracées à la largeur exacte de la page : échelle 1)
# ---------------------------------------------------------------------------

def figure(hauteur: float, *args, **kw):
    return plt.subplots(*args, figsize=(POUCES, hauteur), layout="constrained", **kw)


def png(fig) -> Image:
    buf = io.BytesIO()
    fig.savefig(buf, format="png", dpi=220)
    w, h = fig.get_size_inches()
    plt.close(fig)
    buf.seek(0)
    return Image(buf, width=w * 72, height=h * 72)


def ligne(ax, x, y, couleur, label, epaisseur=1.6, z=3, marqueur="o", style="-"):
    ax.plot(x, y, color=couleur, lw=epaisseur, ls=style, zorder=z)
    ax.plot([x[-1]], [y[-1]], marqueur, ms=4.8, color=couleur, mec="white", mew=1.0, zorder=z + 1)
    # entrée de légende : trait et marqueur ensemble
    ax.plot([], [], color=couleur, lw=epaisseur, ls=style, marker=marqueur, ms=4.8,
            mec="white", mew=1.0, label=label)


def etiquettes_fin(ax, x_fin, series, dec, suffixe):
    """Étiquettes en bout de courbe (nom et valeur), écartées pour ne pas se
    chevaucher, reliées à leur point par un trait fin de la couleur de la
    série. Le texte reste à l'encre secondaire."""
    if not series:
        return
    y0, y1 = ax.get_ylim()
    ecart = (y1 - y0) * 0.052
    ordre = sorted(series, key=lambda t: t[1])
    pos = []
    for t in ordre:
        y = t[1]
        pos.append(max(y, pos[-1] + ecart) if pos else y)
    # recentrer le bloc si le dernier déborde en haut
    debord = pos[-1] - (y1 - ecart * 0.3)
    if debord > 0:
        pos = [p - debord for p in pos]
        for i in range(len(pos) - 2, -1, -1):
            pos[i] = min(pos[i], pos[i + 1] - ecart)
    xl = x_fin + 0.55
    for (nom, y, c, *vrai), p in zip(ordre, pos):
        ax.plot([x_fin + 0.12, xl - 0.08], [y, p], color=c, lw=0.6, zorder=1, clip_on=False)
        # série hors échelle : la valeur affichée est la vraie, signalée par ▲ ou ▼
        val = nombre(vrai[0], dec) + suffixe + (" ▲" if vrai[0] > y else " ▼") if vrai else nombre(y, dec) + suffixe
        ax.annotate(f"{nom}  {val}", (xl, p), va="center", ha="left", fontsize=6.3,
                    color=INK2, annotation_clip=False)


HORS_ECHELLE = 1.8      # une série dont l'amplitude dépasse 1,8 fois celle des autres est coupée


def hors_echelle(series):
    """Identifiants des séries hors échelle : amplitude (valeur absolue
    maximale) supérieure à HORS_ECHELLE fois la plus grande des autres. Leur
    trait est coupé au bord du graphe pour que les autres restent lisibles ;
    l'étiquette de fin donne leur vraie valeur."""
    amp = {k: max(abs(v) for v in y) for k, y in series.items()}
    hors = set()
    for k, a in amp.items():
        autres = [b for j, b in amp.items() if j != k]
        if autres and max(autres) > 0 and a > HORS_ECHELLE * max(autres):
            hors.add(k)
    return hors


def legende(fig, ncol=3):
    fig.legend(loc="outside lower left", ncol=ncol, handlelength=1.6, columnspacing=1.8)


def courbes(D: Donnees, groupe, valeur, titre, dec, suffixe="", ecart=False, reference=None):
    """Une courbe par programme (scénario central), et le tendanciel, sur un
    seul graphe ; étiquettes en bout de courbe."""
    fig, ax = figure(3.5)
    x = D.annees
    base = [valeur(e) for e in D.traj("central", None)]
    fins = []
    series = {}
    if not ecart:
        series[None] = base
    for p in groupe:
        y = [valeur(e) for e in D.traj("central", p["id"])]
        if ecart:
            y = [a - b for a, b in zip(y, base)]
        series[p["id"]] = y
    hors = hors_echelle(series)
    if not ecart:
        ligne(ax, x, base, TENDANCIEL, "Tendanciel (sans programme)", epaisseur=1.3, z=2, style="--")
        fins.append(("Tendanciel", base[-1], TENDANCIEL))
    for p in groupe:
        y = series[p["id"]]
        ligne(ax, x, y, D.couleur[p["id"]], nom_court(p["nom"]),
              marqueur=D.marqueur[p["id"]], style=D.style[p["id"]])
        fins.append((court_nom(nom_court(p["nom"]), 22), y[-1], D.couleur[p["id"]]))
    if hors:
        dans = [v for k, y in series.items() if k not in hors for v in y]
        lo, hi = min(dans + [0]), max(dans + [0])
        if reference is not None:
            lo, hi = min(lo, reference[0]), max(hi, reference[0])
        marge = (hi - lo) * 0.08 or 1
        ax.set_ylim(lo - marge, hi + marge)
        y0, y1 = ax.get_ylim()
        fins = [(n, min(max(v, y0), y1), c, v) if v > y1 or v < y0 else (n, v, c)
                for n, v, c in fins]
    if ecart:
        ax.axhline(0, color=BASE, lw=0.8, zorder=1)
    if reference is not None:
        ax.axhline(reference[0], color=INK2, lw=0.8, zorder=1)
        ax.annotate(reference[1], (x[0], reference[0]), xytext=(2, 3),
                    textcoords="offset points", color=INK2, fontsize=7)
    ax.set_title(titre)
    ax.yaxis.set_major_formatter(fmt_axe(dec, suffixe))
    ax.yaxis.set_major_locator(MaxNLocator(5))
    ax.set_xticks(x[::2] if len(x) > 6 else x)
    ax.set_xlim(x[0] - 0.3, x[-1] + 0.3)
    fig.canvas.draw()           # fige les limites avant de placer les étiquettes
    etiquettes_fin(ax, x[-1], fins, dec, suffixe)
    fig.get_layout_engine().set(rect=(0, 0, 0.78, 1))
    legende(fig, ncol=4)
    return fig


def barres_secteurs(D: Donnees, groupe, variante="central"):
    """Écart d'emploi au tendanciel en fin de période : un panneau par secteur,
    une barre par programme (même échelle partout)."""
    secs = D.secteurs
    n = len(groupe)
    fig, axes = figure(0.2 * n + 1.0, 1, len(secs), sharey=True, sharex=True)
    base = D.fin(variante, None)["emploi"]
    ecarts = {p["id"]: [(D.fin(variante, p["id"])["emploi"][s["id"]] - base[s["id"]]) / 1000
                        for s in secs] for p in groupe}
    m = max([abs(v) for vs in ecarts.values() for v in vs] + [1.0])
    for k, (ax, sec) in enumerate(zip(axes, secs)):
        vals = [ecarts[p["id"]][k] for p in groupe]
        ax.barh(range(n), vals, height=0.66, color=[D.couleur[p["id"]] for p in groupe], zorder=3)
        ax.axvline(0, color=BASE, lw=0.8, zorder=2)
        ax.set_title(SECTEURS_TAB.get(sec["id"], sec["nom"]), fontsize=7.5)
        ax.grid(axis="y", visible=False)
        ax.grid(axis="x", visible=True)
        ax.set_xlim(-m * 1.15, m * 1.15)
        ax.xaxis.set_major_formatter(fmt_axe(0, ""))
        ax.xaxis.set_major_locator(MaxNLocator(3))
        ax.tick_params(axis="x", labelsize=6.5)
    axes[0].set_yticks(range(n), [court_nom(nom_court(p["nom"]), 26) for p in groupe])
    axes[0].set_ylim(n - 0.5, -0.5)
    axes[0].tick_params(axis="y", labelcolor=INK2, labelsize=6.8)
    fig.suptitle(f"Écart d'emploi au tendanciel en {D.annees[-1]}, par secteur (milliers)",
                 x=0.0, ha="left", fontsize=8.5, fontweight="bold", color=INK)
    return fig


def petits_multiples_impots(D: Donnees, groupe, variante="central"):
    """Écart de recettes au tendanciel par prélèvement : un panneau par programme,
    même échelle partout."""
    imp = D.impots
    n = len(groupe)
    cols = 4 if n > 6 else (3 if n > 2 else n)
    rangs = (n + cols - 1) // cols
    fig, axes = figure(1.6 * rangs + 0.35, rangs, cols, sharex=True, sharey=True, squeeze=False)
    base = D.fin(variante, None)["impots"]
    ecarts = {p["id"]: [(D.fin(variante, p["id"])["impots"][i["id"]] - base[i["id"]]) / 1000
                        for i in imp] for p in groupe}
    m = max([abs(v) for vs in ecarts.values() for v in vs] + [1.0])
    for k, ax in enumerate(axes.flat):
        if k >= n:
            ax.axis("off")
            continue
        p = groupe[k]
        vals = ecarts[p["id"]]
        ax.barh(range(len(imp)), vals, height=0.62, color=D.couleur[p["id"]], zorder=3)
        ax.axvline(0, color=BASE, lw=0.8, zorder=2)
        ax.set_title(court_nom(nom_court(p["nom"]), 24), fontsize=7)
        ax.grid(axis="y", visible=False)
        ax.grid(axis="x", visible=True)
        ax.set_xlim(-m * 1.35, m * 1.35)
        ax.set_yticks(range(len(imp)), [COURTS_FIG.get(i["id"], i["nom"]) for i in imp])
        ax.set_ylim(len(imp) - 0.5, -0.5)
        ax.tick_params(axis="y", labelcolor=INK2, labelsize=6.8)
        ax.xaxis.set_major_formatter(fmt_axe(0, ""))
        ax.xaxis.set_major_locator(MaxNLocator(4))
        kmax = max(range(len(vals)), key=lambda i: abs(vals[i]))
        if abs(vals[kmax]) >= 0.05:      # seule la plus grande barre est étiquetée
            v = vals[kmax]
            ax.annotate(signe(v, 1), (v, kmax), xytext=(3 if v >= 0 else -3, 0),
                        textcoords="offset points", ha="left" if v >= 0 else "right",
                        va="center", fontsize=6.8, color=INK)
        else:
            ax.annotate("aucun écart notable", (0, (len(imp) - 1) / 2), xytext=(5, 0),
                        textcoords="offset points", fontsize=6.8, color=MUTED, va="center")
    fig.suptitle(f"Écart de recettes au tendanciel en {D.annees[-1]}, par prélèvement (Md€)",
                 x=0.0, ha="left", fontsize=8.5, fontweight="bold", color=INK)
    return fig


def structure_impots(D: Donnees):
    """Prélèvements de la situation de départ (une seule série)."""
    e = D.traj("central", None)[0]
    imp = sorted(D.impots, key=lambda i: e["impots"][i["id"]], reverse=True)
    vals = [e["impots"][i["id"]] / 1000 for i in imp]
    fig, ax = figure(2.1)
    ax.barh(range(len(imp)), vals, height=0.58, color=SERIES[0], zorder=3)
    ax.set_yticks(range(len(imp)), [i["nom"] for i in imp])
    ax.set_ylim(len(imp) - 0.5, -0.5)
    ax.tick_params(axis="y", labelcolor=INK2, labelsize=7.2)
    ax.grid(axis="y", visible=False)
    ax.grid(axis="x", visible=True)
    for k, v in enumerate(vals):
        ax.annotate(nombre(v, 0), (v, k), xytext=(3, 0), textcoords="offset points",
                    va="center", fontsize=6.8, color=INK2)
    ax.set_xlim(0, max(vals) * 1.1)
    ax.xaxis.set_major_formatter(fmt_axe(0, ""))
    ax.set_title(f"Impôts et cotisations en {D.annees[0]}, situation de départ (Md€)")
    return fig


def points_petrole(D: Donnees, champs):
    """Valeur en fin de période selon le prix du pétrole : trois points par ligne."""
    variantes = [(v, f"{D.brent(v)} $") for v in ("petrole-bas", "central", "petrole-haut")]
    lignes = D.lignes()
    fig, axes = figure(0.24 * len(lignes) + 0.9, 1, len(champs), sharey=True)
    for ax, (champ, titre, dec, suffixe, tr) in zip(axes, champs):
        for k, (pid, _nom) in enumerate(lignes):
            vals = [tr(D.fin(v, pid)[champ]) for v, _ in variantes]
            ax.plot([min(vals), max(vals)], [k, k], color=BASE, lw=1.2, zorder=2)
            for (_v, lab), val, c in zip(variantes, vals, ORDINAL):
                ax.plot([val], [k], "o", ms=5.5, color=c, mec="white", mew=1.0, zorder=3,
                        label=f"Brent à {lab}" if k == 0 else None)
        ax.set_title(titre, fontsize=8)
        ax.grid(axis="y", visible=False)
        ax.grid(axis="x", visible=True)
        ax.xaxis.set_major_formatter(fmt_axe(dec, suffixe))
        ax.xaxis.set_major_locator(MaxNLocator(4))
        ax.set_ylim(len(lignes) - 0.5, -0.5)
    axes[0].set_yticks(range(len(lignes)), [n for _, n in lignes])
    axes[0].tick_params(axis="y", labelcolor=INK2, labelsize=7.2)
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="outside lower left", ncol=3, handlelength=1.0)
    return fig


def courbes_natalite(D: Donnees):
    variantes = [("natalite-basse", f"basse ({D.icf('natalite-basse')} enfant par femme)"),
                 ("central", f"centrale ({D.icf('central')})"),
                 ("natalite-haute", f"haute ({D.icf('natalite-haute')})")]
    fig, ax = figure(2.3)
    x = D.annees
    for (v, lab), c in zip(variantes, ORDINAL):
        y = [e["populationMilliers"] / 1000 for e in D.traj(v, None)]
        ligne(ax, x, y, c, f"Natalité {lab}")
        ax.annotate(nombre(y[-1], 1) + NBSP + "M", (x[-1], y[-1]), xytext=(7, 0),
                    textcoords="offset points", va="center", fontsize=7, color=INK2)
    ax.set_title("Population (millions) selon la fécondité, identique pour tous les programmes")
    ax.yaxis.set_major_formatter(fmt_axe(1, ""))
    ax.yaxis.set_major_locator(MaxNLocator(5))
    ax.set_xticks(x[::2])
    ax.set_xlim(x[0] - 0.3, x[-1] + 1.3)
    legende(fig)
    return fig


COURTS_FIG = {"tva": "TVA", "ir": "IR", "csgCrds": "CSG-CRDS", "cotisations": "Cotisations",
              "impotSocietes": "IS", "accisesEnergie": "Accise énergie",
              "taxeFonciere": "Taxe foncière", "droitsMutation": "Successions",
              "mutationsOnereuses": "DMTO", "patrimoine": "Patrimoine", "autres": "Autres impôts"}
COURTS_TAB = {"tva": "TVA", "ir": "IR", "csgCrds": "CSG", "cotisations": "Cotis.",
              "impotSocietes": "IS", "accisesEnergie": "Accise", "taxeFonciere": "T. fonc.",
              "droitsMutation": "Succ.", "mutationsOnereuses": "DMTO", "patrimoine": "Patr.",
              "autres": "Autres"}
SECTEURS_TAB = {"agriculture": "Agric.", "industrie": "Industrie", "construction": "Constr.",
                "tertiaireMarchand": "Tert. march.", "tertiaireNonMarchand": "Tert. non m."}

# ---------------------------------------------------------------------------
# Mise en page
# ---------------------------------------------------------------------------


def style(nom, police="Sans", taille=8.8, interligne=None, couleur=INK, **kw):
    return ParagraphStyle(nom, fontName=police, fontSize=taille,
                          leading=interligne or taille * 1.4, textColor=couleur, **kw)


STYLES = {
    "titre": style("titre", "Sans-Bold", 21, 26, spaceAfter=6),
    "soustitre": style("soustitre", taille=10.5, interligne=14, couleur=INK2, spaceAfter=12),
    "h1": style("h1", "Sans-Bold", 13.5, 17, spaceBefore=6, spaceAfter=6),
    "h2": style("h2", "Sans-Bold", 9.8, 13, spaceBefore=8, spaceAfter=4),
    "corps": style("corps", taille=8.8, interligne=12.6, spaceAfter=6),
    "puce": style("puce", taille=8.6, interligne=12, leftIndent=10, spaceAfter=2.5),
    "note": style("note", taille=7.2, interligne=9.6, couleur=INK2, spaceBefore=3, spaceAfter=8),
    "cell": style("cell", taille=7.2, interligne=9.0),
    "celld": style("celld", taille=7.2, interligne=9.0, alignment=2),
    "cellg": style("cellg", "Sans-Bold", 7.2, 9.0, couleur=INK2),
    "cellgd": style("cellgd", "Sans-Bold", 7.2, 9.0, couleur=INK2, alignment=2),
    "cellpc": style("cellpc", taille=6.4, interligne=7.6, alignment=1),
    "cellgpc": style("cellgpc", "Sans-Bold", 6.0, 7.2, couleur=INK2, alignment=1),
    "petit": style("petit", taille=7, interligne=9, couleur=INK2, leftIndent=10, spaceAfter=1.5),
}


def P(texte: str, nom: str = "corps") -> Paragraph:
    return Paragraph(texte, STYLES[nom])


def echap(t: str) -> str:
    return t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def tableau(entetes, lignes, largeurs, droite_des=1, surligner_premiere=False) -> Table:
    """Tableau sobre : filets fins, nombres alignés à droite."""
    def cellule(c, j, entete):
        if isinstance(c, Paragraph):
            return c
        nom = ("cellg" if entete else "cell") + ("d" if j >= droite_des else "")
        return P(echap(str(c)), nom)

    data = [[cellule(h, j, True) for j, h in enumerate(entetes)]]
    data += [[cellule(c, j, False) for j, c in enumerate(ln)] for ln in lignes]
    t = Table(data, colWidths=[w * LARGEUR for w in largeurs], repeatRows=1)
    st = [("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
          ("VALIGN", (0, 0), (-1, 0), "BOTTOM"),
          ("LINEBELOW", (0, 0), (-1, 0), 0.7, colors.HexColor(BASE)),
          ("LINEBELOW", (0, 1), (-1, -1), 0.3, colors.HexColor(GRID)),
          ("TOPPADDING", (0, 0), (-1, -1), 2.4), ("BOTTOMPADDING", (0, 0), (-1, -1), 2.4),
          ("LEFTPADDING", (0, 0), (-1, -1), 3), ("RIGHTPADDING", (0, 0), (-1, -1), 3)]
    if surligner_premiere:
        st.append(("BACKGROUND", (0, 1), (-1, 1), colors.HexColor(FOND)))
    t.setStyle(TableStyle(st))
    return t


def puces(items):
    return [Paragraph(t, STYLES["puce"], bulletText="•") for t in items]


# Dégradé des tableaux de propriétés : part des scénarios où la propriété
# tient, du rouge (aucun) au vert (tous) en passant par l'orange (la moitié).
# Interpolation de la teinte (rouge → orange → jaune → vert), puis mélange
# avec le blanc pour que le texte reste lisible ; le nombre de scénarios
# reste écrit dans chaque case (la couleur n'est jamais seule).
DEGRADE = ((0.0, "#d03b3b"), (0.5, "#f0912e"), (1.0, "#0ca30c"))
PART_BLANC = 0.5


def couleur_part(part: float):
    part = min(max(part, 0.0), 1.0)
    for (a, ca), (b, cb) in zip(DEGRADE, DEGRADE[1:]):
        if part <= b:
            t = (part - a) / (b - a)
            h0, l0, s0 = colorsys.rgb_to_hls(*colors.HexColor(ca).rgb())
            h1, l1, s1 = colorsys.rgb_to_hls(*colors.HexColor(cb).rgb())
            r, g, bl = colorsys.hls_to_rgb(h0 + (h1 - h0) * t, l0 + (l1 - l0) * t, s0 + (s1 - s0) * t)
            break
    return colors.Color(*(c + (1 - c) * PART_BLANC for c in (r, g, bl)))


def colorer_parts(t: Table, parts: dict) -> Table:
    """Fond de chaque case (colonne, ligne) selon sa part, filets blancs
    entre les cases colorées."""
    st = [("BACKGROUND", (j, i), (j, i), couleur_part(v)) for (j, i), v in parts.items()]
    if parts:
        j0 = min(j for j, _ in parts)
        i0 = min(i for _, i in parts)
        st += [("INNERGRID", (j0, i0), (-1, -1), 1.2, colors.white),
               ("LINEBEFORE", (j0, i0), (j0, -1), 1.2, colors.white)]
    t.setStyle(TableStyle(st))
    return t


def legende_degrade(n: int, pas: int = 6) -> Table:
    """Légende du dégradé : cases de 0 à n scénarios."""
    valeurs = [round(n * k / pas) for k in range(pas + 1)]
    data = [[P("Part des scénarios où la propriété tient :", "cell")]
            + [P(f"{v}/{n}", "cellpc") for v in valeurs]]
    t = Table(data, colWidths=[0.30 * LARGEUR] + [0.06 * LARGEUR] * len(valeurs), hAlign="LEFT")
    t.setStyle(TableStyle([("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                           ("TOPPADDING", (0, 0), (-1, -1), 1.5), ("BOTTOMPADDING", (0, 0), (-1, -1), 1.5),
                           ("LEFTPADDING", (0, 0), (-1, -1), 1), ("RIGHTPADDING", (0, 0), (-1, -1), 1)]))
    return colorer_parts(t, {(k + 1, 0): v / n for k, v in enumerate(valeurs)})


# ---------------------------------------------------------------------------
# Sections
# ---------------------------------------------------------------------------

PROPS_COURT = {"deficit-plafond": "Déficit sous plafond", "dette-non-degradee": "Dette non dégradée",
               "chomage-non-degrade": "Chômage non dégradé", "emissions-plafond": "Émissions sous plafond",
               "deficit-3pct-2035": "Déficit < 3 % 2035", "equilibre-2035": "Équilibre 2035", "deficit-en-baisse": "Déficit en baisse", "dette-stabilisee-2035": "Dette stable 2035",
               "air-non-degrade": "Air non dégradé", "bornes-suffisantes-2035": "Bornes 2035",
               "emplois-annonces-realisables": "Emplois annoncés",
               "balance-courante-non-degradee": "Solde courant", "accidents-travail-norme-ue": "Accidents du travail",
               "ue-deficit-3pct": "UE : déficit 3 %", "ue-ajustement-0-5": "UE : ajust. 0,5 pt",
               "ue-dette-1pt": "UE : dette −1 pt", "ue-climat-2030": "UE : climat 2030", "ue-esr-2030": "UE : effort 2030",
               "snbc-secteurs-2030": "SNBC : secteurs 2030", "budget-carbone-2029-2033": "Budget carbone 4",
               "parc-electrique-2030": "15 % d'électriques 2030", "zan-enveloppe-2031": "ZAN 2021-2031",
               "ue-afir-2030": "UE : AFIR 2030", "ue-balance-courante": "UE : solde courant",
               "idh-non-degrade": "IDH non dégradé", "lpm-2024-2030": "LPM 2024-2030",
               "ppe3-capacites-2030": "PPE3 : capacités 2030", "electricite-renouvelable-2030": "40 % d'électricité renouvelable",
               "constitution-art-89": "Constitution inchangée", "constitution-ddhc-13": "DDHC 13 : non confiscatoire",
               "constitution-preambule-11": "Préambule al. 11 : retraites", "constitution-preambule-13": "Préambule al. 13 : enseignement",
               "constitution-lo-omt": "LO 2012 : solde structurel"}


def table_proprietes(D: Donnees, moteur: str | None = None, avec_central: bool = False) -> Table:
    """Par programme et propriété : statut au scénario central (✓/✗) et nombre
    de scénarios où la propriété tient, sous un moteur."""
    n = D.d["nbScenarios"]
    mid = moteur or D.standard
    props = [q for q in D.props if not q["id"].startswith("ue-") and not q["id"].startswith("constitution-")]   # pages à part
    ent = [f"Programme (sur {n} scénarios)"] + [PROPS_COURT.get(q["id"], q["titre"]) for q in props]

    def cellule(p, q):
        nb = p["matrice"][mid][q["id"]]
        if not avec_central:
            return P(f"{nb}/{n}", "cellpc")
        ok = p["central"][mid][q["id"]]
        return P(f"{'✓' if ok else '✗'}<br/>{nb}/{n}", "cellpc")

    # colonnes étroites : en-têtes et cellules en petit corps, statut et
    # nombre de scénarios sur deux lignes
    ent = [ent[0]] + [P(echap(h), "cellgpc") for h in ent[1:]]
    rows = [[nom_court(p["nom"])] + [cellule(p, q) for q in props] for p in D.progs]
    t = tableau(ent, rows, [0.17] + [0.83 / len(props)] * len(props))
    t.setStyle(TableStyle([("LEFTPADDING", (1, 0), (-1, -1), 1), ("RIGHTPADDING", (1, 0), (-1, -1), 1)]))
    return colorer_parts(t, {(j + 1, i + 1): p["matrice"][mid][q["id"]] / n
                             for i, p in enumerate(D.progs) for j, q in enumerate(props)})


def score(p: dict, mid: str) -> int:
    """Score global d'un programme sous un moteur : somme, sur toutes les
    propriétés, du nombre de scénarios où chacune tient (même calcul que la
    section « Score global » de Rapport.lean)."""
    return sum(p["matrice"][mid].values())


def table_scores(D: Donnees) -> Table:
    """Classement des programmes par score global (somme des moteurs), cases
    en dégradé selon la part des cases tenues."""
    n = D.d["nbScenarios"] * len(D.props)
    mids = [m["id"] for m in D.moteurs]
    classes = sorted(D.progs, key=lambda p: -sum(score(p, mid) for mid in mids))
    ent = ["Rang", f"Programme ({len(D.props)} propriétés × {D.d['nbScenarios']} scénarios)"] \
        + [D.nom_moteur(mid) for mid in mids] + ["Ensemble"]

    def cel(k, total):
        return P(f"{k}/{total}<br/>{nombre(100 * k / total)} %", "cellpc")

    rows, parts = [], {}
    for i, p in enumerate(classes):
        ks = [score(p, mid) for mid in mids]
        rows.append([str(i + 1), nom_court(p["nom"])] + [cel(k, n) for k in ks]
                    + [cel(sum(ks), n * len(mids))])
        for j, k in enumerate(ks):
            parts[(j + 2, i + 1)] = k / n
        parts[(len(mids) + 2, i + 1)] = sum(ks) / (n * len(mids))
    larg = [0.06, 0.38] + [0.56 / (len(mids) + 1)] * (len(mids) + 1)
    return colorer_parts(tableau([P(echap(h), "cellgpc") if j > 1 else h for j, h in enumerate(ent)],
                                 rows, larg, droite_des=9), parts)


def puces_electricite_sols(D: Donnees) -> list:
    """Électricité et sols en une ligne chacun (si le rapport les contient)."""
    a0, a1 = D.annees[0], D.annees[-1]
    base = D.fin("central", None)
    if "productionGwh" not in base or "surfacesHa" not in base:
        return []
    conso = [(D.fin("central", pid)["consommationGwh"] / 8760, nom) for pid, nom in D.lignes() if pid]
    cmin, cmax = min(conso), max(conso)

    def enaf(pid):
        tr = D.traj("central", pid)
        return sum(tr[-1]["surfacesHa"][x] - tr[0]["surfacesHa"][x] for x in tr[0]["surfacesHa"] if x != "energie")
    abroges = [nom for pid, nom in D.lignes() if pid and D.fin("central", pid).get("ecartZanPm", 0) >= 1000]
    texte_sols = (f"Sols : {nombre(enaf(None))} ha d'espaces naturels, agricoles et forestiers consommés de "
                  f"{a0 + 1} à {a1} sous le ZAN (enveloppe 2021-2031 tenue)")
    if abroges:
        pid_max = max((pid for pid, _ in D.lignes() if pid), key=enaf)
        texte_sols += (f", jusqu'à {nombre(enaf(pid_max))} ha pour les programmes qui l'abrogent "
                       f"({echap(', '.join(abroges))})")
    return [
        f"Électricité en {a1}, sans programme : {nombre(sum(base['productionGwh'].values()) / 8760, 1)} GW "
        f"moyens produits pour {nombre(base['consommationGwh'] / 8760, 1)} GW consommés (de "
        f"{nombre(cmin[0], 1)} à {nombre(cmax[0], 1)} GW selon le programme) ; "
        f"{nombre(base.get('modulationGwh', 0) / 8760, 1)} GW de nucléaire modulé faute de débouchés.",
        texte_sols + ".",
    ]


RACINE = Path(__file__).resolve().parent.parent


def charger_preambule(pid: str) -> list[str]:
    """Paragraphes de la section « Grands principes » du README du programme
    (Programmes/<id>/README.md), s'il en a une ; liste vide sinon. Seuls le
    gras (**…**) et les paragraphes séparés par une ligne vide sont
    interprétés ; le reste est pris tel quel."""
    chemin = RACINE / "Programmes" / pid / "README.md"
    if not chemin.is_file():
        return []
    lignes, dedans = [], False
    for ligne in chemin.read_text(encoding="utf-8").splitlines():
        if ligne.startswith("## "):
            if dedans:
                break
            dedans = ligne.strip() == "## Grands principes"
            continue
        if dedans:
            lignes.append(ligne)
    paragraphes, courant = [], []
    for ligne in lignes + [""]:
        if ligne.strip():
            courant.append(ligne.strip())
        elif courant:
            paragraphes.append(" ".join(courant))
            courant = []
    out = []
    for para in paragraphes:
        texte = echap(para)
        while "**" in texte:
            texte = texte.replace("**", "<b>", 1).replace("**", "</b>", 1)
        out.append(texte)
    return out


def section_preambule(D: Donnees) -> list:
    """Préambule : grands principes du programme, quand la synthèse porte sur
    un seul programme dont le README les expose."""
    if len(D.progs) != 1:
        return []
    p = D.progs[0]
    paragraphes = charger_preambule(p["id"])
    if not paragraphes:
        return []
    out = [P(f"Préambule : les grands principes du programme « {echap(p['nom'])} »", "h1")]
    out += [P(x) for x in paragraphes]
    out.append(P("Texte de l'auteur du programme (section « Grands principes » de son README) ; "
                 "les numéros renvoient aux mesures du programme complet en fin de document. "
                 "Les chiffres qui suivent sont ceux du modèle commun.", "note"))
    out += section_statuts(D, p)
    return out


def section_statuts(D: Donnees, p: dict) -> list:
    """Classement des mesures du programme en rubicons, paramétrables et
    négociables, par domaine (champs `statut` et `domaine` des mesures) :
    tableau des effectifs et liste des négociables."""
    bases = [m for m in p["mesures"] if m.get("statut", "nonClasse") != "nonClasse"
             and not (m["id"] and m["id"][-1].islower())]
    if not bases:
        return []
    statuts = ("rubicon", "parametrable", "negociable")
    noms_st = {x["id"]: x["nom"] for x in D.d.get("statuts", [])}
    noms_dom = {x["id"]: x["nom"] for x in D.d.get("domaines", [])}
    ordre = [x["id"] for x in D.d.get("domaines", [])]
    n = {s: sum(1 for m in bases if m["statut"] == s) for s in statuts}
    out = [P("Rubicons, paramétrables, négociables", "h2"),
           P(f"L'auteur classe ses {len(bases)} mesures pour une négociation : <b>{n['rubicon']} "
             f"rubicons</b> (non négociables), <b>{n['parametrable']} paramétrables</b> (principe acquis, "
             f"taux, montants et calendrier à régler) et <b>{n['negociable']} négociables</b> (cessibles "
             "en échange d'autre chose). Détail et réglages dans le programme complet.")]
    rows = []
    for dom in ordre:
        c = [sum(1 for m in bases if m["domaine"] == dom and m["statut"] == s) for s in statuts]
        if sum(c):
            rows.append([noms_dom[dom]] + [str(x) if x else "—" for x in c] + [str(sum(c))])
    rows.append(["Total"] + [str(n[s]) for s in statuts] + [str(len(bases))])
    out.append(tableau(["Domaine"] + [noms_st[s].split(" (")[0] for s in statuts] + ["Total"], rows,
                       [0.46, 0.135, 0.135, 0.135, 0.135]))
    neg = [m for dom in ordre for m in bases if m["statut"] == "negociable" and m["domaine"] == dom]
    if neg:
        out.append(P("Les mesures négociables", "h2"))
        for m in neg:
            out.append(P(f"<b>{echap(m['id'])}</b> {echap(m['titre'])}"
                         + (f" — <i>{echap(m['noteStatut'])}</i>" if m.get("noteStatut") else ""), "petit"))
    return out


def section_resume(D: Donnees, meta) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    base = D.fin("central", None)
    titre = "Synthèse des programmes" if not D.personnalisee else \
        f"Synthèse personnalisée — moteur « {D.nom_moteur(D.standard)} »"
    out = [P(titre, "titre"),
           P(f"Projections {a0}–{a1} sous hypothèses partagées : PIB, finances publiques, "
             f"emploi par secteur, impôts et taxes, sensibilité au prix du pétrole et à la natalité.",
             "soustitre"),
           P(f"Généré le {meta['date']} à partir du dépôt <b>TOrientationD/Programmes_Lean</b>"
             f"{meta['commit']}. Tous les chiffres sont calculés par le modèle commun du dépôt, "
             f"le même pour chaque programme ; ce document ne fait que les mettre en forme."
             + (f" <b>Synthèse personnalisée</b> : courbes et tableaux sous le moteur « "
                f"{echap(D.nom_moteur(D.standard))} » ({echap(next(m['description'] for m in D.moteurs if m['id'] == D.standard))})"
                + (f", {len(D.progs)} programme(s) sélectionné(s)" if len(D.progs) < len(D.d['programmes']) else "")
                + "." if D.personnalisee else ""))]
    preambule = section_preambule(D)
    if preambule:
        out += preambule
        out.append(CondPageBreak(120 * mm))
    out.append(P(f"Indicateurs en {a1}, scénario central", "h2"))
    ent = ["Programme", "PIB (Md€)", "Écart de PIB", "Déficit public", "Dette", "Chômage",
           "Actifs (M)", "Prélèv. oblig.", "Solde courant"]
    rows = []
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        ecart = "—" if pid is None else signe((e["pib"] - base["pib"]) * 100 / base["pib"], 2) + NBSP + "%"
        rows.append([nom, md(e["pib"]), ecart, pct_pb(e["deficitPb"]), pct_pb(e["dettePb"], 0),
                     pct_pb(e["chomagePb"]), nombre(e["actifs"] / 1e6, 2), pct_pb(po_pb(e)),
                     signe(e["balanceCourantePb"] / 100, 1) + NBSP + "%"])
    out.append(tableau(ent, rows, [0.24, 0.09, 0.095, 0.095, 0.08, 0.085, 0.085, 0.11, 0.12],
                       surligner_premiere=True))
    out.append(P("Déficit, dette, prélèvements obligatoires (impôts et cotisations sociales) et solde des "
                 "transactions courantes en % du PIB. Écart de PIB : par rapport au tendanciel, même "
                 "année, même scénario.", "note"))

    def ext(cle, variante="central"):
        vals = sorted((cle(D.fin(variante, p["id"])), nom_court(p["nom"])) for p in D.progs)
        return vals[0], vals[-1]

    (dmin, nmin), (dmax, nmax) = ext(lambda e: e["deficitPb"])
    (cmin, ncmin), (cmax, ncmax) = ext(lambda e: e["chomagePb"])
    ids = [None] + [p["id"] for p in D.progs]
    pertes = [(D.fin("central", i)["pib"] - D.fin("petrole-haut", i)["pib"]) * 100
              / D.fin("central", i)["pib"] for i in ids]
    hausses = [(D.fin("petrole-haut", i)["deficitPb"] - D.fin("central", i)["deficitPb"]) / 100
               for i in ids]

    def plage(vals, dec, unite):
        a, b = nombre(min(vals), dec), nombre(max(vals), dec)
        return f"{a}{unite}" if a == b else f"{a} à {b}{unite}"
    out.append(P("Ce qu'il faut retenir", "h2"))
    out += puces([
        f"En {a1}, le déficit public va de {pct_pb(dmin)} ({echap(nmin)}) à {pct_pb(dmax)} "
        f"({echap(nmax)}), contre {pct_pb(base['deficitPb'])} sans programme.",
        f"Le chômage va de {pct_pb(cmin, 2)} ({echap(ncmin)}) à {pct_pb(cmax, 2)} "
        f"({echap(ncmax)}), contre {pct_pb(base['chomagePb'], 2)} sans programme.",
        f"Un Brent à {D.brent('petrole-haut')} $ au lieu de {D.brent('central')} $ réduit le PIB "
        f"de {plage(pertes, 1, NBSP + '%')} et creuse le déficit de {plage(hausses, 1, ' point')} "
        "selon le programme (tendanciel compris).",
        f"La natalité ne change que la population "
        f"({nombre(D.fin('natalite-basse', None)['populationMilliers'] / 1000, 1)} à "
        f"{nombre(D.fin('natalite-haute', None)['populationMilliers'] / 1000, 1)} millions en {a1}) "
        "et le PIB par habitant : les enfants nés d'ici là n'arrivent pas sur le marché du travail "
        "avant l'horizon.",
    ] + puces_electricite_sols(D))
    out.append(P("Score global", "h2"))
    out.append(table_scores(D))
    out.append(P(f"Somme, sur les {len(D.props)} propriétés (européennes comprises), du nombre de "
                 f"scénarios où chacune tient, sous chaque moteur ; classement selon la somme des "
                 f"moteurs. Toutes les propriétés pèsent autant : le score résume la matrice, il ne "
                 f"hiérarchise pas les objectifs.", "note"))
    out.append(P(f"Propriétés partagées, moteur « {D.nom_moteur(D.standard)} »", "h2"))
    out.append(table_proprietes(D, avec_central=True))
    out.append(Spacer(1, 3))
    out.append(legende_degrade(D.d["nbScenarios"]))
    out.append(P(f"✓/✗ : statut au scénario central ; puis nombre de scénarios (démographie × "
                 f"économie × pétrole × cadre juridique) où la propriété tient, à l'horizon de "
                 f"{D.d['horizonProprietes']} ans ou à l'année propre à la propriété (2035). "
                 "Résultats sous l'autre moteur : page « Moteurs ».", "note"))
    out.append(P("Comment lire ce document", "h2"))
    out += puces([
        "Chaque programme est une liste de mesures traduites en leviers communs (dépense, "
        "prélèvement, âge légal, SMIC…). Le modèle en calcule les effets sous chaque jeu "
        "d'hypothèses ; aucun programme n'apporte ses propres élasticités.",
        f"Les mesures sont appliquées à leur année d'entrée en vigueur ({a0} sauf mention), puis "
        "la projection les porte jusqu'à l'horizon : les écarts au tendanciel sont des effets de "
        "niveau durables, charge d'intérêts comprise.",
        "Le déficit présenté est celui des administrations publiques au sens de Maastricht ; le "
        "modèle, volontairement simple, ne sépare pas le budget de l'État (limites en annexe C). "
        "Les programmes « Exemple » sont fictifs ; les autres sont des transcriptions partielles "
        "et non officielles.",
    ])
    return out


COULEURS_BENEFICIAIRES = ["#2a78d6", "#eb6834", "#1baf7a", "#eda100", "#e87ba4", "#6250d6"]


def beneficiaires_meta(D: Donnees) -> list[dict]:
    return D.d["beneficiairesInterets"]["beneficiaires"]


def barres_beneficiaires(D: Donnees):
    """Charge d'intérêts de la dernière année, empilée par bénéficiaire : une
    barre par ligne (tendanciel puis programmes)."""
    bens = beneficiaires_meta(D)
    # première ligne : l'année de départ (commune à toutes les trajectoires)
    lignes = [(None, f"Départ ({D.annees[0]})", D.traj("central", None)[0])] + \
        [(pid, nom, D.fin("central", pid)) for pid, nom in D.lignes()]
    n = len(lignes)
    fig, ax = figure(0.2 * n + 1.25)
    totaux = []
    for k, (_pid, _nom, e) in enumerate(lignes):
        r = e["interetsBeneficiaires"]
        gauche = 0.0
        for j, b in enumerate(bens):
            v = r[b["id"]] / 1000
            ax.barh(k, v, left=gauche, height=0.66, color=COULEURS_BENEFICIAIRES[j],
                    edgecolor="white", linewidth=0.8, zorder=3,
                    label=b["nom"] if k == 0 else None)
            gauche += v
        totaux.append(gauche)
    # une barre très au-dessus des autres est coupée, son total écrit au bord
    tri = sorted(totaux, reverse=True)
    limite = tri[1] * 1.3 if len(tri) > 1 and tri[0] > 2 * tri[1] else tri[0] * 1.08
    for k, t in enumerate(totaux):
        if t > limite:
            ax.annotate(f"{nombre(t, 0)} ▸", (limite, k), xytext=(-3, 0), textcoords="offset points",
                        va="center", ha="right", fontsize=6.8, color="white", fontweight="bold",
                        zorder=5)
        else:
            ax.annotate(nombre(t, 0), (t, k), xytext=(3, 0), textcoords="offset points",
                        va="center", fontsize=6.8, color=INK2)
    ax.set_yticks(range(n), [court_nom(nom, 30) for _pid, nom, _e in lignes])
    ax.set_ylim(n - 0.5, -0.5)
    ax.tick_params(axis="y", labelcolor=INK2, labelsize=6.8)
    ax.grid(axis="y", visible=False)
    ax.grid(axis="x", visible=True)
    ax.set_xlim(0, limite)
    ax.xaxis.set_major_formatter(fmt_axe(0, ""))
    ax.set_title(f"Charge d'intérêts par bénéficiaire, {D.annees[0]} et {D.annees[-1]} (Md€ courants)")
    legende(fig, ncol=3)
    return fig


def section_beneficiaires(D: Donnees) -> list:
    """Répartition de la charge d'intérêts entre ses bénéficiaires (calculée par
    le modèle Lean, `Hypotheses/DetentionDette.lean`) ; ratios d'affichage ici."""
    a0, a1 = D.annees[0], D.annees[-1]
    meta = D.d["beneficiairesInterets"]
    bens = beneficiaires_meta(D)
    pf = meta["portefeuilleBdfMeur"]
    st = meta["structureDixMilliemes"]
    t0, t1 = D.traj("central", None)[0], D.fin("central", None)

    def part(e, bid):
        return e["interetsBeneficiaires"][bid] * 100 / e["chargeInterets"]

    intro = (
        "Les intérêts de la dette publique sont versés à ceux qui détiennent ses titres et ses prêts. "
        "Le modèle les répartit en deux temps. La Banque de France reçoit le rendement de son portefeuille "
        f"de titres publics français achetés de 2015 à 2022 (programmes APP et PEPP de l'Eurosystème : "
        f"{nombre(pf[0] / 1000, 0)} Md€ en moyenne en {a0}, ≈ {nombre(pf[-1] / 1000, 0)} Md€ en {a1}, "
        "au rythme des projections de l'enquête de la BCE de juin 2026, puisque les titres arrivés à échéance "
        f"ne sont plus réinvestis), à {nombre(meta['rendementBdfPb'] / 100, 2)} % (rendement de 2025). "
        "Le reste est partagé selon la structure de détention de la dette publique hors banque centrale, "
        f"fixe : non-résidents {nombre(st['nonResidents'] / 100, 1)} %, banques "
        f"{nombre(st['banques'] / 100, 1)} %, autres résidents {nombre(st['autresResidents'] / 100, 1)} % "
        f"(Banque de France : {nombre(st['banqueDeFrance'] / 100, 1)} %) de la dette totale fin 2025 "
        "(FMI, rapport sur la dette annexé au PLF 2027), ces derniers partagés entre assurances, fonds et "
        "autres comme sur la dette négociable de l'État (Agence France Trésor, premier trimestre 2026). "
        "Comme la Banque de France voit son portefeuille fondre, ce sont surtout des investisseurs non "
        f"résidents qui le remplacent : au tendanciel, leur part des intérêts passe de "
        f"{nombre(part(t0, 'nonResidents'), 0)} % en {a0} à {nombre(part(t1, 'nonResidents'), 0)} % en {a1}, "
        f"celle de la Banque de France de {nombre(part(t0, 'banqueDeFrance'), 1)} % à "
        f"{nombre(part(t1, 'banqueDeFrance'), 1)} %.")
    out = [P("Qui reçoit les intérêts", "h1"), P(intro), png(barres_beneficiaires(D))]
    rows = []
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        r = e["interetsBeneficiaires"]
        rows.append([nom, md(e["chargeInterets"], 1)] + [md(r[b["id"]], 1) for b in bens]
                    + [pct_pb(r["nonResidents"] * 10000 // e["pib"], 2)])
    courts = {"nonResidents": "Non-<br/>résidents", "banqueDeFrance": "Banque<br/>de France",
              "banques": "Banques", "assurances": "Assu-<br/>rances", "opc": "Fonds<br/>(OPC)",
              "autres": "Autres<br/>résidents"}
    entetes = [f"Scénario central, {a1}", "Total"] + \
        [P(courts.get(b["id"], echap(b["nom"])), "cellgd") for b in bens] + \
        [P("À l'étranger<br/>(% du PIB)", "cellgd")]
    out.append(Spacer(1, 3))
    out.append(tableau(entetes, rows, [0.25, 0.08] + [0.09] * len(bens) + [0.13],
                       surligner_premiere=True))
    out.append(P(
        "Tableau en Md€ courants. « Non-résidents » comprend les titres détenus en propre par la BCE "
        "(≈ 1 à 2 points de la dette) ; « À l'étranger » rapporte leurs intérêts au PIB. Une barre très "
        "au-dessus des autres est coupée au bord du graphique, son total écrit en blanc. Les intérêts "
        "reçus par la Banque de France ne restent pas chez elle : elle rémunère les réserves des banques "
        "(2,26 % en moyenne en 2025, marge nette de ses portefeuilles APP et PEPP de −12,6 Md€) et ne verse "
        "plus de dividende à l'État depuis l'exercice 2021 (impôt sur les sociétés de 1,5 Md€ en 2025). "
        "L'essentiel des intérêts reçus par les assurances revient aux assurés des fonds en euros de "
        "l'assurance-vie. Limites : la répartition suit les encours, pas les coupons (les BTF, à taux court, "
        "sont détenus à 84 % par des non-résidents ; les titres indexés, surtout par des résidents) ; aucune "
        "source officielle ne répartit les intérêts eux-mêmes par bénéficiaire. Sources : Banque de France "
        "(communiqué du 12 septembre 2026, « Comprendre les comptes 2025 »), BCE (Survey of Monetary "
        "Analysts, juin 2026), Agence France Trésor (bulletin mensuel n° 434, juillet 2026), rapport sur la "
        "dette des administrations publiques annexé au PLF 2027.", "note"))
    return out


def section_courbe(D, titre, intro, valeur, titre_fig, dec, suffixe, fmt_table,
                   note=None, ecart=False, reference=None, valeur_table=None):
    out = [P(titre, "h1"), P(intro)]
    for g in D.groupes:
        out.append(png(courbes(D, g, valeur, titre_fig, dec, suffixe, ecart=ecart,
                               reference=reference)))
    ans = [D.annees[2], D.annees[5], D.annees[-1]]
    idx = [D.annees.index(a) for a in ans]
    vt = valeur_table or valeur
    rows = [[nom] + [fmt_table(vt(D.traj("central", pid)[i])) for i in idx]
            for pid, nom in D.lignes()]
    out.append(Spacer(1, 3))
    out.append(tableau(["Scénario central"] + [str(a) for a in ans], rows,
                       [0.46] + [0.54 / len(ans)] * len(ans), surligner_premiere=True))
    if note:
        out.append(P(note, "note"))
    else:
        out.append(Spacer(1, 6))
    return out


def pib_volume(e: dict, base: dict) -> float:
    """PIB en volume, M€ de l'année de départ : PIB nominal déflaté par l'indice
    des prix de la même trajectoire (base 10 000 l'année de départ)."""
    indice = e.get("indicePrix") or base.get("indicePrix") or 10000
    return e["pib"] * (base.get("indicePrix") or 10000) / indice


def section_pib_volume(D):
    """Évolution du PIB en volume, à côté du déficit et de la dette, avec la
    croissance annuelle moyenne de chaque programme sur la période."""
    a0, a1 = D.annees[0], D.annees[-1]
    base = D.traj("central", None)[0]
    titre_fig = f"PIB en volume (Md€ de {a0}), scénario central"
    out = section_courbe(
        D, "PIB",
        f"Évolution du PIB de chaque programme et du tendanciel, en volume : PIB nominal "
        f"déflaté par l'indice des prix de la trajectoire, en Md€ de {a0}.",
        lambda e: pib_volume(e, base) / 1000, titre_fig, 0, "",
        lambda v: md(v), valeur_table=lambda e: pib_volume(e, base))
    # croissance annuelle moyenne en volume, de l'entrée en vigueur à la fin
    i0 = 1 if len(D.annees) > 2 else 0
    n = len(D.annees) - 1 - i0
    morceaux = []
    for pid, nom in D.lignes():
        t = D.traj("central", pid)
        v0, v1 = pib_volume(t[i0], base), pib_volume(t[-1], base)
        if n > 0 and v0 > 0:
            g = ((v1 / v0) ** (1 / n) - 1) * 100
            morceaux.append(f"{echap(nom)} : {signe(g, 2)}{NBSP}%")
    note = (f"Tableau en Md€ de {a0}. Croissance annuelle moyenne en volume de "
            f"{D.annees[i0]} à {a1} : " + " ; ".join(morceaux) + ".")
    out[-1] = P(note, "note")
    return out


def correlation(xs: list, ys: list) -> float:
    """Coefficient de corrélation de Pearson (statistique d'affichage)."""
    n = len(xs)
    if n < 3:
        return float("nan")
    mx, my = sum(xs) / n, sum(ys) / n
    sxy = sum((a - mx) * (b - my) for a, b in zip(xs, ys))
    sxx = sum((a - mx) ** 2 for a in xs)
    syy = sum((b - my) ** 2 for b in ys)
    return sxy / (sxx * syy) ** 0.5 if sxx > 0 and syy > 0 else float("nan")


def nuage_deficit_chomage(D: Donnees):
    """Déficit et chômage : un point par programme en fin de période (et le
    tendanciel), avec le chemin parcouru depuis l'entrée en vigueur."""
    fig, ax = figure(3.6)
    a1 = D.annees[-1]
    pts = []
    for pid, nom in D.lignes():
        t = D.traj("central", pid)
        xs = [e["chomagePb"] / 100 for e in t[2:]]
        ys = [e["deficitPb"] / 100 for e in t[2:]]
        c = TENDANCIEL if pid is None else D.couleur[pid]
        mk = "s" if pid is None else D.marqueur[pid]
        ax.plot(xs, ys, color=c, lw=0.7, alpha=0.45, zorder=2)
        ax.plot([xs[-1]], [ys[-1]], mk, ms=5.5, color=c, mec="white", mew=1.0, zorder=3)
        # étiquettes voisines décalées verticalement pour ne pas se chevaucher
        voisins = sum(1 for (x0, y0) in pts if abs(x0 - xs[-1]) < 0.35 and abs(y0 - ys[-1]) < 0.45)
        ax.annotate(court_nom("Tendanciel" if pid is None else nom, 22), (xs[-1], ys[-1]),
                    xytext=(4, 2 - 8 * voisins), textcoords="offset points", fontsize=6.2, color=INK2)
        pts.append((xs[-1], ys[-1]))
    r = correlation([p[0] for p in pts], [p[1] for p in pts])
    ax.set_xlabel(f"Taux de chômage {a1} (%)")
    ax.set_ylabel(f"Déficit public {a1} (% du PIB)")
    ax.xaxis.set_major_formatter(fmt_axe(1, NBSP + "%"))
    ax.yaxis.set_major_formatter(fmt_axe(1, NBSP + "%"))
    ax.set_title(f"Déficit et chômage, scénario central (chemin 2027-{a1}, point = {a1})")
    return fig, r


def section_deficit_chomage(D: Donnees) -> list:
    a1 = D.annees[-1]
    fig, r = nuage_deficit_chomage(D)
    out = [P("Déficit et chômage", "h1"),
           P("Le chômage pèse sur le déficit par deux canaux : les recettes, qui suivent l'activité, et "
             "l'indemnisation, que le modèle ajuste chaque année au nombre de chômeurs (≈ 10 000 € par "
             "chômeur supplémentaire, assurance chômage et solidarité ; stabilisateur automatique). Le "
             "solde réagit ainsi de ≈ 0,57 point par point de PIB, la valeur des lois de programmation. "
             "En sens inverse, une consolidation budgétaire réduit l'activité et relève le chômage. Le "
             "graphe place chaque programme selon son chômage et son déficit."),
           png(fig),
           P(f"Corrélation entre déficit et chômage en {a1} d'un programme à l'autre (coefficient de "
             f"Pearson, statistique d'affichage) : {nombre(r, 2)}. Une corrélation négative signale que "
             "les programmes qui réduisent le plus le déficit le font au prix d'un chômage plus élevé ; "
             "elle ne dit rien de la causalité.", "note")]
    return out


def section_emploi(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    secs = D.secteurs
    out = [P("Emploi par secteur", "h1"),
           P("Répartition des personnes en emploi entre les cinq grands secteurs de l'INSEE. "
             "Une dépense ciblée sur un secteur (levier « dépense sectorielle ») y place les emplois "
             "qu'elle crée ; les autres effets (âge légal, SMIC, demande générale) se répartissent "
             "au prorata de la structure de l'emploi.")]
    for g in D.groupes:
        out.append(png(barres_secteurs(D, g)))
    larg = [0.25, 0.085, 0.1, 0.09, 0.12, 0.12, 0.11, 0.125]
    ent = ["Emploi (milliers)"] + [SECTEURS_TAB.get(s["id"], s["nom"]) for s in secs] \
        + ["Total", "Part industrie"]

    def rangee(nom, e):
        return [nom] + [nombre(e["emploi"][s["id"]] / 1000) for s in secs] \
            + [nombre(e["emploiTotal"] / 1000),
               nombre(e["emploi"]["industrie"] * 100 / e["emploiTotal"], 2) + NBSP + "%"]

    rows = [rangee(f"Situation de départ ({a0})", D.traj("central", None)[0])]
    rows += [rangee(f"{nom} ({a1})", D.fin("central", pid)) for pid, nom in D.lignes()]
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, larg))
    base = D.fin("central", None)["emploi"]
    ent2 = [f"Écart au tendanciel en {a1} (emplois)"] + [SECTEURS_TAB.get(s["id"], s["nom"]) for s in secs] + ["Total"]
    rows2 = []
    for p in D.progs:
        e = D.fin("central", p["id"])["emploi"]
        ds = [e[s["id"]] - base[s["id"]] for s in secs]
        rows2.append([nom_court(p["nom"])] + [signe(v, 0) for v in ds] + [signe(sum(ds), 0)])
    out.append(Spacer(1, 6))
    out.append(tableau(ent2, rows2, [0.25, 0.1, 0.11, 0.11, 0.13, 0.15, 0.15]))
    e0 = D.traj("central", None)[0]
    out.append(P("Emploi au sens du BIT. Structure de départ : estimations d'emploi INSEE 2024 "
                 f"par secteur, appliquées à l'emploi {a0} ({nombre(e0['actifs'] / 1e6, 1)} millions "
                 f"d'actifs, chômage {pct_pb(e0['chomagePb'])}). "
                 "Agric. : agriculture ; Constr. : construction ; Tert. march. / non m. : tertiaire "
                 "marchand / non marchand.", "note"))
    return out


def section_impots(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    imp = D.impots
    out = [P("Impôts et taxes majeurs", "h1"),
           P("Les recettes publiques sont suivies par grand prélèvement, chacun sur son assiette : "
             "masse salariale pour les cotisations, la CSG et l'impôt sur le revenu (barème revalorisé "
             "de l'inflation passée, progressivité sur la hausse réelle des revenus) ; consommation "
             "des ménages pour la TVA ; bénéfice fiscal et règles d'acomptes pour l'IS ; volume de "
             "carburants pour les accises, fixées en euros par litre et érodées par l'électrification "
             "du parc ; valeurs locatives revalorisées par la loi pour la taxe foncière ; transactions "
             "immobilières pour les DMTO ; flux successoral (hausse des décès, patrimoine transmis, "
             "abattements non indexés) pour les droits de succession, ≈ 5 % par an au scénario "
             "central. Une mesure fiscale s'impute sur le prélèvement qu'elle "
             "vise (levier « prélèvement sur ») ou, faute de précision dans le programme, sur « autres "
             "impôts » (patrimoine, taxes diverses) ; les effets d'activité se répartissent au prorata.")]
    out.append(png(structure_impots(D)))
    for g in D.groupes:
        out.append(png(petits_multiples_impots(D, g)))
    larg = [0.15] + [0.068] * len(imp) + [0.10]
    ent = [f"Recettes {a1} (Md€)"] + [COURTS_TAB.get(i["id"], i["nom"]) for i in imp] + ["Prélèv. oblig."]
    rows = [[nom] + [md(D.fin("central", pid)["impots"][i["id"]], 1) for i in imp]
            + [md(impots_total(D.fin("central", pid)), 1)] for pid, nom in D.lignes()]
    out.append(KeepTogether([Spacer(1, 3), tableau(ent, rows, larg, surligner_premiere=True)]))
    base = D.fin("central", None)
    ent2 = [f"Écart au tendanciel {a1} (Md€)"] + [COURTS_TAB.get(i["id"], i["nom"]) for i in imp] + ["Prélèv. oblig."]
    rows2 = []
    for p in D.progs:
        e = D.fin("central", p["id"])
        rows2.append([nom_court(p["nom"])]
                     + [signe((e["impots"][i["id"]] - base["impots"][i["id"]]) / 1000, 1) for i in imp]
                     + [signe((impots_total(e) - impots_total(base)) / 1000, 1)])
    out.append(KeepTogether([Spacer(1, 6), tableau(ent2, rows2, larg)]))
    out.append(P(f"CSG : CSG et CRDS ; Cotis. : cotisations sociales ; IS : impôt sur les sociétés ; "
                 f"Accise : accise sur les énergies (TICPE) ; T. fonc. : taxe foncière ; Succ. : droits de succession et de donation ; "
                 f"DMTO : droits de mutation à titre onéreux ; Patr. : impôts sur le patrimoine (IFI, fortune) ; Prélèv. oblig. : "
                 f"somme des colonnes (hors recettes non fiscales). Situation de "
                 f"départ {a0} : INSEE, comptes des administrations publiques 2025 ; DGCL (taxe "
                 "foncière) ; ministère de la Transition écologique (accise, dernier chiffre publié : "
                 "2022). Rendements nets des pertes dues aux comportements (fuite fiscale).", "note"))
    return out


def section_petrole(D: Donnees) -> list:
    a1 = D.annees[-1]
    out = [P("Sensibilité au prix du pétrole", "h1"),
           P(f"Trois prix du Brent : {D.brent('petrole-bas')} $, {D.brent('central')} $ (référence, "
             f"prix figé par l'INSEE pour 2026) et {D.brent('petrole-haut')} $ (choc). Chaque hausse "
             f"de 10 $ coûte {nombre(-D.var['central']['effetPibPar10DollarsPb'] / 100, 2)} % de PIB "
             "l'année de départ (INSEE : −0,2 à −0,3 %) ; l'effet se propage aux recettes et à "
             "l'emploi.")]
    champs = [("deficitPb", f"Déficit public en {a1} (% du PIB)", 1, NBSP + "%", lambda v: v / 100),
              ("chomagePb", f"Chômage en {a1} (%)", 1, NBSP + "%", lambda v: v / 100)]
    out.append(png(points_petrole(D, champs)))
    prix = " / ".join(str(D.brent(v)) for v in ("petrole-bas", "central", "petrole-haut"))
    ent = [f"{a1}, Brent à {prix} $", "PIB (Md€)", "Déficit public (%)", "Dette (%)", "Chômage (%)"]
    rows = []
    for pid, nom in D.lignes():
        es = [D.fin(v, pid) for v in ("petrole-bas", "central", "petrole-haut")]
        rows.append([nom, " / ".join(md(e["pib"]) for e in es),
                     " / ".join(nombre(e["deficitPb"] / 100, 1) for e in es),
                     " / ".join(nombre(e["dettePb"] / 100, 0) for e in es),
                     " / ".join(nombre(e["chomagePb"] / 100, 1) for e in es)])
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.28, 0.22, 0.17, 0.16, 0.17], surligner_premiere=True))
    out.append(P("Déficit et dette en % du PIB, chômage en % des actifs. Effet de niveau uniquement : "
                 "pas d'effet modélisé sur l'inflation, la facture énergétique ou le rendement de "
                 "l'accise.", "note"))
    return out


def section_natalite(D: Donnees) -> list:
    a1 = D.annees[-1]
    out = [P("Sensibilité à la natalité", "h1"),
           P(f"Trois hypothèses de fécondité : {D.icf('natalite-basse')} enfant par femme "
             f"(poursuite de la baisse), {D.icf('central')} (niveau de 2025) et "
             f"{D.icf('natalite-haute')} (niveau de 2014). Sur dix ans, la natalité modifie la "
             "population, donc le PIB par habitant, mais pas encore la population active.")]
    out.append(png(courbes_natalite(D)))
    ent = [f"PIB par habitant en {a1} (€)", "Natalité basse", "Centrale", "Haute"]
    rows = [[nom] + [nombre(D.fin(v, pid)["pibParHabitant"])
                     for v in ("natalite-basse", "central", "natalite-haute")]
            for pid, nom in D.lignes()]
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.46, 0.18, 0.18, 0.18], surligner_premiere=True))
    naiss = " / ".join(nombre(D.var[v]["naissancesMilliers"] * 1000)
                       for v in ("natalite-basse", "central", "natalite-haute"))
    out.append(P(f"Naissances par an : {naiss} (2025 : 645 000, INSEE, bilan démographique 2025 ; "
                 "variantes mises à l'échelle de la fécondité). Décès et solde migratoire de 2025 "
                 "prolongés.", "note"))
    return out


def points_moteurs(D: Donnees, champs):
    """Valeur en 2035 selon le moteur : un point par moteur et par ligne."""
    lignes = D.lignes()
    fig, axes = figure(0.24 * len(lignes) + 0.9, 1, len(champs), sharey=True)
    couleurs = SERIES[:len(D.moteurs)]
    for ax, (champ, titre, dec, suffixe, tr) in zip(axes, champs):
        for k, (pid, _nom) in enumerate(lignes):
            vals = [tr(D.fin("central", pid, m["id"])[champ]) for m in D.moteurs]
            ax.plot([min(vals), max(vals)], [k, k], color=BASE, lw=1.2, zorder=2)
            for m, val, c in zip(D.moteurs, vals, couleurs):
                ax.plot([val], [k], "o", ms=5.5, color=c, mec="white", mew=1.0, zorder=3,
                        label=f"Moteur « {m['nom']} »" if k == 0 else None)
        ax.set_title(titre, fontsize=8)
        ax.grid(axis="y", visible=False)
        ax.grid(axis="x", visible=True)
        ax.xaxis.set_major_formatter(fmt_axe(dec, suffixe))
        ax.xaxis.set_major_locator(MaxNLocator(4))
        ax.set_ylim(len(lignes) - 0.5, -0.5)
    axes[0].set_yticks(range(len(lignes)), [n for _, n in lignes])
    axes[0].tick_params(axis="y", labelcolor=INK2, labelsize=7.2)
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="outside lower left", ncol=2, handlelength=1.0)
    return fig


def barres_effets(D: Donnees):
    """Écart de PIB en 2035 dû à chaque programme, sous les deux moteurs."""
    progs = D.progs
    fig, ax = figure(0.3 * len(progs) + 0.9)
    pas = 0.8 / max(1, len(D.moteurs))
    couleurs = SERIES[:len(D.moteurs)]
    for j, (m, c) in enumerate(zip(D.moteurs, couleurs)):
        vals = [next(e["pibPb"] for e in p["effetTotal"] if e["moteur"] == m["id"]) / 100 for p in progs]
        ys = [i + (j - (len(D.moteurs) - 1) / 2) * pas for i in range(len(progs))]
        ax.barh(ys, vals, height=pas * 0.84, color=c, label=f"Moteur « {m['nom']} »", zorder=3)
    ax.set_yticks(range(len(progs)), [nom_court(p["nom"]) for p in progs])
    ax.set_ylim(len(progs) - 0.5, -0.5)
    ax.tick_params(axis="y", labelcolor=INK2, labelsize=7.5)
    ax.grid(axis="y", visible=False)
    ax.grid(axis="x", visible=True)
    ax.axvline(0, color=BASE, lw=0.8, zorder=2)
    ax.xaxis.set_major_formatter(fmt_axe(1, NBSP + "%"))
    ax.set_title(f"Écart de PIB au tendanciel en {D.annees[-1]}, programme complet, scénario central")
    legende(fig, ncol=3)
    return fig


def section_effets(D: Donnees) -> list:
    a1 = D.annees[-1]
    mids = [m["id"] for m in D.moteurs]
    out = [P("Effet de chaque mesure sur la croissance", "h1"),
           P(f"Chaque mesure est appliquée seule (avec ses lignes liées, O-150 et O-150b…, comptées "
             f"ensemble sur la première), projetée jusqu'en {a1} au scénario central, et "
             "comparée au tendanciel : écart de PIB (en % du PIB tendanciel), de déficit (en points "
             "de PIB) et d'emploi. Les effets ne s'additionnent pas exactement (interactions, arrondis). "
             "Sous le moteur « demande », une dépense accroît le PIB par le bloc de demande (effet "
             "propre à son canal, qui monte puis s'estompe avec les prix) et une économie le réduit "
             "d'autant ; sous le moteur « offre », une économie pèse moitié moins et une baisse de "
             "prélèvements relève la croissance potentielle."),
           png(barres_effets(D))]
    nm = len(D.moteurs)
    ent = ["Mesure"] + [f"PIB — {m['nom']}" for m in D.moteurs] \
        + [f"Déficit — {D.nom_moteur(D.standard)}", f"Emplois — {D.nom_moteur(D.standard)}",
           "Solde courant (Md€)"]
    larg = [0.40 if nm <= 2 else 0.31] + [(0.60 if nm <= 2 else 0.69) / (nm + 3)] * (nm + 3)
    for p in D.progs:
        par = {(e["moteur"], e["mesure"]): e for e in p["effetsMesures"]}
        rows = []
        for m in p["mesures"]:
            es = [par[(mid, m["id"])] for mid in mids]
            st = par[(D.standard, m["id"])]
            if st.get("compteAvec"):
                continue
            rows.append([f"{m['id']} {court_nom(m['titre'], 70)}"]
                        + [signe(e["pibPb"] / 100, 2) + NBSP + "%" for e in es]
                        + [signe(st["deficitPb"] / 100, 2), signe(st["emplois"], 0),
                           signe(st.get("balanceCourante", 0) / 1000, 1)])
        tot = {e["moteur"]: e for e in p["effetTotal"]}
        e_t = D.fin("central", p["id"])
        rows.append(["Programme complet"]
                    + [signe(tot[mid]["pibPb"] / 100, 2) + NBSP + "%" for mid in mids]
                    + [signe(tot[D.standard]["deficitPb"] / 100, 2), signe(tot[D.standard]["emplois"], 0),
                       signe((e_t["balanceCourante"] - D.fin("central", None)["balanceCourante"]) / 1000, 1)])
        out.append(KeepTogether([P(echap(nom_court(p["nom"])), "h2"), tableau(ent, rows, larg)]))
    out.append(P("Déficit : écart en points de PIB (positif = déficit creusé). Les mesures d'âge de "
                 "départ, de SMIC et de durée du travail agissent sur le PIB par le volume d'heures ; "
                 "les économies et dépenses par l'effet de demande du moteur.", "note"))
    out += section_variantes(D)
    return out


def section_variantes(D: Donnees) -> list:
    progs = [p for p in D.progs if p.get("effetsVariantes")]
    if not progs:
        return []
    a1 = D.annees[-1]
    out = [CondPageBreak(90 * mm), P("Variantes des mesures", "h2"),
           P(f"Programme complet dont une mesure prend les leviers de sa variante, comparé au programme "
             f"retenu : déficit {a1} du programme avec la variante, écarts de déficit (points de PIB), "
             f"de PIB et d'emploi. Moteur « {D.nom_moteur(D.standard)} », scénario central.")]
    ent = ["Mesure et variante", f"Déficit {a1}", "Écart déficit", "Écart PIB", "Écart emplois",
           f"Chômage {a1}"]
    larg = [0.46, 0.10, 0.11, 0.11, 0.12, 0.10]
    for p in progs:
        rows = [[f"{v['mesure']} — {court_nom(v['variante'], 70)}", pct_pb(v["deficitPb"]),
                 signe(v["ecartDeficitPb"] / 100, 2), signe(v["ecartPibPb"] / 100, 2) + NBSP + "%",
                 signe(v["ecartEmplois"], 0), pct_pb(v["chomagePb"])] for v in p["effetsVariantes"]]
        out.append(KeepTogether([P(echap(nom_court(p["nom"])), "h2"), tableau(ent, rows, larg)]))
    return out


def court_nom(nom: str, n: int = 34) -> str:
    return nom if len(nom) <= n else nom[: n - 1] + "…"


FONCTIONS_COURT = {"retraites": "Retraites", "sante": "Santé", "famille": "Famille, chômage, exclusion",
                   "enseignement": "Enseignement, recherche", "affairesEconomiques": "Affaires éco., transports",
                   "defense": "Défense", "securiteJustice": "Sécurité, justice",
                   "logementEnvironnement": "Logement, environnement", "culture": "Culture, sport",
                   "interets": "Charge d'intérêts", "fonctionnement": "Services généraux, coll., UE",
                   "nonVentile": "Non ventilé"}


def structure_fonctions(D: Donnees):
    e = D.traj("central", None)[0]
    fs = sorted(D.fonctions, key=lambda f: e["depensesParFonction"][f["id"]], reverse=True)
    fs = [f for f in fs if e["depensesParFonction"][f["id"]] > 0]
    vals = [e["depensesParFonction"][f["id"]] / 1000 for f in fs]
    fig, ax = figure(2.5)
    ax.barh(range(len(fs)), vals, height=0.58, color=SERIES[0], zorder=3)
    ax.set_yticks(range(len(fs)), [FONCTIONS_COURT.get(f["id"], f["nom"]) for f in fs])
    ax.set_ylim(len(fs) - 0.5, -0.5)
    ax.tick_params(axis="y", labelcolor=INK2, labelsize=7.2)
    ax.grid(axis="y", visible=False)
    ax.grid(axis="x", visible=True)
    for k, v in enumerate(vals):
        ax.annotate(nombre(v, 0), (v, k), xytext=(3, 0), textcoords="offset points",
                    va="center", fontsize=6.8, color=INK2)
    ax.set_xlim(0, max(vals) * 1.1)
    ax.xaxis.set_major_formatter(fmt_axe(0, ""))
    ax.set_title(f"Dépenses publiques par fonction en {D.annees[0]} (Md€, nomenclature COFOG agrégée)")
    return fig


GROUPES_CONTRIB = [("Charge d'intérêts", ["interets"]), ("Retraites", ["retraites"]),
                   ("Santé", ["sante"]), ("Autres dépenses primaires", None), ("Recettes", "recettes")]


def contributions(e0: dict, e1: dict, D: Donnees) -> list[dict]:
    """Décomposition exacte de la variation du ratio déficit/PIB entre deux
    états, en points de PIB. Pour chaque poste x (dépense : signe +, recette :
    signe −) on a l'identité
        Δ(x/Y) = (x1 − x0)/Y1  +  x0·(1/Y1 − 1/Y0)
                 (volume)         (dénominateur)
    et la somme des contributions est exactement Δ(déficit/Y) puisque
    déficit = Σ dépenses par fonction − Σ impôts − autres recettes."""
    y0, y1 = e0["pib"], e1["pib"]

    def terme(cle, nom, x0, x1, s):
        vol = s * (x1 - x0) / y1 * 100
        den = s * x0 * (1 / y1 - 1 / y0) * 100
        return {"cle": cle, "nom": nom, "ecart": s * (x1 - x0), "volume": vol, "denominateur": den,
                "contribution": vol + den}

    out = []
    for f in D.fonctions:
        out.append(terme(f["id"], "Dépenses : " + FONCTIONS_COURT.get(f["id"], f["nom"]),
                         e0["depensesParFonction"][f["id"]], e1["depensesParFonction"][f["id"]], 1))
    for i in D.impots:
        out.append(terme("impot:" + i["id"], "Recettes : " + i["nom"], e0["impots"][i["id"]],
                         e1["impots"][i["id"]], -1))
    out.append(terme("autresRecettes", "Recettes non fiscales", e0["autresRecettes"], e1["autresRecettes"], -1))
    return out


def deficit_pct(e: dict) -> float:
    return (e["depenses"] - e["recettes"]) / e["pib"] * 100


def regrouper(contribs: list[dict]) -> list[float]:
    """Agrège les contributions selon GROUPES_CONTRIB (somme exacte conservée)."""
    vals = []
    for _nom, cles in GROUPES_CONTRIB:
        if cles == "recettes":
            vals.append(sum(c["contribution"] for c in contribs if c["cle"].startswith("impot:")
                            or c["cle"] == "autresRecettes"))
        elif cles is None:
            pris = {k for _n, ks in GROUPES_CONTRIB if isinstance(ks, list) for k in ks}
            vals.append(sum(c["contribution"] for c in contribs
                            if not c["cle"].startswith("impot:") and c["cle"] != "autresRecettes"
                            and c["cle"] not in pris))
        else:
            vals.append(sum(c["contribution"] for c in contribs if c["cle"] in cles))
    return vals


def barres_contributions(D: Donnees):
    """Deux panneaux : variation du déficit sur la période (tendanciel et
    programmes) et écart au tendanciel en fin de période (programmes),
    décomposés en contributions exactes (points de PIB)."""
    a0, a1 = D.annees[0], D.annees[-1]
    base1 = D.fin("central", None)
    panneaux = [
        (f"Variation {a0} → {a1}", D.lignes(),
         lambda pid: contributions(D.traj("central", pid)[0], D.fin("central", pid), D)),
        (f"Écart au tendanciel {a1}", [(p["id"], nom_court(p["nom"])) for p in D.progs],
         lambda pid: contributions(base1, D.fin("central", pid), D)),
    ]
    n = len(D.lignes())
    fig, axes = figure(0.26 * n + 1.3, 1, 2)
    couleurs = [SERIES[6], SERIES[1], SERIES[3], SERIES[0], SERIES[2]]
    for ax, (titre, lignes, calc) in zip(axes, panneaux):
        for k, (pid, _nom) in enumerate(lignes):
            vals = regrouper(calc(pid))
            pos = neg = 0.0
            for (gnom, _), v, c in zip(GROUPES_CONTRIB, vals, couleurs):
                gauche = pos if v >= 0 else neg + v
                ax.barh(k, abs(v), left=gauche, height=0.62, color=c, zorder=3,
                        label=gnom if (k == 0 and ax is axes[0]) else None)
                if v >= 0:
                    pos += v
                else:
                    neg += v
            total = sum(vals)
            ax.plot([total, total], [k - 0.42, k + 0.42], color=INK, lw=1.4, zorder=4,
                    label="Total (= Δ déficit/PIB)" if (k == 0 and ax is axes[0]) else None)
        ax.set_yticks(range(len(lignes)), [nom for _, nom in lignes])
        ax.set_ylim(n - 0.5, -0.5)
        ax.tick_params(axis="y", labelcolor=INK2, labelsize=7.2)
        ax.grid(axis="y", visible=False)
        ax.grid(axis="x", visible=True)
        ax.axvline(0, color=BASE, lw=0.8, zorder=2)
        ax.xaxis.set_major_formatter(fmt_axe(1, NBSP + "pt"))
        ax.xaxis.set_major_locator(MaxNLocator(5))
        ax.set_xlabel("points de PIB", fontsize=7, color=INK2)
        ax.set_title(titre, fontsize=8, loc="left")
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="outside lower left", ncol=3, handlelength=1.0)
    return fig


def tableau_contributions(e0: dict, e1: dict, D: Donnees, libelle0: str, libelle1: str) -> Table:
    cs = contributions(e0, e1, D)
    d0, d1 = deficit_pct(e0), deficit_pct(e1)
    rows = [[libelle0, md(e0["depenses"] - e0["recettes"], 1), "", "", nombre(d0, 3)]]
    for c in cs:
        rows.append([c["nom"], signe(c["ecart"] / 1000, 1), signe(c["volume"], 3),
                     signe(c["denominateur"], 3), signe(c["contribution"], 3)])
    rows.append(["Somme des contributions", signe(sum(c["ecart"] for c in cs) / 1000, 1),
                 signe(sum(c["volume"] for c in cs), 3), signe(sum(c["denominateur"] for c in cs), 3),
                 signe(sum(c["contribution"] for c in cs), 3)])
    rows.append([libelle1, md(e1["depenses"] - e1["recettes"], 1), "", "", nombre(d1, 3)])
    var_pib = signe((e1["pib"] - e0["pib"]) * 100 / e0["pib"], 2)
    rows.append([f"Contrôle : Δ(déficit/PIB) − Σ contributions (PIB {var_pib}{NBSP}%)", "", "", "",
                 f"{(d1 - d0) - sum(c['contribution'] for c in cs):.1e}"])
    return tableau(["Poste (déficit creusé = +)", "Md€", "Volume", "Dénominateur", "Total (pt)"], rows,
                   [0.46, 0.13, 0.13, 0.14, 0.14])


def section_budget(D: Donnees) -> list:
    """Décomposition exacte du déficit : identité comptable en points de PIB,
    poste par poste, sans seuil ni regroupement."""
    a0, a1 = D.annees[0], D.annees[-1]
    base0, base1 = D.traj("central", None)[0], D.fin("central", None)
    out = [P("Décomposition du budget et du déficit", "h1"),
           P("Les dépenses publiques sont suivies par fonction (nomenclature COFOG agrégée) et les "
             "recettes par prélèvement. Le déficit vaut, par construction du modèle, "
             "Σ dépenses par fonction − Σ impôts − recettes non fiscales ; son ratio au PIB se "
             "décompose donc <i>exactement</i> entre postes. Pour chaque poste x, de signe + pour "
             "une dépense et − pour une recette, la variation du ratio entre deux états (Y₀, Y₁) "
             "s'écrit Δ(x/Y) = (x₁ − x₀)/Y₁ + x₀·(1/Y₁ − 1/Y₀) : le premier terme est l'effet "
             "volume (variation du poste rapportée au PIB d'arrivée), le second l'effet "
             "dénominateur (variation du PIB appliquée au poste de départ). La somme des "
             "contributions est égale à la variation du ratio de déficit, à l'arrondi flottant "
             "près, ce que la ligne de contrôle vérifie dans chaque tableau. Aucun poste n'est "
             "omis ni seuillé ; les totaux sont calculés avant arrondi d'affichage."),
           png(structure_fonctions(D)),
           png(barres_contributions(D)),
           P("Lecture : chaque barre empile les contributions signées (à droite les postes qui "
             "creusent le déficit, à gauche ceux qui le réduisent) ; le trait noir marque leur "
             "somme, égale à la variation du ratio déficit/PIB. Le panneau de gauche décompose la "
             f"dérive {a0} → {a1} de chaque trajectoire ; celui de droite décompose l'écart de "
             f"chaque programme au tendanciel en {a1}. « Autres dépenses primaires » regroupe les "
             "fonctions hors intérêts, retraites et santé ; « Recettes » somme tous les prélèvements "
             "et les recettes non fiscales.", "note")]
    out += [CondPageBreak(70 * mm), P(f"Tendanciel : variation {a0} → {a1}", "h2"),
            tableau_contributions(base0, base1, D, f"Déficit {a0}", f"Déficit {a1}")]
    for p in D.progs:
        e0, e1 = D.traj("central", p["id"])[0], D.fin("central", p["id"])
        nom = echap(nom_court(p["nom"]))
        out += [CondPageBreak(70 * mm), P(f"{nom} : variation {a0} → {a1}", "h2"),
                tableau_contributions(e0, e1, D, f"Déficit {a0}", f"Déficit {a1}"),
                CondPageBreak(70 * mm), P(f"{nom} : écart au tendanciel en {a1}", "h2"),
                tableau_contributions(base1, e1, D, f"Déficit tendanciel {a1}", f"Déficit du programme {a1}")]
    out.append(P("Scénario central, moteur « " + echap(D.nom_moteur(D.standard)) + " ». Md€ : variation "
                 "du poste en niveau (signée comme sa contribution). Volume, dénominateur et total en "
                 "points de PIB, trois décimales. Le ratio de déficit affiché ici est le quotient exact "
                 "déficit/PIB ; la valeur « deficitPb » du modèle Lean en est la troncature entière en "
                 "points de base (division entière), d'où un écart possible inférieur à 0,01 point avec "
                 "les autres sections.", "note"))
    return out


def section_heures(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    e0 = D.traj("central", None)[0]
    out = [P("Heures travaillées et productivité", "h1"),
           P(f"Volume annuel d'heures travaillées (personnes en emploi × durée effective, "
             f"{nombre(e0['heuresParEmploi'])} h par emploi en {a0}, OCDE), heures par habitant et PIB par "
             "heure travaillée. Les mesures sur l'âge de départ, le SMIC et la durée du travail "
             "changent le volume d'heures, et le PIB suit à l'élasticité du scénario (65 %, part du "
             "travail dans la valeur ajoutée) ; les effets de demande modifient le PIB par heure.")]
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: e["heuresTotalesMillions"] / 1000,
                               "Heures travaillées (milliards d'heures par an), scénario central", 1, "")))
    ent = [f"{a1}, scénario central", "Heures par emploi", "Heures par habitant", "Heures totales (Md h)",
           "PIB par heure (€)", "Écart d'heures au tendanciel"]
    base = D.fin("central", None)
    rows = [[f"Situation de départ ({a0})", nombre(e0["heuresParEmploi"]), nombre(e0["heuresParHabitant"]),
             nombre(e0["heuresTotalesMillions"] / 1000, 2), nombre(e0["pibParHeure"]), "—"]]
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        rows.append([nom, nombre(e["heuresParEmploi"]), nombre(e["heuresParHabitant"]),
                     nombre(e["heuresTotalesMillions"] / 1000, 2), nombre(e["pibParHeure"]),
                     "—" if pid is None else signe((e["heuresTotalesMillions"] - base["heuresTotalesMillions"]) * 100 / base["heuresTotalesMillions"], 2) + NBSP + "%"])
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.28, 0.13, 0.14, 0.15, 0.14, 0.16]))
    out.append(P("PIB par heure en euros courants (le PIB du modèle est nominal). Durée du travail : "
                 "OCDE, heures annuelles par personne en emploi ; la durée tendancielle est supposée "
                 "constante.", "note"))
    return out


def section_commerce(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    e0 = D.traj("central", None)[0]
    out = [P("Commerce extérieur et balance des paiements", "h1"),
           P("Exportations et importations de biens et services suivent le PIB nominal ; s'y "
             "ajoutent le contenu en importations des mesures de demande (30 %), la facture "
             "énergétique selon le prix du Brent, le carburant évité et les véhicules importés des "
             "mesures automobiles, et les recettes touristiques. Le solde courant ajoute les revenus "
             f"nets du reste du monde (−5,3 Md€ en {a0}). La propriété « balance courante non dégradée » "
             "compare le solde courant du programme, en part du PIB, à celui du tendanciel.")]
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: e["balanceCommerciale"] / 1000,
                               "Balance commerciale, biens et services (Md€), scénario central", 0, "")))
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: e["balanceCourantePb"] / 100,
                               "Solde des transactions courantes (% du PIB), scénario central", 1, NBSP + "%")))
    ent = [f"{a1}, scénario central", "Exportations (Md€)", "Importations (Md€)", "Balance commerciale",
           "Solde courant (Md€)", "Solde courant (% PIB)"]
    rows = [[f"Situation de départ ({a0})", md(e0["exportations"]), md(e0["importations"]),
             signe(e0["balanceCommerciale"] / 1000, 1), signe(e0["balanceCourante"] / 1000, 1),
             signe(e0["balanceCourantePb"] / 100, 2) + NBSP + "%"]]
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        rows.append([nom, md(e["exportations"]), md(e["importations"]), signe(e["balanceCommerciale"] / 1000, 1),
                     signe(e["balanceCourante"] / 1000, 1), signe(e["balanceCourantePb"] / 100, 2) + NBSP + "%"])
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.28, 0.14, 0.14, 0.15, 0.15, 0.14]))
    # contributions : écart d'exportations et d'importations au tendanciel, par programme
    ent2 = [f"Écart au tendanciel {a1} (Md€)", "Exportations", "Importations", "Balance commerciale",
            "Solde courant", "dont tourisme (export.)"]
    rows2 = []
    base = D.fin("central", None)
    for p in D.progs:
        e = D.fin("central", p["id"])
        rows2.append([nom_court(p["nom"]), signe((e["exportations"] - base["exportations"]) / 1000, 1),
                      signe((e["importations"] - base["importations"]) / 1000, 1),
                      signe((e["balanceCommerciale"] - base["balanceCommerciale"]) / 1000, 1),
                      signe((e["balanceCourante"] - base["balanceCourante"]) / 1000, 1),
                      signe((e["recettesTourisme"] - base["recettesTourisme"]) / 1000, 1)])
    out.append(Spacer(1, 6))
    out.append(tableau(ent2, rows2, [0.3, 0.13, 0.13, 0.16, 0.13, 0.15]))
    eh, ec = D.fin("petrole-haut", None), D.fin("central", None)
    out.append(P(f"Un Brent à {D.brent('petrole-haut')} $ dégrade le solde courant tendanciel de "
                 f"{nombre((ec['balanceCourante'] - eh['balanceCourante']) / 1000, 0)} Md€ en {a1} "
                 "(facture énergétique de 60 Md€ au prix de référence, proportionnelle au prix). "
                 "Les programmes d'économies améliorent le solde courant par moindres importations ; "
                 "les programmes de relance le dégradent. Source de départ : Banque de France, "
                 "balance des paiements, cumul 12 mois à septembre 2025.", "note"))
    return out


def section_accidents(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    var = D.var["central"]
    cu, jours, let, ue = var["coutParAccidentEuros"], var["joursPerdusParAccident"], var["letaliteAccidentsPdm"], var["tauxAccidentsUEPdm"]
    e0 = D.traj("central", None)[0]
    out = [P("Accidents du travail", "h1"),
           P(f"Le modèle suit le taux d'accidents du travail avec arrêt ({nombre(e0['tauxAccidentsPdm'])} pour "
             f"10 000 emplois en {a0}, CNAM ; moyenne de l'Union : ≈ {nombre(ue)}, Eurostat). Chaque accident "
             f"coûte {nombre(cu)} € aux finances publiques (branche AT-MP), fait perdre {nombre(jours)} journées de "
             f"travail, et {nombre(let / 100, 2)} % des accidents sont mortels. Une mesure de prévention réduit "
             "le taux : les accidents évités allègent la dépense (fonction famille-chômage), rendent des heures "
             "au PIB et évitent des décès. Propriété « accidents du travail à la norme UE ».")]
    ent = [f"{a1}, scénario central", "Taux (pour 10 000)", "Accidents / an", "Coût (Md€)",
           "Journées perdues (M)", "Décès / an", "Norme UE"]

    def ligne(nom, e, statut):
        acc = e["accidentsTravail"]
        return [nom, nombre(e["tauxAccidentsPdm"]), nombre(acc), nombre(acc * cu / 1e9, 1),
                nombre(acc * jours / 1e6, 1), nombre(acc * let / 10000), statut]

    rows = [ligne(f"Situation de départ ({a0})", e0, "")]
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        rows.append(ligne(nom, e, "" if pid is None else ("✓" if e["tauxAccidentsPdm"] <= ue else "✗")))
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.28, 0.12, 0.13, 0.11, 0.14, 0.11, 0.11], surligner_premiere=True))
    out.append(P("Sources : Assurance maladie — Risques professionnels, rapport annuel 2023 (564 000 accidents "
                 "avec arrêt, 759 décès, 13,5 Md€) ; Eurostat, accidents du travail 2022. Le coût unitaire "
                 "inclut une part de maladies professionnelles ; le coût pour les entreprises et les victimes "
                 "n'est pas compté.", "note"))
    return out


def section_europe(D: Donnees) -> list:
    n = D.d["nbScenarios"]
    textes = D.d["textesEuropeens"]
    props = [q for q in D.props if q["id"].startswith("ue-")]
    out = [P("Textes européens : les programmes les respectent-ils ?", "h1"),
           P("Chaque règle européenne est traduite en un critère vérifiable sur la trajectoire (simplification "
             "assumée, écrite avec la référence juridique). Le tableau donne, pour chaque programme et sous le "
             f"moteur « {echap(D.nom_moteur(D.standard))} », le statut au scénario central (✓/✗) et le nombre de "
             f"scénarios sur {n} où le critère est respecté. Le tendanciel lui-même ne respecte aucun des critères "
             "budgétaires : la question est si le programme fait mieux.")]
    rows = [[P(f"<b>{echap(t['titre'])}</b><br/>{echap(t['reference'])}", "cell"),
             P(echap(t["critere"]), "cell")] for t in textes]
    out.append(tableau(["Texte", "Critère vérifié"], rows, [0.55, 0.45], droite_des=9))
    out.append(Spacer(1, 6))
    ent = ["Programme"] + [PROPS_COURT.get(q["id"], q["titre"]).replace("UE : ", "") for q in props]
    rows = []
    for p in D.progs:
        r = [nom_court(p["nom"])]
        for q in props:
            ok = p["central"][D.standard][q["id"]]
            r.append(f"{'✓' if ok else '✗'}  {p['matrice'][D.standard][q['id']]}/{n}")
        rows.append(r)
    out.append(colorer_parts(tableau(ent, rows, [0.22] + [0.78 / len(props)] * len(props)),
                             {(j + 1, i + 1): p["matrice"][D.standard][q["id"]] / n
                              for i, p in enumerate(D.progs) for j, q in enumerate(props)}))
    out.append(Spacer(1, 3))
    out.append(legende_degrade(n))
    out.append(P("Les critères datés (2030, 2035) sont évalués à leur année ; les autres à l'horizon du "
                 "scénario. Les propriétés européennes figurent aussi dans la matrice complète du rapport.", "note"))
    return out


def section_constitution(D: Donnees) -> list:
    n = D.d["nbScenarios"]
    textes = D.d.get("textesConstitutionnels", [])
    props = [q for q in D.props if q["id"].startswith("constitution-")]
    if not textes or not props:
        return []
    out = [P("Constitution et lois organiques : les programmes y sont-ils conformes ?", "h1"),
           P("Normes de rang constitutionnel ou organique traduites en garde-fous chiffrés (simplification "
             "assumée, écrite avec la référence juridique et, le cas échéant, la jurisprudence du Conseil "
             "constitutionnel). Deux critères reposent sur ce que le programme déclare : le taux marginal "
             "maximal qu'il crée et les révisions de la Constitution qu'il exige. Une propriété perdue ne vaut pas "
             "inconstitutionnalité : elle signale ce qu'un juge ou le Haut Conseil des finances publiques examinerait. "
             f"Statut au scénario central (✓/✗) et nombre de scénarios sur {n} où le critère est respecté, "
             f"moteur « {echap(D.nom_moteur(D.standard))} ».")]
    rows = [[P(f"<b>{echap(t['titre'])}</b><br/>{echap(t['reference'])}", "cell"),
             P(echap(t["critere"]), "cell")] for t in textes]
    out.append(tableau(["Texte", "Critère vérifié"], rows, [0.55, 0.45], droite_des=9))
    out.append(Spacer(1, 6))
    ent = ["Programme"] + [PROPS_COURT.get(q["id"], q["titre"]) for q in props]
    rows = []
    for p in D.progs:
        r = [nom_court(p["nom"])]
        for q in props:
            ok = p["central"][D.standard][q["id"]]
            r.append(f"{'✓' if ok else '✗'}  {p['matrice'][D.standard][q['id']]}/{n}")
        rows.append(r)
    out.append(colorer_parts(tableau(ent, rows, [0.22] + [0.78 / len(props)] * len(props)),
                             {(j + 1, i + 1): p["matrice"][D.standard][q["id"]] / n
                              for i, p in enumerate(D.progs) for j, q in enumerate(props)}))
    out.append(Spacer(1, 3))
    out.append(legende_degrade(n))
    out.append(P("Le solde structurel corrige le déficit de l'écart de production (écart de départ, trajectoire du "
                 "scénario et effets de demande des mesures), à la semi-élasticité de 0,57 ; l'écart de production "
                 "nourrit aussi l'inflation (courbe de Phillips, pente de 0,1). Les propriétés constitutionnelles "
                 "figurent aussi dans la matrice complète du rapport.", "note"))
    return out


def section_main_doeuvre(D: Donnees) -> list:
    """Population active, immigration, emplois annoncés : la promesse tient-elle dans les bras disponibles ?"""
    a0, a1 = D.annees[0], D.annees[-1]
    var = D.var["central"]
    fr = var["chomageFrictionnelPb"]
    base = D.fin("central", None)
    e0 = D.traj("central", None)[0]
    out = [P("Population active, immigration et emplois annoncés", "h1"),
           P("Un programme ne peut pas créer plus d'emplois qu'il n'y a de personnes pour les occuper. "
             "La population active suit la démographie hors migrations (vieillissement, taux "
             f"d'activité), le solde migratoire ({nombre(var['soldeMigratoireMilliers'])} 000 par an, dont "
             f"{nombre(var['partActiveMigrantsPm'] / 10)}{NBSP}% d'actifs) corrigé de la politique migratoire du "
             "programme, et l'âge de départ. L'emploi maximal est celui qu'autorise le chômage frictionnel "
             f"({pct_pb(fr)}). La propriété « emplois annoncés réalisables » exige que l'emploi tendanciel plus "
             "les emplois que le programme annonce créer tiennent sous ce maximum.")]
    ent = [f"{a1}, scénario central", "Actifs (M)", "Solde migr. /an", "Emploi max. (M)", "Emplois annoncés",
           "Marge (milliers)", "ETP (M)", "Réalisable"]
    rows = [[f"Situation de départ ({a0})", nombre(e0["actifs"] / 1e6, 2), nombre(var["soldeMigratoireMilliers"] * 1000),
             nombre(e0["actifs"] * (10000 - fr) / 1e10, 2), "—",
             nombre((e0["actifs"] * (10000 - fr) // 10000 - e0["emploiTotal"]) / 1000), nombre(e0["emploisEtp"] / 1e6, 2), ""]]
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        maxi = e["actifs"] * (10000 - fr) // 10000
        marge = maxi - base["emploiTotal"] - e["emploisAnnonces"]
        rows.append([nom, nombre(e["actifs"] / 1e6, 2),
                     nombre((var["soldeMigratoireMilliers"] + e["migrationAnnuelleMilliers"]) * 1000),
                     nombre(maxi / 1e6, 2), nombre(e["emploisAnnonces"]) if e["emploisAnnonces"] else "—",
                     signe(marge / 1000, 0), nombre(e["emploisEtp"] / 1e6, 2),
                     "" if pid is None else ("✓" if marge >= 0 else "✗")])
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.25, 0.09, 0.11, 0.11, 0.12, 0.11, 0.09, 0.12], surligner_premiere=True))
    out.append(P("Marge = emploi maximal du programme − emploi tendanciel − emplois annoncés. Une marge "
                 "négative signifie que le programme repose sur plus de bras qu'il n'en aura : il lui "
                 "faudrait relever le taux d'activité, l'immigration ou l'âge de départ. ETP : équivalents "
                 "temps plein à 1 607 h. Les emplois annoncés sont ceux que les programmes déclarent "
                 "(levier `annonceEmplois`) ; ils n'agissent pas sur le modèle.", "note"))
    return out


def section_moteurs(D: Donnees) -> list:
    a1 = D.annees[-1]
    out = [P("Moteurs : deux lectures des mêmes mesures", "h1"),
           P("Le dépôt évalue chaque programme sous plusieurs moteurs, c'est-à-dire plusieurs jeux "
             "de règles d'interprétation des leviers, avec les mêmes hypothèses de scénario. "
             + " ".join(f"<b>{echap(m['nom'])}</b> : {echap(m['description'].lower())}." for m in D.moteurs)
             + " Les autres sections de ce document utilisent le moteur « "
             + echap(D.nom_moteur(D.standard)) + " ».")]
    champs = [("deficitPb", f"Déficit {a1} (% PIB)", 1, NBSP + "%", lambda v: v / 100),
              ("dettePb", f"Dette {a1} (% PIB)", 0, NBSP + "%", lambda v: v / 100),
              ("chomagePb", f"Chômage {a1} (%)", 1, NBSP + "%", lambda v: v / 100)]
    out.append(png(points_moteurs(D, champs)))
    ent = [f"{a1}, scénario central"]
    for m in D.moteurs:
        ent += [f"Déficit — {m['nom']}", f"Dette — {m['nom']}", f"Chômage — {m['nom']}"]
    rows = []
    for pid, nom in D.lignes():
        r = [nom]
        for m in D.moteurs:
            e = D.fin("central", pid, m["id"])
            r += [pct_pb(e["deficitPb"]), pct_pb(e["dettePb"], 0), pct_pb(e["chomagePb"])]
        rows.append(r)
    nb = 3 * len(D.moteurs)
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.24] + [0.76 / nb] * nb, surligner_premiere=True))
    out.append(P("Déficit et dette en % du PIB, chômage en % des actifs. L'écart entre moteurs mesure "
                 "la sensibilité d'un programme aux hypothèses de mécanisme, indépendamment des "
                 "hypothèses de scénario. Les moteurs contribués (dossier `Moteurs/`) s'ajoutent "
                 "aux deux moteurs du socle.", "note"))
    mult = D.d.get("multiplicateurs")
    if mult:
        horizons = (1, 2, 3, 5, 10)
        rows = [[echap(v["nom"])] + [nombre(v["pibPpm"][h - 1] / 10000, 2) for h in horizons]
                for v in mult]
        out += [CondPageBreak(70 * mm), P("Multiplicateurs par canal et délais de diffusion", "h2"),
                P("Le PIB est calculé par la demande (consommation, investissement, dépense publique, "
                  "exportations, importations), chaque composante par sa propre équation (coefficients "
                  "de Mésange, e-mod.fr et FR-BDF). Le multiplicateur en résulte : il diffère selon le "
                  "canal par lequel passe une mesure, monte plus ou moins vite, puis s'estompe quand les "
                  "prix et les salaires montent. Effet sur le PIB (%) d'un choc permanent d'un point de "
                  "PIB, scénario central, moteur de demande ; les tests du dépôt le comparent aux "
                  "variantes publiées de Mésange, FR-BDF et e-mod.fr."),
                tableau(["Canal"] + [f"{h} an{'s' if h > 1 else ''}" for h in horizons], rows,
                        [0.45] + [0.11] * len(horizons))]
    return out


def section_retro(D: Donnees) -> list:
    """Rétro-test : le modèle part des comptes observés de l'année précédente
    et simule l'année ; puis la même chose sans repartir des comptes."""
    r = D.d.get("retro")
    if not r or not r.get("unAn"):
        return []
    un = r["unAn"]
    multi = {x["depart"]: x["annees"] for x in r.get("plusieursAnnees", [])}
    annees = [e["annee"] for e in un]
    out = [P("Le modèle face aux comptes passés", "h1"),
           P("Pour chaque année de 2019 à 2025, le modèle part des comptes publics observés de l'année "
             "précédente et simule l'année avec la même fonction que les projections. Il reçoit ce qui "
             "n'est pas de son ressort : croissance, inflation et taux observés, marché immobilier, "
             "revalorisation légale des valeurs locatives ; mesures nouvelles de prélèvements, dépenses "
             "primaires et recettes hors prélèvements constatées. Il calcule ce qui relève de ses "
             "mécanismes : les assiettes (masse salariale, consommation, excédent des entreprises), "
             "l'évolution spontanée de chaque prélèvement sur la sienne, la charge d'intérêts, le "
             "chômage et la dette. L'écart au déficit observé mesure donc l'erreur des "
             "mécanismes, pas celle des choix budgétaires. Sources : INSEE (comptes nationaux en base "
             "2020), Cour des comptes, Agence France Trésor ; source de chaque donnée dans "
             "Hypotheses/Historique.lean.")]
    fig, ax = figure(2.6)
    ax.plot(annees, [e["deficitObservePb"] / 100 for e in un], color=TENDANCIEL, lw=1.8, marker="o",
            ms=3.5, label="Observé")
    ax.plot(annees, [e["deficitModelePb"] / 100 for e in un], color=SERIES[0], lw=1.6, marker="s",
            ms=3.5, label="Modèle, à un an")
    if multi:
        dep = min(multi)
        m = multi[dep]
        ax.plot([e["annee"] for e in m], [e["deficitModelePb"] / 100 for e in m], color=SERIES[1],
                lw=1.4, ls="--", marker="^", ms=3.5, label=f"Modèle, depuis {dep}")
    ax.set_ylabel("Déficit public (% du PIB)")
    ax.set_xticks(annees)
    ax.legend(fontsize=7, loc="upper right")
    out.append(png(fig))
    ent = ["Année", "Déficit observé", "Modèle à un an", "Écart", "Prélèvements : écart (Md€)",
           "Intérêts : modèle / observé (Md€)", "Chômage : modèle / observé"]
    rows = []
    for e in un:
        rows.append([str(e["annee"]), pct_pb(e["deficitObservePb"], 2), pct_pb(e["deficitModelePb"], 2),
                     ("+" if e["deficitModelePb"] >= e["deficitObservePb"] else "−")
                     + nombre(abs(e["deficitModelePb"] - e["deficitObservePb"]) / 100, 2),
                     ("+" if e["prelevementsModele"] >= e["prelevementsObserves"] else "−")
                     + nombre(abs(e["prelevementsModele"] - e["prelevementsObserves"]) / 1000, 1),
                     nombre(e["interetsModele"] / 1000, 1) + " / " + nombre(e["interetsObserves"] / 1000, 1),
                     pct_pb(e["chomageModelePb"]) + " / " + pct_pb(e["chomageObservePb"])])
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.08, 0.13, 0.13, 0.09, 0.17, 0.22, 0.18]))
    err = [e["deficitModelePb"] - e["deficitObservePb"] for e in un]
    ierr = [e["interetsModele"] - e["interetsObserves"] for e in un]
    def ecart_pct(m, o):
        return ("+" if m >= o else "−") + nombre(abs(m - o) / o * 100, 1) + " %"
    if "masseSalarialeModele" in un[0]:
        ent_b = ["Année", "Masse salariale : modèle / observée (Md€)", "Écart",
                 "Consommation des ménages : modèle / observée (Md€)", "Écart"]
        rows_b = [[str(e["annee"]),
                   nombre(e["masseSalarialeModele"] / 1000, 1) + " / " + nombre(e["masseSalarialeObservee"] / 1000, 1),
                   ecart_pct(e["masseSalarialeModele"], e["masseSalarialeObservee"]),
                   nombre(e["consommationModele"] / 1000, 1) + " / " + nombre(e["consommationObservee"] / 1000, 1),
                   ecart_pct(e["consommationModele"], e["consommationObservee"])] for e in un]
        out.append(Spacer(1, 4))
        out.append(tableau(ent_b, rows_b, [0.10, 0.30, 0.12, 0.34, 0.12]))
    texte = (f"Erreur moyenne sur le déficit : {nombre(sum(abs(x) for x in err) / len(err) / 100, 2)} point "
             f"(biais {nombre(sum(err) / len(err) / 100, 2)}) ; sur la charge d'intérêts : "
             f"{nombre(sum(abs(x) for x in ierr) / len(ierr) / 1000, 1)} Md€. L'élasticité des "
             "prélèvements au PIB a été de 1,4 en 2022 et de 0,4 en 2023 (Cour des comptes, base 2020) ; "
             "chaque prélèvement étant calculé sur son assiette (bénéfice fiscal et acomptes de l'IS, "
             "transactions immobilières, valeurs locatives, masse salariale, consommation), l'essentiel "
             "de ces écarts est retrouvé. Restent la déformation de la consommation vers les taux réduits "
             "de TVA (2023-2024, IGF), le calendrier du prélèvement à la source de l'impôt sur le revenu "
             "et, en 2020-2021, l'activité partielle, qui a découplé l'emploi du PIB.")
    if multi:
        dep = min(multi)
        f = multi[dep][-1]
        texte += (f" Simulé depuis {dep} sans repartir des comptes observés, le déficit {f['annee']} est de "
                  f"{pct_pb(f['deficitModelePb'], 2)} ({pct_pb(f['deficitObservePb'], 2)} observé) et la dette "
                  f"de {pct_pb(f['detteModelePb'], 1)} du PIB ({pct_pb(f['detteObserveePb'], 1)}) : l'écart "
                  "de dette vient des ajustements dette-déficit, que le modèle ne projette pas.")
    out.append(P(texte, "note"))
    return out


OBJECTIFS_SNBC_2030 = {"transports": 92, "batiments": 37, "agriculture": 68, "industrie": 42,
                       "energie": 25, "dechets": 12}
GES_COURT = {"transports": "Transp.", "batiments": "Bâtim.", "agriculture": "Agric.",
             "industrie": "Indus.", "energie": "Énergie", "dechets": "Déchets"}


def section_climat(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    i30 = D.annees.index(2030) if 2030 in D.annees else min(5, len(D.annees) - 1)
    out = [P("Climat : émissions par secteur et objectifs", "h1"),
           P(f"Émissions territoriales brutes de gaz à effet de serre (hors puits), par secteur de "
             f"l'inventaire du Citepa : {nombre(D.traj('central', None)[0]['emissionsMt'])} Mt CO₂e en {a0}. "
             "Chaque secteur baisse à son rythme tendanciel, calé sur le scénario « avec mesures "
             "existantes » du ministère (326 Mt en 2030) ; les mesures agissent sur leur secteur "
             "(voitures électriques : transports ; rénovation : bâtiments ; conversion des "
             "exploitations : agriculture). Objectifs vérifiés par les propriétés : SNBC-3 (décret "
             "n° 2026-636) par secteur en 2030 et budget carbone 2029-2033 (262 Mt par an), total "
             "brut de 276 Mt en 2030, répartition de l'effort européenne (−47,5 % par rapport à 2005), "
             "15 % de voitures électriques dans le parc en 2030.")]
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: e["emissionsMt"],
                               "Émissions territoriales brutes (Mt CO₂e), scénario central", 0, "",
                               reference=(276, "Objectif SNBC-3 2030 : 276 Mt"))))
    secs = D.secteurs_ges
    if secs:
        ent = [f"2030, Mt CO₂e"] + [GES_COURT.get(s["id"], s["nom"]) for s in secs] + ["Total"]
        rows = []
        for pid, nom in D.lignes():
            e = D.traj("central", pid)[i30]
            vals = [e["emissionsSecteursKt"][s["id"]] / 1000 for s in secs]
            rows.append([nom] + [nombre(v, 1) for v in vals] + [nombre(sum(vals), 1)])
        rows.append(["Objectif SNBC-3"] + [nombre(OBJECTIFS_SNBC_2030.get(s["id"], 0), 0) for s in secs]
                    + ["276"])
        larg = [0.30] + [0.70 / (len(secs) + 1)] * (len(secs) + 1)
        out.append(Spacer(1, 3))
        out.append(tableau(ent, rows, larg, surligner_premiere=True))
        out.append(P("Les secteurs au-dessus de leur objectif 2030 font échouer la propriété « SNBC : "
                     "secteurs 2030 ». La SNBC-3 demande une baisse de 5,1 % par an de 2025 à 2030, "
                     "contre 2,1 % observés en 2025 (Citepa).", "note"))
    return out


def gw_moyens(gwh: float) -> float:
    """Puissance moyenne sur l'année, GW, d'une énergie annuelle en GWh."""
    return gwh / 8760


FILIERES_COURT = {"nucleaire": "Nucléaire", "hydraulique": "Hydraulique", "eolienTerrestre": "Éolien terrestre",
                  "eolienMer": "Éolien en mer", "solaire": "Solaire", "thermique": "Thermique fossile",
                  "bioenergies": "Bioénergies"}


def section_electricite(D: Donnees) -> list:
    if "productionGwh" not in D.traj("central", None)[0]:
        return []
    a0, a1 = D.annees[0], D.annees[-1]
    tend = D.traj("central", None)
    e0 = tend[0]
    prod0 = gw_moyens(sum(e0["productionGwh"].values()))
    cons0 = gw_moyens(e0["consommationGwh"])
    out = [P("Électricité : production et consommation", "h1"),
           P(f"Puissance moyenne produite et consommée sur l'année (GW moyens = TWh / 8,76) : "
             f"{nombre(prod0, 1)} GW produits et {nombre(cons0, 1)} GW consommés en {a0} (RTE), l'écart "
             "allant aux exportations et au pompage. Les capacités de chaque filière croissent des "
             "installations de la programmation pluriannuelle de l'énergie (PPE3, décret du 12 février "
             "2026) et de celles des mesures ; la production en découle aux facteurs de charge observés "
             "(nucléaire : 365 TWh par an de référence, RTE). La consommation suit la trajectoire "
             "« décarbonation lente » de RTE, plus les voitures électriques du parc (celles des mesures "
             "comprises). Les interconnexions plafonnant le solde exportateur vers 100 TWh, la production "
             "qui ne trouve pas de débouché est retirée au nucléaire (modulation). Aucun nouveau réacteur "
             "(EPR2, SMR) n'entre en service avant 2035.")]
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: gw_moyens(sum(e["productionGwh"].values())),
                               "Électricité produite (GW moyens), scénario central", 1, NBSP + "GW")))
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: gw_moyens(e["consommationGwh"]),
                               "Électricité consommée (GW moyens), scénario central", 1, NBSP + "GW")))
    # tendanciel par filière
    jalons = [i for i, a in enumerate(D.annees) if a in (a0, 2030, a1)]
    ent = ["Tendanciel"] + [x for i in jalons for x in (f"{D.annees[i]} GW", f"{D.annees[i]} TWh")]
    rows = []
    for f, nomf in FILIERES_COURT.items():
        rows.append([nomf] + [x for i in jalons for x in (nombre(tend[i]["capacitesMw"][f] / 1000, 1),
                                                           nombre(tend[i]["productionGwh"][f] / 1000, 0))])
    rows.append(["Total produit"] + [x for i in jalons for x in
                                     (nombre(sum(tend[i]["capacitesMw"].values()) / 1000, 1),
                                      nombre(sum(tend[i]["productionGwh"].values()) / 1000, 0))])
    rows.append(["Consommation"] + [x for i in jalons for x in ("", nombre(tend[i]["consommationGwh"] / 1000, 0))])
    rows.append(["Nucléaire modulé"] + [x for i in jalons for x in ("", nombre(tend[i].get("modulationGwh", 0) / 1000, 0))])
    if any(e.get("ecretementGwh", 0) for e in tend):
        rows.append(["Renouvelable écrêté"] + [x for i in jalons for x in ("", nombre(tend[i].get("ecretementGwh", 0) / 1000, 0))])
    out.append(KeepTogether([Spacer(1, 3), tableau(ent, rows, [0.22] + [0.13] * (2 * len(jalons)))]))
    ent = [f"{a1}", "Nucl. (GW)", "Éolien (GW)", "Solaire (GW)", "Autres (GW)",
           "Produit", "Consommé", "Solde", "Modulé", "Écrêté"]
    rows = []
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        c = e["capacitesMw"]
        prod = gw_moyens(sum(e["productionGwh"].values()))
        cons = gw_moyens(e["consommationGwh"])
        rows.append([nom, nombre(c["nucleaire"] / 1000, 1),
                     nombre((c["eolienTerrestre"] + c["eolienMer"]) / 1000, 1),
                     nombre(c["solaire"] / 1000, 1),
                     nombre((c["hydraulique"] + c["thermique"] + c["bioenergies"]) / 1000, 1),
                     nombre(prod, 1), nombre(cons, 1), signe(prod - cons, 1),
                     nombre(gw_moyens(e.get("modulationGwh", 0)), 1),
                     nombre(gw_moyens(e.get("ecretementGwh", 0)), 1)])
    out.append(Spacer(1, 4))
    out.append(tableau(ent, rows, [0.23, 0.08, 0.08, 0.09, 0.09, 0.09, 0.10, 0.08, 0.08, 0.08],
                       surligner_premiere=True))
    out.append(P("Capacités installées en fin d'année ; « autres » : hydraulique, thermique fossile, "
                 "bioénergies. Produit, consommé, solde (exportations et pompage), production nucléaire "
                 "modulée et production renouvelable écrêtée (programmes qui donnent la priorité au "
                 "nucléaire : le surplus est retiré au solaire puis à l'éolien) en GW moyens. La fin des soutiens aux nouvelles installations solaires et "
                 "éoliennes (LR-04, RN-16) retire les volumes des appels d'offres de la PPE3 ; le nucléaire "
                 "module alors moins. Sources : RTE (bilans électriques 2023 à 2025, bilan prévisionnel "
                 "2025), décret PPE3 (voir Hypotheses/Electricite.lean).", "note"))
    return out


def barres_pays_energie(D: Donnees):
    """Prix de l'électricité des entreprises en 2024 par pays (observé, hors TVA),
    et le coût d'équilibre modélisé pour la France en début et fin de période."""
    pays = sorted(D.d["prixEnergieComparaison"], key=lambda c: c["electriciteEurosMWh"])
    fig, ax = figure(3.3)
    noms = [c["pays"] for c in pays]
    vals = [c["electriciteEurosMWh"] for c in pays]
    coul = [SERIES[0] if c["pays"] == "France" else MUTED for c in pays]
    ax.barh(noms, vals, color=coul, height=0.62, zorder=2)
    for i, v in enumerate(vals):
        ax.annotate(f"{v}", (v, i), xytext=(3, 0), textcoords="offset points", va="center",
                    fontsize=7, color=INK2)
    a0, a1 = D.annees[0], D.annees[-1]
    tend = D.traj("central", None)
    for e, lab, ls in ((tend[0], f"France modèle {a0}", ":"), (tend[-1], f"France modèle {a1} (tendanciel)", "--")):
        ax.axvline(e["prixElectriciteEntreprisesEurosMWh"], color=INK, lw=1, ls=ls, zorder=3, label=lab)
    fins = [D.fin("central", p["id"])["prixElectriciteEntreprisesEurosMWh"] for p in D.progs]
    if fins and (max(fins) - min(fins)) > 1:
        ax.axvspan(min(fins), max(fins), color=SERIES[1], alpha=0.18, zorder=1,
                   label=f"Programmes en {a1} (min–max)")
    ax.set_title("Électricité des entreprises, 2024 observé (€/MWh hors TVA) et coût d'équilibre modélisé")
    ax.xaxis.set_major_formatter(fmt_axe(0, NBSP + "€"))
    ax.xaxis.set_major_locator(MaxNLocator(6))
    ax.set_xlim(0, max(vals) * 1.12)
    ax.invert_yaxis()
    ax.tick_params(axis="y", labelsize=7.5)
    legende(fig, ncol=3)
    return fig


def section_energie_cout(D: Donnees) -> list:
    if "prixElectriciteEntreprisesEurosMWh" not in D.traj("central", None)[0]:
        return []
    a0, a1 = D.annees[0], D.annees[-1]
    comp = {c["pays"]: c for c in D.d.get("prixEnergieComparaison", [])}
    fr = comp.get("France", {}).get("electriciteEurosMWh")
    ue = comp.get("UE-27", {}).get("electriciteEurosMWh")
    de = comp.get("Allemagne", {}).get("electriciteEurosMWh")
    us = comp.get("États-Unis", {}).get("electriciteEurosMWh")
    tend = D.traj("central", None)
    p0, p1 = tend[0]["prixElectriciteEntreprisesEurosMWh"], tend[-1]["prixElectriciteEntreprisesEurosMWh"]
    out = [P("Coût de l'énergie : la France face aux autres pays, et les usines qui suivent", "h1"),
           P("Le modèle calcule chaque année un <b>coût d'équilibre</b> de l'électricité pour les entreprises : "
             "coût complet du mix (nucléaire existant à coût annuel fixe, 61 €/MWh pour 365 TWh ; renouvelables "
             "et cycles à gaz à leurs coûts complets, le gaz indexé sur le Brent du scénario et le CO<sub>2</sub> "
             "passant de 75 à 120 €/t), plus marge de fourniture, réseau et taxes. Ce n'est pas un prix de marché : "
             f"en 2024 les entreprises françaises ont payé {fr} €/MWh hors TVA (SDES), encore marqués par les contrats "
             f"de la crise de 2022, contre {p0} €/MWh de coût d'équilibre en {a0} dans le modèle. L'écart entre "
             "programmes vient du mix : plus de renouvelables à coût complet, moins de nucléaire modulé, ou l'inverse. "
             f"Les autres pays sont représentés par leur niveau observé en 2024 (UE-27 : {ue}, Allemagne : {de}, "
             f"États-Unis : {us} €/MWh), supposé constant en termes réels.")]
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: e["prixElectriciteEntreprisesEurosMWh"],
                               "Coût d'équilibre de l'électricité des entreprises (€/MWh), scénario central",
                               0, NBSP + "€", reference=(fr, "France 2024, prix observé (SDES)"))))
    out.append(png(barres_pays_energie(D)))
    out.append(P("<b>Facteur d'implantation.</b> L'emploi manufacturier répond au prix réel de l'électricité "
                 "avec une élasticité de −0,10 (fourchette −0,05 à −0,20 dans la littérature : Marin et Vona ; "
                 "Fontagné, Martin et Orefice ; OCDE ; BCE), atteinte au tiers par an. Le coût est comparé à celui "
                 "qu'aurait le mix de départ aux mêmes prix du gaz et du CO<sub>2</sub> (les concurrents européens "
                 "subissent ces prix-là) : seuls le mix, la modulation du nucléaire et l'écrêtement des renouvelables "
                 "comptent. Un coût inférieur de 10 % attire "
                 "donc, à terme, 1 % d'emplois industriels supplémentaires "
                 "(ouvertures, extensions, relocalisations) ; une hausse en fait partir. Ces emplois passent par "
                 "le canal emploi du modèle (production, salaires, cotisations) et s'ajoutent aux exportations."))
    ans = [D.annees[2], D.annees[5], D.annees[-1]]
    idx = [D.annees.index(a) for a in ans]
    ent = ["Scénario central"] + [f"{a} €/MWh" for a in ans] + [f"Implantations {a1}", f"PIB associé {a1}"]
    rows = []
    for pid, nom in D.lignes():
        tr = D.traj("central", pid)
        e = tr[-1]
        emp = e.get("emploisImplantationsEnergie", 0)
        pib_par_emploi = e["pib"] / e["emploiTotal"] if e.get("emploiTotal") else 0
        rows.append([nom] + [nombre(tr[i]["prixElectriciteEntreprisesEurosMWh"]) for i in idx]
                    + [signe(emp / 1000, 1) + NBSP + "k", signe(emp * pib_par_emploi / 1000, 1) + NBSP + "Md€"])
    out.append(KeepTogether([Spacer(1, 3),
                             tableau(ent, rows, [0.30, 0.12, 0.12, 0.12, 0.17, 0.17], surligner_premiere=True),
                             P("Implantations : emplois manufacturiers cumulés créés (+) ou perdus (−) par le facteur "
                 "d'implantation ; PIB associé : ces emplois multipliés par le PIB par emploi de l'année "
                 "(calcul, ordre de grandeur ; l'effet exact passe par le canal emploi). Les niveaux étrangers sont "
                 "des prix 2024 observés, hors TVA (SDES pour la France et l'UE-27 ; Eurostat, bande 500 à 2 000 "
                 "MWh, repris par Apiar Data et ramenés hors TVA ; DESNZ, EIA, KEPCO), non des projections : la "
                 "comparaison est entre un coût d'équilibre français projeté et des prix étrangers constants. "
                 "Sources et hypothèses : Hypotheses/Electricite.lean.", "note")]))
    return out


DEST_COURT = {"logement": "Logement", "activites": "Activités", "infrastructures": "Infra.",
              "autres": "Autres", "energie": "Énergie"}


def regime_zan(pm: int) -> str:
    if pm <= 0:
        return "ZAN"
    if pm >= 1000:
        return "abrogé"
    return f"assoupli ({pm // 10} %)"


def section_sols(D: Donnees) -> list:
    if "surfacesHa" not in D.traj("central", None)[0]:
        return []
    a0, a1 = D.annees[0], D.annees[-1]
    dests = [x["id"] for x in D.d.get("destinations", [])]
    enaf = [x for x in dests if x != "energie"]
    env = D.d.get("enveloppeZanHa", 0)
    out = [P("Sols : surfaces consommées", "h1"),
           P("Consommation d'espaces naturels, agricoles et forestiers (ENAF) depuis le 1er janvier 2021, "
             "début de la première tranche du zéro artificialisation nette (ZAN, lois du 22 août 2021 et "
             f"du 20 juillet 2023). L'enveloppe 2021-2031 est la moitié de la consommation 2011-2021, soit "
             f"{nombre(env)} ha (Cerema, millésime 2025) ; ce qu'il en reste fin {a0} permet "
             f"{nombre(D.d.get('rythmeZanHa', 0))} ha par an jusqu'en 2030, rythme prolongé ensuite, "
             f"contre 15 119 ha consommés en 2024. Un programme qui abroge le ZAN revient au "
             f"rythme de 2011-2021 ({nombre(D.d.get('rythmeSansZanHa', 0))} ha par an). Sous le ZAN, "
             "l'enveloppe est un plafond : les surfaces des mesures (lignes nouvelles, prisons) s'y "
             "imputent et évincent d'autant les autres usages ; sans ZAN, elles s'ajoutent. L'emprise "
             "des installations nouvelles de solaire au sol et d'éolien terrestre (surface clôturée, "
             "couverte de panneaux pour 25 à 40 %) est comptée à part, en « énergie ».")]
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: sum(e["surfacesHa"][x] for x in enaf) / 1000,
                               "ENAF consommés depuis 2021 (milliers d'ha), scénario central", 0, "",
                               reference=(env / 1000, "Enveloppe ZAN 2021-2031"))))
    ent = [f"Cumul {a0 + 1}-{a1}, ha"] + [DEST_COURT.get(x, x) for x in enaf] + ["ENAF", "Hors ZAN", "Énergie",
                                                                                "Régime"]
    rows = []
    for pid, nom in D.lignes():
        tr = D.traj("central", pid)
        e, e0 = tr[-1], tr[0]
        v = [e["surfacesHa"][x] - e0["surfacesHa"][x] for x in enaf]
        en = e["surfacesHa"]["energie"] - e0["surfacesHa"]["energie"]
        hz = e.get("surfacesHorsZanHa", 0) - e0.get("surfacesHorsZanHa", 0)
        rows.append([nom] + [nombre(x) for x in v] + [nombre(sum(v)), nombre(hz) if hz else "—", nombre(en),
                                                    regime_zan(e.get("ecartZanPm", 0))])
    larg = [0.24] + [0.105, 0.105] + [0.08] * (len(enaf) - 2) + [0.095, 0.085, 0.09, 0.08]
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, larg, surligner_premiere=True))
    out.append(P("Destinations du Cerema : habitat, activité (dont industrie), infrastructures routières "
                 "et ferroviaires, autres (mixte, équipements, non renseigné). Régime : ZAN en vigueur, "
                 "assoupli (part de l'écart au rythme d'avant la loi) ou abrogé (RN-22, LR-18) ; « hors ZAN » : part des ENAF "
                 "qu'une exemption légale créée par le programme sort du décompte de l'enveloppe. Sources : "
                 "Cerema, déterminants de la consommation d'ENAF 2011-2025 ; ADEME et Congrès des notaires "
                 "(emprises) ; voir Hypotheses/Sols.lean et Hypotheses/Electricite.lean.", "note"))
    return out


def section_air(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    out = [P("Voitures électriques, bornes et qualité de l'air", "h1"),
           P("Le parc de voitures électriques croît avec le règlement (UE) 2023/851 (ventes "
             "d'électriques portées de 19,9 % des ventes neuves en 2025 à 100 % en 2035) et avec les "
             "mesures d'aide à l'achat ou de remplacement, dans la limite des ventes neuves. Chaque "
             "million de voitures thermiques remplacées évite "
             f"{nombre(D.var['central']['decesEvitesParMillionVehicules'])} décès par an attribuables aux particules fines (hypothèse de calcul : Santé publique "
             "France, Citepa) et retire de l'assiette fiscale 354 M€ d'accises et 155 M€ de TVA sur "
             "les carburants par an. La propriété « bornes suffisantes » exige un point de recharge "
             "public pour dix véhicules électriques en 2035 ; la propriété AFIR, 1,3 kW de puissance "
             "publique par voiture électrique en 2030.")]
    for g in D.groupes:
        out.append(png(courbes(D, g, lambda e: e["decesPollutionAir"],
                               "Décès annuels attribuables à la pollution de l'air, scénario central",
                               0, "")))
    ent = [f"{a1}, scénario central", "Parc électrique (milliers)", "Bornes publiques (milliers)",
           "Véhicules par borne", "Décès pollution de l'air", "Décès évités / an"]
    base = D.fin("central", None)
    rows = []
    e0 = D.traj("central", None)[0]
    rows.append([f"Situation de départ ({a0})", nombre(e0["parcElectriqueMilliers"]), nombre(e0["bornesMilliers"]),
                 nombre(e0["parcElectriqueMilliers"] / max(1, e0["bornesMilliers"]), 1),
                 nombre(e0["decesPollutionAir"]), "—"])
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        rows.append([nom, nombre(e["parcElectriqueMilliers"]), nombre(e["bornesMilliers"]),
                     nombre(e["parcElectriqueMilliers"] / max(1, e["bornesMilliers"]), 1),
                     nombre(e["decesPollutionAir"]),
                     "—" if pid is None else signe(base["decesPollutionAir"] - e["decesPollutionAir"], 0)])
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.28, 0.15, 0.15, 0.13, 0.15, 0.14]))
    out.append(P("Décès évités : par rapport au tendanciel, même année. Le parc et les bornes de "
                 f"départ sont des ordres de grandeur (Avere-France, fin {a0}). Les primes ne s'ajoutent "
                 "aux ventes tendancielles que dans la limite des ventes neuves (au-delà : effet "
                 "d'aubaine) ; leur effet d'aubaine en deçà et les émissions hors échappement (pneus, "
                 "freins) ne sont pas modélisés.", "note"))
    return out


VERT, ROUGE = "#008300", "#c62f2e"  # mêmes couleurs que programme_pdf.py

# Unité de chaque réglage de la cohérence interne (Modele/Coherence.lean)
UNITE_REGLAGE = {
    "dureeTravail": ("‰ d'heures", 1), "ageLegal": ("mois", 1), "dureeCotisation": ("mois", 1),
    "smic": ("%", 100), "migration": ("milliers par an", 1), "prixTabac": ("‰ du prix", 1),
    "smicVise": ("€ brut", 1), "tauxIS": ("%", 100), "ageLegalVise": ("mois", 1),
    "regimeZan": ("‰", 1), "prixMinimumAlcool": ("c par verre", 1), "plafondNormeSante": ("%", 100),
    "freinDeficit": ("% du PIB", 100), "detteNumerique": ("‰ de la dette", 1),
}


def valeur_reglage(reglage: str, v: int, signe: bool) -> str:
    unite, div = UNITE_REGLAGE.get(reglage, ("", 1))
    x = v / div
    txt = f"{x:+,.2f}" if signe else f"{x:,.2f}"
    txt = txt.replace(",", " ").replace(".", ",").rstrip("0").rstrip(",").replace("-", "−")
    return f"{txt} {unite}".strip()


def conflit_texte(c: dict) -> str:
    """« O1 (39 h) et O4 (35 h) — durée du travail : sens opposés »."""
    sens = c["nature"] == "sens"
    (m1, m2), (v1, v2) = c["mesures"], c["valeurs"]
    quoi = "sens opposés" if sens else "deux valeurs différentes"
    return (f"<b>{echap(m1)}</b> ({valeur_reglage(c['reglage'], v1, sens)}) et <b>{echap(m2)}</b> "
            f"({valeur_reglage(c['reglage'], v2, sens)}) — {echap(c['reglageNom'])} : {quoi}")


INTRO_COHERENCE = ("Deux mesures d'un même programme se contredisent quand elles fixent un même réglage "
                   "à deux valeurs différentes (taux de l'impôt sur les sociétés, SMIC visé, âge légal "
                   "visé…) ou le déplacent dans des sens opposés (durée du travail, âge légal, durée de "
                   "cotisation…). La vérification lit les leviers des mesures, sans projection ni "
                   "hypothèse ; les étapes d'une même mesure ne sont pas comparées entre elles. L'auteur "
                   "peut déclarer une paire voulue, avec sa raison : elle est alors <i>arbitrée</i> et "
                   "reste affichée. Deux mesures contradictoires modélisées par des leviers différents "
                   "échappent à la vérification.")


def coherence_paragraphes(p: dict) -> list:
    """Conflits non arbitrés puis arbitrés d'un programme (rien si l'export n'en a pas)."""
    co = p.get("coherence")
    if co is None:
        return []
    out = []
    if co["coherent"]:
        out.append(P(f"<font color='{VERT}'>✓</font> " + (
            "Aucun conflit non arbitré : le programme est cohérent au sens de cette vérification."
            if co["arbitres"] else "Aucune paire de mesures contradictoires.")))
    s = lambda n: "s" if n > 1 else ""
    if co["conflits"]:
        n = len(co["conflits"])
        out.append(P(f"<font color='{ROUGE}'>✗</font> <b>{n} conflit{s(n)} non arbitré{s(n)}</b> : "
                     "le programme n'est pas cohérent au sens de cette vérification."))
        out += [P("• " + conflit_texte(c), "cell") for c in co["conflits"]]
    if co["arbitres"]:
        n = len(co["arbitres"])
        out.append(P(f"<b>{n} conflit{s(n)} arbitré{s(n)} par l'auteur</b> :"))
        out += [P("• " + conflit_texte(a["conflit"]) + f". <i>{echap(a['raison'])}</i>", "cell")
                for a in co["arbitres"]]
    for a in co.get("arbitragesSansObjet", []):
        out.append(P(f"⚠ Arbitrage sans objet ({echap(' / '.join(a['mesures']))}) : aucun conflit entre "
                     "ces mesures.", "note"))
    return out


def section_coherence(D: Donnees) -> list:
    progs = [p for p in D.progs if "coherence" in p]
    if not progs:
        return []
    rows = []
    for p in progs:
        co = p["coherence"]
        ok = co["coherent"]
        rows.append([nom_court(p["nom"]),
                     P(f"<font color='{VERT if ok else ROUGE}'>{'✓ oui' if ok else '✗ non'}</font>", "cell"),
                     str(len(co["conflits"])), str(len(co["arbitres"]))])
    out = [CondPageBreak(95 * mm), P("Cohérence interne", "h2"), P(INTRO_COHERENCE),
           tableau(["Programme", "Cohérent", "Conflits", "Arbitrés"], rows, [0.52, 0.16, 0.16, 0.16],
                   droite_des=2)]
    for p in progs:
        co = p["coherence"]
        if co["conflits"] or co["arbitres"]:
            out.append(P(f"<b>{echap(nom_court(p['nom']))}</b>"))
            out += coherence_paragraphes(p)
    return out


def section_proprietes(D: Donnees) -> list:
    d = D.d
    n = d["nbScenarios"]
    out = [P("Propriétés et engagements", "h1"),
           P(f"Chaque programme est évalué sous les {n} scénarios du dépôt (démographie × économie "
             f"× prix du pétrole × cadre juridique), à l'horizon de {d['horizonProprietes']} ans. "
             "Une propriété est un critère partagé ; un engagement est une propriété qu'un programme "
             "revendique sous un ou plusieurs scénarios, vérifiée par le noyau Lean à chaque "
             "modification du dépôt."),
           ]
    for m in D.moteurs:
        out += [P(f"Moteur « {m['nom']} » — {echap(m['description'])}", "h2"),
                table_proprietes(D, m["id"], avec_central=True)]
    out += [Spacer(1, 3), legende_degrade(n),
            P("✓/✗ : statut au scénario central, puis nombre de scénarios où la propriété tient. "
              "Les propriétés datées (2035) sont évaluées dix ans après le départ, les autres à "
              "l'horizon du scénario.", "note"),
            Spacer(1, 4), P("Engagements revendiqués", "h2")]
    rows = []
    for p in D.progs:
        groupes: OrderedDict[str, list] = OrderedDict()
        for e in p["engagements"]:
            groupes.setdefault(e["propriete"], []).append(e)
        for prop, es in groupes.items():
            tenus = sum(1 for e in es if e["tenu"])
            mot = D.nom_moteur(es[0].get("moteur", D.standard))
            if len(es) == n:
                scen, statut = f"tous les scénarios ({n})", f"tenu ({tenus}/{n})" if tenus == n else f"NON TENU ({tenus}/{n})"
                rows.append([nom_court(p["nom"]), prop, mot, scen, statut])
            else:
                for e in es:
                    rows.append([nom_court(p["nom"]), prop, mot,
                                 P(echap(e["scenario"].replace("/", " / ")), "cell"),
                                 "tenu" if e["tenu"] else "NON TENU"])
    if rows:
        out.append(tableau(["Programme", "Propriété", "Moteur", "Scénario", "Statut"], rows,
                           [0.2, 0.17, 0.1, 0.41, 0.12], droite_des=4))
    else:
        out.append(P("Aucun engagement déclaré.", "note"))
    out.append(P("Contrats de mesure", "h2"))
    out.append(P("Un contrat est un théorème démontré sur une mesure (par exemple : « l'amende est "
                 "nulle pour toute commune qui atteint son objectif »), valable pour toutes les "
                 "valeurs possibles et pas seulement pour les scénarios. Nombre de contrats : "
                 + " ; ".join(f"{echap(nom_court(p['nom']))} {len(p['contrats'])}" for p in D.progs)
                 + ". Liste en annexe A."))
    out += section_coherence(D)
    return out


def section_glossaire(titre: str = "Annexe D — Concepts et définitions Lean") -> list:
    """Table de correspondance concept → déclaration Lean (scripts/glossaire_lean.py),
    vérifiée contre les sources à chaque génération."""
    if str(Path(__file__).resolve().parent) not in sys.path:
        sys.path.insert(0, str(Path(__file__).resolve().parent))
    from glossaire_lean import GLOSSAIRE, verifier
    problemes = verifier()
    for i, msg in problemes.items():
        print(f"glossaire : {GLOSSAIRE[i][0]} : {msg}", file=sys.stderr)
    rows = []
    for i, (concept, clair, nom, fichier) in enumerate(GLOSSAIRE):
        lean = (f"<font name='Mono' size='6.6'>{echap(nom)}</font>" if nom else "—")
        if i in problemes:
            lean += f" <font color='{ROUGE}'>⚠ introuvable</font>"
        rows.append([P(f"<b>{echap(concept)}</b>", "cell"), P(echap(clair), "cell"), P(lean, "cell"),
                     P(f"<font name='Mono' size='6.2' color='{INK2}'>{echap(fichier)}</font>", "cell")])
    return [P(titre, "h1"),
            P("Chaque notion du projet a sa définition dans le code Lean du dépôt. Cette table donne, "
              "pour chacune, le nom de la déclaration et le fichier où la lire : c'est le point "
              "d'entrée pour vérifier une affirmation de ce document ou écrire son propre programme. "
              "Les noms sont relus dans les sources à chaque génération du document ; un nom "
              "introuvable y est signalé."),
            tableau(["Concept", "En clair", "Définition Lean", "Fichier"], rows,
                    [0.16, 0.34, 0.29, 0.21], droite_des=4)]


def section_annexes(D: Donnees) -> list:
    out = [PageBreak(), P("Annexe A — Mesures et contrats par programme", "h1")]
    for p in D.progs:
        bloc = [P(echap(p["nom"]), "h2"), P(echap(p["description"]), "note")]
        bloc += [Paragraph(f"<b>{echap(m['id'])}</b> {echap(m['titre'])}", STYLES["puce"],
                           bulletText="•") for m in p["mesures"]]
        if p["contrats"]:
            bloc.append(P("Contrats démontrés :", "note"))
            bloc += [P(echap(c), "petit") for c in p["contrats"]]
        out.append(KeepTogether(bloc[:4]))
        out += bloc[4:]
    out += [CondPageBreak(80 * mm), P("Annexe B — Hypothèses et sources", "h1")]
    h = D.d["hypotheses"]
    groupes = [("Situation de départ", [h["reference"] | {"id": "référence"}]),
               ("Démographie", h["demographie"]), ("Natalité", h["natalite"]),
               ("Économie", h["economie"]), ("Prix du pétrole", h["energie"]),
               ("Cadre juridique", h["droit"])]
    for titre, items in groupes:
        out.append(P(titre, "h2"))
        for it in items:
            out.append(Paragraph(f"<b>{echap(it['id'])}</b> — {echap(it['description'])}",
                                 STYLES["puce"], bulletText="•"))
            out += [P(echap(s), "petit") for s in it["sources"]]
    out += [CondPageBreak(60 * mm), P("Annexe C — Méthode et limites", "h1")]
    out += puces([
        "Modèle commun en nombres entiers (M€, points de base, personnes), écrit en Lean 4 : la "
        "même fonction projette le tendanciel et chaque programme. Engagements et contrats sont "
        "vérifiés par le noyau Lean ; les trajectoires de ce document sont calculées par le même "
        "code.",
        "Effets de demande : le PIB est calculé par la demande (consommation, investissement, "
        "dépense publique, exportations, importations), chaque composante par une équation à "
        "correction d'erreur dont les coefficients reprennent Mésange (DG Trésor 2017/04), e-mod.fr "
        "et FR-BDF ; l'emploi, les salaires et les prix en découlent (boucle prix-salaires). Les "
        "multiplicateurs qui en résultent, par canal et par horizon, sont comparés aux variantes "
        "publiées de ces modèles (section Moteurs). Fuite fiscale et élasticité du chômage au SMIC "
        "restent des ordres de grandeur (annexe B). Trois jeux d'hypothèses économiques encadrent "
        "ces incertitudes dans la matrice des propriétés ; ce document ne montre que le jeu central.",
        "Déficit : croissance, inflation et taux suivent les prévisions publiées jusqu'en 2030 "
        "(Banque de France, PLF 2027, mission d'experts de juillet 2026), puis les valeurs de long "
        "terme ; les prélèvements suivent le PIB nominal et réagissent au cycle selon leur "
        "élasticité (LPFP 2023-2027) ; les dépenses primaires suivent les prix et une tendance en "
        "volume par fonction (COR, mission d'experts) ; la charge d'intérêts suit la structure de "
        "la dette (BTF, refinancement, titres indexés). Rétro-test 2019-2025 : voir la section "
        "dédiée. Les assiettes fiscales restent rattachées au PIB, pas à la masse salariale ou à la "
        "consommation ; pas de balance commerciale macroéconomique (le sous-modèle automobile la "
        "calcule pour la mesure O-01 seulement).",
        "Déficit « de l'État » : le modèle suit les administrations publiques consolidées ; les "
        "transferts internes (par exemple les amendes SRU versées par les communes) sont neutres "
        "sur le solde.",
        "Prêts et prises de participation de l'État (financement des EPR2, nationalisations) : "
        "opérations financières, comptées dans la dette mais pas dans le déficit, conformément au "
        "traitement de Maastricht. L'activité qu'ils financent se déroule hors des administrations "
        "publiques et n'est pas modélisée.",
        "Population active : tendance démographique et effet de l'âge légal (30 000 actifs par "
        "mois, INSEE). La natalité n'agit pas sur les actifs avant l'horizon.",
        "Lois en vigueur : la référence applique le calendrier de l'âge légal suspendu par la LFSS "
        "pour 2026 (64 ans en 2033), la loi de programmation militaire actualisée (76,3 Md€ en 2030), "
        "l'ETS2 à partir de 2028, la fin de la contribution exceptionnelle des grandes entreprises "
        "(après 2026) et de la CVAE (2030), la contribution différentielle sur les hauts revenus tant "
        "que le déficit dépasse 3 % et l'érosion des accises par l'électrification du parc, la "
        "contribution à l'Union (27,9 Md€ en 2026, puis le remboursement de NextGenerationEU dès "
        "2028), la prime d'activité revalorisée, la fin de l'aide exceptionnelle à l'apprentissage, "
        "les nouvelles règles des ruptures conventionnelles et le complément de fin de droits de "
        "l'assurance chômage, déclenché quand le chômage atteint 9 %. La "
        "tendance des dépenses de retraite (COR, juin 2026) est prise nette de la suspension de la "
        "réforme de 2023, comptée par l'écart au calendrier de cette réforme. Les économies de la "
        "loi de finances et de la loi de financement de la sécurité sociale pour 2026 ne sont pas "
        "dans la référence (déficit tendanciel 2026 de 5,8 %, contre 5,4 % prévus dans le PLF 2027).",
        "Incidence et coût du travail : chaque prélèvement passe par un canal du bloc de demande "
        "(ménages, TVA et accises, IS), pondéré par son incidence relativement à l'impôt de "
        "référence du canal (autres impôts 0,73 de l'IR ; successions et patrimoine 0,18). Les "
        "allègements de cotisations patronales sont suivis par tranche de salaire (75 Md€, dont "
        "87 % entre 1 et 1,6 SMIC) ; l'emploi y répond au coût du travail (≈ 14 500 emplois par "
        "Md€ sous 1,6 SMIC, ≈ 5 100 de 1,6 à 2,5 SMIC, presque rien au-delà), en cinq ans environ. "
        "Une dépense soutient l'activité selon son canal : consommation publique (affaires "
        "économiques et défense à 0,85), transferts aux ménages (famille-chômage 1,06 fois les "
        "retraites), investissement, emplois publics.",
        "IDH : formule du PNUD (espérance de vie, scolarisation, RNB par habitant en volume). "
        "L'espérance de vie suit la tendance de l'INSEE (+0,12 an par an) plus les années de vie "
        "gagnées par les décès évités (pollution, accidents du travail, tabac, alcool, dépistage ; "
        "années de vie par décès et délais d'effet : hypothèses) ; l'inflation suit la trajectoire "
        "du déflateur (1,75 % à long terme au scénario central), plus les effets de la courbe de "
        "Phillips et des prix du bloc de demande.",
        "Vieillissement : les tendances de dépenses de retraite et de santé intègrent la démographie "
        "de leurs projections ; seul l'écart d'une hypothèse démographique à celle-ci ajoute un "
        "surcoût (nul au scénario central).",
        "Offre de travail : le PIB suit le volume d'heures travaillées (emploi × durée) à "
        "l'élasticité de 65 %, pour les mesures d'âge de départ, de SMIC et de durée du travail ; "
        "le capital des entreprises n'entre que par le bloc de demande (son accumulation relève le "
        "PIB potentiel) et par le canal du capital du moteur d'offre.",
        "Robotisation : levier des programmes seulement (les tendances de dépenses intègrent déjà "
        "les gains de productivité) ; elle réduit la croissance de trois fonctions de dépense, sans "
        "effet modélisé sur l'emploi public.",
        "Commerce extérieur : les écarts au tendanciel des exportations (demande mondiale, "
        "compétitivité-prix) et des importations (contenus en importations, prix relatifs) viennent "
        "du bloc de demande ; les prix mondiaux et le taux de change sont exogènes, les revenus nets "
        "du reste du monde constants.",
        "Bloc de demande : les emplois publics créés n'entrent ni dans le revenu des ménages ni dans "
        "le chômage du bloc ; les dépenses prévues par la référence (loi de programmation "
        "militaire…) le nourrissent aussi au tendanciel ; à dix ans, les effets s'estompent plus "
        "vite que dans Mésange.",
        "Moteurs : les paramètres du moteur « offre » (demi-multiplicateur sur les économies, "
        "0,1 point de croissance par point de prélèvements obligatoires) sont des ordres de "
        "grandeur à sourcer, comme le retour plus rapide des effets de demande vers 20 % de leur "
        "niveau ; ils encadrent la lecture « demande » plutôt qu'ils ne la remplacent.",
        "Programmes réels : transcriptions partielles et non officielles, limitées aux mesures "
        "chiffrées dans la source ; toute erreur se signale par une issue sur le dépôt.",
    ])
    out += [CondPageBreak(120 * mm)] + section_glossaire()
    return out


# ---------------------------------------------------------------------------

def construire(d: dict, sortie: Path, commit: str | None, moteur: str | None = None,
               programmes: list[str] | None = None) -> None:
    D = Donnees(d, moteur, programmes)
    meta = {"date": dt.date.today().strftime("%d/%m/%Y"),
            "commit": f" (version {commit[:7]})" if commit else ""}
    a0, a1 = D.annees[0], D.annees[-1]
    pib0 = D.traj("central", None)[0]["pib"]
    story = section_resume(D, meta)
    story.append(PageBreak())
    story += section_pib_volume(D)
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Écart de PIB",
        "Écart du PIB de chaque programme au PIB tendanciel : au-dessus de zéro, le programme "
        "accroît l'activité ; en dessous, il la réduit.",
        lambda e: e["pib"] * 100 / pib0, "Écart de PIB au tendanciel (% du PIB de départ), "
        "scénario central", 2, NBSP + "%", md, ecart=True, valeur_table=lambda e: e["pib"],
        note="Tableau : PIB en Md€ courants.")
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Déficit public",
        "Solde des administrations publiques (État, sécurité sociale, collectivités), en % du PIB. "
        "La ligne de référence marque le seuil de 3 % du traité de Maastricht.",
        lambda e: e["deficitPb"] / 100, "Déficit public (% du PIB), scénario central", 1,
        NBSP + "%", pct_pb, valeur_table=lambda e: e["deficitPb"],
        reference=(3.0, "3 % (Maastricht)"))
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Dette publique", "Dette au sens de Maastricht, en % du PIB. Les passifs implicites (« dettes "
        "cachées » : heures supplémentaires non payées des policiers, 189 M€, et des hôpitaux publics, "
        "720 M€, en 2025) n'y figurent pas ; "
        "le rapport les suit à part (dette étendue), et une mesure qui les apure les fait passer dans "
        "le déficit de l'année.",
        lambda e: e["dettePb"] / 100, "Dette publique (% du PIB), scénario central", 0,
        NBSP + "%", lambda v: pct_pb(v, 1), valeur_table=lambda e: e["dettePb"])
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Charge d'intérêts",
        "Intérêts versés sur la dette, en Md€. Le taux apparent part de son niveau de 2025 et "
        "converge vers le taux marginal du scénario au rythme du refinancement : plus la dette "
        "monte, plus les intérêts pèsent sur le déficit de l'année suivante (effet boule de neige). "
        "Le tendanciel est une trajectoire « à politique inchangée », sans aucune consolidation.",
        lambda e: e["chargeInterets"] / 1000, "Charge d'intérêts (Md€), scénario central", 0, "",
        lambda v: md(v, 1), valeur_table=lambda e: e["chargeInterets"],
        note="Tableau en Md€. Les opérations financières (prêts de l'État) alourdissent la dette, "
             "donc les intérêts, sans entrer dans le déficit primaire.")
    story.append(CondPageBreak(150 * mm))
    story += section_beneficiaires(D)
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Chômage",
        "Taux de chômage au sens du BIT, en % de la population active. L'emploi ne suit pas "
        "mécaniquement la population active : la tendance démographique est absorbée au taux "
        "d'emploi courant ; la croissance agit par la loi d'Okun, convertie en emplois avec "
        "l'effet de flexion (1,15 emploi par chômeur en moins, INSEE) ; les actifs ajoutés ou "
        "retirés par les mesures (âge de départ, migrations, reconversions) entrent au taux "
        "d'emploi des personnes concernées (72 % pour les seniors maintenus, 87,6 % pour les "
        "immigrés), puis l'écart à l'emploi d'équilibre se résorbe de 20 % par an. Le chômage "
        "réagit donc d'abord à la composition de la population active, puis revient vers son "
        "niveau d'avant choc.",
        lambda e: e["chomagePb"] / 100, "Taux de chômage (%), scénario central", 1, NBSP + "%",
        lambda v: pct_pb(v, 2), valeur_table=lambda e: e["chomagePb"])
    story.append(CondPageBreak(150 * mm))
    story += section_deficit_chomage(D)
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Population active",
        "Nombre d'actifs (en emploi ou au chômage). Il dépend de la démographie et de l'âge légal "
        "de départ à la retraite : chaque mois de recul ajoute environ 30 000 actifs (INSEE). "
        "L'âge légal suit le calendrier en vigueur (62 ans et 9 mois jusqu'en 2027, 64 ans en "
        "2033) ; les programmes qui le fixent s'en écartent par rapport à ce calendrier.",
        lambda e: e["actifs"] / 1e6, "Population active (millions), scénario central", 1, "",
        lambda v: nombre(v / 1e6, 3), valeur_table=lambda e: e["actifs"],
        note="Tableau en millions de personnes.")
    story.append(CondPageBreak(150 * mm))
    story += section_emploi(D)
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Indice de développement humain",
        "IDH selon la formule du PNUD : moyenne géométrique des indices d'espérance de vie à la "
        "naissance, de scolarisation (durée attendue et durée moyenne) et de RNB par habitant en "
        "volume (logarithme, dollars PPA constants). L'espérance de vie suit la tendance de "
        "l'INSEE, plus les années de vie gagnées par les mesures (décès évités) ; la scolarisation, "
        "les tendances observées et les mesures d'éducation ; le RNB par habitant, le PIB en volume "
        "et la population.",
        lambda e: e["idhMillioniemes"] / 1e6, "IDH, scénario central", 3, "",
        lambda v: nombre(v / 1e6, 4), valeur_table=lambda e: e["idhMillioniemes"])
    story.append(PageBreak())
    story += section_impots(D)
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Taux de prélèvements obligatoires", "Impôts et cotisations sociales rapportés au PIB.",
        lambda e: po_pb(e) / 100, "Prélèvements obligatoires (% du PIB), scénario central", 1,
        NBSP + "%", pct_pb, valeur_table=po_pb,
        note="Périmètre : impôts et cotisations sociales effectives des comptes des administrations "
             "publiques. Le taux officiel de prélèvements obligatoires de l'INSEE retient un "
             "périmètre un peu plus étroit, d'où un niveau légèrement inférieur.")
    story.append(CondPageBreak(130 * mm))
    story += section_petrole(D)
    story.append(CondPageBreak(120 * mm))
    story += section_natalite(D)
    story.append(PageBreak())
    story += section_climat(D)
    story.append(PageBreak())
    story += section_electricite(D)
    story.append(PageBreak())
    story += section_energie_cout(D)
    story.append(PageBreak())
    story += section_sols(D)
    story.append(PageBreak())
    story += section_air(D)
    story.append(PageBreak())
    story += section_heures(D)
    story.append(CondPageBreak(120 * mm))
    story += section_main_doeuvre(D)
    story.append(PageBreak())
    story += section_commerce(D)
    story.append(PageBreak())
    story += section_accidents(D)
    story.append(PageBreak())
    story += section_europe(D)
    story.append(PageBreak())
    story += section_constitution(D)
    story.append(PageBreak())
    story += section_budget(D)
    story.append(PageBreak())
    story += section_effets(D)
    story.append(PageBreak())
    story += section_retro(D)
    story.append(PageBreak())
    story += section_moteurs(D)
    story.append(CondPageBreak(120 * mm))
    story += section_proprietes(D)
    story += section_annexes(D)

    def pied(canvas, doc):
        canvas.saveState()
        canvas.setFont("Sans", 6.8)
        canvas.setFillColor(colors.HexColor(MUTED))
        canvas.drawString(18 * mm, 10 * mm,
                          f"Synthèse des programmes {a0}–{a1} · TOrientationD/Programmes_Lean"
                          f"{meta['commit']} · modèle commun, chiffres indicatifs")
        canvas.drawRightString(A4[0] - 18 * mm, 10 * mm, str(doc.page))
        canvas.restoreState()

    doc = SimpleDocTemplate(str(sortie), pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm,
                            topMargin=16 * mm, bottomMargin=17 * mm,
                            title=("Synthèse des programmes" if not D.personnalisee
                                   else f"Synthèse personnalisée ({D.standard})"), author="TOrientationD",
                            subject=f"Projections {a0}–{a1} sous hypothèses partagées")
    doc.build(story, onFirstPage=pied, onLaterPages=pied)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("entree", help="JSON produit par Rapport.lean --synthese")
    ap.add_argument("sortie", help="PDF à écrire")
    ap.add_argument("--commit", default=os.environ.get("GITHUB_SHA"))
    ap.add_argument("--moteur", help="identifiant du moteur au centre de la synthèse (courbes, tableaux)")
    ap.add_argument("--programmes", help="identifiants de programmes à inclure, séparés par des virgules")
    a = ap.parse_args()
    d = json.loads(Path(a.entree).read_text(encoding="utf-8"))
    if d.get("version") != 1:
        print(f"Version de synthèse inattendue : {d.get('version')}", file=sys.stderr)
        return 1
    construire(d, Path(a.sortie), a.commit, a.moteur,
               [x.strip() for x in a.programmes.split(",") if x.strip()] if a.programmes else None)
    print(f"Synthèse PDF écrite : {a.sortie}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
