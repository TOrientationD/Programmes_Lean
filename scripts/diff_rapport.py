#!/usr/bin/env python3
"""Compare deux rapports JSON (base vs PR) et produit un résumé Markdown.

Usage :
    python3 scripts/diff_rapport.py BASE.json PR.json [--fichiers CHANGES.txt] [--out DIFF.md]

`--fichiers` : liste des chemins modifiés par la PR (un par ligne), pour
indiquer si la PR touche le socle commun (et donc tous les programmes).
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

SOCLE = ("Modele/", "Modele.lean", "Hypotheses/", "Hypotheses.lean",
         "Proprietes/", "Proprietes.lean", "lakefile.toml", "lean-toolchain")
INDICATEURS = [("deficitPb", "Déficit % PIB", True), ("dettePb", "Dette % PIB", True),
               ("chomagePb", "Chômage %", True), ("emissionsMt", "Émissions Mt", False),
               ("actifs", "Actifs", False), ("decesPollutionAir", "Décès pollution", False)]
MAX_LIGNES = 30


def charger(chemin: str) -> dict:
    p = Path(chemin)
    if not p.exists():
        return {"scenarios": [], "proprietes": [], "programmes": [], "erreurs": []}
    return json.loads(p.read_text(encoding="utf-8"))


def fmt(v: int, pb: bool) -> str:
    if not pb:
        return str(v)
    signe = "-" if v < 0 else ""
    a = abs(v)
    return f"{signe}{a // 100},{a % 100:02d}"


def cle(ev: dict) -> str:
    """Scénario préfixé du moteur (les rapports antérieurs à la version 2 n'en ont pas)."""
    return f"{ev.get('moteur', 'demande')}:{ev['scenario']}"


def index_cellules(r: dict) -> dict:
    out = {}
    for p in r.get("programmes", []):
        for ev in p["evaluations"]:
            for prop, ok in ev["proprietes"].items():
                out[(p["id"], cle(ev), prop)] = ok
    return out


def index_indicateurs(r: dict) -> dict:
    return {(p["id"], cle(ev)): ev["programme"]
            for p in r.get("programmes", []) for ev in p["evaluations"]}


def index_engagements(r: dict) -> dict:
    return {(p["id"], cle(e), e["propriete"]): e["tenu"]
            for p in r.get("programmes", []) for e in p["engagements"]}


def index_contrats(r: dict) -> set:
    return {(p["id"], c["mesure"], c["titre"])
            for p in r.get("programmes", []) for c in p.get("contrats", [])}


def index_sru(r: dict) -> dict:
    return {(p["id"], l["mesure"], l["commune"]): l
            for p in r.get("programmes", []) for l in p.get("sru", [])}


def euros(v: int) -> str:
    return f"{v:,}".replace(",", "\u202f") + " €"


def mesures_communales(base: dict, pr: dict) -> list[str]:
    out: list[str] = []
    cb, cp = index_contrats(base), index_contrats(pr)
    ajoutes, retires = sorted(cp - cb), sorted(cb - cp)
    if ajoutes or retires:
        out += ["", "### Contrats de mesure", ""]
        out += [f"- ✅ ajouté : {k[0]} {k[1]} — {k[2]}" for k in ajoutes]
        out += [f"- ⚠️ retiré : {k[0]} {k[1]} — {k[2]} (à justifier dans la PR)" for k in retires]

    sb, sp = index_sru(base), index_sru(pr)
    lignes = []
    for k in sorted(sp):
        avant = sb.get(k, {}).get("amende")
        apres = sp[k]["amende"]
        if avant != apres:
            lignes.append(f"| {k[0]} | {k[1]} | {k[2]} | {euros(sp[k]['actuel'])} | "
                          f"{'—' if avant is None else euros(avant)} | {euros(apres)} |")
    if lignes:
        out += ["", f"<details><summary>Amendes SRU modifiées sur le panel communal ({len(lignes)})</summary>",
                "", "| Programme | Mesure | Commune | Droit actuel | Avant | Après |",
                "| --- | --- | --- | --- | --- | --- |"]
        out += lignes[:MAX_LIGNES] + ["", "</details>"]
    return out


def pastille(k: int, n: int) -> str:
    """Part des scénarios où une propriété tient, en quatre paliers (même
    règle que `pastille` dans Rapport.lean) : rouge (moins d'un quart),
    orange (jusqu'aux trois quarts), jaune, vert (tous)."""
    if n == 0:
        return ""
    if k == n:
        return "🟩"
    if 3 * n <= 4 * k:
        return "🟨"
    return "🟧" if n <= 4 * k else "🟥"


def ids(r: dict, cle: str) -> set:
    return {x["id"] for x in r.get(cle, [])}


def perimetre(fichiers: list[str]) -> list[str]:
    lignes = []
    socle = sorted({f for f in fichiers if f.startswith(SOCLE)})
    progs = sorted({f.split("/")[1] for f in fichiers
                    if f.startswith("Programmes/") and f.count("/") >= 2})
    mots = sorted({f.split("/")[1] for f in fichiers
                   if f.startswith("Moteurs/") and f.count("/") >= 2})
    if socle:
        lignes.append("> ⚠️ **Cette PR modifie le socle commun** (modèle, hypothèses ou "
                      "propriétés) : elle change l'évaluation de **tous** les programmes "
                      "et requiert la revue des mainteneurs du socle.")
        lignes.append(">")
        lignes.append("> Fichiers du socle : " + ", ".join(f"`{f}`" for f in socle))
    if progs:
        if lignes:
            lignes.append("")
        lignes.append("Programmes modifiés : " + ", ".join(f"`{p}`" for p in progs))
    if mots:
        if lignes:
            lignes.append("")
        lignes.append("Moteurs contribués modifiés : " + ", ".join(f"`{m}`" for m in mots)
                      + " (l'évaluation de tous les programmes sous ce moteur change ; les autres moteurs sont inchangés)")
    return lignes


def nouveautes(base: dict, pr: dict) -> list[str]:
    """Résultats des lignes, colonnes ou programmes ajoutés par la PR (absents
    du diff cellule à cellule, qui ne compare que l'existant)."""
    if not base.get("programmes"):
        return []  # pas de base : tout serait « nouveau »
    out: list[str] = []
    props = [q["id"] for q in pr.get("proprietes", [])]
    nb_scen = len(pr.get("scenarios", []))

    nouveaux_s = ids(pr, "scenarios") - ids(base, "scenarios")
    lignes = [f"| {p['id']} | {cle(ev)} | "
              + " | ".join("✅" if ev["proprietes"].get(q) else "❌" for q in props) + " |"
              for p in pr["programmes"] if p["id"] in ids(base, "programmes")
              for ev in p["evaluations"] if ev["scenario"] in nouveaux_s]
    if lignes:
        out += ["", f"### Résultats sous les nouveaux scénarios ({len(nouveaux_s)})", "",
                "| Programme | Scénario | " + " | ".join(props) + " |",
                "| --- | --- | " + " | ".join("---" for _ in props) + " |"]
        out += lignes[:MAX_LIGNES]
        if len(lignes) > MAX_LIGNES:
            out.append(f"| … | {len(lignes) - MAX_LIGNES} de plus | " + " | ".join("" for _ in props) + " |")

    nb_mot = max(1, len(pr.get("moteurs", [])) or 1)

    def tenues(p: dict, q: str) -> str:
        k, n = sum(1 for ev in p['evaluations'] if ev['proprietes'].get(q)), nb_scen * nb_mot
        return f"{pastille(k, n)} {k}/{n}"

    nouveaux_p = [p for p in pr["programmes"] if p["id"] not in ids(base, "programmes")]
    if nouveaux_p:
        out += ["", "### Nouveaux programmes : scénarios où la propriété tient", "",
                "| Programme | " + " | ".join(props) + " |",
                "| --- | " + " | ".join("---" for _ in props) + " |"]
        out += [f"| {p['id']} | " + " | ".join(tenues(p, q) for q in props) + " |" for p in nouveaux_p]

    nouvelles_q = [q for q in props if q not in ids(base, "proprietes")]
    if nouvelles_q:
        out += ["", "### Nouvelles propriétés : scénarios où elles tiennent", "",
                "| Programme | " + " | ".join(nouvelles_q) + " |",
                "| --- | " + " | ".join("---" for _ in nouvelles_q) + " |"]
        out += [f"| {p['id']} | " + " | ".join(tenues(p, q) for q in nouvelles_q) + " |"
                for p in pr["programmes"]]
    return out


def diff(base: dict, pr: dict, fichiers: list[str]) -> str:
    out = ["## Impact de la PR sur l'évaluation", ""]
    out += perimetre(fichiers)
    if out[-1] != "":
        out.append("")

    for k, nom in (("programmes", "Programmes"), ("moteurs", "Moteurs"),
                   ("scenarios", "Scénarios"), ("proprietes", "Propriétés")):
        ajout = sorted(ids(pr, k) - ids(base, k))
        retrait = sorted(ids(base, k) - ids(pr, k))
        if ajout:
            out.append(f"- {nom} ajoutés : " + ", ".join(f"`{x}`" for x in ajout))
        if retrait:
            out.append(f"- {nom} retirés : " + ", ".join(f"`{x}`" for x in retrait))

    out += nouveautes(base, pr)
    out += mesures_communales(base, pr)

    # Engagements
    eb, ep = index_engagements(base), index_engagements(pr)
    casses = sorted(k for k, v in ep.items() if not v)
    nouvellement_casses = [k for k in casses if eb.get(k, True)]
    if casses:
        out += ["", "### ❌ Engagements non tenus", "",
                "| Programme | Scénario | Propriété | Nouveau ? |", "| --- | --- | --- | --- |"]
        for k in casses[:MAX_LIGNES]:
            out.append(f"| {k[0]} | {k[1]} | {k[2]} | {'oui' if k in nouvellement_casses else 'non'} |")
        if len(casses) > MAX_LIGNES:
            out.append(f"| … | {len(casses) - MAX_LIGNES} de plus | | |")

    # Cellules de la matrice
    cb, cp = index_cellules(base), index_cellules(pr)
    changes = sorted(k for k in cb.keys() & cp.keys() if cb[k] != cp[k])
    if changes:
        out += ["", f"### Propriétés qui changent de statut ({len(changes)})", "",
                "| Programme | Scénario | Propriété | Avant | Après |",
                "| --- | --- | --- | --- | --- |"]
        for k in changes[:MAX_LIGNES]:
            out.append(f"| {k[0]} | {k[1]} | {k[2]} | {'✅' if cb[k] else '❌'} | {'✅' if cp[k] else '❌'} |")
        if len(changes) > MAX_LIGNES:
            out.append(f"| … | {len(changes) - MAX_LIGNES} de plus | | | |")

    # Indicateurs
    ib, ip = index_indicateurs(base), index_indicateurs(pr)
    lignes = []
    for k in sorted(ib.keys() & ip.keys()):
        deltas = []
        for champ, libelle, pb in INDICATEURS:
            a, b = ib[k].get(champ), ip[k].get(champ)
            if a is not None and b is not None and a != b:
                deltas.append(f"{libelle} {fmt(a, pb)} → {fmt(b, pb)}")
        if deltas:
            lignes.append(f"| {k[0]} | {k[1]} | {'<br>'.join(deltas)} |")
    if lignes:
        out += ["", f"<details><summary>Indicateurs modifiés ({len(lignes)} couples programme × scénario)</summary>",
                "", "| Programme | Scénario | Changements |", "| --- | --- | --- |"]
        out += lignes[:MAX_LIGNES]
        if len(lignes) > MAX_LIGNES:
            out.append(f"| … | {len(lignes) - MAX_LIGNES} de plus | |")
        out += ["", "</details>"]

    if pr.get("erreurs"):
        out += ["", "### ⛔ Erreurs de registre", ""] + [f"- {e}" for e in pr["erreurs"]]

    axes_changes = any(ids(pr, c) != ids(base, c)
                       for c in ("scenarios", "programmes", "proprietes", "moteurs"))
    if not (changes or lignes or casses or pr.get("erreurs")) and len(out) <= 3:
        out.append("Aucun changement d'évaluation.")
    elif not (changes or lignes or casses or pr.get("erreurs")) and axes_changes:
        out += ["", "Aucune cellule commune à la base et à la PR n'a changé. Des scénarios, "
                "programmes ou propriétés ont été ajoutés ou retirés : leurs résultats ne se "
                "comparent pas cellule à cellule (voir les tableaux ci-dessus et le rapport complet)."]
    elif not (changes or lignes or casses or pr.get("erreurs")):
        out += ["", "Aucun changement de la matrice d'évaluation (propriétés et indicateurs macro)."]
    return "\n".join(out) + "\n"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("base")
    ap.add_argument("pr")
    ap.add_argument("--fichiers")
    ap.add_argument("--out")
    a = ap.parse_args()
    fichiers = []
    if a.fichiers and Path(a.fichiers).exists():
        fichiers = [l.strip() for l in Path(a.fichiers).read_text().splitlines() if l.strip()]
    texte = diff(charger(a.base), charger(a.pr), fichiers)
    if a.out:
        Path(a.out).write_text(texte, encoding="utf-8")
    else:
        sys.stdout.write(texte)
    return 0


if __name__ == "__main__":
    sys.exit(main())
