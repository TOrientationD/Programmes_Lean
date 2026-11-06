import Modele

/-!
# Tests du modèle commun : cohérence interne d'un programme

Programmes fictifs, sans source : seuls les leviers comptent. Ils vérifient
que `Programme.coherent` repère deux mesures contradictoires, qu'un
arbitrage déclaré lève l'alerte et que les étapes d'une même mesure ne sont
pas comparées entre elles.
-/

namespace Tests.Coherence
open Modele

/-- 35 h → 39 h : +114 ‰ d'heures (4/35, arrondi). -/
def passage39h : Levier := .dureeTravail 114
/-- 39 h → 35 h : −103 ‰ d'heures (4/39, arrondi). -/
def passage35h : Levier := .dureeTravail (-103)

def mesure (id : String) (ls : List Levier) : Mesure :=
  { id := id, titre := id, source := "test", leviers := ls }

def fictif (ms : List Mesure) (as : List Arbitrage := []) : Programme :=
  { id := "Fictif", nom := "Fictif", description := "", mainteneurs := [],
    source := "test", mesures := ms, arbitrages := as }

/-- O1 passe à 39 heures, O4 revient à 35 heures : programme incohérent. -/
def heures : Programme :=
  fictif [mesure "O1" [passage39h], mesure "O2" [.depense 100],
    mesure "O3" [.impotSocietes 2500], mesure "O4" [passage35h]]

theorem trente_neuf_contre_trente_cinq :
    heures.coherent = false ∧ heures.conflits.length = 1 := by decide

theorem conflit_designe :
    heures.conflits.map (fun c => (c.nature, c.reglage, c.mesure1, c.mesure2))
      = [(.sens, .dureeTravail, "O1", "O4")] := by decide

/-- Deux mesures du même sens ne se contredisent pas. -/
theorem meme_sens :
    (fictif [mesure "O1" [passage39h], mesure "O2" [.dureeTravail 10]]).coherent = true := by
  decide

/-- Deux taux d'impôt sur les sociétés différents se contredisent ; le même
taux deux fois, non. -/
theorem deux_taux_is :
    (fictif [mesure "O1" [.impotSocietes 2000], mesure "O2" [.impotSocietes 2500]]).coherent
      = false ∧
    (fictif [mesure "O1" [.impotSocietes 2000], mesure "O2" [.impotSocietes 2000]]).coherent
      = true := by decide

/-- L'arbitrage déclaré par l'auteur lève l'alerte, dans un ordre comme dans
l'autre, et reste visible avec sa raison. -/
theorem arbitrage_leve_l_alerte :
    let p := fictif heures.mesures [⟨"O4", "O1", "test"⟩]
    p.coherent = true ∧ p.conflitsArbitres.length = 1 ∧ p.arbitragesSansObjet = [] := by
  decide

/-- Un arbitrage qui ne couvre aucun conflit est signalé. -/
theorem arbitrage_sans_objet :
    (fictif heures.mesures [⟨"O2", "O3", "test"⟩]).arbitragesSansObjet.length = 1 := by decide

/-- Les étapes d'une même mesure (O5 puis O5b) forment un calendrier, pas une
contradiction. -/
theorem etapes_non_comparees :
    (fictif [mesure "O5" [.impotSocietes 2500], mesure "O5b" [.impotSocietes 2000]]).coherent
      = true := by decide

end Tests.Coherence
