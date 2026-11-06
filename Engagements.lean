import Programmes

/-!
# Vérification des engagements de tous les programmes

Un seul théorème (`tous_tenus`) couvre tous les programmes enregistrés : un
programme ajouté à `Programmes.tous` ne peut pas échapper à la vérification.

Si ce fichier ne compile plus, au moins un engagement est devenu faux.
Le rapport (`lake exe rapport`) indique lequel, sous quel scénario, et avec
quelles valeurs.

**Vérification par blocs.** Le noyau garde en mémoire tous les calculs d'une
même vérification : un programme qui revendique beaucoup d'engagements (par
exemple un engagement sous chacun des 36 scénarios) la ferait dépasser la
mémoire disponible. Les programmes d'au plus `seuil` engagements sont donc
vérifiés ensemble (`legers`) ; les autres, par blocs de `bloc` engagements
(`lourds_k`, un théorème par bloc, chacun vérifié à part par le noyau), et
`forall_mem_blocs` assemble les blocs. Au-delà de `bloc × blocs`
engagements pour un même programme, `lourds_fin` échoue : il faut ajouter
des blocs.

Un programme peut ajouter ici des théorèmes plus forts que ses engagements
ponctuels, par exemple des énoncés paramétriques (« pour toute croissance
≥ 2 %… ») prouvés avec `omega`.
-/

namespace Engagements
open Modele

/-- Programmes vérifiés d'un seul tenant : au plus `seuil` engagements. -/
abbrev seuil : Nat := 8
/-- Taille d'un bloc d'engagements, nombre de blocs. -/
abbrev bloc : Nat := 6
abbrev blocs : Nat := 7

/-- Engagements du bloc `k` d'un programme. -/
abbrev Bloc (p : Programme) (k : Nat) : Prop :=
  ∀ e ∈ (p.engagements.drop (bloc * k)).take bloc, p.Verifie e.moteur e.scenario e.propriete

theorem legers : ∀ p ∈ Programmes.tous, p.engagements.length ≤ seuil → p.EngagementsTenus := by
  decide +kernel

theorem lourds_0 : ∀ p ∈ Programmes.tous, seuil < p.engagements.length → Bloc p 0 := by decide +kernel
theorem lourds_1 : ∀ p ∈ Programmes.tous, seuil < p.engagements.length → Bloc p 1 := by decide +kernel
theorem lourds_2 : ∀ p ∈ Programmes.tous, seuil < p.engagements.length → Bloc p 2 := by decide +kernel
theorem lourds_3 : ∀ p ∈ Programmes.tous, seuil < p.engagements.length → Bloc p 3 := by decide +kernel
theorem lourds_4 : ∀ p ∈ Programmes.tous, seuil < p.engagements.length → Bloc p 4 := by decide +kernel
theorem lourds_5 : ∀ p ∈ Programmes.tous, seuil < p.engagements.length → Bloc p 5 := by decide +kernel
theorem lourds_6 : ∀ p ∈ Programmes.tous, seuil < p.engagements.length → Bloc p 6 := by decide +kernel

/-- Aucun programme ne revendique plus de `bloc × blocs` engagements (sinon,
ajouter des blocs). -/
theorem lourds_fin : ∀ p ∈ Programmes.tous, seuil < p.engagements.length →
    ∀ e ∈ p.engagements.drop (bloc * blocs), p.Verifie e.moteur e.scenario e.propriete := by
  decide +kernel

theorem tous_tenus : ∀ p ∈ Programmes.tous, p.EngagementsTenus := by
  intro p hp
  by_cases h : p.engagements.length ≤ seuil
  · exact legers p hp h
  · have h' : seuil < p.engagements.length := by omega
    refine forall_mem_blocs _ bloc blocs p.engagements (fun k hk => ?_) (lourds_fin p hp h')
    match k, hk with
    | 0, _ => exact lourds_0 p hp h'
    | 1, _ => exact lourds_1 p hp h'
    | 2, _ => exact lourds_2 p hp h'
    | 3, _ => exact lourds_3 p hp h'
    | 4, _ => exact lourds_4 p hp h'
    | 5, _ => exact lourds_5 p hp h'
    | 6, _ => exact lourds_6 p hp h'
    | k + 7, hk => exact absurd hk (by simp only [blocs]; omega)

end Engagements
