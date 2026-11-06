import Modele.Scenario

/-!
# Indice de développement humain

Formule du PNUD (Rapport sur le développement humain, notes techniques) :
moyenne géométrique de trois indices dimensionnels, chacun entre 0 et 1.

* santé : (espérance de vie à la naissance − 20) / (85 − 20) ;
* éducation : moyenne de (durée attendue de scolarisation / 18) et de
  (durée moyenne de scolarisation des 25 ans et plus / 15), chacune
  plafonnée à 1 ;
* niveau de vie : (ln RNB par habitant − ln 100) / (ln 75 000 − ln 100),
  RNB en dollars PPA constants.

Tout est entier, en millionièmes. Le logarithme du RNB s'écrit
ln(RNB₀ / 100) + ln(RNB / RNB₀) : le premier terme est une donnée de la
référence (calculé une fois), le second une série rapidement convergente
(ln y = 2 (z + z³/3 + z⁵/5 + z⁷/7), z = (y − 1)/(y + 1)), exacte au
millionième près pour un RNB entre la moitié et le double de celui de
départ. La racine cubique est entière (recherche dichotomique).
-/

namespace Modele

/-- ln(num / den) en millionièmes, pour un rapport proche de 1 (série en
`z = (num − den)/(num + den)`, quatre termes). -/
def lnRapportMillioniemes (num den : Int) : Int :=
  if num ≤ 0 ∨ den ≤ 0 then 0 else
  let z := (num - den) * 1000000 / (num + den)
  let z2 := z * z / 1000000
  let z3 := z * z2 / 1000000
  let z5 := z3 * z2 / 1000000
  let z7 := z5 * z2 / 1000000
  2 * (z + z3 / 3 + z5 / 5 + z7 / 7)

/-- Racine cubique entière par défaut de `n ≥ 0` (dichotomie sur
`[0, borne]`, `fuel` itérations). -/
def racineCubique (n : Nat) : Nat :=
  let rec go : Nat → Nat → Nat → Nat
    | 0, lo, _ => lo
    | fuel + 1, lo, hi =>
      if hi ≤ lo then lo else
      let m := (lo + hi + 1) / 2
      if m * m * m ≤ n then go fuel m hi else go fuel lo (m - 1)
  go 64 0 2000000

example : racineCubique 1000000000000000000 = 1000000 := by decide
example : racineCubique 27 = 3 := by decide

/-- Borne un indice dans `[0, 10⁶]`. -/
def borneIndice (x : Int) : Int := max 0 (min 1000000 x)

/-- Espérance de vie à la naissance de l'état, centièmes d'année : tendance
(état) plus les années de vie gagnées par les mesures, rapportées aux décès
de l'année (approximation de la population stationnaire : supprimer `N`
décès qui auraient coûté `L` années chacun allonge l'espérance de vie de
`N × L / décès`). -/
def esperanceVieCentiemes (H : Scenario) (s : Etat) : Int :=
  let parCauses := CauseDeces.tous.foldl (fun acc c =>
    acc + H.demo.decesAttribuables.get c * s.baisseMortaliteAtteintePm.get c / 1000
      * H.demo.anneesVieParDecesDixiemes.get c / 10) 0
  -- lien dépense de santé → espérance de vie : élasticité × écart relatif de
  -- la dépense de santé à sa trajectoire tendancielle
  let ecartSantePm := if s.depenseSanteTendanceMeur ≤ 0 then 0
    else s.depensesF.sante * 1000 / s.depenseSanteTendanceMeur - 1000
  s.esperanceVieTendanceCentiemes
    + s.esperanceVieTendanceCentiemes * H.demo.elasticiteEsperanceSantePm * ecartSantePm / 1000000
    + (if s.decesMilliers ≤ 0 then 0
       else (s.anneesVieGagneesParAn + parCauses) * 100 / (s.decesMilliers * 1000))

/-- RNB par habitant en dollars PPA constants : celui de départ × PIB en
volume (PIB nominal déflaté par l'indice des prix) par habitant, relatif au
départ. -/
def rnbParHabitantPpa (H : Scenario) (s : Etat) : Int :=
  let r := H.reference
  if r.etat.pib = 0 ∨ s.indicePrix = 0 ∨ s.populationMilliers = 0 then r.rnbParHabitantPpaDollars else
  r.rnbParHabitantPpaDollars * (s.pib * 10000 / s.indicePrix) / r.etat.pib
    * r.populationMilliers / s.populationMilliers

/-- Indices dimensionnels (santé, éducation, niveau de vie), millionièmes. -/
def indicesIdh (H : Scenario) (s : Etat) : Int × Int × Int :=
  let sante := borneIndice ((esperanceVieCentiemes H s - 2000) * 1000000 / 6500)
  let attendue := borneIndice (s.dureeAttendueCentiemes * 1000000 / 1800)
  let moyenne := borneIndice (s.dureeMoyenneCentiemes * 1000000 / 1500)
  let education := (attendue + moyenne) / 2
  let lnRnb := H.reference.lnRnbSur100Millioniemes
    + lnRapportMillioniemes (rnbParHabitantPpa H s) H.reference.rnbParHabitantPpaDollars
  -- ln(75 000 / 100) = 6,620073
  let niveauVie := borneIndice (lnRnb * 1000000 / 6620073)
  (sante, education, niveauVie)

/-- IDH, millionièmes : moyenne géométrique des trois indices. -/
def calculerIdh (H : Scenario) (s : Etat) : Int :=
  let (a, b, c) := indicesIdh H s
  ((racineCubique (a.toNat * b.toNat * c.toNat) : Nat) : Int)

end Modele
