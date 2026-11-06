#!/usr/bin/env python3
"""Vérifie la cohérence entre les dossiers de Programmes/ et le registre
Programmes.lean.

Usage :
    python3 -I scripts/verifier_registre.py [RACINE]

Pour chaque dossier `Programmes/X/` :
  - `Programme.lean` existe et déclare `id := "X"` ;
  - `Programmes.lean` importe `Programmes.X.Programme` et liste `X.programme` ;
  - `Programmes/X/PROPRIETAIRES` nomme au moins un compte GitHub valide
    (c'est lui que lit le contrôle d'accès, voir controle_acces.py).
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

def main() -> int:
    # En CI, le script vient de la branche de base et s'applique à la PR :
    # la racine est passée en argument.
    RACINE = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent).resolve()
    erreurs: list[str] = []
    registre = (RACINE / "Programmes.lean").read_text(encoding="utf-8")

    dossiers = sorted(d for d in (RACINE / "Programmes").iterdir() if d.is_dir())
    if not dossiers:
        erreurs.append("aucun programme dans Programmes/")

    for d in dossiers:
        x = d.name
        if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", x):
            erreurs.append(f"{x} : le nom de dossier doit être un identifiant Lean ASCII "
                           "(lettres, chiffres, _ ; commence par une lettre)")
            continue
        prog = d / "Programme.lean"
        if not prog.exists():
            erreurs.append(f"{x} : Programme.lean manquant")
            continue
        if not re.search(rf'\bid\s*:=\s*"{re.escape(x)}"', prog.read_text(encoding="utf-8")):
            erreurs.append(f'{x} : Programme.lean doit déclarer id := "{x}"')
        if f"import Programmes.{x}.Programme" not in registre:
            erreurs.append(f"{x} : import manquant dans Programmes.lean")
        if not re.search(rf"\b{re.escape(x)}\.programme\b", registre.split("def tous", 1)[-1]):
            erreurs.append(f"{x} : absent de Programmes.tous")
        proprietaires = d / "PROPRIETAIRES"
        comptes = [l.split("#", 1)[0].strip().lstrip("@")
                   for l in proprietaires.read_text(encoding="utf-8").splitlines()] \
            if proprietaires.exists() else []
        comptes = [c for c in comptes if c]
        if not comptes:
            erreurs.append(f"{x} : Programmes/{x}/PROPRIETAIRES absent ou vide")
        for c in comptes:
            if not re.fullmatch(r"[A-Za-z0-9](?:[A-Za-z0-9-]{0,37}[A-Za-z0-9])?", c):
                erreurs.append(f"{x} : compte GitHub invalide dans PROPRIETAIRES : {c}")

    # Moteurs contribués : même discipline (dossier, id, import, registre, propriétaires).
    moteurs = sorted(d for d in (RACINE / "Moteurs").iterdir() if d.is_dir()) \
        if (RACINE / "Moteurs").is_dir() else []
    reg_m = (RACINE / "Moteurs.lean").read_text(encoding="utf-8") if (RACINE / "Moteurs.lean").exists() else ""
    for d in moteurs:
        x = d.name
        if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", x):
            erreurs.append(f"Moteurs/{x} : le nom de dossier doit être un identifiant Lean ASCII")
            continue
        f = d / "Moteur.lean"
        if not f.exists():
            erreurs.append(f"Moteurs/{x} : Moteur.lean manquant")
            continue
        if not re.search(rf'\bid\s*:=\s*"{re.escape(x)}"', f.read_text(encoding="utf-8")):
            erreurs.append(f'Moteurs/{x} : Moteur.lean doit déclarer id := "{x}"')
        if f"import Moteurs.{x}.Moteur" not in reg_m:
            erreurs.append(f"Moteurs/{x} : import manquant dans Moteurs.lean")
        if not re.search(rf"\b{re.escape(x)}\.moteur\b", reg_m.split("def contribues", 1)[-1]):
            erreurs.append(f"Moteurs/{x} : absent de Moteurs.contribues")
        proprietaires = d / "PROPRIETAIRES"
        comptes = [l.split("#", 1)[0].strip().lstrip("@")
                   for l in proprietaires.read_text(encoding="utf-8").splitlines()] \
            if proprietaires.exists() else []
        if not [c for c in comptes if c]:
            erreurs.append(f"Moteurs/{x} : PROPRIETAIRES absent ou vide")

    for e in erreurs:
        print(f"ERREUR : {e}", file=sys.stderr)
    if not erreurs:
        print(f"Registre OK : {len(dossiers)} programmes, {len(moteurs)} moteurs contribués.")
    return 1 if erreurs else 0


if __name__ == "__main__":
    sys.exit(main())
