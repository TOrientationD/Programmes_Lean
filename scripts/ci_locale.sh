#!/usr/bin/env bash
# Rejoue en local les vérifications bloquantes de la CI, dans le même ordre.
# Usage : scripts/ci_locale.sh        (journaux dans out/ci-*.log)
set -u
export LC_ALL="${LC_ALL:-C.UTF-8}"   # largeur des libellés accentués
cd "$(dirname "$0")/.."
mkdir -p out
echec=0

etape() {
  local id="$1" nom="$2"; shift 2
  printf '%s%*s' "$nom" $((52 - ${#nom})) ''
  if "$@" > "out/ci-$id.log" 2>&1; then
    echo "✅"
  else
    echo "❌  (out/ci-$id.log)"
    echec=1
    return 1
  fi
}

etape garde "Garde-fou syntaxique" python3 -I scripts/garde_fou.py . || {
  echo "Garde-fou en échec : rien n'est compilé."; exit 1; }
etape registre "Registre des programmes" python3 -I scripts/verifier_registre.py .
# Tous les modules compilés du dépôt, d'après les .olean (comme en CI).
modules() {
  (cd .lake/build/lib/lean && find . -name '*.olean' | sed 's|^\./||; s|\.olean$||; s|/|.|g' | sort)
}
rejouer() {
  # shellcheck disable=SC2046
  lake env leanchecker $(modules)
}

etape compilation "Compilation" lake build Programmes Moteurs || exit 1
etape tests "Tests du modèle commun" lake build Tests
etape rapport "Matrice d'évaluation" bash -c "lake build rapport && .lake/build/bin/rapport --json out/rapport.json --md out/rapport.md"
if etape engagements "Engagements (noyau Lean)" lake build Engagements; then
  etape noyau "Rejeu des preuves (leanchecker)" rejouer
  etape audit "Audit des axiomes" lake env lean Audit.lean
else
  grep -h "non tenus" out/ci-rapport.log 2>/dev/null
  echo "Détail : out/rapport.md, section « Engagements revendiqués »."
fi
exit $echec
