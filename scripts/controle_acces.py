#!/usr/bin/env python3
"""Contrôle d'accès aux dossiers de programmes.

Usage :
    python3 -I scripts/controle_acces.py EVENEMENT.json [RACINE_BASE]

Règle : un fichier sous `Programmes/<X>/` ou `Moteurs/<X>/` ne peut être
ajouté, modifié, renommé ou supprimé que par un propriétaire de `<X>`.

* `<X>` existe sur la branche de base : l'auteur de la PR doit figurer dans
  `Programmes/<X>/PROPRIETAIRES` **de la base**. Une PR ne peut donc pas
  s'ajouter elle-même comme propriétaire d'un programme existant.
* `<X>` est nouveau : son fichier `PROPRIETAIRES` **dans la PR** doit
  exister et nommer l'auteur. On ne crée pas de programme au nom d'autrui.

Les fichiers hors `Programmes/<X>/` (socle, registre, outillage) ne sont pas
concernés ici : ils relèvent de la revue des mainteneurs.

`EVENEMENT.json` est produit par `.github/workflows/acces-programmes.yml` :
    {"auteur": "login",
     "fichiers": [{"filename": "...", "previous_filename": null, "status": "modified"}],
     "proprietaires_tete": {"Programmes/X": "contenu de Programmes/X/PROPRIETAIRES dans la PR" | null}}

`RACINE_BASE` est un checkout de la branche de base (défaut : `.`). Le
script ne lit que des données : il n'exécute rien de la PR.

Sortie : résumé Markdown sur stdout ; code 1 si un accès est refusé.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

RE_COMPTE = re.compile(r"[A-Za-z0-9](?:[A-Za-z0-9-]{0,37}[A-Za-z0-9])?")
RE_PROGRAMME = re.compile(r"^(Programmes|Moteurs)/([^/]+)/")


def lire_proprietaires(texte: str | None) -> set[str]:
    """Un compte GitHub par ligne, `@` facultatif, `#` pour commenter."""
    comptes: set[str] = set()
    for ligne in (texte or "").splitlines():
        ligne = ligne.split("#", 1)[0].strip().lstrip("@")
        if ligne and RE_COMPTE.fullmatch(ligne):
            comptes.add(ligne.lower())
    return comptes


def programmes_touches(fichiers: list[dict]) -> dict[str, list[str]]:
    touches: dict[str, list[str]] = {}
    for f in fichiers:
        for chemin in (f.get("filename"), f.get("previous_filename")):
            if chemin and (m := RE_PROGRAMME.match(chemin)):
                cle = f"{m.group(1)}/{m.group(2)}"
                touches.setdefault(cle, [])
                if chemin not in touches[cle]:
                    touches[cle].append(chemin)
    return touches


def controler(evenement: dict, base: Path) -> tuple[bool, list[str]]:
    auteur = str(evenement["auteur"]).lower()
    touches = programmes_touches(evenement.get("fichiers", []))
    tete = evenement.get("proprietaires_tete", {})
    lignes = [f"### Contrôle d'accès aux programmes", "",
              f"Auteur de la PR : `@{evenement['auteur']}`", ""]
    if not touches:
        return True, lignes + ["Aucun dossier de programme ni de moteur modifié."]

    lignes += ["| Dossier | Statut | Propriétaires | Accès |", "| --- | --- | --- | --- |"]
    ok = True
    for x in sorted(touches):
        dossier_base = base / x
        if dossier_base.is_dir():
            fichier = dossier_base / "PROPRIETAIRES"
            proprietaires = lire_proprietaires(
                fichier.read_text(encoding="utf-8") if fichier.is_file() else None)
            statut = "existant (propriétaires lus sur la base)"
        else:
            proprietaires = lire_proprietaires(tete.get(x))
            statut = "nouveau (propriétaires lus dans la PR)"
        autorise = auteur in proprietaires
        ok &= autorise
        liste = ", ".join(f"@{p}" for p in sorted(proprietaires)) or "aucun"
        lignes.append(f"| `{x}` | {statut} | {liste} | {'✅' if autorise else '❌'} |")

    lignes.append("")
    if ok:
        lignes.append("Accès autorisé.")
    else:
        lignes += [
            "**Accès refusé.** Un dossier `Programmes/<X>/` ou `Moteurs/<X>/` ne se "
            "modifie que par ses propriétaires (fichier `PROPRIETAIRES` du dossier). Pour "
            "proposer une modification au programme ou au moteur de quelqu'un d'autre, ouvrez "
            "une issue ou soumettez-la à l'un de ses propriétaires. Pour créer un programme ou "
            "un moteur, listez votre compte dans son fichier `PROPRIETAIRES`."]
    return ok, lignes


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2
    evenement = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    base = Path(sys.argv[2] if len(sys.argv) > 2 else ".").resolve()
    ok, lignes = controler(evenement, base)
    print("\n".join(lignes))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
