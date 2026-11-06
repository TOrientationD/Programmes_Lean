import Modele

/-!
# Moteurs du dépôt

Deux lectures des mêmes mesures (plus le moteur contribué « Exemple
équilibre », entre les deux). Dans les deux, les effets de demande des
mesures passent par le bloc de demande (`Modele/Demande.lean`) : chaque
canal (dépense publique, investissement, transferts et prélèvements sur les
ménages, TVA, coût du travail, impôts des entreprises) a sa réponse et ses
délais, et la boucle prix-salaires referme peu à peu l'écart de production.

* **demande** (moteur standard) : les économies pèsent autant que les
  dépenses ; aucun effet des prélèvements sur la croissance potentielle,
  pas de canal du capital ni de résorption supplémentaire.
* **offre** : une économie de dépense ne retire que la moitié de l'effet
  de demande d'une dépense équivalente ; chaque point de prélèvements
  obligatoires au-dessus de son niveau de départ retire 0,1 point de
  croissance par an (et en ajoute autant en dessous). Haut de la fourchette
  de la littérature : 10 points de PIB de dépenses ou de recettes publiques
  de plus vont de pair avec 0,5 à 1 point de croissance annuelle en moins
  dans les pays riches (Bergh et Henrekson, Journal of Economic Surveys,
  2011, revue de la littérature ; causalité discutée), −0,12 point par point
  de recettes dans l'OCDE (Afonso et Furceri, BCE, document de travail 849,
  2008, tableau 3 ; −0,05 à −0,08 dans les tests de robustesse). Le moteur
  « Exemple équilibre » retient le bas de la fourchette (0,05). Un effet en
  niveau plutôt qu'en taux est mieux étayé (Gemmell, Kneller et Sanz,
  Economic Journal, 2011) ; sur dix ans, les deux formulations restent
  proches. S'y ajoute le canal du capital
  (`canalCapitalPm`) : l'investissement public des mesures accroît le stock
  de capital public, donc le PIB potentiel (élasticité de 0,12) ; le taux
  d'IS des mesures change le coût du capital des entreprises, dont le stock
  rejoint progressivement son nouveau niveau (+0,10 % de PIB à long terme par
  point de taux en moins). Pour l'IS, ce canal remplace l'effet générique
  des prélèvements. Paramètres et sources : `Hypotheses/Economie.lean`.
  Le moteur de demande n'a pas ce canal.
  Enfin, les effets de demande des mesures s'estompent davantage
  (`resorptionDemandePm`, `partDemandeDurablePm`, appliqués dans le bloc de
  demande) : en plus de leur décrue propre au bloc (boucle prix-salaires,
  compétitivité), ils sont ramenés vers 20 % de leur niveau, la part qui s'en
  va se résorbant de 5 % par an. C'est une hypothèse du moteur d'offre : les
  repères ci-dessous décrivent le profil complet de Mésange et de ThreeME,
  que le bloc reproduit déjà en partie ; le moteur d'offre suppose un retour
  au potentiel plus rapide que ces modèles.
  Repères : pour une hausse de la dépense publique de 1 point de PIB, le PIB
  est plus haut de 0,9 point à 1 an, de 1 point à 5 ans et de 0,2 point à
  long terme dans Mésange, de 0,68, 0,90, 0,80 (10 ans), 0,46 (30 ans) et
  0,45 dans ThreeME (Trésor-Éco n° 394, juillet 2026, tableau 1 et p. 2) :
  part durable de Mésange (0,2 sur 1) ; rythme tiré de ThreeME, dont la
  part qui s'en va perd 22 % de 5 à 10 ans (calcul : ≈ 5 % par an).
  La résorption part de l'année qui suit l'impulsion (hypothèse). Le moteur
  de demande n'ajoute pas de résorption : ses effets sont ceux du bloc.

Tous les programmes sont évalués sous les deux ; les engagements précisent
leur moteur.
-/

namespace Hypotheses.Moteurs
open Modele

def demande : Moteur where
  id := "demande"
  nom := "Demande"
  description := "Effets de demande du bloc par canal (multiplicateurs, délais, boucle prix-salaires), économies et dépenses symétriques, pas d'effet d'offre des prélèvements"
  multiplicateurEconomiesPm := 1000
  multiplicateurPrelevementsPm := 1000
  elasticiteCroissancePoPm := 0

def offre : Moteur where
  id := "offre"
  nom := "Offre"
  description := "Économies à demi-multiplicateur ; +1 point de prélèvements obligatoires retire 0,1 point de croissance par an ; canal du capital (investissement public, IS) sur le PIB potentiel ; effets de demande du bloc ramenés en plus vers 20 % de leur niveau, à 5 % par an (hypothèse)"
  multiplicateurEconomiesPm := 500
  multiplicateurPrelevementsPm := 1000
  elasticiteCroissancePoPm := 100
  canalCapitalPm := 1000
  resorptionDemandePm := 50
  partDemandeDurablePm := 200

def tous : List Moteur := [demande, offre]

/-- Moteur de référence des engagements qui n'en précisent pas. -/
def standard : Moteur := demande

theorem tous_valides : ∀ M ∈ tous, M.Valide := by decide +kernel

end Hypotheses.Moteurs
