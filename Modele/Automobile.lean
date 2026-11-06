import Modele.Unites

/-!
# Sous-modèle : remplacement de véhicules et commerce extérieur

Remplacer des voitures thermiques par des voitures électriques a deux effets
opposés sur la balance commerciale :

* **une fois**, à l'achat : la part importée de la valeur des véhicules
  neufs creuse le déficit ;
* **chaque année** ensuite : le carburant que les véhicules retirés auraient
  brûlé n'est plus importé, mais l'électricité qu'ils consomment n'est plus
  exportée (la France est exportatrice nette d'électricité).

Le solde cumulé après `n` années est donc `n × gain annuel − importations
initiales`. Ce module le calcule et prouve qu'il est croissant avec le temps
dès que le gain annuel est positif, et que l'année d'équilibre calculée est
correcte et minimale.

Simplifications assumées (à affiner par issue « modèle commun ») :
* pas de scénario contrefactuel : les véhicules retirés ne sont pas censés
  être remplacés plus tard de toute façon ;
* la valeur importée est une part de la valeur du véhicule, marges de
  distribution comprises ;
* pas d'effet sur les exportations de véhicules d'occasion (véhicules
  retirés détruits et recyclés en France).

Unités : €, centimes (`Cts`), litres, kWh, pm.
-/

namespace Modele

/-- Hypothèses du sous-modèle (valeurs et sources : `Hypotheses/Automobile.lean`). -/
structure HypAuto where
  id : String
  description : String
  /-- Carburant non consommé par véhicule thermique retiré, litres/an. -/
  litresEvitesParAn : Int
  /-- Valeur à l'importation d'un litre de carburant, centimes. -/
  valeurImportCarburantCts : Int
  /-- Électricité consommée par le véhicule de remplacement, kWh/an. -/
  kwhParAn : Int
  /-- Valeur à l'exportation de l'électricité, €/MWh (= dixièmes de centime par kWh). -/
  valeurExportElecEurMWh : Int
  sources : List String
  deriving Repr

abbrev HypAuto.Valide (h : HypAuto) : Prop :=
  0 ≤ h.litresEvitesParAn ∧ 0 ≤ h.valeurImportCarburantCts ∧
  0 ≤ h.kwhParAn ∧ 0 ≤ h.valeurExportElecEurMWh

/-- Opération de remplacement, telle que la décrit le programme. -/
structure Remplacement where
  nombre : Int
  /-- Prix d'achat d'un véhicule de remplacement, €. -/
  prixUnitaire : Int
  /-- Part importée de la valeur du véhicule, pm. -/
  partImporteePm : Int
  /-- Vignette Crit'Air des voitures retirées (0 : moyenne du parc). Le
  modèle en déduit leurs particules à l'échappement (axe énergie). -/
  vignetteCritAir : Nat := 0
  deriving Repr, DecidableEq

namespace Remplacement

/-- Coût budgétaire total, €, versé une fois. -/
def cout (r : Remplacement) : Int := r.nombre * r.prixUnitaire

/-- Importations de véhicules, centimes (année 0). -/
def importsInitialesCts (r : Remplacement) : Int :=
  r.nombre * r.prixUnitaire * r.partImporteePm / 10

/-- Effet annuel sur le solde commercial, centimes/an : carburant importé
évité moins électricité non exportée. -/
def gainAnnuelCts (h : HypAuto) (r : Remplacement) : Int :=
  r.nombre * (h.litresEvitesParAn * h.valeurImportCarburantCts
    - h.kwhParAn * h.valeurExportElecEurMWh / 10)

/-- Solde commercial cumulé `n` années après l'achat, centimes. -/
def soldeCumuleCts (h : HypAuto) (r : Remplacement) (n : Nat) : Int :=
  (n : Int) * r.gainAnnuelCts h - r.importsInitialesCts

/-- Première année où le solde cumulé redevient positif ou nul ; `none` si
le gain annuel n'est pas positif (le déficit ne se résorbe jamais). -/
def anneeEquilibre (h : HypAuto) (r : Remplacement) : Option Nat :=
  if r.importsInitialesCts ≤ 0 then some 0
  else if r.gainAnnuelCts h ≤ 0 then none
  else some ((r.importsInitialesCts + r.gainAnnuelCts h - 1) / r.gainAnnuelCts h).toNat

/-! ## Propriétés -/

/-- **Le déficit induit se résorbe avec le temps** : si le gain annuel est
positif, le solde cumulé est croissant en le nombre d'années. -/
theorem soldeCumule_mono (h : HypAuto) (r : Remplacement) (hg : 0 ≤ r.gainAnnuelCts h)
    {m n : Nat} (hmn : m ≤ n) : r.soldeCumuleCts h m ≤ r.soldeCumuleCts h n := by
  unfold soldeCumuleCts
  have := Int.mul_le_mul_of_nonneg_right (Int.ofNat_le.mpr hmn) hg
  omega

/-- **L'année d'équilibre est correcte et minimale** : le solde y est positif
ou nul, et strictement négatif l'année précédente. -/
theorem anneeEquilibre_correcte (h : HypAuto) (r : Remplacement) {n : Nat}
    (hn : r.anneeEquilibre h = some n) :
    0 ≤ r.soldeCumuleCts h n ∧ (0 < n → r.soldeCumuleCts h (n - 1) < 0) := by
  unfold anneeEquilibre at hn
  unfold soldeCumuleCts
  split at hn
  · rename_i hI
    cases hn
    constructor
    · simp; omega
    · intro h0; exact absurd h0 (Nat.lt_irrefl 0)
  · rename_i hI
    split at hn
    · cases hn
    · rename_i hG
      cases hn
      generalize hI' : r.importsInitialesCts = I at *
      generalize hG' : r.gainAnnuelCts h = G at *
      have hq0 : 0 ≤ (I + G - 1) / G := Int.ediv_nonneg (by omega) (by omega)
      have hq : (((I + G - 1) / G).toNat : Int) = (I + G - 1) / G := Int.toNat_of_nonneg hq0
      have hdiv := Int.mul_ediv_add_emod (I + G - 1) G
      have hmod0 := Int.emod_nonneg (I + G - 1) (show G ≠ 0 by omega)
      have hmodlt := Int.emod_lt_of_pos (I + G - 1) (show 0 < G by omega)
      constructor
      · rw [hq, Int.mul_comm]; omega
      · intro hpos
        have hcast : ((((I + G - 1) / G).toNat - 1 : Nat) : Int) = (I + G - 1) / G - 1 := by
          omega
        rw [hcast, Int.sub_mul, Int.one_mul, Int.mul_comm]
        omega

end Remplacement

end Modele
