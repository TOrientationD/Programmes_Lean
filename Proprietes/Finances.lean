import Modele

namespace Proprietes
open Modele

/-- Déficit public à l'horizon sous le plafond du cadre juridique. -/
abbrev DeficitSousPlafond (H : Scenario) (_tendanciel s : Etat) : Prop :=
  10000 * s.deficit ≤ H.droit.plafondDeficitPb * s.pib

def deficit : Propriete :=
  .mk' "deficit-plafond" "Déficit sous le plafond juridique"
    "Le déficit public à l'horizon, en % du PIB, respecte le plafond du cadre juridique du scénario."
    DeficitSousPlafond

/-- Le ratio dette/PIB à l'horizon n'est pas pire qu'au tendanciel
(produit en croix, les PIB étant positifs). -/
abbrev DetteNonDegradee (_H : Scenario) (a s : Etat) : Prop :=
  s.dette * a.pib ≤ a.dette * s.pib

def dette : Propriete :=
  .mk' "dette-non-degradee" "Dette/PIB non dégradée"
    "Le ratio dette/PIB à l'horizon est inférieur ou égal à celui du tendanciel."
    DetteNonDegradee

end Proprietes

namespace Proprietes
open Modele

/-- Déficit public sous 3 % du PIB, dix ans après le départ (2035). -/
abbrev DeficitSous3En2035 (_H : Scenario) (_tendanciel s : Etat) : Prop :=
  100 * s.deficit ≤ 3 * s.pib

def deficit2035 : Propriete :=
  .mk' "deficit-3pct-2035" "Déficit sous 3 % en 2035"
    "Dix ans après le départ, le déficit public ne dépasse pas 3 % du PIB (critère de Maastricht), quel que soit le cadre juridique."
    DeficitSous3En2035 (annee := some 10)

/-- Budget à l'équilibre en 2035 : déficit nul ou excédent. -/
abbrev EquilibreEn2035 (_H : Scenario) (_tendanciel s : Etat) : Prop :=
  s.deficit ≤ 0

def equilibre2035 : Propriete :=
  .mk' "equilibre-2035" "Budget à l'équilibre en 2035"
    "Dix ans après le départ, le solde public est à l'équilibre ou en excédent (déficit ≤ 0)."
    EquilibreEn2035 (annee := some 10)

/-- Déficits (pb du PIB) de chaque année d'une trajectoire. -/
def deficits (traj : List Etat) : List Int := traj.map Etat.deficitPb

/-- Le déficit baisse strictement chaque année, à partir de l'entrée en
vigueur (comparée à l'année précédente). -/
def baisseChaqueAnnee (entree : Nat) (ds : List Int) : Bool :=
  (List.range ds.length).all fun t =>
    decide (t < max entree 1) || decide (ds.getD t 0 < ds.getD (t - 1) 0)

def deficitEnBaisse : Propriete :=
  .surTrajectoire "deficit-en-baisse" "Déficit en baisse chaque année"
    "De l'entrée en vigueur du programme à 2035, le déficit public (en % du PIB) baisse chaque année par rapport à l'année précédente."
    (fun _ entree _ traj => baisseChaqueAnnee entree (deficits traj)) (annee := some 10)

/-- Dette/PIB en 2035 au plus égale à celle de départ (produit en croix). -/
abbrev DetteStabiliseeEn2035 (H : Scenario) (_tendanciel s : Etat) : Prop :=
  s.dette * H.reference.etat.pib ≤ H.reference.etat.dette * s.pib

def dette2035 : Propriete :=
  .mk' "dette-stabilisee-2035" "Dette/PIB stabilisée en 2035"
    "Dix ans après le départ, le ratio dette/PIB n'est pas supérieur à celui de l'année de départ."
    DetteStabiliseeEn2035 (annee := some 10)

end Proprietes

namespace Proprietes
open Modele

/-- Le solde des transactions courantes, en part du PIB, n'est pas pire qu'au
tendanciel (produit en croix). -/
abbrev BalanceCouranteNonDegradee (_H : Scenario) (a s : Etat) : Prop :=
  a.balanceCourante * s.pib ≤ s.balanceCourante * a.pib

def balanceCourante : Propriete :=
  .mk' "balance-courante-non-degradee" "Balance courante non dégradée"
    "À l'horizon, le solde des transactions courantes rapporté au PIB n'est pas inférieur à celui du tendanciel."
    BalanceCouranteNonDegradee

end Proprietes
