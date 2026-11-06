import Modele.Unites

/-!
# Moteurs : plusieurs lectures du même état

Un **moteur** est un jeu de règles d'interprétation des leviers et de
projection. Tous les programmes sont évalués sous tous les moteurs
(`Modeles.tous`), avec les mêmes hypothèses de scénario : la matrice du
rapport est programme × moteur × scénario × propriété.

Les moteurs partagent l'état, les leviers et les hypothèses ; ils diffèrent
par des **paramètres de mécanisme** (comment une économie de dépense agit
sur la demande, si les prélèvements pèsent sur la croissance potentielle…).
Ajouter un moteur ou en changer les règles est une modification du socle.
-/

namespace Modele

structure Moteur where
  id : String
  nom : String
  description : String
  /-- Part du multiplicateur budgétaire appliquée aux économies de dépenses,
  pm (`1000` = symétrique aux dépenses nouvelles). -/
  multiplicateurEconomiesPm : Int
  /-- Part de l'impulsion d'un prélèvement ou d'un transfert aux ménages
  transmise au bloc de demande, pm (`1000` : entière ; le bloc fixe la
  réponse propre à chaque canal, par la propension à consommer et les
  délais). -/
  multiplicateurPrelevementsPm : Int
  /-- Croissance annuelle perdue, en pb, par pb de prélèvements obligatoires
  au-dessus de leur niveau de départ, en pm (`0` : aucun effet d'offre ;
  `100` : +1 point de PO retire 0,1 point de croissance chaque année). -/
  elasticiteCroissancePoPm : Int
  /-- Part du canal du capital appliquée, pm (`0` : l'investissement public et
  le taux d'IS n'agissent sur le PIB que par la demande ; `1000` : effet
  entier sur le PIB potentiel, par le stock de capital public et par le coût
  du capital des entreprises). Pour le taux d'IS fixé par les mesures, ce
  canal remplace l'effet générique des prélèvements dans la même proportion :
  `elasticiteCroissancePoPm` ne porte que sur la part `1000 − canalCapitalPm`
  de la variation d'IS due au taux (surtaxes et cycle restent dans l'effet
  générique). -/
  canalCapitalPm : Int := 0
  /-- Résorption des effets de demande des mesures, pm par an : part de
  l'écart de PIB dû à leurs impulsions de demande (au-delà de sa part
  durable) qui se referme chaque année, quand l'activité revient vers son
  potentiel (`0` : effets permanents). -/
  resorptionDemandePm : Int := 0
  /-- Part durable de l'effet de demande des mesures, pm : ce qu'il en reste
  à long terme (`1000` : tout). -/
  partDemandeDurablePm : Int := 1000
  deriving Repr

abbrev Moteur.Valide (M : Moteur) : Prop :=
  0 ≤ M.multiplicateurEconomiesPm ∧ M.multiplicateurEconomiesPm ≤ 1000 ∧
  0 ≤ M.multiplicateurPrelevementsPm ∧ M.multiplicateurPrelevementsPm ≤ 1000 ∧
  0 ≤ M.elasticiteCroissancePoPm ∧ M.elasticiteCroissancePoPm ≤ 1000 ∧
  0 ≤ M.canalCapitalPm ∧ M.canalCapitalPm ≤ 1000 ∧
  0 ≤ M.resorptionDemandePm ∧ M.resorptionDemandePm ≤ 1000 ∧
  0 ≤ M.partDemandeDurablePm ∧ M.partDemandeDurablePm ≤ 1000

end Modele
