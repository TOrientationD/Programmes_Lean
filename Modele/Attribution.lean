/-!
# Sous-modèle : attribution de logements sociaux vérifiable

Une attribution est **transparente** si chacun peut vérifier qu'elle suit
la règle publiée, sans que les données personnelles des demandeurs soient
divulguées. Une preuve à divulgation nulle de connaissance (ZK) le permet :
la commission publie un engagement cryptographique sur la liste des
candidats (racine de Merkle) et, pour chaque attribution, une preuve de
l'énoncé `EnonceZK` ci-dessous. La liste reste privée.

Ce module ne contient pas le circuit ZK : il fixe **ce que le circuit doit
prouver** et démontre que cet énoncé ne laisse aucune marge discrétionnaire :

* `choisir_conforme`, `choisir_complet` : la règle est exécutable, et elle
  désigne un attributaire dès qu'un candidat est éligible ;
* `conforme_unique` : pour une liste donnée, un seul candidat satisfait la
  règle ;
* `zk_sans_discretion` : deux preuves acceptées pour le même engagement
  désignent le même attributaire, si l'engagement est liant ;
* `zk_complet` : la commission peut toujours produire la preuve pour
  l'attributaire légitime.

La règle : parmi les candidats éligibles, le plus haut score de cotation
(grille publiée), puis le dépôt le plus ancien, puis l'identifiant
pseudonyme le plus petit.

Hors du champ de Lean, à traiter séparément : le caractère liant de
l'engagement (hypothèse cryptographique, ici `hlie`), la correction du
circuit vis-à-vis de `Conforme`, le calcul honnête des scores à partir des
pièces du dossier.
-/

namespace Modele

/-- Un candidat, tel que le voit le circuit (données privées). -/
structure Candidat where
  /-- Identifiant pseudonyme (dérivé du numéro unique de demande). -/
  id : Nat
  /-- Éligible à ce logement (plafonds de ressources, typologie…). -/
  eligible : Bool
  /-- Points de cotation selon la grille publiée. -/
  score : Int
  /-- Date de dépôt de la demande, en jours. -/
  depot : Nat
  deriving Repr, DecidableEq

namespace Candidat

/-- `a` passe devant `b` : score plus élevé, puis dépôt plus ancien, puis
identifiant plus petit. -/
def Devant (a b : Candidat) : Prop :=
  b.score < a.score ∨ (a.score = b.score ∧ (a.depot < b.depot ∨ (a.depot = b.depot ∧ a.id < b.id)))

instance (a b : Candidat) : Decidable (Devant a b) := by unfold Devant; infer_instance

theorem devant_irrefl (a : Candidat) : ¬ Devant a a := by
  unfold Devant; omega

theorem devant_trans {a b c : Candidat} : Devant a b → Devant b c → Devant a c := by
  unfold Devant; omega

theorem devant_total {a b : Candidat} (h : a.id ≠ b.id) : Devant a b ∨ Devant b a := by
  unfold Devant; omega

end Candidat

open Candidat

/-- `a` est l'attributaire conforme à la règle pour la liste `cs`. -/
def Conforme (cs : List Candidat) (a : Candidat) : Prop :=
  a ∈ cs ∧ a.eligible = true ∧ ∀ d ∈ cs, d.eligible = true → ¬ Devant d a

/-- La règle, exécutable. -/
def choisir : List Candidat → Option Candidat
  | [] => none
  | c :: cs =>
    match choisir cs with
    | none => if c.eligible then some c else none
    | some a => if c.eligible ∧ Devant c a then some c else some a

theorem choisir_none {cs : List Candidat} (h : choisir cs = none) :
    ∀ d ∈ cs, d.eligible = false := by
  induction cs with
  | nil => intro d hd; cases hd
  | cons c cs ih =>
    simp only [choisir] at h
    split at h
    · rename_i hcs
      split at h
      · cases h
      · rename_i hc
        intro d hd
        rcases List.mem_cons.mp hd with rfl | hd
        · simpa using hc
        · exact ih hcs d hd
    · split at h <;> cases h

theorem choisir_conforme {cs : List Candidat} {a : Candidat} (h : choisir cs = some a) :
    Conforme cs a := by
  induction cs generalizing a with
  | nil => cases h
  | cons c cs ih =>
    simp only [choisir] at h
    split at h
    · rename_i hcs
      split at h
      · rename_i hc
        cases h
        refine ⟨List.mem_cons_self .., hc, ?_⟩
        intro d hd hde
        rcases List.mem_cons.mp hd with rfl | hd
        · exact devant_irrefl d
        · have := choisir_none hcs d hd; simp_all
      · cases h
    · rename_i b hcs
      have ⟨hb, hbe, hbmax⟩ := ih hcs
      split at h
      · rename_i hc
        cases h
        refine ⟨List.mem_cons_self .., hc.1, ?_⟩
        intro d hd hde hdc
        rcases List.mem_cons.mp hd with rfl | hd
        · exact devant_irrefl d hdc
        · exact hbmax d hd hde (devant_trans hdc hc.2)
      · rename_i hc
        cases h
        refine ⟨List.mem_cons_of_mem _ hb, hbe, ?_⟩
        intro d hd hde
        rcases List.mem_cons.mp hd with rfl | hd
        · exact fun hdb => hc ⟨hde, hdb⟩
        · exact hbmax d hd hde

/-- **Complétude** : dès qu'un candidat est éligible, la règle désigne un
attributaire. -/
theorem choisir_complet {cs : List Candidat} (h : ∃ c ∈ cs, c.eligible = true) :
    ∃ a, choisir cs = some a := by
  cases hc : choisir cs with
  | some a => exact ⟨a, rfl⟩
  | none =>
    obtain ⟨c, hc', he⟩ := h
    have := choisir_none hc c hc'
    simp_all

theorem egal_si_meme_id {cs : List Candidat} (hnd : (cs.map (·.id)).Nodup)
    {a b : Candidat} (ha : a ∈ cs) (hb : b ∈ cs) (hid : a.id = b.id) : a = b := by
  induction cs with
  | nil => cases ha
  | cons c cs ih =>
    simp only [List.map_cons, List.nodup_cons] at hnd
    obtain ⟨hnd1, hnd2⟩ := hnd
    rcases List.mem_cons.mp ha with hac | ha'
    · rcases List.mem_cons.mp hb with hbc | hb'
      · rw [hac, hbc]
      · exfalso; apply hnd1; rw [← hac, hid]; exact List.mem_map_of_mem hb'
    · rcases List.mem_cons.mp hb with hbc | hb'
      · exfalso; apply hnd1; rw [← hbc, ← hid]; exact List.mem_map_of_mem ha'
      · exact ih hnd2 ha' hb'

/-- **Unicité** : avec des identifiants distincts, un seul candidat est
conforme. Il n'y a rien à arbitrer. -/
theorem conforme_unique {cs : List Candidat} (hnd : (cs.map (·.id)).Nodup)
    {a b : Candidat} (ha : Conforme cs a) (hb : Conforme cs b) : a = b := by
  obtain ⟨ham, hae, hamax⟩ := ha
  obtain ⟨hbm, hbe, hbmax⟩ := hb
  by_cases hid : a.id = b.id
  · exact egal_si_meme_id hnd ham hbm hid
  · rcases devant_total hid with h | h
    · exact absurd h (hbmax a ham hae)
    · exact absurd h (hamax b hbm hbe)

/-- Énoncé prouvé en ZK pour chaque attribution. Public : `racine`
(engagement sur la liste) et `attributaire`. Privé : la liste. -/
def EnonceZK {R : Type} (engager : List Candidat → R) (racine : R) (attributaire : Nat) : Prop :=
  ∃ cs a, engager cs = racine ∧ (cs.map (·.id)).Nodup ∧ Conforme cs a ∧ a.id = attributaire

/-- **Aucune discrétion** : si l'engagement est liant, deux preuves acceptées
pour la même racine désignent le même attributaire. -/
theorem zk_sans_discretion {R : Type} {engager : List Candidat → R}
    (hlie : ∀ x y, engager x = engager y → x = y) {r : R} {i j : Nat}
    (hi : EnonceZK engager r i) (hj : EnonceZK engager r j) : i = j := by
  obtain ⟨cs, a, hcs, hnd, ha, rfl⟩ := hi
  obtain ⟨cs', b, hcs', -, hb, rfl⟩ := hj
  have : cs = cs' := hlie _ _ (hcs.trans hcs'.symm)
  subst this
  rw [conforme_unique hnd ha hb]

/-- **Complétude de la preuve** : pour toute liste aux identifiants distincts
comportant un éligible, l'attributaire calculé par la règle satisfait
l'énoncé ; la commission peut donc toujours produire la preuve. -/
theorem zk_complet {R : Type} (engager : List Candidat → R) {cs : List Candidat}
    (hnd : (cs.map (·.id)).Nodup) {a : Candidat} (h : choisir cs = some a) :
    EnonceZK engager (engager cs) a.id :=
  ⟨cs, a, rfl, hnd, choisir_conforme h, rfl⟩

end Modele
