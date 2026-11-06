import Modele
import Hypotheses

/-!
# Tests du modèle commun : rétro-test sur les comptes 2018-2025

Le modèle part des comptes observés et simule l'année suivante (voir
`Modele/Retro.lean`) ; ces tests bornent ses erreurs. Les seuils sont des
garde-fous : ils disent la précision atteinte et cassent la CI si une
modification du socle la dégrade, ils ne calent aucun paramètre (le modèle
n'a aucun paramètre ajusté sur ces années).

Repères : l'erreur de prévision du déficit de l'année en cours par le
Gouvernement, à l'automne, est de l'ordre d'un demi-point (2023 : 4,9 %
prévus dans le PLF 2024, 5,5 % constatés). L'élasticité des prélèvements
au PIB a varié de 0,4 (2023) à 1,4 (2022, base 2020). Chaque prélèvement
étant calculé sur son assiette (masse salariale, consommation, bénéfice
fiscal et règles d'acomptes de l'IS, transactions immobilières, valeurs
locatives), l'essentiel de ces écarts est retrouvé ; restent la
déformation de la consommation vers les taux réduits de TVA (2023-2024,
IGF), le calendrier du prélèvement à la source de l'IR et l'écart entre
bénéfice fiscal et excédent des entreprises.
-/

namespace Tests.Retro
open Modele

def H : Scenario := Hypotheses.central
def D : Moteur := Hypotheses.Moteurs.demande
def base : Etat := Hypotheses.reference2026.etat

def unAn : List EcartRetro := retroUnAn D H base Hypotheses.observations
def depuis2018 : List EcartRetro := retroPlusieursAnnees D H base Hypotheses.observations
def depuis2021 : List EcartRetro := retroPlusieursAnnees D H base (Hypotheses.observations.drop 3)

/-- Le rétro-test couvre les sept années 2019 à 2025. -/
theorem sept_annees : unAn.map (·.annee) = [2019, 2020, 2021, 2022, 2023, 2024, 2025] := by
  decide +kernel

/-! ## Déficit (à un an) -/

/-- Pas d'erreur systématique : biais moyen inférieur à 0,25 point de PIB. -/
theorem deficit_sans_biais : Int.natAbs (moyenne (unAn.map (·.erreurDeficitPb))) ≤ 25 := by
  decide +kernel

/-- Erreur absolue moyenne inférieure à 0,5 point de PIB (0,53 quand les
prélèvements suivaient le seul PIB). -/
theorem deficit_erreur_moyenne : moyenneAbsolue (unAn.map (·.erreurDeficitPb)) ≤ 50 := by
  decide +kernel

/-- Aucune année au-delà de 1,1 point (2023 : 1,44 point quand les
prélèvements suivaient le seul PIB). -/
theorem deficit_erreur_maximale : unAn.all (fun e => decide (Int.natAbs e.erreurDeficitPb ≤ 110)) = true := by
  decide +kernel

/-! ## Prélèvements obligatoires -/

/-- Évolution spontanée des prélèvements : biais moyen inférieur à 0,5 point
d'évolution, erreur absolue moyenne inférieure à 1,2 point. -/
theorem prelevements_spontanes :
    let ecarts := unAn.map fun e => e.evolutionSpontaneeModelePb - e.evolutionSpontaneeObserveePb
    Int.natAbs (moyenne ecarts) ≤ 50 ∧ moyenneAbsolue ecarts ≤ 120 := by decide +kernel

/-! ## Assiettes -/

/-- Masse salariale à un an (emploi par la loi d'Okun, rémunération par
emploi selon la productivité tendancielle, l'inflation et le cycle) :
erreur absolue moyenne inférieure à 1,2 %. -/
theorem masse_salariale_un_an : moyenneAbsolue (unAn.map (·.erreurMasseSalarialePb)) ≤ 120 := by
  decide +kernel

/-- Consommation des ménages à un an (volume de l'activité, prix à la
consommation) : erreur absolue moyenne inférieure à 1,2 %. -/
theorem consommation_un_an : moyenneAbsolue (unAn.map (·.erreurConsommationPb)) ≤ 120 := by
  decide +kernel

/-! ## Charge d'intérêts -/

/-- Charge d'intérêts à un an : biais inférieur à 1,5 Md€, erreur absolue
moyenne inférieure à 3 Md€ (0,1 point de PIB), y compris les années
d'inflation forte (indexation). -/
theorem interets_un_an :
    let ecarts := unAn.map (·.erreurInterets)
    Int.natAbs (moyenne ecarts) ≤ 1500 ∧ moyenneAbsolue ecarts ≤ 3000 := by decide +kernel

/-- Sur plusieurs années (intérêts calculés sur la dette simulée, en base
2020 depuis 2021) : écart en 2025 inférieur à 5 %. -/
theorem interets_depuis_2021 :
    depuis2021.getLast?.map (fun e => decide (20 * Int.natAbs e.erreurInterets ≤ e.interetsObserves.natAbs))
      = some true := by decide +kernel

/-! ## Sur plusieurs années -/

/-- Depuis 2018, les erreurs ne s'accumulent pas : biais moyen inférieur à
0,5 point, erreur absolue moyenne inférieure à 0,7 point. -/
theorem deficit_depuis_2018 :
    let ecarts := depuis2018.map (·.erreurDeficitPb)
    Int.natAbs (moyenne ecarts) ≤ 50 ∧ moyenneAbsolue ecarts ≤ 70 := by decide +kernel

/-- Dette 2025 simulée depuis 2018 : à moins de 3 points de PIB de la dette
observée ; l'écart vient surtout des ajustements dette-déficit, que le
modèle ne projette pas (trésorerie constituée en 2020 : 58,6 Md€). -/
theorem dette_depuis_2018 :
    depuis2018.getLast?.map (fun e => decide (Int.natAbs e.erreurDettePb ≤ 300)) = some true := by
  decide +kernel

/-! ## Chômage (loi d'Okun) -/

/-- Hors 2020-2021 (activité partielle : l'emploi n'a pas suivi le PIB), le
chômage simulé est à moins d'un demi-point du chômage observé. -/
theorem okun_hors_crise :
    (unAn.filter fun e => e.annee ≠ 2020 ∧ e.annee ≠ 2021).all
      (fun e => decide (Int.natAbs (e.chomageModelePb - e.chomageObservePb) ≤ 50)) = true := by
  decide +kernel

end Tests.Retro
