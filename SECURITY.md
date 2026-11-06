# Sécurité

La valeur de ce dépôt tient à la fiabilité des verdicts de sa CI : un
engagement marqué ✅ doit être réellement prouvé. Le modèle de confiance
est décrit dans le [README](README.md#modèle-de-confiance).

## Signaler une faille, en privé

Onglet **Security → Report a vulnerability** (signalement privé GitHub).
Ne publiez pas d'issue ni de PR de démonstration avant correction.

Relèvent de ce canal :

* un moyen de faire accepter une preuve fausse : contournement du
  garde-fou syntaxique, du noyau Lean, de `leanchecker` ou de l'audit des
  axiomes ;
* un moyen de faire afficher par le bot un verdict ou un rapport qui ne
  correspond pas au code de la PR ;
* une élévation de droits d'un workflow : écriture sur le dépôt, accès à
  un secret, commentaire sur une autre PR ;
* un moyen de modifier le programme d'un autre sans être dans son
  `PROPRIETAIRES`, ou de s'y ajouter ;
* un écart entre le rapport compilé et le rapport interprété.

## Hors périmètre

Les désaccords sur le modèle économique, une hypothèse ou le contenu d'un
programme se traitent publiquement, par issue ou par PR.

Les limites déjà documentées dans le README ne sont pas des failles : une
PR qui modifie l'outillage exécute sa propre version de la CI, et le
commentaire du bot le signale.
