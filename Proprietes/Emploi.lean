import Modele

namespace Proprietes
open Modele

/-- Le taux de chômage à l'horizon n'est pas supérieur au tendanciel
(produit en croix sur les effectifs, les populations actives étant
positives : aucun arrondi au point de base près). -/
abbrev ChomageNonDegrade (_H : Scenario) (a s : Etat) : Prop :=
  (s.actifs - s.emploiTotal) * a.actifs ≤ (a.actifs - a.emploiTotal) * s.actifs

def chomage : Propriete :=
  .mk' "chomage-non-degrade" "Chômage non dégradé"
    "Le taux de chômage à l'horizon est inférieur ou égal à celui du tendanciel."
    ChomageNonDegrade

end Proprietes

namespace Proprietes
open Modele

/-- Les emplois annoncés par le programme tiennent dans sa population active :
emploi tendanciel + emplois annoncés ≤ actifs du programme × (1 − chômage
frictionnel). Un programme qui promet plus d'emplois qu'il n'y a de bras
(immigration comprise) échoue ici. -/
abbrev EmploisAnnoncesRealisables (H : Scenario) (a s : Etat) : Prop :=
  a.emploiTotal + s.emploisAnnonces ≤ s.emploiMaximal H.eco.chomageFrictionnelPb

def emploisAnnonces : Propriete :=
  .mk' "emplois-annonces-realisables" "Emplois annoncés réalisables"
    "À l'horizon, l'emploi tendanciel augmenté des emplois que le programme annonce créer ne dépasse pas la population active du programme (politique migratoire comprise) au chômage frictionnel."
    EmploisAnnoncesRealisables

end Proprietes

namespace Proprietes
open Modele

/-- Le taux d'accidents du travail rejoint la moyenne de l'Union à l'horizon. -/
abbrev AccidentsNormeUE (H : Scenario) (_a s : Etat) : Prop :=
  s.tauxAccidentsPdm ≤ H.eco.tauxAccidentsUEPdm

def accidentsTravail : Propriete :=
  .mk' "accidents-travail-norme-ue" "Accidents du travail à la norme UE"
    "À l'horizon, le taux d'accidents du travail avec arrêt pour 10 000 emplois ne dépasse pas la moyenne de l'Union européenne."
    AccidentsNormeUE

end Proprietes
