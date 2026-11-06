import Modele
import Hypotheses

/-!
# Tests du modèle commun : le tendanciel face à une projection indépendante

La mission d'experts indépendants sur la transparence des finances
publiques (X. Jaravel, X. Ragot, P. Tavernier, N. Valla, rapport du
15 juillet 2026, tableaux 3 à 6) projette les finances publiques « à
politique inchangée » de 2026 à 2030. Ses hypothèses de dépenses sont
celles que reprend l'axe économique (tendances par poste) ; ses
hypothèses de taux et de croissance sont proches. Le modèle n'est pas calé
sur elle : on vérifie que sa dérive tendancielle reste proche.

La mission part d'un déficit 2026 de 5,0 % (cible du Gouvernement) ; le
modèle ne contient pas les économies de la loi de finances et de la loi de
financement de la sécurité sociale pour 2026 (non chiffrées dans leur
version votée) et part plus haut (5,8 %, contre 5,4 % prévus dans le PLF
2027) : on compare donc la **dérive** depuis 2026.
-/

namespace Tests.Tendanciel
open Modele

def H : Scenario := Hypotheses.central
def D : Moteur := Hypotheses.Moteurs.demande

/-- Tendanciel de 2025 (rang 0) à 2030 (rang 5). -/
def t : List Etat := trajectoire D H 5 (etatDepart H)

/-- Déficit de la mission, pb du PIB, 2026 à 2030. -/
def deficitMission : List Int := [500, 588, 621, 657, 676]

/-- Charge d'intérêts de la mission, Md€, 2026 à 2030. -/
def interetsMission : List Int := [78, 89, 101, 112, 124]

/-- Dérive du déficit depuis 2026 : à moins d'un demi-point de celle de la
mission chaque année de 2027 à 2030. -/
theorem derive_deficit :
    let m := (t.drop 1).map Etat.deficitPb
    let dm := m.map (· - m.headD 0)
    let dr := deficitMission.map (· - deficitMission.headD 0)
    (dm.zip dr).all (fun (a, b) => decide (Int.natAbs (a - b) ≤ 50)) = true := by decide +kernel

/-- Charge d'intérêts 2026-2028 : à moins de 10 % de celle de la mission
(au-delà, la prime de risque du modèle, que la mission n'applique pas,
relève les taux avec le déficit). -/
theorem interets_proches :
    let m := ((t.drop 1).take 3).map (·.chargeInterets)
    let r := (interetsMission.take 3).map (· * 1000)
    (m.zip r).all (fun (a, b) => decide (10 * Int.natAbs (a - b) ≤ b)) = true := by decide +kernel

end Tests.Tendanciel
