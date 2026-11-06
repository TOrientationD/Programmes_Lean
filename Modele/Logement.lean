import Modele.Unites

/-!
# Sous-modèle communal : article 55 de la loi SRU

Certaines mesures ne se lisent pas à l'échelle macro. Une amende SRU est un
transfert des communes vers le FNAP et les établissements fonciers : elle
est neutre sur le solde consolidé des administrations publiques, mais son
**barème** se juge commune par commune.

Ce module formalise :

* les données SRU d'une commune (`Commune`) ;
* le **droit actuel** (CCH L.302-7 et L.302-9-1) : prélèvement de base
  automatique, et plafond de la majoration que le préfet peut décider en
  cas de carence ;
* un vocabulaire de **barème automatique** (`BaremeSRU`) : coefficient
  linéaire en la part de l'objectif non atteinte, plafond, seuil ;
* des théorèmes valables **pour toute commune** et **tout barème bien
  formé** : amende nulle si l'objectif est atteint, plafonnée, jamais
  augmentée par la construction d'un logement social (pas d'effet
  pervers), encadrée par le droit actuel.

« Automatique » se lit dans la signature : `BaremeSRU.amende b : Commune →
Int` ne prend que les données de la commune. Aucun paramètre
d'appréciation n'existe, contrairement à la majoration préfectorale
actuelle.

Montants en €, taux en pb, coefficients en pm (`Modele/Unites.lean`).
Chaque montant est calculé avec **une seule** division finale : les
arrondis ne peuvent pas casser les propriétés prouvées.
-/

namespace Modele

/-- Données SRU d'une commune soumise (CCH L.302-5 à L.302-7). -/
structure Commune where
  id : String
  /-- Résidences principales. -/
  residencesPrincipales : Int
  /-- Logements sociaux décomptés (inventaire SRU). -/
  logementsSociaux : Int
  /-- Taux légal, pb : `2500` (25 %) ou `2000` (20 %). -/
  tauxLegalPb : Int
  /-- Potentiel fiscal par habitant, €. -/
  potentielFiscalParHabitant : Int
  /-- Dépenses réelles de fonctionnement (compte administratif N-2), €. -/
  depensesReellesFonctionnement : Int
  deriving Repr, DecidableEq

namespace Commune

/-- Données plausibles (rien de négatif, taux ≤ 100 %). -/
abbrev Valide (c : Commune) : Prop :=
  0 ≤ c.residencesPrincipales ∧ 0 ≤ c.logementsSociaux ∧
  0 ≤ c.tauxLegalPb ∧ c.tauxLegalPb ≤ 10000 ∧
  0 ≤ c.potentielFiscalParHabitant ∧ 0 ≤ c.depensesReellesFonctionnement

/-- Objectif légal de logements sociaux. -/
def objectif (c : Commune) : Int := c.tauxLegalPb * c.residencesPrincipales / 10000

/-- Logements sociaux manquants (0 si l'objectif est atteint). -/
def manquants (c : Commune) : Int := max 0 (c.objectif - c.logementsSociaux)

/-- Part de l'objectif non atteinte, pm (affichage seulement). -/
def partManquantePm (c : Commune) : Int :=
  if c.objectif ≤ 0 then 0 else c.manquants * 1000 / c.objectif

/-- Part de logements sociaux dans les résidences principales, pb. -/
def tauxLogementsSociauxPb (c : Commune) : Int :=
  ratioPb c.logementsSociaux c.residencesPrincipales

/-- `tauxPb` pb des dépenses réelles de fonctionnement. -/
def plafond (c : Commune) (tauxPb : Int) : Int :=
  c.depensesReellesFonctionnement * tauxPb / 10000

end Commune

namespace SRU

/-- Rien n'est prélevé sous le seuil de recouvrement. -/
def recouvrer (seuil x : Int) : Int := if x < seuil then 0 else x

/-- Seuil de recouvrement actuel : 4 000 € (CCH L.302-7). -/
def seuilActuel : Int := 4000

/-- **Droit actuel, prélèvement de base** (CCH L.302-7) : 25 % du potentiel
fiscal par habitant par logement manquant, plafonné à 5 % des dépenses
réelles de fonctionnement, non prélevé sous 4 000 €. Automatique.
(Les dépenses déductibles ne sont pas modélisées.) -/
def prelevementActuel (c : Commune) : Int :=
  recouvrer seuilActuel
    (min (c.potentielFiscalParHabitant * c.manquants / 4) (c.plafond 500))

/-- **Droit actuel, maximum en cas de carence** (CCH L.302-9-1) : le préfet
peut majorer jusqu'à cinq fois le prélèvement initial ; le prélèvement
majoré ne peut excéder 5 % des DRF, 7,5 % si le potentiel fiscal par
habitant atteint 150 % de la médiane des communes soumises.

Le montant effectif est **discrétionnaire** entre `prelevementActuel` et ce
maximum. Lecture retenue pour « prélèvement initial » : le prélèvement de
base déjà plafonné à 5 % (la plus basse des deux lectures possibles ; tout
énoncé « ≤ maximum actuel » prouvé ici vaut donc pour l'autre lecture). -/
def majorationMaxActuelle (medianePFH : Int) (c : Commune) : Int :=
  let plafondMajorePb := if 3 * medianePFH ≤ 2 * c.potentielFiscalParHabitant then 750 else 500
  recouvrer seuilActuel
    (min (min (5 * c.potentielFiscalParHabitant * c.manquants / 4) (5 * c.plafond 500))
         (c.plafond plafondMajorePb))

end SRU

/-- Barème d'amende SRU **automatique** :

`amende = tauxBase × PFH × manquants × coef(p)`, plafonnée et soumise au
seuil de recouvrement, où `p = manquants / objectif` et
`coef(p) = coefMin + (coefMax − coefMin) × p` (linéaire, sans effet de
seuil). -/
structure BaremeSRU where
  /-- Part du potentiel fiscal par habitant par logement manquant, pm (`250` = 25 %). -/
  tauxBasePm : Int
  /-- Coefficient pour une commune presque conforme (p → 0), pm (`1000` = ×1). -/
  coefMinPm : Int
  /-- Coefficient pour une commune sans aucun logement social (p = 100 %), pm. -/
  coefMaxPm : Int
  /-- Plafond, pb des dépenses réelles de fonctionnement. -/
  plafondPb : Int
  /-- Seuil de recouvrement, €. -/
  seuil : Int
  deriving Repr, DecidableEq

namespace BaremeSRU

abbrev Valide (b : BaremeSRU) : Prop :=
  0 ≤ b.tauxBasePm ∧ 0 ≤ b.coefMinPm ∧ b.coefMinPm ≤ b.coefMaxPm ∧
  0 ≤ b.plafondPb ∧ 0 ≤ b.seuil

/-- Montant avant plafond, en une seule division :
`PFH × m × tauxBase × (coefMin × o + (coefMax − coefMin) × m) / (10⁶ × o)`. -/
def brut (b : BaremeSRU) (c : Commune) : Int :=
  if c.objectif ≤ 0 then 0 else
    c.potentielFiscalParHabitant * c.manquants * b.tauxBasePm *
      (b.coefMinPm * c.objectif + (b.coefMaxPm - b.coefMinPm) * c.manquants)
      / (1000000 * c.objectif)

/-- Amende due par la commune. -/
def amende (b : BaremeSRU) (c : Commune) : Int :=
  SRU.recouvrer b.seuil (min (b.brut c) (c.plafond b.plafondPb))

/-- Coefficient effectif `coef(p)` en pm (affichage seulement). -/
def coefPm (b : BaremeSRU) (c : Commune) : Int :=
  b.coefMinPm + (b.coefMaxPm - b.coefMinPm) * c.partManquantePm / 1000

/-! ## Propriétés valables pour toute commune et tout barème bien formé -/

section Preuves

variable {b : BaremeSRU} {c : Commune}

theorem manquants_nonneg (c : Commune) : 0 ≤ c.manquants := by
  unfold Commune.manquants; omega

theorem manquants_le_objectif (hc : c.Valide) : c.manquants ≤ max 0 c.objectif := by
  unfold Commune.manquants; omega

theorem plafond_nonneg (hc : c.Valide) {t : Int} (ht : 0 ≤ t) : 0 ≤ c.plafond t :=
  Int.ediv_nonneg (Int.mul_nonneg hc.2.2.2.2.2 ht) (by decide)

theorem plafond_mono (hc : c.Valide) {t u : Int} (h : t ≤ u) : c.plafond t ≤ c.plafond u :=
  Int.ediv_le_ediv (by decide) (Int.mul_le_mul_of_nonneg_left h hc.2.2.2.2.2)

/-- `recouvrer` est croissant en le montant et décroissant en le seuil. -/
theorem recouvrer_mono {s t x y : Int} (hs : 0 ≤ t) (hst : t ≤ s) (hxy : x ≤ y) :
    SRU.recouvrer s x ≤ SRU.recouvrer t y := by
  unfold SRU.recouvrer; split <;> split <;> omega

/-- Le numérateur du barème est croissant en le nombre de manquants. -/
theorem numerateur_mono (hb : b.Valide) {P o m m' : Int} (hP : 0 ≤ P) (ho : 0 < o)
    (hm' : 0 ≤ m') (hmm : m' ≤ m) :
    P * m' * b.tauxBasePm * (b.coefMinPm * o + (b.coefMaxPm - b.coefMinPm) * m')
      ≤ P * m * b.tauxBasePm * (b.coefMinPm * o + (b.coefMaxPm - b.coefMinPm) * m) := by
  obtain ⟨htb, hcmin, hcc, -, -⟩ := hb
  have hΔ : 0 ≤ b.coefMaxPm - b.coefMinPm := by omega
  have h1 : P * m' * b.tauxBasePm ≤ P * m * b.tauxBasePm :=
    Int.mul_le_mul_of_nonneg_right (Int.mul_le_mul_of_nonneg_left hmm hP) htb
  have h2 : (b.coefMaxPm - b.coefMinPm) * m' ≤ (b.coefMaxPm - b.coefMinPm) * m :=
    Int.mul_le_mul_of_nonneg_left hmm hΔ
  have h3 : 0 ≤ b.coefMinPm * o + (b.coefMaxPm - b.coefMinPm) * m' := by
    have := Int.mul_nonneg hcmin (Int.le_of_lt ho)
    have := Int.mul_nonneg hΔ hm'
    omega
  have h4 : 0 ≤ P * m * b.tauxBasePm :=
    Int.mul_nonneg (Int.mul_nonneg hP (Int.le_trans hm' hmm)) htb
  exact Int.mul_le_mul h1 (by omega) h3 h4

theorem brut_nonneg (hb : b.Valide) (hc : c.Valide) : 0 ≤ b.brut c := by
  unfold brut
  split
  · exact Int.le_refl 0
  · have := numerateur_mono (b := b) (P := c.potentielFiscalParHabitant) (o := c.objectif)
      (m := c.manquants) (m' := 0) hb hc.2.2.2.2.1 (by omega) (Int.le_refl 0) (manquants_nonneg c)
    simp only [Int.mul_zero, Int.zero_mul] at this
    exact Int.ediv_nonneg this (Int.le_of_lt (Int.mul_pos (by decide) (by omega)))

/-- **Nulle si conforme** : une commune qui atteint son objectif ne paie rien. -/
theorem amende_nulle_si_conforme (hb : b.Valide) (hc : c.Valide)
    (h : c.objectif ≤ c.logementsSociaux) : b.amende c = 0 := by
  have hm : c.manquants = 0 := by unfold Commune.manquants; omega
  have hbrut : b.brut c = 0 := by
    unfold brut; split
    · rfl
    · simp [hm]
  have := plafond_nonneg hc hb.2.2.2.1 (t := b.plafondPb)
  unfold amende SRU.recouvrer; rw [hbrut]; split <;> omega

/-- **Plafonnée** : l'amende ne dépasse jamais le plafond du barème. -/
theorem amende_plafonnee (hb : b.Valide) (hc : c.Valide) :
    b.amende c ≤ c.plafond b.plafondPb := by
  have := plafond_nonneg hc hb.2.2.2.1 (t := b.plafondPb)
  unfold amende SRU.recouvrer; split <;> omega

theorem amende_nonneg (hb : b.Valide) (hc : c.Valide) : 0 ≤ b.amende c := by
  have := brut_nonneg hb hc
  have := plafond_nonneg hc hb.2.2.2.1 (t := b.plafondPb)
  have := hb.2.2.2.2
  unfold amende SRU.recouvrer; split <;> omega

/-- Le brut ne dépend des logements sociaux qu'à travers les manquants, de
façon croissante. -/
theorem brut_mono (hb : b.Valide) {c' : Commune} (hP : 0 ≤ c.potentielFiscalParHabitant)
    (hobj : c'.objectif = c.objectif)
    (hpfh : c'.potentielFiscalParHabitant = c.potentielFiscalParHabitant)
    (hm : c'.manquants ≤ c.manquants) : b.brut c' ≤ b.brut c := by
  unfold brut
  rw [hobj, hpfh]
  split
  · exact Int.le_refl 0
  · exact Int.ediv_le_ediv (Int.mul_pos (by decide) (by omega))
      (numerateur_mono hb hP (by omega) (manquants_nonneg c') hm)

/-- **Pas d'effet pervers** : construire `k ≥ 0` logements sociaux de plus
ne peut jamais augmenter l'amende. -/
theorem amende_decroit_avec_logements_sociaux (hb : b.Valide) (hc : c.Valide)
    {k : Int} (hk : 0 ≤ k) :
    b.amende { c with logementsSociaux := c.logementsSociaux + k } ≤ b.amende c := by
  have hbrut : b.brut { c with logementsSociaux := c.logementsSociaux + k } ≤ b.brut c :=
    brut_mono hb hc.2.2.2.2.1 rfl rfl (by unfold Commune.manquants; simp only [Commune.objectif]; omega)
  unfold amende
  exact recouvrer_mono hb.2.2.2.2 (Int.le_refl _) (by simp only [Commune.plafond] at *; omega)

/-! ## Encadrement par le droit actuel -/

private theorem simplifier {A B o : Int} (ho : 0 < o) : A * o / (B * o) = A / B := by
  rw [Int.mul_comm A o, Int.mul_comm B o]; exact Int.mul_ediv_mul_of_pos _ _ ho

/-- Le brut est encadré par les coefficients extrêmes du barème. -/
theorem brut_encadre (hb : b.Valide) (hc : c.Valide) :
    c.potentielFiscalParHabitant * c.manquants * (b.tauxBasePm * b.coefMinPm) / 1000000 ≤ b.brut c ∧
    b.brut c ≤ c.potentielFiscalParHabitant * c.manquants * (b.tauxBasePm * b.coefMaxPm) / 1000000 := by
  obtain ⟨htb, hcmin, hcc, -, -⟩ := hb
  have hX : 0 ≤ c.potentielFiscalParHabitant * c.manquants :=
    Int.mul_nonneg hc.2.2.2.2.1 (manquants_nonneg c)
  have hm := manquants_le_objectif hc
  unfold brut
  split
  · rename_i ho
    have : c.manquants = 0 := by have := manquants_nonneg c; omega
    simp [this]
  · rename_i ho
    have ho : 0 < c.objectif := by omega
    have hΔ : 0 ≤ b.coefMaxPm - b.coefMinPm := by omega
    have hXt : 0 ≤ c.potentielFiscalParHabitant * c.manquants * b.tauxBasePm := Int.mul_nonneg hX htb
    have hD : 0 < 1000000 * c.objectif := Int.mul_pos (by decide) ho
    constructor
    · -- coef ≥ coefMin
      have hle : b.coefMinPm * c.objectif ≤
          b.coefMinPm * c.objectif + (b.coefMaxPm - b.coefMinPm) * c.manquants := by
        have := Int.mul_nonneg hΔ (manquants_nonneg c); omega
      have := Int.ediv_le_ediv hD (Int.mul_le_mul_of_nonneg_left hle hXt)
      rw [show c.potentielFiscalParHabitant * c.manquants * b.tauxBasePm * (b.coefMinPm * c.objectif)
            = c.potentielFiscalParHabitant * c.manquants * (b.tauxBasePm * b.coefMinPm) * c.objectif by
            simp only [Int.mul_assoc],
          simplifier ho] at this
      exact this
    · -- coef ≤ coefMax, car m ≤ o
      have hle : b.coefMinPm * c.objectif + (b.coefMaxPm - b.coefMinPm) * c.manquants ≤
          b.coefMaxPm * c.objectif := by
        have := Int.mul_le_mul_of_nonneg_left (show c.manquants ≤ c.objectif by omega) hΔ
        simp only [Int.sub_mul] at this ⊢; omega
      have := Int.ediv_le_ediv hD (Int.mul_le_mul_of_nonneg_left hle hXt)
      rw [show c.potentielFiscalParHabitant * c.manquants * b.tauxBasePm * (b.coefMaxPm * c.objectif)
            = c.potentielFiscalParHabitant * c.manquants * (b.tauxBasePm * b.coefMaxPm) * c.objectif by
            simp only [Int.mul_assoc],
          simplifier ho] at this
      exact this

/-- **Jamais moins que le droit actuel** : un barème dont le coefficient
minimal, le plafond et le seuil sont au moins aussi sévères que le droit
actuel prélève au moins le prélèvement de base actuel. -/
theorem amende_ge_prelevement_actuel (hb : b.Valide) (hc : c.Valide)
    (htaux : 250000 ≤ b.tauxBasePm * b.coefMinPm) (hplaf : 500 ≤ b.plafondPb)
    (hseuil : b.seuil ≤ SRU.seuilActuel) :
    SRU.prelevementActuel c ≤ b.amende c := by
  have hX : 0 ≤ c.potentielFiscalParHabitant * c.manquants :=
    Int.mul_nonneg hc.2.2.2.2.1 (manquants_nonneg c)
  have h1 := (brut_encadre hb hc).1
  have h2 := Int.ediv_le_ediv (show (0 : Int) < 1000000 by decide)
    (Int.mul_le_mul_of_nonneg_left htaux hX)
  have h3 := plafond_mono hc hplaf
  unfold SRU.prelevementActuel amende
  exact recouvrer_mono hb.2.2.2.2 hseuil (by omega)

/-- **Jamais plus que le maximum préfectoral actuel** : un barème dont le
coefficient maximal ne dépasse pas ×5, le plafond 5 % et le seuil 4 000 €
ne prélève jamais plus que ce qu'un préfet peut infliger aujourd'hui en
cas de carence, quelle que soit la médiane du potentiel fiscal. -/
theorem amende_le_majoration_max_actuelle (hb : b.Valide) (hc : c.Valide) (medianePFH : Int)
    (htaux : b.tauxBasePm * b.coefMaxPm ≤ 1250000) (hplaf : b.plafondPb ≤ 500)
    (hseuil : SRU.seuilActuel ≤ b.seuil) :
    b.amende c ≤ SRU.majorationMaxActuelle medianePFH c := by
  have hX : 0 ≤ c.potentielFiscalParHabitant * c.manquants :=
    Int.mul_nonneg hc.2.2.2.2.1 (manquants_nonneg c)
  have h1 := (brut_encadre hb hc).2
  have h2 := Int.ediv_le_ediv (show (0 : Int) < 1000000 by decide)
    (Int.mul_le_mul_of_nonneg_left htaux hX)
  have h3 := plafond_mono hc hplaf
  have h4 := plafond_nonneg hc (show (0 : Int) ≤ 500 by decide)
  have h5 : c.plafond 500 ≤ c.plafond
      (if 3 * medianePFH ≤ 2 * c.potentielFiscalParHabitant then 750 else 500) :=
    plafond_mono hc (by split <;> decide)
  have h6 : 5 * c.potentielFiscalParHabitant * c.manquants =
      5 * (c.potentielFiscalParHabitant * c.manquants) := Int.mul_assoc _ _ _
  unfold amende SRU.majorationMaxActuelle
  exact recouvrer_mono (by decide) hseuil (by omega)

end Preuves

end BaremeSRU

end Modele
