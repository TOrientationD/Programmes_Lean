import Modele

namespace Proprietes
open Modele

/-- Émissions à l'horizon sous le plafond du cadre juridique du scénario :
l'ancien budget carbone 2029-2033 de la SNBC-2 (300 Mt), repère
intermédiaire depuis la SNBC-3 (voir `Hypotheses.Droit`). -/
abbrev EmissionsSousPlafond (H : Scenario) (_tendanciel s : Etat) : Prop :=
  s.emissionsMt ≤ H.droit.plafondEmissionsMt

def emissions : Propriete :=
  .mk' "emissions-plafond" "Émissions sous 300 Mt (SNBC-2)"
    "Les émissions territoriales à l'horizon respectent le plafond du cadre juridique du scénario : l'ancien budget carbone 2029-2033 de la SNBC-2 (300 Mt), remplacé par celui de la SNBC-3 (262 Mt)."
    EmissionsSousPlafond

end Proprietes

namespace Proprietes
open Modele

/-- Les décès attribuables à la pollution de l'air ne dépassent pas le tendanciel. -/
abbrev AirNonDegrade (_H : Scenario) (a s : Etat) : Prop :=
  s.decesPollutionAir ≤ a.decesPollutionAir

def air : Propriete :=
  .mk' "air-non-degrade" "Mortalité liée à l'air non dégradée"
    "À l'horizon, les décès annuels attribuables à la pollution de l'air ne dépassent pas ceux du tendanciel."
    AirNonDegrade

/-- Points de recharge publics suffisants pour le parc électrique en 2035. -/
abbrev BornesSuffisantesEn2035 (H : Scenario) (_tendanciel s : Etat) : Prop :=
  s.parcElectriqueMilliers ≤ s.bornesMilliers * H.energie.vehiculesParBorne

def bornes2035 : Propriete :=
  .mk' "bornes-suffisantes-2035" "Bornes suffisantes en 2035"
    "En 2035, le nombre de points de recharge publics atteint la cible du scénario (un point pour dix véhicules électriques)."
    BornesSuffisantesEn2035 (annee := some 10)

end Proprietes

/-! ## Objectifs climatiques nationaux (SNBC-3)

Troisième stratégie nationale bas-carbone, adoptée par le décret
n° 2026-636 du 16 juillet 2026 (JO du 18 juillet 2026) : objectifs 2030 par
secteur et budgets carbone. Émissions territoriales brutes, hors puits. -/

namespace Proprietes
open Modele

/-- Objectifs 2030 de la SNBC-3 par secteur, kt CO₂e : transports 92 Mt,
bâtiments 37, agriculture 68, industrie 42, production d'énergie 25,
déchets 12 ; total brut 276 Mt. -/
def objectifsSnbc2030 : ParSecteurGes :=
  { transports := 92000, batiments := 37000, agriculture := 68000, industrie := 42000,
    energie := 25000, dechets := 12000 }

abbrev SnbcSecteurs2030 (_H : Scenario) (_a s : Etat) : Prop :=
  s.emissionsKt.transports ≤ objectifsSnbc2030.transports ∧
  s.emissionsKt.batiments ≤ objectifsSnbc2030.batiments ∧
  s.emissionsKt.agriculture ≤ objectifsSnbc2030.agriculture ∧
  s.emissionsKt.industrie ≤ objectifsSnbc2030.industrie ∧
  s.emissionsKt.energie ≤ objectifsSnbc2030.energie ∧
  s.emissionsKt.dechets ≤ objectifsSnbc2030.dechets

def snbcSecteurs2030 : Propriete :=
  .mk' "snbc-secteurs-2030" "SNBC-3 : objectifs sectoriels 2030"
    "En 2030, chaque secteur respecte son objectif de la SNBC-3 (décret n° 2026-636) : transports 92 Mt, bâtiments 37, agriculture 68, industrie 42, énergie 25, déchets 12."
    SnbcSecteurs2030 (annee := some 5)

/-- Budget carbone 4 de la SNBC-3 : 262 Mt CO₂e par an en moyenne de 2029
à 2033 (années 4 à 8 de la projection). -/
def budgetCarbone4Kt : Int := 262000

def emissionsCumuleesKt (traj : List Etat) (debut fin : Nat) : Int :=
  ((traj.drop debut).take (fin + 1 - debut)).foldl (fun acc s => acc + s.emissionsKt.total) 0

def budgetCarbone4 : Propriete :=
  .surTrajectoire "budget-carbone-2029-2033" "SNBC-3 : budget carbone 2029-2033"
    "Les émissions de 2029 à 2033 ne dépassent pas le quatrième budget carbone de la SNBC-3 : 262 Mt CO₂e par an en moyenne."
    (fun _ _ _ traj => decide (emissionsCumuleesKt traj 4 8 ≤ 5 * budgetCarbone4Kt)) (annee := some 8)

/-- Voitures électriques : 15 % du parc en 2030 (SNBC-3), sur ≈ 40 millions de
voitures (SDES, 40,0 millions au 1er janvier 2026). -/
def parcVoituresMilliers : Int := 40000

abbrev ParcElectrique2030 (_H : Scenario) (_a s : Etat) : Prop :=
  s.parcElectriqueMilliers * 1000 ≥ parcVoituresMilliers * 150

def parcElectrique2030 : Propriete :=
  .mk' "parc-electrique-2030" "SNBC-3 : 15 % de voitures électriques en 2030"
    "En 2030, les voitures électriques représentent au moins 15 % du parc (objectif de la SNBC-3), soit 6 millions de voitures."
    ParcElectrique2030 (annee := some 5)

end Proprietes

