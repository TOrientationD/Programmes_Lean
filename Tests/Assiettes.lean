import Modele
import Hypotheses

/-!
# Tests du modèle commun : prélèvements sur leur assiette naturelle

La règle d'évolution de chaque prélèvement (`Assiettes.taux`) est testée
seule, puis dans la projection : chaque test vérifie une propriété que la
législation ou la comptabilité impose (barème indexé, accises en euros par
litre, acomptes de l'IS), ou une élasticité au cycle qui doit **émerger**
des assiettes sans être imposée (fourchettes larges autour des estimations
publiées).
-/

namespace Tests.Assiettes
open Modele

def A : Assiettes := Hypotheses.Eco.assiettesFrance

/-- Croissances toutes égales à `g` (inflation précédente comprise). -/
def uniforme (g : Int) : CroissanceAssiettes :=
  { masse := g, pensions := g, consommation := g, excedent := g,
    beneficePrecedent := g, beneficeAvant := g,
    independants := g, capital := g, masseCycle := 0, pibNominal := g, pibTendance := g,
    volume := 0, cycle := 0, inflationPrecedente := g, revalorisationFonciere := g, immobilier := g }

/-! ## La règle seule -/

/-- Barème indexé : si tous les revenus et le barème croissent de la même
inflation, l'impôt sur le revenu croît exactement d'autant (pas de
progressivité à froid). -/
theorem ir_neutre_a_l_inflation : (A.taux 1000 (uniforme 200)).ir = 200 := by decide

/-- Progressivité : deux points de hausse des revenus au-delà de la
revalorisation du barème relèvent l'IR de `progressiviteIrPm` × 2 points. -/
theorem ir_progressif :
    (A.taux 1000 { uniforme 400 with inflationPrecedente := 200 }).ir
      = 400 + (A.progressiviteIrPm - 1000) * 200 / 1000 := by decide

/-- Accises : tarifs en euros par unité ; une hausse des prix sans hausse
des volumes ne les change pas. -/
theorem accises_hors_prix : (A.taux 1000 (uniforme 300)).accisesEnergie = 0 := by decide

/-- Taxe foncière : revalorisation légale des valeurs locatives (7,1 % en
2023), plus les constructions nouvelles. -/
theorem foncier_revalorise :
    (A.taux 1000 { uniforme 0 with revalorisationFonciere := 710 }).taxeFonciere
      = 710 + A.croissancePhysiqueFoncierPb := by decide

/-- Droits de mutation à titre onéreux : la valeur des transactions
immobilières (−21,8 % en 2023), pas le PIB. -/
theorem dmto_transactions :
    (A.taux 1000 { uniforme 600 with immobilier := -2175 }).mutationsOnereuses = -2175 := by decide

/-- IS, accélérateur des acomptes : un bond de 10 % du bénéfice fiscal de
l'exercice précédent relève l'IS encaissé cette année d'au moins 10 %
(acomptes sur un exercice plus élevé et solde de cet exercice), puis le
fait baisser l'année suivante (le solde redevient normal). -/
theorem is_accelerateur :
    1000 ≤ A.croissanceIs 0 1000 0 ∧ A.croissanceIs 0 0 1000 < 0 := by decide

/-- IS, modulation des acomptes : quand le bénéfice de l'exercice baisse de
10 % après des années stables, les entreprises réduisent leurs acomptes et
l'IS encaissé baisse d'autant dès l'année (à l'arrondi près). -/
theorem is_modulation : -1001 ≤ A.croissanceIs (-1000) 0 0 ∧ A.croissanceIs (-1000) 0 0 ≤ -999 := by
  decide

/-- IS en croissance régulière : il suit le bénéfice (à l'arrondi près). -/
theorem is_regulier :
    let g := A.croissanceIs 300 300 300
    299 ≤ g ∧ g ≤ 301 := by decide

/-- En croissance régulière (sans cycle), chaque prélèvement suit son
assiette, et toutes les assiettes suivent le PIB : TVA, CSG, cotisations,
IS (à l'arrondi près) croissent comme lui. Les élasticités au-delà de 1
(IS, progressivité de l'IR) ne jouent que sur le cycle, les marges et la
hausse réelle des revenus. -/
theorem croissance_reguliere :
    let t := A.taux 1000 (uniforme 300)
    t.tva = 300 ∧ t.csgCrds = 300 ∧ t.cotisations = 300 ∧
    299 ≤ t.impotSocietes ∧ t.impotSocietes ≤ 301 := by decide

/-- Bénéfice fiscal : la croissance tendancielle de l'excédent passe telle
quelle, un écart de 1 % à la tendance est amplifié `elasticiteIsPm` fois. -/
theorem benefice_amplifie_les_ecarts :
    A.beneficeFiscal 300 300 = 300 ∧
    A.beneficeFiscal 300 400 = 300 + 100 * A.elasticiteIsPm / 1000 := by decide

/-! ## Dans la projection -/

def D : Moteur := Hypotheses.Moteurs.demande

/-- Scénario central sans échéanciers ni calendriers (voir
`Tests.Mecanismes`). -/
def H : Scenario :=
  let C := Hypotheses.central
  { C with reference := { C.reference with etat := { C.reference.etat with
      echeances := [], echeancesRecettes := [], calendrierAgeLegal := [],
      calendrierAgeTendanciel := [] } } }

def avecPremiereAnnee (volume prix conso : Int) : Scenario :=
  { H with eco := { H.eco with
      croissancePotentielleAnneesPb := [H.eco.croissancePotentiellePb],
      croissanceVolumeAnneesPb := [volume], inflationAnneesPb := [prix],
      inflationConsoAnneesPb := [conso] } }

def base : Scenario := avecPremiereAnnee H.eco.croissancePotentiellePb H.eco.inflationPb H.eco.inflationPb
def haut : Scenario := avecPremiereAnnee (H.eco.croissancePotentiellePb + 100) H.eco.inflationPb H.eco.inflationPb

def an1 (S : Scenario) : Etat := anneeSuivante D S (etatDepart S)

/-- Écart relatif d'un prélèvement entre deux états, pb. -/
def ecart (i : Impot) (a b : Etat) : Int := ratioPb (b.impots.get i - a.impots.get i) (a.impots.get i)

/-- Cotisations : un point de croissance au-delà du potentiel relève la
masse salariale de son élasticité au cycle (Commission : 0,66 ; emploi par
la loi d'Okun, rémunération par emploi pour le reste), d'où une élasticité
des cotisations entre 0,4 et 0,9 (LPFP 2023-2027 : 0,63 ; OCDE : 0,70). -/
theorem cotisations_elasticite_cycle :
    let e := ecart .cotisations (an1 base) (an1 haut)
    40 ≤ e ∧ e ≤ 90 := by decide +kernel

/-- IS : le même point relève l'excédent des entreprises bien plus que le
PIB (les salaires suivent moins), et l'IS dû plus encore ; la part encaissée
dans l'année donne une élasticité de première année entre 1 et 3 (LPFP :
2,76 en régime établi ; l'effet des acomptes vient l'année suivante). -/
theorem is_elasticite_cycle :
    let e := ecart .impotSocietes (an1 base) (an1 haut)
    100 ≤ e ∧ e ≤ 300 := by decide +kernel

/-- IS en régime établi (troisième année, après l'accélérateur des
acomptes de la deuxième) : élasticité au cycle entre 2 et 4 (LPFP : 2,76 ;
OCDE : 3,09). -/
theorem is_elasticite_regime :
    let a3 (S : Scenario) := projeterN D S 3 (etatDepart S)
    let e := ecart .impotSocietes (a3 base) (a3 haut)
    200 ≤ e ∧ e ≤ 400 := by decide +kernel

/-- TVA : la consommation suit l'activité, élasticité unitaire au cycle. -/
theorem tva_elasticite_cycle :
    let e := ecart .tva (an1 base) (an1 haut)
    95 ≤ e ∧ e ≤ 105 := by decide +kernel

/-- Accises : un point d'inflation de plus la même année ne change pas leur
rendement (hors électrification, identique dans les deux scénarios). -/
theorem accises_inflation :
    let prix := an1 (avecPremiereAnnee H.eco.croissancePotentiellePb (H.eco.inflationPb + 100) (H.eco.inflationPb + 100))
    (an1 base).impots.accisesEnergie = prix.impots.accisesEnergie := by decide +kernel

end Tests.Assiettes
