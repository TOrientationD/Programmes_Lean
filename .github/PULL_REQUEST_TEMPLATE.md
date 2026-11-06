## Type de contribution

<!-- Une PR = un seul type. Cochez-en un. -->

- [ ] Nouveau programme (mon compte est dans son `PROPRIETAIRES`)
- [ ] Modification de mon programme (mesures, montants, engagements)
- [ ] Hypothèse : nouvelle valeur sur un axe ou correction d'une donnée
- [ ] Propriété partagée
- [ ] Modèle commun (état, leviers, projection) — **issue préalable obligatoire : #…**
- [ ] Outillage, CI, documentation

## Description

<!-- Ce qui change et pourquoi. -->

## Sources

<!-- Obligatoire pour toute valeur numérique ajoutée ou modifiée :
     document, page ou section, date de consultation. -->

## Vérifications

- [ ] `python3 -I scripts/garde_fou.py`, `lake build` et `lake env lean Audit.lean` passent en local
- [ ] J'ai relu l'impact avec `lake build rapport && .lake/build/bin/rapport` (ou dans le commentaire du bot)
- [ ] Aucun `sorry`, `native_decide` ni `axiom`
- [ ] Je ne modifie pas l'outillage (`.github/`, `scripts/`, `Rapport.lean`, `Audit.lean`, config de build) — ou c'est l'objet même de la PR
- [ ] Programme : chaque mesure cite sa source dans le champ `source`
- [ ] Engagement retiré : je l'explique ci-dessus (un engagement cassé ne se supprime pas en silence)
