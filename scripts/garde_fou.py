#!/usr/bin/env python3
"""Garde-fou syntaxique, lancé AVANT toute compilation.

Usage :
    python3 -I scripts/garde_fou.py [RACINE]

Pourquoi : `lake build` exécute du code au moment de la compilation
(`#eval`, `run_cmd`, `elab`, `initialize`…). Sur une PR, ce code vient de
l'auteur de la PR. Il pourrait remplacer le binaire `lean`, désactiver le
noyau (`set_option debug.skipKernelTC true`) ou réécrire le rapport, et
rendre verts des engagements faux.

Ce script interdit donc, dans tous les fichiers Lean du dépôt sauf
l'outillage (`Rapport.lean`, `Audit.lean`), toute primitive qui exécute du
code ou contourne le noyau. Il contrôle aussi la configuration de build
(`lakefile.toml`, `lean-toolchain`, `lake-manifest.json`).

En CI, c'est la version de la BRANCHE DE BASE de ce script qui est
exécutée : une PR ne peut pas l'assouplir pour elle-même.

Les commentaires et les chaînes sont retirés avant l'analyse : écrire
« sorry » dans une docstring ou un titre de mesure est permis.
"""

from __future__ import annotations

import json
import re
import sys
import tomllib
from pathlib import Path

# Fichiers d'outillage : ils ont besoin d'IO ou de métaprogrammation. Toute
# PR qui les modifie est signalée comme « verdict à relire » par le
# commentaire de PR (voir .github/workflows/commentaire-pr.yml).
OUTILLAGE = {"Rapport.lean", "Audit.lean"}

# Seules ces bibliothèques peuvent être importées hors outillage.
IMPORTS_AUTORISES = re.compile(r"(Modele|Hypotheses|Proprietes|Moteurs|Programmes|Engagements)(\.[A-Za-z0-9_]+)*")

# Mots-clés et identifiants interdits (après retrait des commentaires et chaînes).
INTERDITS = {
    # exécution de code à la compilation
    "run_cmd": "exécute du code à la compilation",
    "run_elab": "exécute du code à la compilation",
    "run_meta": "exécute du code à la compilation",
    "elab": "définit un élaborateur (code exécuté à la compilation)",
    "elab_rules": "définit un élaborateur (code exécuté à la compilation)",
    "macro": "définit une macro",
    "macro_rules": "définit une macro",
    "syntax": "étend la syntaxe",
    "declare_syntax_cat": "étend la syntaxe",
    "initialize": "code exécuté au chargement",
    "builtin_initialize": "code exécuté au chargement",
    "run_tac": "exécute du code à la compilation",
    "by_elab": "exécute du code à la compilation",
    # contournement du noyau ou du compilateur
    "set_option": "options du compilateur (ex. debug.skipKernelTC)",
    "attribute": "attributs arbitraires (ex. implemented_by)",
    "implemented_by": "le code compilé diffère de la définition vérifiée",
    "extern": "le code compilé diffère de la définition vérifiée",
    "opaque": "définition opaque",
    "unsafe": "code non sûr",
    "native_decide": "fait confiance au compilateur plutôt qu'au noyau",
    "ofReduceBool": "fait confiance au compilateur plutôt qu'au noyau",
    "reduceBool": "fait confiance au compilateur plutôt qu'au noyau",
    # preuves manquantes ou hypothèses déguisées
    "sorry": "preuve manquante",
    "sorryAx": "preuve manquante",
    "admit": "preuve manquante",
    "axiom": "une hypothèse doit être une donnée (def), jamais un axiome",
}
# Identifiants qui COMMENCENT par ces préfixes (unsafeBaseIO, unsafeCast…).
PREFIXES_INTERDITS = {"unsafe": "code non sûr"}

ATTRIBUTS_AUTORISES = {"simp", "reducible", "irreducible", "inline", "instance"}

IDENT = r"[A-Za-z_À-ɏͰ-Ͽᴀ-ᶿ⁰-₟][A-Za-z0-9_'!?À-ɏͰ-Ͽᴀ-ᶿ⁰-₟]*"
RE_IDENT = re.compile(rf"(?<![A-Za-z0-9_'.]){IDENT}(?:\.{IDENT})*")


def retirer_commentaires_et_chaines(src: str) -> str:
    """Remplace commentaires, chaînes et caractères littéraux par des espaces
    (en conservant les retours à la ligne pour les numéros de ligne)."""
    out: list[str] = []
    i, n = 0, len(src)

    def blanc(s: str) -> str:
        return "".join("\n" if c == "\n" else " " for c in s)

    while i < n:
        c = src[i]
        if src.startswith("--", i):
            j = src.find("\n", i)
            j = n if j < 0 else j
            out.append(blanc(src[i:j]))
            i = j
        elif src.startswith("/-", i):
            profondeur, j = 1, i + 2
            while j < n and profondeur:
                if src.startswith("/-", j):
                    profondeur, j = profondeur + 1, j + 2
                elif src.startswith("-/", j):
                    profondeur, j = profondeur - 1, j + 2
                else:
                    j += 1
            out.append(blanc(src[i:j]))
            i = j
        elif c == '"':
            j = i + 1
            while j < n and src[j] != '"':
                j += 2 if src[j] == "\\" else 1
            out.append(blanc(src[i:j + 1]))
            i = j + 1
        elif c == "'" and (i == 0 or not re.match(r"[A-Za-z0-9_'!?.]", src[i - 1])):
            m = re.match(r"'(\\.[^']*|[^\\'])'", src[i:])
            if m:
                out.append(blanc(m.group(0)))
                i += len(m.group(0))
            else:
                out.append(c)
                i += 1
        else:
            out.append(c)
            i += 1
    return "".join(out)


def analyser_lean(chemin: Path, rel: str) -> list[str]:
    code = retirer_commentaires_et_chaines(chemin.read_text(encoding="utf-8"))
    fautes: list[str] = []

    def ligne(pos: int) -> int:
        return code.count("\n", 0, pos) + 1

    for m in re.finditer(r"^\s*import\s+(\S+)", code, re.M):
        if not IMPORTS_AUTORISES.fullmatch(m.group(1)):
            fautes.append(f"{rel}:{ligne(m.start())} : import interdit `{m.group(1)}` "
                          "(seules les bibliothèques du dépôt sont autorisées)")

    for m in re.finditer(r"(?<![A-Za-z0-9_'])#[A-Za-z_]+", code):
        fautes.append(f"{rel}:{ligne(m.start())} : commande `{m.group(0)}` interdite "
                      "(les commandes # exécutent du code à la compilation)")

    for m in re.finditer("\u00ab", code):
        fautes.append(f"{rel}:{ligne(m.start())} : identifiant entre « » interdit "
                      "(contournerait l'analyse des identifiants)")

    for m in re.finditer(r"@\[([^\]]*)\]", code):
        for attr in (a.strip() for a in m.group(1).split(",")):
            nom = attr.split()[0] if attr.split() else ""
            if nom in ("local", "scoped") and len(attr.split()) > 1:
                nom = attr.split()[1]
            if nom not in ATTRIBUTS_AUTORISES:
                fautes.append(f"{rel}:{ligne(m.start())} : attribut `@[{attr}]` interdit "
                              f"(autorisés : {', '.join(sorted(ATTRIBUTS_AUTORISES))})")

    for m in RE_IDENT.finditer(code):
        for morceau in m.group(0).split("."):
            raison = INTERDITS.get(morceau)
            if raison is None:
                raison = next((r for p, r in PREFIXES_INTERDITS.items() if morceau.startswith(p)), None)
            if raison:
                fautes.append(f"{rel}:{ligne(m.start())} : `{m.group(0)}` interdit — {raison}")
                break
    return fautes


def analyser_config(racine: Path) -> list[str]:
    fautes: list[str] = []

    if (racine / "lakefile.lean").exists():
        fautes.append("lakefile.lean : interdit (exécuté par Lake) — utiliser lakefile.toml")

    tc = (racine / "lean-toolchain").read_text(encoding="utf-8").strip()
    if not re.fullmatch(r"leanprover/lean4:v\d+\.\d+\.\d+(-rc\d+)?", tc):
        fautes.append(f"lean-toolchain : `{tc}` — seule une version officielle "
                      "leanprover/lean4:vX.Y.Z est acceptée")

    manifeste = racine / "lake-manifest.json"
    if manifeste.exists() and json.loads(manifeste.read_text(encoding="utf-8")).get("packages"):
        fautes.append("lake-manifest.json : dépendances externes interdites sans revue du socle")

    cfg = tomllib.loads((racine / "lakefile.toml").read_text(encoding="utf-8"))
    cles = {"name", "version", "defaultTargets", "leanOptions", "lean_lib", "lean_exe"}
    for k in cfg.keys() - cles:
        fautes.append(f"lakefile.toml : clé `{k}` interdite (autorisées : {', '.join(sorted(cles))})")
    options = {"autoImplicit", "relaxedAutoImplicit"}
    for k in cfg.get("leanOptions", {}).keys() - options:
        fautes.append(f"lakefile.toml : option Lean `{k}` interdite")
    for cible, autorisees in (("lean_lib", {"name", "globs", "roots", "srcDir"}),
                              ("lean_exe", {"name", "root", "srcDir"})):
        for t in cfg.get(cible, []):
            for k in t.keys() - autorisees:
                fautes.append(f"lakefile.toml : `{k}` interdit dans [[{cible}]] {t.get('name', '?')}")
    return fautes


def main() -> int:
    racine = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    fautes = analyser_config(racine)
    fichiers = sorted(p for p in racine.rglob("*.lean")
                      if ".lake" not in p.parts and not any(x.startswith(".") for x in p.relative_to(racine).parts))
    nb = 0
    for f in fichiers:
        rel = f.relative_to(racine).as_posix()
        if rel in OUTILLAGE:
            continue
        nb += 1
        fautes += analyser_lean(f, rel)
    for e in fautes:
        print(f"ERREUR : {e}", file=sys.stderr)
    if not fautes:
        print(f"Garde-fou OK : {nb} fichiers Lean, configuration de build conforme.")
    return 1 if fautes else 0


if __name__ == "__main__":
    sys.exit(main())
