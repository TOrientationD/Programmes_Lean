import Modele.Scenario
import Modele.Idh
import Modele.Moteur
import Modele.Logement
import Modele.Automobile

/-!
# Leviers : le vocabulaire fermé des mesures

Une mesure de programme n'est **pas** une fonction arbitraire sur l'état :
c'est une liste de `Levier`, interprétés ici, une seule fois, pour tous les
programmes. C'est la garantie d'équité du dépôt : un programme ne peut pas
apporter ses propres élasticités ni son propre multiplicateur. Il choisit des
leviers et des montants ; c'est le modèle commun, sous les hypothèses du
scénario, qui en calcule les effets.

Conséquences :
* les fichiers de programmes sont de la donnée pure, lisible par des
  non-spécialistes de Lean ;
* une PR qui ne touche qu'un dossier `Programmes/X/` ne peut changer que
  l'évaluation de X ;
* ajouter un levier ou changer son interprétation est une modification du
  modèle commun, revue par les mainteneurs (CODEOWNERS).

Le modèle est un modèle agrégé, en entiers, dont chaque paramètre cite sa
source (`Hypotheses/`) et que le rétro-test confronte aux comptes de 2018 à
2025 ; il ne remplace pas une microsimulation (barèmes, ménages types), qui
pourrait émettre des certificats vérifiés ici.
-/

namespace Modele

/-- Énergie fossile évitée par une mesure de transition (levier
`transitionEcologique`). -/
inductive EnergieFossile where
  | carburant | fioul | gaz | aucune
  deriving Repr, DecidableEq, Inhabited

/-- Mesure de transition écologique décrite finement : émissions évitées,
énergie fossile qui n'est plus achetée, électricité consommée à la place,
activité intérieure qui disparaît. Voir le levier `transitionEcologique`. -/
structure MesureTransition where
  /-- Secteur d'émission. -/
  secteurGes : SecteurGes
  /-- Émissions évitées, kt CO₂e (niveau ajouté à chaque application). -/
  reductionKt : Int
  /-- Énergie fossile dont la baisse explique ces émissions (`aucune` pour
  le méthane, le protoxyde d'azote, les gaz fluorés ou une fermeture
  d'usine comptée à part). -/
  energie : EnergieFossile := .aucune
  /-- Part de l'énergie évitée remplacée par un substitut importé
  (biocarburant), pm. -/
  substitutImportePm : Int := 0
  /-- Le substitut paie les mêmes accises et la même TVA (biocarburant,
  biofioul) : pas de recette perdue. -/
  taxesMaintenues : Bool := false
  /-- Électricité consommée à la place, GWh (niveau ajouté). -/
  electriciteGwh : Int := 0
  /-- Part de l'énergie évitée qu'achetaient les administrations publiques
  (bâtiments, flottes publiques), pm. Ménages et entreprises dépensent
  ailleurs ce qu'ils n'achètent plus (effet de demande) ; les
  administrations, elles, dépensent moins, sans effet de demande : leur
  facture baisse du prix hors taxes (gaz au prix du tertiaire, fioul et
  carburant à leur valeur importée) et des taxes, qu'elles se versaient à
  elles-mêmes. -/
  partPubliquePm : Int := 0
  /-- Production intérieure qui disparaît, M€ par an (niveau ajouté), et son
  secteur. -/
  activitePerdueMeur : Int := 0
  secteurActivite : Secteur := .industrie
  /-- Part de cette production remplacée par des importations, pm. -/
  activiteImporteePm : Int := 0
  deriving Repr, DecidableEq

inductive Levier where
  /-- Dépense publique nouvelle, M€/an. -/
  | depense (montant : Int)
  /-- Économie sur la dépense, M€/an. -/
  | economie (montant : Int)
  /-- Prélèvement nouveau, rendement **statique** en M€/an (avant
  comportements). -/
  | prelevement (rendementStatique : Int)
  /-- Baisse de prélèvement, coût **statique** en M€/an. -/
  | baissePrelevement (coutStatique : Int)
  /-- Prestation forfaitaire, €/an par habitant (coût calculé sur la
  population de l'année de mise en œuvre). -/
  | prestationParHabitant (eurosParAn : Int)
  /-- Revalorisation du SMIC, pb : emplois perdus progressivement (coût du
  travail au voisinage du SMIC, `emploisParPointSmic`, moins ceux que
  sauvent les allègements en plus), allègements généraux, rémunération des
  agents publics, prélèvements sur les salaires privés, prestations et revenu
  des ménages (`smicParPoint`), proportionnels à la hausse (au-delà d'une
  dizaine de points, l'effet est sans doute plus que proportionnel :
  davantage de salariés rattrapés par le SMIC). -/
  | revalorisationSmic (hausse : Int)
  /-- SMIC brut mensuel porté à `euros` (euros de l'année d'entrée en
  vigueur) : hausse calculée sur le SMIC projeté de l'année (indexé sur les
  prix), sans effet s'il est déjà au-dessus. `agentsPublics := false` quand
  le programme relève déjà la rémunération de tous les agents d'au moins
  autant (point d'indice) : la composante publique n'est pas comptée. -/
  | smicCibleBrut (euros : Int) (agentsPublics : Bool := true)
  /-- Modification de l'âge légal, mois (positif = recul), par rapport au
  calendrier en vigueur (qui continue de s'appliquer). -/
  | ageLegal (deltaMois : Int)
  /-- Investissement de transition : réduction d'émissions (MtCO₂e) d'un
  secteur pour un coût annuel (M€). -/
  | transition (secteur : SecteurGes) (reductionMt : Int) (coutAnnuel : Int)
  /-- Comme `transition`, en kt de CO₂e (négatif : émissions en hausse). -/
  | transitionKt (secteur : SecteurGes) (reductionKt : Int) (coutAnnuel : Int)
  /-- Transition écologique décrite finement (`MesureTransition`), appliquée
  en niveau : émissions évitées ; énergie fossile évitée (carburant aux
  valeurs par voiture du sous-modèle automobile rapportées au CO₂, fioul et
  gaz aux valeurs par MWh des rénovations) : importations en moins, sauf la
  part remplacée par un substitut importé, et accises et TVA perdues, sauf
  si le substitut les paie ; électricité consommée à la place (accise et TVA
  gagnées). Effets sur l'activité : la dépense qui n'achète plus d'énergie
  importée reste dans l'économie (impulsion de demande égale aux importations
  évitées) ; les taxes perdues, nettes de celles de l'électricité, restent
  aux ménages et aux entreprises (pondérées comme un prélèvement) ; la
  production intérieure qui disparaît retire autant de PIB dans son secteur
  (emplois par la loi d'Okun et l'intensité en emploi du secteur), et sa
  part remplacée par des importations s'ajoute aux importations. Coûts
  publics : par les autres leviers de la mesure. -/
  | transitionEcologique (t : MesureTransition)
  /-- Investissement public de transition par technologie : niveaux annuels
  (M€ de l'année d'entrée en vigueur, le dernier reconduit, 0 pour arrêter)
  comme `investissementEcheancier`, mais avec la part importée de la
  technologie (`Energie.partImporteeTransitionPm`, qui part aux
  importations et ne soutient pas l'activité) et son secteur d'emploi
  (`TechnoTransition.secteur`). -/
  | investissementTransition (techno : TechnoTransition) (niveaux : List Int)
  /-- Investissement privé de transition entraîné par une mesure (centrales
  solaires ou éoliennes, équipements des entreprises), M€ par an,
  échéancier comme `investissementTransition` : impulsion de demande de sa
  part intérieure dans le secteur de la technologie, part importée aux
  importations ; aucune dépense publique. -/
  | investissementPriveTransition (techno : TechnoTransition) (niveaux : List Int)
  /-- Déclaratif : le programme porte le taux marginal maximal d'imposition
  d'un revenu (toutes impositions) à `pm` au moins (l'état garde le plus
  haut). La propriété « DDHC art. 13 : imposition non confiscatoire » le
  compare au seuil de la jurisprudence constitutionnelle. -/
  | tauxMarginalSommet (pm : Int)
  /-- Déclaratif : la mesure exige une révision de la Constitution
  (`article`, p. ex. "art. 3", et `objet`). Une révision passe par l'article
  89 (vote des deux assemblées puis référendum ou Congrès aux trois
  cinquièmes) ; la propriété « Constitution inchangée » le signale. -/
  | revisionConstitution (article objet : String)
  /-- Amende SRU automatique selon la part de logements sociaux manquants
  (barème et propriétés : `Modele/Logement.lean`). C'est un transfert des
  communes vers le FNAP et les établissements fonciers : **neutre sur le
  solde consolidé** des administrations publiques. Ses effets se lisent
  dans le panel communal du rapport et dans les contrats de la mesure. -/
  | amendeSRU (bareme : BaremeSRU)
  /-- Dépense versée **une fois**, M€ (achat, développement…) : inscrite
  dans les dépenses (et le déficit) de l'année, retirée l'année suivante,
  avec un effet de demande qui s'annule à son tour. -/
  | depensePonctuelle (montant : Int)
  /-- Remplacement de véhicules par l'État (sous-modèle :
  `Modele/Automobile.lean`). Effet macro : achat inscrit dans les dépenses
  de l'année (part importée aux importations, effet de demande sur la part
  intérieure), puis, en niveau : carburant importé évité, accises et TVA
  perdues, CO₂ évité, et décès évités selon la vignette Crit'Air des
  voitures retirées. Effet sur la balance commerciale cumulée : calculé
  par le sous-modèle et affiché dans le rapport à 5 et 10 ans. -/
  | remplacementVehicules (operation : Remplacement)
  /-- Rétrofit électrique : `vehiculesParAn` voitures thermiques du parc
  converties chaque année à l'électrique (arrêté du 13 mars 2020), avec une
  aide publique de `aideEuros` par conversion. À la différence de
  `aideAchatElectrique`, la voiture n'est pas un achat neuf : la conversion
  échappe à la limite des ventes neuves, et chaque voiture convertie est une
  voiture électrique de plus (le rétrofit n'existe presque pas à la
  tendance, pas d'aubaine). Effet macro : l'aide est une dépense de l'année
  (logement-environnement), payée aux installateurs (tertiaire marchand),
  dont la part importée du kit (`partImporteePm`) va aux importations ; la
  part payée par le ménage n'est pas comptée (comme les autres aides). Puis,
  en niveau, comme `remplacementVehicules` : parc électrique, CO₂, carburant
  importé évité, accises et TVA perdues, particules et décès évités selon la
  vignette Crit'Air (`vignetteCritAir`) des voitures converties. -/
  | retrofitElectrique (vehiculesParAn : Int) (aideEuros : Int) (partImporteePm : Int)
      (vignetteCritAir : Nat)
  /-- Prélèvement nouveau affecté à un impôt identifié, rendement statique
  M€/an (négatif pour une baisse). `prelevement` seul va dans « autres
  impôts ». -/
  | prelevementSur (impot : Impot) (rendementStatique : Int)
  /-- Dépense nouvelle, M€/an, dont l'effet sur l'emploi bénéficie à un
  secteur identifié (sinon : au prorata de tous les secteurs). -/
  | depenseSecteur (secteur : Secteur) (montant : Int)
  /-- Prêt ou prise de participation de l'État dans une entité hors
  administrations publiques (EDF, entreprise nationalisée…), M€/an,
  versé chaque année de la projection. Opération financière : la dette
  augmente, pas le déficit. L'activité financée (chantiers, emplois) se
  déroule hors des administrations publiques et n'est pas modélisée (choix
  prudent), pas plus que les remboursements au-delà de l'horizon. -/
  | pretEtat (montantAnnuel : Int)
  /-- Aide à l'achat de voitures électriques : `vehiculesParAn` véhicules
  aidés par an à `primeEuros` chacun, pour un public (`PublicAide`). Dépense
  annuelle pour tous les véhicules aidés ; seule une part est une voiture
  électrique de plus : `1 − e^(−β A)` des achats non électriques
  (`fractionReponsePm`), la part des ventes déjà électrique étant ôtée
  chaque année par la projection (aubaine), dans la limite des ventes
  neuves. Une obligation (`.obligation`, prime nulle) ajoute chaque voiture
  visée. -/
  | aideAchatElectrique (vehiculesParAn : Int) (primeEuros : Int) (cible : PublicAide := .general)
  /-- Déploiement de points de recharge publics : `bornesParAn` par an à
  `coutParBorne` € (dépense annuelle, emplois dans la construction). -/
  | deploiementBornes (bornesParAn : Int) (coutParBorne : Int)
  /-- Dépense nouvelle, M€/an, imputée à une fonction de la nomenclature
  COFOG (les emplois vont au secteur de la fonction). `depense` seul va
  dans « non ventilé ». -/
  | depenseSur (fonction : Fonction) (montant : Int)
  /-- Économie, M€/an, sur une fonction identifiée. -/
  | economieSur (fonction : Fonction) (montant : Int)
  /-- Investissement public (bâtiments, infrastructures), M€/an, imputé à une
  fonction mais dont les emplois vont à la construction. Aux moteurs qui ont
  le canal du capital, il accroît le capital public, donc le PIB potentiel
  (comme les échéanciers de construction). -/
  | investissement (fonction : Fonction) (montant : Int)
  /-- Durée du travail : variation des heures annuelles par emploi, pm
  (`-86` : 35 h → 32 h). Le PIB suit le volume d'heures à l'élasticité du
  scénario, sans effet d'Okun sur l'emploi. -/
  | dureeTravail (variationPm : Int)
  /-- Taux normal de l'impôt sur les sociétés porté à `tauxPb`. Le modèle
  applique le plancher du pilier 2 aux grands groupes (taux effectif moyen)
  et la réponse de l'assiette au taux effectif (bénéfices transférés ou
  relocalisés) ; les deux paramètres sont dans l'axe économique, communs à
  tous les programmes. -/
  | impotSocietes (tauxPb : Int)
  /-- Politique migratoire : écart de solde migratoire net, milliers par an
  (négatif = moins d'entrées). Population et population active suivent
  (part active des migrants du scénario). -/
  | migration (deltaMilliersParAn : Int)
  /-- Offre de travail : `actifs` personnes de plus dans la population active
  (seniors, parents de jeunes enfants, inactifs ramenés vers l'emploi ;
  niveau ajouté à chaque application), dont `tauxEmploiPm` trouvent un
  emploi l'année même et produisent (PIB par le volume d'heures) ; les
  autres sont chômeurs jusqu'à l'emploi d'équilibre, puis réabsorbés au
  rythme du scénario (`absorptionChomagePm`). Un effet d'aubaine se traite en
  n'inscrivant que les actifs supplémentaires. -/
  | offreTravail (actifs tauxEmploiPm : Int)
  /-- Objectif d'emplois annoncé par le programme pour cette mesure
  (personnes). Déclaratif : n'agit pas sur le modèle, mais la propriété
  « emplois annoncés réalisables » vérifie que la somme des objectifs tient
  dans la population active du programme. -/
  | annonceEmplois (emplois : Int)
  /-- Programme de qualité d'accueil touristique : `zones` zones de
  rénovation à `coutParZone` M€/an chacune (dépense d'affaires
  économiques, emplois dans la construction), qui relèvent la
  fréquentation de `hausseTouristesPm` et la dépense par touriste de
  `hausseDepensePm`. Le surcroît de recettes touristiques est une demande
  extérieure : il entre dans le PIB au prorata de son contenu en valeur
  ajoutée nationale (`partValeurAjouteeServicesPm` : 79,6 % pour les
  services marchands, Insee Analyses n° 89, 2019). -/
  | accueilTouristique (zones : Int) (coutParZone : Int) (hausseTouristesPm : Int)
      (hausseDepensePm : Int)
  /-- Robotisation accélérée des services automatisables : `gainPb` de
  moins de croissance des dépenses de fonctionnement, d'affaires
  économiques et de santé chaque année, en plus de la tendance. -/
  | robotisation (gainPb : Int)
  /-- Automatisation d'une activité (véhicules autonomes, caisses…) : gain
  de productivité `gainPibPb` sur le niveau du PIB (sans effet d'Okun) et
  `emploisSupprimes` emplois en moins. Parmi les personnes concernées,
  `sortiesActivite` quittent la population active (fin de carrière) ; les
  autres restent actives et sont réabsorbées au rythme du scénario
  (réallocation, voir `Etat.chomeursExcedentaires`). -/
  | automatisation (gainPibPb : Int) (emploisSupprimes : Int) (sortiesActivite : Int)
  /-- Suppression de `postes` emplois publics de la fonction `f`, au coût
  complet `coutParPosteEuros` par an : économie de dépense (impulsion
  pondérée par le moteur), baisse directe de l'emploi public, et réponse de
  l'emploi privé (loi d'Okun) à la seule part de la variation du PIB qui
  n'est pas la production publique supprimée. -/
  | suppressionPostes (f : Fonction) (postes : Int) (coutParPosteEuros : Int)
  /-- Création d'emplois publics dans la fonction `f`, symétrique de
  `suppressionPostes` : `postes` = effectifs supplémentaires cumulés année
  par année depuis l'entrée en vigueur (échéancier, le dernier est
  conservé), au coût complet `coutParPosteEuros` par an (euros de l'année
  d'entrée en vigueur, indexés comme la fonction). Dépense (impulsion de
  demande de la fonction), hausse directe de l'emploi public, et réponse
  de l'emploi privé (loi d'Okun) à la seule part de la variation du PIB qui
  n'est pas la production publique ajoutée. -/
  | creationPostes (f : Fonction) (postes : List Int) (coutParPosteEuros : Int)
  /-- Dépense à échéancier sur la fonction `f` : `niveaux` = montants des
  années successives, M€ de l'année d'entrée en vigueur (le premier est
  versé tout de suite, les suivants dans la projection, indexés ; le dernier
  est conservé). Des niveaux négatifs sont des économies (gel d'une
  revalorisation…). L'impulsion de demande suit le niveau pondéré : un
  niveau positif est une dépense (multiplicateur plein), un niveau négatif
  une économie (pondérée par le moteur). Voir `Echeance`. -/
  | depenseEcheancier (f : Fonction) (niveaux : List Int)
  /-- Variation du niveau des importations, M€ (substitution d'une énergie
  importée par une production nationale…) : balance commerciale, et effet
  de demande (canal extérieur) de la dépense qui se reporte sur d'autres
  biens. -/
  | importationsNiveau (deltaMeur : Int)
  /-- Norme de dépense : les fonctions pilotables (santé, affaires
  économiques, sécurité-justice, logement-environnement, culture, services
  généraux) croissent chaque année de `moderationPb` de moins que la
  tendance. L'économie de l'année passe par le multiplicateur, pondérée par
  le moteur (dans la projection). -/
  | normeDepense (moderationPb : Int)
  /-- Les normes de dépense (`normeDepense`, frein) ne retirent à la santé
  qu'au plus `pb` par an de croissance (gains d'efficience), le reste de la
  norme portant sur les autres fonctions pilotables ; le lien dépense de
  santé → espérance de vie en dépend. -/
  | plafondNormeSante (pb : Int)
  /-- Frein automatique au déficit : toute année dont le déficit dépasse
  `seuilPb` (pb du PIB), la norme de dépense des fonctions pilotables est
  durcie de `moderationPb` l'année suivante (moindre croissance, comme
  `normeDepense`, mais pour cette seule année : le niveau de dépense reste
  plus bas). Le frein ne joue que dans les scénarios où le déficit dépasse
  le seuil ; l'économie passe par le multiplicateur, pondérée par le
  moteur. Un programme n'a qu'un frein : un second levier le remplace. -/
  | freinDeficit (seuilPb : Int) (moderationPb : Int)
  /-- Placement de l'excédent : dès que le budget de l'année précédente est
  en excédent, `partPm` de cet excédent est placé, dont `partOrPm` en rachat
  d'or (jusqu'à `plafondOrMeur` cumulés) et le reste en prises de
  participation dans les entreprises (dividendes au rendement du
  portefeuille de départ). Opérations financières : la dette ne baisse pas
  d'autant, le déficit n'en est pas affecté. -/
  | placementExcedent (partPm partOrPm plafondOrMeur : Int)
  /-- Recette à échéancier : impôt (`some i`, avec effet de demande pondéré
  comme un prélèvement) ou recette non fiscale (`none`, sans effet de
  demande : péages, redevances déjà acquittés par les usagers). Niveaux
  annuels nets, M€ de l'année d'entrée en vigueur, indexés sur le PIB
  nominal ; le dernier est conservé. Voir `EcheanceRecette`. -/
  | recetteEcheancier (impot : Option Impot) (niveaux : List Int)
  /-- Prises de participation de l'État dans des entreprises, M€ par an (flux
  porté) : dette sans déficit, portefeuille et dividendes au rendement du
  portefeuille de départ. -/
  | prisesDeParticipation (montantAnnuel : Int)
  /-- Durée de cotisation requise allongée de `moisRequis` mois ; seule la part
  `partDepartsDureePm` des départs, liée à la durée, est retardée d'autant.
  Même effet par mois que `ageLegal`, au millième de mois près. -/
  | dureeCotisation (moisRequis : Int) (partDepartsDureePm : Int)
  /-- Âge légal porté à `cibleMois`. Sous l'âge courant : baisse immédiate et
  fin du calendrier légal. Au-dessus : le calendrier en vigueur est suivi
  (`rythmeMois` = 0) ou remplacé par des hausses de `rythmeMois` mois par an,
  jusqu'à la cible. Les effets sont ceux de `ageLegal`, mois par mois, par
  écart au calendrier dont la tendance du scénario tient déjà compte. -/
  | ageLegalCible (cibleMois : Int) (rythmeMois : Int)
  /-- Prévention des accidents du travail : `fondsMeur` M€/an de fonds
  publics (accompagnement des entreprises, inspection, formation) et
  baisse du taux d'accidents de `baissePm` (pour mille du taux courant).
  Les accidents évités réduisent la dépense d'indemnisation (fonction
  famille-chômage) et rendent des journées de travail au PIB. -/
  | preventionAccidents (fondsMeur : Int) (baissePm : Int)
  /-- Dette numérique : OAT tokenisées, souscrites et échangées en jetons de
  monnaie électronique euro (mécanisme « USDC »), dont les intérêts sont
  exonérés de PFU pour les particuliers résidents. La tranche monte de
  `rythmePm` de la dette par an jusqu'à `ciblePm`. Le taux servi sur la
  tranche est réduit de `capitalisationPm` × taux du PFU (part de
  l'avantage fiscal que le prix des titres capitalise). Les intérêts de la
  tranche détenus par des particuliers résidents (`partResidentsPm`) et
  qui, sans la mesure, auraient été placés en produits imposés au PFU
  (`partImposeeAvantPm`) sont autant de recettes perdues. Calcul annuel
  dans `anneeSuivante`. -/
  | detteNumerique (ciblePm rythmePm capitalisationPm partResidentsPm partImposeeAvantPm : Int)
  /-- Aide à la rénovation énergétique relevée de `bonusEuros` par rénovation
  dans le territoire `cible`. Le modèle en déduit, avec le sous-modèle
  rénovation de l'axe énergie : le coût (bonus sur les rénovations déjà
  aidées, aide entière sur les rénovations suscitées), les rénovations
  suscitées (effet d'aubaine), et chaque année les économies de fioul et de
  gaz (importations, accises, TVA, CO₂). -/
  | bonusRenovation (cible : Territoire) (bonusEuros : Int)
  /-- Programme dédié de rénovations d'ampleur : `nombreParAn` logements
  rénovés chaque année, aide de `aideEuros` par logement (dépense de
  logement et environnement, travaux adressés à la construction ; la part
  payée par les ménages n'est pas comptée). Chaque logement économise
  `economieKWh` d'énergie finale par an, répartis entre fioul et gaz selon
  les parts du territoire `cible` (sous-modèle rénovation) ; comme pour
  `bonusRenovation`, les économies de chaque année s'ajoutent à celles des
  années précédentes (importations, accises, TVA, CO₂ dans la projection).
  Les rénovations sont supposées s'ajouter à la tendance (pas d'effet
  d'aubaine). -/
  | renovationsAmpleur (cible : Territoire) (nombreParAn : Int) (aideEuros : Int) (economieKWh : Int)
  /-- Solaire sur toitures ou ombrières : `mwParAn` MW installés chaque année
  en plus de la tendance (comme `capaciteElectrique .solaire`), sans emprise
  au sol (pas d'espace consommé). -/
  | solaireToiture (mwParAn : Int)
  /-- Investissement public outre-mer, échéancier de niveaux annuels (M€ de
  l'année d'entrée en vigueur ; le dernier niveau est reconduit, 0 pour
  arrêter). Emplois dans la construction ; la part importée de la dépense,
  plus forte qu'en métropole (axe économique), ne soutient pas l'activité
  intérieure et accroît les importations. -/
  | investissementOutreMer (fonction : Fonction) (niveaux : List Int)
  /-- Investissement public échelonné (bâtiments, équipements) : niveaux
  annuels en M€ de l'année d'entrée en vigueur (le dernier niveau est
  reconduit, 0 pour arrêter), imputés à une fonction, emplois dans la
  construction ; l'arrêt des travaux retire ces emplois. -/
  | investissementEcheancier (fonction : Fonction) (niveaux : List Int)
  /-- Raccordement de `foyers` foyers d'outre-mer au réseau électrique : leur
  consommation est produite au coût des zones non interconnectées et le
  tarif péréqué n'en couvre qu'une partie ; le surcoût, financé par les
  charges de service public de l'énergie, est une dépense annuelle
  (affaires économiques). -/
  | raccordementZni (foyers : Int)
  /-- Rémunération supplémentaire d'agents publics déjà en poste (primes,
  traitement, heures supplémentaires), échéancier de niveaux bruts annuels
  (M€ de l'année d'entrée en vigueur ; négatif pour une baisse). Le modèle
  en retire les prélèvements qui reviennent aussitôt (CSG-CRDS, cotisations,
  impôt sur le revenu selon la nature) ; le net soutient la consommation
  (effet de demande d'un transfert), sans production ni emplois publics en
  plus. -/
  | remunerationPublique (nature : NatureRemuneration) (fonction : Fonction) (niveaux : List Int)
  /-- Apurement de `partPm` du stock de passifs implicites du type `type`
  (« dettes cachées » : heures supplémentaires non payées…), payé l'année
  même comme des heures supplémentaires (dépense et déficit de l'année). -/
  | apurementPassifs (type : TypePassif) (fonction : Fonction) (partPm : Int)
  /-- Résorption d'un retard d'entretien (`type`, en pratique
  `entretienInfrastructures`) : `montant` M€ de travaux l'année même,
  investissement d'une année (emplois dans la construction, capital public
  au moteur d'offre), retirés du stock de passifs ; à répéter chaque année
  (`repetitions`). -/
  | entretienPassifs (type : TypePassif) (fonction : Fonction) (montant : Int)
  /-- Paiement au fil de l'eau de `partPm` des nouveaux passifs implicites
  du type `type` (heures supplémentaires payées l'année où elles sont
  faites) : dépense permanente, et le stock cesse de croître d'autant. -/
  | paiementFluxPassifs (type : TypePassif) (fonction : Fonction) (partPm : Int)
  /-- Taxe environnementale sur une activité (kérosène des vols intérieurs,
  poids lourds…) : rendement statique `rendementStatique` M€/an sur
  l'impôt `impot`, hausse du coût de l'activité `hausseCoutPm`, émissions
  de l'activité `emissionsViseesKt`. Le modèle applique l'élasticité-prix
  de l'activité (axe énergie) : l'activité, donc ses émissions et
  l'assiette de la taxe, reculent de élasticité × hausse. -/
  | taxeEnvironnementale (activite : ActiviteTaxee) (impot : Impot) (emissionsViseesKt : Int)
      (hausseCoutPm : Int) (rendementStatique : Int)
  /-- Allègements généraux de cotisations patronales sur la tranche de
  salaire `tranche` relevés de `montant` M€/an (négatif : réduits, le coût
  du travail de la tranche monte). Les cotisations varient d'autant ;
  l'emploi de la tranche répond au coût du travail selon l'élasticité de
  l'axe économique, progressivement (`ajustementCoutTravailPm`), et produit
  (volume d'heures) ; le montant passe aussi par le canal du coût du travail
  du bloc de demande (marges, prix, compétitivité). Une baisse ne peut dépasser
  les allègements en vigueur sur la tranche. -/
  | allegementsCotisations (tranche : TrancheSalaire) (montant : Int)
  /-- Allègements généraux réduits de `montant` M€/an, répartis entre les
  tranches au prorata des allègements en vigueur (réduction sans ciblage :
  aujourd'hui surtout au voisinage du SMIC). Effets de
  `allegementsCotisations` sur chaque tranche. -/
  | reductionAllegements (montant : Int)
  /-- Recentrage à coût constant : les parts `partIntermediairePm` (1,6 à
  2,5 SMIC) et `partHautPm` (au-delà) des allègements en vigueur sont
  supprimées et reversées aux salaires de 1 à 1,6 SMIC. Effets de
  `allegementsCotisations` sur chaque tranche. -/
  | recentrageAllegements (partIntermediairePm : Int) (partHautPm : Int)
  /-- Accompagnement des demandeurs d'emploi : `conseillers` conseillers de
  plus au service public de l'emploi, à `coutParConseillerEuros` € par an
  chacun (dépense de la fonction famille-chômage). Le chômage d'équilibre
  baisse de `chomeursEvitesParConseiller` (axe économique) par conseiller ;
  l'écart se résorbe au rythme du scénario (`absorptionChomagePm`). -/
  | accompagnementDemandeurs (conseillers : Int) (coutParConseillerEuros : Int)
  /-- Prix du tabac relevé de `hausseprixPm` par une hausse des accises : la
  consommation baisse selon l'élasticité-prix (axe économique), les accises
  en face (fuite fiscale comprise : achats transfrontaliers) ; les décès
  attribuables au tabac baissent comme la consommation, au rythme du délai
  d'effet (axe démographique). -/
  | prixTabac (hausseprixPm : Int)
  /-- Prix minimum de l'alcool, `centimesParVerre` par verre standard : les
  décès attribuables à l'alcool baissent selon l'axe économique (évaluation
  française), au rythme du délai d'effet ; sans effet net sur les finances
  publiques (la hausse de prix va aux vendeurs). -/
  | prixMinimumAlcool (centimesParVerre : Int)
  /-- Dépistage organisé du cancer colorectal porté à une participation de
  `participationCiblePm` : coût des dépistages supplémentaires (santé), et
  décès évités par point de participation (axe économique). -/
  | depistageColorectal (participationCiblePm : Int)
  /-- Décès annuels attribuables à la pollution de l'air ajoutés (`decesParAn`
  positif : une règle qui améliorait l'air est supprimée) ou retirés
  (négatif), en niveau ; les années de vie suivent (IDH). -/
  | pollutionAir (decesParAn : Int)
  /-- Baisse visée des décès d'une cause suivie (`CauseDeces`), pm des décès
  attribuables de départ, atteinte au rythme du délai d'effet de la cause
  (IDH par les années de vie) ; le coût passe par les autres leviers. -/
  | baisseMortalite (cause : CauseDeces) (pm : Int)
  /-- Taux de scolarisation de chaque âge de 18 à 24 ans relevé de
  `hausseTauxPm` (places, bourses) : coût (dépense par étudiant) et durée
  attendue de scolarisation de l'IDH. -/
  | scolarisationJeunes (hausseTauxPm : Int)
  /-- Capacités de production d'électricité de la filière `f` installées
  chaque année en plus de la tendance (en moins si négatif), MW/an, à partir
  de l'année suivante. Effet physique seulement (production, surfaces) : le
  coût et le soutien public éventuels passent par les autres leviers de la
  mesure. -/
  | capaciteElectrique (f : Filiere) (mwParAn : Int)
  /-- Consommation d'électricité ajoutée par l'électrification d'usages,
  GWh/an (niveau, dès l'année). -/
  | consommationElectrique (gwhParAn : Int)
  /-- Priorité au nucléaire : la production que ni la consommation ni le
  solde exportateur maximal n'absorbent est écrêtée sur le solaire, puis
  l'éolien terrestre, puis l'éolien en mer, avant toute modulation du
  nucléaire. L'électricité écrêtée n'est pas produite donc pas payée
  (hypothèse : les contrats de soutien récents ne rémunèrent pas les heures
  de prix négatifs) ; le coût du mix baisse, la part renouvelable aussi. -/
  | prioriteNucleaire
  /-- Stockage d'électricité (station de transfert d'énergie par pompage,
  souterraine ou non ; batteries) : `mw` MW de puissance, `heures` heures de
  stockage, `cyclesParAn` cycles complets par an, rendement aller-retour
  `rendementPm`. L'électricité restituée remplace la production thermique
  fossile de pointe (dans la limite de celle-ci) et évite `gCo2ParKwh` g de
  CO₂ par kWh dans le secteur de l'énergie ; la charge est prise sur le
  surplus que le modèle retire au nucléaire (la production nucléaire
  augmente d'autant), et les pertes (charge moins restitution) s'ajoutent à
  la consommation. Le modèle, annuel, ne représente pas l'écrêtement du
  solaire que le stockage éviterait. Le coût passe par les autres leviers
  de la mesure. -/
  | stockageElectrique (mw : Int) (heures : Int) (cyclesParAn : Int) (rendementPm : Int)
      (gCo2ParKwh : Int)
  /-- Régime de zéro artificialisation nette : écart de la consommation
  d'espaces à la trajectoire ZAN, vers celle de la décennie d'avant la loi,
  pm (0 : ZAN maintenu ; 1000 : abrogé). -/
  | regimeZan (ecartPm : Int)
  /-- Surfaces consommées par la mesure, destination `d`, ha, année par
  année à partir de l'année suivante (échéancier : par exemple une ligne
  nouvelle, longueur × emprise par km, répartie sur les années de
  travaux). Sous le ZAN, elles s'imputent sur l'enveloppe. -/
  | artificialisation (d : Destination) (haParAnnee : List Int)
  /-- Surfaces consommées hors de l'enveloppe du ZAN, par une exemption
  légale que crée la mesure (zones industrielles…), destination `d`, ha,
  année par année à partir de l'année suivante : elles s'ajoutent à la
  consommation d'espaces sans évincer d'autres usages et sortent du décompte
  de l'enveloppe. -/
  | artificialisationHorsZan (d : Destination) (haParAnnee : List Int)
  /-- Pompes à chaleur installées gratuitement, `nombreParAn` chaque année,
  à `coutEuros` € l'une, à la place de chaudières au fioul ou au gaz du
  territoire `cible` (paramètres : `Energie.pac`). Hors effet d'aubaine :
  fioul et gaz économisés (importations, accises, TVA, CO₂, comme les
  rénovations), électricité consommée (accise, TVA), logements qui quittent
  le gaz (coûts de réseau évités, reversés au financement de la mesure). Les
  travaux sont adressés à la construction ; le coût des PAC qui auraient été
  installées sans la mesure est un transfert aux ménages. -/
  | pompesAChaleur (cible : Territoire) (nombreParAn : Int) (coutEuros : Int)
  /-- Emplois aidés : `contrats` contrats en cours en permanence dans le
  `secteur`, aide de `aideEuros` € par contrat et par an (dépense des
  affaires économiques) ; emplois nets de l'effet d'aubaine `aubainePm`,
  qui produisent (PIB par le volume d'heures). -/
  | emploisAides (secteur : Secteur) (contrats : Int) (aideEuros : Int) (aubainePm : Int)
  /-- Emplois privés attirés dans le `secteur` par la mesure (implantations
  industrielles), hypothèse du programme à sourcer : ils produisent (PIB par
  le volume d'heures), et leur production est exportée ou remplace des
  importations. -/
  | implantations (secteur : Secteur) (emplois : Int)
  deriving Repr, DecidableEq

/-- Ajoute `d` emplois (personnes, signé) au secteur `cible`, ou au prorata
des secteurs. Une hausse ne fait jamais passer le chômage sous son niveau
frictionnel. -/
def ajouterEmploi (H : Scenario) (cible : Option Secteur) (d : Int) (s : Etat) : Etat :=
  let plafond := s.actifs * (10000 - H.eco.chomageFrictionnelPb) / 10000
  let d' := if 0 < d then min d (max (plafond - s.emploiTotal) 0) else d
  { s with emploi := s.emploi.repartir d' cible }

/-- Choc de demande de travail de `d` emplois (signé), au bénéfice de
`cible`. Effet de flexion : la population active varie de
`flexion / (1000 + flexion)` de ces emplois (des inactifs prennent une
partie des emplois créés ; une partie des emplois détruits pousse à
l'inactivité), le reste passe par le chômage. -/
def chocDemandeTravail (H : Scenario) (cible : Option Secteur) (d : Int) (s : Etat) : Etat :=
  let dActifs := d * H.eco.flexionPm / (1000 + H.eco.flexionPm)
  ajouterEmploi H cible d { s with actifs := s.actifs + dActifs }

/-- Emplois correspondant à `dChomeurs` chômeurs de moins (la loi d'Okun est
exprimée en chômage) : `(1000 + flexion)/1000` emploi par chômeur. -/
def emploisPourChomeurs (H : Scenario) (dChomeurs : Int) : Int :=
  dChomeurs * (1000 + H.eco.flexionPm) / 1000

/-- Variation de PIB due à la demande, et des recettes qui en découlent, sans
effet sur l'emploi : un choc de demande est cyclique, chaque prélèvement
réagit selon son élasticité à l'écart de production ; les recettes non
fiscales n'en dépendent pas. -/
def chocPibSeul (H : Scenario) (dPib : Int) (s : Etat) : Etat :=
  { s with
    impots := s.impots.plus (s.impots.variationCycle dPib s.pib H.eco.elasticiteCycliquePm)
    -- la consommation des ménages (assiette de la TVA) suit l'activité ;
    -- l'emploi, donc la masse salariale, suit par `chocPib`
    consommationMenages := s.consommationMenages
      + (if s.pib = 0 then 0 else s.consommationMenages * dPib / s.pib)
    pib := s.pib + dPib
    importations := s.importations + appliquerPm dPib H.eco.contenuImportDemandePm }

/-- Choc sur le niveau du PIB (M€) : recettes au prorata ; le chômage baisse
de `okun × dPib / PIB` (loi d'Okun), converti en emplois avec l'effet de
flexion, au bénéfice de `cible`. -/
def chocPib (H : Scenario) (cible : Option Secteur) (dPib : Int) (s : Etat) : Etat :=
  -- une demande adressée à un secteur y crée des emplois selon son intensité
  -- en main-d'œuvre relative (construction, non marchand > industrie)
  let intensite := match cible with
    | some sec => H.eco.intensiteEmploiSecteurPm.get sec
    | none => 1000
  let dEmploi := if s.pib = 0 then 0
    else s.actifs * dPib * H.eco.okunPm * (1000 + H.eco.flexionPm) * intensite / (s.pib * 1000000000)
  chocDemandeTravail H cible dEmploi (chocPibSeul H dPib s)

/-- Impulsion budgétaire signée (M€, positive quand elle soutient la
demande) passant par le canal `canal` : elle s'ajoute aux chocs du bloc de
demande (`Modele/Demande.lean`), qui en calcule l'effet sur le PIB, l'emploi
et les prix, l'année même et les suivantes (`bouclerDemande`). Le secteur
`cible` reçoit la part correspondante des emplois créés ou détruits. -/
def effetDemande (_H : Scenario) (canal : Canal) (cible : Option Secteur) (impulsion : Int)
    (s : Etat) : Etat :=
  let ppm := if s.pib = 0 then 0 else impulsion * 1000000 / s.pib
  let cibles := match cible with
    | some sec => (sec, Int.natAbs ppm) :: s.demande.cibles
    | none => s.demande.cibles
  let d := s.demande
  { s with demande := { d with chocs := d.chocs.ajouter canal ppm, cibles := cibles,
                               totalPpm := d.totalPpm + Int.natAbs ppm } }

/-- Rend effectifs dans l'état les écarts du bloc de demande de l'année
(`s.demande.ecarts`), par différence avec ceux déjà appliqués : PIB et recettes
(chaque prélèvement selon son élasticité au cycle), consommation des
ménages, exportations et importations, emploi (réparti entre les secteurs
visés par les chocs, le reste au prorata), écart de demande du solde
structurel. Les écarts de prix et de salaires entrent dans l'inflation de
l'année suivante (`anneeSuivante`). -/
def appliquerEcartsDemande (H : Scenario) (s : Etat) : Etat :=
  let P := H.eco.demande
  let e := s.demande.ecarts
  let a := s.demande.appliques
  let enMeur (ppm : Int) : Int := ppm * s.pib / 1000000
  let dPib := enMeur (e.pib - a.pib)
  let dConso := enMeur (e.consommation P - a.consommation P)
  let dExport := enMeur (e.exportations - a.exportations)
  let dImport := enMeur (e.importations - a.importations)
  let dEmploi := (e.emploi - a.emploi) * s.emploiTotal / 1000000
  let s₁ : Etat := { s with
    impots := s.impots.plus (s.impots.variationCycle dPib s.pib H.eco.elasticiteCycliquePm)
    consommationMenages := s.consommationMenages + dConso
    pib := s.pib + dPib
    exportations := s.exportations + dExport
    importations := s.importations + dImport }
  -- emplois : part de chaque secteur visé (chocs en valeur absolue), le reste
  -- au prorata de l'emploi
  let total := s.demande.totalPpm
  let parts := Secteur.tous.map fun sec =>
    (sec, if total = 0 then 0
      else dEmploi * ((s.demande.cibles.filter (·.1 = sec)).foldl (fun acc x => acc + x.2) 0) / total)
  let s₂ := parts.foldl (fun st (sec, d) => if d = 0 then st else chocDemandeTravail H (some sec) d st) s₁
  let reste := dEmploi - parts.foldl (fun acc x => acc + x.2) 0
  let s₃ := chocDemandeTravail H none reste s₂
  { s₃ with demande := { s₃.demande with appliques := e }, ecartDemandeMeur := enMeur e.pib }

/-- Résout le bloc de demande pour l'année en cours (chocs cumulés de l'état,
écarts des deux années précédentes) et rend ses écarts effectifs. -/
def bouclerDemande (M : Moteur) (H : Scenario) (s : Etat) : Etat :=
  let P := H.eco.demande
  let mult := if P.multiplicateurReferencePm = 0 then 1000
    else H.eco.multiplicateurPm * 1000 / P.multiplicateurReferencePm
  let taux := if s.actifs = 0 then 0 else s.emploiTotal * 1000 / s.actifs
  let e := resoudre P mult taux H.eco.flexionPm M.resorptionDemandePm M.partDemandeDurablePm
    s.demande.prec s.demande.prec2 s.demande.chocs s.demande.chocsPrec
  appliquerEcartsDemande H { s with demande := { s.demande with ecarts := e } }

/-- Stabilisateur automatique : la dépense d'indemnisation du chômage suit le
nombre de chômeurs (écart à ceux que les dépenses inscrites couvrent déjà),
à `coutParChomeurEuros` par chômeur (euros de départ, indexés sur le PIB
nominal), avec l'effet de demande d'un transfert aux ménages. -/
def stabilisateurChomage (M : Moteur) (H : Scenario) (s : Etat) : Etat :=
  let chomeurs := s.actifs - s.emploiTotal
  let d := if H.reference.etat.pib = 0 then 0
    else (chomeurs - s.chomeursComptes) * H.eco.coutParChomeurEuros * s.pib
      / (H.reference.etat.pib * 1000000)
  effetDemande H .transferts none (appliquerPm d M.multiplicateurPrelevementsPm)
    { s with depensesF := s.depensesF.ajouter .famille d, chomeursComptes := chomeurs }

/-- Part des achats non électriques qu'une aide de `aideEuros` rend
électriques, pm : `1 − e^(−β A)`, β en pm par k€ (forme réduite calée,
voir `Hypotheses/Energie.lean`). L'exponentielle est approchée par l'inverse du développement de
`e^x` à l'ordre 4 (écart < 2 % jusqu'à `x = 1,5`). -/
def fractionReponsePm (betaPmParKeur aideEuros : Int) : Int :=
  let x := max 0 (betaPmParKeur * aideEuros / 1000)
  let ex := 1000 + x + x * x / 2000 + x * x * x / 6000000 + x * x * x * x / 24000000000
  1000 - 1000000 / ex

theorem fractionReponse_valeurs :
    fractionReponsePm 55 4000 = 197 ∧ fractionReponsePm 115 6000 = 498 ∧ fractionReponsePm 55 0 = 0 := by
  decide

/-- Poids de l'impulsion d'une dépense de la fonction `f` dans son canal du
bloc de demande : son incidence, rapportée à celle de la fonction de
référence du canal (`Canal.fonctionReference`) ; le canal des transferts
étant calé sur les variantes de pensions, une dépense de retraites y entre à
poids plein. -/
def poidsDepense (H : Scenario) (f : Fonction) : Int :=
  match f.canal.fonctionReference with
  | some r =>
      let ref := H.eco.incidenceDepensePm.get r
      if ref = 0 then 1000 else H.eco.incidenceDepensePm.get f * 1000 / ref
  | none => H.eco.incidenceDepensePm.get f

/-- Dépense nouvelle sur une fonction (partagée par plusieurs leviers). -/
def appliquerDepense (H : Scenario) (cible : Option Secteur) (f : Fonction) (montant : Int)
    (s : Etat) : Etat :=
  effetDemande H f.canal cible (appliquerPm montant (poidsDepense H f))
    { s with depensesF := s.depensesF.ajouter f montant }

/-- Création (ou, si négatifs, suppression) de `postes` emplois publics
pour une dépense de `depense` M€ dans la fonction `f` : les emplois publics
s'ajoutent un pour un ; leur rémunération est une demande publique (canal
`emploisPublics`), à laquelle l'emploi marchand répond par le bloc de
demande (symétrique de `suppressionPostes`). -/
def effetCreationPostes (H : Scenario) (f : Fonction) (depense postes : Int) (s : Etat) : Etat :=
  effetDemande H .emploisPublics none (appliquerPm depense (H.eco.incidenceDepensePm.get f))
    (chocDemandeTravail H (some .tertiaireNonMarchand) postes
      { s with depensesF := s.depensesF.ajouter f depense })

/-- Investissement public imputé à la fonction `f` : emplois dans la
construction, effet sur la demande de l'investissement. -/
def appliquerInvestissement (H : Scenario) (f : Fonction) (montant : Int) (s : Etat) : Etat :=
  effetDemande H .investissement (some .construction) montant
    { s with depensesF := s.depensesF.ajouter f montant }

/-- Poids de l'impulsion de demande d'une dépense à échéancier : entier pour
un investissement (construction), celui de sa fonction sinon. -/
def poidsEcheance (H : Scenario) (e : Echeance) : Int :=
  if e.secteur = some .construction then 1000
  else poidsDepense H e.fonction

/-- Canal de demande d'une dépense à échéancier : investissement (sa part
intérieure seulement quand la part importée est inscrite à part), privé ou
adressé à la construction, sinon celui de sa fonction. -/
def Echeance.canal (e : Echeance) : Canal :=
  if e.partInterieurePm < 1000 then .investissementInterieur
  else if e.privee ∨ e.secteur = some .construction then .investissement else e.fonction.canal

/-- Économie de dépense : l'impulsion négative est pondérée par le moteur et
la nature de la dépense ; les emplois perdus le sont dans le secteur de la
fonction. -/
def appliquerEconomie (M : Moteur) (H : Scenario) (f : Fonction) (montant : Int) (s : Etat) : Etat :=
  -- les emplois perdus le sont dans le secteur de la fonction, comme ceux
  -- qu'une dépense de même nature crée (intensité en emplois symétrique)
  effetDemande H f.canal f.secteur (-(appliquerPm (appliquerPm montant M.multiplicateurEconomiesPm)
      (poidsDepense H f)))
    { s with depensesF := s.depensesF.ajouter f (-montant) }

/-- Choc d'offre de travail : variation relative `num / den` du volume
d'heures → PIB à l'élasticité du scénario, recettes au prorata, sans effet
d'Okun. Une seule division : pas de perte de précision pour les petits chocs. -/
def chocHeuresRatio (H : Scenario) (num den : Int) (s : Etat) : Etat :=
  if den = 0 then s else
  let dPib := s.pib * num * H.eco.elasticitePibHeuresPm / (den * 1000)
  let dRecettes := if s.pib = 0 then 0 else dPib * s.recettes / s.pib
  { s.ajouterRecettesProrata dRecettes with pib := s.pib + dPib }

/-- Variation du volume d'heures de `variationPm` pour mille. -/
def chocHeures (H : Scenario) (variationPm : Int) (s : Etat) : Etat :=
  chocHeuresRatio H variationPm 1000 s

/-- Variation du PIB induite par `dEmploi` personnes en emploi de plus (ou
de moins), à durée du travail inchangée. -/
def chocEmploi (H : Scenario) (dEmploi : Int) (s : Etat) : Etat :=
  chocHeuresRatio H dEmploi s.emploiTotal s

/-- Poids de l'impulsion de demande d'un prélèvement sur l'impôt `i`, pm :
part transmise par le moteur, puis incidence de l'impôt relativement à
l'impôt de référence de son canal (impôt sur le revenu, TVA, impôt sur les
sociétés : 1 000 ‰). -/
def poidsPrelevement (M : Moteur) (H : Scenario) (i : Impot) : Int :=
  let ref := H.eco.incidencePrelevementPm.get i.canal.impotReference
  if ref = 0 then 0
  else M.multiplicateurPrelevementsPm * H.eco.incidencePrelevementPm.get i / ref

/-- Fuite fiscale de l'impôt `i`, pm : la fuite moyenne du scénario, pondérée
par la fuite relative de l'impôt, plafonnée à 1 000. -/
def fuiteImpot (H : Scenario) (i : Impot) : Int :=
  min 1000 (H.eco.fuiteFiscalePm * H.eco.fuiteFiscaleRelativePm.get i / 1000)

/-- Prélèvement nouveau (rendement statique `r`, négatif pour une baisse) sur
l'impôt `i`. Le rendement est réduit de la fuite fiscale de l'impôt ;
l'impulsion de demande, pondérée par le moteur et l'incidence de l'impôt,
passe par le canal de l'impôt. -/
def appliquerPrelevement (M : Moteur) (H : Scenario) (i : Impot) (r : Int) (s : Etat) : Etat :=
  let rendement := r - appliquerPm r (fuiteImpot H i)
  effetDemande H i.canal none (-(appliquerPm r (poidsPrelevement M H i)))
    { s with impots := s.impots.ajouter i rendement }

/-- Recul de l'âge moyen de départ de `moisPm` millièmes de mois : actifs
supplémentaires en emploi au taux observé lors du report de 2010 (l'écart à
l'emploi d'équilibre est résorbé dans la projection), pensions économisées,
PIB par le volume d'heures. -/
def reculDepart (H : Scenario) (moisPm : Int) (s : Etat) : Etat :=
  let dActifs := moisPm * H.eco.actifsParMoisAgeLegal / 1000
  let dEmploi := appliquerPm dActifs H.eco.tauxEmploiSeniorsMaintenusPm
  let dEquilibre := if s.actifs = 0 then 0 else dActifs * s.emploiTotal / s.actifs
  chocEmploi H dEmploi
    { s with
      ageLegalMois := s.ageLegalMois + moisPm / 1000
      depensesF := s.depensesF.ajouter .retraites (-(moisPm * H.eco.economieParMoisRetraite / 1000))
      actifs := s.actifs + dActifs
      emploi := s.emploi.repartir dEmploi none
      chomeursExcedentaires := s.chomeursExcedentaires + (dEquilibre - dEmploi) }

/-- Taux effectif moyen de l'IS pour un taux normal `taux` : les groupes du
pilier 2 (part `partISPilier2Pm` de l'IS) restent imposés au taux minimal
(directive (UE) 2022/2523, impôt complémentaire national depuis la loi de
finances pour 2024). -/
def tauxISEffectif (H : Scenario) (taux : Int) : Int :=
  ((1000 - H.eco.partISPilier2Pm) * taux
    + H.eco.partISPilier2Pm * max taux H.eco.tauxMinimumPilier2Pb) / 1000

/-- Part d'une dépense dont le contenu en importations est `contenuPm`
adressée à la production intérieure, pm : la part importée est inscrite par
le levier, la part intérieure passe par le canal `investissementInterieur`
du bloc de demande (sans nouvelle fuite d'importations). -/
def partInterieure (_H : Scenario) (contenuPm : Int) : Int :=
  max 0 (min 1000 (1000 - contenuPm))

/-- Investissement outre-mer : contenu importé de l'axe économique. -/
def partInterieureOutreMer (H : Scenario) : Int :=
  partInterieure H H.eco.contenuImportOutreMerPm

/-- Dépense d'une seule année (achat) : inscrite dans les dépenses de l'année
et retirée l'année suivante (échéancier `[0]`), avec un effet de demande
symétrique ; la part importée va aux importations. -/
def depenseUneAnnee (H : Scenario) (f : Fonction) (secteur : Option Secteur) (part montant : Int)
    (s : Etat) : Etat :=
  let e : Echeance := { fonction := f, restants := [0], niveau := montant, indice := 10000,
                        secteur := secteur, partInterieurePm := part }
  effetDemande H e.canal secteur (appliquerPm (montant * part / 1000) (poidsEcheance H e))
    { s with echeances := s.echeances ++ [e]
             depensesF := s.depensesF.ajouter f montant
             importations := s.importations + montant * (1000 - part) / 1000 }

/-- `nombre` voitures thermiques du parc deviennent électriques (achat de
remplacement ou conversion) : la dépense `depense` de l'opération est
inscrite, puis, en niveau, CO₂ évité, carburant importé en moins, accises
et TVA perdues, parc électrique, particules et décès évités selon la
vignette Crit'Air des voitures retirées ou converties ; le ménage dépense
ailleurs ce qu'il ne paie plus en carburant (importations et taxes), ce qui
passe par le bloc de demande. -/
def basculeElectrique (M : Moteur) (H : Scenario) (nombre : Int) (vignette : Nat)
    (depense : Etat → Etat) (s : Etat) : Etat :=
  let pm := (H.energie.pmRelatifCritAirPm.getD vignette 1000)
  let s : Etat := depense
    (s.reduireEmissions .transports (nombre * H.energie.co2EviteParVehiculeKg / 1000000))
  { s with importations := s.importations
             - nombre * H.energie.gainCommercialParVehiculeEuros / 1000000
           impots := (s.impots.ajouter .accisesEnergie
               (-(nombre * H.energie.accisesParVehiculeEuros / 1000000)))
             |>.ajouter .tva (-(nombre * H.energie.tvaParVehiculeEuros / 1000000))
           parcElectriqueMilliers := s.parcElectriqueMilliers + nombre / 1000
           decesPollutionAir := s.decesPollutionAir
             - nombre * H.energie.decesEvitesParMillionVehicules * pm / 1000000000
           anneesVieGagneesParAn := s.anneesVieGagneesParAn
             + nombre * H.energie.decesEvitesParMillionVehicules * pm / 1000000000
               * H.demo.anneesVieParDecesPollutionDixiemes / 10 }
  -- le ménage dépense ailleurs ce qu'il n'achète plus en carburant : moins
  -- d'importations, moins d'accises et de TVA payées (bloc de demande)
  |> effetDemande H .exterieur none (nombre * H.energie.gainCommercialParVehiculeEuros / 1000000)
  |> effetDemande H .taxesConsommation none
      (appliquerPm (nombre * (H.energie.accisesParVehiculeEuros + H.energie.tvaParVehiculeEuros) / 1000000)
        M.multiplicateurPrelevementsPm)

/-- Prélèvements qui reviennent sur une rémunération publique brute `brut`,
selon sa nature : (CSG-CRDS, cotisations salariales, impôt sur le revenu). -/
def retoursRemuneration (H : Scenario) (nature : NatureRemuneration) (brut : Int) : Int × Int × Int :=
  let csg := appliquerPm brut H.eco.tauxCsgCrdsRemunerationPm
  match nature with
  | .traitement => (csg, appliquerPm brut H.eco.tauxCotisationsTraitementPm,
      appliquerPm brut H.eco.tauxIrRemunerationPm)
  | .primes => (csg, appliquerPm brut H.eco.tauxCotisationsPrimesPm,
      appliquerPm brut H.eco.tauxIrRemunerationPm)
  | .heuresSup => (csg, appliquerPm brut H.eco.tauxCotisationsHeuresSupPm, 0)

/-- Effets d'une variation `brut` de rémunération publique, hors inscription
de la dépense : prélèvements qui en reviennent, et effet de demande du
revenu net (pondéré comme un transfert aux ménages). -/
def effetRemuneration (M : Moteur) (H : Scenario) (nature : NatureRemuneration) (brut : Int)
    (s : Etat) : Etat :=
  let (csg, cot, ir) := retoursRemuneration H nature brut
  effetDemande H .transferts none (appliquerPm (brut - csg - cot - ir) M.multiplicateurPrelevementsPm)
    { s with impots := ((s.impots.ajouter .csgCrds csg).ajouter .cotisations cot).ajouter .ir ir }

/-- Rémunération publique d'une seule année (apurement d'un arriéré) :
inscrite dans les dépenses de l'année, retirée l'année suivante. -/
def remunerationUneAnnee (M : Moteur) (H : Scenario) (nature : NatureRemuneration) (f : Fonction)
    (montant : Int) (s : Etat) : Etat :=
  let e : Echeance := { fonction := f, restants := [0], niveau := montant, indice := 10000,
                        remuneration := some nature }
  effetRemuneration M H nature montant
    { s with echeances := s.echeances ++ [e], depensesF := s.depensesF.ajouter f montant }

/-- Variation de `m` M€ des allègements généraux de la tranche `t` (négatif :
réduction, bornée par les allègements en vigueur sur la tranche) :
cotisations, emplois visés (élasticité × variation relative du coût du
travail × emploi de la tranche, à coût du travail de l'année de départ
ramené au PIB courant), ajoutés progressivement par la projection ; le
montant entre dans le canal du coût du travail du bloc de demande (marges,
prix, compétitivité). -/
def varierAllegements (M : Moteur) (H : Scenario) (t : TrancheSalaire) (m : Int) (s : Etat) : Etat :=
  let m' := if m < 0 then max m (-(s.allegementsTranche.get t)) else m
  let cout := H.eco.coutTravailTrancheMeur.get t
  let emploiT := H.eco.emploiPriveTrancheMilliers.get t
  let emplois := if s.pib = 0 ∨ cout = 0 then 0
    else m' * H.eco.elasticiteEmploiCoutTravailPm.get t * emploiT * H.reference.etat.pib / (cout * s.pib)
  -- pondération : coût par emploi de la tranche / coût par emploi moyen
  let coutTotal := H.eco.coutTravailTrancheMeur.total
  let emploiTotalT := H.eco.emploiPriveTrancheMilliers.total
  let ponderes := if emploiT = 0 ∨ coutTotal = 0 then 0
    else emplois * cout * emploiTotalT / (emploiT * coutTotal)
  effetDemande H .coutTravail none (appliquerPm m' M.multiplicateurPrelevementsPm)
    { s with impots := s.impots.ajouter .cotisations (-m')
             allegementsTranche := s.allegementsTranche.ajouter t m'
             emploisCoutTravailRestants := s.emploisCoutTravailRestants + emplois
             emploisPonderesCoutTravailRestants := s.emploisPonderesCoutTravailRestants + ponderes }

/-- Revalorisation du SMIC de `h` pb. Emplois : l'effet brut du coût du
travail (`emploisParPointSmic`) moins les emplois que sauvent les allègements
en plus (élasticité de la première tranche, comme `varierAllegements`, sans
son effet sur les marges : la hausse des salaires les réduit d'autant)
rejoignent progressivement l'emploi, pondérés par le coût par emploi de la
tranche pour le PIB. Finances publiques, par point, ramenées au PIB
courant : allègements en plus (suivis sur la première tranche),
cotisations, CSG et impôt sur le revenu des salariés du privé, prestations
en moins ; rémunération des agents publics payés près du SMIC (si
`agentsPublics`), avec leurs retenues (CSG-CRDS 9,53 %, retenue pour pension
11,10 %, sans impôt sur le revenu à ce niveau de salaire) ; revenu disponible
des ménages (effet de demande d'un transfert). Les prélèvements nets dus au
SMIC sont suivis à part (`smicPrelevementsMeur`). -/
def revaloriserSmic (M : Moteur) (H : Scenario) (agentsPublics : Bool) (h : Int) (s : Etat) : Etat :=
  let P := H.eco.smicParPoint
  let ref := H.reference.etat.pib
  let parPoint (x : Int) : Int := if ref = 0 then 0 else x * h * s.pib / (100 * ref)
  let allegements := parPoint P.allegementsMeur
  let remuneration := if agentsPublics then parPoint P.remunerationPubliqueMeur else 0
  let csgPublique := remuneration * 953 / 10000
  let pensionPublique := remuneration * 1110 / 10000
  let cout := H.eco.coutTravailTrancheMeur.get .bas
  let emploiT := H.eco.emploiPriveTrancheMilliers.get .bas
  let sauves := if s.pib = 0 ∨ cout = 0 then 0
    else allegements * H.eco.elasticiteEmploiCoutTravailPm.get .bas * emploiT * ref / (cout * s.pib)
  let emplois := sauves - H.eco.emploisParPointSmic * h / 100
  let ponderes := if emploiT = 0 ∨ H.eco.coutTravailTrancheMeur.total = 0 then 0
    else emplois * cout * H.eco.emploiPriveTrancheMilliers.total / (emploiT * H.eco.coutTravailTrancheMeur.total)
  let dCotisations := parPoint P.cotisationsMeur - allegements + pensionPublique
  let dCsg := parPoint P.csgMeur + csgPublique
  let dIr := parPoint P.impotRevenuMeur
  let s₁ : Etat := { s with
    smicMensuel := s.smicMensuel + appliquerPb s.smicMensuel h
    impots := ((s.impots.ajouter .cotisations dCotisations).ajouter .csgCrds dCsg).ajouter .ir dIr
    allegementsTranche := s.allegementsTranche.ajouter .bas allegements
    depensesF := (s.depensesF.ajouter .famille (-(parPoint P.prestationsMeur))).ajouter .fonctionnement remuneration
    smicPrelevementsMeur := s.smicPrelevementsMeur + dCotisations + dCsg + dIr
    emploisCoutTravailRestants := s.emploisCoutTravailRestants + emplois
    emploisPonderesCoutTravailRestants := s.emploisPonderesCoutTravailRestants + ponderes }
  let revenu := parPoint P.revenuDisponiblePriveMeur + remuneration - csgPublique - pensionPublique
  effetDemande H .transferts none (appliquerPm revenu M.multiplicateurPrelevementsPm) s₁

/-- Hausses régulières de `pas` mois par an jusqu'à `reste` mois (dernière
hausse partielle). Vide si `reste` ou `pas` n'est pas positif. -/
def pasReguliers (reste pas : Int) : List Int :=
  if reste ≤ 0 ∨ pas ≤ 0 then []
  else List.replicate (reste / pas).toNat pas ++ (if reste % pas = 0 then [] else [reste % pas])

/-- Calendrier qui suit `cal` en plafonnant la hausse cumulée à `reste` mois,
puis monte de 3 mois par an (rythme de la réforme de 2023) jusqu'à `reste`. -/
def calendrierVers : Int → List Int → List Int
  | reste, [] => pasReguliers reste 3
  | reste, x :: xs =>
      let y := max 0 (min x reste)
      y :: calendrierVers (reste - y) xs

-- 63 ans et 6 mois depuis 62 ans et 9 mois (+9 mois), puis 65 ans (+27) :
-- le calendrier légal est suivi, puis prolongé de 3 mois par an
example : calendrierVers 9 [3, 0, 3, 3, 3, 3] = [3, 0, 3, 3, 0, 0] := by decide
example : calendrierVers 27 [3, 0, 3, 3, 3, 3] = [3, 0, 3, 3, 3, 3, 3, 3, 3, 3] := by decide

/-- Somme terme à terme de deux échéanciers de surfaces (le plus long
fixe la durée). -/
def fusionnerSurfaces : List ParDestination → List ParDestination → List ParDestination
  | [], l => l
  | l, [] => l
  | a :: l, b :: m => a.plus b :: fusionnerSurfaces l m

/-- Interprétation d'un levier sous un moteur et un scénario. -/
def Levier.appliquer (M : Moteur) (H : Scenario) : Levier → Etat → Etat
  | .depense m, s => appliquerDepense H none .nonVentile m s
  | .economie m, s => appliquerEconomie M H .nonVentile m s
  | .depenseSur f m, s => appliquerDepense H f.secteur f m s
  | .economieSur f m, s => appliquerEconomie M H f m s
  -- canal du capital : le flux d'investissement public des mesures (les
  -- échéanciers de construction sont lus sur leurs échéances)
  | .investissement f m, s => appliquerInvestissement H f m
      { s with investissementPublicMesures := s.investissementPublicMesures.ajouter f m }
  | .prelevement r, s => appliquerPrelevement M H .autres r s
  | .baissePrelevement c, s => appliquerPrelevement M H .autres (-c) s
  | .prestationParHabitant e, s =>
      appliquerDepense H none .famille (e * s.populationMilliers / 1000) s
  | .revalorisationSmic h, s => revaloriserSmic M H true h s
  | .smicCibleBrut e pub, s =>
      let h := if s.smicMensuel = 0 then 0 else e * 10000 / s.smicMensuel - 10000
      if h ≤ 0 then s else { revaloriserSmic M H pub h s with smicMensuel := e }
  | .ageLegal d, s => reculDepart H (d * 1000) s
  | .dureeCotisation m part, s => reculDepart H (m * part) s
  | .ageLegalCible c r, s =>
      if c ≤ s.ageLegalMois then
        reculDepart H ((c - s.ageLegalMois) * 1000) { s with calendrierAgeLegal := [] }
      else
        { s with calendrierAgeLegal :=
            if r ≤ 0 then calendrierVers (c - s.ageLegalMois) s.calendrierAgeLegal
            else pasReguliers (c - s.ageLegalMois) r }
  | .dureeTravail v, s =>
      chocHeures H v { s with heuresParEmploi := s.heuresParEmploi + appliquerPm s.heuresParEmploi v }
  -- IS : taux effectif moyen (plancher du pilier 2 pour les grands groupes),
  -- assiette qui répond au taux effectif, impulsion de demande sur la
  -- variation statique
  | .impotSocietes taux, s =>
      let t0 := H.eco.tauxISPb
      let tEff := tauxISEffectif H taux
      -- taux effectif en vigueur (un levier précédent l'a peut-être changé) ;
      -- la réponse de l'assiette se mesure depuis le taux du scénario
      let tCour := t0 + s.ecartTauxISPb
      let statique := if tCour = 0 then 0 else s.impots.impotSocietes * (tEff - tCour) / tCour
      -- recettes après réponse de l'assiette : IS × tEff/tCour × (1 + ε (t0 − tEff)/100)
      -- / (1 + ε (t0 − tCour)/100)
      let den := tCour * (100000 + H.eco.semiElasticiteAssietteISPm * (t0 - tCour))
      let apres := if den = 0 then s.impots.impotSocietes
        else s.impots.impotSocietes * tEff
          * (100000 + H.eco.semiElasticiteAssietteISPm * (t0 - tEff)) / den
      -- canal du capital : le coût du capital suit l'écart du taux effectif au
      -- taux du scénario (effet sur le PIB potentiel dans la projection)
      effetDemande H .entreprises none (-(appliquerPm statique (poidsPrelevement M H .impotSocietes)))
        { s with impots := s.impots.ajouter .impotSocietes (apres - s.impots.impotSocietes)
                 ecartTauxISPb := tEff - t0
                 isTauxMeur := s.isTauxMeur + (apres - s.impots.impotSocietes) }
  | .transition sec r c, s =>
      appliquerDepense H none .logementEnvironnement c (s.reduireEmissions sec (r * 1000))
  | .transitionKt sec kt c, s =>
      appliquerDepense H none .logementEnvironnement c (s.reduireEmissions sec kt)
  | .transitionEcologique t, s =>
      let E := H.energie
      let R := E.renovation
      let P := E.pac
      -- énergie fossile évitée : importations et taxes (M€ par an)
      let (imports, accises, tva, acciseAutres) := match t.energie with
        | .carburant =>
            if E.co2EviteParVehiculeKg = 0 then (0, 0, 0, 0)
            else (t.reductionKt * E.gainCommercialParVehiculeEuros / E.co2EviteParVehiculeKg,
                  t.reductionKt * E.accisesParVehiculeEuros / E.co2EviteParVehiculeKg,
                  t.reductionKt * E.tvaParVehiculeEuros / E.co2EviteParVehiculeKg, 0)
        | .fioul =>
            let mwh := if R.co2FioulKgMWh = 0 then 0 else t.reductionKt * 1000000 / R.co2FioulKgMWh
            (mwh * R.importFioulEurosMWh * E.prixBrentDollars / E.prixReferenceDollars / 1000000,
             mwh * R.accisesFioulEurosMWh / 1000000, mwh * R.tvaFioulEurosMWh / 1000000, 0)
        | .gaz =>
            let mwh := if R.co2GazKgMWh = 0 then 0 else t.reductionKt * 1000000 / R.co2GazKgMWh
            (mwh * R.importGazEurosMWh / 1000000, 0, mwh * R.tvaGazEurosMWh / 1000000,
             mwh * R.accisesGazEurosMWh / 1000000)
        | .aucune => (0, 0, 0, 0)
      let importsEvites := imports * (1000 - t.substitutImportePm) / 1000
      let (accises, tva, acciseAutres) := if t.taxesMaintenues then (0, 0, 0) else (accises, tva, acciseAutres)
      let acciseElec := t.electriciteGwh * P.accisesElecEurosMWh / 1000
      let tvaElec := t.electriciteGwh * P.tvaElecEurosMWh / 1000
      let taxesNettes := accises + tva + acciseAutres - acciseElec - tvaElec
      let s₁ : Etat := { (s.reduireEmissions t.secteurGes t.reductionKt) with
        importations := s.importations - importsEvites
          + t.activitePerdueMeur * t.activiteImporteePm / 1000
        impots := ((s.impots.ajouter .accisesEnergie (acciseElec - accises)).ajouter .tva (tvaElec - tva)).ajouter
          .autres (0 - acciseAutres)
        consommationMesuresGwh := s.consommationMesuresGwh + t.electriciteGwh
        consommationGwh := s.consommationGwh + t.electriciteGwh }
      -- économies des ménages et des entreprises : dépensées ailleurs (moins
      -- d'importations, moins de taxes payées) ; économies des administrations
      -- publiques : leur dépense baisse de la facture importée et des taxes
      -- facture hors taxes de l'énergie évitée : gaz au prix du tertiaire ;
      -- fioul et carburant à leur seule valeur importée (minorant)
      let factureHt := match t.energie with
        | .gaz => if R.co2GazKgMWh = 0 then 0
            else t.reductionKt * 1000000 / R.co2GazKgMWh * E.prixGazTertiaireHtEurosMWh / 1000000
        | _ => importsEvites
      let privePm := 1000 - t.partPubliquePm
      let economiePublique := (factureHt + taxesNettes) * t.partPubliquePm / 1000
      let s₁ := { s₁ with depensesF := s₁.depensesF.ajouter .fonctionnement (0 - economiePublique) }
      let s₂ := effetDemande H .exterieur (some .tertiaireMarchand) (importsEvites * privePm / 1000) s₁
      let s₃ := effetDemande H .taxesConsommation none
        (appliquerPm (taxesNettes * privePm / 1000) M.multiplicateurPrelevementsPm) s₂
      chocPib H (some t.secteurActivite) (0 - t.activitePerdueMeur) s₃
  | .investissementTransition _ [], s => s
  | .investissementTransition tech (n :: reste), s =>
      let part := partInterieure H (H.energie.partImporteeTransitionPm.get tech)
      -- équipement fossile qui n'est plus acheté (chaudière en fin de vie)
      let subst := min part (H.energie.substitutionBruneTransitionPm.get tech)
      let e : Echeance := { fonction := tech.fonction, restants := reste, niveau := n, indice := 10000,
                            secteur := some tech.secteur, partInterieurePm := part, substitutionPm := subst,
                            capitalPublic := tech.capitalPublic }
      let s' : Etat := { s with echeances := s.echeances ++ [e]
                                depensesF := s.depensesF.ajouter tech.fonction n
                                importations := s.importations + n * (1000 - part) / 1000 }
      effetDemande H .investissementInterieur (some tech.secteur) (appliquerPm (n * (part - subst) / 1000) (poidsEcheance H e)) s'
  | .tauxMarginalSommet pm, s => { s with tauxMarginalSommetPm := max s.tauxMarginalSommetPm pm }
  | .revisionConstitution a o, s => { s with revisionsConstitution := s.revisionsConstitution ++ [s!"{a} ({o})"] }
  | .investissementPriveTransition _ [], s => s
  | .investissementPriveTransition tech (n :: reste), s =>
      let part := partInterieure H (H.energie.partImporteeTransitionPm.get tech)
      -- équipement fossile remplacé et éviction par le financement
      let subst := min part (H.energie.substitutionBruneTransitionPm.get tech + H.eco.evictionInvestissementPrivePm)
      let e : Echeance := { fonction := tech.fonction, restants := reste, niveau := n, indice := 10000,
                            secteur := some tech.secteur, partInterieurePm := part, privee := true,
                            substitutionPm := subst }
      let s' : Etat := { s with echeances := s.echeances ++ [e]
                                importations := s.importations + n * (1000 - part) / 1000 }
      effetDemande H .investissementInterieur (some tech.secteur) (n * (part - subst) / 1000) s'
  -- Transfert interne aux APU : aucun effet sur l'état consolidé. Un effet
  -- logement (rattrapage induit) demanderait un indicateur et une hypothèse
  -- de comportement des communes : évolution du modèle commun, à discuter
  -- en issue.
  | .amendeSRU _, s => s
  | .depensePonctuelle m, s => depenseUneAnnee H .nonVentile none 1000 m s
  -- achat : dépense de l'année (déficit), dont la part importée suit les
  -- importations, retirée l'année suivante ; dès l'année 0 et en niveau :
  -- parc électrique, particules selon la vignette Crit'Air des voitures
  -- retirées, CO₂, carburant importé en moins, accises et TVA perdues
  | .remplacementVehicules r, s =>
      basculeElectrique M H r.nombre r.vignetteCritAir
        (depenseUneAnnee H .logementEnvironnement (some .industrie)
          (partInterieure H r.partImporteePm) (r.cout / 1000000)) s
  -- conversion : seule l'aide publique est une dépense ; la voiture reste
  -- dans le parc, électrique
  | .retrofitElectrique n aide partImp vignette, s =>
      basculeElectrique M H n vignette
        (depenseUneAnnee H .logementEnvironnement (some .tertiaireMarchand)
          (partInterieure H partImp) (n * aide / 1000000)) s
  | .prelevementSur i r, s => appliquerPrelevement M H i r s
  | .depenseSecteur sec m, s => appliquerDepense H (some sec) .nonVentile m s
  | .pretEtat m, s => { s with operationsFinancieres := s.operationsFinancieres + m }
  | .migration d, s => { s with migrationAnnuelleMilliers := s.migrationAnnuelleMilliers + d }
  | .offreTravail d taux, s =>
      let emplois := appliquerPm d taux
      let equilibre := if s.actifs = 0 then 0 else d * s.emploiTotal / s.actifs
      let s₁ : Etat := { s with actifs := s.actifs + d
                                chomeursExcedentaires := s.chomeursExcedentaires + (equilibre - emplois) }
      chocEmploi H emplois (ajouterEmploi H none emplois s₁)
  | .accueilTouristique zones cout hT hD, s =>
      let s₁ := appliquerInvestissement H .affairesEconomiques (zones * cout) s
      let s₂ := { s₁ with touristesMilliers := s₁.touristesMilliers + appliquerPm s₁.touristesMilliers hT
                          depenseParTouriste := s₁.depenseParTouriste + appliquerPm s₁.depenseParTouriste hD }
      let dExport := s₂.recettesTourisme - s₁.recettesTourisme
      effetDemande H .exterieur none dExport { s₂ with exportations := s₂.exportations + dExport }
  | .robotisation g, s => { s with robotisationPb := s.robotisationPb + g }
  | .preventionAccidents fonds baisse, s =>
      let s₁ := appliquerDepense H none .famille fonds s
      let avant := s₁.accidentsTravail
      let s₂ := { s₁ with tauxAccidentsPdm := s₁.tauxAccidentsPdm - appliquerPm s₁.tauxAccidentsPdm baisse }
      let evites := avant - s₂.accidentsTravail
      let economie := evites * H.eco.coutParAccidentEuros / 1000000
      -- journées rendues au travail : 7 h chacune, rapportées au volume d'heures
      let heures : Int := evites * H.eco.joursPerdusParAccident * 7
      chocHeuresRatio H heures (s₂.heuresTotales * 1000000)
        { s₂ with depensesF := s₂.depensesF.ajouter .famille (-economie)
                  anneesVieGagneesParAn := s₂.anneesVieGagneesParAn
                    + evites * H.eco.letaliteAccidentsPdm / 10000 * H.demo.anneesVieParDecesAccidentDixiemes / 10 }
  -- réallocation : l'écart à l'emploi d'équilibre (taux d'emploi courant
  -- appliqué à la population active restante) est résorbé dans la projection
  | .automatisation g emplois sorties, s =>
      let dEquilibre := if s.actifs = 0 then 0 else -(sorties * s.emploiTotal / s.actifs)
      let s' : Etat := { s with
        actifs := s.actifs - sorties
        emploi := s.emploi.repartir (-emplois) none
        chomeursExcedentaires := s.chomeursExcedentaires + (dEquilibre + emplois) }
      let dPib := appliquerPb s'.pib g
      let dRecettes := if s'.pib = 0 then 0 else dPib * s'.recettes / s'.pib
      { s'.ajouterRecettesProrata dRecettes with pib := s'.pib + dPib }
  -- la production publique supprimée (au coût des facteurs) est la part
  -- directe de la baisse du PIB ; l'emploi privé répond au reste
  | .suppressionPostes f postes cout, s =>
      -- symétrique de `creationPostes` : les postes disparaissent un pour un,
      -- la rémunération économisée est une demande publique en moins
      -- (pondérée par le moteur), à laquelle l'emploi marchand répond
      let economie := postes * cout / 1000000
      effetDemande H .emploisPublics none
        (-(appliquerPm (appliquerPm economie M.multiplicateurEconomiesPm) (H.eco.incidenceDepensePm.get f)))
        (chocDemandeTravail H (some .tertiaireNonMarchand) (-postes)
          { s with depensesF := s.depensesF.ajouter f (-economie) })
  | .creationPostes _ [] _, s => s
  | .creationPostes f (n :: reste) cout, s =>
      let niveau := n * cout / 1000000
      let e : Echeance := { fonction := f, restants := reste.map (· * cout / 1000000), niveau := niveau,
                            indice := 10000, coutParPosteEuros := some cout }
      effetCreationPostes H f niveau n { s with echeances := s.echeances ++ [e] }
  | .depenseEcheancier _ [], s => s
  | .depenseEcheancier f (n :: reste), s =>
      let s' := { s with echeances := s.echeances ++ [{ fonction := f, restants := reste, niveau := n, indice := 10000 }] }
      if n < 0 then appliquerEconomie M H f (-n) s' else appliquerDepense H f.secteur f n s'
  -- importations en moins (énergie importée évitée…) : la dépense se reporte
  -- ailleurs (bloc de demande, canal extérieur)
  | .importationsNiveau d, s => effetDemande H .exterieur none (0 - d) { s with importations := s.importations + d }
  | .normeDepense m, s => { s with moderationDepensesPb := s.moderationDepensesPb + m }
  | .plafondNormeSante pb, s => { s with plafondModerationSantePb := pb }
  | .freinDeficit seuil m, s =>
      { s with freinDeficitSeuilPb := seuil, freinDeficitPb := m }
  | .placementExcedent part partOr plafond, s =>
      { s with placementExcedentPm := part, partOrPlacementPm := partOr, plafondOrRacheteMeur := plafond }
  | .recetteEcheancier _ [], s => s
  | .recetteEcheancier i (n :: reste), s =>
      let e : EcheanceRecette := { impot := i, restants := reste, niveau := n, indice := 10000 }
      let s' : Etat := { s with echeancesRecettes := s.echeancesRecettes ++ [e] }
      match i with
      | some imp =>
          effetDemande H imp.canal none (-(appliquerPm n (poidsPrelevement M H imp)))
            { s' with impots := s'.impots.ajouter imp n }
      | none => { s' with autresRecettes := s'.autresRecettes + n }
  | .prisesDeParticipation m, s =>
      { s with investissementsParticipations := s.investissementsParticipations + m }
  | .annonceEmplois n, s => { s with emploisAnnonces := s.emploisAnnonces + n }
  | .aideAchatElectrique n prime pub, s =>
      let E := H.energie
      let s' : Etat := match pub with
        | .obligation => { s with electrificationAnnuelleMilliers := s.electrificationAnnuelleMilliers + n / 1000 }
        | .general => { s with electrificationAideePondereeMilliers := s.electrificationAideePondereeMilliers
            + n * fractionReponsePm E.sensibiliteAideGeneralePmParKeur prime / 1000000 }
        | .modestes => { s with electrificationAideePondereeMilliers := s.electrificationAideePondereeMilliers
            + n * fractionReponsePm E.sensibiliteAideModestesPmParKeur prime / 1000000 }
      appliquerDepense H none .logementEnvironnement (n * prime / 1000000) s'
  -- rénovation : rénovations déjà aidées dans la cible, rénovations suscitées
  -- par le bonus (demande linéaire en l'aide), coût annuel, économies
  -- d'énergie portées par la projection
  -- le bonus versé aux rénovations qui auraient eu lieu est un transfert aux
  -- ménages (effet de demande d'une baisse de prélèvement) ; les rénovations
  -- suscitées sont des travaux, aide et part des ménages comprises, adressés
  -- à la construction
  | .bonusRenovation cible bonus, s =>
      let R := H.energie.renovation
      let base := R.renovationsAideesParAn * R.part cible / 1000
      let suscitees := base * (1000 - R.aubainePm) * bonus / (1000 * R.aideMoyenneEuros)
      let transfert := base * bonus / 1000000
      let aideSuscitees := suscitees * (R.aideMoyenneEuros + bonus) / 1000000
      let travaux := suscitees * max R.coutTravauxMoyenEuros (R.aideMoyenneEuros + bonus) / 1000000
      let mwh := suscitees * R.economieKWhParRenovation / 1000
      let s₁ : Etat := { s with
        depensesF := s.depensesF.ajouter .logementEnvironnement (transfert + aideSuscitees)
        economiesFioulMWhAnnuelles := s.economiesFioulMWhAnnuelles + mwh * R.partFioul cible / 1000
        economiesGazMWhAnnuelles := s.economiesGazMWhAnnuelles + mwh * R.partGaz cible / 1000 }
      effetDemande H .investissement (some .construction) travaux
        (effetDemande H .transferts none (appliquerPm transfert M.multiplicateurPrelevementsPm) s₁)
  | .renovationsAmpleur cible n aide kwh, s =>
      let R := H.energie.renovation
      let travaux := n * aide / 1000000
      let mwh := n * kwh / 1000
      let s₁ : Etat := { s with
        depensesF := s.depensesF.ajouter .logementEnvironnement travaux
        economiesFioulMWhAnnuelles := s.economiesFioulMWhAnnuelles + mwh * R.partFioul cible / 1000
        economiesGazMWhAnnuelles := s.economiesGazMWhAnnuelles + mwh * R.partGaz cible / 1000 }
      effetDemande H .investissement (some .construction) travaux s₁
  | .investissementEcheancier _ [], s => s
  | .investissementEcheancier f (n :: reste), s =>
      let e : Echeance := { fonction := f, restants := reste, niveau := n, indice := 10000,
                            secteur := some .construction }
      appliquerInvestissement H f n { s with echeances := s.echeances ++ [e] }
  | .investissementOutreMer _ [], s => s
  | .investissementOutreMer f (n :: reste), s =>
      let part := partInterieureOutreMer H
      let e : Echeance := { fonction := f, restants := reste, niveau := n, indice := 10000,
                            secteur := some .construction, partInterieurePm := part }
      let s' : Etat := { s with echeances := s.echeances ++ [e]
                                depensesF := s.depensesF.ajouter f n
                                importations := s.importations + n * (1000 - part) / 1000 }
      effetDemande H .investissementInterieur (some .construction) (n * part / 1000) s'
  | .remunerationPublique _ _ [], s => s
  | .remunerationPublique nat f (n :: reste), s =>
      let e : Echeance := { fonction := f, restants := reste, niveau := n, indice := 10000,
                            remuneration := some nat }
      effetRemuneration M H nat n
        { s with echeances := s.echeances ++ [e], depensesF := s.depensesF.ajouter f n }
  | .apurementPassifs t f part, s =>
      let montant := s.passifs.get t * part / 1000
      remunerationUneAnnee M H .heuresSup f montant
        { s with passifs := s.passifs.ajouter t (-montant) }
  | .entretienPassifs t f montant, s =>
      let m := max 0 (min montant (s.passifs.get t))
      let e : Echeance := { fonction := f, restants := [0], niveau := montant, indice := 10000,
                            secteur := some .construction }
      appliquerInvestissement H f montant
        { s with echeances := s.echeances ++ [e], passifs := s.passifs.ajouter t (-m) }
  | .paiementFluxPassifs t f part, s =>
      let montant := s.fluxPassifs.get t * part / 1000
      let e : Echeance := { fonction := f, restants := [], niveau := montant, indice := 10000,
                            remuneration := some .heuresSup }
      effetRemuneration M H .heuresSup montant
        { s with echeances := s.echeances ++ [e], depensesF := s.depensesF.ajouter f montant
                 fluxPassifs := s.fluxPassifs.ajouter t (-montant) }
  | .taxeEnvironnementale act imp emissions hausse statique, s =>
      let recul := H.energie.elasticitesPrix.get act * hausse / 1000
      appliquerPrelevement M H imp (statique * (1000 - recul) / 1000)
        (s.reduireEmissions act.secteur (emissions * recul / 1000))
  | .raccordementZni foyers, s =>
      appliquerDepense H none .affairesEconomiques
        (foyers * H.energie.consommationFoyerZniKWh * H.energie.surcoutPerequationZniEurosMWh / 1000000000) s
  | .detteNumerique cible rythme cap res imp, s =>
      let tPfu := H.eco.tauxPfuIrPm + H.eco.tauxPfuCsgCrdsPm + H.eco.tauxPfuSolidaritePm
      { s with cibleDetteNumeriquePm := cible
               rythmeDetteNumeriquePm := rythme
               decoteDetteNumeriquePm := cap * tPfu / 1000
               partDefiscaliseePm := res * imp / 1000 }
  | .deploiementBornes n cout, s =>
      appliquerInvestissement H .affairesEconomiques (n * cout / 1000000)
        { s with bornesAnnuellesMilliers := s.bornesAnnuellesMilliers + n / 1000 }
  -- coût du travail : emplois visés = élasticité × variation relative du
  -- coût du travail de la tranche × emploi de la tranche (coût du travail et
  -- emploi de l'année de départ, coût ramené au PIB courant) ; ils
  -- s'ajoutent progressivement dans la projection
  | .allegementsCotisations t m, s => varierAllegements M H t m s
  | .reductionAllegements m, s =>
      let a := s.allegementsTranche
      let tot := a.total
      if tot ≤ 0 then s else
      let mb := m * a.bas / tot
      let mi := m * a.intermediaire / tot
      varierAllegements M H .haut (-(m - mb - mi))
        (varierAllegements M H .intermediaire (-mi) (varierAllegements M H .bas (-mb) s))
  | .recentrageAllegements partI partH, s =>
      let a := s.allegementsTranche
      let i := a.intermediaire * partI / 1000
      let h := a.haut * partH / 1000
      varierAllegements M H .bas (i + h)
        (varierAllegements M H .haut (-h) (varierAllegements M H .intermediaire (-i) s))
  | .prixTabac h, s =>
      let e := H.eco.elasticitePrixTabacPm
      -- accises × ((1 + h)(1 − e·h) − 1), proportionnelles au PIB courant
      let base := if H.reference.etat.pib = 0 then 0 else H.eco.accisesTabacMeur * s.pib / H.reference.etat.pib
      let statique := base * ((1000 + h) * (1000000 - e * h) - 1000000000) / 1000000000
      appliquerPrelevement M H .autres statique
        { s with baisseMortaliteCiblePm := s.baisseMortaliteCiblePm.ajouter .tabac (e * h / 1000) }
  | .prixMinimumAlcool c, s =>
      { s with baisseMortaliteCiblePm :=
          s.baisseMortaliteCiblePm.ajouter .alcool (c * H.eco.baisseDecesAlcoolPar10CentimesPm / 10) }
  | .depistageColorectal cible, s =>
      let points := max 0 (cible - H.eco.participationDepistagePm)
      let cout := points * H.eco.populationDepistageMilliers * H.eco.coutParDepistageEuros / 1000000
      appliquerDepense H Fonction.sante.secteur .sante cout
        { s with baisseMortaliteCiblePm := s.baisseMortaliteCiblePm.ajouter .cancerColorectal
                   (points * H.eco.baisseDecesColorectalParPointPm / 10) }
  | .baisseMortalite c pm, s =>
      { s with baisseMortaliteCiblePm := s.baisseMortaliteCiblePm.ajouter c pm }
  | .pollutionAir d, s =>
      { s with decesPollutionAir := max 0 (s.decesPollutionAir + d)
               anneesVieGagneesParAn := s.anneesVieGagneesParAn
                 - d * H.demo.anneesVieParDecesPollutionDixiemes / 10 }
  | .scolarisationJeunes h, s =>
      let etudiants := 7 * H.eco.jeunesParGenerationMilliers * h   -- milliers × pm → personnes
      appliquerDepense H Fonction.enseignement.secteur .enseignement
        (etudiants * H.eco.depenseParEtudiantEuros / 1000000)
        { s with dureeAttendueCentiemes := s.dureeAttendueCentiemes + 7 * h / 10 }
  | .accompagnementDemandeurs n cout, s =>
      appliquerDepense H Fonction.famille.secteur .famille (n * cout / 1000000)
        { s with chomeursExcedentaires := s.chomeursExcedentaires + n * H.eco.chomeursEvitesParConseiller }
  | .capaciteElectrique f m, s => { s with ajoutsCapaciteMw := s.ajoutsCapaciteMw.ajouter f m }
  | .solaireToiture m, s =>
      { s with ajoutsCapaciteMw := s.ajoutsCapaciteMw.ajouter .solaire m
               ajoutsToitureMw := s.ajoutsToitureMw + m }
  | .consommationElectrique g, s =>
      { s with consommationMesuresGwh := s.consommationMesuresGwh + g
               consommationGwh := s.consommationGwh + g }
  | .prioriteNucleaire, s => { s with prioriteNucleaire := true }
  | .stockageElectrique mw h cycles rend g, s =>
      let charge := mw * h * cycles / 1000
      let restitue := charge * rend / 1000
      let deplace := max 0 (min restitue (s.productionGwh.thermique - s.dechargeStockageGwh))
      let pertes := charge - deplace
      { (s.reduireEmissions .energie (deplace * g / 1000)) with
        consommationMesuresGwh := s.consommationMesuresGwh + pertes
        consommationGwh := s.consommationGwh + pertes
        dechargeStockageGwh := s.dechargeStockageGwh + deplace }
  | .regimeZan e, s => { s with ecartZanPm := max s.ecartZanPm e }
  | .artificialisation d hs, s =>
      { s with surfacesMesuresHa := fusionnerSurfaces s.surfacesMesuresHa (hs.map fun h => ({} : ParDestination).ajouter d h) }
  | .artificialisationHorsZan d hs, s =>
      { s with surfacesHorsZanMesuresHa :=
          fusionnerSurfaces s.surfacesHorsZanMesuresHa (hs.map fun h => ({} : ParDestination).ajouter d h) }
  | .pompesAChaleur cible n cout, s =>
      let P := H.energie.pac
      let nets := n * (1000 - P.aubainePm) / 1000
      let fossileMWh := if P.rendementChaudierePm = 0 then 0 else nets * P.besoinChaleurKWh / P.rendementChaudierePm
      let fioulPm := P.partFioul cible
      let elecGwh := if P.scopCentiemes = 0 then 0 else nets * P.besoinChaleurKWh * 100 / (P.scopCentiemes * 1000000)
      let travaux := nets * cout / 1000000
      let transfert := (n - nets) * cout / 1000000
      let s₁ : Etat := { s with
        depensesF := s.depensesF.ajouter .logementEnvironnement (travaux + transfert)
        economiesFioulMWhAnnuelles := s.economiesFioulMWhAnnuelles + fossileMWh * fioulPm / 1000
        economiesGazMWhAnnuelles := s.economiesGazMWhAnnuelles + fossileMWh * (1000 - fioulPm) / 1000
        consommationPacHausseGwh := s.consommationPacHausseGwh + elecGwh
        deraccordementsGazParAn := s.deraccordementsGazParAn + nets * (1000 - fioulPm) / 1000 }
      effetDemande H .investissement (some .construction) travaux
        (effetDemande H .transferts none (appliquerPm transfert M.multiplicateurPrelevementsPm) s₁)
  | .emploisAides sec n aide aubaine, s =>
      let nets := n * (1000 - aubaine) / 1000
      chocEmploi H nets (chocDemandeTravail H (some sec) nets
        { s with depensesF := s.depensesF.ajouter .affairesEconomiques (n * aide / 1000000) })
  | .implantations sec e, s =>
      let s₁ := chocEmploi H e (chocDemandeTravail H (some sec) e s)
      { s₁ with exportations := s₁.exportations + (s₁.pib - s.pib) }

end Modele
