import Modele
import Hypotheses
import Proprietes

/-!
# Programme fictif « Exemple relance »

⚠️ Programme **fictif** à visée pédagogique. Il ne reproduit le programme
d'aucun parti ; les montants sont arbitraires.
-/

namespace Programmes.ExempleRelance
open Modele

/-- Barème de la mesure R-07 : coefficient ×1 à ×5 selon la part de
l'objectif SRU non atteinte, plafond (5 % des DRF) et seuil (4 000 €) du
droit actuel. -/
def baremeSRU : BaremeSRU where
  tauxBasePm := 250
  coefMinPm := 1000
  coefMaxPm := 5000
  plafondPb := 500
  seuil := 4000

theorem baremeSRU_valide : baremeSRU.Valide := by decide

def mesures : List Mesure := [
  { id := "R-01", titre := "Plan d'investissement de transition"
    source := "Exemple fictif, §1"
    leviers := [.transition .energie 30 30000] },
  { id := "R-02", titre := "Revalorisation du SMIC de 8 %"
    source := "Exemple fictif, §2"
    leviers := [.revalorisationSmic 800] },
  { id := "R-03", titre := "Prestation forfaitaire de 250 €/an par habitant"
    source := "Exemple fictif, §3"
    leviers := [.prestationParHabitant 250] },
  { id := "R-04", titre := "Contribution sur les hauts patrimoines"
    source := "Exemple fictif, §4"
    leviers := [.prelevement 20000] },
  { id := "R-05", titre := "Retour de l'âge légal à 62 ans"
    source := "Exemple fictif, §5"
    leviers := [.ageLegal (-24)] },
  { id := "R-06", titre := "Taxe sur les profits exceptionnels"
    source := "Exemple fictif, §6"
    leviers := [.prelevementSur .impotSocietes 15000] },
  { id := "R-07"
    titre := "Amende SRU automatique selon la part de logements sociaux manquants"
    source := "Exemple fictif, §7 — remplace la majoration préfectorale discrétionnaire (CCH L.302-9-1)"
    leviers := [.amendeSRU baremeSRU]
    contrats := [
      { titre := "Nulle pour toute commune qui atteint son objectif"
        enonce := ∀ c : Commune, c.Valide → c.objectif ≤ c.logementsSociaux →
          baremeSRU.amende c = 0
        preuve := fun _ hc h => BaremeSRU.amende_nulle_si_conforme baremeSRU_valide hc h },
      { titre := "Ne dépasse jamais 5 % des dépenses réelles de fonctionnement"
        enonce := ∀ c : Commune, c.Valide → baremeSRU.amende c ≤ c.plafond 500
        preuve := fun _ hc => BaremeSRU.amende_plafonnee baremeSRU_valide hc },
      { titre := "Construire des logements sociaux ne fait jamais payer plus"
        enonce := ∀ c : Commune, c.Valide → ∀ k, 0 ≤ k →
          baremeSRU.amende { c with logementsSociaux := c.logementsSociaux + k } ≤
            baremeSRU.amende c
        preuve := fun _ hc _ hk =>
          BaremeSRU.amende_decroit_avec_logements_sociaux baremeSRU_valide hc hk },
      { titre := "Jamais moins que le prélèvement de base actuel"
        enonce := ∀ c : Commune, c.Valide → SRU.prelevementActuel c ≤ baremeSRU.amende c
        preuve := fun _ hc => BaremeSRU.amende_ge_prelevement_actuel baremeSRU_valide hc
          (by decide) (by decide) (by decide) },
      { titre := "Jamais plus que le maximum qu'un préfet peut infliger aujourd'hui"
        enonce := ∀ (medianePFH : Int) (c : Commune), c.Valide →
          baremeSRU.amende c ≤ SRU.majorationMaxActuelle medianePFH c
        preuve := fun med _ hc => BaremeSRU.amende_le_majoration_max_actuelle baremeSRU_valide hc med
          (by decide) (by decide) (by decide) }
    ] }
]

open Hypotheses in
def programme : Programme where
  id := "ExempleRelance"
  nom := "Exemple relance (fictif)"
  description := "Relance par l'investissement de transition et le pouvoir d'achat, financée en partie par des prélèvements nouveaux."
  mainteneurs := ["@TOrientationD"]
  source := "Programme fictif — aucun document source"
  mesures := mesures
  engagements := [
    -- « Nos émissions passent sous le plafond légal en hypothèses centrales. »
    Engagement.sous Moteurs.standard (central) Proprietes.emissions,
    -- (Un engagement « déficit sous le plafond dérogatoire avec croissance
    -- forte » figurait ici ; il ne tient plus depuis que la baisse de l'âge
    -- légal et la hausse du SMIC (ancien levier, à élasticité jouet)
    -- réduisaient le volume d'heures travaillées, donc le PIB : 5,02 % contre
    -- 5 %. Retiré, comme la CI l'exige.)
    -- « Avec une croissance forte, le chômage ne dépasse pas le tendanciel. »
    Engagement.sous Moteurs.standard (scenario Demo.centrale Eco.croissanceHaute Droit.cadreActuel) Proprietes.chomage
  ]

end Programmes.ExempleRelance
