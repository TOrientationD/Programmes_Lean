import Modele

/-!
# Lois de programmation et objectifs légaux (octobre 2026)

Lois en vigueur au 30 octobre 2026 qu'un programme doit respecter, sauf à
les modifier :
* loi de programmation militaire 2024-2030 actualisée (loi n° 2026-791 du
  16 août 2026, art. 3) : crédits de la mission Défense hors pensions de
  57,1, 63,3, 69,5, 72,6 et 75,7 Md€ de 2026 à 2030. Le tendanciel les
  contient (échéancier de `Hypotheses.Reference`, en euros 2025 indexés sur
  le déflateur du scénario ; niveaux nominaux du scénario central vérifiés
  par `Tests.Mecanismes.lpm_tendanciel`) : la propriété vérifie que la
  dépense de défense du programme ne passe sous celle du tendanciel aucune
  année de l'entrée en vigueur à 2030 (comparaison relative : avec une
  autre inflation, la trajectoire suit le déflateur du scénario) ;
* programmation pluriannuelle de l'énergie n° 3 (décret n° 2026-76 du
  12 février 2026, annexe, Hexagone continental) : capacités installées en
  2030 de 48 000 MW de photovoltaïque, 31 000 MW d'éolien terrestre,
  3 600 MW d'éolien en mer et 26 300 MW d'hydraulique (stations de
  transfert d'énergie par pompage comprises) ;
* code de l'énergie, art. L.100-4, I, 4° : les énergies renouvelables
  représentent au moins 40 % de la production d'électricité en 2030.
Non retenues : la loi de programmation des finances publiques 2023-2027
(sans « caractère opératoire » selon le Haut Conseil des finances
publiques, avis 2026-5), les lois de programmation de la justice, de
l'intérieur et de la recherche (crédits par ministère, sans correspondance
établie avec la nomenclature des fonctions du modèle), la loi sur l'aide au
développement (0,7 % du revenu national brut « en s'efforçant », sans
fonction dans le modèle).
-/

namespace Proprietes
open Modele

/-- La dépense de défense du programme ne passe sous celle du tendanciel
(loi de programmation militaire) aucune année de l'entrée en vigueur à 2030
(années 1 à 5). -/
def defenseSuitLpm (entree : Nat) (tend prog : List Etat) : Bool :=
  (List.range 6).all fun t =>
    decide (t < max entree 1) ||
      match tend[t]?, prog[t]? with
      | some a, some b => decide (a.depensesF.defense ≤ b.depensesF.defense)
      | _, _ => true

def lpm : Propriete :=
  .surTrajectoire "lpm-2024-2030" "LPM 2024-2030 : crédits de défense"
    "De l'entrée en vigueur du programme à 2030, la dépense de défense ne passe pas sous la trajectoire de la loi de programmation militaire actualisée (loi n° 2026-791 : 57,1 à 75,7 Md€ de 2026 à 2030 pour la mission Défense hors pensions)."
    (fun _ entree tend prog => defenseSuitLpm entree tend prog) (annee := some 5)

/-- Capacités installées visées en 2030 par la PPE3 (décret n° 2026-76),
MW. -/
def objectifsPpe3_2030 : ParFiliere :=
  { solaire := 48000, eolienTerrestre := 31000, eolienMer := 3600, hydraulique := 26300 }

abbrev Ppe3Capacites2030 (_H : Scenario) (_tendanciel s : Etat) : Prop :=
  objectifsPpe3_2030.solaire ≤ s.capacitesMw.solaire ∧
  objectifsPpe3_2030.eolienTerrestre ≤ s.capacitesMw.eolienTerrestre ∧
  objectifsPpe3_2030.eolienMer ≤ s.capacitesMw.eolienMer ∧
  objectifsPpe3_2030.hydraulique ≤ s.capacitesMw.hydraulique

def ppe3Capacites2030 : Propriete :=
  .mk' "ppe3-capacites-2030" "PPE3 : capacités renouvelables 2030"
    "En 2030, les capacités installées atteignent celles de la programmation pluriannuelle de l'énergie (décret n° 2026-76) : 48 000 MW de photovoltaïque, 31 000 MW d'éolien terrestre, 3 600 MW d'éolien en mer, 26 300 MW d'hydraulique."
    Ppe3Capacites2030 (annee := some 5)

/-- Production d'électricité renouvelable : hydraulique, éolien, solaire,
bioénergies. -/
def productionRenouvelable (p : ParFiliere) : Int :=
  p.hydraulique + p.eolienTerrestre + p.eolienMer + p.solaire + p.bioenergies

/-- Part minimale des renouvelables dans la production d'électricité en
2030, pm (code de l'énergie, art. L.100-4, I, 4°). -/
def partRenouvelableElectricite2030Pm : Int := 400

abbrev ElectriciteRenouvelable2030 (_H : Scenario) (_tendanciel s : Etat) : Prop :=
  partRenouvelableElectricite2030Pm * (productionRenouvelable s.productionGwh
    + s.productionGwh.nucleaire + s.productionGwh.thermique)
    ≤ 1000 * productionRenouvelable s.productionGwh

def electriciteRenouvelable2030 : Propriete :=
  .mk' "electricite-renouvelable-2030" "Code de l'énergie : 40 % d'électricité renouvelable en 2030"
    "En 2030, les énergies renouvelables (hydraulique, éolien, solaire, bioénergies) produisent au moins 40 % de l'électricité (code de l'énergie, art. L.100-4, I, 4°)."
    ElectriciteRenouvelable2030 (annee := some 5)

end Proprietes
