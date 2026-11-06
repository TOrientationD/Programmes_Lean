import Modele
import Hypotheses

/-!
# Tests du modèle commun : identités comptables

Invariants que toute projection doit respecter, vérifiés par le noyau sur
le scénario central, sans programme et avec un programme d'essai qui
touche chaque famille de leviers (dépense, prélèvement, économie, prêt).
-/

namespace Tests.Comptabilite
open Modele

def H : Scenario := Hypotheses.central
def D : Moteur := Hypotheses.Moteurs.demande
def O : Moteur := Hypotheses.Moteurs.offre

/-- Programme d'essai, entré en vigueur la première année projetée. -/
def essai : Programme where
  id := "Essai"
  nom := "Essai"
  description := "Programme d'essai des tests"
  mainteneurs := []
  source := "Tests"
  mesures := [
    { id := "T-1", titre := "Dépense", source := "", leviers := [.depenseSur .enseignement 10000] },
    { id := "T-2", titre := "Prélèvement", source := "", leviers := [.prelevementSur .ir 8000] },
    { id := "T-3", titre := "Économie", source := "", leviers := [.economieSur .fonctionnement 5000], debut := 2 },
    { id := "T-4", titre := "Prêt", source := "", leviers := [.pretEtat 2000] } ]
  entreeEnVigueur := 1

def vide : Programme := { essai with mesures := [] }

def tendanciel (M : Moteur) : List Etat := trajectoire M H 10 (etatDepart H)
def avecEssai (M : Moteur) : List Etat := essai.trajectoire M H 10 0 (etatDepart H)

/-- La dette de fin d'année devient la dette de début de l'année suivante. -/
def continuite : List Etat → Bool
  | a :: b :: r => decide (b.detteDebut = a.dette) && continuite (b :: r)
  | _ => true

/-- Les années se suivent : rang 0, 1, 2… -/
def rangs : Nat → List Etat → Bool
  | k, a :: r => decide (a.rang = k) && rangs (k + 1) r
  | _, [] => true

theorem dette_continue_tendanciel : continuite (tendanciel D) = true := by decide +kernel
theorem dette_continue_programme : continuite (avecEssai D) = true := by decide +kernel
theorem dette_continue_offre : continuite (avecEssai O) = true := by decide +kernel
theorem rangs_tendanciel : rangs 0 (tendanciel D) = true := by decide +kernel

/-- Neutralité : un programme sans mesure donne exactement le tendanciel. -/
theorem programme_vide_neutre :
    vide.trajectoire D H 10 0 (etatDepart H) = tendanciel D := by decide +kernel

/-- Les mesures d'une année entrent dans la dette de cette année : l'année
d'entrée en vigueur, l'écart de dette au tendanciel est l'écart de déficit
plus le prêt (opération financière). -/
theorem mesures_dans_la_dette :
    let t := (tendanciel D)[1]!
    let p := (avecEssai D)[1]!
    p.dette - t.dette = (p.deficit - t.deficit) + 2000 := by decide +kernel

end Tests.Comptabilite
