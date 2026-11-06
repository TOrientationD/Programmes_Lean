import Modele

/-!
# Axe natalité

Les naissances sont prises proportionnelles à l'indicateur conjoncturel de
fécondité (ICF), à partir de 2025 : 645 000 naissances pour 1,56 enfant par
femme (INSEE, bilan démographique 2025). L'approximation ignore l'évolution
du nombre de femmes en âge d'avoir des enfants.

Dans le modèle, la natalité n'agit que sur la population (et donc sur le PIB
par habitant et le coût des prestations par habitant). Elle ne change pas la
population active avant une vingtaine d'années : au-delà de l'horizon.

Cet axe n'entre pas dans le produit cartésien de la matrice (il n'y changerait
aucune propriété) ; la synthèse PDF l'explore autour du scénario central.
-/

namespace Hypotheses.Natalite
open Modele

def basse : Natalite where
  id := "natalite-basse"
  description := "Poursuite de la baisse : 1,40 enfant par femme"
  icfCentiemes := 140
  naissancesMilliers := 579
  sources := ["645 000 × 1,40 / 1,56 (INSEE, bilan démographique 2025)"]

def centrale : Natalite where
  id := "natalite-centrale"
  description := "Fécondité de 2025 : 1,56 enfant par femme"
  icfCentiemes := 156
  naissancesMilliers := 645
  sources := ["INSEE, bilan démographique 2025 : 645 000 naissances, ICF 1,56"]

def haute : Natalite where
  id := "natalite-haute"
  description := "Remontée au niveau de 2014 : 1,80 enfant par femme"
  icfCentiemes := 180
  naissancesMilliers := 744
  sources := ["645 000 × 1,80 / 1,56"]

def toutes : List Natalite := [basse, centrale, haute]

end Hypotheses.Natalite
