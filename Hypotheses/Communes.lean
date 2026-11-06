import Modele

/-!
# Panel de communes soumises à l'article 55 de la loi SRU

Sert au rapport : il calcule, pour chaque mesure qui utilise le levier
`amendeSRU`, ce que paierait chaque commune du panel en droit actuel, au
maximum préfectoral actuel, et avec le barème de la mesure.

⚠️ COMMUNES FICTIVES — ordres de grandeur choisis pour couvrir les cas
caractéristiques (conforme, proche de l'objectif, à mi-chemin, taux de
20 %, commune aisée très en retard, aucun logement social, petite commune
sous le seuil de recouvrement). À remplacer par l'inventaire SRU réel
(bilans triennaux publiés par le ministère du Logement), commune par
commune, avec sources.

Les contrats des mesures sont prouvés pour **toute** commune ; le panel ne
sert qu'à illustrer les montants.
-/

namespace Hypotheses.Communes
open Modele

def panel : List Commune := [
  { id := "A-conforme", residencesPrincipales := 12000, logementsSociaux := 3100,
    tauxLegalPb := 2500, potentielFiscalParHabitant := 1100,
    depensesReellesFonctionnement := 30000000 },
  { id := "B-proche-objectif", residencesPrincipales := 15000, logementsSociaux := 3300,
    tauxLegalPb := 2500, potentielFiscalParHabitant := 1150,
    depensesReellesFonctionnement := 40000000 },
  { id := "C-mi-chemin", residencesPrincipales := 10000, logementsSociaux := 1250,
    tauxLegalPb := 2500, potentielFiscalParHabitant := 1300,
    depensesReellesFonctionnement := 28000000 },
  { id := "D-taux-20", residencesPrincipales := 8000, logementsSociaux := 1200,
    tauxLegalPb := 2000, potentielFiscalParHabitant := 1000,
    depensesReellesFonctionnement := 20000000 },
  { id := "E-aisee-tres-deficitaire", residencesPrincipales := 9000, logementsSociaux := 270,
    tauxLegalPb := 2500, potentielFiscalParHabitant := 2400,
    depensesReellesFonctionnement := 25000000 },
  { id := "F-sans-logement-social", residencesPrincipales := 4000, logementsSociaux := 0,
    tauxLegalPb := 2500, potentielFiscalParHabitant := 900,
    depensesReellesFonctionnement := 9000000 },
  { id := "G-petite-commune", residencesPrincipales := 1600, logementsSociaux := 380,
    tauxLegalPb := 2500, potentielFiscalParHabitant := 700,
    depensesReellesFonctionnement := 4000000 }
]

/-- Potentiel fiscal médian par habitant des communes soumises, € (sert au
plafond majoré de 7,5 % du droit actuel). ⚠️ Valeur fictive. -/
def medianePFH : Int := 1000

def sources : List String := ["À COMPLÉTER — communes fictives"]

theorem panel_valide : ∀ c ∈ panel, c.Valide := by decide +kernel

end Hypotheses.Communes
