import Hypotheses.Reference
import Hypotheses.Demographie
import Hypotheses.Economie
import Hypotheses.Droit
import Hypotheses.Natalite
import Hypotheses.Energie
import Hypotheses.Sols

/-!
# Scénarios : produit cartésien des axes

`tous` croise chaque valeur de chaque axe. Ajouter une valeur sur un axe
ajoute automatiquement une ligne par combinaison dans la matrice d'évaluation
de **tous** les programmes.

Les théorèmes ci-dessous sont des garde-fous de CI :
* `tous_valides` — aucune hypothèse absurde ;
* `tous_non_vide` — l'espace des hypothèses n'est pas vide (sinon tout
  énoncé « pour tout scénario » serait vrai par vacuité).
-/

namespace Hypotheses
open Modele

/-- Horizon commun de projection, en années. -/
def horizon : Nat := 5

/-- Construit un scénario à partir de ses axes (pour les engagements).
Natalité et prix du pétrole prennent par défaut leur valeur centrale. -/
def scenario (d : Demographie) (e : Economie) (j : CadreJuridique)
    (n : Natalite := Natalite.centrale) (en : Energie := Energie.central) : Scenario :=
  { reference := reference2026, demo := d, natalite := n, eco := e, energie := en, droit := j,
    sols := Sols.central, horizon := horizon }

/-- Produit cartésien démographie × économie × prix du pétrole × droit.
La natalité, sans effet sur les propriétés à l'horizon, est fixée à sa
valeur centrale (voir `Hypotheses/Natalite.lean`). -/
def tous : List Scenario :=
  Demo.toutes.flatMap fun d =>
    Eco.toutes.flatMap fun e =>
      Energie.toutes.flatMap fun en =>
        Droit.toutes.map fun j => scenario d e j (en := en)

/-- Scénario de référence. -/
def central : Scenario := scenario Demo.centrale Eco.centrale Droit.cadreActuel

/-- Variantes de la synthèse PDF : le scénario central, puis une hypothèse
modifiée à la fois. -/
def variantesSynthese : List (String × String × Scenario) := [
  ("central", "Scénario central", central),
  ("natalite-basse", "Natalité basse (1,40)", scenario Demo.centrale Eco.centrale Droit.cadreActuel (n := Natalite.basse)),
  ("natalite-haute", "Natalité haute (1,80)", scenario Demo.centrale Eco.centrale Droit.cadreActuel (n := Natalite.haute)),
  ("petrole-bas", "Pétrole à 50 $", scenario Demo.centrale Eco.centrale Droit.cadreActuel (en := Energie.bas)),
  ("petrole-haut", "Pétrole à 100 $", scenario Demo.centrale Eco.centrale Droit.cadreActuel (en := Energie.haut))
]

theorem tous_valides : ∀ H ∈ tous, H.Valide := by decide +kernel

theorem tous_non_vide : 0 < tous.length := by decide +kernel

theorem central_valide : central.Valide := by decide +kernel

theorem variantes_valides : ∀ v ∈ variantesSynthese, v.2.2.Valide := by decide +kernel

end Hypotheses
