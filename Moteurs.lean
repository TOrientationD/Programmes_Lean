import Hypotheses
import Moteurs.ExempleEquilibre.Moteur

/-!
# Registre des moteurs contribués

Un **moteur** est un jeu de règles d'interprétation des leviers
(`Modele/Moteur.lean`). Les deux moteurs du socle (« demande », « offre »)
vivent dans `Hypotheses/Moteurs.lean` ; toute personne autorisée peut en
ajouter un ici, dans son propre dossier :

1. créer `Moteurs/<Nom>/Moteur.lean` qui définit `def moteur : Modele.Moteur`
   avec `id := "<Nom>"`, et `Moteurs/<Nom>/PROPRIETAIRES` listant son compte
   GitHub (seuls les propriétaires peuvent ensuite modifier le dossier :
   même contrôle d'accès que les programmes) ;
2. ajouter l'`import` ci-dessus et le moteur à `contribues`.

Tous les programmes sont alors évalués sous ce moteur en plus des autres,
et la synthèse PDF peut être centrée dessus (`scripts/synthese_pdf.py
--moteur <Nom>`, ou le workflow « Synthèse PDF » avec le paramètre
`moteur`). Un moteur doit respecter `Moteur.Valide` (bornes de
plausibilité), vérifié par `valides` ci-dessous.
-/

namespace Moteurs

def contribues : List Modele.Moteur := [
  ExempleEquilibre.moteur
]

def tous : List Modele.Moteur := Hypotheses.Moteurs.tous ++ contribues

theorem valides : ∀ M ∈ tous, M.Valide := by decide +kernel

end Moteurs
