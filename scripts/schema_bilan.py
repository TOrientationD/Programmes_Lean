"""Schéma des actifs et passifs des administrations publiques, 2027 et 2035,
tendanciel et Texte Orientation D (scénario central, moteur de demande).
Sources : Insee, comptes de patrimoine fin 2025 (actifs non financiers 2 945,
actifs financiers 1 718, passifs 3 913 dont dette de Maastricht 3 460 Md€) ;
Banque de France (or 257 Md€ fin 2025) ; compte général de l'État 2025
(retraites des fonctionnaires 1 283 Md€) ; modèle commun pour la dette, les
passifs implicites, le capital public et les participations des mesures.
Hypothèse : les actifs et les autres passifs hors modèle gardent leur part
du PIB de 2025."""
import json
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter

PIB25 = 2991.0
ANF25, AF25, PASSIFS25, MAASTRICHT25, OR25, RETRAITES25 = 2945.0, 1718.0, 3913.0, 3460.0, 257.0, 1283.0
AUTRES25 = PASSIFS25 - MAASTRICHT25
PROG = "TexteOrientationD"
# usage : python3 scripts/schema_bilan.py synthese.json [sortie.png] [programme]
d = json.load(open(sys.argv[1]))
sortie = sys.argv[2] if len(sys.argv) > 2 else "schema_actifs_dette_2027_2035.png"
PROG = sys.argv[3] if len(sys.argv) > 3 else PROG
NOM_PROG = next(p["nom"] for p in d["programmes"] if p["id"] == PROG)
v = next(x for x in d["variantes"] if x["id"] == "central")["moteurs"][d["moteurStandard"]]
annees = d["annees"]
PARTICIP0 = v["tendanciel"][0]["participationsEtat"] / 1000
def cas_de(e, or_):
    return dict(pib=e["pib"] / 1000, dette=e["dette"] / 1000, passifs=e["passifsImplicites"] / 1000,
                cap=e.get("capitalPublicMesures", 0) / 1000, particip=e["participationsEtat"] / 1000, or_=or_)
def or_(prog, annee):
    # vente de la moitié de l'or de 2027 à 2032 (O-149) : hypothèse lue dans le programme seul
    if prog != "TexteOrientationD":
        return OR25
    return OR25 * (1 - min(max(annee - 2026, 0), 6) / 12)
cas = {}
for annee in (2027, 2035):
    i = annees.index(annee)
    cas[(annee, "tend")] = cas_de(v["tendanciel"][i], OR25)
    cas[(annee, "tod")] = cas_de(v["programmes"][PROG][i], or_(PROG, annee))
def bilan(c):
    r = c["pib"] / PIB25
    anf = ANF25 * r + c["cap"]
    af = AF25 * r + (c["particip"] - PARTICIP0)
    autres = AUTRES25 * r
    return dict(anf=anf, af=af, dette=c["dette"], autres=autres, implicites=c["passifs"],
                net=anf + af - c["dette"] - autres - c["passifs"], pib=c["pib"], or_=c["or_"],
                retraites=RETRAITES25 * r)

INK, INK2, MUTED, GRID, SURFACE = "#0b0b0b", "#52514e", "#898781", "#e1e0d9", "#ffffff"
C_ANF, C_AF, C_DETTE, C_AUTRES, C_IMPL = "#2a78d6", "#86b6ef", "#eb6834", "#f3a583", "#e34948"
plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 9, "axes.edgecolor": GRID,
                     "axes.labelcolor": INK2, "xtick.color": INK2, "ytick.color": INK2,
                     "axes.spines.top": False, "axes.spines.right": False, "axes.spines.left": False})
fig, axes = plt.subplots(1, 2, figsize=(13, 7.4), sharey=True)
fig.patch.set_facecolor(SURFACE)
def seg(ax, x, bottom, h, color, label, w=0.55):
    if h <= 0: return bottom
    ax.bar(x, h - 8, bottom=bottom + 4, width=w, color=color, edgecolor="none", zorder=3)
    if h > 150:
        ax.text(x, bottom + h / 2, f"{label}\n{h:,.0f}".replace(",", " "), ha="center", va="center",
                fontsize=8, color="white" if color in (C_ANF, C_DETTE, C_IMPL) else INK)
    return bottom + h
for ax, annee in zip(axes, (2027, 2035)):
    ax.set_facecolor(SURFACE)
    ax.set_title(f"{annee}", fontsize=13, color=INK, loc="left", pad=10)
    ax.yaxis.grid(True, color=GRID, lw=0.6, zorder=0)
    ax.set_axisbelow(True)
    xs = {"tend": (0, 1), "tod": (2.6, 3.6)}
    for cle, nom in (("tend", "Sans programme"), ("tod", NOM_PROG)):
        b = bilan(cas[(annee, cle)])
        xa, xp = xs[cle]
        t = seg(ax, xa, 0, b["anf"], C_ANF, "Actifs non\nfinanciers")
        t = seg(ax, xa, t, b["af"], C_AF, "Actifs\nfinanciers")
        u = seg(ax, xp, 0, b["dette"], C_DETTE, "Dette\n(Maastricht)")
        u = seg(ax, xp, u, b["autres"], C_AUTRES, "Autres\npassifs")
        u2 = seg(ax, xp, u, b["implicites"], C_IMPL, "")
        ax.text(xa, t + 120, f"Actifs {t:,.0f}".replace(",", " "), ha="center", va="bottom", fontsize=8.5, color=INK)
        ax.text(xp, u2 + 120, f"Passifs {u2:,.0f}".replace(",", " "), ha="center", va="bottom", fontsize=8.5, color=INK)
        signe = "+" if b["net"] >= 0 else "−"
        ax.text((xa + xp) / 2, -450, f"{nom}", ha="center", va="top", fontsize=9.5, color=INK,
                fontweight="bold" if cle == "tod" else "normal")
        ax.text((xa + xp) / 2, -900, f"valeur nette {signe}{abs(b['net']):,.0f} Md€ ({b['net'] / b['pib'] * 100:+.0f} % du PIB)".replace(",", " "),
                ha="center", va="top", fontsize=8.5, color=INK)
        ax.text((xa + xp) / 2, -1300,
                f"dette {b['dette'] / b['pib'] * 100:.0f} % du PIB\npassifs implicites {b['implicites']:.0f} Md€\n"
                f"or de la Banque de France {b['or_']:.0f} Md€ (hors APU)\n"
                f"retraites des fonctionnaires ≈ {b['retraites']:,.0f} Md€ (hors bilan)".replace(",", " "),
                ha="center", va="top", fontsize=7.5, color=INK2, linespacing=1.5)
    ax.set_xticks([]); ax.set_xlim(-0.6, 4.2); ax.set_ylim(0, 7600)
    ax.yaxis.set_major_formatter(FuncFormatter(lambda v, _: f"{v:,.0f}".replace(",", " ")))
axes[0].set_ylabel("Md€ courants", color=INK2)
fig.suptitle("Actifs et dette des administrations publiques, 2027 et 2035 — scénario central, moteur de demande",
             x=0.01, ha="left", fontsize=12, color=INK, y=0.995)
fig.text(0.01, 0.945, "Insee (comptes de patrimoine fin 2025), Banque de France, compte général de l'État 2025 ; "
         "dette, passifs implicites, capital public et participations : modèle commun.\nActifs et autres passifs "
         "hors modèle à leur part du PIB de 2025 (hypothèse). Md€ courants.", fontsize=7.5, color=INK2, va="top", linespacing=1.4)
fig.subplots_adjust(left=0.06, right=0.99, top=0.85, bottom=0.30, wspace=0.06)
fig.savefig(sortie, dpi=170, facecolor=SURFACE)
if sortie.endswith(".png"):
    fig.savefig(sortie[:-4] + ".svg", facecolor=SURFACE)
for annee in (2027, 2035):
    for cle in ("tend", "tod"):
        b = bilan(cas[(annee, cle)])
        print(annee, cle, {k: round(v) for k, v in b.items()})
