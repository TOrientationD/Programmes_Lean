#!/usr/bin/env bash
# Prépare le dépôt pour GitHub et pousse toutes les branches.
#
# Usage : scripts/publier.sh COMPTE [DEPOT] [--ssh] [--sans-push]
#
#   COMPTE       compte ou organisation GitHub, sans @
#   DEPOT        nom du dépôt (défaut : programmes-verifies)
#   --ssh        pousser par SSH (git@github.com:…) plutôt que HTTPS
#   --sans-push  tout préparer, ne rien pousser
#
# Le dépôt doit exister sur GitHub et être VIDE (ni README, ni licence, ni
# .gitignore créés par l'assistant de création).
#
# Ce que fait le script, sur la machine locale uniquement :
#   1. remplace les comptes d'exemple de CODEOWNERS et des programmes par
#      @COMPTE, ajoute le badge CI au README, committe sur main ;
#   2. rebase les branches de travail sur ce nouveau main ;
#   3. vérifie le registre (CODEOWNERS ↔ programmes) ;
#   4. ajoute le remote `origin` et pousse main puis les autres branches.
#
# Aucun token n'est manipulé : l'authentification est celle de git sur
# cette machine (GitHub Desktop, `gh auth login`, Git Credential Manager ou
# clé SSH).
set -euo pipefail
cd "$(dirname "$0")/.."

erreur() { echo "ERREUR : $*" >&2; exit 1; }

COMPTE="" DEPOT="programmes-verifies" SSH=0 PUSH=1
for a in "$@"; do
  case "$a" in
    --ssh) SSH=1 ;;
    --sans-push) PUSH=0 ;;
    -*) erreur "option inconnue : $a" ;;
    *) if [ -z "$COMPTE" ]; then COMPTE="$a"; else DEPOT="$a"; fi ;;
  esac
done
[ -n "$COMPTE" ] || erreur "usage : scripts/publier.sh COMPTE [DEPOT] [--ssh] [--sans-push]"
COMPTE="${COMPTE#@}"
[[ "$COMPTE" =~ ^[A-Za-z0-9]([A-Za-z0-9-]{0,37}[A-Za-z0-9])?$ ]] \
  || erreur "nom de compte GitHub invalide : $COMPTE"
[[ "$DEPOT" =~ ^[A-Za-z0-9._-]+$ ]] || erreur "nom de dépôt invalide : $DEPOT"
command -v perl >/dev/null || erreur "perl est requis"
git diff --quiet && git diff --cached --quiet || erreur "des modifications ne sont pas commitées"
git rev-parse -q --verify main >/dev/null || erreur "branche main absente"

# Branches de travail et leur base, dans l'ordre des rebases.
BRANCHES=(socle/sous-modele-sru mesure/amende-sru-automatique demo/hypothese-multiplicateur-fort)
BASES=(main socle/sous-modele-sru main)

git checkout -q main

# 1. Comptes et badge
CIBLES=(.github/CODEOWNERS Programmes/*/Programme.lean Programmes/*/PROPRIETAIRES)
if grep -q "VOTRE-ORG\|mainteneur-exemple" "${CIBLES[@]}"; then
  perl -pi -e "s{\@VOTRE-ORG/[A-Za-z0-9-]+}{\@$COMPTE}g; s{\@mainteneur-exemple-[A-Za-z0-9-]+}{\@$COMPTE}g" \
    "${CIBLES[@]}"
  URL_CI="https://github.com/$COMPTE/$DEPOT/actions/workflows/ci.yml"
  perl -pi -e "s{<!-- badge-ci -->}{[![CI]($URL_CI/badge.svg)]($URL_CI)}" README.md
  python3 -I scripts/verifier_registre.py .
  git commit -q -am "Publication : mainteneurs @$COMPTE, badge CI"
  echo "main : comptes d'exemple remplacés par @$COMPTE."
else
  echo "main : déjà configuré, rien à remplacer."
fi

# 2. Rebases
PRESENTES=()
for i in "${!BRANCHES[@]}"; do
  b="${BRANCHES[$i]}" base="${BASES[$i]}"
  git rev-parse -q --verify "$b" >/dev/null || continue
  if ! git rebase -q "$base" "$b"; then
    git rebase --abort
    git checkout -q main
    erreur "conflit en rebasant $b sur $base : à résoudre à la main"
  fi
  PRESENTES+=("$b")
  echo "$b : rebasée sur $base."
done
git checkout -q main

# 3. Remote
if [ "$SSH" = 1 ]; then URL="git@github.com:$COMPTE/$DEPOT.git"
else URL="https://github.com/$COMPTE/$DEPOT.git"; fi
URL="${PUBLIER_REMOTE:-$URL}"   # surcharge pour les tests
if git remote get-url origin >/dev/null 2>&1; then git remote set-url origin "$URL"
else git remote add origin "$URL"; fi
echo "origin → $URL"

if [ "$PUSH" = 0 ]; then
  echo "Préparation terminée (--sans-push). Pour pousser : git push -u origin main ${PRESENTES[*]}"
  exit 0
fi

# 4. Push : main d'abord (premier run de la CI), puis les branches.
git push -u origin main
for b in "${PRESENTES[@]}"; do git push -u origin "$b"; done

cat <<EOF

Poussé. Étapes suivantes sur https://github.com/$COMPTE/$DEPOT :
  1. Actions : attendre le premier run de « CI » sur main (vert attendu).
  2. Settings : appliquer les réglages de la section « Gouvernance » du README
     (ruleset sur main, Actions, signalement privé).
  3. Ouvrir les PR, dans l'ordre :
       socle/sous-modele-sru          → main
       mesure/amende-sru-automatique  → main (après fusion du socle)
       demo/hypothese-multiplicateur-fort → main, en brouillon : CI rouge attendue
EOF
