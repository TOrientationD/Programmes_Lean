import Modele.Projection

/-!
# Propriétés

Une propriété est un énoncé décidable sur le triplet
`(scénario, état tendanciel, état avec programme)`. Elle peut donc exprimer
une contrainte absolue (« déficit sous le plafond légal ») comme une
comparaison au tendanciel (« le programme n'augmente pas le chômage »).

Les **valeurs** vivent dans `Proprietes/`. Toute propriété est évaluée pour
chaque programme sous chaque scénario : c'est la matrice du rapport.
-/

namespace Modele

structure Propriete where
  id : String
  titre : String
  description : String
  /-- `tient H tendanciel avecProgramme` -/
  tient : Scenario → Etat → Etat → Prop
  dec : ∀ H a b, Decidable (tient H a b)
  /-- Année d'évaluation, comptée depuis l'année de départ ; `none` =
  horizon du scénario. Permet « déficit sous 3 % en 2035 ». -/
  annee : Option Nat := none
  /-- Critère portant sur toute la trajectoire, quand l'état final ne suffit
  pas (« le déficit baisse chaque année ») : `f H entree tendanciel
  programme`, où les listes contiennent les états des années 0 à
  `horizon` et `entree` est l'année d'entrée en vigueur du programme.
  S'il est présent, il remplace `tient`. -/
  trajectoire : Option (Scenario → Nat → List Etat → List Etat → Bool) := none

instance (p : Propriete) (H : Scenario) (a b : Etat) : Decidable (p.tient H a b) :=
  p.dec H a b

/-- Propriété de trajectoire (critère calculable sur les listes d'états). -/
def Propriete.surTrajectoire (id titre description : String)
    (f : Scenario → Nat → List Etat → List Etat → Bool) (annee : Option Nat := none) : Propriete :=
  ⟨id, titre, description, (fun _ _ _ => True), (fun _ _ _ => instDecidableTrue), annee, some f⟩

/-- Constructeur qui infère l'instance de décidabilité. -/
def Propriete.mk' (id titre description : String)
    (tient : Scenario → Etat → Etat → Prop)
    [inst : ∀ H a b, Decidable (tient H a b)] (annee : Option Nat := none) : Propriete :=
  ⟨id, titre, description, tient, inst, annee, none⟩

/-- Année à laquelle la propriété est évaluée sous le scénario `H`. -/
def Propriete.horizon (p : Propriete) (H : Scenario) : Nat :=
  p.annee.getD H.horizon

/-- Évaluation calculable (utilisée par le rapport). -/
def Propriete.evaluer (p : Propriete) (H : Scenario) (a b : Etat) : Bool :=
  decide (p.tient H a b)

end Modele
