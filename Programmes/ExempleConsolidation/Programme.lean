import Modele
import Hypotheses
import Proprietes

/-!
# Programme fictif « Exemple consolidation »

⚠️ Programme **fictif** à visée pédagogique. Il ne reproduit le programme
d'aucun parti ; les montants sont arbitraires.
-/

namespace Programmes.ExempleConsolidation
open Modele

def mesures : List Mesure := [
  { id := "C-01", titre := "Revue des dépenses de fonctionnement"
    source := "Exemple fictif, §1"
    leviers := [.economieSur .fonctionnement 35000] },
  { id := "C-02", titre := "Recul de l'âge légal à 65 ans"
    source := "Exemple fictif, §2"
    leviers := [.ageLegal 12] },
  { id := "C-03", titre := "Baisse des impôts de production"
    source := "Exemple fictif, §3"
    leviers := [.baissePrelevement 8000] },
  { id := "C-04", titre := "Rénovation thermique ciblée"
    source := "Exemple fictif, §4"
    leviers := [.transition .batiments 12 6000] },
  { id := "C-05", titre := "Sous-indexation temporaire des prestations"
    source := "Exemple fictif, §5"
    leviers := [.economieSur .famille 10000] }
]

open Hypotheses in
def programme : Programme where
  id := "ExempleConsolidation"
  nom := "Exemple consolidation (fictif)"
  description := "Réduction du déficit par les économies de dépense et le recul de l'âge légal, avec une baisse ciblée des impôts de production."
  mainteneurs := ["@TOrientationD"]
  source := "Programme fictif — aucun document source"
  mesures := mesures
  engagements :=
    -- « Sous TOUTES les hypothèses du dépôt, le ratio dette/PIB est meilleur qu'au tendanciel. »
    tous.map (fun H => Engagement.sous Moteurs.standard (H) Proprietes.dette)
    -- Engagement retiré : « avec une croissance forte et la clause dérogatoire,
    -- le déficit respecte le plafond ». Il visait d'abord le cadre actuel et ne
    -- tenait plus depuis que le modèle compte la charge d'intérêts (3,09 %
    -- contre 3 %) ; avec le calcul du déficit affiné et vérifié sur 2017-2025
    -- (rétro-test), le déficit 2030 de ce scénario est de 5,74 % contre un
    -- plafond de 5 % (tendanciel : 7,02 %).

end Programmes.ExempleConsolidation
