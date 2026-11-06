import Modele
import Hypotheses
import Proprietes

/-!
# Programme « Texte Orientation D »

Programme de TOrientationD. Seuls les comptes listés dans `PROPRIETAIRES`
peuvent modifier ce dossier : la CI refuse toute autre PR (contrôle d'accès
aux programmes).

Mesures (extrait) :

* **O-01** — remplacement gratuit par l'État de 10 000 voitures Crit'Air 5
  chaque année. Balance commerciale à 5 et 10 ans : sous-modèle automobile.
* **O-02** — amendes SRU proportionnelles à la part de logements sociaux
  manquants, avec comparaison de plusieurs taux. Effet par commune et
  destination des fonds : sous-modèle SRU.
* **O-03** — transparence des attributions de logements sociaux par preuve
  à divulgation nulle de connaissance (ZK). Spécification et garanties :
  sous-modèle d'attribution.
* **O-04** — construction de six EPR2, au niveau du programme
  gouvernemental en cours, financée comme lui par un prêt de l'État.
* **O-05** — prime à l'achat d'une voiture électrique pour 300 000 ménages
  par an ; **O-06** — 50 000 points de recharge publics par an : effets sur
  le parc électrique, les bornes nécessaires et la mortalité liée aux
  particules fines.
* **O-07** — fin de l'âge légal de départ : seule compte la durée cotisée
  (seuil actuel, 172 trimestres), réduite selon la pénibilité.
* **O-08** — impôt sur les sociétés à deux points au-dessus du taux le plus
  bas de l'Union européenne (11 %).
* **O-09** — la démission ouvre des droits au chômage (six mois, une fois
  tous les cinq ans).
* **O-10** — moyens pour la justice, prud'hommes en priorité.
* **O-11** — financement des lignes nouvelles Lyon-Turin, Bordeaux-Toulouse
  et Montpellier-Perpignan.
* **O-12** — qualité d'accueil des touristes : six zones de rénovation de
  qualité (dont Le Grau-du-Roi), pour accroître la dépense par touriste et
  le nombre de nuitées.
* **O-13** — autorisation de la conduite autonome (FSD), avec indemnisation
  des chauffeurs de taxi titulaires d'une licence jusqu'à leur retraite.
* **O-14** — partenaires d'accompagnement à l'application des normes et à
  la lutte contre les accidents du travail, financés par des fonds dédiés
  de l'État ; objectif : la moyenne de l'Union européenne.
* **O-15** — passage au logiciel libre pour tous les logiciels de l'État et
  tous ses ordinateurs.
* **O-20** à **O-23** — économies et recettes : aide à l'apprentissage
  recentrée, commande publique, médicaments et dispositifs avec une agence
  française du médicament qui produit les références en rupture, lutte
  contre la fraude et le travail dissimulé.
* **O-16** à **O-19** — universités : reprise de la dette et apurement des
  déficits, reconstruction aux normes de campus dégradés (Nanterre,
  Toulouse, Montpellier, Grenoble), Parcoursup pour les étudiants
  étrangers à nombre constant, places pour les bacheliers sans
  affectation.
* **O-24** — dette numérique : OAT tokenisées achetées en stablecoin euro
  (mécanisme USDC), intérêts exonérés de PFU pour les particuliers
  résidents.
* **O-25** — rémunération des enseignants +2 % par an ; **O-26** —
  automatisation des tâches administratives, 10 000 postes de contrôle
  supprimés par an pendant cinq ans ; **O-27** — simplification des tâches
  des généralistes, enquêteurs humains sur les cas anormaux.
* **O-28** à **O-34** — désindexation des très hautes retraites, TVA à
  22 %, taxe à l'atterrissage des jets privés, conversion électrique des
  exploitations agricoles, DPE et climatisation réversible dans les
  quartiers historiques, urbanisme (pas de tours en quartier historique,
  quartiers de gare), TER 24 h sur 24 avec agents de sécurité.
* **O-36** à **O-42** — redressement des comptes :
  CSG sur les gros héritages, taxe numérique à 15 %,
  exonérations de cotisations, fraude fiscale et train de vie de l'État,
  niches fiscales, Pacte Dutreil divisé par deux et holdings, norme de
  dépense ; **O-43** défense −1 Md€ par an ; **O-44** 174 trimestres ;
  **O-45** lutte contre la fraude fiscale ; **O-46** CSG progressive pour
  les hauts revenus ; **O-47** 100 M€ par an de participations dans les
  entreprises stratégiques ; **O-48** non-renouvellement des concessions
  autoroutières ; **O-49** hauts fonctionnaires −5 % ; **O-50** revenus des
  élus plafonnés ; **O-51** fin du PFU ; **O-52** rachats d'actions ;
  **O-53** cabinets de conseil ; **O-54** à **O-58** trajectoire de baisse
  continue : CRDS prolongée, norme renforcée, aides aux entreprises,
  niches, durée de cotisation ; **O-59** à **O-62** face aux lois en
  vigueur ajoutées à la référence : CVAE maintenue, contribution
  exceptionnelle des grandes entreprises pérennisée, deuxième étape sur les
  aides aux entreprises et les niches ; **O-63** aide à la rénovation
  majorée de 25 % dans les territoires ruraux ; **O-64** à **O-66** eau
  potable et électrification de tous les foyers des outre-mer ; **O-67** et
  **O-68** dettes cachées (heures supplémentaires des policiers, RIFSEEP
  pour les enseignants) ; **O-69** à **O-73** troisième étape du
  redressement (CIR recentré, assurance-vie au barème, contribution des
  poids lourds, kérosène des vols intérieurs, défiscalisation des heures
  supplémentaires réduite de moitié) ; **O-74** heures supplémentaires non
  payées des hôpitaux publics ; **O-75** 85 000 places de prison, la
  moitié des places nouvelles en modulaire ; **O-76** et **O-77** déficit et chômage en baisse
  à la fois (allègements recentrés sous 2 SMIC, accompagnement renforcé des
  demandeurs d'emploi) ; **O-78** à **O-81** indice de développement
  humain (prix minimum de l'alcool, prix du tabac, dépistage du cancer
  colorectal, scolarisation des 18-24 ans) ; **O-82** financement d'une loi
  intégrale contre les violences sexistes et sexuelles ; **O-83**
  allocations familiales dès le premier enfant ; **O-84** deuxième journée
  de solidarité (retirée en novembre 2026). La suppression de la journée
  existante (O-222, 5 novembre 2026) a été retirée le même jour : la journée
  de solidarité de 2004 est maintenue.

Les valeurs marquées « hypothèse » restent à sourcer ou à arbitrer.
-/

namespace Programmes.TexteOrientationD
open Modele

/-! ## O-01 — Remplacement des 10 000 voitures les plus polluantes -/

/-- 10 000 citadines électriques à 25 000 € (hypothèse de prix) chaque
année, achetées sans critère d'origine : 73 % de la valeur importée,
puisque 27 % des voitures électriques vendues en France y sont fabriquées
(IMT, 2025). Voitures retirées : les plus polluantes, Crit'Air 5 et non
classées (diesel Euro 2 et antérieures ; 1,2 million de voitures au
1er janvier 2026, SDES), dont le modèle déduit les particules évitées
(7,5 fois la moyenne du parc thermique). Neuf vagues de 2027 à 2035 :
90 000 voitures, 7,5 % de ce parc. -/
def remplacement : Remplacement where
  nombre := 10000
  prixUnitaire := 25000
  partImporteePm := 730
  vignetteCritAir := 5

/-- Vagues annuelles de remplacement (2027 à 2035). -/
def vaguesRemplacement : Nat := 9

/-- Variante : véhicules assemblés en France, dont 35 % de la valeur reste
importée (batteries, composants ; hypothèse). -/
def remplacementFabriqueEnFrance : Remplacement :=
  { remplacement with partImporteePm := 350 }

/-! ## O-02 — Amendes SRU proportionnelles -/

/-- Barème retenu : ×1 à ×5 selon la part de l'objectif non atteinte,
plafond porté à 10 % des dépenses réelles de fonctionnement, seuil actuel. -/
def baremeSRU : BaremeSRU where
  tauxBasePm := 250
  coefMinPm := 1000
  coefMaxPm := 5000
  plafondPb := 1000
  seuil := 4000

theorem baremeSRU_valide : baremeSRU.Valide := by decide

def baremeSRUPlafondActuel : BaremeSRU := { baremeSRU with plafondPb := 500 }
def baremeSRUModere : BaremeSRU := { baremeSRU with coefMaxPm := 3000, plafondPb := 500 }
def baremeSRUSevere : BaremeSRU := { baremeSRU with coefMaxPm := 10000, plafondPb := 1500 }

/-! ## O-04 — Six EPR2, comme le programme gouvernemental -/

/-- Programme gouvernemental : 6 EPR2 (Penly, Gravelines, Bugey), devis EDF
du 18 décembre 2025 de 72,8 Md€ (euros 2020), décision finale
d'investissement fin 2026, première mise en service visée en 2038. Accord
État-EDF de juin 2025 : prêt bonifié de l'État couvrant au moins la moitié
des coûts de construction, contrat pour différence à 100 €/MWh sur 40 ans.
Prêt supposé versé linéairement de 2027 à 2038 : 72 800 / 2 / 12 ≈ 3 033
M€/an. -/
def pretEPR2 : Int := 3033

/-- Variante : l'État prête la totalité du coût de construction. -/
def pretEPR2Total : Int := 6067

/-! ## O-07 à O-11 — Hypothèses de chiffrage -/

/-- Impôt sur les sociétés à 21 % (`tauxISCible`), contre 25 % en France.
Le texte visait 15 %, le taux minimal du pilier 2 (12 % dans une version
antérieure : taux hongrois de 9 %, le plus bas de l'Union, plus trois
points) ; 20 % en octobre 2026, 21 % en novembre 2026 pour rapprocher le
déficit de 2035 de 2 % (20 % en variante). Au-dessus de 15 %, le plancher
du pilier 2 ne joue pas.

Le modèle commun applique désormais lui-même (levier `impotSocietes`, axe
économique) :

* le **minimum mondial (pilier 2)** : les groupes dont le chiffre
  d'affaires dépasse 750 M€ restent imposés à au moins 15 % effectifs
  (directive (UE) 2022/2523, impôt complémentaire national de la loi de
  finances pour 2024) ; la France perçoit elle-même le complément ;
* la **réponse de l'assiette** au taux effectif (bénéfices transférés ou
  relocalisés), par une semi-élasticité tirée de la littérature, au lieu
  du coefficient de retour d'assiette de 30 % que le programme fixait
  lui-même.

`tauxMinimumPilier2` ne sert plus qu'au calcul de O-60 (taux des grands
groupes). -/
def tauxISCible : Int := 2100
def tauxMinimumPilier2 : Int := 1500

/-- Démission indemnisée six mois, une fois tous les cinq ans. Hypothèse :
1,9 million de démissions de CDI par an (DARES, ordre de grandeur), 20 %
donnent lieu à indemnisation, 1 300 € par mois pendant 6 mois :
≈ 3,0 Md€/an. Effet sur le chômage non modélisé. -/
def coutDemission : Int := 3000

/-- Lignes nouvelles : accès français au Lyon-Turin (≈ 10 Md€), Bordeaux-
Toulouse et Bordeaux-Dax (14,3 Md€ en valeur 2020), Montpellier-Perpignan
(≈ 6 Md€) : ≈ 30 Md€ sur dix ans, dont 80 % portés par l'État, les
collectivités et SNCF Réseau (administrations publiques), le reste par
l'Union européenne : 2,4 Md€/an. Hypothèses d'ordre de grandeur. -/
def lignesNouvelles : Int := 2400

/-- Emprise des lignes nouvelles (O-11) : 4 800 ha pour Bordeaux-Toulouse
et Bordeaux-Dax (Politis, 30 avril 2026, d'après le projet GPSO),
150 km × 10 ha/km pour Montpellier-Perpignan (longueur : préfecture de la
région Occitanie ; emprise moyenne d'une ligne à grande vitesse, étude des
impacts des LGV, débat public LGV PACA, 2004, p. 5), soit 630 ha par an
sur les dix ans de travaux. Accès au Lyon-Turin : pas de chiffre officiel,
non compté. Bordeaux-Toulouse et le Lyon-Turin figurent parmi les projets
d'envergure nationale de l'arrêté du 31 mai 2024 : sous le ZAN, leur
emprise s'impute sur l'enveloppe. -/
def surfaceLignesNouvellesHa : Int := (4800 + 150 * 10) / 10

/-- Qualité d'accueil touristique : six zones de rénovation (Le Grau-du-Roi,
les Pyrénées et quatre autres
stations), 150 M€/an par zone pendant dix ans (hypothèse :
rénovation du bâti, espaces publics, mobilités). Effet attendu, hypothèse à
étayer (Atout France, études d'impact des stations rénovées) : +2 % de
visiteurs internationaux et +3 % de dépense par touriste, soit ≈ +3,6 Md€/an
de recettes touristiques sur 71 Md€. -/
def zonesTouristiques : Int := 6
def coutParZone : Int := 150

/-- Conduite autonome et taxis (O-13), par cohorte d'âge.

* Effectif : 62 800 taxis en 2024, autant d'autorisations de stationnement
  (ADS) (Observatoire national des T3P) ; titulaires exploitant eux-mêmes
  leur licence : `titulairesTaxi` = 40 000 (hypothèse : environ deux tiers
  des ADS, le reste étant détenu par des sociétés et des loueurs, surtout à
  Paris ; INSEE : 24 000 taxis non salariés sans salarié en 2016).
* Âges : 49 ans en moyenne, 2,4 % de moins de 30 ans, 12,8 % de 60 ans ou
  plus parmi les taxis non salariés (INSEE, « Les revenus d'activité des
  chauffeurs de taxi et de VTC », 2016). `pyramideTaxis` reconstitue des
  tranches (âge minimal, âge maximal, ‰), uniformes à l'intérieur, qui
  respectent ces trois repères (moyenne 49,3 ans).
* Indemnité : `indemniteTaxi` = 25 000 € par an et par titulaire
  (hypothèse : entre le revenu déclaré, 14 800 € en 2016 selon l'INSEE, et
  le chiffre d'affaires des artisans), versée de l'entrée en vigueur
  jusqu'à `ageRetraiteTaxi` = 64 ans (O-07 : 172 trimestres pour une
  carrière commencée vers 21 ans) ; rien pour ceux qui l'ont déjà atteint.
  Le coût s'éteint cohorte par cohorte (`indemnitesTaxis`).
* Emploi : les titulaires cessent l'activité à l'entrée en vigueur (rachat
  de la licence contre la rente). À partir de `ageSortieTaxi` = 55 ans
  (moins de dix ans d'indemnité), ils quittent la population active ; les
  plus jeunes restent actifs et se reclassent au rythme du scénario.
* Automatisation : +0,05 % de PIB (hypothèse : 0,3 % de PIB pour taxis,
  VTC et livraison, 15 % de gain de coût). -/
def titulairesTaxi : Int := 40000
def indemniteTaxi : Int := 25000
def ageRetraiteTaxi : Nat := 64
def ageSortieTaxi : Nat := 55
def pyramideTaxis : List (Nat × Nat × Int) :=
  [(25, 29, 24), (30, 39, 150), (40, 49, 310), (50, 59, 388), (60, 64, 98), (65, 69, 30)]

/-- Titulaires d'âge `a` parmi `n` (répartition uniforme dans la tranche). -/
def titulairesAge (n : Int) (a : Nat) : Int :=
  pyramideTaxis.foldl (fun acc (lo, hi, pm) =>
    if lo ≤ a ∧ a ≤ hi then acc + n * pm / (1000 * ((hi - lo + 1 : Nat) : Int)) else acc) 0

/-- Somme sur les âges 0 à 99 des titulaires (parmi `n`) qui vérifient `p`. -/
def titulairesSi (n : Int) (p : Nat → Bool) : Int :=
  (List.range 100).foldl (fun acc a => if p a then acc + titulairesAge n a else acc) 0

/-- Indemnités de l'année `k` après l'entrée en vigueur, M€ : titulaires
encore sous l'âge de départ × indemnité. Variante `seuilReconversion` :
sous cet âge, deux ans d'indemnité puis une formation de `formation` €
(versée la première année) au lieu d'une rente jusqu'à la retraite. -/
def indemnitesAnnee (n : Int) (seuilReconversion : Nat) (formation : Int) (k : Nat) : Int :=
  let rente := titulairesSi n (fun a => decide (seuilReconversion ≤ a) && decide (a + k < ageRetraiteTaxi))
  let reconvertis := titulairesSi n (fun a => decide (a < seuilReconversion) && decide (a + k < ageRetraiteTaxi) && decide (k < 2))
  let formations := if k = 0 then titulairesSi n (fun a => decide (a < seuilReconversion)) * formation else 0
  ((rente + reconvertis) * indemniteTaxi + formations) / 1000000

/-- Échéancier sur 40 ans (le plus jeune titulaire atteint 64 ans). -/
def indemnitesTaxis (n : Int) (seuilReconversion : Nat) (formation : Int) : List Int :=
  (List.range 40).map (indemnitesAnnee n seuilReconversion formation)

def sortiesTaxis (n : Int) : Int := titulairesSi n (fun a => decide (ageSortieTaxi ≤ a))

/-- Leviers de O-13 pour `n` titulaires. -/
def leviersTaxis (n : Int) (seuilReconversion : Nat) (formation : Int) : List Levier :=
  [.depenseEcheancier .famille (indemnitesTaxis n seuilReconversion formation),
   .automatisation 5 (titulairesSi n (fun _ => true)) (sortiesTaxis n)]

/-- Accidents du travail : 190 accidents avec arrêt pour 10 000 emplois en
France contre ≈ 110 en moyenne dans l'Union (Eurostat). Fonds dédiés :
500 M€/an (hypothèse : réseau de partenaires d'accompagnement des
entreprises, renfort de l'inspection et de la médecine du travail). Objectif
atteint à l'horizon : −42,5 % du taux (190 → 110, arrondi entier). Variante : fonds doublés,
objectif inchangé. -/
def fondsPrevention : Int := 500
def baisseAccidentsPm : Int := 425

/-- Logiciel libre : licences et services propriétaires de l'État ≈ 1 Md€/an
(hypothèse : accords-cadres Microsoft, Oracle, SAP… de l'État et de ses
opérateurs) ; économie nette de 400 M€/an à partir de la quatrième année,
après une migration de 900 M€ (formation, adaptation, matériel) étalée sur
trois ans et comptée en une fois dans la dette, par prudence. -/
def economieLibre : Int := 400
def coutMigrationLibre : Int := 900

/-- Universités. Reprise de la dette : les universités sont des organismes
divers d'administration centrale, déjà consolidés dans la dette publique ;
la reprise par l'État est un transfert interne, neutre sur le solde et la
dette des administrations publiques. Ce qui coûte, c'est l'apurement des
déficits de fonctionnement : ≈ 60 universités en déficit en 2024, pour
environ 500 M€/an (hypothèse ; Cour des comptes, situation financière des
universités, 2025). Reconstruction : quatre campus démolis puis rebâtis aux
normes, 1 Md€ chacun (hypothèse : opérations campus comparables, Jussieu
≈ 2 Md€), étalés sur huit ans à partir de 2027 : 500 M€/an. Places pour les
bacheliers sans affectation : ≈ 10 000 par an sans proposition en fin de
procédure Parcoursup (SIES), trois années de licence, 10 500 € par
étudiant et par an (dépense moyenne, MESR) : 315 M€/an, et 2 000 postes
d'enseignants-chercheurs annoncés. -/
def deficitsUniversites : Int := 500
def reconstructionCampus : Int := 500
def placesSansFac : Int := 315

/-- Économies et recettes. Apprentissage : l'aide exceptionnelle à
l'embauche d'apprentis (3,9 Md€ en 2024, dont plus de la moitié pour le
supérieur) s'éteint pour les contrats conclus à partir de 2027 (décret
n° 2026-168, voir la référence) ; le programme maintient une aide réservée
aux niveaux infra-bac (CAP, bac) dans les entreprises de moins de 250
salariés, sur le modèle de l'aide unique de 2019 : ≈ 1 Md€ par an, les
3,9 Md€ de 2024 moins les 2,94 Md€ d'économies que la Cour des comptes
attend de ce recentrage (revue de dépenses, janvier 2025). Le recentrage,
naguère une économie de 2 Md€ par rapport à l'aide de 2025, est donc
désormais un coût par rapport à la référence. Commande publique : centrales d'achat, standardisation,
lutte contre les ententes ; 3 Md€/an (hypothèse médiane des estimations,
Autorité de la concurrence, IGF). Médicaments et dispositifs : génériques,
biosimilaires, prix des innovations, pertinence des prescriptions, 2 Md€/an
(Assurance maladie, rapport charges et produits 2025) ; l'agence française
du médicament qui produit les références en rupture coûte 300 M€/an
(hypothèse : établissement pharmaceutique public de taille moyenne,
investissement initial de 500 M€). Fraude et travail dissimulé (BTP,
restauration, services à la personne) : manque à gagner de cotisations
estimé entre 6 et 8 Md€ par an (Haut Conseil du financement de la
protection sociale, 2024) ; récupération de 2 Md€/an de cotisations et 1 Md€
de TVA, montée en charge sur deux ans. -/
def aideApprentissageCiblee : Int := 1000
def economieCommandePublique : Int := 3000
def economieMedicament : Int := 2000
def coutAgenceMedicament : Int := 300
def investissementAgence : Int := 500
def fraudeCotisations : Int := 2000
def fraudeTVA : Int := 1000

/-- Enseignants (O-25). Masse salariale des enseignants hors CAS Pensions :
59,23 Md€ en 2026 pour 852 752 enseignants du public et du privé sous
contrat (PLF 2026, rapport du Sénat sur la mission Enseignement scolaire) ;
une hausse de 1 % du point d'indice coûte ≈ 0,5 Md€. Base 2027 :
`masseEnseignants2027` = 59,23 × 1,028 ≈ 60,9 Md€ (croissance tendancielle
des dépenses). Rémunération +2 % par an en plus de l'évolution tendancielle,
à partir de 2027 (échéancier sur vingt ans) : niveau atteint après k + 1 hausses = masse × (1,02^(k+1)
− 1), en euros de 2027, indexé ensuite comme la fonction enseignement. -/
def masseEnseignants2027 : Int := 60900
def revalorisationsEnseignants : List Int :=
  (List.range 20).map fun k =>
    masseEnseignants2027 * ((10200 : Int) ^ (k + 1) - (10000 : Int) ^ (k + 1)) / (10000 : Int) ^ (k + 1)

/-- Automatisation des contrôles administratifs (O-26). 10 000 postes par an
pendant cinq ans (50 000) libérés par l'automatisation. Amendement
d'octobre 2026 : les agents sont redéployés au lieu d'être supprimés (dans
le modèle commun, la suppression creusait le déficit de 2035 de 0,08 point
et accroissait le chômage de 0,10 point en 2030 : indemnisation et
recettes perdues dépassaient l'économie) ; 10 000 d'entre eux, 2 500 par an
de 2027 à 2030, renforcent l'accompagnement à France Travail (O-77, en
plus des 10 000 conseillers d'O-77), 1 500 le contrôle fiscal d'O-45, les
autres les contrôles et l'accueil (effets non modélisés). Coût complet
d'un poste de catégorie B ou C : `coutPosteControle` = 55 000 € par an
(hypothèse : salaire net moyen de la fonction publique de l'État 3 018 €
par mois en 2024, toutes catégories (DGAFP), plus bas en B et C, cotisations
employeur comprises hors pensions). Outil : `investissementParPoste` =
30 000 € par poste supprimé, la même année, et `maintenanceParPoste` =
3 000 € par an ensuite (hypothèses). -/
def postesControleParAn : Int := 10000
def agentsRedeployesParAn : Int := 2500
def coutPosteControle : Int := 55000
def investissementParPoste : Int := 30000
def maintenanceParPoste : Int := 3000

/-- Médecins généralistes (O-27). Les généralistes libéraux travaillent
54 h par semaine, dont 44 h 30 de soins et ≈ 5 h 30 de gestion et de
coordination ; 18 min par consultation ; 6,2 semaines de congés (DREES,
Études et résultats, mai 2019). `generalistesLiberaux` = 52 000 (ordre de
grandeur, à sourcer). Simplification : `heuresLibereesCentiemes` = 275,
soit la moitié des tâches administratives (2 h 45 par semaine). Temps
libéré : 52 000 × 2,75 h × 45,8 semaines ≈ 6,5 millions d'heures par an,
soit ≈ 3 200 généralistes à temps plein (44 h 30 de soins) ou ≈ 21,8
millions de consultations possibles. Les contrôles systématiques sont
remplacés par `enqueteurs` = 500 enquêteurs sur les cas anormaux, à
`coutEnqueteur` = 65 000 € (hypothèses). Sans hypothèse d'usage du temps
libéré, l'effet budgétaire est le seul coût des enquêteurs ; la variante
convertit le temps libéré en consultations remboursées (30 €, 70 % à la
charge de l'assurance maladie). -/
def generalistesLiberaux : Int := 52000
def heuresLibereesCentiemes : Int := 275
def semainesTravaillees10 : Int := 458
def enqueteurs : Int := 500
def coutEnqueteur : Int := 65000
/-- Heures de soin libérées par an, milliers. -/
def heuresLibereesMilliers : Int := generalistesLiberaux * heuresLibereesCentiemes * semainesTravaillees10 / 1000000
/-- Équivalents temps plein de généralistes (44,5 h de soins × 45,8 semaines). -/
def etpGeneralistesLiberes : Int := heuresLibereesMilliers * 1000 * 10 / (445 * semainesTravaillees10 / 10)
/-- Consultations possibles (18 min), milliers. -/
def consultationsMilliers : Int := heuresLibereesMilliers * 60 / 18
/-- Coût pour l'assurance maladie si elles sont réalisées, M€. -/
def coutConsultations : Int := consultationsMilliers * 30 * 700 / 1000000

/-- Désindexation des très hautes retraites (O-28). ≈ 17 millions de
retraités de droit direct ; 1 % perçoivent plus de 5 150 € bruts par mois,
6 470 € en moyenne (DREES, cité par le Journal de l'économie, août 2026).
Retenu : la revalorisation ne porte plus que sur la part de la pension sous
`seuilTresHautesRetraites` = 5 150 € (pas d'effet de seuil ni d'inversion de
rang) ; part au-delà : 170 000 × 1 320 € × 12 ≈ 2,69 Md€ en 2025, soit
`masseAuDelaSeuil` ≈ 2,85 Md€ en 2027 (× 1,057, tendance). Revalorisation
évitée : `inflationPb` = 180 (hypothèse : 1,8 % d'inflation, cohérente avec
3 % de croissance nominale et 1,2 % réelle). Économie après k + 1 gels, en
euros de 2027 : masse × (1 − 1/1,018^(k+1)). Suppose une loi s'appliquant
aussi aux régimes complémentaires (Agirc-Arrco, gérés par les partenaires
sociaux). Variante : gel de toute la pension au-delà du seuil (13,2 Md€ en
2025, 13,95 Md€ en 2027), avec effets de seuil. -/
def retraitesTresHautes : Int := 170000
def seuilTresHautesRetraites : Int := 5150
def pensionMoyenneTresHautes : Int := 6470
def inflationPb : Int := 180
def masseAuDelaSeuil : Int :=
  retraitesTresHautes * (pensionMoyenneTresHautes - seuilTresHautesRetraites) * 12 * 10570 / 10000000000
def masseTresHautes : Int := retraitesTresHautes * pensionMoyenneTresHautes * 12 * 10570 / 10000000000
def desindexation (masse : Int) : List Int :=
  (List.range 20).map fun k =>
    -(masse * ((10000 + inflationPb) ^ (k + 1) - (10000 : Int) ^ (k + 1)) / (10000 + inflationPb) ^ (k + 1))

/-- TVA (O-29) : taux normal porté de 20 % à 23 %, taux intermédiaire de
10 % à 11 %, taux réduit de 5,5 % à 6 % (6,5 % dans la version précédente) ; taux super-réduit de
2,1 % inchangé. Mesure appelée à être temporaire, le temps de rétablir les
comptes (préambule). Rendement d'un point (FIPECO, fiche « La TVA »,
2025) : taux normal ≈ 8,2 Md€, taux de 10 % 1,6 Md€, taux de 5,5 %
2,3 Md€ ; rendement statique `tvaHausse` = 3 × 8,2 + 1,6 + 2,3 / 2
= 27,35 Md€ (calcul), net de la fuite fiscale du modèle. Variantes : taux normal seul à 23 % (24,6 Md€) ;
version précédente du programme, taux normal à 22 % (16,4 Md€). -/
def tvaPointNormal : Int := 8200
def tvaPointIntermediaire : Int := 1600
def tvaPointReduit : Int := 2300
def tvaHausse : Int := 3 * tvaPointNormal + tvaPointIntermediaire + tvaPointReduit / 2

theorem tvaHausse_eq : tvaHausse = 27350 := by decide

/-- Jets privés (O-30) : taxe forfaitaire de `taxeAtterrissage` = 3 000 € par
atterrissage. 84 885 vols de jets privés au départ de la France en 2022
(Greenpeace, repris par la proposition de loi n° 1741) ; atterrissages pris
égaux : `atterrissagesJets` = 85 000. Rendement statique 255 M€ ; la fuite
fiscale du modèle (20 % au scénario central) représente le report vers les
aéroports frontaliers et la baisse des vols. Variante : 1 000 €. -/
def atterrissagesJets : Int := 85000
def taxeAtterrissage : Int := 3000

/-- Conversion électrique des exploitations agricoles (O-31). 389 000
exploitations (recensement agricole 2020). Énergie de l'agriculture et de la
pêche : 52,1 TWh, dont 71 % de produits pétroliers (≈ 37 TWh, ≈ 3,7 Md de
litres ; ministère de la Transition écologique, Chiffres clés de l'énergie
2022), soit ≈ 10 Mt de CO₂ (0,27 t/MWh) : `emissionsEnergieAgricole`.
Plan sur dix ans : aide de `aideConversion` = 30 000 € par exploitation
(hypothèse : moitié d'un surcoût de 60 000 € pour les engins, la recharge
et une production photovoltaïque), soit ≈ 1,17 Md€ par an ; −1 Mt par an.
Commerce extérieur : carburant importé évité ≈ 2,0 Md€ (3,7 Md de litres ×
0,55 € hors taxes), électricité non exportée ≈ 0,84 Md€ (≈ 12 TWh au
rendement électrique, × 70 €/MWh) : −116 M€ d'importations nettes par an.
Les engins lourds électriques restent peu disponibles : l'objectif de
toutes les exploitations en dix ans est un plafond. -/
def exploitationsAgricoles : Int := 389000
def aideConversion : Int := 30000
def emissionsEnergieAgricole : Int := 10
def carburantAgricoleImporte : Int := 2000
def electriciteNonExportee : Int := 840

/-- DPE et climatisation réversible (O-32). Suppression du DPE pour les
immeubles de Paris et des autres quartiers historiques : pas d'effet
budgétaire ; évite le retrait du marché locatif des logements classés F et
G (interdiction de location, loi Climat et résilience). Climatisation
réversible (pompe à chaleur air-air) aidée : `logementsClimatisation` =
50 000 par an × `aideClimatisation` = 2 000 € = 100 M€ par an pendant dix
ans (hypothèses). Émissions : le remplacement du chauffage fossile (≈ 1 t
par logement et par an pour la moitié des logements équipés) et le moindre
effort de rénovation se compensent à moins de 1 Mt : effet non retenu. -/
def logementsClimatisation : Int := 50000
def aideClimatisation : Int := 2000

/-- Urbanisme (O-33). Interdiction des immeubles de grande hauteur dans les
quartiers historiques : sans effet budgétaire. Quartiers nouveaux autour des
pôles très desservis (Val de Fontenay : RER A et E, métro 1 et 15, tramway
T1) : aide aux équipements publics de `aideLogementQuartierGare` = 10 000 €
pour `logementsQuartiersGare` = 20 000 logements par an (hypothèses), soit
200 M€ par an d'investissement. -/
def logementsQuartiersGare : Int := 20000
def aideLogementQuartierGare : Int := 10000

/-- TER 24 h sur 24 (O-34) entre métropoles et villes moyennes (Paris –
Orléans…), avec agents de sécurité à bord, en gare et dans les parkings.
`liaisonsTerNuit` = 20 liaisons de `distanceTerKm` = 100 km ; de 0 h à 5 h,
un train par heure et par sens (`trainsParNuit` = 10). Coût :
`coutTrainKmCentimes` = 2 340 (23,40 € par train-km, moyenne des TER sous
convention SNCF, IFRAP 2024) ; sécurité : `heuresAgentsParNuit` = 46 (10 à
bord, 24 en gare, 12 aux parkings) à `coutHeureAgent` = 35 €. Recettes :
`couvertureRecettesPm` = 250 (hypothèse). La nuit est aussi la plage des
travaux d'entretien du réseau : contrainte d'exploitation non chiffrée. -/
def liaisonsTerNuit : Int := 20
def distanceTerKm : Int := 100
def trainsParNuit : Int := 10
def coutTrainKmCentimes : Int := 2340
def heuresAgentsParNuit : Int := 46
def coutHeureAgent : Int := 35
def couvertureRecettesPm : Int := 250
def coutTerNuit : Int :=
  liaisonsTerNuit * 365 * (trainsParNuit * distanceTerKm * coutTrainKmCentimes / 100
    + heuresAgentsParNuit * coutHeureAgent) * (1000 - couvertureRecettesPm) / 1000000000

/-- Redressement des comptes (O-36 à O-42 ; la taxe Zucman, O-35, a été
retirée). Base :
amendements déposés à l'Assemblée (16 septembre 2026 : taxe
Zucman 15 Md€, CSG sur les gros héritages 10 Md€, taxe sur les géants du
numérique 10 Md€, reconfiguration des exonérations de cotisations 4 Md€,
12,1 Md€ d'économies par la lutte contre la fraude fiscale et le train de
vie de l'État), complétées par la note de la Cour des comptes sur la
fiscalité du patrimoine (septembre 2026) et une revue des niches fiscales.
Les rendements sont statiques ; le modèle retire sa fuite fiscale (20 % au
scénario central) et calcule l'effet d'activité.

* Taxe Zucman (ancienne O-35) : retirée du programme.
* `csgHeritages` = 20 Md€ : le double du chiffrage de l'amendement de
  septembre 2026 (10 Md€, sans contre-expertise connue ; 10 Md€ en
  variante), relevé en novembre 2026 pour rapprocher le déficit de 2035 de
  2 % (droits de succession et donations : 20,7 Md€ en 2025). Imputée à la
  ligne des droits de succession, dont elle partage l'assiette ; le modèle
  retire la fuite des transmissions (15 % au scénario central). Avec les
  autres mesures sur les transmissions (O-41, O-152, O-167), le total
  dépasse les réformes de l'héritage simulées par le Conseil d'analyse
  économique (+9,3 à +19 Md€ par an, statique, Focus n° 077, 2021) :
  risque d'évitement au-delà de la fuite retenue (donations anticipées,
  assurance-vie, expatriation).
* `taxeNumerique` = 3,1 Md€ : taxe sur les services numériques de 3 % à
  15 %, 0,89 → ≈ 4 Md€ (commission des finances, octobre 2026).
  L'amendement annonce 10 Md€ (variante). Risque de représailles commerciales.
* `exonerationsCotisations` = 4 Md€ : reconfiguration des allègements
  généraux (chiffrage de l'amendement). Comme O-56 et O-61, réduction des allègements
  au prorata des tranches de salaire (levier `reductionAllegements` : coût
  du travail et emploi par tranche, modèle commun) ; O-76 en recentre le
  reste sous 2 SMIC.
* `trainDeVieEtat` = 3,1 Md€ : part « train de vie » des 12,1 Md€ annoncés,
  moins O-21 (commande publique, 3 Md€). La fraude fiscale fait l'objet
  d'une mesure propre (O-45).
* `nichesFiscales` = 8 Md€ : 465 niches pour 88,3 Md€ en 2026 (PLF 2026) ;
  −10 % hors Pacte Dutreil (traité à part) et hors dispositifs pour les
  ménages modestes, réparti entre IR (4), IS (2) et TVA (2).
* `pacteDutreil` = 1,95 Md€ : Pacte Dutreil divisé par deux, abattement de
  75 % à 37,5 %. La Cour des comptes (note du 21 septembre 2026) chiffre à
  1,3 Md€ le passage à 50 % (25 points, pactes futurs, comportements
  inchangés) ; même méthode, proportionnelle aux points d'abattement
  retirés : 1,3 × 37,5 / 25 = 1,95 Md€ (le dispositif coûtait 5,5 Md€ en
  2024). `holdings` = 1,0 Md€ (taxe sur les holdings élargie, même note).
* `normeDepense` = 50 pb : les dépenses pilotables (santé, affaires
  économiques, sécurité-justice, logement-environnement, culture, services
  généraux ; ≈ 739 Md€ en 2025) croissent de 2,3 % au lieu de 2,8 % par an,
  soit +0,5 % en volume pour 1,8 % d'inflation. Retraites, famille,
  enseignement et défense sont hors norme. Variante : zéro volume (100 pb).
-/
def csgHeritages : Int := 20000
def taxeNumerique : Int := 3100
def exonerationsCotisations : Int := 4000
def trainDeVieEtat : Int := 3100
def nichesFiscales : Int := 8000
def pacteDutreil : Int := 1950

/-- Défense (O-43) : −1 Md€ par an sur le budget de la défense (53 Md€ en
2025, COFOG), hors norme de dépense, par rapport à la trajectoire de la LPM
actualisée (loi n° 2026-791, 75,7 Md€ en 2030) que la référence applique. -/
def economieDefense : Int := 1000

/-- Durée de cotisation (O-44) : 174 trimestres au lieu de 172, soit six mois
de plus pour les départs liés à la durée. Sans âge légal (O-07), la durée est
la contrainte de la plupart des départs : plus de neuf retraités sur dix
liquident au taux plein, surtout au titre de la durée (COR, génération 1950) ;
les carrières incomplètes partent à l'âge du taux plein automatique.
`partDepartsDuree` = 800 ‰ (hypothèse) : âge moyen de départ reculé de
6 × 0,8 = 4,8 mois (levier `dureeCotisation`). Coût et actifs par mois : hypothèses économiques du
scénario (réforme de 2023). -/
def partDepartsDuree : Int := 800
def holdings : Int := 1000
def normeDepensePb : Int := 50

/-- Lutte contre la fraude fiscale (O-45), distincte de la fraude sociale et
de la TVA du travail dissimulé (O-23).
* Écart de TVA (conformité) : 12,1 Md€ en 2023, 5,6 % de la TVA théorique ;
  16,5 Md€ en estimation rapide pour 2024 (Commission européenne, VAT gap
  report 2025).
* Facturation électronique (émission obligatoire pour les grandes
  entreprises et ETI en septembre 2026, pour toutes en septembre 2027) :
  l'administration en attend 2 à 3 Md€ par an à terme (question écrite
  n° 17870, Assemblée nationale, 2026) : `fraudeFacturation` = 2,5 Md€ de
  TVA à partir de 2028.
* Contrôle fiscal : 11,4 Md€ encaissés en 2024 (+0,8 Md€ sur 2023), après
  ≈ 800 emplois créés en trois ans (DGFiP) ; la Cour des comptes (décembre
  2025) demande de chiffrer l'écart fiscal et d'évaluer le croisement de
  données. `agentsControle` = 1 500 agents de plus (vérificateurs,
  analystes de données) à `coutAgentControle` = 70 000 € ; encaissements
  supplémentaires `rendementControle` = 1,5 Md€ par an (hypothèse : ≈ 1 M€
  par agent, ordre de grandeur de la hausse récente), répartis entre IR,
  IS et TVA.
Le modèle applique sa fuite fiscale à ces recettes. -/
def fraudeFacturation : Int := 2500
def agentsControle : Int := 1500
def coutAgentControle : Int := 70000
def rendementControle : Int := 1500

/-- CSG progressive pour les hauts revenus (O-46) : +2 points de CSG sur la
part des revenus d'activité et de remplacement au-delà de `seuilCsgHauts`
= 100 000 € par an et par personne. Un point de CSG sur toute l'assiette
rapporte 17 Md€ (FIPECO, 2024). Part de l'assiette au-delà du seuil :
`partAssietteAuDelaPm` = 60 ‰ (hypothèse : ≈ 1 % des contribuables ;
extrapolation de Pareto, coefficient ≈ 2, depuis l'assiette de la
contribution exceptionnelle sur les hauts revenus, au-delà de 250 000 €).
Rendement statique : 2 × 17 Md€ × 6 % ≈ 2,0 Md€, net de la fuite fiscale
dans le modèle. À vérifier sur les données de la DGFiP. -/
def seuilCsgHauts : Int := 100000
def pointsCsgHauts : Int := 2
def partAssietteAuDelaPm : Int := 60
def rendementCsgHauts : Int := pointsCsgHauts * 17000 * partAssietteAuDelaPm / 1000

/-- Entreprises stratégiques (O-47) : 100 M€ par an de prises de participation
de l'État. Opération financière : dette sans déficit ; les dividendes suivent
le rendement du portefeuille de l'APE (4,0 Md€ de dividendes 2025 pour
209,1 Md€, soit ≈ 1,9 %). -/
def participationsStrategiques : Int := 100

/-- Concessions autoroutières (O-48) : pas de renouvellement à l'échéance,
exploitation publique, péages maintenus. Échéances (Arafer, 2018) : Sanef
31/12/2031, Escota 29/02/2032, SAPN 31/08/2033, APRR 30/11/2035, ASF
30/04/2036, AREA 30/09/2036, Cofiroute 31/12/2034 (réseau interurbain ; le
tunnel A86 Duplex court jusqu'en 2086, part négligeable : VINCI, document
d'enregistrement universel 2024).

Secteur en 2023 (Autorité de régulation des transports) : EBITDA 9,1 Md€,
dont ≈ 8,5 Md€ pour les sociétés historiques (93 % du réseau) ;
investissements 1,5 Md€ (92 % pour les historiques, ≈ 1,4 Md€) ; dividendes
4,1 Md€, soit l'ordre de grandeur du bénéfice net, d'où un IS estimé à
≈ 1,4 Md€ (taux de 25,8 %). Parts par société (‰ de l'EBITDA des
historiques), d'après la répartition des dividendes par groupe (ASF-Escota
40,6 %, APRR-AREA 24,3 %, Cofiroute 16 %, Sanef-SAPN 15,1 %) et la
longueur relative des réseaux dans chaque groupe (hypothèse).

Gain pour les administrations publiques à l'échéance : EBITDA − investissements
de renouvellement, recette non fiscale ; IS des concessionnaires en moins.
Une concession est comptée à partir de la première année pleine qui suit son
échéance (prudent). Valeurs 2023 portées en 2027 par la croissance nominale
(× 1,1255). Variante : baisse des péages de 20 % à la reprise. -/
def ebitdaHistoriques : Int := 8500
def investissementsHistoriques : Int := 1400
def isHistoriques : Int := 1400
def indice2023a2027 : Int := 11255
/-- (société, part en ‰, première année pleine après l'échéance, comptée depuis 2027). -/
def concessions : List (String × Int × Nat) :=
  [("Sanef", 118, 5), ("Escota", 76, 6), ("SAPN", 39, 7), ("APRR", 197, 9),
   ("ASF", 347, 10), ("AREA", 56, 10), ("Cofiroute", 167, 8)]
/-- Part du réseau historique revenue à l'État l'année `k` (comptée depuis 2027), ‰. -/
def partReprise (k : Nat) : Int :=
  concessions.foldl (fun acc (_, pm, an) => if an ≤ k then acc + pm else acc) 0
/-- Échéancier (20 ans) d'une grandeur 2023 répartie selon les reprises, M€ de 2027. -/
def echeancierReprise (montant2023 : Int) (facteurPm : Int := 1000) : List Int :=
  (List.range 20).map fun k =>
    montant2023 * indice2023a2027 / 10000 * partReprise k / 1000 * facteurPm / 1000

/-- Hauts fonctionnaires (O-49) : −5 % de rémunération pour l'encadrement
supérieur et dirigeant des trois versants. DGAFP (fin 2012) : 9 900 agents
dans l'État (7 700 € bruts par mois en moyenne), 5 600 dans l'hospitalière
(6 603 €), 6 000 dans la territoriale (5 898 €), soit 1 783 M€ bruts par an ;
× 1,10 pour 2025 (point d'indice et primes, hypothèse) et × 1,5 pour le coût
complet (cotisations employeur) : ≈ 2,94 Md€. Économie : 147 M€, dont 75 %
sur les services généraux (État et collectivités) et 25 % sur la santé. -/
def masseHautsFonctionnaires : Int := 1783 * 110 / 100 * 150 / 100
def economieHautsFonctionnaires : Int := masseHautsFonctionnaires * 5 / 100

/-- Revenus des élus (O-50) : plafond de 10 000 € par mois pour l'ensemble des
mandats et fonctions. Le droit en vigueur plafonne déjà le cumul des
indemnités et rémunérations à une fois et demie l'indemnité parlementaire de
base, soit 8 897,93 € bruts par mois depuis le 1er janvier 2024 (article
L. 2123-20 II du CGCT ; Ville de Paris, 2025). Un plafond de 10 000 € est
donc moins strict : la mesure n'a d'effet qu'en étendant le plafond aux
rémunérations qui y échappent (organismes extérieurs, sociétés publiques),
dont le montant n'est pas publié. Enregistrée pour mémoire, sans effet
budgétaire. -/
def plafondElus : Int := 10000
def plafondCumulActuel : Int := 8898

/-- Fin du prélèvement forfaitaire unique (O-51) : retour au barème de l'IR
pour les revenus du capital. Coût du PFU chiffré par l'État : 1,3 Md€ en
2018 et 1,9 Md€ en 2019 (chiffrage statique), ≈ 1,8 Md€ (annexe économique
du PLF 2022) ; France Stratégie : 1,4 à 1,7 Md€ par an de façon durable
(Sénat, octobre 2019). Retenu : 1,8 Md€ statiques (3,4 Md€ dans la version
précédente, chiffrage non officiel). Le comité d'évaluation de France
Stratégie (2023) juge que la réforme s'est probablement autofinancée les
premières années, les dividendes passant de 14 à 23 Md€ par an : variante
sans rendement, si les dividendes reviennent à leur niveau d'avant 2018. Interaction avec O-24 : les intérêts
des OAT numériques restent exonérés. -/
def finPfu : Int := 1800

/-- Rachats d'actions (O-52) : taxe de 8 % (loi de finances pour 2025,
entreprises de plus de 1 Md€ de chiffre d'affaires) portée à 20 %. Un
amendement à 33 % annonçait 8,4 Md€, soit une assiette implicite d'environ
25 Md€ ; +12 points donneraient 3 Md€ mécaniquement. Les entreprises peuvent
remplacer les rachats par des dividendes : rendement retenu 1,5 Md€ (moitié,
hypothèse). -/
def rachatsActions : Int := 1500

/-- Cabinets de conseil (O-53) : dépenses de conseil des ministères 893,9 M€
en 2021 (commission d'enquête du Sénat, 2022). Division par deux, au profit
de l'expertise interne : `economieConseil` = 400 M€ (sur une base supposée
ramenée à 800 M€ depuis la circulaire de 2022). -/
def economieConseil : Int := 400

/-- Trajectoire de baisse continue du déficit (O-54 à O-58). Sans elles, le
déficit du Texte Orientation D baisse en 2027 puis remonte d'environ
0,2 point par an : la charge d'intérêts passe de 2,6 % à 4,6 % du PIB, le
taux apparent rejoignant le taux de marché. Pour qu'il baisse chaque année,
il faut des mesures dont le rendement croît chaque année plus vite que les
intérêts :

* O-54 : prolongation de la CRDS au-delà de 2033 pour amortir la dette de
  l'ACOSS (59,4 Md€ fin 2025, ≈ 65 Md€ fin 2026, sans ressource dédiée) :
  9,55 Md€ (euros 2027) à partir de 2034 ; loi organique nécessaire.
* O-55 : norme de dépense renforcée de 150 pb (soit 200 pb avec O-42) :
  dépenses pilotables à +0,8 % par an en valeur, ≈ −1 % en volume (200 pb,
  ≈ −1,5 % en volume, d'octobre au 5 novembre 2026 ; ramenée à 150 pb : au
  scénario central, ≈ 114 000 emplois de plus en 2035, déficit +0,2 point).
  Amendement d'octobre 2026 : 100 pb dans la version initiale ; les
  100 pb de plus avaient été retenus pour tenir le déficit sous 3 % en 2035
  sous les trois moteurs, avant le calcul du PIB par la demande.
* O-56 : aides aux entreprises (211 Md€ selon la commission d'enquête du
  Sénat, juillet 2025) : exonérations de cotisations réduites de 1,5 Md€
  par an pendant six ans (9 Md€ en 2032), en les conditionnant.
* O-57 : niches fiscales : −2 % par an pendant cinq ans en plus de O-40
  (≈ 2 Md€ par an : IR 1, IS 0,5, TVA 0,5).
* O-58 : durée de cotisation +1 trimestre tous les trois ans à partir de
  2028, dans la logique de la réforme de 2014 : +1 mois de durée requise
  par an, 80 % des départs concernés (`partDepartsDuree`). Raison donnée
  par l'auteur (novembre 2026) : la baisse de la natalité. Fécondité de
  1,61 en 2024 et 1,56 en 2025, la plus basse depuis la fin de la Première
  Guerre mondiale, solde naturel négatif en 2025 pour la première fois
  depuis 1945 (Insee Première n° 2087, janvier 2026) ; 1,45 retenu par
  l'Insee à partir de 2028 (projections de juin 2026) ; selon le COR
  (rapport 2026), 1,8 cotisant par retraité en 2025 et 1,3 en 2070, et une
  fécondité de 1,2 dégraderait le solde de 2070 d'environ 1 point de PIB,
  l'effet n'apparaissant qu'après 2045 : un allongement progressif et
  continu répond à cette tendance de long terme.
-/
def crdsProlongee : List Int := (List.range 20).map fun k => if k < 7 then 0 else 9550
/-- Plafond de la modération des normes de dépense appliquée à la santé
(O-55b), pb par an : 1 point (parmi
0,5, 1 et 1,5 : à 1 point, l'espérance de vie reste au niveau tendanciel
et 26 propriétés sont tenues ; à 0,5, 24 ; à 1,5, 27 mais −0,13 an). -/
def plafondNormeSantePb : Int := 100
def normeRenforceePb : Int := 150
def baisseAidesEntreprises : Int := 1500
def rabotNiches : Int := 2000

/-- Lois de finances en vigueur que la référence applique désormais (O-59,
O-60) :

* O-59 : la CVAE disparaît par étapes (0,28 % en 2027, 0,19 % en 2028,
  0,09 % en 2029, 0 en 2030 ; loi n° 2025-127, art. 62). Son maintien à
  0,28 % rapporte, par rapport à la référence, 1,09 puis 2,31 puis
  3,4 Md€ (euros 2025), soit ×1,0609 en euros 2027 (croissance nominale de
  3 % par an du scénario central) : `cvaeMaintenue`.
* O-60 : la contribution exceptionnelle sur les bénéfices des grandes
  entreprises (7,5 Md€ en 2026) n'est pas reconduite à législation
  constante. Pérennisée aux taux de 2026 (20,6 % et 41,2 % de l'IS dû au-delà
  de 1,5 et 3 Md€ de chiffre d'affaires), elle porte sur l'IS des seuls
  grands groupes, tous soumis au pilier 2 : avec O-08, leur taux effectif
  est de 15 %, d'où 7,5 × 15 / 25 = 4,5 Md€ (euros 2026), 4,64 Md€ en euros
  2027 : `contributionGrandesEntreprises`. -/
def cvaeMaintenue : List Int := [0, 1156, 2451, 3607]

/-- Deuxième étape de la trajectoire (O-61, O-62). Une fois la référence
complétée par les lois en vigueur (LPM actualisée, érosion des accises par
l'électrification, fin de la contribution exceptionnelle et de la CVAE),
le déficit du Texte Orientation D stagne de 2029 à 2032 (≈ 4,6 %) : la
LPM monte jusqu'en 2030, la charge d'intérêts continue de croître et l'âge
moyen de départ cesse de suivre le calendrier légal en 2032 (O-07). Il
faut ≈ 1,5 à 2 Md€ de rendement supplémentaire chaque année de 2029 à 2032
(un peu plus du double en statique, la moitié étant reprise par la baisse
d'activité au moteur de demande) :

* O-61 : aides aux entreprises, deuxième étape : exonérations de
  cotisations réduites de 1,5 Md€ de plus chaque année de 2029 à 2034, sous
  conditions (emploi, salaires, investissement) ; avec O-38 et O-56, 22 Md€
  sur ≈ 80 Md€ d'allègements généraux en 2034.
* O-62 : niches fiscales : −1,5 Md€ de plus chaque année de 2029 à 2035
  (−1 Md€ dans la version précédente ; relevé avec le modèle affiné pour
  que le déficit baisse chaque année sous les trois moteurs) ; avec O-40 et
  O-57, 28,5 Md€ sur 88,3 Md€ de dépenses fiscales en 2035 (hors Pacte
  Dutreil, traité par O-41, et dispositifs des ménages modestes). -/
def aidesSecondeEtape : Int := 1500
def nichesSecondeEtape : Int := 1500

/-- Deuxième journée de solidarité (O-84) : sept heures de travail non
rémunérées de plus par an (+0,44 % de durée annuelle du travail sur
1 607 heures, levier `dureeTravail`), contribution de solidarité pour
l'autonomie des employeurs portée de 0,3 % à 0,6 % de la masse salariale,
affectée à l'autonomie (dépense de santé, au sens de la nomenclature du
modèle). Reprend la contribution de solidarité par le travail votée par le
Sénat le 20 novembre 2024 (PLFSS 2025, amendement adopté par 216 voix
contre 119), chiffrée à ≈ 2,5 Md€ par an.

Retirée du programme le 5 novembre 2026. La suppression de la journée
existante qui l'a remplacée (O-222) a été retirée le même jour : la journée de 2004 et sa
contribution de 0,3 % restent dans la référence. Ces paramètres servent aux
options chiffrées (suppression de la journée, deuxième journée). -/
def heuresSolidaritePm : Int := 4
def contributionSolidariteAutonomie : Int := 2500

/-- Santé mentale (O-85) : 100 M€ de moyens de plus par an. Ordre de
grandeur : 23 Md€ remboursés chaque année par l'Assurance maladie pour les
troubles psychiques et les maladies psychiatriques, son premier poste de
dépenses (La Banque Postale, d'après le ministère de la Santé, 24 avril
2025) ; la santé mentale est grande cause nationale 2025. -/
def santeMentale : Int := 100

/-- Liberté fiscale des collectivités (O-86). Taxe foncière : chaque commune
vote son taux, au plus 2,5 fois le taux moyen de l'année précédente dans le
département ou en France (CGI, art. 1636 B septies : plafond de 99,35 % en
2025 pour un taux moyen national de 39,74 %, DGCL), et sous les règles de
lien entre les taux (art. 1636 B sexies) ; la mesure lève plafond et liens.
Taxe d'habitation des résidences principales, supprimée de 2020 à 2023 :
15,3 Md€ perdus par les communes et 7,5 Md€ par les intercommunalités, tous
compensés (DGCL, FAQ de la refonte de la fiscalité locale) ; la mesure
permet de la rétablir, les compensations restant acquises. Sans effet sur
le solde à taux inchangés ; le rétablissement partiel est évalué en
variante. -/
def produitTaxeHabitation : Int := 15300 + 7500

/-- Référendum d'initiative citoyenne (O-87), par révision de la
Constitution (article 89). Un référendum coûte ≈ 200 M€, ≈ 100 M€
dématérialisé (ministre de l'Intérieur, RTL, 11 mai 2025, via Acteurs
publics). Hypothèse : un scrutin par an, non couplé à une élection. -/
def coutReferendum : Int := 200

/-- Médecins scolaires (O-88) : 818 en 2022 contre 1 143 en 2013 (Sénat,
proposition de loi du 13 mars 2024), un pour 13 300 élèves, 44 % des postes
vacants (La Revue du praticien, 19 janvier 2026) ; la Cour des comptes
(avril 2020) juge une revalorisation « indispensable ». La mesure double
l'effectif : 800 médecins de plus en quatre ans (un pour 6 700 élèves
environ), à 100 000 € par médecin et par an, traitement, indemnités
revalorisées pour pourvoir les postes et cotisations de l'employeur
comprises (hypothèse). -/
def medecinsScolairesNouveaux : Int := 800
def coutMedecinScolaireEuros : Int := 100000

/-- Octroi de mer (O-89) : 1,644 Md€ de recettes nettes en 2022 (Cour des
comptes, 5 mars 2024, via economie.gouv.fr), dont 75,8 % pour les communes
(32 % de leurs produits de gestion), le reste pour les régions ; +4,64 % par
an de 2014 à 2022, prolongés jusqu'en 2025 : 1 883 M€ (calcul). Suppression
compensée aux collectivités par une dotation de l'État : la recette
disparaît, les prix baissent dans les cinq départements et régions
d'outre-mer. -/
def octroiDeMer2025 : Int := 1644 * 10464 * 10464 * 10464 / 1000000000000

theorem octroiDeMer2025_eq : octroiDeMer2025 = 1883 := by decide

/-- Pompes à chaleur gratuites en zone rurale (O-90) : 100 000 par an
(hypothèse : un million de maisons en dix ans, sur plus de 1,56 million de
résidences principales rurales chauffées au fioul, Insee Première
n° 2088), à 14 700 €, coût moyen d'une PAC air/eau (gouvernement, « Pompes
à chaleur, l'industrie au service de la planification écologique »). Elles
consomment une part du surplus d'électricité que le nucléaire module faute
de débouchés. Les logements qui quittent le gaz de réseau évitent ≈ 67 €
par an de charges d'exploitation au gestionnaire du réseau, reversés au
financement de la mesure (hypothèse de transcription) ; chaleur,
coefficient de performance, énergies remplacées, taxes : voir
`Hypotheses.Energie.pompesAChaleur`. -/
def pacRuralesParAn : Int := 100000
def coutPacEuros : Int := 14700

/-- Zones d'électrification industrielle (O-91), à tarif d'électricité
négocié et hors ZAN.
* Électricité : les zones portent la consommation de l'industrie de la
  trajectoire « décarbonation lente » (+4 TWh de 2024 à 2030) à la
  trajectoire « rapide » (+13 TWh) du bilan prévisionnel 2025 de RTE, soit
  9 TWh de plus, atteints en cinq ans ; à 40 % de facteur de charge
  (hypothèse de RTE pour les projets industriels), 2 568 MW de projets
  (calcul).
* Emplois : 4 700 emplois annoncés à Dunkerque (ProLogium 3 000, XTC-Orano
  1 700 ; AFP) pour 1 615 MW de raccordements signés (CRE, délibération
  2026-21 du 27 janvier 2026), soit 7 473 emplois industriels (calcul).
* Foncier : 35 000 emplois sur 3 026 ha de sites industriels clés en main
  commercialisés depuis 2019 (DGE, 16 octobre 2026), soit 646 ha (calcul),
  exemptés de l'enveloppe du ZAN.
* Tarif : contrats de long terme d'EDF (cible de 70 €/MWh en moyenne de
  l'accord État-EDF de 2023) pour une électricité que le parc nucléaire
  module faute de débouchés : sans coût budgétaire ; le gain d'EDF n'est
  pas compté. -/
def zonesGwh : Int := 13000 - 4000
def zonesMw : Int := zonesGwh * 1000 / 3504
def zonesEmplois : Int := zonesMw * 4700 / 1615
def zonesHa : Int := zonesEmplois * 3026 / 35000

theorem zones_valeurs : zonesMw = 2568 ∧ zonesEmplois = 7473 ∧ zonesHa = 646 := by decide

/-- Déserts médicaux (O-92) : aide à la première installation d'un médecin
généraliste en zone d'intervention prioritaire (ZIP) portée à 50 000 €,
montant de l'ancien contrat d'aide à l'installation (CAIM), au lieu de
10 000 € depuis le 1er janvier 2026 (convention médicale de 2024) ; puis
5 000 € par an pendant cinq ans à chaque médecin installé, montant de
l'ancien contrat de stabilisation (COSCOM). 891 premières installations
de généralistes en ZIP en 2025 (Cnam, 11 juin 2026). La Cour des comptes
(12 novembre 2025) juge ces aides peu efficaces hors exercice coordonné :
l'effet sur l'accès aux soins n'est pas chiffré. -/
def installationsZip : Int := 891
def aideInstallationZip : Int := 50000 - 10000
def primeExerciceZip : Int := 5000
def primesZip : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => installationsZip * primeExerciceZip * k / 1000000

/-- Minimum de pension des retraités agricoles (O-93) : garantie des chefs
d'exploitation à carrière complète portée de 85 % à 100 % du SMIC net
agricole (85 % : 1 214,40 € par mois en 2026, soit +214,30 € au plancher).
224 681 bénéficiaires du complément différentiel fin 2025 (MSA, tableau de
bord des retraites des non-salariés agricoles, septembre 2026) :
224 681 × 214,30 € × 12 = 577 M€ par an (calcul ; trop haut pour les
carrières incomplètes, dont la garantie est proratisée, trop bas faute des
nouveaux bénéficiaires entre 85 % et 100 %). -/
def minimumAgricole : Int := 224681 * 21430 * 12 / 100000000

theorem minimumAgricole_eq : minimumAgricole = 577 := by decide

/-- Emplois aidés dans l'industrie (O-94) : 20 000 contrats initiative
emploi en cours dans l'industrie (hypothèse), aide de 47 % du SMIC brut,
plafond du CIE (circulaire FIE 2025), sur un temps plein : 10 160 € par
contrat et par an (calcul) ; 0,16 emploi net par CIE (Dares, via FIPECO,
19 septembre 2017) : aubaine et substitution de 840 pm. -/
def contratsIndustrie : Int := 20000
def aideCieEuros : Int := 10160

/-- Divisions régionales de cybersécurité de la police (O-95) : une division
dans chacune des 18 régions (13 en métropole, 5 outre-mer), de 50
enquêteurs et ingénieurs, pour les enquêtes et l'appui aux victimes
(entreprises, collectivités, particuliers), en plus de l'Office
anti-cybercriminalité (OFAC), qui doit passer de 380 à 720 enquêteurs et de
18 à 45 antennes d'ici 2027 (Le Figaro, via Next, 22 janvier 2024). Coût
d'un agent : coût moyen d'un emploi de la police nationale, 12,09 Md€ de
crédits de personnel pour 153 285 ETPT (PLF 2026, programme 176 ; calcul :
78 872 €) ; recrutement en trois ans ; laboratoire de criminalistique
numérique : 1 M€ par division (hypothèse). -/
def divisionsCyber : Int := 18
def agentsCyber : Int := divisionsCyber * 50
def coutAgentPoliceEuros : Int := 12090000000 / 153285
def coutCyberPolice : Int := agentsCyber * coutAgentPoliceEuros / 1000000

theorem cyberPolice_valeurs : coutAgentPoliceEuros = 78872 ∧ agentsCyber = 900 ∧ coutCyberPolice = 70 := by decide

/-- Revenu minimum des nouveaux exploitants agricoles (O-96) : pendant les
cinq premières années d'installation, l'État complète le revenu
professionnel des chefs d'exploitation jusqu'au SMIC net. 43 % des
agriculteurs gagnent moins que le SMIC ; l'écart au SMIC a été de 3,3 Md€
par an en moyenne de 2015 à 2024 (5,22 Md€ en 2024 ; Observatoire de la
rémunération agricole équitable de Max Havelaar France, d'après l'Insee et
le ministère de l'Agriculture, 28 avril 2026). Installés depuis moins de
cinq ans : 5 × 12 661 installations (2024) sur 374 062 chefs
d'exploitation (MSA, 2024), 17 % ; leur part de l'écart, au prorata :
558 M€ par an une fois cinq promotions installées, une promotion de plus
chaque année (calcul ; les nouveaux installés ont souvent des revenus plus
faibles, mais un revenu négatif n'est complété que jusqu'au SMIC). -/
def installationsAgricoles : Int := 12661
def chefsExploitation : Int := 374062
def ecartSmicAgricole : Int := 3300
def revenuMinimumInstalles : Int := ecartSmicAgricole * (5 * installationsAgricoles) / chefsExploitation
def revenuMinimumRampe : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => revenuMinimumInstalles * k / 5

theorem revenuMinimumInstalles_eq : revenuMinimumInstalles = 558 := by decide

/-- Prime à l'installation des médecins outre-mer (O-97) : 100 000 € versés
en cinq ans (20 000 € par an, contre un engagement d'exercice de cinq ans)
à chaque médecin, généraliste ou spécialiste, qui s'installe à Mayotte ou
en Guyane, où la densité est de 76 et 261 médecins pour 100 000 habitants
contre 346 en France (Insee, 1er janvier 2025 : 251 et 762 médecins).
Atteindre la densité nationale demande 891 médecins à Mayotte et 248 en
Guyane (calcul) : 113 installations par an pour combler l'écart en dix
ans. La prime s'ajoute à l'aide d'O-92 en zone prioritaire ; la
Guadeloupe, la Martinique et La Réunion, à la densité nationale, n'y sont
pas éligibles. -/
def ecartMedecinsMayotte : Int := (346 - 76) * 251 / 76
def ecartMedecinsGuyane : Int := (346 - 261) * 762 / 261
def installationsOutreMer : Int := (ecartMedecinsMayotte + ecartMedecinsGuyane) / 10
def primesOutreMer (montantAnnuelEuros : Int) : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => installationsOutreMer * montantAnnuelEuros * k / 1000000

theorem medecinsOutreMer_valeurs :
    ecartMedecinsMayotte = 891 ∧ ecartMedecinsGuyane = 248 ∧ installationsOutreMer = 113 := by decide

/-- Accompagnement des entreprises en cybersécurité (O-98).
* Chèque cyber : 50 % des dépenses de sécurité, au plus 2 500 € pour une TPE
  et 10 000 € pour une PME, sur le modèle du chèque investissement cyber de
  l'Île-de-France (fermé le 21 février 2025) ; 40 000 TPE et 10 000 PME par
  an (hypothèse ; 16 % des TPE-PME ont subi un incident en douze mois, 77 %
  dépensent moins de 2 000 € par an en sécurité et 37 % demandent une aide
  financière : baromètre Cybermalveillance-OpinionWay, 7 octobre 2025) :
  200 M€ par an.
* Cybermalveillance.gouv.fr porté à 3 M€ de financement public, le minimum
  recommandé par le Sénat (subvention de l'ANSSI inchangée à 0,845 M€ par an
  depuis 2017 : Sénat, avis n° 141, 19 novembre 2025).
* CSIRT régionaux : 1 M€ par région métropolitaine sur trois ans, comme la
  première vague financée par l'ANSSI en 2022, arrêtée depuis : 13 M€ / 3
  par an.
Les cyberattaques ont coûté ≈ 2 Md€ aux entreprises en 2022 (Asterès) :
l'effet de la mesure sur ce coût n'est pas chiffré. -/
def chequesCyber : Int := (40000 * 2500 + 10000 * 10000) / 1000000
def cyberGipCsirt : Int := (3000 - 845 + 13000 / 3) / 1000

theorem chequesCyber_eq : chequesCyber = 200 ∧ cyberGipCsirt = 6 := by decide

/-- Amendes automatiques en cas de fuite de données (O-99), dans les
plafonds du RGPD : pour une entreprise qui n'est pas une PME (chiffre
d'affaires de plus de 50 M€, recommandation européenne 2003/361/CE), une
violation de données due à un défaut de sécurité (art. 32) et touchant plus
d'un million de personnes entraîne d'office l'amende maximale de l'article
83.4, 2 % du chiffre d'affaires mondial, au lieu d'une amende fixée au cas
par cas (Free : 42 M€ en janvier 2026, pour 24 millions de contrats
exposés). Environ 40 violations par an touchent plus d'un million de
personnes (CNIL, rapports 2024 et 2025) ; hypothèses : 10 par an dans des
entreprises de plus de 50 M€ de chiffre d'affaires (les autres touchent des
organismes publics, plafonnés à 10 M€, ou des sous-traitants plus petits),
1 Md€ de chiffre d'affaires médian, 95 % de recouvrement (taux de la CNIL
de 2019 à 2024) : 190 M€ par an versés au budget de l'État (calcul). Ce
produit baisserait à mesure que les entreprises se protègent, ce que le
modèle ne retient pas. Point juridique : l'article 83.2 du RGPD impose
d'apprécier chaque cas ; l'automaticité devra prendre la forme d'une
sanction nationale (article 84) ou passer par la loi de transposition de
NIS2, et reste à expertiser. -/
def fuitesAutomatiques : Int := 10
def caMedianFuitesMeur : Int := 1000
def amendesFuitesSupplementaires : Int := fuitesAutomatiques * caMedianFuitesMeur * 2 / 100 * 95 / 100

theorem amendesFuites_eq : amendesFuitesSupplementaires = 190 := by decide

/-- Douaniers et contrôles des produits importés (O-100) : 2 000 douaniers
de plus en trois ans, dont 1 220 pour revenir aux effectifs de 2019 (la
douane compte 16 500 agents ; 0,1 % des marchandises importées sont
contrôlées) et 780 affectés au contrôle de la conformité des produits
agricoles et industriels importés (normes, ajustement carbone aux
frontières) ; 52 000 € par emploi, coût moyen du programme 302 (amendement II-CF2611 du rapporteur Legavre, PLF 2026,
7 novembre 2025). Les droits et amendes recouvrés grâce aux contrôles ne
sont pas comptés. -/
def douaniersSupplementaires : Int := 1220 + 780
def coutDouanierEuros : Int := 52000
def coutDouaniers : Int := douaniersSupplementaires * coutDouanierEuros / 1000000

theorem coutDouaniers_eq : coutDouaniers = 104 := by decide

/-- Liberté d'installation des médecins et financement du fonds d'aide aux
déserts médicaux (O-101) : pas de régulation de l'installation ; les aides
d'O-92 (installation en zone prioritaire, primes d'exercice) et d'O-97
(Mayotte, Guyane) sont financées par une contribution annuelle des
médecins généralistes libéraux installés dans les zones les mieux dotées,
au montant exact de ces aides (41 M€ la première année, 68 M€ au
complet). Il n'existe pas de zonage « surdoté » pour les médecins (il en
existe pour les infirmiers, kinésithérapeutes, sages-femmes et dentistes) :
la zone est à définir par les ARS. Près de 52 500 généralistes libéraux
en activité fin 2025, hors médecins à expertise particulière (Cnam,
11 juin 2026) ; si un quart d'entre eux exercent en zone surdotée
(hypothèse), la contribution est de ≈ 5 200 € par an et par médecin au
complet (calcul), ≈ 1 300 € si elle portait sur tous. -/
def fondsDesertsMedicaux : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k =>
    installationsZip * aideInstallationZip / 1000000 + installationsZip * primeExerciceZip * k / 1000000
      + installationsOutreMer * 20000 * k / 1000000
def generalistesLiberaux2025 : Int := 52500
def generalistesZonesSurdotees : Int := generalistesLiberaux2025 / 4
def contributionMedecinEuros : Int := fondsDesertsMedicaux.getLastD 0 * 1000000 / generalistesZonesSurdotees

theorem fondsDeserts_valeurs :
    fondsDesertsMedicaux = [41, 47, 54, 61, 68] ∧ generalistesZonesSurdotees = 13125 ∧
    contributionMedecinEuros = 5180 := by decide

/-- Cotisations salariales réduites outre-mer (O-102) : −3 points sur les
salaires du secteur privé des cinq départements d'outre-mer, soit ≈ 90 €
nets de plus par mois au salaire moyen. Salariés du privé fin 2024 :
La Réunion 201 300, Mayotte 24 300 (Insee) ; Martinique 87 550 (131 850
salariés, dont ≈ 44 300 dans le public, d'après la baisse de 310 emplois,
−0,7 %) ; Guadeloupe (128 720) et Guyane (74 860) avec la même part du
privé que la Martinique (66,4 %) : 85 470 et 49 710 (calculs) ; 448 330 au
total. Salaire net moyen en équivalent temps plein, 2024 : 2 237 à 2 470 €
selon le département (Insee), 2 330 € en moyenne pondérée, soit ≈ 2 990 €
bruts (rapport net/brut de 0,78, ordre de grandeur, hypothèse) : masse
salariale de ≈ 16,1 Md€ (calcul, majorée par le temps partiel). Coût :
482 M€ par an. Les exonérations patronales existantes (LODEOM) ne changent
pas. -/
def salariesPrivesOutreMer : Int := 201300 + 24300 + 87550 + 85470 + 49710
def salaireBrutOutreMerEuros : Int := 2330 * 100 / 78
def masseSalarialeOutreMer : Int := salariesPrivesOutreMer * salaireBrutOutreMerEuros * 12 / 1000000
def baisseCotisationsOutreMer : Int := masseSalarialeOutreMer * 3 / 100

theorem cotisationsOutreMer_valeurs :
    salariesPrivesOutreMer = 448330 ∧ salaireBrutOutreMerEuros = 2987 ∧ baisseCotisationsOutreMer = 482 := by decide

/-- Aide au gazole non routier agricole (O-103) : 30 centimes par litre,
déduits sur la facture, la demande de la FNSEA (22 septembre 2026 ; aide de
crise de 15 centimes de mai à décembre 2026, ≈ 55 M€ par mois, hors
tendance), sur les ≈ 3,7 Md de litres de produits pétroliers de
l'agriculture et de la pêche (voir `exploitationsAgricoles`) : 1,11 Md€
par an, réduits de 10 % chaque année au rythme de la conversion électrique
des exploitations (O-31), à zéro au terme du plan. Le tarif réduit
d'accise du GNR agricole (≈ 1,13 Md€ en 2024, Cour des comptes) est
inchangé. -/
def litresGnrAgricoles : Int := 3700
def aideGnr (centimes : Int) : List Int :=
  ([9, 8, 7, 6, 5, 4, 3, 2, 1, 0] : List Int).map fun k => litresGnrAgricoles * centimes / 100 * k / 10

theorem aideGnr_debut : aideGnr 30 = [999, 888, 777, 666, 555, 444, 333, 222, 111, 0] := by decide

/-- Coopérative d'État d'engrais azotés bas carbone (O-104, O-104b) :
deux usines sur le modèle du projet FertigHy (Languevoisin, Somme :
500 000 t d'ammonitrate CAN27 par an, 15 % de la consommation française,
1,3 Md€, ≈ 250 emplois directs, hydrogène par électrolyse ; AFP, 12 mai
2024), construites l'une après l'autre de 2027 à 2035 : apport en capital
de l'État de 2,6 Md€ réparti sur ces neuf années, 288 M€ par an
(opération financière : dette sans déficit ; le flux s'arrête après
l'horizon du modèle). La première produit à partir de 2031 : 500 000 t de
CAN27 contiennent 135 000 t d'azote, soit ≈ 164 000 t d'ammoniac, à
12,12 MWh par tonne au minimum (AFT, fiche ALTERFI « Ammoniac ») : ≈ 2 TWh
d'électricité par an (calcul), pris sur le surplus du parc nucléaire. La seconde usine produit
après 2035. Les importations d'engrais remplacées et la valeur ajoutée,
plus forte par emploi que la moyenne, ne sont comptées qu'à travers les
emplois. -/
def capitalEngrais : Int := 2 * 1300 / 9
def ammoniacParUsineKt : Int := 500 * 27 / 100 * 17 / 14
def electriciteEngraisGwh : Int := ammoniacParUsineKt * 1212 / 100

theorem engrais_valeurs : capitalEngrais = 288 ∧ ammoniacParUsineKt = 163 ∧ electriciteEngraisGwh = 1975 := by decide

/-- Légalisation encadrée du cannabis (O-105, O-105b), soumise à
référendum (article 11 de la Constitution, ou RIC d'O-87, dont le scrutin
annuel porte la question : pas de coût propre) ; le programme retient
l'hypothèse d'un oui en 2027, la loi en 2028 et les premières ventes en
2029. Modèle du Conseil d'analyse économique (note n° 52, juin 2019) :
production et distribution sous licence d'État, vente aux majeurs, prix de
9 € le gramme toutes taxes comprises (5 € hors taxes, droit d'accise de
50 %, TVA de 20 % : 2,50 € d'accise et 1,50 € de TVA par gramme, calcul),
entre les prix de rue de la résine (8 €) et de l'herbe (10 €) en 2023.
Marché de 2023 : 397,4 t pour 2,73 Md€ (OFDT, décembre 2025). Part du
marché légal : 72 % des consommateurs canadiens achètent dans le circuit
légal cinq ans après la légalisation (Enquête canadienne sur le cannabis
2024 : 72 %, contre 4 % en 2018), atteinte ici linéairement en cinq ans
(hypothèse). Emplois : 55 à 114 par tonne (CAE, directs, indirects et
induits ; bas de la fourchette retenu), répartis comme la valeur : coût de
production inférieur à 1 € sur un prix hors taxes de 5 € (CAE), soit 20 %
dans l'agriculture et 80 % dans le commerce (calcul) ; les cotisations de
ces emplois sont calculées par le modèle. 10 % de l'accise financent la
prévention et le soin (le CAE recommande d'y affecter une partie des
recettes ; part : hypothèse). Les amendes forfaitaires pour usage
disparaissent : 652 347 dressées de septembre 2020 à fin janvier 2025
(ministère de l'Intérieur), ≈ 147 700 par an, à 200 € et 34,6 % de
recouvrement (Cour des comptes, avril 2026) : ≈ 10 M€ par an (calcul,
majoré : toutes les AFD de stupéfiants sont comptées). Les forces de
l'ordre (plus d'un million d'heures par an pour l'usage, CAE) sont
redéployées vers les trafics : la dépense publique de répression du
cannabis (568 M€, dont 70 % de police et 20 % de justice, CAE) n'est pas
économisée. -/
def cannabisTonnes : Int := 397
def acciseCannabisCentimes : Int := 500 * 50 / 100
def tvaCannabisCentimes : Int := (500 + acciseCannabisCentimes) * 20 / 100
def partLegaleCannabis : List Int := ([1, 2, 3, 4, 5] : List Int).map fun k => 72 * k / 5
def acciseCannabis : List Int :=
  partLegaleCannabis.map fun p => cannabisTonnes * acciseCannabisCentimes / 100 * p / 100
def tvaCannabis : List Int :=
  partLegaleCannabis.map fun p => cannabisTonnes * tvaCannabisCentimes / 100 * p / 100
def preventionCannabis : List Int := acciseCannabis.map fun a => a / 10
def afdStupefiantsParAn : Int := 652347 * 12 / 53
def recettesAfd : Int := afdStupefiantsParAn * 200 * 346 / 1000 / 1000000
def emploisCannabisAnnuels : Int := 55 * cannabisTonnes * 72 / 100 / 5
def emploisCannabisAgriculture : Int := emploisCannabisAnnuels / 5
def repressionCannabis : Int := 568

theorem cannabis_valeurs :
    acciseCannabisCentimes = 250 ∧ tvaCannabisCentimes = 150 ∧
    partLegaleCannabis = [14, 28, 43, 57, 72] ∧
    acciseCannabis = [138, 277, 426, 565, 714] ∧ tvaCannabis = [83, 166, 255, 339, 428] ∧
    afdStupefiantsParAn = 147701 ∧ recettesAfd = 10 ∧
    emploisCannabisAnnuels = 3144 ∧ emploisCannabisAgriculture = 628 := by decide

/-- Légalisation de la prostitution sur le modèle allemand (O-106), soumise
à référendum (même scrutin qu'O-105) ; hypothèse d'un oui. Abrogation de la
pénalisation des clients (loi du 13 avril 2016) ; activité légale, exercée
comme indépendant ou salarié, déclarée et imposée ; établissements soumis
à autorisation ; enregistrement obligatoire et consultation de santé
annuelle, préservatif obligatoire (Prostitutionsgesetz de 2002 et
Prostituiertenschutzgesetz de 2017). La traite, le proxénétisme de
contrainte et la prostitution des mineurs restent réprimés ; le parcours
de sortie de la loi de 2016 est maintenu. Recettes : l'activité non
déclarée prive l'État et la sécurité sociale de 853 M€ par an pour 37 000
personnes (étude ProstCost, Mouvement du Nid et Psytel, 2015 ; chiffres
contestés, le ministère de l'Intérieur comptant 20 000 personnes). En
Allemagne, 32 300 personnes sont enregistrées fin 2024 (Destatis) sur
200 000 à 400 000 estimées (gouvernement fédéral, avril 2023) : 10,7 % au
milieu de la fourchette (calcul), appliqués au manque à gagner : 91 M€ par
an à partir de 2029 (calcul). Point juridique : la convention des Nations
unies du 2 décembre 1949, ratifiée par la France en 1960 (l'Allemagne n'y
est pas partie), oblige à punir quiconque tient ou finance une maison de
prostitution (article 2) : les établissements autorisés supposent de la
dénoncer. -/
def manqueAGagnerProstitution : Int := 853
def partDeclareeProstitutionPm : Int := 32300 * 1000 / 300000
def recettesProstitution : Int := manqueAGagnerProstitution * partDeclareeProstitutionPm / 1000

theorem prostitution_valeurs : partDeclareeProstitutionPm = 107 ∧ recettesProstitution = 91 := by decide

/-- Rénovation des passoires thermiques dans les villes moyennes (O-107) :
programme dédié dans les 244 villes du plan Action cœur de ville (≈ 20
millions d'habitants, 23 % de la population, Banque des Territoires),
porté par l'Anah et les collectivités : rénovations d'ampleur des
logements classés F et G. 120 306 rénovations d'ampleur aidées en 2025
(Anah, bilan 2025) ; à la part de ces villes dans la population, 27 670 par
an (calcul) : le programme en finance autant de plus chaque année, soit le
double du rythme actuel. Aide moyenne d'une rénovation d'ampleur :
40 429 € en 2025 (Anah ; 32 567 € pour les ménages modestes et 45 580 €
pour les très modestes en Provence-Alpes-Côte d'Azur, DREAL). Économie
d'énergie : 0,9 TWh par an pour 71 600 rénovations d'ampleur engagées en
2023 (SDES, décembre 2024), 12 569 kWh par logement (calcul) ; 60 % des
logements rénovés par MaPrimeRénov' Sérénité étaient des passoires
(même source). Fioul et gaz aux parts nationales du sous-modèle
rénovation (pas de donnée propre aux villes moyennes). Coût : 1,12 Md€ par
an (calcul). -/
def renovationsAmpleur2025 : Int := 120306
def renovationsVillesMoyennes : Int := renovationsAmpleur2025 * 23 / 100
def aideRenovationAmpleurEuros : Int := 40429
def economieRenovationAmpleurKWh : Int := 900000000000 / 71600 / 1000

theorem passoires_valeurs :
    renovationsVillesMoyennes = 27670 ∧ economieRenovationAmpleurKWh = 12569 ∧
    renovationsVillesMoyennes * aideRenovationAmpleurEuros / 1000000 = 1118 := by decide

/-- Décarbonation des sites industriels (O-108) : l'industrie émet 58,4 Mt
en 2025 (Citepa, voir `Hypotheses.emissions2025`) et suit la tendance à
mesures existantes (−3 % par an), 50,2 Mt en 2030 contre 42 Mt pour
l'objectif sectoriel de la SNBC-3 : 8 Mt d'écart. La DGE (1er avril 2026)
estime à ≈ 22 Md€ le soutien public nécessaire de 2024 à 2030 pour passer de
63 Mt (2023) à ≈ 45 Mt (quatrième budget carbone, 2029-2033), soit
1 222 M€ de soutien par Mt évitée chaque année (calcul). Le programme
comble l'écart : 2 Mt de plus chaque année de 2027 à 2030 (électrification
des procédés, chaleur bas carbone, captage sur les 50 sites les plus
émetteurs, qui pèsent 55 % des émissions de l'industrie et se sont engagés
sur −45 % en 2030 ; 50 à 70 Md€ d'investissements, ministère de l'Industrie,
13 décembre 2023), 2,44 Md€ d'aides par an pendant quatre ans. La
consommation d'électricité supplémentaire n'est pas comptée. -/
def soutienParMt : Int := 22000 / (63 - 45)
def mtParAnIndustrie : Int := 2
def aideDecarbonation : Int := mtParAnIndustrie * soutienParMt
/-- Renforcement d'octobre 2026 : 1,25 Mt de plus par an de 2027 à 2030,
au même soutien par Mt (13 Mt en tout au lieu de 8, au-delà de l'objectif
SNBC-3 de l'industrie) pour ramener les émissions de 2030 sous le plafond
de 300 Mt avec O-124. -/
def ktSupplementairesIndustrie : Int := 1250
def aideDecarbonationSupplementaire : Int := ktSupplementairesIndustrie * soutienParMt / 1000

theorem decarbonation_valeurs : soutienParMt = 1222 ∧ aideDecarbonation = 2444 ∧
    aideDecarbonationSupplementaire = 1527 := by decide

/-- Places en Ehpad publics (O-109, O-109b) : la DREES prévoit 108 000
résidents de plus en Ehpad en 2030 dans son scénario central (Études et
résultats n° 1172, décembre 2020) ; le public accueille 275 900 des 573 100
résidents fin 2023 (48 %, Études et résultats n° 1351, novembre 2025) et ses
places ont baissé de 0,9 % depuis 2019. Le programme crée la part publique
du besoin, 51 993 places (calcul), 10 398 par an de 2027 à 2031, ouvertes
l'année suivante. Construction : ≈ 85 000 € HT par place en 2012 (Anap et
CNSA, Observatoire des coûts de la construction médico-sociale), actualisés
par l'indice du coût de la construction (1 617 au 1er trimestre 2012, 2 058
au 4e trimestre 2025, Insee) : 108 181 € (calcul). Fonctionnement à la
charge des administrations : soins financés par l'assurance maladie,
12 755 € par place et par an, et APA en établissement, 338 € par mois en
moyenne (valeurs 2019 : La Banque Postale d'après le rapport Libault ;
DREES), 16 811 € par place (calcul, non actualisé) ; l'hébergement reste
payé par les résidents. -/
def residentsSupplementaires2030 : Int := 108000
def placesEhpadPubliques : Int := residentsSupplementaires2030 * 275900 / 573100
def placesEhpadParAn : Int := placesEhpadPubliques / 5
def coutPlaceEhpadEuros : Int := 85000 * 2058 / 1617
def fonctionnementPlaceEhpadEuros : Int := 12755 + 338 * 12
def investissementEhpad : Int := placesEhpadParAn * coutPlaceEhpadEuros / 1000000
def fonctionnementEhpad : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * placesEhpadParAn * fonctionnementPlaceEhpadEuros / 1000000

theorem ehpad_valeurs :
    placesEhpadPubliques = 51993 ∧ placesEhpadParAn = 10398 ∧ coutPlaceEhpadEuros = 108181 ∧
    fonctionnementPlaceEhpadEuros = 16811 ∧ investissementEhpad = 1124 ∧
    fonctionnementEhpad = [174, 349, 524, 699, 874] := by decide

/-- Police de proximité (O-110) : rétablie sur le modèle de 1998-2003 :
20 000 adjoints de sécurité encadrés par 6 700 policiers titulaires (un
pour trois, ratio de 1998-2003). Coût complet d'un titulaire : 78 848 € par
an, pensions comprises (moyenne de la police nationale en 2026 : 12 086 M€
pour 153 286 agents en équivalent temps plein, rapport spécial AN
n° 1996, calcul) ; d'un adjoint, contractuel rémunéré près du SMIC :
39 015 € chargés, formation et équipement compris (hypothèse). Montée en
charge en cinq ans (670, 2 670, 10 700, 21 300 puis 26 700 agents,
hypothèse). Les brigades anticriminalité sont maintenues : pas d'économie
en regard. Fonctionnement et investissement (locaux, véhicules) non
comptés : chiffrage minimal. -/
def adjointsSecurite : Int := 20000
def encadrantsProximite : Int := 6700
def coutTitulairePoliceEuros : Int := 12086400000 / 153286
def coutPoliceProximite : Int := (adjointsSecurite * 39015 + encadrantsProximite * coutTitulairePoliceEuros) / 1000000
def agentsProximite : List Int := [670, 2670, 10700, 21300, adjointsSecurite + encadrantsProximite]
/-- Coût moyen d'un agent de la police de proximité (adjoints et
encadrants pondérés, calcul), pour le levier `creationPostes`. -/
def coutAgentProximiteEuros : Int :=
  (adjointsSecurite * 39015 + encadrantsProximite * coutTitulairePoliceEuros) / (adjointsSecurite + encadrantsProximite)
def policeProximite : List Int :=
  agentsProximite.map fun a => coutPoliceProximite * a / (adjointsSecurite + encadrantsProximite)

theorem policeProximite_valeurs :
    coutPoliceProximite = 1308 ∧ policeProximite = [32, 130, 524, 1043, 1308] ∧
    coutAgentProximiteEuros = 49010 := by decide

/-- Bpifrance (O-111) : 5 % des financements de la banque publique sont
orientés vers des projets choisis par un vote en ligne des citoyens, parmi
des projets instruits et jugés finançables par Bpifrance (solvabilité,
règles bancaires) ; un vote par personne, identifiée par FranceConnect. Bpifrance a injecté 72 Md€ dans l'économie en 2025
(prêts, garanties, fonds propres, assurance export ; bilan annuel du
17 février 2026) : 3,6 Md€ par an soumis au vote (calcul). Ce sont des
opérations de la banque publique, pas des dépenses des administrations :
la mesure ne change pas le solde public. Le coût de la plateforme de vote et
un éventuel surcroît de pertes ne sont pas chiffrés. -/
def financementsBpifrance : Int := 72000
def partVoteBpifrancePct : Int := 5
def financementsVotes : Int := financementsBpifrance * partVoteBpifrancePct / 100

theorem financementsVotes_eq : financementsVotes = 3600 := by decide

/-- Titres de séjour (O-112) : renfort des services des étrangers des
préfectures pour réduire les délais. 4,33 millions de titres et documents
de séjour valides fin 2024 (+56 % depuis 2014), plus de 343 000 premiers
titres en 2024, un record hors 2021 (Sénat, avis sur le PLF 2026, 5 décembre
2025) ; 384 230 premiers titres en 2025 (ministère de l'Intérieur). Les
effectifs n'ont pas suivi la demande (exposé de l'amendement II-333 au PLF
2026, d'après le bleu budgétaire du programme 354), qui proposait 500
emplois de plus dans les préfectures pour 25 M€, soit 50 000 € par emploi
(calcul) : le programme reprend ces 500 emplois. L'effet de délais plus
courts sur l'emploi déclaré des étrangers titulaires n'est pas chiffré. -/
def agentsPrefectures : Int := 500
def coutAgentPrefectureEuros : Int := 25000000 / 500
def renfortPrefectures : Int := agentsPrefectures * coutAgentPrefectureEuros / 1000000

theorem renfortPrefectures_eq : coutAgentPrefectureEuros = 50000 ∧ renfortPrefectures = 25 := by decide

/-- Algérie : réponse aux demandes mémorielles (O-113). Les demandes portées
par le gouvernement algérien (ministre des Moudjahidine, 4 juillet 2021) :
restitution des archives, informations sur les disparus et les lieux où ils
se trouvent, essais nucléaires (cartes des lieux d'enfouissement des
déchets, dépollution des sites, indemnisation des victimes), auxquelles
s'ajoute la restitution des restes humains conservés en France (24 crânes
rendus en 2020). Réponses et coûts :
* archives : copie numérique des ≈ 10 km linéaires d'archives rapatriées
  aux Archives nationales d'outre-mer (rapport Stora, janvier 2021), avec
  l'ouverture des fonds sur les disparus : 2 M€ par an pendant cinq ans
  (hypothèse ; pas de devis public) ;
* essais nucléaires : remise des cartes (sans coût) ; présomption de la loi
  Morin étendue aux résidents des zones de Reggane et d'In Ekker, où ont eu
  lieu 17 essais de 1960 à 1966 ; le CIVEN a indemnisé 1 538 dossiers de
  2010 à 2025 pour 108 M€, soit 70 221 € en moyenne (Sénat, rapport n° 640,
  2026 ; calcul) ; 1 000 victimes algériennes indemnisées en dix ans
  (hypothèse, aucune estimation des populations exposées n'étant publiée) :
  7 M€ par an ; fonds de dépollution des sites avec l'Algérie : 100 M€ sur
  cinq ans (hypothèse, faute d'inventaire public des déchets) ;
* restes humains : restitution par la procédure de la loi de 2023, sans coût
  notable.
Indemnités et dépollution sont versées en Algérie : sans effet sur la
demande intérieure (recette négative du modèle, voir `transfertsAlgerie`). -/
def archivesAlgerie : List Int := [2, 2, 2, 2, 2, 0]
def indemniteMoyenneCivenEuros : Int := 108000000 / 1538
def victimesAlgeriennes : Int := 1000
def indemnisationAlgerie : Int := victimesAlgeriennes * indemniteMoyenneCivenEuros / 1000000 / 10
def depollutionAlgerie : Int := 100 / 5
def transfertsAlgerie : List Int :=
  List.replicate 5 (-(indemnisationAlgerie + depollutionAlgerie)) ++ List.replicate 5 (-indemnisationAlgerie) ++ [0]

theorem algerie_valeurs :
    indemniteMoyenneCivenEuros = 70221 ∧ indemnisationAlgerie = 7 ∧ depollutionAlgerie = 20 ∧
    transfertsAlgerie = [-27, -27, -27, -27, -27, -7, -7, -7, -7, -7, 0] := by decide

/-- Haïti : remboursement de la « double dette » (O-114). En 1825, la France
impose à Haïti une indemnité de 150 millions de francs-or, ramenée à 90
millions en 1838, payée jusqu'en 1888 avec des emprunts contractés auprès de
banques parisiennes, remboursés jusqu'au milieu du XXe siècle (Public Sénat,
17 avril 2025). Le New York Times (enquête « The Ransom », 2022) évalue à
≈ 560 millions de dollars actuels les sommes versées par Haïti (indemnité et
emprunts), et à 21 à 115 milliards de dollars la croissance perdue. Le
président Macron a qualifié l'indemnité d'injuste et créé une commission
franco-haïtienne d'historiens (17 avril 2025). Le programme rembourse les
sommes versées : 560 M$ au cours de référence de la BCE (1,1537 dollar pour
un euro le 16 septembre 2026), 485 M€ (calcul), versés en cinq ans à un fonds
franco-haïtien (éducation, santé, reconstruction) géré avec l'AFD. Versement
à l'étranger, sans effet sur la demande intérieure. Variante : bas de la
fourchette des pertes de croissance (21 Md$, 18,2 Md€) en vingt ans. -/
def sommesVerseesHaitiMusd : Int := 560
def remboursementHaiti : Int := sommesVerseesHaitiMusd * 10000 / 11537
def versementsHaiti : List Int := [remboursementHaiti / 5, remboursementHaiti / 5, remboursementHaiti / 5,
                                   remboursementHaiti / 5, remboursementHaiti / 5, 0]
def pertesHaitiBasses : Int := 21000 * 10000 / 11537

theorem haiti_valeurs :
    remboursementHaiti = 485 ∧ versementsHaiti = [97, 97, 97, 97, 97, 0] ∧ pertesHaitiBasses = 18202 := by decide

/-- Afrique : restitution des biens culturels et reconnaissance d'actes
coloniaux (O-115). Au moins 90 000 objets d'Afrique subsaharienne dans les
collections publiques, dont 70 000 au musée du quai Branly, 46 000 de ces
derniers acquis de 1885 à 1960 (rapport Sarr-Savoy, novembre 2018). La loi
de 2026 sur la restitution des biens culturels (accord en commission mixte
paritaire le 30 avril 2026) permet de les restituer sans loi d'espèce. Le
programme applique la loi aux demandes des États africains et finance la
recherche de provenance : la France verse aujourd'hui 300 000 € par an au
fonds franco-allemand de recherche de provenance (étude d'impact du projet
de loi) ; porté à 3 M€ par an (dix fois plus, hypothèse). Appui aux musées
des pays qui reçoivent les biens : 35 M€ tous les deux ans, montant du
financement de l'AFD pour le musée d'Abomey après la restitution de 26
objets au Bénin (même source ; rythme : hypothèse), versé à l'étranger.
Reconnaissance officielle d'actes coloniaux (massacres de Thiaroye en 1944,
de Sétif et Guelma en 1945, répression de 1947 à Madagascar, guerre au
Cameroun) : sans coût budgétaire. -/
def provenanceAfrique : Int := 300000 * 10 / 1000000
def appuiMusees : Int := 35 / 2
def appuiMuseesEcheancier : List Int := List.replicate 10 (-appuiMusees) ++ [0]

theorem afrique_valeurs : provenanceAfrique = 3 ∧ appuiMusees = 17 := by decide

/-- Densification des zones commerciales (O-116) : les parkings de surface
des zones commerciales d'entrée de ville sont remplacés par des parkings
mutualisés en silo, et le sol libéré accueille commerces, activités ou
logements sans consommer d'espaces naturels. 50 000 ha de zones d'entrée de
ville à transformer selon le gouvernement (AFP, via Weka, 4 juin 2025) ;
les parkings occupent 28 % de l'emprise des zones commerciales en
Île-de-France (Institut Paris Région, via Banque des Territoires, 14 juin
2023) : 14 000 ha (calcul). Le programme en traite 10 % en dix ans
(hypothèse) : 140 ha de parkings par an, soit 56 000 places à 25 m²
(circulations comprises ; ratio usuel, hypothèse). Une place en silo coûte
10 000 à 15 000 € HT (Réseau national des aménageurs, 2019) : 12 500 € ;
l'État en finance 30 % (hypothèse) : 210 M€ par an (calcul). Sur quatre
niveaux (hypothèse), le silo libère 75 % de l'emprise : 105 ha par an qui
ne sont plus pris sur les espaces naturels pour les activités (calcul). -/
def zonesCommercialesHa : Int := 50000
def partParkingsPct : Int := 28
def parkingsTraitesHaParAn : Int := zonesCommercialesHa * partParkingsPct / 100 / 10 / 10
def placesSiloParAn : Int := parkingsTraitesHaParAn * 10000 / 25
def coutPlaceSiloEuros : Int := (10000 + 15000) / 2
def aideSilos : Int := placesSiloParAn * coutPlaceSiloEuros / 1000000 * 30 / 100
def haLiberesParAn : Int := parkingsTraitesHaParAn * 3 / 4

theorem silos_valeurs :
    parkingsTraitesHaParAn = 140 ∧ placesSiloParAn = 56000 ∧ aideSilos = 210 ∧ haLiberesParAn = 105 := by decide

/-- Fret ferroviaire augmenté de moitié (O-117) : la part modale du fer est
de 8,9 % en 2023 (29,4 Md de tonnes-km, SDES), loin de l'objectif de 18 % en
2030 de la stratégie nationale (2021). Le transport intérieur terrestre est
de 344 Md de tonnes-km en 2024, dont 89 % par la route (SDES, Chiffres clés
2026) ; les poids lourds émettent 27,1 Mt de CO₂e en 2024 (Citepa, Secten
2025, via la FNTR) : 88,6 g par tonne-km (calcul). Le texte doublait la
part du fer ; l'auteur la relève de 50 % (`hausseFretPm`, demande du
6 novembre 2026), de 8,9 % à 13,4 % en 2032, sous l'objectif de 18 % : 15,3 Md
de tonnes-km reportés de la route, 1,36 Mt évitées par an (calcul ;
émissions du fer, surtout électrique, négligées), atteintes en six ans, de
2027 à 2032 (225 kt de plus chaque année). Moyens : le plan
d'investissement Ulysse Fret prévoit ≈ 4,5 Md€ d'ici 2032 et l'aide au
wagon isolé est de 100 M€ par an (Sénat, avis sur le PLF 2026) ; le
programme relève l'un et l'autre de 50 % : 2,25 Md€ de plus de 2027 à 2032
(375 M€ par an) et 50 M€ par an. Les pertes d'accise sur le gazole et les
importations évitées ne sont pas comptées. -/
def fretTkmMd : Int := 344
def partFerPm : Int := 89
def emissionsPoidsLourdsKt : Int := 27100
def mgCo2ParTkm : Int := emissionsPoidsLourdsKt * 1000 / (fretTkmMd * 890 / 1000)
/-- Hausse de la part modale du fer, ‰ de la part actuelle (1000 = doublement du texte). -/
def hausseFretPm : Int := 500
def fretReporteMtkm : Int := fretTkmMd * 1000 * partFerPm / 1000 * hausseFretPm / 1000
def co2EviteFretKt : Int := fretReporteMtkm * mgCo2ParTkm / 1000000
def co2EviteFretParAnKt : Int := co2EviteFretKt / 6
def investissementFret : Int := 4500 * hausseFretPm / 1000 / 6
def aideWagonIsole : Int := 100 * hausseFretPm / 1000

theorem fret_valeurs :
    mgCo2ParTkm = 88562 ∧ fretReporteMtkm = 15308 ∧ co2EviteFretKt = 1355 ∧ co2EviteFretParAnKt = 225 ∧
    investissementFret = 375 ∧ aideWagonIsole = 50 := by decide

/-- Autoroutes sans limitation de vitesse sur certains tronçons (O-118) :
sur le modèle allemand, la vitesse est libre (vitesse conseillée 130 km/h)
sur 10 % du réseau autoroutier (hypothèse), choisi pour sa sécurité (tracé,
trafic). La France compte 11 752 km d'autoroutes (SDES, 2024) : 1 175 km
(calcul). En Allemagne, 70,4 % des 25 767 km de chaussées autoroutières
n'ont pas de limitation (BASt, 2015), soit ≈ 9 070 km d'autoroute (calcul),
et une limitation générale à 120 km/h y éviterait 6,7 Mt de CO₂e par an
(Umweltbundesamt, janvier 2023) : 0,739 kt par km (calcul). Passer de
130 km/h à la vitesse libre pèse moins que passer de la vitesse libre à
120 km/h : la moitié (hypothèse). Hausse : ≈ 433 kt de CO₂e par an (ordre de
grandeur). Le surcroît de carburant (accises, TVA, importations) et l'effet
sur l'accidentalité (vitesse et mortalité, ONISR) ne sont pas modélisés. -/
def autoroutesKm : Int := 11752
def troncons : Int := autoroutesKm / 10
def autobahnLibreKm : Int := 25767 * 704 / 1000 / 2
def ktParKmLibre1000 : Int := 6700 * 1000 / autobahnLibreKm
def hausseCo2AutobahnKt : Int := troncons * ktParKmLibre1000 / 1000 / 2

theorem autobahn_valeurs :
    troncons = 1175 ∧ autobahnLibreKm = 9069 ∧ ktParKmLibre1000 = 738 ∧ hausseCo2AutobahnKt = 433 := by decide

/-- Plan contre les fuites des réseaux d'eau (O-119) : ≈ 1 milliard de m³
perdus chaque année, un litre sur cinq (SISPEA 2021, via UFC-Que Choisir,
juin 2023), sur ≈ 850 000 km de canalisations ; renouvellement de 0,67 % par
an contre 1 % visé par les Assises de l'eau de 2019 (même source). Fonds de
l'État pour les collectivités : 1 Md€ par an, soit les 1,5 Md€ de
l'amendement n° 2034 au PLF 2025 (plan d'investissement pour les
canalisations d'eau) moins 500 M€ (1,5 Md€ en variante), pendant cinq ans (durée : hypothèse), soit un tiers à
40 % des 2,5 à 3 Md€ par an jugés nécessaires (UFC-Que Choisir, d'après des
experts ; calcul). L'eau économisée n'est pas modélisée. -/
def fondsFuitesEau : Int := 1500 - 500

/-- Aides à domicile du grand âge (O-120) : 475 000 aides à domicile en 2022,
dont 156 000 salariées de particuliers employeurs ; revenu salarial annuel
moyen net de 7 040 € en 2021, faute d'heures (740 heures par an en moyenne
pour les femmes) (DREES, Études et résultats n° 1341, juin 2025, via Weka).
Revalorisation de 10 % (hypothèse), financée par la hausse du tarif de l'APA
et du crédit d'impôt pour les particuliers employeurs : masse brute de
4 287 M€ (net / 0,78, rapport net/brut d'O-102), 428 M€ par an (calcul). -/
def aidesDomicile : Int := 475000
def revenuNetAideDomicileEuros : Int := 7040
def revalorisationAidesDomicile : Int := aidesDomicile * revenuNetAideDomicileEuros * 100 / 78 / 1000000 / 10

theorem aidesDomicile_eq : revalorisationAidesDomicile = 428 := by decide

/-- 90 000 enseignants, AESH et infirmières scolaires (O-121), sur le modèle
de la proposition du PCF (PC-12, sans les médecins scolaires, déjà dans
O-88) : 4 000 postes coûtent 150 M€ en année pleine (gouvernement, janvier
2025), soit 37 500 € par poste et 3 375 M€ pour 90 000 postes (calcul),
recrutés en quatre ans, de 2027 à 2030 (hypothèse ; cinq ans dans la
version précédente). -/
def postesEcole : Int := 90000
def coutPosteEcoleEuros : Int := 150000000 / 4000
/-- Effectifs cumulés de O-121, par quarts (levier `creationPostes`). -/
def postesEcoleCumul : List Int := ([1, 2, 3, 4] : List Int).map fun k => postesEcole * k / 4
def postesEcoleEcheancier : List Int :=
  ([1, 2, 3, 4] : List Int).map fun k => postesEcole * k / 4 * coutPosteEcoleEuros / 1000000

theorem postesEcole_valeurs :
    coutPosteEcoleEuros = 37500 ∧ postesEcoleCumul = [22500, 45000, 67500, 90000] ∧
    postesEcoleEcheancier = [843, 1687, 2531, 3375] := by decide

/-- Cotisations salariales −0,5 point (O-122) : coup de pouce au pouvoir
d'achat de tous les salariés, public et privé. Salaires et traitements bruts
de 2025 : 1 157,2 Md€ (Insee, compte des ménages ; voir
`Hypotheses.Reference`) : un point vaut 11 572 M€ (calcul) ; un demi-point,
5 786 M€ par an, ≈ 197 € par an au salaire moyen (39 469 € bruts). Le point
entier (variante) ramène la marge de baisse annuelle du déficit à 0,01
point. -/
def masseSalarialeBrute2025 : Int := 1157200
def pointCotisationsSalariales : Int := masseSalarialeBrute2025 / 100
def baisseCotisationsSalariales : Int := pointCotisationsSalariales / 2

theorem pointCotisations_eq : pointCotisationsSalariales = 11572 ∧ baisseCotisationsSalariales = 5786 := by decide

/-- Aide ciblée au solaire sur toiture (O-123) : la prime à
l'autoconsommation des installations résidentielles a été supprimée par
l'arrêté du 1er juin 2026, et le surplus racheté 1,1 c€/kWh (Selectra). Le
programme aide les ménages modestes (plafonds de MaPrimeRénov') à poser 3 kWc
sur leur toit : ≈ 2 000 € par kWc, 6 000 € pour 3 kWc (Selectra) ; l'État
en paie la moitié, 3 000 € par installation, pour 50 000 installations par an
(hypothèse) : 150 M€ et 150 MW de plus chaque année, sans emprise au sol
(nouveau levier `solaireToiture`). -/
def installationsSolaires : Int := 50000
def kwcParInstallation : Int := 3
def aideSolaireEuros : Int := 2000 * kwcParInstallation / 2
def aideSolaire : Int := installationsSolaires * aideSolaireEuros / 1000000
def mwSolaireParAn : Int := installationsSolaires * kwcParInstallation / 1000

theorem solaire_valeurs : aideSolaire = 150 ∧ mwSolaireParAn = 150 := by decide

/-- Rénovation énergétique en territoire rural (O-63) : l'aide à la
rénovation (MaPrimeRénov', 13 000 € en moyenne en 2026) est majorée de 25 %
dans les communes rurales, `bonusRenovationRurale` = 3 250 € par
rénovation. Les ménages ruraux se chauffent deux fois plus souvent au
fioul (16,7 % contre 8,5 %, INSEE 2026) : chaque rénovation y évite plus
de CO₂ et d'importations. Le modèle commun (sous-modèle rénovation de l'axe
énergie) en déduit le coût, dont la majoration versée aux rénovations qui
auraient eu lieu sans elle, et les rénovations suscitées. -/
def bonusRenovationRurale : Int := 3250

/-- Eau potable outre-mer (O-64). La Cour des comptes (mars 2025) chiffre à
2,36 Md€ les investissements nécessaires dans les DROM et à Saint-Martin,
dont 1,52 Md€ pour l'eau potable et 841 M€ pour l'assainissement (Mayotte
743 M€, La Réunion 688 M€, Guadeloupe 375 M€) ; le plan Eau-DOM n'en a
couvert qu'environ 10 %. Situation : 25 % des ménages de Mayotte sans eau
courante en 2024 et des coupures quotidiennes pour 63 % des raccordés
(INSEE Analyses Mayotte n° 42, juin 2026) ; 15 % de la population de Guyane
sans eau potable du réseau public (réponse ministérielle, JO du
23 décembre 2025) ; 25 % des Guadeloupéens soumis aux tours d'eau,
rendement des réseaux de 32 % (Sénat, rapport n° 440, mars 2025). La loi
de programmation pour la refondation de Mayotte (n° 2025-797) prévoit déjà
730 M€ : le programme finance le reste, 1,63 Md€ (euros 2027) sur cinq
ans, `eauOutreMer` = 326 M€ par an de 2027 à 2031. Les collectivités du
Pacifique (Polynésie : 62 % de la population desservie en eau conforme en
2024 ; Nouvelle-Calédonie, Wallis-et-Futuna) relèvent de leurs propres
compétences : non chiffrées. -/
def eauOutreMer : Int := 326

/-- Électrification totale des outre-mer (O-65). Logements sans électricité
(INSEE, 2026) : 19 % à Mayotte en 2024, soit ≈ 15 400 ménages (calcul :
323 153 habitants, 4 personnes par ménage) ; 7 % en Guyane, ≈ 6 700
ménages (hypothèse : ≈ 95 000 résidences principales), surtout dans les
communes de l'intérieur (60 % des logements électrifiés, IEDOM 2021). Coût
par foyer non publié : hypothèses de 5 000 € pour un raccordement au réseau
(Mayotte) et de 20 000 € pour un site isolé (micro-réseau solaire avec
stockage, Guyane), soit 77 + 134 = 211 M€ sur trois ans,
`electrificationOutreMer` = [70, 70, 71] M€ ; puis le surcoût de
production de l'électricité consommée par les 22 100 foyers raccordés
(péréquation des zones non interconnectées, modèle commun),
`foyersRaccordesParAn` = 7 367 par an pendant trois ans. -/
def electrificationOutreMer : List Int := [70, 70, 71, 0]

/-- Dettes cachées (O-67, O-68).

* O-67 : paiement immédiat du stock d'heures supplémentaires non payées des
  policiers (passif implicite suivi par le modèle commun : 189 M€, 14,3
  millions d'heures à 13,22 €), en 2027, comme des heures supplémentaires
  (exonérées d'impôt sur le revenu). Au coût complet retenu par la Cour
  des comptes en 2020 (25,6 €/h), le stock vaudrait 366 M€.
* O-68 : RIFSEEP pour les enseignants, c'est-à-dire l'alignement de leurs
  primes sur celles des autres agents de catégorie A. Les primes font
  17,2 % du salaire brut des enseignants contre 32,9 % pour les autres
  agents de catégorie A (DGAFP, rapport annuel 2025, données 2023) ; le
  rapport primes / traitement passe de 0,208 à 0,490, soit +0,283 × un
  traitement de ≈ 38 750 € : ≈ 10 950 € bruts par enseignant et par an,
  × 693 400 enseignants fonctionnaires du public (DEPP, rentrée 2025) =
  7,6 Md€, 8,0 Md€ en euros 2027 (`rifseepEnseignants`). Les primes ne
  donnent pas lieu à RAFP (déjà au plafond de 20 % du traitement) ; la
  CSG et l'impôt sur le revenu en reviennent (≈ 24,5 %). Aucun chiffrage
  officiel ni contentieux de rattrapage n'a été trouvé : chiffrage par le
  programme. Variante : montée en charge sur cinq ans. -/
def rifseepEnseignants : Int := 8000

/-- Baisse du déficit, troisième étape (O-69 à O-73), pour financer O-67 et
O-68 :

* O-69 : crédit d'impôt recherche plafonné par groupe à 50 M€ et
  suppression du taux de 5 % au-delà de 100 M€ de dépenses : ≥ 960 M€
  (IGF, revue de dépenses, mars 2024) ; mesure déposée en amendements au
  PLF 2026 (AN I-754, Sénat I-674). Le CIR
  coûte ≈ 8 Md€, les 50 premiers bénéficiaires en reçoivent 43 % ; sans
  effet significatif sur la R&D des grandes entreprises (CNEPI, 2021).
* O-70 : assurance-vie au barème des successions en ligne directe, à
  partir de la tranche à 20 %, au-delà de 250 000 € par bénéficiaire (au
  lieu des 152 500 € d'abattement actuels). Le Conseil des prélèvements
  obligatoires chiffre à ≈ 1,25 Md€ à terme la même réforme avec
  l'abattement de 152 500 € (rapport du 1er décembre 2025, recommandation
  n° 6). Relever le seuil de 97 500 € allège tous les bénéficiaires de plus
  de 152 500 € (jusqu'à 97 500 × 20 % = 19 500 € chacun), alors que le gain
  du barème vient des très gros contrats (≈ 2 000 défunts, 7 M€ en
  moyenne) : rendement retenu, la moitié, `assuranceVieBareme` = 625 M€
  (hypothèse ; aucun chiffrage publié pour ce seuil). Ligne des droits de
  succession.
* O-71 : contribution kilométrique nationale des poids lourds sur le réseau
  non concédé (≈ 15 000 km, l'assiette de l'écotaxe de 2014) : 1 129 M€
  bruts à 0,13 €/km selon la Cour des comptes (rapport public 2017),
  `ecotaxePoidsLourds` = 1 350 M€ avec ≈ 20 % d'inflation depuis 2014
  (hypothèse). Assiette implicite : 8,7 milliards de véhicules-kilomètres,
  ≈ 29 % du trafic des poids lourds (≈ 30 milliards, ordre de grandeur) :
  émissions visées 29 % × 26,7 Mt (Citepa, 2024). Hausse du coût : 0,156 €
  pour ≈ 1,4 € par kilomètre (coût complet, ordre de grandeur), 11 %. Le
  modèle applique l'élasticité-prix (report modal compris).
* O-72 : accise sur le kérosène des vols intérieurs métropolitains au taux
  du gazole (59,40 €/MWh) : 0,476 Mt de kérosène (1,5 Mt de CO₂, DGAC 2024,
  3,15 t de CO₂ par tonne), 5,7 TWh, ≈ 340 M€ avant comportements (calcul) ;
  ≈ 13,6 € par passager pour ≈ 25 millions de passagers et un billet moyen
  de ≈ 130 € (ordres de grandeur) : +10 % de coût. Outre-mer exclu
  (continuité territoriale).
* O-73 : défiscalisation des heures supplémentaires (loi de 2019) réduite
  de moitié : exonération d'impôt sur le revenu (≈ 2,0 Md€ en 2026 ;
  1,79 Md€ en 2025, ≈ 2,3 Md€ en 2027, Voies et moyens) et réduction de
  cotisations salariales (2,31 Md€ en 2026, annexe 4 du PLFSS 2026)
  divisées par deux, par exemple plafond d'exonération ramené de 7 500 € à
  3 750 € et réduction de cotisations de 11,31 % à 5,66 % : la moitié des
  deux coûts, `partDefiscalisationSupprimeePm` = 500 (rendement supposé
  proportionnel). La loi TEPA n'avait pas augmenté les heures travaillées
  (Cahuc et Carcillo, 2014) : pas d'effet sur les heures, la fuite fiscale
  du modèle couvrant l'optimisation des déclarations. -/
def cirRecentre : Int := 960
def assuranceVieBareme : Int := 625
def assuranceVieBaremeCpo : Int := 1250
def ecotaxePoidsLourds : Int := 1350
def emissionsPoidsLourdsVisees : Int := 26700 * 29 / 100
def kerosene : Int := 340
def heuresSupIr : Int := 2000
def heuresSupCotisations : Int := 2310
def partDefiscalisationSupprimeePm : Int := 500
def foyersRaccordesParAn : Int := 7367

/-- Hôpitaux et prisons (O-74, O-75).

* O-74 : paiement immédiat du stock d'heures supplémentaires non payées ni
  récupérées des hôpitaux publics (passif implicite suivi par le modèle
  commun, `passifsHopital2025` = 720 M€ : 20,8 heures par agent non médical
  et 6,1 demi-journées par médecin, bilan social ATIH 2022, rapportés aux
  effectifs DREES 2024 ; 463 M€ fin 2018 selon la Cour des comptes), en
  2027, comme des heures supplémentaires, sur la fonction santé (les
  hôpitaux publics sont des administrations de sécurité sociale, financées
  à 76,8 % par l'Assurance maladie, DREES 2026). Les comptes épargne-temps
  (≈ 2,6 Md€, provisionnés au moins en partie) ne sont pas payés.
* O-75 : parc pénitentiaire porté à `placesPrisonCible` = 85 000 places
  au plus (le
  texte visait 100 000 places, toutes en cellule individuelle, variante).
  Au 1er août 2026 : 63 303 places opérationnelles pour 89 668 détenus
  (densité 141,6 %, 7 956 matelas au sol, 32,3 % des détenus seuls en
  cellule ; ministère de la Justice). À nombre de détenus constant, la
  densité tomberait à ≈ 105 % (calcul : 89 668 / 85 000) : l'encellulement
  individuel (principe de 1875 repris par la loi pénitentiaire de 2009,
  suspendu par moratoire jusqu'au 31 décembre 2027) progresse mais n'est
  pas atteint pour tous. Deux programmes en cours sont supposés financés
  par les crédits immobiliers de l'administration pénitentiaire que la
  tendance des dépenses reconduit (hypothèse) :
  - le plan 15 000 (5 411 places nettes livrées en septembre 2025,
    achèvement en 2031-2032, 5,7 Md€ ; Cour des comptes, 17 décembre 2025),
    qui apporte encore `placesPlan15000Restantes` = 9 589 places ;
  - le programme modulaire du ministère (`placesModulairesGouvernement`
    = 3 000 places en sus du plan 15 000, deux appels d'offres de 1 500,
    unités de 100, 150 ou 200 places, première livraison à Troyes-Lavau dès
    l'automne 2026 ; ministère de la Justice, communiqué de juillet 2025 ;
    Batiweb, 14 avril 2025).
  La mesure finance le reste, `placesPrisonNouvelles` = 9 108 places, dont
  `partModulairePm` = 50 % en modulaire pour répondre à l'urgence.
  - Modulaire (`placesModulaires` = 4 554 places) : ≈ 200 k€ la place et
    livraison en 18 mois, contre ≈ 400 k€ et 7 ans pour un établissement
    classique (ministère de la Justice, juillet 2025 ; le coût modulaire
    est pris tel quel, sans le rapporter aux 270 k€ de la Cour des comptes :
    prudent). Modules fabriqués en usine, assemblés sur le domaine
    pénitentiaire existant ou sur des terrains proposés par les élus ;
    détenus orientés selon leur dangerosité (ministère). Commandes de 2027
    à 2029 (`calendrierModulairePm`), ouvertures de 2028 à 2030
    (`ouvertureModulairePm`, hypothèse : 18 mois après la commande), soit
    ≈ 1 500 places par an, le rythme du programme du ministère.
  - Classique (`placesClassiques` = 4 554 places) : 270 k€ par place
    nette, coût moyen du plan 15 000 (Cour des comptes ; 450 k€ pour les
    centres pénitentiaires, variante), versés de 2027 à 2035
    (`calendrierConstructionPm`) ; ouvertures de 2032 à 2035
    (`ouverturePlacesPm`, hypothèse : ≈ 7 ans de la recherche foncière à
    la livraison), après l'achèvement du plan 15 000.
  - Fonctionnement des places ouvertes : 0,48 surveillant par place
    (2 587 emplois ouverts pour 5 411 places, Cour des comptes) × 80 800 €
    (2,9 Md€ pour 35 879 agents de surveillance, PAP 2026) = 38 784 €, plus
    6 200 € d'entretien et d'énergie (moitié des frais hors personnel de la
    journée de détention, 129,33 € dont 95,48 € de personnel en 2024 ;
    hypothèse : alimentation et frais par détenu inchangés, les détenus
    étant déjà incarcérés) : 44 984 € par place et par an, modulaire
    compris (hypothèse : même encadrement), soit 0,41 Md€ et ≈ 4 400
    surveillants une fois les places ouvertes, en plus du déficit actuel de
    4 000 à 6 000 postes. -/
def placesPrisonCible : Int := 85000
/-- Cible du texte initial (100 000 places, toutes en cellule individuelle), variante. -/
def placesPrisonCibleTexte : Int := 100000
def placesOperationnelles2026 : Int := 63303
def placesPlan15000Restantes : Int := 15000 - 5411
def placesModulairesGouvernement : Int := 3000
def placesNouvellesPour (cible : Int) : Int :=
  cible - placesOperationnelles2026 - placesPlan15000Restantes - placesModulairesGouvernement
def placesPrisonNouvelles : Int := placesNouvellesPour placesPrisonCible
/-- Part des places nouvelles construites en modulaire, ‰. -/
def partModulairePm : Int := 500
def placesModulairesPour (cible partPm : Int) : Int := placesNouvellesPour cible * partPm / 1000
def placesClassiquesPour (cible partPm : Int) : Int :=
  placesNouvellesPour cible - placesModulairesPour cible partPm
def placesModulaires : Int := placesModulairesPour placesPrisonCible partModulairePm
def placesClassiques : Int := placesClassiquesPour placesPrisonCible partModulairePm
def coutPlaceModulaireKEuros : Int := 200
def coutPlacePrisonKEuros : Int := 270
def coutPlacePrisonCpKEuros : Int := 450
/-- Part du coût des places modulaires versée chaque année, de 2027 à 2030, ‰. -/
def calendrierModulairePm : List Int := [333, 333, 334, 0]
/-- Part des places modulaires ouvertes, de 2027 à 2030, ‰ (18 mois après la commande). -/
def ouvertureModulairePm : List Int := [0, 250, 600, 1000]
/-- Part du coût des places classiques versée chaque année, de 2027 à 2036, ‰. -/
def calendrierConstructionPm : List Int := [20, 41, 82, 150, 191, 191, 164, 109, 52, 0]
/-- Part des places classiques ouvertes, de 2027 à 2035, ‰. -/
def ouverturePlacesPm : List Int := [0, 0, 0, 0, 0, 150, 400, 700, 1000]
def surveillantsParPlacePm : Int := 480
def coutSurveillantEuros : Int := 80800
def fonctionnementPlaceEuros : Int := 6200
def coutAnnuelPlaceEuros : Int :=
  surveillantsParPlacePm * coutSurveillantEuros / 1000 + fonctionnementPlaceEuros
/-- Somme terme à terme de deux échéanciers ; le plus court est prolongé par
son dernier niveau, reconduit comme dans `Echeance`. -/
def sommeEcheanciers (a b : List Int) : List Int :=
  let n := max a.length b.length
  let prolonger (l : List Int) := l ++ List.replicate (n - l.length) (l.getLast?.getD 0)
  List.zipWith (· + ·) (prolonger a) (prolonger b)
def constructionPrisonsPour (cible partPm coutPlaceKEuros : Int) : List Int :=
  sommeEcheanciers
    (calendrierModulairePm.map fun p => placesModulairesPour cible partPm * coutPlaceModulaireKEuros / 1000 * p / 1000)
    (calendrierConstructionPm.map fun p => placesClassiquesPour cible partPm * coutPlaceKEuros / 1000 * p / 1000)
def constructionPrisons (coutPlaceKEuros : Int) : List Int :=
  constructionPrisonsPour placesPrisonCible partModulairePm coutPlaceKEuros
/-- Emprise des prisons nouvelles (O-75) : 17 ha pour 700 places (centre de
Saint-Saulve, ministère de la Justice, 23 juin 2023), modulaire compris
(hypothèse), au rythme des calendriers de construction, ha. -/
def surfacesPrisonsPour (cible partPm : Int) : List Int :=
  sommeEcheanciers
    (calendrierModulairePm.map fun p => placesModulairesPour cible partPm * 17 / 700 * p / 1000)
    (calendrierConstructionPm.map fun p => placesClassiquesPour cible partPm * 17 / 700 * p / 1000)
def surfacesPrisons : List Int := surfacesPrisonsPour placesPrisonCible partModulairePm
def fonctionnementPrisonsPour (cible partPm : Int) : List Int :=
  sommeEcheanciers
    (ouvertureModulairePm.map fun p => placesModulairesPour cible partPm * p / 1000 * coutAnnuelPlaceEuros / 1000000)
    (ouverturePlacesPm.map fun p => placesClassiquesPour cible partPm * p / 1000 * coutAnnuelPlaceEuros / 1000000)
def fonctionnementPrisons : List Int := fonctionnementPrisonsPour placesPrisonCible partModulairePm

/-- Baisser à la fois le déficit et le chômage (O-76, O-77).

* O-76 : allègements recentrés. La réduction générale dégressive unique
  s'éteint à 3 SMIC depuis 2026 ; elle sortirait à 2 SMIC, et l'économie
  serait reversée aux salaires de 1 à 1,6 SMIC, à coût constant. Au-delà
  de 1,6 SMIC, les allègements créent peu d'emplois (≈ 5 000 par Md€ pour
  les anciens bandeaux maladie et famille, Bozio et Wasmer, 2024 ; effets
  « très faibles » au-delà de 2,5 SMIC, CAE, note n° 49) ; au voisinage du
  SMIC, beaucoup plus (23 000 à 57 000 par Md€ pour 4 points de baisse,
  CAE). Le CAE (2019) recommandait de supprimer les allègements au-delà de
  2,5 SMIC ; Bozio et Wasmer chiffrent la suppression des bandeaux avec
  recyclage complet (sortie à 2,2 SMIC) à +50 000 emplois. Part des
  allègements de 1,6 à 2,5 SMIC versée au-dessus de 2 SMIC :
  `partAllegementsAuDela2Smic` = 343 ‰ (calcul avec le barème de 2026 et
  la distribution des salaires) ; la tranche au-delà de 2,5 SMIC est
  entièrement reversée. Le recentrage s'applique après O-38 ; les
  réductions suivantes (O-56, O-61) portent alors sur les seuls allègements
  restants, au voisinage du SMIC.
* O-77 : accompagnement renforcé. 10 000 conseillers de plus à France
  Travail (52 837 ETP en 2023, IGF-IGAS ; 515 ETPT de moins en 2026), pour
  ramener les portefeuilles de l'accompagnement guidé (≈ 230 demandeurs par
  conseiller, Dares-IPP 2026) vers la centaine des expériences étrangères ;
  `coutConseillerEuros` = 80 000 € par an (hypothèse : rémunération chargée
  d'un conseiller ≈ 55 000 € et frais de structure ; 127 000 € par ETP tous
  coûts de l'opérateur compris, calcul d'après IGF-IGAS). Chômage
  d'équilibre : −5 chômeurs par conseiller (axe économique : expériences
  aléatoires française, autrichienne et allemande, éviction comprise). -/
def partAllegementsAuDela2Smic : Int := 343
def conseillersFranceTravail : Int := 10000
def coutConseillerEuros : Int := 80000
/-- Fusion des doublons (novembre 2026) : les 10 000 conseillers d'O-77 sont
les agents redéployés par l'automatisation (ancienne O-26b, 2 500 par an
de 2027 à 2030), déjà rémunérés ; reste la formation et l'outillage,
5 000 € par conseiller et par an (hypothèse). -/
def coutFormationConseillerEuros : Int := 5000

/-- Indice de développement humain (O-78 à O-81). L'IDH de la France (0,920
en 2023, 26e rang, PNUD) est surtout en retard sur l'éducation : une année
de durée attendue de scolarisation vaut ≈ 0,010 d'IDH, deux fois une année
d'espérance de vie (calcul). Mesures dont l'effet est documenté :

* O-78 : prix minimum de 0,50 € par verre standard d'alcool : −15 % de
  consommation, −22 % de décès par cancers liés à l'alcool (Etilé et al.,
  INCa-MILDECA, 2022) ; en Écosse, −13,4 % des décès entièrement dus à
  l'alcool (Lancet, 2023) ; sans effet net sur les finances publiques.
* O-79 : prix du tabac +20 % (paquet de ≈ 12,50 € à ≈ 15 €) par les
  accises : élasticité-prix −0,4 (Santé publique France), −8 % de
  consommation, décès attribuables (68 000 en 2023) en baisse d'autant à
  terme ; recettes calculées par le modèle commun (achats transfrontaliers
  compris dans la fuite fiscale). Le paquet de mesures de 2016-2019 (prix,
  paquet neutre, Mois sans tabac) gagne 644 000 années de vie d'ici 2050
  (OCDE et Santé publique France, Tobacco Control, 2024).
* O-80 : dépistage organisé du cancer colorectal porté de 30,7 % à 65 % de
  participation (Barré et al., 2020 : −22 % de mortalité de 34 % à 65 %) :
  ≈ 3 700 décès évités à terme ; coût des dépistages supplémentaires
  (hypothèse du modèle commun : 70 €).
* O-81 : scolarisation des 18-24 ans relevée d'un point par an pendant trois
  ans (places en BTS, IUT et universités, bourses) : +0,21 an de durée
  attendue de scolarisation, ≈ 2,2 Md€ par an à terme (13 300 € par
  étudiant, DEPP). Variante : +5 points (250 000 places, comme LFI). -/
def prixMinimumAlcoolCentimes : Int := 50
def hausseprixTabacPm : Int := 200
def participationDepistageCible : Int := 650
def hausseScolarisationParAn : Int := 10

/-- Justice : coût selon le personnel et les locaux, capacité de jugement
et délais (`Modele.Justice` ; données sourcées dans `Hypotheses.Justice`).
Les listes d'équipes commencent en 2026, avec les moyens actuels ; la mesure
agit à partir de 2027. Les affaires nouvelles restent au niveau de 2025
(hypothèse). Chaque poste créé coûte 80 969 € par an (coût moyen d'un ETPT
du programme 166), 147 812 € de locaux l'année de sa création et 6 904 € de
fonctionnement immobilier par an.

* Prud'hommes (O-10, priorité) : 120, 240 puis 330 équipes de greffe de
  2027 à 2029, chacune d'un agent de greffe et de 0,06 juge départiteur, qui
  terminent 92 affaires au fond par an ; facteur de traitement des greffes
  porté à la cible 2027 du projet annuel de performances (+5,4 %) en deux
  ans. Sans mesure, le stock croît de 22 475 affaires par an.
* Tribunaux judiciaires, matière civile (O-10) : facteur de traitement des
  magistrats du siège porté à la cible 2027 (+7,4 %) en deux ans, par
  l'équipe autour du magistrat et la numérisation (hypothèse : l'inspection
  générale de la justice juge l'effet de ces équipes « contrasté » et non
  mesuré au niveau national, février 2026), et 10, 20 puis 30 magistrats
  avec leur équipe de greffe.
* Violences sexuelles (O-82) : la Fondation des femmes évalue le besoin à
  « plus de 600 magistrats spécialisés » (synthèse 2023, p. 5). 28 formations
  de cinq magistrats renforcent les cours criminelles départementales, qui
  jugent l'essentiel des viols (8, 16, 24 puis 28 de 2027 à 2030) ; les
  460 autres magistrats, avec leur équipe de greffe, arment les pôles
  spécialisés dans les violences intrafamiliales des tribunaux (150, 300 puis
  460 de 2027 à 2029 ; pôles créés par le décret n° 2023-1077), sans
  modèle de délai faute de stock publié. -/
def anneesJustice : Nat := 10
def equipesPrudhommes : List Int := [0, 120, 240, 330]
def facteursPrudhommes : List Int :=
  [1000, (1000 + Hypotheses.Justice.facteurGreffePm) / 2, Hypotheses.Justice.facteurGreffePm]
def magistratsCivil : List Int := [0, 10, 20, 30]
def facteursCivil : List Int :=
  [1000, (1000 + Hypotheses.Justice.facteurSiegeCivilPm) / 2, Hypotheses.Justice.facteurSiegeCivilPm]
def formationsCriminelles : List Int := [0, 8, 16, 24, 28]
def magistratsPolesVif : List Int := [0, 150, 300, 460]

def capacitesPrudhommes (avecMesure : Bool) : List Int :=
  Modele.Justice.capacites Hypotheses.Justice.prudhommes anneesJustice
    (if avecMesure then facteursPrudhommes else []) (if avecMesure then equipesPrudhommes else [])
    Hypotheses.Justice.equipePrudhommes.affairesParAn
def capacitesCivil (avecMesure : Bool) : List Int :=
  Modele.Justice.capacites Hypotheses.Justice.tribunauxCivil anneesJustice
    (if avecMesure then facteursCivil else []) (if avecMesure then magistratsCivil else [])
    Hypotheses.Justice.equipeTribunal.affairesParAn
def capacitesCriminelles (avecMesure : Bool) : List Int :=
  Modele.Justice.capacites Hypotheses.Justice.coursCriminelles anneesJustice
    [] (if avecMesure then formationsCriminelles else [])
    Hypotheses.Justice.formationCriminelle.affairesParAn

/-- Délais d'écoulement du stock, dixièmes de mois, de 2026 à 2035. -/
def delaisPrudhommes (avecMesure : Bool) : List Int :=
  Modele.Justice.delais Hypotheses.Justice.prudhommes (capacitesPrudhommes avecMesure)
def delaisCivil (avecMesure : Bool) : List Int :=
  Modele.Justice.delais Hypotheses.Justice.tribunauxCivil (capacitesCivil avecMesure)
def delaisCriminels (avecMesure : Bool) : List Int :=
  Modele.Justice.delais Hypotheses.Justice.coursCriminelles (capacitesCriminelles avecMesure)
/-- Durées moyennes de traitement recalées sur 2025, dixièmes de mois. -/
def dureesPrudhommes : List Int :=
  Modele.Justice.dureesRecalees Hypotheses.Justice.prudhommes
    Hypotheses.Justice.dureePrudhommesDixiemes (capacitesPrudhommes true)
def dureesCivil : List Int :=
  Modele.Justice.dureesRecalees Hypotheses.Justice.tribunauxCivil
    Hypotheses.Justice.dureeTribunauxCivilDixiemes (capacitesCivil true)

/-- Postes créés (cumul de 2027 à 2035), par mesure. -/
def postesJusticeO10 : List Int :=
  sommeEcheanciers
    (Modele.Justice.postes Hypotheses.Justice.equipePrudhommes (equipesPrudhommes.drop 1))
    (Modele.Justice.postes Hypotheses.Justice.equipeTribunal (magistratsCivil.drop 1))
def postesJusticeO82 : List Int :=
  sommeEcheanciers
    (Modele.Justice.postes Hypotheses.Justice.formationCriminelle (formationsCriminelles.drop 1))
    (Modele.Justice.postes Hypotheses.Justice.equipeTribunal (magistratsPolesVif.drop 1))
def magistratsO82 : Int :=
  (formationsCriminelles.getLast?.getD 0) * Hypotheses.Justice.formationCriminelle.magistratsPm / 1000
    + (magistratsPolesVif.getLast?.getD 0)

/-- Leviers de coût d'un renfort de justice : postes, locaux, fonctionnement immobilier. -/
def leviersJustice (postesCumules : List Int) : List Levier :=
  [.creationPostes .securiteJustice postesCumules Hypotheses.Justice.coutEtptEuros,
   .investissementEcheancier .securiteJustice
     (Modele.Justice.investissementLocaux postesCumules Hypotheses.Justice.coutLocauxPosteEuros),
   .depenseEcheancier .securiteJustice
     (Modele.Justice.fonctionnementLocaux postesCumules Hypotheses.Justice.coutImmobilierEtptEuros)]

/-- Violences sexistes et sexuelles (O-82). Besoins de la Fondation des
femmes, hypothèse basse (« Où est l'argent contre les violences faites aux
femmes ? », septembre 2023, tableaux p. 27 et p. 30-31 : 2 367,5 M€ pour
les violences conjugales et 361,1 M€ pour les violences sexuelles hors
couple ; le texte annonce 2,6 à 5,4 Md€), moins les crédits dédiés de 2023
ligne à ligne (184,4 M€ au total, p. 31), en dixièmes de M€ :

* police et gendarmerie : enquêteurs spécialisés 2 536 + 447, intervenants
  sociaux 482 + 85, accueil 311 + 55, formation 58 + 10, plainte en ligne
  21 + 4, registre 21 + 4 ; crédits 38 + 7 et 14 + 3 ;
* justice hors pôles : aide juridictionnelle 60 + 3, téléphones grave
  danger 68 (crédits 37), formation 2 + 2 ; les bracelets anti-rapprochement
  sont déjà financés (52 pour un besoin de 9). Les pôles spécialisés
  (1 106 + 195) sont remplacés par le renfort modélisé de magistrats, de
  greffiers et de locaux (voir `anneesJustice`) ;
* mise en sécurité : hébergement 3 043, abri 34, formation des SIAO 9,
  espaces de rencontre 911, protocole féminicide 3, aide financière
  d'urgence 1 177, fonds pour les familles 6, sortie de prostitution 326
  et 205 ; crédits 1 059, 71, 47 et 16 ;
* accueil : campagnes 150 + 150, lignes d'écoute 86 + 33, maisons de
  solidarité 3 905, accueil global 57, centres d'aide d'urgence 1 000,
  harcèlement au travail 361 et 39 ; crédits 61 + 22, 209, 13 + 2 ;
* santé : soins spécialisés 222 + 4, formation des soignants 167 + 29,
  unités médico-judiciaires 120 + 6, psychotraumatologie 2 501 (femmes),
  2 501 (enfants co-victimes), 105 + 44 + 8 + 19 ; crédits 14 + 3 et 51 ;
* retour à l'emploi : allocation 1 357, insertion 151 ;
* pilotage 510 + 90 (crédits 110 + 19) ; recherche 2 152 + 328.

Recoupements dans le programme : O-85 (santé mentale, 100 M€, générale) et
O-110 (police de proximité : adjoints de sécurité, pas d'enquêteurs
spécialisés) ne financent pas ces dispositifs ; O-10 porte sur les
prud'hommes et la matière civile. Hors programme : l'État valorise 562 M€ en
2026 contre les violences (document de politique transversale, axe 2) et
le gouvernement compte ≈ 1,5 Md€ de dépenses existantes ; une partie des
besoins (enquêteurs, hébergement) y est peut-être déjà couverte, sans
décompte publié : non déduite (prudent). La loi intégrale adoptée par
l'Assemblée nationale le 13 octobre 2026 programme 3 Md€ par an de 2027
à 2032 ; le gouvernement chiffre les mesures adoptées à 3 à 4 Md€ par an. -/
def violencesPoliceDixiemes : Int := (2536 + 447 + 482 + 85 + 311 + 55 + 58 + 10 + 21 + 4 + 21 + 4) - (38 + 7 + 14 + 3)
def violencesJusticeAutresDixiemes : Int := (60 + 3) + (68 - 37) + (2 + 2)
def violencesPolesDixiemes : Int := 1106 + 195
def violencesSecuriteDixiemes : Int := (3043 + 34 + 9 + 911 + 3 + 1177 + 6 + 326 + 205) - (1059 + 71 + 47 + 16)
def violencesAccueilDixiemes : Int := (150 + 150 + 86 + 33 + 3905 + 57 + 1000 + 361 + 39) - (61 + 22 + 209 + 13 + 2)
def violencesSanteDixiemes : Int :=
  (222 + 4 + 167 + 29 + 120 + 6 + 2501 + 2501 + 105 + 44 + 8 + 19) - (14 + 3 + 51)
def violencesEmploiDixiemes : Int := 1357 + 151
def violencesPilotageDixiemes : Int := (510 + 90) - (110 + 19)
def violencesRechercheDixiemes : Int := 2152 + 328
def creditsViolencesExistants : Int := 184
/-- Besoins nets hors pôles spécialisés, M€ par an (calcul). -/
def violencesHorsPolesMeur : Int :=
  (violencesPoliceDixiemes + violencesJusticeAutresDixiemes + violencesSecuriteDixiemes
    + violencesAccueilDixiemes + violencesSanteDixiemes + violencesEmploiDixiemes
    + violencesPilotageDixiemes + violencesRechercheDixiemes) / 10

/-- Dixièmes affichés avec une virgule (« 21,4 »). -/
def virguleDixiemes (d : Int) : String := s!"{d / 10},{d % 10}"

theorem justice_delais_en_baisse :
    Modele.Justice.strictementDecroissante (delaisPrudhommes true) = true ∧
    Modele.Justice.strictementDecroissante (delaisCivil true) = true ∧
    Modele.Justice.strictementDecroissante (delaisCriminels true) = true ∧
    magistratsO82 = 600 := by
  decide

/-- Allocations familiales dès le premier enfant (O-83), proposition de loi
adoptée en première lecture le 5 juin 2025 : 70 € par mois et par enfant,
2,8 Md€ bruts par an, 1,8 Md€ nets des moindres versements de RSA et de
prime d'activité, dont les allocations sont une ressource (direction de la
Sécurité sociale, rapport AN n° 1473, p. 19-20). -/
def allocationsPremierEnfantBrut : Int := 2800
def allocationsPremierEnfantNet : Int := 1800

theorem placesPrisonNouvelles_eq : placesPrisonNouvelles = 9108 ∧ placesModulaires = 4554
    ∧ placesClassiques = 4554 ∧ placesNouvellesPour placesPrisonCibleTexte = 24108 := by decide
theorem calendrierConstruction_total : calendrierConstructionPm.foldl (· + ·) 0 = 1000
    ∧ calendrierModulairePm.foldl (· + ·) 0 = 1000 := by decide
theorem prisons_cible : placesOperationnelles2026 + placesPlan15000Restantes + placesModulairesGouvernement
    + placesModulaires * (ouvertureModulairePm.getLast?.getD 0) / 1000
    + placesClassiques * (ouverturePlacesPm.getLast?.getD 0) / 1000 = placesPrisonCible := by decide
def contributionGrandesEntreprises : Int :=
  7500 * max tauxISCible tauxMinimumPilier2 / 2500 * 103 / 100

/-- Dette numérique (O-24). OAT tokenisées, inscrites sur une chaîne de blocs
et réglées en jetons de monnaie électronique euro conformes à MiCA
(règlement (UE) 2023/1114) : c'est le mécanisme d'USDC (jeton adossé 1:1 à
des réserves, circulant sur une chaîne publique), appliqué à la dette
française. MiCA interdit de rémunérer le jeton lui-même (art. 50) : le
rendement est porté par l'OAT numérique, que le jeton sert à acheter.
Intérêts exonérés de PFU pour les particuliers résidents (31,4 % en 2026) ;
les non-résidents ne paient déjà pas d'impôt français sur ces intérêts.

* `cibleDetteNumerique` = 10 ‰ de la dette (≈ 57 Md€ en 2035 dans le
  scénario central), par paliers de `rythmeDetteNumerique` = 2 ‰ par an :
  mesure votée en 2027, première tranche fin 2028, cible atteinte en 2032.
  Le régime pilote DLT (règlement (UE) 2022/858) plafonne aujourd'hui
  l'ensemble des titres tokenisés à 6 Md€ ; la Commission propose 100 Md€
  pour toute l'Union (paquet « intégration des marchés », décembre 2025),
  les plateformes demandent au moins 150 Md€. La cible suppose un plafond
  relevé au-delà de la proposition, ou une émission hors régime pilote
  par le dépositaire central. Repère de demande : les ménages italiens
  détiennent ≈ 13 % de la dette italienne (SUERF, 2026), contre une
  détention directe marginale en France.
* `capitalisationFiscale` = 500 ‰ : part de l'avantage fiscal capitalisée
  dans le prix. Repère : obligations municipales américaines exonérées,
  ratio de rendement à Treasury ≈ 75 % à 10 ans et ≈ 91 % à 30 ans
  (2025), soit un taux implicite de 25 % et 9 % pour un taux marginal
  maximal de 40,8 % : 60 % et 22 % capitalisés ; maturité moyenne de la
  dette ≈ 8,5 ans. Décote retenue : 500 ‰ × 314 ‰ = 157 ‰ du taux.
* `partResidents` = 800 ‰ : le reste est détenu par des émetteurs de
  jetons (réserves) et des non-résidents, qui ne tirent aucun avantage de
  l'exonération.
* `partImposeeAvant` = 600 ‰ : part de l'épargne attirée qui était placée
  en produits imposés au PFU ou assimilés ; le reste vient de livrets
  exonérés (livret A, LDDS, LEP), sans perte fiscale mais avec moins de
  ressources pour le fonds d'épargne (logement social), non modélisé.

Bilan par euro de tranche, taux `y`, PFU `t`, capitalisation `θ`, part
défiscalisée `ρα` : gain = y·t·(θ − (1 − θt)·ρα). Seuil de rentabilité :
θ* = ρα / (1 + t·ρα) = 0,48 / 1,151 ≈ 0,417 ; avec θ = 0,5 le gain est
≈ 0,030·y, soit ≈ 10 pb sur la tranche quand y = 3,3 % (≈ 56 M€/an en
2035 : 294 M€ d'intérêts économisés, 238 M€ de PFU perdus). -/
def cibleDetteNumerique : Int := 10
def rythmeDetteNumerique : Int := 2
def capitalisationFiscale : Int := 500
def partResidents : Int := 800
def partImposeeAvant : Int := 600

/-! ## Mesures -/

/-! ## O-124 à O-128 — Tenue des propriétés au scénario central (octobre 2026)

Mesures ajoutées pour que chaque propriété non tenue au scénario central
le soit dans au moins 18 des 36 scénarios sous les trois moteurs, quand
c'est atteignable avec des mesures sourcées : déficit sous le plafond
juridique en 2030, déficit sous 3 % en 2035, baisse du déficit chaque
année, chômage de 2030 non dégradé, émissions de 2030 sous 300 Mt (voir
README, « Propriétés »). -/

/-- Composante carbone remise sur sa trajectoire (O-124). Gelée à 44,6 €/t
depuis 2018 ; la loi n° 2015-992 (transition énergétique, art. 1) visait
100 €/t en 2030 : +55,4 €/t, en quatre hausses égales de 2027 à 2030.
Assiettes : voitures particulières, 53,24 % des émissions des transports
en 2024 (Citepa, via la FNTR), appliqués aux 122,9 Mt de 2025 : 65,4 Mt
(calcul) ; chauffage au fioul et au gaz, 85 % des 54,9 Mt des bâtiments
(hypothèse : hors gaz fluorés) : 46,7 Mt. Hausse de prix : gazole
+14,7 c€ HT par litre (2,65 kg CO₂/l), +10,7 % TTC sur 1,648 €/l ;
SP95-E10 +12,6 c€ (2,28 kg/l), +8,8 % sur 1,714 €/l (moyennes 2025,
prix-carburant.eu ; facteurs d'émission usuels, hypothèse) ; moyenne
9,8 % (moitié gazole, hypothèse), 24 ‰ par étape ; gaz +1,26 c€ HT par
kWh (0,227 kg/kWh), +12,6 % TTC sur ≈ 12 c€/kWh (hypothèse), 31 ‰ par
étape. Élasticités-prix du modèle commun (0,6 et 0,3). Rendement statique :
65,4 × 55,4 = 3 624 M€ et 46,7 × 55,4 = 2 585 M€ (calcul), dont 2,5 Md€
reversés aux ménages modestes en chèque énergie (`chequeCarbone` ; la moitié du rendement, 3 104 M€, en
variante). -/
def assietteVoituresKt : Int := 122900 * 5324 / 10000
def assietteChauffageKt : Int := 54900 * 85 / 100
def hausseCarbone : Int := 554
def rendementCarboneVoitures : Int := assietteVoituresKt * hausseCarbone / 10000
def rendementCarboneChauffage : Int := assietteChauffageKt * hausseCarbone / 10000
def chequeCarbone : Int := 2500
def chequeCarboneMoitie : Int := (rendementCarboneVoitures + rendementCarboneChauffage) / 2

theorem carbone_valeurs : assietteVoituresKt = 65431 ∧ assietteChauffageKt = 46665 ∧
    rendementCarboneVoitures = 3624 ∧ rendementCarboneChauffage = 2585 ∧ chequeCarboneMoitie = 3104 := by decide

/-- Amendes proportionnelles aux revenus (O-125), sur le modèle des
jours-amendes nordiques : l'amende est le montant actuel multiplié par le
rapport entre le niveau de vie du contrevenant et le niveau de vie médian,
sans pouvoir être inférieure au montant actuel.
Amendes de la circulation et du stationnement encaissées en 2025 :
2,13 Md€ pour 45 millions de contraventions (Cour des comptes, via
L'argus, 13 octobre 2026). Niveaux de vie 2024 (Insee) : médiane 26 740 €,
D6 29 880, D7 33 680, D8 38 780, D9 48 580 € ; moyenne du dernier décile
1,5 × D9 (hypothèse) ; contrevenants répartis comme la population
(hypothèse). Supplément moyen = Σ (milieu de chaque dixième au-dessus de la
médiane − médiane) / (10 × médiane) = 79 170 / 267 400 ≈ 29,6 % (calcul),
soit 630 M€ par an ; effet dissuasif non compté. -/
def amendesCirculation : Int := 2130
def excedentNiveauxDeVie : Int :=
  (28310 - 26740) + (31780 - 26740) + (36230 - 26740) + (43680 - 26740) + (48580 * 3 / 2 - 26740)
def recettesAmendesProportionnelles : Int := amendesCirculation * excedentNiveauxDeVie / (10 * 26740)

theorem amendes_valeurs : excedentNiveauxDeVie = 79170 ∧ recettesAmendesProportionnelles = 630 := by decide

/-- Contrats aidés non marchands (O-127, parcours emploi compétences) :
32 000 financés en 2025, aidés à 37 % (circulaire DGEFP, via Carenews,
15 mai 2025), contre plus de 300 000 contrats aidés avant 2017. Le
programme finance 175 000 contrats en cours (87 500 de plus en 2027 et en
2028, 200 000 en variante), aidés à 60 % du SMIC brut sur 26 heures par semaine : 12,02 € ×
26 × 52 × 60 % = 9 750 € par contrat et par an (calcul). Effet net sur
l'emploi : dans le secteur non marchand, à budget constant de l'employeur,
il est égal au taux de prise en charge, 0,6 emploi par contrat (Insee,
Note de conjoncture, décembre 2019), soit 400 ‰ d'effet d'aubaine. -/
def contratsAidesParAn : Int := 87500
def aideContratAideEuros : Int := 1202 * 26 * 52 * 60 / 100 / 100

theorem contratsAides_valeurs : aideContratAideEuros = 9750 := by decide

/-- Leasing social électrique (O-128) : 135 000 voitures par an (150 000 en
variante ; à 125 000, la mortalité liée à l'air dépasse le tendanciel en
2030, propriété « air-non-degrade », calcul) à 6 000 €
d'aide (6 Md€ pour un million de voitures, même coût unitaire que la
proposition de R. Glucksmann, PP-04) ; 50 000 voitures par édition depuis
2024. Émissions évitées par le sous-modèle automobile du modèle commun. -/
def leasingSocialParAn : Int := 135000
def leasingSocialAideEuros : Int := 6000

/-- Recouvrements entre mesures (passe d'octobre 2026).
* Niches fiscales : les rabots généraux (O-40 : −10 % ; O-57 : −2 % par an ;
  O-62 : −1,5 Md€ par an sur 88,3 Md€ de dépenses fiscales en 2026, PLF 2026)
  ne portent pas sur ce que O-69 (CIR recentré, 960 M€) et O-73
  (défiscalisation des heures supplémentaires, moitié des 2 Md€ d'impôt sur
  le revenu) suppriment déjà : chaque rabot est diminué de son taux
  appliqué à ces montants.
* Autonomie : la contribution d'O-84, affectée à l'autonomie, finançait
  d'abord le fonctionnement des places d'Ehpad publics (O-109b) et la
  revalorisation des aides à domicile (O-120), seul le reste étant une
  dépense nouvelle ; O-84 retirée (novembre 2026), elles sont financées par
  le budget général (`depenseAutonomieNouvelle` sert à l'option « deuxième
  journée de solidarité »). -/
def depensesFiscales2026 : Int := 88300
def recouvrementNichesIr : Int := heuresSupIr * partDefiscalisationSupprimeePm / 1000
def recouvrementNichesIs : Int := cirRecentre
def autonomieDejaFinancee : List Int :=
  (0 :: fonctionnementEhpad).map (· + revalorisationAidesDomicile)
def depenseAutonomieNouvelle : List Int :=
  autonomieDejaFinancee.map fun x => max 0 (contributionSolidariteAutonomie - x)

theorem recouvrements_valeurs : recouvrementNichesIr = 1000 ∧ recouvrementNichesIs = 960 ∧
    depenseAutonomieNouvelle = [2072, 1898, 1723, 1548, 1373, 1198] := by decide

/-- Dirigeants d'institutions publiques (O-129) : −20 % de rémunération.
Périmètre : 881 emplois de cadres dirigeants de l'État (directeurs
d'administration centrale, préfets, ambassadeurs, recteurs… : observatoire
des cadres supérieurs de la Diese, novembre 2025), 431 opérateurs de l'État
(Louvre, CNES, universités… : jaune « Opérateurs », PLF 2026) et
24 autorités administratives et publiques indépendantes (jaune, PLF 2025).
Rémunérations brutes annuelles : 166 000 € pour un cadre dirigeant
(11 490 € nets par mois en moyenne pour les secrétaires généraux et
directeurs d'administration centrale, DGAFP 2019, ratio net/brut de 0,83 :
hypothèse) ; 135 000 € pour un dirigeant d'opérateur (part fonctionnelle de
la directrice générale de l'EPA Euroméditerranée, 2023 : exemple, hypothèse) ;
190 000 € pour un président d'autorité (Arcom 194 374 €, Autorité de la
concurrence 220 398 € en 2023 : hypothèse). Coût complet × 1,5 (comme O-49).
Les cadres dirigeants sont déjà dans l'encadrement d'O-49 (−5 %) : 15 points
de plus pour eux, 20 pour les autres. Économie : ≈ 51,7 M€ (calcul). -/
def cadresDirigeants : Int := 881
def dirigeantsOperateurs : Int := 431
def presidentsAutorites : Int := 24
def remunerationCadreDirigeantEuros : Int := 166000
def remunerationDirigeantOperateurEuros : Int := 135000
def remunerationPresidentAutoriteEuros : Int := 190000
def economieDirigeants : Int :=
  (cadresDirigeants * remunerationCadreDirigeantEuros * 15 / 100
    + (dirigeantsOperateurs * remunerationDirigeantOperateurEuros
       + presidentsAutorites * remunerationPresidentAutoriteEuros) * 20 / 100) * 150 / 100 / 1000000

theorem dirigeants_valeurs : economieDirigeants = 51 := by decide

/-- Un commissariat dans chaque ville de plus de 30 000 habitants (O-130).
287 communes de plus de 30 000 habitants (populations de référence 2023,
INSEE) ; aucun recensement public de celles qui n'ont pas de commissariat.
Deux cas documentés : (1) les communes en zone gendarmerie, toutes outre-mer
— huit à La Réunion (Saint-Paul, Le Tampon, Saint-Louis, Saint-Joseph,
Saint-Benoît, Sainte-Marie, La Possession, Saint-Leu : 433 243 habitants,
réponse à la question orale n° 1267, 2021) et Saint-Laurent-du-Maroni
(54 429) — passent en police d'État, au ratio d'un policier pour
478 habitants des communes passées en zone police en 2003-2006 (Cour des
comptes, 2011) : 1 020 policiers de plus (calcul), les gendarmes étant
redéployés dans le reste de la zone gendarmerie (hypothèse) ; (2) les
communes en zone police sans commissariat sur leur territoire (Six-Fours,
Tremblay-en-France, Viry-Châtillon, Sevran, Puteaux, Liévin, Trappes… :
huit cas documentés, « plusieurs dizaines » probables) : 30 (hypothèse),
servies par les effectifs de leur circonscription. Coût d'un commissariat de
60 à 100 agents : 10 M€ hors foncier (1 500 à 2 500 m² à 5 000 à 5 500 €/m² :
Villeneuve-Saint-Georges 12,5 M€ pour 2 500 m², Aubagne 13 M€ ; hypothèse),
bâtis de 2027 à 2030. Coût complet d'un policier : 78 848 €, pensions
comprises (programme 176, PLF 2026 : 12 086,4 M€ pour 153 286 ETPT ;
Assemblée nationale, rapport n° 1996). Recrutements en quatre ans. -/
def habitantsZoneGendarmerie30000 : Int :=
  108088 + 82579 + 54941 + 39207 + 38604 + 37093 + 36568 + 36163 + 54429
def habitantsParPolicier : Int := 478
def policiersCommissariats : Int := habitantsZoneGendarmerie30000 / habitantsParPolicier
def communesZonePoliceSansCommissariat : Int := 30
def communesZoneGendarmerie30000 : Int := 9
def coutCommissariat : Int := 10
def coutPolicierEuros : Int := 12086400000 / 153286
def investissementCommissariats : Int :=
  (communesZoneGendarmerie30000 + communesZonePoliceSansCommissariat) * coutCommissariat
def postesCommissariats : List Int := [1, 2, 3, 4].map (policiersCommissariats * · / 4)

theorem commissariats_valeurs : habitantsZoneGendarmerie30000 = 487672 ∧ policiersCommissariats = 1020 ∧
    coutPolicierEuros = 78848 ∧ investissementCommissariats = 390 ∧
    postesCommissariats = [255, 510, 765, 1020] := by decide

/-- Indemnisation forfaitaire des personnes blessées lors d'une intervention
de police ou de gendarmerie (O-131), sans attendre un jugement : 5 000 € pour
une incapacité totale de travail d'au moins 8 jours (souffrances endurées de
3 à 4 sur 7 : 3 619 à 7 201 € au référentiel de l'ONIAM, juillet 2025),
1 000 € en deçà (hypothèse). Blessés recensés avec au moins 8 jours d'ITT :
≈ 125 par an (IGPN : 79 en 2021, 66 en 2022 ; IGGN : 46 en 2025) ; blessés plus
légers : aucun recensement, 3 000 par an (hypothèse à sourcer). Coût :
≈ 3,6 M€ par an, arrondi à 4 (calcul), en partie déjà dû par l'État (responsabilité sans
faute envers les tiers, CE 1949 Lecomte ; contentieux du programme 216 :
126 M€ exécutés en 2025, tous motifs). -/
def blessesGraves : Int := 125
def blessesLegers : Int := 3000
def forfaitBlesseGraveEuros : Int := 5000
def forfaitBlesseLegerEuros : Int := 1000
def indemnisationBlesses : Int :=
  (blessesGraves * forfaitBlesseGraveEuros + blessesLegers * forfaitBlesseLegerEuros + 500000) / 1000000

theorem blesses_valeurs : indemnisationBlesses = 4 := by decide

/-- Second porte-avions (O-133) : coût de la réalisation du premier (PANG,
10 251 M€ d'autorisations d'engagement en LFI 2025 : Assemblée nationale,
avis n° 2048, 2025) diminué de 30 % d'effet de série (30 à 40 % selon le
Sénat, rapport n° 559, 2020 ; le second porte-avions de 2008 n'en promettait
aucun : Assemblée nationale, rapport n° 717) : 7 176 M€. La forme de
Saint-Nazaire est occupée par le premier jusqu'en 2035 environ : études et
commandes à long délai (chaufferies, ≈ 600 M€ comme en 2024 pour le
premier) jusqu'en 2030, puis début de la réalisation ; profil du second
porte-avions de 2008 pour les trois premières années (3 %, 7 %, puis
600 M€), 460 M€ par an ensuite (hypothèse) : ≈ 3,6 Md€ d'ici 2035, le reste
après l'horizon. Hors groupe aérien supplémentaire (≈ 1,2 Md€ pour
10 Rafale de plus) et coût de possession (≈ 250 à 350 M€ par an) après la mise
en service, vers 2042-2044. -/
def coutPremierPorteAvions : Int := 10251
def coutSecondPorteAvions : Int := coutPremierPorteAvions * 700 / 1000
def echeancierPorteAvions : List Int :=
  [0, coutSecondPorteAvions * 3 / 100, coutSecondPorteAvions * 7 / 100, 600, 460, 460, 460, 460, 460]

theorem porteAvions_valeurs : coutSecondPorteAvions = 7175 ∧
    echeancierPorteAvions.foldl (· + ·) 0 = 3617 := by decide

/-- Lancements de satellites sur lanceurs européens (O-134) : deux Ariane 62
(82,07 M€ payés par l'ESA pour Sentinel-1D en 2025) et un Vega-C (51,65 M€
pour Sentinel-1C) de plus par an pour des satellites institutionnels
français, et des achats d'ancrage de mini-lanceurs français (enveloppe
France 2030 de ≈ 400 M€ pour MaiaSpace, Latitude, HyPrSpace et Sirius,
reconduite sur cinq ans : 80 M€ par an, hypothèse). Prix via European
Spaceflight (contrats de l'ESA, avril 2026). ≈ 296 M€ par an (calcul),
lancement seul : les charges utiles relèvent des programmes du CNES et des
armées. Accord de Séville (2023) : 4 Ariane 6 et 3 Vega-C institutionnels
européens par an jusqu'en 2030. -/
def prixAriane62 : Int := 8207
def prixVegaC : Int := 5165
def achatsMiniLanceurs : Int := 80
def programmeLancements : Int := (2 * prixAriane62 + prixVegaC) / 100 + achatsMiniLanceurs

theorem lancements_valeurs : programmeLancements = 295 := by decide

/-- Plan méthane des déchets (O-135, O-135b). Le stockage des déchets non
dangereux (ISDND) émet 11,4 Mt CO₂e en 2024, uniquement du méthane, soit 75 %
du secteur des déchets (15,3 Mt ; Citepa, Secten 2026). Objectif de la
SNBC-3 : 12 Mt en 2030 (−28 % par rapport à 1990 : résumé de la SNBC-3,
juillet 2026), et 12 Mt par an en moyenne de 2029 à 2033 (décret
n° 2026-636, art. 3). Le méthane d'un déchet stocké se dégage sur des années
(décroissance du premier ordre du GIEC, lignes directrices 2006, vol. 5,
chap. 3, tableau 3.3, climat tempéré humide : demi-vie de sept ans pour les
déchets en vrac, ≈ 3,7 ans pour les déchets alimentaires) : d'ici 2030, c'est
surtout le captage du biogaz des alvéoles existantes qui compte. Quatre
volets :
* captage renforcé (arrêté ISDND : captage dès l'exploitation, couvertures,
  mesure des fuites), porté de ≈ 45 % (DREAL Hauts-de-France, janvier 2025,
  sans source primaire : hypothèse) à 55 % en 2030, le quart de l'écart à
  la cible nationale de 85 % (même source), 2,5 points de plus par an de
  2027 à 2030 (hypothèse). Avec 10 % du méthane oxydé dans la couverture
  (GIEC, valeur par défaut), le méthane produit vaut 11 400 / (0,55 × 0,9)
  ≈ 23 030 kt CO₂e en 2024 (calcul), ramené au milieu de la montée (2028)
  par la baisse tendancielle du secteur (`baisseEmissionsAME`) ; chaque
  point de captage évite alors ≈ 190 kt (calcul). Coût ≈ 20 €/t CO₂e évitée
  (12 à 22 €/t : E-CUBE pour Waga Energy, Suez et Veolia, novembre 2023,
  étude financée par la profession), aidé à 50 % par l'ADEME (hypothèse) et
  versé en entier dès 2027 (prudent), et 5 M€ par an de contrôles
  (hypothèse) ;
* TGAP modulée selon le captage mesuré, bonus-malus à recette constante
  (hypothèse) : sans coût. Depuis 2025, la TGAP ne distingue plus les
  installations qui valorisent leur biogaz (BOFiP, BOI-BAREME-000039) ;
* aide au tri à la source des biodéchets rétablie : 100 M€ par an (Fonds
  vert depuis 2023, mesure supprimée en 2026 : Les EPL, avril 2026) ;
* Fonds économie circulaire de l'ADEME ramené à son niveau de 2024 : 301 M€
  d'autorisations d'engagement contre 95 en 2026 (Sénat, rapport n° 139,
  2025-2026, tome III, annexe 10), soit +206 M€ par an.
Les deux derniers volets rétablissent les moyens de 2024, quand a été
observée la baisse sur laquelle est calée la tendance du secteur (−2,2 % par
an en 2024-2025, `baisseEmissionsAME`) : leur effet sur les émissions est
supposé déjà dans la tendance et n'est pas compté en plus ; sans eux, cette
tendance serait moins sûre. -/
def emissionsStockageKt : Int := 11400
def captageInitialPm : Int := 450
def oxydationCouverturePm : Int := 100
def methaneProduitKt : Int :=
  emissionsStockageKt * 1000000 / ((1000 - captageInitialPm) * (1000 - oxydationCouverturePm))
/-- Facteur de la baisse tendancielle des déchets sur `n` années, pm. -/
def facteurTendancielDechetsPm (n : Nat) : Int :=
  (List.range n).foldl (fun f _ => f * (1000 - Hypotheses.Eco.baisseEmissionsAME.dechets) / 1000) 1000
/-- Années de 2024 (inventaire) à 2028 (milieu de la montée). -/
def anneesJusquAuMilieuMontee : Nat := 4
def methaneProduitMilieuMonteeKt : Int :=
  methaneProduitKt * facteurTendancielDechetsPm anneesJusquAuMilieuMontee / 1000
def ktParPointCaptage : Int := methaneProduitMilieuMonteeKt * (1000 - oxydationCouverturePm) / 1000 / 100
def pointsCaptage2030 : Int := 10
/-- Années de montée des plans méthane et azote (2027 à 2030). -/
def anneesMontee : Nat := 4
def captageEviteParAnKt : Int := ktParPointCaptage * pointsCaptage2030 / anneesMontee
def coutAbattementCaptageEuros : Int := 20
def aideCaptagePm : Int := 500
def aideCaptageBiogaz : Int :=
  ktParPointCaptage * pointsCaptage2030 * coutAbattementCaptageEuros / 1000 * aideCaptagePm / 1000
def controlesIsdnd : Int := 5
def aideBiodechets : Int := 100
def fondsEconomieCirculaire2024 : Int := 301
def fondsEconomieCirculaire2026 : Int := 95
def planMethaneDechets : Int :=
  aideCaptageBiogaz + controlesIsdnd + aideBiodechets + (fondsEconomieCirculaire2024 - fondsEconomieCirculaire2026)
/-- Variante : 7 points de captage en 2030 au lieu de 10 (hypothèse). -/
def pointsCaptageBas : Int := 7

theorem dechets_valeurs : methaneProduitKt = 23030 ∧ facteurTendancielDechetsPm 4 = 913 ∧
    ktParPointCaptage = 189 ∧ captageEviteParAnKt = 472 ∧ aideCaptageBiogaz = 18 ∧
    planMethaneDechets = 329 := by decide

/-- Plan azote et effluents (O-136, O-136b), hors engins (O-31) et production
d'engrais (O-104). Agriculture : 77,5 Mt CO₂e en 2024, 76,6 Mt en 2025
(Citepa, Secten 2026) ; objectif de la SNBC-3 : 68 Mt en 2030 (67 Mt par an
en moyenne de 2029 à 2033, décret n° 2026-636, art. 3) ; engrais minéraux
azotés −30 % en 2030 par rapport à 2020, couverture des fosses généralisée,
méthanisation, sans tonnage par levier (ministère, page SNBC agriculture,
juin 2026). Trois volets :
* fosses à lisier couvertes avec torchère : 1 250 élevages par an de 2027 à
  2030 (hypothèse : 5 000 en 2030, le quart des 20 000 retenus par l'INRA,
  « Quelle contribution de l'agriculture française à la réduction des
  émissions de gaz à effet de serre ? », 2013, action 9 : 3,4 Mt par an),
  140 t CO₂e évitées par élevage (hypothèse, fourchette de 95 à 190 t
  d'après l'INRA converti aux PRG actuels et minoré pour le recul du
  cheptel), 105 000 € d'investissement (81 200 € en 2013 selon l'INRA, +30 %,
  hypothèse) aidés à 60 % (hypothèse ; 40 % pour l'aide PE-ELEVAGE de 2024) ;
* légumineuses : 75 000 ha de plus par an (300 000 ha en 2030, pour ≈ 1 Mha
  et une cible de 2,7 Mha : SGPE, revue sectorielle agriculture, mars
  2026), 150 € par hectare (hypothèse, en plus de l'aide couplée de 122 à
  124 €/ha), 120 kg d'azote minéral évités par hectare (hypothèse,
  fourchette de 80 à 160), à 5,4 kg CO₂e par kg d'azote : les engrais
  minéraux émettent 12,8 % des 77,5 Mt de l'agriculture en 2024, soit
  9,92 Mt (Secten 2026, calcul), pour 1 831 kt d'azote livré (SGPE)
  (calcul) ;
* additif anti-méthane (3-NOP) pour 75 000 vaches laitières de plus par an
  (300 000 en 2030, hypothèse), 117 kg de méthane entérique par vache et par
  an (GIEC, lignes directrices 2006, vol. 4, chap. 10, tableau 10.11, Europe
  de l'Ouest : valeur prudente pour des vaches françaises plus
  productives), PRG de 28 (inventaire, AR5), −25 % (−25 à −31 % à l'essai de
  l'INRAE à Theix ; −15 à −40 % selon l'Idele) (calcul : 819 kg CO₂e évités
  par vache) ; 0,28 € par vache et par jour (Idele, 2025), payé en entier
  (hypothèse).
Ces pratiques ne réduisent les émissions de l'inventaire que si le Citepa
les intègre à ses données d'activité. L'objectif de 68 Mt suppose aussi que
la conversion électrique des exploitations (O-31) atteint son plafond. Ni
l'aide de 2026 à l'achat d'engrais azotés (145 M€) n'est modifiée, ni la
redevance sur l'azote proposée par l'IGF (30 €/t, 2023 ; amendement I-786
rejeté au PLF 2026) n'est reprise. -/
def elevagesFossesParAn : Int := 1250
def tonnesEviteesParFosse : Int := 140
def investissementFosseEuros : Int := 105000
def aideFossePm : Int := 600
def aideFosses : Int := elevagesFossesParAn * investissementFosseEuros / 1000 * aideFossePm / 1000000
def legumineusesHaParAn : Int := 75000
def azoteEviteKgParHa : Int := 120
def emissionsAgriculture2024Kt : Int := 77500
def partEngraisMinerauxPm : Int := 128
def emissionsEngraisMinerauxKt : Int := emissionsAgriculture2024Kt * partEngraisMinerauxPm / 1000
def livraisonsAzoteKt : Int := 1831
def co2eParKgAzoteDixiemes : Int := emissionsEngraisMinerauxKt * 10 / livraisonsAzoteKt
def legumineusesEviteesKt (kgParHa : Int) : Int :=
  legumineusesHaParAn * kgParHa * co2eParKgAzoteDixiemes / 10 / 1000000
def aideLegumineusesEurosParHa : Int := 150
def vachesAdditifParAn : Int := 75000
def methaneEnteriqueKgParVache : Int := 117
def prgMethane : Int := 28
def baisseAdditifPm : Int := 250
def evitementAdditifKgParVache : Int := methaneEnteriqueKgParVache * prgMethane * baisseAdditifPm / 1000
def additifEviteKt : Int := vachesAdditifParAn * evitementAdditifKgParVache / 1000000
def coutAdditifCentimesParJour : Int := 28
def joursParAn : Int := 365
/-- Aides annuelles ajoutées chaque année de 2027 à 2030 (légumineuses et
additif), M€ arrondis à l'unité. -/
def aidesAgricolesParAn : Int :=
  (legumineusesHaParAn * aideLegumineusesEurosParHa
    + vachesAdditifParAn * coutAdditifCentimesParJour * joursParAn / 100 + 500000) / 1000000
def agricultureEviteeParAnKt : Int :=
  elevagesFossesParAn * tonnesEviteesParFosse / 1000 + legumineusesEviteesKt azoteEviteKgParHa + additifEviteKt
/-- Variante basse : 95 t par fosse, 80 kg d'azote par hectare, additif non
pris en compte par l'inventaire (bas des fourchettes). -/
def tonnesEviteesParFosseBas : Int := 95
def azoteEviteKgParHaBas : Int := 80
def agricultureEviteeParAnBasKt : Int :=
  elevagesFossesParAn * tonnesEviteesParFosseBas / 1000 + legumineusesEviteesKt azoteEviteKgParHaBas

theorem agriculture_valeurs : aideFosses = 78 ∧ emissionsEngraisMinerauxKt = 9920 ∧
    co2eParKgAzoteDixiemes = 54 ∧ legumineusesEviteesKt azoteEviteKgParHa = 48 ∧
    evitementAdditifKgParVache = 819 ∧ additifEviteKt = 61 ∧ aidesAgricolesParAn = 19 ∧
    agricultureEviteeParAnKt = 284 ∧ agricultureEviteeParAnBasKt = 150 := by decide

/-- Déchetteries publiques gratuites pour tous (O-137) : sans quota de
passages pour les particuliers, sans droit d'entrée pour les artisans,
l'État compensant les recettes perdues par les collectivités (transfert
interne aux administrations publiques, neutre sur le solde consolidé). Les
déchetteries sont financées surtout par la taxe d'enlèvement des ordures
ménagères (77 % du financement du service public des déchets en 2023 :
IGF-IGEDD, mars 2026) ; certaines collectivités limitent les passages des
particuliers ou les facturent au-delà d'un quota, et l'accès des artisans
est le plus souvent payant (Amorce, enquête de 2013). Dépôts sauvages : 340 à
420 M€ par an d'enlèvement et de nettoyage (ministère de la Transition
écologique, 2019) ; entreprises et artisans en sont les auteurs dans 24 %
des cas, et le refus de payer l'accès des entreprises en déchetterie ou la
tarification incitative est la cause citée dans 20 % des cas (ADEME,
enquête 2019 auprès des collectivités). Aucune élasticité des dépôts
sauvages au prix d'accès des professionnels n'a été trouvée (la
tarification au sac des ménages en reporte une partie vers les dépôts
illégaux : Fullerton et Kinnaman, American Economic Review, 1996).
Chiffrage, en M€ par an :
* recettes perdues sur les professionnels : aucun total national ; 1 € par
  habitant (hypothèse calée sur Seine-Eure, 0,57 € en 2023, Miribel,
  0,4 €, et Questembert, au plus 3,0 € en 2021 : rapports annuels), pour
  69,08 millions d'habitants (INSEE, 1er janvier 2026) ;
* quotas des particuliers supprimés : 5 millions d'habitants concernés
  (hypothèse, sur ≈ 9 millions en tarification incitative, où les quotas
  sont fréquents : Localtis, février 2025), 0,2 passage hors quota par
  habitant (Clisson Sèvre et Maine, 2024 : 12 059 passages pour 58 933
  habitants, calcul), 7 € par passage (Mauges : 5,76 à 8,63 € HT,
  hypothèse) ;
* tonnages reçus en plus : 0,4 Mt (hypothèse : dépôts sauvages ramenés en
  déchetterie, ≈ 1 Mt par an selon Gestes propres, et apports des artisans
  qui allaient en déchetterie professionnelle privée) à 97 € par tonne, la
  part du traitement des flux (57 % à Mauges, 2024) dans le coût aidé de
  171 €/t des déchetteries (IGF-IGEDD, mars 2026 ; calcul) ;
* nettoyage évité : 380 M€ (milieu de la fourchette de 2019) × 24 % de dépôts
  des professionnels × 30 % évités par la gratuité (hypothèse) × 84 %, la
  part qui n'est pas déjà financée par le fonds « dépôts sauvages » de la
  filière à responsabilité élargie des déchets du bâtiment (≈ 60 M€ sur
  380 : réponse à la question écrite n° 18121, septembre 2026 ; calcul).
La filière des déchets du bâtiment (REP PMCB) reprend déjà sans frais les
déchets triés des artisans dans les déchetteries sous contrat (48 % des
déchetteries publiques fin 2024 : ADEME, bilan 2024 de la filière). Sa
refondation, en discussion pour 2027, supprimerait cette reprise pour les
petits volumes : la mesure garantirait alors la gratuité, et l'État paierait
en plus ce que paie aujourd'hui la filière pour ces volumes, non chiffré
(coût conditionnel, non compté). Les recettes observées dans les rapports
annuels tiennent déjà compte de la reprise sans frais. Variante haute :
2 € par habitant et 1 Mt reçue en plus, surtout des apports détournés des
déchetteries professionnelles privées (le nettoyage évité ne change pas). -/
def habitantsMilliers2026 : Int := 69082
def recettesProsCentimesParHabitant : Int := 100
def recettesProsDechetteries (centimes : Int) : Int := habitantsMilliers2026 * centimes / 100000
def habitantsQuotasMilliers : Int := 5000
def passagesHorsQuotaPm : Int := 200
def prixPassageCentimes : Int := 700
def quotasDechetteries : Int := habitantsQuotasMilliers * passagesHorsQuotaPm * prixPassageCentimes / 100000000
def tonnagesDechetteriesKt : Int := 400
def coutAideDechetterieEurosParT : Int := 171
def partTraitementFluxPm : Int := 570
def coutMarginalDechetterieEurosParT : Int := coutAideDechetterieEurosParT * partTraitementFluxPm / 1000
def tonnagesDechetteries (kt : Int) : Int := kt * coutMarginalDechetterieEurosParT / 1000
def coutDepotsSauvages : Int := 380
def partDepotsProfessionnelsPm : Int := 240
def depotsEvitesPm : Int := 300
def partHorsFondsRepPm : Int := 840
def nettoyageEvite : Int :=
  coutDepotsSauvages * partDepotsProfessionnelsPm * depotsEvitesPm * partHorsFondsRepPm / 1000000000
/-- Variante haute (hypothèses). -/
def recettesProsCentimesParHabitantHaut : Int := 200
def tonnagesDechetteriesHautKt : Int := 1000

theorem dechetteries_valeurs : recettesProsDechetteries recettesProsCentimesParHabitant = 69 ∧
    quotasDechetteries = 7 ∧ coutMarginalDechetterieEurosParT = 97 ∧
    tonnagesDechetteries tonnagesDechetteriesKt = 38 ∧ nettoyageEvite = 22 ∧
    recettesProsDechetteries recettesProsCentimesParHabitantHaut = 138 ∧
    tonnagesDechetteries tonnagesDechetteriesHautKt = 97 := by decide

/-- Mesures originales d'octobre 2026 (O-138, O-139), pour tenir des
propriétés non tenues (parc électrique de 2030, LPM 2024-2030).

* O-138 : rétrofit électrique massif des voitures thermiques (arrêté du
  13 mars 2020, levier `retrofitElectrique` du modèle commun). Il manque
  ≈ 520 000 voitures électriques au parc de 2030 pour 15 %. Les ventes
  neuves y sont électriques à 63 % (1,05 million sur 1,665) : une aide en
  achète peu, l'aubaine absorbant l'essentiel (O-05, O-128) ; une
  obligation sur les ventes ou les flottes en ajouterait : la variante
  oblige les flottes d'entreprises et de location à acheter électrique,
  100 000 voitures de plus chaque année jusqu'à 400 000 en 2030
  (hypothèse ; les personnes morales achètent une grande part des voitures
  neuves), soit ≈ 1,1 million de voitures électriques de plus en 2030,
  sans coût public ; une conversion, elle, ajoute une voiture électrique
  au parc sans passer par les ventes neuves. 135 000 conversions par an de 2027 à 2030
  (540 000), l'ordre de grandeur du scénario haut de l'ADEME (510 600
  voitures rétrofitées fin 2028 ; « Conditions nécessaires à un rétrofit
  économe, sûr et bénéfique pour l'environnement », mai 2021, d'après le
  Journal de l'Automobile du 21 mai 2021), hypothèse. Risque d'exécution
  très élevé : ≈ 740 conversions aidées par an en 2025 (552 primes sur neuf
  mois, amendement n° 1192 au PLF 2026), 42 kits homologués, faillites de
  Lormauto (2025) et de Tolv (2025). Coût d'une conversion : 17 500 € « tout
  compris » (hypothèse de l'ADEME reprise par Forum Vies Mobiles, étude
  2024 ; 15 000 à 20 000 € selon le ministère de la Transition écologique,
  20 novembre 2025) ; consentement à payer ≈ 3 000 € (Forum Vies Mobiles) :
  aide de 14 500 € (calcul ; la prime actuelle va jusqu'à 5 000 €). Part
  importée : 60 % du kit (hypothèse : cellules de batterie importées, 50 à
  70 %), le kit faisant 12 350 € d'un prix de 21 000 € (ADEME, 2021), soit
  35 % de la valeur de la conversion (calcul). Vignette Crit'Air : moyenne
  du parc. CO₂ évité : 1,7 t par voiture
  et par an (axe énergie ; 1,3 à 1,5 t avec la fabrication du kit, que
  l'inventaire ne compte pas).
* O-139 : drones de masse et bouclier anti-drones des points d'importance
  vitale, en plus des 2 Md€ de drones et 1,6 Md€ d'anti-drones ajoutés par
  la loi n° 2026-791 (LCP, 20 avril 2026 ; Breaking Defense, avril 2026).
  Drones, chaque année : 3 000 munitions téléopérées longue portée de type
  Chorus à 110 000 € (DGA, audition à l'Assemblée du 15 avril 2026, via le
  Journal du Geek du 9 juin 2026 ; capacité de 600 par mois au Mans),
  25 000 drones FPV à 4 000 € (3 000 à 5 000 €, L'Essentiel de l'Éco,
  22 juillet 2026) et 20 000 micro-drones d'observation à 1 000 € (moins de
  1 000 €, Clubic, 22 février 2026). Anti-drones : systèmes de type PARADE à
  5,5 M€ l'un (33 M€ pour la tranche ferme de six systèmes, Defense News,
  28 avril 2022 ; calcul, développement compris), 120 en 2027, 80 en 2028,
  30 en 2029 et 20 en 2030 (hypothèse), sur 1 369 points d'importance vitale
  (SGDSN) ; fonctionnement non compté. Le programme réduit la défense de
  1 Md€ (O-43) : la mesure garde la dépense au-dessus de la trajectoire de
  la LPM chaque année jusqu'en 2030, de 107 à 169 M€ seulement. Risque :
  120 systèmes dès 2027, quand la tranche ferme de PARADE n'en compte que
  six. -/
def coutRetrofitEuros : Int := 17500
def consentementRetrofitEuros : Int := 3000
def aideRetrofitEuros : Int := coutRetrofitEuros - consentementRetrofitEuros
def retrofitsParAn : Int := 135000
def partImporteeKitPm : Int := 600 * 12350 / 21000
def anneesRetrofit : Nat := 4
def coutDronesParAn : Int := (3000 * 110000 + 25000 * 4000 + 20000 * 1000) / 1000000
def coutSystemeAntiDroneKEuros : Int := 33000 / 6
def systemesAntiDrones : List Int := [120, 80, 30, 20]
def defenseOriginale : List Int :=
  systemesAntiDrones.map (fun n => n * coutSystemeAntiDroneKEuros / 1000 + coutDronesParAn) ++ [coutDronesParAn]

theorem originales_valeurs : aideRetrofitEuros = 14500 ∧ partImporteeKitPm = 352 ∧
    retrofitsParAn * aideRetrofitEuros / 1000000 = 1957 ∧
    coutDronesParAn = 450 ∧ coutSystemeAntiDroneKEuros = 5500 ∧
    defenseOriginale = [1110, 890, 615, 560, 450] := by decide

/-- Recettes originales d'octobre 2026 (O-140, O-141).

* O-140 : captation de la plus-value d'urbanisme. Quand un terrain devient
  constructible par décision publique, la moitié de la plus-value est
  prélevée à la première vente (au moins 20 % en Suisse, art. 5 de la loi
  sur l'aménagement du territoire ; 20 à 40 % selon les cantons,
  EspaceSuisse, janvier 2026 ; 30 à 50 % en Colombie, loi 388 de 1997).
  Marché de l'urbanisation 2024 : 10 400 ha vendus pour 2,39 Md€ (Safer,
  Pleinchamp, 4 juin 2025), soit 229 800 € par ha ; terres et prés libres :
  6 400 € par ha (Safer 2024) ; plus-value de 223 400 € par ha (calcul).
  Espaces consommés : 15 119 ha en 2024 (Cerema, 1er juillet 2026), 12 000
  ha par an retenus sous le ZAN (hypothèse), dont 69 % vendus (10 400 /
  15 119, calcul). Les taxes existantes (articles 1529 et 1605 nonies du
  CGI, ≈ 100 M€ en 2022, exposé des motifs de l'amendement I-637 au PLF
  2025) sont remplacées. Périmètre : première vente de tout terrain devenu
  constructible, y compris avant la réforme (comme l'article 1605 nonies
  pour les terrains devenus constructibles depuis 2010), hypothèse ;
  rétention foncière (ventes retardées) : 20 % de l'assiette (hypothèse) ;
  la moitié du rendement la première année (hypothèse) ; une partie des
  acheteurs sont des personnes publiques (non déduite). Impôt sur une
  rente : imputé aux impôts sur le patrimoine (incidence faible sur
  l'activité).
* O-141 : contribution de 50 % sur la rémunération des réserves
  excédentaires des banques à la Banque de France (taux de la facilité de
  dépôt, toutes les réserves excédentaires depuis la décision ECB/2026/10).
  Dépôts des banques à la Banque de France : 506,6 Md€ en juin 2026, pour
  2 177 Md€ de liquidité excédentaire de la zone euro (moyenne du 17 juin au
  28 juillet 2026, BCE, Bulletin économique 6/2026), soit ≈ 21 % (calcul,
  réserves obligatoires de ≈ 40 Md€ déduites, hypothèse). Liquidité
  excédentaire : 2 177 Md€ mi-2026, moins la baisse des portefeuilles de
  politique monétaire (3 458 Md€ mi-2026 ; 3 088, 2 631, 2 240 et 1 884 Md€
  en fin d'année de 2027 à 2030, enquête de la BCE auprès des analystes
  monétaires, septembre 2026) : 1 807, 1 350, 959 et 603 Md€ (calcul) ;
  taux de la facilité de dépôt : 2,50 %, 2,25 %, 2,10 % et 2,00 % (même
  enquête, moyennes annuelles arrondies, calcul). Érosion de l'assiette de
  20 % (déplacement des réserves, hypothèse). Montants de chaque année
  ramenés en euros 2027 (3 % de croissance nominale par an, convention
  d'O-59), l'échéancier étant indexé sur le PIB nominal.
  Risque juridique élevé : la rémunération des réserves relève de la BCE,
  qui juge défavorablement les taxes bancaires nationales (avis CON/2023/9,
  CON/2023/26). Imputée à l'impôt sur les sociétés ; 2030 reconduit. -/
def surfacesConsommeesHa : Int := 12000
def partVenduePm : Int := 10400 * 1000 / 15119
def plusValueEurosParHa : Int := 2390000000 / 10400 - 6400
def tauxCaptationPm : Int := 500
def taxesExistantesUrbanisme : Int := 100
def retentionFoncierePm : Int := 200
def captationBrute : Int :=
  surfacesConsommeesHa * partVenduePm / 1000 * plusValueEurosParHa / 1000000 * tauxCaptationPm / 1000
    * (1000 - retentionFoncierePm) / 1000
def captationPlusValues : List Int := [captationBrute / 2 - taxesExistantesUrbanisme, captationBrute - taxesExistantesUrbanisme]
def partFranceReservesPm : Int := 210
def liquiditeMi2026MdEuros : Int := 2177
def portefeuilleMi2026MdEuros : Int := 3458
def portefeuillesFinAnnee : List Int := [3088, 2631, 2240, 1884]
def liquiditeExcedentaireMdEuros : List Int :=
  portefeuillesFinAnnee.map fun p => liquiditeMi2026MdEuros - (portefeuilleMi2026MdEuros - p)
def tauxDepotPb : List Int := [250, 225, 210, 200]
def indicesNominauxPdm : List Int := [10000, 10300, 10609, 10927]
def contributionReserves : List Int :=
  ((liquiditeExcedentaireMdEuros.zip tauxDepotPb).zip indicesNominauxPdm).map fun ((l, t), i) =>
    l * partFranceReservesPm / 1000 * t / 10 * 500 / 1000 * 800 / 1000 * 10000 / i

theorem recettes_originales_valeurs : partVenduePm = 687 ∧ plusValueEurosParHa = 223407 ∧
    captationBrute = 736 ∧ captationPlusValues = [268, 636] ∧
    liquiditeExcedentaireMdEuros = [1807, 1350, 959, 603] ∧
    contributionReserves = [3789, 2471, 1591, 922] := by decide

/-- Biokérosène et frein automatique (O-142, O-143).

* O-142 : biokérosène (carburant aviation durable issu d'huiles et de
  graisses, HEFA) porté à 20 % du kérosène des vols intérieurs en 2030,
  contre 6 % imposés par ReFuelEU (règlement (UE) 2023/2405, annexe I),
  soit 3,5 points de plus chaque année de 2027 à 2030 ; le surcoût est payé
  par l'État (le prix du billet n'est pas touché). Aviation domestique :
  4,2 Mt CO₂e en 2024 (Citepa, Secten 2026), liaisons avec les outre-mer
  comprises, soit 1,33 Mt de kérosène à 3,15 t CO₂ par tonne (facteur par
  défaut du GIEC ; calcul). Surcoût du HEFA : 1 285 € par tonne en 2025
  (prix de référence de l'EASA, SAF Investor, 4 mars 2026). Le CO₂ des
  biocarburants est compté à zéro dans l'inventaire (Citepa). Hypothèse : le
  biokérosène acheté pour les vols intérieurs leur est affecté ; la DGAC
  répartit le biokérosène au prorata des ventes de chaque aéroport, et
  l'inventaire n'en compterait alors que ≈ 20 % (variante). Production
  française : 210 à 285 kt par an à Grandpuits (Argus, 20 mars 2025),
  absorbés par les 6 % de ReFuelEU sur tout l'avitaillement en France
  (≈ 0,4 Mt) : les ≈ 190 kt de plus seraient importés (fuite de la dépense
  non modélisée). ReFuelEU impose 20 % en 2035 : l'écart disparaît cette
  année-là (O-142b). Surcoût imputé aux affaires économiques.
* O-143 : frein automatique au déficit, sur le modèle du frein à
  l'endettement suisse (art. 126 de la Constitution fédérale, 2003) et
  allemand (art. 115 de la Loi fondamentale) : toute année où le déficit
  dépasse 5,5 % du PIB, la norme de dépense des fonctions pilotables est
  durcie de 5 points l'année suivante (levier `freinDeficit`). Seuil et
  intensité calés pour ne jouer que dans les scénarios défavorables
  (hypothèse) : au scénario central, le déficit du programme ne dépasse pas
  4,99 % (2027) et le frein ne joue pas. Il joue dans 12 scénarios sur 36
  (pétrole à 100 $ ou croissance basse) : la dépense de 2030 y baisse de
  41 à 43 Md€ (≈ 1,2 à 1,3 point de PIB) et le chômage monte de 0,2 à
  0,4 point ; « chômage non dégradé » y passe de 24 à 20 scénarios sur 36.
  À la différence des freins suisse et allemand, qui portent sur un solde
  corrigé du cycle, corrigent progressivement et ont une clause d'urgence,
  il est pro-cyclique : il durcit la dépense quand la conjoncture est
  mauvaise. -/
def kerosineDomestiqueKt : Int := 4200 * 100 / 315
def pointsBiokerosenePm : Int := 35
def biokeroseneAnnuelKt : Int := kerosineDomestiqueKt * pointsBiokerosenePm / 1000
def surcoutBiokeroseneEurosParT : Int := 1285
def biokeroseneEviteKt : Int := biokeroseneAnnuelKt * 315 / 100
def biokeroseneCout : Int := biokeroseneAnnuelKt * surcoutBiokeroseneEurosParT / 1000
def biokeroseneProrataKt : Int := biokeroseneEviteKt * 200 / 1000
def anneesBiokerosene : Nat := 4
def freinSeuilPb : Int := 550
def freinNormePb : Int := 500

theorem biokerosene_valeurs : kerosineDomestiqueKt = 1333 ∧ biokeroseneAnnuelKt = 46 ∧
    biokeroseneEviteKt = 144 ∧ biokeroseneCout = 59 ∧ biokeroseneProrataKt = 28 := by decide

/-- Énergie (O-144, O-145).

* O-144 : conversion des centrales au fioul d'EDF encore à convertir dans
  les outre-mer (notamment Pointe Jarry en Guadeloupe et Bellefontaine en
  Martinique) au bioliquide de colza en 2027 et 2028, au lieu de 2033 (plan
  « Émeraude » d'EDF : ≈ 2,5 Mt de CO₂ évitées par an après conversion de
  toutes ses îles, AFP, 4 octobre 2023 ; Mayotte, desservie par Électricité
  de Mayotte, n'en fait pas partie). Déjà engagés, donc dans la tendance : Port Est (La Réunion,
  ≈ 280 kt par an), Larivot (Guyane, février 2027), Ricanto (Corse). Reste
  ≈ 1,5 Mt par an (1,4 à 1,6), en deux étapes de 750 kt (hypothèse).
  Surcoût au ratio de Port Est : 74 M€ par an de charges de service public
  pour ≈ 280 kt (CRE, délibération 2022-274, 3 novembre 2022), soit 264 € par
  tonne (calcul). Les émissions des outre-mer de l'Union sont dans
  l'inventaire (Citepa, Secten 2026) ; leur électricité n'est pas dans la
  production de métropole du modèle (sans effet sur la part renouvelable).
  En 2033, date du plan d'EDF, la conversion aurait eu lieu sans la
  mesure : ses effets sortent cette année-là (O-144b). Surcoût imputé aux
  affaires économiques, comme le raccordement des zones non
  interconnectées ; le bioliquide est importé (fuite non modélisée).
* O-145 : fin du soutien public aux cogénérations au gaz à l'échéance des
  contrats : charges « cogénération et autres thermiques » de 600,7 M€ en
  2027 (CRE, délibération 2026-149, annexe 1, 15 juillet 2026), éteintes en
  quatre ans (hypothèse). Hypothèses : à la tendance, les contrats échus
  seraient renouvelés (la dépense de la fonction reconduit ces charges) ;
  la ligne « cogénération et autres thermiques » de la CRE est surtout
  faite de cogénérations au gaz. L'effet sur les émissions, faible et
  incertain (la chaleur serait produite autrement), n'est pas compté. -/
def emissionsZniEviteesKt : Int := 750
def coutTonneZniEuros : Int := 74000000 / 280000
def coutZni : Int := emissionsZniEviteesKt * coutTonneZniEuros / 1000
def soutienCogenerations : Int := 600
def extinctionCogenerations : List Int :=
  ([1, 2, 3, 4] : List Int).map fun k => 0 - k * soutienCogenerations / 4

theorem energie_originale_valeurs : coutTonneZniEuros = 264 ∧ coutZni = 198 ∧
    extinctionCogenerations = [-150, -300, -450, -600] := by decide

/-- Pôles régionaux solaire, stockage hydraulique souterrain et chaleur
(O-146 à O-146d). Un pôle dans chacune des 13 régions de métropole :

* photovoltaïque au sol : 300 MWc par pôle, 3,9 GW en trois ans
  (1,3 GW par an de 2027 à 2029, hypothèse), en plus de la tendance ;
  appels d'offres à 61,33 €/MWh en moyenne (photovoltaïque au sol, octobre
  2026, Les Énergies renouvelables, 12 octobre 2026) ; 1,25 TWh par GW et
  par an (CRE, 2019) ; le solaire capte un prix ≈ 32 % sous le prix en
  base (CRE, note du 19 mars 2026), soit ≈ 45 €/MWh pour une base à
  66 €/MWh (hypothèse) : soutien public de ≈ 16 €/MWh (calcul), 78 M€ par
  an une fois les 3,9 GW en service ; emprise au sol calculée par le
  modèle commun ;
* stockage hydraulique souterrain (station de transfert d'énergie par
  pompage entre un bassin de surface et un silo, un puits ou une ancienne
  mine) : 100 MW et 6 heures par pôle, 1,3 GW et 7,8 GWh en tout ;
  2 500 €/kW (hypothèse centrale ; 1 100 €/kW pour la STEP de surface de
  Montézic 2, 1 900 à 3 000 €/kW pour les projets souterrains de Kidston,
  Lieres et Prosper-Haniel), soit 3,25 Md€ ; sept ans de construction
  (Prosper-Haniel : 7 à 10 ans ; Gombert et al., La Houille Blanche, 2020),
  mise en service en 2034 ; rendement de 75 % (68 à 80 %, Menéndez et al.,
  Journal of Energy Storage, 2020), un cycle par jour pendant 300 jours
  (hypothèse) ; la restitution remplace des centrales au gaz à 0,36 t de
  CO₂ par MWh (cycle combiné, calcul) ; financée par un prêt de l'État à
  un opérateur public (actif commercial, comme les EPR2 de PC-08), sans
  effet sur le déficit ; levier `stockageElectrique`. Aucune STEP dans une
  mine fermée ne produit encore dans le monde (Prosper-Haniel abandonné en
  2018, Pyhäsalmi sans décision d'investissement en 2026) : risque élevé.
  Une batterie de même capacité coûterait 65 à 150 M€ par pôle et serait
  prête en un à deux ans ;
* chaleur : fosse d'eau enterrée de 200 000 m³ et 70 000 m² de capteurs
  solaires (modèle de Vojens, Danemark, 2015 : 28 GWh par an, part
  solaire de 45 à 50 %) et un doublet de géothermie (≈ 25 GWh par an, 10 à
  13 M€, BRGM) par pôle, sur un réseau de chaleur : 53 GWh par pôle, 0,69
  TWh en tout, à 0,22 t de CO₂ évitée par MWh (Fonds chaleur 2025 : 777 kt
  pour 3,5 TWh, calcul) ; ≈ 42 M€ par pôle (fosse à 24 à 48 €/m³ et
  capteurs : 20 à 40 M€ ; doublet : 11,5 M€), aidés à 65 % par le Fonds
  chaleur (plafond ADEME), sur 2027-2028 ; en service en 2029 ; les réseaux
  de chaleur relèvent du secteur de l'énergie dans l'inventaire.

Les « bassines » ne sont pas comptées comme réserve d'eau : l'eau d'une
STEP circule et celle d'un stockage de chaleur monte à 90 °C ; une citerne
enterrée coûte ≈ 1 800 €/m³ (bassin d'Austerlitz) contre ≈ 12 €/m³ pour
une réserve à ciel ouvert (Deux-Sèvres). -/
def polesRegionaux : Int := 13
def solaireParPoleMw : Int := 300
def solaireParAnMw : Int := polesRegionaux * solaireParPoleMw / 3
def soutienSolaireEurosMWh : Int := (6133 - 66 * (100 - 32)) / 100
def productionSolaireGwhParGw : Int := 1250
def soutienSolaire : List Int :=
  ([0, 50, 150, 250, 300] : List Int).map fun pm =>
    polesRegionaux * solaireParPoleMw * pm / 300 * productionSolaireGwhParGw / 1000 * soutienSolaireEurosMWh / 1000
def stepParPoleMw : Int := 100
def stepHeures : Int := 6
def stepEurosParKw : Int := 2500
def stepInvestissement : Int := polesRegionaux * stepParPoleMw * stepEurosParKw / 1000
def anneesConstructionStep : Nat := 7
def stepPretParAn : Int := stepInvestissement / anneesConstructionStep
def chaleurParPoleGwh : Int := 28 + 25
def chaleurEviteeKt : Int := polesRegionaux * chaleurParPoleGwh * 220 / 1000
def chaleurInvestissementPole : Int := 42
def chaleurAide : Int := polesRegionaux * chaleurInvestissementPole * 650 / 1000
/-- Part de l'investissement de chaleur non couverte par l'aide (35 %),
payée par les exploitants des réseaux (calcul). -/
def chaleurPrive : Int := polesRegionaux * chaleurInvestissementPole - chaleurAide

theorem poles_valeurs : solaireParAnMw = 1300 ∧ soutienSolaireEurosMWh = 16 ∧
    soutienSolaire = [0, 12, 38, 64, 78] ∧ stepInvestissement = 3250 ∧ stepPretParAn = 464 ∧
    chaleurEviteeKt = 151 ∧ chaleurAide = 354 ∧ chaleurPrive = 192 := by decide

/-- Métro entièrement accessible aux personnes handicapées en 2035 (O-147).

* Paris : 320 stations (question écrite n° 18558, JO du 29 septembre 2026 ;
  319 pour la Ville de Paris, rapport 2025 sur les transports), dont ≈ 30
  accessibles en autonomie aux usagers en fauteuil roulant (29 en 2025 :
  21 sur la ligne 14 et 8 sur la ligne 11, Île-de-France Mobilités ; 33 à
  l'été 2024 avec les prolongements des lignes 4, 11 et 14) : 290 stations à
  traiter. Coût : 20 Md€ (Région Île-de-France, assises « Métro pour tous »
  du 10 octobre 2024 : « 20 Md€ sur environ 20 ans » ; 15 à 20 Md€ dans le
  dossier de presse d'IDFM du 5 septembre 2024 ; « plus de 20 Md€ » en août
  2026, Handicap.fr), soit ≈ 69 M€ par station ; ligne 6, seule chiffrée :
  660 à 850 M€ pour 28 stations. Le chiffre n'est pas actualisé ni majoré
  pour la cadence (minorant).
* Hors Paris : Marseille, 29 stations dont 9 accessibles fin 2025 et 2
  prévues en 2026 (bilan 2025 de la commission accessibilité de la
  Métropole Aix-Marseille-Provence) : 18 stations, à 53 M€ HT les 7
  stations du programme de 2019 (délibération de 2019, euros 2019 :
  minorant). Lyon : toutes accessibles sauf Croix-Paquet, jugée impossible
  à aménager (TCL) ; Lille, Toulouse et Rennes : accessibles dès leur
  conception.
* Calendrier : études ligne par ligne des 13 lignes historiques en 2027
  (≈ 1 M€ par ligne : l'étude de faisabilité de la ligne 6 coûte ≈ 1 M€,
  Région Île-de-France, mars 2025), puis travaux de 2028 à 2035
  au même rythme chaque année (hypothèse) : ≈ 38 stations par an.
  **Faisabilité très faible** : aucun réseau ne dépasse durablement dix
  stations par an (Londres : 10 en 2021 ; New York : 9 à 10 par an imposés
  par l'accord judiciaire de 2022) ; Paris en rend 2 à 4 par an (APF France
  handicap) ; la RATP juge certaines stations impossibles à équiper
  d'ascenseurs et la règle incendie GN8 impose l'évacuation des fauteuils
  par ascenseur. Variante réaliste : études en 2027-2028, puis la ligne 6
  (755 M€, milieu de la fourchette) et 50 stations de correspondance
  prioritaires à 69 M€ (20 Md€ pour 290 stations, calcul) de
  2029 à 2035, et Marseille de 2027 à 2030 : ≈ 108 stations parisiennes
  accessibles en 2035 sur 320 (34 %), le reste vers 2045-2050 comme le
  prévoit IDFM.

Investissement public (IDFM, Région, État, Ville : la clé « un tiers, un
tiers, un tiers » proposée par la Région n'a pas été acceptée par l'État),
imputé aux affaires économiques (transports). Non comptés : entretien des
ascenseurs supplémentaires, effet sur l'emploi des personnes handicapées
(41 % en emploi contre 69 % pour l'ensemble, Insee 2025, Agefiph ; aucune
étude ne relie leur emploi à l'accessibilité du métro). -/
def stationsMetroParis : Int := 320
def stationsAccessiblesParis : Int := 30
def stationsATraiterParis : Int := stationsMetroParis - stationsAccessiblesParis
def coutAccessibiliteParis : Int := 20000
def stationsATraiterMarseille : Int := 29 - 9 - 2
def coutStationMarseilleKeur : Int := 53000 / 7
def coutAccessibiliteMarseille : Int := stationsATraiterMarseille * coutStationMarseilleKeur / 1000
def lignesHistoriques : Int := 13
def etudesAccessibilite : Int := lignesHistoriques * 1
def anneesTravauxAccessibilite : Nat := 8
def travauxAccessibiliteParAn : Int :=
  (coutAccessibiliteParis + coutAccessibiliteMarseille) / anneesTravauxAccessibilite
def stationsAccessiblesParAn : Int :=
  (stationsATraiterParis + stationsATraiterMarseille) / anneesTravauxAccessibilite
def metroAccessible : List Int :=
  etudesAccessibilite :: List.replicate anneesTravauxAccessibilite travauxAccessibiliteParAn ++ [0]
/-- Variante réaliste : ligne 6 (660 à 850 M€) et 50 stations de
correspondance à 69 M€ sur sept ans, Marseille sur quatre ans. -/
def ligne6Accessible : Int := (660 + 850) / 2
def stationsCorrespondance : Int := 50
def coutStationMoyen : Int := (20000 * 10 / stationsATraiterParis + 5) / 10
def travauxRealistesParAn : Int := (ligne6Accessible + stationsCorrespondance * coutStationMoyen) / 7
def marseilleParAn : Int := coutAccessibiliteMarseille / 4
def metroAccessibleRealiste : List Int :=
  [etudesAccessibilite / 2 + marseilleParAn, etudesAccessibilite / 2 + marseilleParAn,
   travauxRealistesParAn + marseilleParAn, travauxRealistesParAn + marseilleParAn,
   travauxRealistesParAn, travauxRealistesParAn, travauxRealistesParAn, travauxRealistesParAn,
   travauxRealistesParAn, 0]

theorem metro_valeurs : stationsATraiterParis = 290 ∧ coutAccessibiliteMarseille = 136 ∧
    travauxAccessibiliteParAn = 2517 ∧ stationsAccessiblesParAn = 38 ∧
    metroAccessible = [13, 2517, 2517, 2517, 2517, 2517, 2517, 2517, 2517, 0] ∧
    travauxRealistesParAn = 600 ∧
    metroAccessibleRealiste = [40, 40, 634, 634, 600, 600, 600, 600, 600, 0] := by decide

/-- Électricité renouvelable à 40 % en 2030 (O-148), mesure originale
(octobre 2026) : retenir les projets déjà candidats aux appels d'offres
au lieu d'en écarter les neuf dixièmes, renouveler les vieux parcs éoliens
et économiser l'électricité.

* Solaire au sol : 4 500 MW par an de plus que la tendance de 2027 à 2030.
  L'appel d'offres d'octobre 2026 a reçu 8,34 GW de candidatures pour
  0,925 GW retenus, à 61,33 €/MWh en moyenne (Les Énergies renouvelables,
  12 octobre 2026) ; soutien de 16 €/MWh comme pour O-146
  (`soutienSolaireEurosMWh`).
* Toitures, ombrières de parkings et serres : 3 750 MW par an. La 12e
  période de l'appel d'offres « bâtiments » a reçu 1 559 MWc pour 300
  appelés, à 82,98 €/MWh en moyenne (CRE, délibération 2026-120 du 11 juin
  2026) ; l'obligation d'ombrières de la loi APER sur les grands parkings
  est appliquée sans report. Soutien : 82,98 €/MWh moins le prix capté par
  le solaire (≈ 45 €/MWh, comme pour O-146), soit 38 €/MWh (calcul).
  Production : 1,25 TWh par GW et par an (CRE, 2019 ; majorant du coût pour
  les toitures).
* Éolien terrestre : 400 MW par an renouvelés ou ajoutés au-delà de la
  programmation (1,6 GW en quatre ans ; 883 MW raccordés en 2025), ≈ 0,1 Md€
  par an de soutien (estimation).
* Sobriété électrique : −1,5 TWh par an de 2027 à 2030, soit −6 TWh en 2030
  (éclairage public à LED et extinction nocturne, ≈ −2 TWh ; pompes à
  chaleur air-air à la place des convecteurs dans un million de logements,
  ≈ −4 TWh), 0,45 Md€ par an d'investissement (estimation). Dans le modèle,
  chaque TWh consommé en moins réduit d'autant le nucléaire modulé.

Le rythme total (≈ 14 GW de solaire par an avec la tendance, soit 33 GW de plus en 2030) est plus du
double du record de 2025 (5,9 GW) : risque élevé, d'abord sur le
raccordement (≈ 10 % du territoire saturé, délais de plus de cinq ans,
Connaissance des énergies, juillet 2026). Le solaire en plus remplace du
nucléaire dans le modèle, pas du gaz : pas d'effet sur les émissions.

Mesure retirée en novembre 2026 avec la priorité au nucléaire (O-181) :
sans modulation, ce solaire aurait été écrêté aux quatre cinquièmes et la
part de 40 % n'est plus atteignable ; les constantes restent (O-163c
renvoie à l'estimation de la sobriété). -/
def solaireSolParAnMw : Int := 4500
def solaireToitParAnMw : Int := 3750
def soutienToitEurosMWh : Int := (8298 - 66 * (100 - 32)) / 100
def eolienRenouveleParAnMw : Int := 400
def soutienEolien : Int := 100
def sobrieteParAnGwh : Int := 1500
def investissementSobriete : Int := 450
/-- Soutien public, M€ : capacité moyenne de l'année (la moitié de l'ajout
de l'année), production, soutien. -/
def soutienRenouvelables : List Int :=
  ([1, 3, 5, 7, 8] : List Int).map fun demiAnnees =>
    (solaireSolParAnMw * soutienSolaireEurosMWh + solaireToitParAnMw * soutienToitEurosMWh)
      * demiAnnees / 2 * productionSolaireGwhParGw / 1000000 + soutienEolien

theorem renouvelables_valeurs : soutienToitEurosMWh = 38 ∧
    soutienRenouvelables = [234, 502, 770, 1038, 1172] := by decide

/-- Vente de la moitié de l'or de la Banque de France (O-149), mesure
originale (octobre 2026). Stock : 2 436,8 t, soit 78,35 millions d'onces
(Banque de France, gestion de l'or) ; cours ≈ 4 000 $ l'once (4 038 $ le
26 octobre 2026) pour 1,12 $ par euro (hypothèse) : ≈ 280 Md€. La moitié
(≈ 1 218 t) vendue de 2027 à 2032 : ≈ 140 Md€, dont la plus-value réalisée
(coût d'entrée dans l'Eurosystème : 246,37 € l'once au 1er janvier 1999)
est versée à l'État par une distribution exceptionnelle, ≈ 21,7 Md€ par an.
Deux tiers jusqu'en octobre 2026, puis tout l'or avec O-164 ; l'auteur
divise la vente par deux (« diminue de moitié la vente d'or »).
Comptabilité nationale : le versement à l'État du produit de la vente
d'actifs de réserve est une opération financière, sans effet sur le
déficit (décisions d'Eurostat du 3 février 1997) : la dette baisse, et les
intérêts avec elle. Précédents : Suisse, 1 300 t vendues de 2000 à 2005,
produit versé aux cantons et à l'AVS ; France, ≈ 587 t de 2004 à 2009, produit
resté au bilan de la Banque de France ; l'accord des banques centrales sur
l'or n'est plus en vigueur depuis 2019. **Risque juridique élevé** : la BCE
doit être consultée sur la loi (articles 123, 127 et 130 du traité,
article 31 des statuts du SEBC) et s'est opposée en 2009 et en 2025 à des
projets italiens sur l'or ; on perd la hausse future du cours. -/
def onceOrMillions : Int := 7835
def coursOrDollars : Int := 4000
def dollarsParEuroCentiemes : Int := 112
def coutEntreeOrCentiemes : Int := 24637
def anneesVenteOr : Nat := 6
def valeurOr : Int := onceOrMillions * coursOrDollars * 100 / dollarsParEuroCentiemes / 100
def plusValueOrParAn : Int :=
  valeurOr / 2 * (coursOrDollars * 100 * 100 / dollarsParEuroCentiemes - coutEntreeOrCentiemes)
    / (coursOrDollars * 100 * 100 / dollarsParEuroCentiemes) / anneesVenteOr

theorem or_valeurs : valeurOr = 279821 ∧ plusValueOrParAn = 21709 := by decide

/-- Consolidation des réserves de trois fonds publics en titres de l'État
(O-150), mesure originale (octobre 2026). Fonds de réserve pour les
retraites : 20,8 Md€ fin 2025 (Sénat, comptes de la sécurité sociale) ;
Retraite additionnelle de la fonction publique (RAFP) : plus de 57 Md€
(ERAFP, 2026) ; Ircantec : 18,6 Md€ fin 2025. Les trois appartiennent aux
administrations publiques : les OAT qu'ils détiennent sont retirées de la
dette de Maastricht (consolidation, règlement (CE) 479/2009). Un quart est
supposé déjà placé en titres publics français (hypothèse) : ≈ 72 Md€
convertis en 2027-2028. Contrepartie : les dividendes et coupons des
autres placements (≈ 2,5 % par an, hypothèse) sont perdus, recettes des
administrations publiques en moins ; moins de diversification, et un même
choc de taux frappe l'État et les fonds. -/
def reservesFonds : Int := 20800 + 57000 + 18600
def reservesConverties : Int := reservesFonds * 3 / 4
def rendementPerduPm : Int := 25
def revenusPerdus : Int := reservesConverties * rendementPerduPm / 1000

theorem fonds_valeurs : reservesConverties = 72300 ∧ revenusPerdus = 1807 := by decide

/-- Contribution nationale sur la valeur du sol (O-151), mesure originale
(octobre 2026), sur le modèle de l'impôt foncier danois (« grundskyld » :
23,2 Md DKK en 2024, ≈ 0,8 % du PIB, Danmarks Statistik) et des théories de
Henry George : impôt sur la seule valeur des terrains, pas sur les
constructions. Depuis novembre 2026, le taux est
**progressif selon la surface de la parcelle** par logement ou local (en
collectif, parcelle répartie au prorata des surfaces habitables, méthode du
SDES), et les terrains **agricoles et industriels sont exclus** : les
terres agricoles ne sont pas des terrains bâtis (comptes de patrimoine) ;
les terrains industriels et logistiques, ≈ 200 Md€ (100 à 300 : ≈ 60 % des
450 000 ha de zones d'activité à 40 à 80 €/m², calcul, Cerema 2022), sont
retirés de l'assiette. Assiette : terrains bâtis hors administrations
publiques, 5 826 Md€ fin 2024 (ménages 4 043, sociétés non financières
1 596, sociétés financières 186 ; Insee Première n° 2081), moins
l'industriel : ≈ 5 600 Md€, répartis en trois classes de surface par
logement ou local (calcul, hypothèses sur les répartitions ; médiane de
732 m² pour les maisons et 68 m² pour les appartements, SDES, empreinte
foncière 2022 ; maisons : 35 % sous 500 m², 51 % de 500 à 2 000, 14 %
au-delà, enquête Logement 2013 ; la valeur d'un terrain est à peu près la
même quelle que soit sa taille, le prix du m² décroissant avec la surface,
EPTB) : ≈ 3 450 Md€ sous 500 m², ≈ 1 600 Md€ de 500 à 2 000 m², ≈ 580 Md€
au-delà de 2 000 m² (fourchettes 3 100-3 700, 1 350-1 900, 400-800).
Barème (hypothèse, modèle taïwanais pour le critère de surface) : 0,25 %,
0,5 % et 1 % de la valeur de la parcelle selon sa classe ; abattement de
50 000 € de terrain sur la résidence principale de ≈ 17,7 millions de
propriétaires occupants (30,6 millions de résidences principales, 58 %,
Insee), imputé pour 70 % à la première classe et 30 % à la deuxième
(hypothèse). Loi en 2027, évaluation de masse en 2028 à partir des ventes
(DVF), demi-taux en 2029, plein taux en 2030 ; report de paiement possible
jusqu'à la succession pour les retraités modestes. Le moins distorsif des
impôts : il ne frappe ni le travail ni la construction, et pénalise la
rétention foncière (comme O-140) ; la progressivité par surface épargne les
appartements et frappe surtout le rural peu dense, où le mètre carré vaut
peu : l'essentiel du produit vient des petites parcelles. Version
précédente : taux unique de 0,5 % (24,7 Md€), porté à 1,15 % puis 0,575 %
par O-169, retirée. Acceptabilité faible ; s'ajoute à la taxe foncière. -/
def valeurSolHorsApu : Int := 5826000
def valeurSolIndustriel : Int := 200000
def valeurSolClasses : List Int := [3450000, 1600000, 580000]
def tauxSolClassesPcm : List Int := [250, 500, 1000]
def proprietairesOccupantsMilliers : Int := 30600 * 58 / 100
def abattementSolEuros : Int := 50000
def abattementSol : Int := proprietairesOccupantsMilliers * abattementSolEuros / 1000
def abattementSolClassesPm : List Int := [700, 300, 0]
def contributionSol : Int :=
  (List.range 3).foldl (fun acc k =>
    acc + (valeurSolClasses.getD k 0 - abattementSol * abattementSolClassesPm.getD k 0 / 1000)
      * tauxSolClassesPcm.getD k 0 / 100000) 0
/-- Taux moyen apparent, pour dix mille (information : ≈ 0,34 %). -/
def tauxSolPdm : Int := contributionSol * 10000 / (valeurSolHorsApu - valeurSolIndustriel)

theorem sol_valeurs : valeurSolClasses.foldl (· + ·) 0 = valeurSolHorsApu - valeurSolIndustriel + 4000 ∧
    abattementSol = 887400 ∧ contributionSol = 19540 ∧ tauxSolPdm = 34 := by decide

/-- Capitalisation de la contribution sur le sol (O-151) : l'offre de sol est
inélastique, il n'y a pas de fuite comportementale (Høj, Jørgensen, Schou,
Fiscal Studies 39, 2018, Danemark ; Schwerhoff, Edenhofer, Fleurbaey, FMI
WP/22/263), mais l'impôt se capitalise dans le prix des terrains : la valeur
d'un terrain passe de a / r à a / (r + τ). L'évaluation de masse partant des
ventes (DVF), l'assiette baisse d'autant et la recette n'est plus que
r / (r + τ) de la recette statique, avec r = 2,3 % (taux d'actualisation
implicite mesuré au Danemark, Høj et al.) et τ le taux moyen : 12,9 % de
recette en moins au barème actuel (calcul). -/
def tauxActualisationSolPdm : Int := 230
def solNet (brut : Int) : Int :=
  let tau := brut * 10000 / (valeurSolHorsApu - valeurSolIndustriel)
  brut * tauxActualisationSolPdm / (tauxActualisationSolPdm + tau)
def contributionSolNette : Int := solNet contributionSol

theorem sol_net : contributionSolNette = 17023 ∧ solNet 24693 = 20803 := by decide

/-- Fin de l'effacement des plus-values latentes au décès (O-152), mesure
originale en France (octobre 2026) : à la transmission, les plus-values
latentes des titres et des biens sont imposées comme si elles étaient
réalisées (modèle canadien de la « disposition réputée » au décès), avec
un abattement. ≈ 2 Md€ par an en régime de croisière (Terra Nova, « Mettons
fin à l'effacement des plus-values au moment de la transmission »,
février 2022). -/
def plusValuesDeces : Int := 2000

/-- Trésorerie de l'État réduite de 25 Md€ en 2027 (O-153) : l'écart
entre dette brute et dette nette atteint 215 Md€ fin 2025 (Insee), dont
une trésorerie de précaution élevée depuis 2020 ; la dette brute (celle de
Maastricht) baisse d'autant, la dette nette ne change pas. Risque : moins
de marge de liquidité en cas de tension sur les marchés. -/
def reductionTresorerie : Int := 25000

/-- Vote obligatoire, vote blanc reconnu et tirage au sort (O-154).

* Vote obligatoire à toutes les élections, sanctionné par une contravention
  de première classe (38 € au plus, article 131-13 du code pénal ;
  Belgique : 50 € au plus, 125 € en récidive ; Australie : 20 dollars
  australiens, étude de législation comparée du Sénat n° 301, 2022) ;
  27 pays sur 203 pratiquent le vote obligatoire (IDEA).
* Vote blanc compté parmi les suffrages exprimés (la loi du 21 février 2014
  le décompte à part sans l'y inclure). Au second tour de la présidentielle
  de 2022 : 2 228 044 blancs, 6,35 % des votants (ministère de l'Intérieur).
* Si les blancs dépassent 50 % des suffrages exprimés, le siège ou le poste
  est attribué par tirage au sort parmi les électeurs de la circonscription
  volontaires (hypothèse de mise en œuvre) ; cela n'est jamais arrivé à une
  élection nationale.

Révision de la Constitution (articles 3, 6 et 24 : élection du Président et
des parlementaires au suffrage universel), par le référendum d'O-87 par
exemple. Sans effet budgétaire mesurable dans le modèle : à 90 % de
participation (hypothèse) et 11 € d'amende forfaitaire, les amendes
rapporteraient au plus ≈ 50 M€ par scrutin (calcul), moins de 0,01 point
de PIB ; une élection nationale coûte ≈ 170 M€ (législatives de 2024 :
171,49 M€, ministère de l'Intérieur), sans changement par le vote
obligatoire. -/
def voteObligatoirePourMemoire : Unit := ()

/-- Paquet climat sans signal-prix sur le carburant (O-155 à O-163). Cibles 2030 (scénario médian, moteur de demande) :
transports ≤ 92 Mt (104,4), bâtiments ≤ 37 (46,9), production d'énergie
≤ 25 (26,8), total ≤ 276 (295,5), répartition de l'effort (hors marché
carbone) ≤ 210,5 (245,8), budget carbone 2029-2033 ≤ 262 Mt par an
(289,9). C'est la répartition de l'effort qui décide : ≈ −35 Mt dans les
transports, les bâtiments, l'agriculture et les déchets. Les effets sont
ceux de 2030, atteints par quarts de 2027 à 2030. Depuis octobre 2026, le
levier `transitionEcologique` du modèle commun compte, pour chaque tonne
évitée, l'énergie fossile qui n'est plus achetée (importations évitées,
accises et TVA perdues, sauf quand un biocarburant prend la place à prix et
taxes inchangés), l'électricité consommée en plus (accise et TVA gagnées)
et l'activité perdue (raffinerie, élevage), avec sa part reprise par des
importations ; les dépenses sont des investissements par technologie
(`investissementTransition`, part importée propre à chaque technologie),
et l'investissement privé déclenché est compté (`investissementPriveTransition`). Recherche
documentaire d'octobre 2026, sources citées mesure par mesure.

**Faisabilité d'ensemble très faible d'ici 2030** : le paquet suppose des
pompes à chaleur à 3 ou 4 fois le marché record, le rachat de 20 % du
cheptel bovin en quatre ans, ≈ 2,5 Mt de biocarburants dans un marché
européen déjà en pénurie et la fermeture d'une raffinerie. -/
def anneesMonteeClimat : Nat := 4

/-- Sobriété routière (O-155), effets 2030 en kt : 110 km/h sur autoroute
et 100 km/h sur voies rapides (−2 100 : Espagne 2011, −2 à −3 % de
carburant ; A62 à 110 km/h, −9 % ; Umweltbundesamt 2023) ; poids lourds à
80 km/h sur autoroute (−600, estimation) ; télétravail de deux jours sur
les postes télétravaillables et covoiturage (−1 000 ; ADEME : −69 % de
trajets les jours télétravaillés, rebond de 31 %) ; semaine de quatre jours
compressée dans la fonction publique (−160 dans les transports, −130 dans
les bâtiments ; domicile-travail : 17,4 Mt, Insee Première n° 1975). -/
def sobrieteRoutiereKt : Int := 2100 + 600 + 1000 + 160
def sobrieteRoutiereBatimentsKt : Int := 130
def sobrieteRoutiereAccises : Int := (2100 + 1000 + 160) * 400 / 1000 + 600 * 250 / 1000

/-- Flottes 100 % électriques (O-156), effets 2030 en kt : voitures de
société à la belge, fin de la déductibilité des thermiques et quotas de
95 % d'électriques en 2030 (−2 000 ; Belgique : 40 % d'électriques chez
les voitures de société, ICCT 2025) ; VUL d'entreprise électriques
(−2 040 ; 400 000 VUL neufs par an, 7 % électriques en 2024, T&E) ;
loueurs, taxis et VTC (−740 ; ANFA 2025) ; livraisons urbaines zéro
émission dans 40 agglomérations (−500 ; Pays-Bas, 30 villes) ; camions
électriques, bonus et exonération de la contribution kilométrique (−1 300 ;
Allemagne : exonération jusqu'en 2031). Électricité : +9,5 TWh en 2030.
Aides : 2,1 Md€ par an de 2027 à 2030. -/
def flottesKt : Int := 2000 + 2040 + 740 + 500 + 1300
def flottesGwh : Int := 9500
def flottesAides : Int := 2100
def flottesAccises : Int := 500 + 500 + 220 + 130 + 330

/-- Biocarburants payés par l'État, prix à la pompe inchangé (O-157), en
kt : HVO porté de 5 points dans le gazole routier (−3 000 ; gazole R33,
norme EN 590, Neste 2018 ; ≈ 0,75 Md€ par an à 0,6 € de surcoût par
litre) ; B100 et HVO pour les poids lourds (−1 500 ; 0,25 Md€) ; bus et cars
au B100, au HVO ou au bioGNV (−1 000 ; 0,05 Md€) ; 600 000 conversions à
l'E85 (−500 ; 0,3 Md€). Biomasse limitée : l'inventaire compte −100 %,
le cycle de vie ≈ −60 %. -/
def biocarburantsKt : Int := 3000 + 1500 + 1000 + 500
def biocarburantsCout : Int := 750 + 250 + 50 + 300

/-- Plan « Liberty ships » du chauffage (O-158), en kt 2030 : pompes à
chaleur air-eau et hybrides gratuites, 150 000 en 2027, 350 000 en 2028,
550 000 en 2029 puis 700 000 par an jusqu'en 2033 (179 377 PAC air-eau
vendues en 2025, record de 346 313 en 2022 ; Royaume-Uni : 13,5 millions
de foyers convertis au gaz en dix ans), 80 % d'effet additionnel
(−3 780 ; 8 500 € par PAC) ; un million de PAC air-air en relève de
chaudières (−1 150) ; biofioul F30 obligatoire (−1 630) ; thermostats
connectés réglés à 19 °C (−450). Électricité : +7 TWh en 2030, puis
+1,2 TWh par an avec les PAC de 2031 à 2033.

Fusion des doublons (novembre 2026) : les 100 000 pompes à chaleur
rurales gratuites d'O-90 font partie des 700 000 du plan ; elles sont
comptées une fois, par O-90 (sous-modèle rénovation : fioul et gaz
économisés, coûts de réseau évités). Le plan n'en compte donc que
600 000 par an en régime (50 000, 250 000, 450 000 puis 600 000) : la
part « pompes à chaleur » des émissions, l'électricité et
l'investissement sont réduits de 100 000 PAC par an (six septièmes en
régime, 850 M€ par an d'investissement en moins). -/
def chauffagePacKt : Int := 3780 * 6 / 7
def chauffageKt : Int := chauffagePacKt + 1150 + 1630 + 450
def chauffageGwh : Int := 7000 * 6 / 7
def chauffageSuiteKt : Int := 600 * 6 / 7
def chauffageSuiteGwh : Int := 1200 * 6 / 7
def chauffageInvestissement : List Int := [4100 - 850, 6500 - 850, 6700 - 850, 6400 - 850, 6400 - 850, 6400 - 850, 6400 - 850, 0]

/-- Tertiaire (O-159), en kt : 19 °C contrôlé, régulation des grands
systèmes de chauffage et sanctions du décret tertiaire (−1 300) ; quotas
d'émissions des grands bâtiments tertiaires sur le modèle de Tokyo (−500 ;
≈ 1 300 bâtiments, −20 %) ; chauffage collectif (−600) ; fuites de fluides
frigorigènes et consigne à la destruction (−1 200 ; Norvège depuis 2004).
0,6 Md€ par an. -/
def tertiaireKt : Int := 1300 + 500 + 600 + 1200

/-- Part des administrations publiques dans le gaz et le fioul du tertiaire
(O-159) : hôpitaux, écoles, collèges, lycées, universités et autres
bâtiments administratifs, ≈ 42 % (`Hypotheses.Energie.chauffagePublic`,
sources et calculs). Leurs économies de gaz réduisent la dépense publique
au lieu d'être dépensées ailleurs. -/
def partPubliqueTertiairePm : Int := Hypotheses.Energie.chauffagePublic.partPubliquePm
def tertiaireCout : Int := 600

/-- Production d'énergie (O-160), en kt : Fonds chaleur doublé (−780 dans
l'énergie, −540 dans l'industrie, −230 dans les bâtiments ; 51,5 € d'aide
par tonne en 2025, ADEME) et chaudières électriques dans les réseaux de
chaleur (−300) ; fermeture et reconversion de la raffinerie de Donges en
2029 (−1 150 ; 11 Mt de brut par an, ≈ 650 salariés ; les émissions
partent avec les importations de gazole). -/
def energieKt : Int := 780 + 300 + 1150
def energieIndustrieKt : Int := 540
def energieBatimentsKt : Int := 230
def energieGwh : Int := 1300
def energieInvestissement : List Int := [800, 800, 1300, 1300, 800]

/-- Agriculture (O-161), en kt : rachat volontaire de 20 % du cheptel
bovin de 2028 à 2031 (−3 750 ; Pays-Bas : 723 élevages rachetés pour
1,81 Md€ ; Cour des comptes, 2023) ; additif 3-NOP pour 900 000 vaches de
plus (−620, avis de l'EFSA attendu) ; deux repas végétariens sur cinq en
restauration collective (−200) ; plafond d'azote minéral 15 % sous
l'optimum, à la danoise (−1 200) ; fosses à lisier couvertes dans 15 000
élevages (−1 230). ≈ 2,45 Md€ par an de 2028 à 2031. -/
def agricultureKt : Int := 3750 + 620 + 200 + 1200 + 1230
def agricultureCout : List Int := [750, 2450, 2450, 2450, 2450, 750]

/-- Déchets (O-162) : captage du biogaz des décharges porté à 70 % (au
lieu des 55 % d'O-135), −2 500 kt (189 kt par point de captage, paramètre
d'O-135), 0,15 Md€ par an. -/
def dechetsKt : Int := 2500
def dechetsCout : Int := 150

/-- Électricité renouvelable avec l'électrification (O-163) : les flottes,
les pompes à chaleur et les réseaux de chaleur ajoutent ≈ 18 TWh de
consommation en 2030, qui feraient retomber la part renouvelable sous
40 % ; 1,5 GW de solaire de plus par an de 2027 à 2030 (moitié au sol,
moitié sur toitures) et 4 TWh de sobriété de plus (un million de logements
de plus passés des convecteurs aux PAC air-air). -/
def solaireSupplementMw : Int := 750
def sobrieteSupplementGwh : Int := 1000
/-- Soutien du supplément solaire, M€ : même calcul que `soutienRenouvelables`
(16 €/MWh au sol, 38 €/MWh sur toitures). -/
def soutienSolaireSupplement : List Int :=
  ([1, 3, 5, 7, 8] : List Int).map fun demiAnnees =>
    (solaireSupplementMw * soutienSolaireEurosMWh + solaireSupplementMw * soutienToitEurosMWh)
      * demiAnnees / 2 * productionSolaireGwhParGw / 1000000

/-- Finances pour l'équilibre en 2035, la règle européenne de −1 point de
dette par an et le financement du paquet climat (O-164 à O-171). Au rang qui décide (neuvième meilleur des
dix-huit scénarios économiques), il manquait ≈ 0,5 point de déficit en
2030, ≈ 0,8 point en 2035 et ≈ 6,5 points de dette, plus ≈ 15 Md€ par an
pour le climat. Trois familles : opérations sur la dette sans effet sur
l'activité (O-164), recettes à faible effet sur la demande (O-167, O-168,
O-170, O-171), contribution sur le sol relevée (O-169, retirée en novembre
2026 au profit du barème progressif d'O-151). Essai : la
consolidation des réserves de l'Agirc-Arrco, du RCI et du Fonds de garantie
des dépôts, un dividende exceptionnel du fonds d'épargne de la Caisse des
dépôts et le droit d'entrée des concessions hydroélectriques permettraient
de garder le dernier tiers de l'or ; écartés pour leur risque juridique
(régime paritaire) et parce que la dette hydroélectrique passe à EDF. Recherche
documentaire d'octobre 2026.

Or : O-164 vendait aussi le dernier tiers de l'or (avec O-149, tout l'or de
la Banque de France) ; retiré : O-149 vend la moitié de l'or.

Réserves de change de l'État hors or : 28,4 Md€ ; la moitié vendue en
2027 (O-164), opération financière ; capacité d'intervention réduite. -/
def devisesVendues : Int := 28400 / 2

/-- Réserve de réévaluation des réserves de change et en or de l'État
(RRRODE) de la Banque de France : 11,4 Md€ après la plus-value de 11 Md€
réalisée en 2025 sur l'or « mis aux normes » (résultats 2025, 25 mars
2026), versée à l'État en 2027 (O-164) ; elle couvrait les pertes futures
de la Banque de France. -/
def rrrode : Int := 11400

/-- Deuxième baisse de la trésorerie de l'État (O-164) : 15 Md€ en 2027
(écart de 95,4 Md€ entre dette des administrations et dette de l'État,
Insee, fin 2025). -/
def tresorerieSupplementaire : Int := 15000

/-- Recettes à faible effet sur la demande (O-167, O-168), M€ :
fin des avantages du démembrement de propriété (réunion de l'usufruit
taxée au décès, barème de l'article 669 revu : 2 à 3 Md€ de coût actuel,
Conseil d'analyse économique, note 69, 2021), montée de 0,3 à 2,3 Md€ ;
plus-values immobilières indexées sur l'inflation au lieu de l'abattement
pour durée de détention (surcoût actuel ≈ 3 Md€, Cour des comptes, novembre
2025) et exonération de la résidence principale plafonnée à l'américaine
(250 000 $ par personne), de 1 à 3 Md€ ; fin du reste du Pacte Dutreil
(37,5 % → 0, après O-41), 2 Md€ ; taxe sur les transactions financières
étendue aux achats-reventes dans la journée et aux dérivés sur actions
françaises (modèle italien), 1,5 Md€ ; prélèvement sur le fonds d'épargne
de la Caisse des dépôts porté à 90 % de son résultat, 1,6 Md€ ; redevance
annuelle de marché sur les fréquences (modèle de l'Ofcom), 0,3 Md€. -/
def demembrement : List Int := [300, 600, 800, 1000, 1300, 1600, 1900, 2100, 2300]
def plusValuesImmobilieres : List Int := [1000, 1500, 2000, 2200, 2400, 2600, 2800, 3000]
def finDutreil : Int := 2000
def ttfElargie : Int := 1500
def prelevementFondsEpargne : Int := 1600
def redevanceFrequences : Int := 300

/-- Transition décrite finement (leviers `transitionEcologique`,
`investissementTransition`, `investissementPriveTransition` du modèle
commun) : paramètres propres aux mesures du programme, recherche
documentaire d'octobre 2026.

* Investissement privé dans le solaire : 0,87 M€ par MW au sol (0,72 €/W et
  0,15 €/W de raccordement) et 0,85 M€ par MW sur les toitures de 100 à
  500 kW (IEA-PVPS, National Survey Report France 2025) ; éolien terrestre :
  ≈ 1,4 M€ par MW (hypothèse, ordre de grandeur européen de l'IRENA).
* Raffinerie de Donges (O-160) : valeur ajoutée perdue ≈ 375 M€ par an
  (0,3 à 0,45 Md€ : marge brute de raffinage de 57 €/t en 2025 sur ≈ 10 Mt,
  moins les coûts d'exploitation ; DGEC), remplacée par des importations de
  produits raffinés ; 650 salariés et 1 500 à 2 800 emplois indirects.
* Rachat de 20 % du cheptel bovin (O-161) : valeur ajoutée agricole perdue
  ≈ 1 150 M€ par an (0,8 à 1,5 Md€ ; 154 820 ETP dans les exploitations
  bovines en 2020, Cour des comptes 2023 ; production de 1,3 Mtec en 2024,
  FranceAgriMer), dont ≈ 65 % remplacés par des importations de viande
  (≈ +0,75 Md€ ; ≈ +1,5 Md€ si la consommation ne baissait pas,
  hypothèse) ; aval (abattoirs, transformation) : ≈ 600 M€ de valeur ajoutée
  (10 000 emplois à 60 k€, hypothèse).
* Répartition des énergies évitées (hypothèses) : chauffage (O-158), 60 %
  de gaz et 40 % de fioul pour les PAC (le fioul en priorité), gaz pour les
  thermostats ; biofioul F30 : fioul remplacé par du biogazole ; tertiaire
  (O-159) : gaz, sauf les fluides frigorigènes ; biocarburants (O-157) :
  HVO 3 000 kt, biogazole 2 500 kt (B100, bus et cars), bioéthanol 500 kt.

Parts importées des biocarburants substitués (mêmes valeurs que
`Hypotheses.Energie.partImporteeTransition` : HVO 80 %, biogazole 55 %,
bioéthanol 10 %). -/
def partImporteeHvo : Int := 800
def partImporteeBiogazole : Int := 550
def partImporteeBioethanol : Int := 100
def capexSolaireSolMeurParMw : Int := 87
def capexSolaireToitMeurParMw : Int := 85
def capexEolienMeurParMw : Int := 140
def investissementSolaire (solMw toitMw : Int) : Int :=
  (solMw * capexSolaireSolMeurParMw + toitMw * capexSolaireToitMeurParMw) / 100
def valeurAjouteeDonges : Int := 375
def valeurAjouteeCheptel : Int := 1150
def partCheptelImporteePm : Int := 650
def valeurAjouteeAvalBovin : Int := 600
def chauffageGazKt : Int := (chauffagePacKt + 1150) * 600 / 1000 + 450
def chauffageFioulKt : Int := (chauffagePacKt + 1150) * 400 / 1000
def biofioulKt : Int := 1630

/-- Mesures originales pour le PIB (O-172 à O-174). Dans le modèle commun, le PIB monte
surtout par les heures travaillées, la population active et la
productivité ; recherche documentaire d'octobre 2026.

Budget réglementaire (O-172) : les coûts administratifs imposés aux
entreprises valent au moins 3 % du PIB (≈ 60 Md€ par an, chiffre du
gouvernement repris par le Sénat, rapport d'information n° 743, juin 2023,
p. 12 ; jusqu'au double selon le même rapport). La Commission européenne
estimait qu'une baisse de 25 % de coûts valant 3,5 % du PIB relèverait le
PIB de ≈ 1,4 % à moyen terme (communication COM(2007)23, §1.1, modèle
WorldScan du CPB ; jusqu'à 1,8 % avec QUEST) : ≈ 1,6 point de PIB par point
de coûts supprimés (calcul). Pour la France : 25 % de 3 % = 0,75 point,
soit ≈ +1,2 % de PIB ; la moitié seulement est retenue, car les
simplifications annoncées se réalisent mal (43 % des mesures du Conseil de
la simplification non effectives, Sénat 2017, repris par l'iFRAP ;
hypothèse) : +0,6 % de PIB, par cinquièmes de 2027 à 2031. Autorité
indépendante de mesure des coûts (modèle néerlandais ATR) : 30 M€ par an
(hypothèse). -/
def coutAdministratifPibPb : Int := 300
def baisseCoutsAdministratifsPm : Int := 250
def rendementPibSimplificationPm : Int := 1600
def realisationSimplificationPm : Int := 500
def anneesSimplification : Nat := 5
def gainSimplificationParAnPb : Int :=
  coutAdministratifPibPb * baisseCoutsAdministratifsPm / 1000 * rendementPibSimplificationPm / 1000
    * realisationSimplificationPm / 1000 / anneesSimplification
def autoriteNormes : Int := 30

/-- Visa diplômé France (O-173) : droit au séjour et au travail de trois
ans, sans autorisation de travail, pour tout diplômé de master ou de
doctorat d'un établissement français (modèle de la Graduate Route
britannique de 2021 et du permis post-diplôme canadien). ≈ 118 000
premiers titres étudiants en 2025 (DGEF, juin 2026) ; cinq ans après leur
arrivée, 21 % des étudiants étrangers sont encore en France avec un statut
économique (CAE, note n° 67, novembre 2021, p. 12). +10 points de rétention
(hypothèse) : ≈ 11 800 personnes de plus par an dans le solde migratoire,
actives à la part des migrants du scénario (60 %, prudent pour des
diplômés). Contribution budgétaire des immigrés : de −0,5 à +0,5 % du PIB
(CAE, p. 6) ; le FMI trouve jusqu'à +2 % de PIB par habitant à long terme
par point de migrants dans la population adulte (Jaumotte et al., 2016). -/
def premiersTitresEtudiants : Int := 118000
def hausseRetentionDiplomesPm : Int := 100
def visaDiplomeMilliersParAn : Int := premiersTitresEtudiants * hausseRetentionDiplomesPm / 1000 / 1000

/-- Droit au rachat des RTT (O-174) : le salarié peut exiger le paiement de
cinq jours de RTT par an, majorés de 10 % (aujourd'hui, l'employeur peut
refuser ; rachat possible jusqu'au 31 décembre 2026, avec déduction de
cotisations patronales), sans exonération : neutre pour les finances
publiques. 8 millions de salariés ont des RTT, 13 jours en moyenne
(hypothèse : aucune statistique publique ne les dénombre ; 40,1 % des
entreprises de 10 salariés ou plus accordent des RTT, 2,4 millions de
salariés sont au forfait jours, Dares) ; recours de la moitié
(hypothèse) ; 7 heures par jour ; ≈ 45 milliards d'heures travaillées par an
(≈ 30 millions d'emplois × 1 500 h, calcul) : ≈ +0,3 % d'heures. Risque :
la détaxation des heures supplémentaires de 2007 a relevé les heures
déclarées, pas les heures réelles (Cahuc et Carcillo, 2011). -/
def salariesRttMilliers : Int := 8000
def joursRachetables : Int := 5
def recoursRachatPm : Int := 500
def heuresParJour : Int := 7
def heuresTravailleesMillions : Int := 45000
def heuresRachatPm : Int :=
  salariesRttMilliers * 1000 * joursRachetables * recoursRachatPm / 1000 * heuresParJour * 1000
    / (heuresTravailleesMillions * 1000000)

theorem pib_originales_valeurs :
    gainSimplificationParAnPb = 12 ∧ visaDiplomeMilliersParAn = 11 ∧ heuresRachatPm = 3 := by decide

/-- Deuxième série de mesures pour le PIB (O-175 à O-178). Dans le modèle, le PIB monte
par la productivité, les heures et la population active en emploi ; le
levier `offreTravail` (actifs supplémentaires, part en emploi) a été ajouté
pour les seniors et les parents. Recherche documentaire de novembre 2026.

Concurrence (O-175) : liberté d'installation des notaires, huissiers,
pharmacies et taxis (fin du numerus clausus et des licences), ouverture du
capital des professions du droit et de la santé, tarifs réglementés revus
tous les deux ans, fin des monopoles de distribution (pièces détachées
visibles, médicaments sans ordonnance en grande surface). Repère : pour la
loi croissance et activité de 2015, l'OCDE estimait +0,3 % de PIB potentiel
à cinq ans et +0,4 % à dix ans (note remise au ministre le 18 septembre
2015, cinq blocs de mesures) ; une réforme « typique » de la réglementation
des marchés de produits vaut +0,7 % de PIB par habitant à cinq ans (Égert
et Gal, OCDE, document de travail n° 1354, 2016). La mesure, plus large que
la loi de 2015, en reprend le chiffrage, prudent : +6 pb de PIB par an de
2027 à 2031, puis +2 pb par an de 2032 à 2036. Coût public : nul
(indemnisation des offices non chiffrée, hypothèse). -/
def concurrenceGainParAnPb : Int := 6
def concurrenceGainSuitePb : Int := 2
def anneesConcurrence : Nat := 5

/-- Emploi des seniors (O-176) : surcote doublée (2,5 % par trimestre au
lieu de 1,25 %) de l'âge légal à 67 ans, et cumul emploi-retraite libre dès
l'âge légal dans les métiers en tension. 4,29 millions de 60-64 ans
(Insee, 1er janvier 2025) ; taux d'emploi de 42,4 % (Dares, 2024) contre
56,5 % en moyenne dans l'OCDE (Panorama des pensions 2025). Effets mesurés :
la surcote de 2003 a relevé de 7,5 points (+16 %) la probabilité de
travailler après 60 ans chez les éligibles (Benallah, Économie et
Statistique n° 441-442, 2011) ; la suppression du plafond de cumul aux
États-Unis, +0,8 à 2 points de participation des 65-69 ans (Song et
Manchester, 2007). Retenu : +1,5 point de taux d'emploi des 60-64 ans
(fourchette 0,8 à 2,5 ; hypothèse), soit ≈ 65 000 emplois par quarts de
2027 à 2030, 90 % en emploi dès l'année (ce sont des personnes qui
prolongent leur activité). Coût : 14 % des nouveaux retraités du régime
général liquident avec surcote (8,5 à 9,5 trimestres, DREES) ; doubler la
surcote ≈ +0,1 Md€ par cohorte, cumulatif (calcul), soit 1 Md€ par an au
bout de dix ans. -/
def seniorsActifsParAn : Int := 4290000 * 15 / 1000 / 4
def seniorsTauxEmploiPm : Int := 900
def surcoteCoutParCohorte : Int := 100

/-- Petite enfance (O-177) : 100 000 places de crèche de plus de 2027 à
2030 et droit opposable à une place dès un an (le service public de la
petite enfance visait +100 000 places en 2027 et +200 000 en 2030, annonce
du 1er juin 2023 ; les places ont baissé de 0,6 % en 2023). Taux d'emploi
des mères d'un enfant de moins de trois ans : 73 %, 70 % et 49 % selon le
nombre d'enfants, contre 79, 84 et 66 % quand le plus jeune a trois ans
(DREES, REPSS Famille 2024). Effets causaux : +10 points de couverture →
+3,4 à 3,7 points d'emploi des mères en Allemagne (Bauernschuster et
Schlotter, 2015), +1,1 point en France pour la PAJE de 2004 (Givord et
Marbot, 2015), ≈ 0 en Norvège (garde informelle remplacée) : 0,1 à 0,35
emploi de mère par place, 0,25 retenu (hypothèse) : +25 000 mères en
emploi, par quarts. Emplois directs : 0,3 équivalent temps plein par place
(hypothèse ; coût de revient de 19 450 € par place et par an, CNAF 2024,
dont ≈ 70 % de personnel) : 30 000 postes à 45 000 € ; investissement de
35 000 € par place (hypothèse) : 875 M€ par an. -/
def placesCrecheParAn : Int := 25000
def meresParPlacePm : Int := 250
def meresEmploiParAn : Int := placesCrecheParAn * meresParPlacePm / 1000
def postesParPlacePm : Int := 300
def postesCreche : List Int := (List.range 4).map fun (k : Nat) => placesCrecheParAn * postesParPlacePm / 1000 * (Int.ofNat k + 1)
def investissementCrecheParPlace : Int := 35000
def investissementCreche : List Int :=
  (List.replicate 4 (placesCrecheParAn * investissementCrecheParPlace / 1000000)) ++ [0]

/-- Temps partiel subi (O-178) : droit au temps complet (l'employeur accepte
la demande de passage à temps plein ou justifie d'un motif économique,
comme la loi néerlandaise de 2016 sur le travail flexible) et heures
complémentaires majorées de 25 % dès la première. 4,3 millions de salariés
à temps partiel (17,6 %), 23,1 heures par semaine, 21,3 % « faute de temps
complet » (Insee, enquête Emploi 2025) ; sous-emploi : 4,3 % des personnes
en emploi (≈ 1,3 million). Un quart du temps partiel subi résorbé en cinq
ans (≈ 300 000 personnes, +12 heures par semaine) vaudrait ≈ +100 000
équivalents temps plein ; la moitié retenue (hypothèse, les heures
déclarées pouvant dépasser les heures réelles) : +2 ‰ d'heures par emploi,
par moitiés en 2027 et 2028. Coût public nul. -/
def heuresTempsPartielPm : Int := 1

/-- Dette cachée d'entretien (O-179). Le modèle commun suit depuis novembre
2026 un passif « retard d'entretien des infrastructures » : ≈ 12 Md€ fin
2025 (ouvrages d'art routiers ≈ 6 Md€, dont 3,3 Md€ pour les ponts et murs
des petites communes, Cerema, Programme national ponts, bilan d'octobre
2025 ; chaussées nationales ≈ 4,5 Md€ ; voies navigables 1,1 Md€), qui
grossit de ≈ 0,8 Md€ par an (`Hypotheses.Reference`). L'enveloppe de
1 Md€ par an pendant dix ans (fonds ponts des collectivités et entretien
courant : 0,5 Md€ ; chaussées nationales : 0,35 Md€ ; voies navigables :
0,15 Md€) résorbe ≈ 10 Md€ sur ≈ 20 Md€ de retard cumulé en 2035 ; travaux
publics : ≈ 5,5 emplois directs par million d'euros (FNTP, calcul) ; un
entretien différé coûte ≈ 3 fois plus en curatif (audit du réseau routier
national, 2018). Limite : capacité des maîtrises d'ouvrage communales (la
moitié des ouvrages subventionnés en 2023 sans travaux engagés deux ans
plus tard) et coûts des travaux d'ouvrages d'art en hausse de 84 % de 2016
à 2023.

Maintenance renforcée : l'enveloppe
passe à 1,8 Md€ par an pendant douze ans, soit 1 Md€ de résorption du
retard et 0,8 Md€ d'entretien courant égal au flux annuel de dégradation :
le stock cesse de croître et se résorbe de 1 Md€ par an, à zéro vers 2038 ;
l'État remplace ensuite l'enveloppe par l'entretien courant seul. -/
def entretienInfrastructuresParAn : Int := 1800
def anneesEntretien : Nat := 12

/-- Suppression des effets de seuil (O-180). Règle : tout droit sous
condition de ressources décroît de façon continue, jamais par marche, et la
linéarisation part du dernier montant acquis (« par le haut », sans
perdant). Marches identifiées (recherche documentaire de novembre 2026 ;
déjà lissés : ARS, allocations familiales, CMG depuis septembre 2025,
réversion, ASPA, AAH, RSA, prime d'activité, aides au logement, décote,
CEHR) et coût d'un lissage par le haut, M€ par an (ordres de grandeur,
hypothèses) :
* complémentaire santé solidaire : participation proportionnelle au revenu
  jusqu'à ≈ 18 000 € au lieu du double seuil (gratuite sous 10 421 €,
  payante jusqu'à 14 069 €, puis rien : perte de 500 à 1 400 € par an ;
  7,8 millions de bénéficiaires, DREES 2025) : 650 (300 à 1 000) ;
* MaPrimeRénov' : taux d'aide continu au lieu des quatre catégories (saut
  jusqu'à 14 000 € sur 40 000 € de travaux entre violet et rose, barème
  Anah 2026) : 400 (100 à 400) ;
* CSG des retraités : barème continu au lieu des taux 0, 3,8, 6,6 et
  8,3 % (marches de 440 à 620 € par an, lissage de deux ans sur une seule
  marche) : 350 (200 à 500) ;
* bourses étudiantes : montant linéaire au lieu des huit échelons (marches
  de 300 à 2 200 €) : 350 (étape 2 de la réforme de 2023, chiffrée puis
  gelée en 2025) ; bourses de collège et de lycée : 100 ;
* allocation de base et prime de naissance de la PAJE, complément familial
  (marches de 1 060 à 2 360 €) : 350 (250 à 600) ;
* chèque énergie : montant continu au lieu de quatre tranches : 150 ;
* taxe foncière des plus de 75 ans et dégrèvements (seuils de revenu
  fiscal, perte de 1 000 à 1 500 €) : sortie dégressive, 150 ;
* allègements de cotisations à 3 SMIC et prime de partage de la valeur :
  corrections paramétriques, coût non compté.
Total ≈ 2,5 Md€ par an (1,5 à 3,5). Effet sur l'emploi : les taux marginaux
effectifs au-dessus de 100 % ne touchent que 1,1 % des personnes en emploi
(Insee Analyses n° 66, 2021) et la réponse aux barèmes de prestations est
faible (élasticité ≈ 0,1, Sicsic 2022) : +0,01 à +0,1 % d'heures, trop
faible et incertain pour être compté ; le gain est l'équité et le
non-recours (66 % pour la C2S payante). Une microsimulation (Ines,
TAXIPP) serait nécessaire pour compter les ménages au voisinage de chaque
seuil : hors de portée du modèle agrégé. -/
def lissageSeuilsFamille : Int := 350 + 100 + 350 + 150
def lissageSeuilsSante : Int := 650
def lissageSeuilsLogement : Int := 400
def lissageSeuilsCsg : Int := 350
def lissageSeuilsTaxeFonciere : Int := 150

theorem pib_deux_valeurs :
    seniorsActifsParAn = 16087 ∧ meresEmploiParAn = 6250 ∧ postesCreche = [7500, 15000, 22500, 30000] ∧
    investissementCreche = [875, 875, 875, 875, 0] := by decide

/-- Foncière de l'État (O-170) : cession d'un quart des bureaux de l'État
en dix ans (23 millions de m², valeur comptable 73,7 Md€ ; cessions de
0,2 à 0,3 Md€ par an aujourd'hui ; projet de foncière de l'État, Sénat,
PLF 2025, compte d'affectation spéciale « Immobilier de l'État ») :
≈ 0,9 Md€ par an, investissement négatif qui réduit le déficit ; ventes
avec reprise en location exclues (Eurostat les requalifie en dette).

Reconversion en logements sociaux privilégiée : la moitié des surfaces cédées va aux organismes HLM
(hypothèse), avec la décote prévue par la loi du 18 janvier 2013 (jusqu'à
la cession gratuite ; repères : 100 % pour le PLAI, 75 % pour le PLUS,
50 % pour le PLS), 50 % en moyenne (hypothèse) : produit des cessions
ramené de 900 à 675 M€ par an. Logements produits : 450 M€ de surfaces à
≈ 3 200 €/m² (73,7 Md€ pour 23 millions de m², calcul), 65 m² par logement
(hypothèse) : ≈ 2 160 logements sociaux par an ; transformation à
≈ 2 500 € HT/m² payée par les bailleurs (rapport Bouyer-Lépine, juillet
2025), non comptée dans le solde public. Décotes de 2013-2016 : ≈ 23 000 €
par logement social (Cour des comptes, 2017, calcul). -/
def cessionsBureauxMarche : Int := 900
def partHlmCessionsPm : Int := 500
def decoteHlmPm : Int := 500
def cessionsBureaux : Int := cessionsBureauxMarche - cessionsBureauxMarche * partHlmCessionsPm / 1000 * decoteHlmPm / 1000
def logementsSociauxBureaux : Int := cessionsBureauxMarche * partHlmCessionsPm / 1000 * 1000000 / 3204 / 65

/-- Confiscation des avoirs criminels sans condamnation (O-171), permise
par la directive (UE) 2024/1260 à transposer avant novembre 2027 : en 2025,
1,44 Md€ saisis, 212 M€ confisqués dont 145 M€ versés au budget (ministère
de la Justice) ; +0,1 puis +0,2 Md€ par an (estimation). -/
def avoirsConfisques : List Int := [100, 200]

theorem paquet_ultra_valeurs : sobrieteRoutiereKt = 3860 ∧ flottesKt = 6580 ∧ biocarburantsKt = 6000 ∧
    chauffageKt = 6470 ∧ tertiaireKt = 3600 ∧ energieKt = 2230 ∧ agricultureKt = 7000 ∧
    soutienSolaireSupplement = [25, 75, 126, 177, 202] ∧
    devisesVendues = 14200 ∧ chauffageGazKt + chauffageFioulKt + biofioulKt = chauffageKt ∧
    investissementSolaire solaireSolParAnMw solaireToitParAnMw = 7102 := by decide

/-- Essai d'octobre 2026 (variante d'O-124) : hausse de la composante
carbone multipliée par 8, soit 44,6 + 8 × 55,4 = 487,8 €/t en 2030 (calcul),
avec le même partage en chèque énergie. -/
def multipleCarboneEssai : Int := 8

/-- Plan de rénovation des ascenseurs (O-182). Parc : 661 000 ascenseurs en 2025, dont ≈ 25 % de plus
de 40 ans (≈ 165 000) et 40 % de plus de 25 ans ; ≈ 2 900 remplacements
complets par an (taux de renouvellement de 0,45 %, plus de deux siècles
pour renouveler le parc) ; 1,5 million de pannes par an, 126 000
personnes bloquées en cabine ; 17 200 salariés, chiffre d'affaires de
2,83 Md€ (Fédération des Ascenseurs 2025-2026 ; rapport AN n° 704, janvier
2025). Le plan remplace les 165 000 appareils de plus de 40 ans en onze
ans (15 000 par an, cinq fois le rythme actuel ; la filière installe
11 000 appareils neufs par an et recrute 1 000 à 2 000 personnes par an :
risque d'exécution élevé les premières années), à 75 000 € par appareil
(remplacement complet : ≈ 30 000 € pour cinq niveaux, jusqu'à 300 000 €
pour une tour ; moyenne pondérée, hypothèse). L'État subventionne 30 % des
travaux (taux de MaPrimeRénov' Copropriété ; ANAH pour les copropriétés,
ANRU-PNRU3 pour le logement social), soit 338 M€ par an ; les
copropriétés et les bailleurs financent le reste (prêts de la Banque des
Territoires), 70 % de 12 100 appareils réellement supplémentaires (les
2 900 remplacements tendanciels sont subventionnés sans être ajoutés :
effet d'aubaine de 19 %), soit 635 M€ par an d'investissement privé
déclenché. Chaque appareil remplacé consomme ≈ 2 000 kWh de moins par an
(≈ 3 400 kWh pour un appareil ancien, ≈ 1 200 pour un récent ; Fédération
des Ascenseurs, Kone) et appelle ≈ 40 % de dépannages en moins (bailleur
ayant remplacé 200 appareils sur 700, 2026). Non comptés : pannes évitées,
personnes âgées maintenues à domicile, accidents (≈ 1 décès par an). -/
def ascenseursAnciens : Int := 165000
def remplacementsAscenseursParAn : Int := 15000
def remplacementsAscenseursTendanciels : Int := 2900
def coutRemplacementAscenseurEuros : Int := 75000
def partEtatAscenseursPm : Int := 300
def economieAscenseurKwh : Int := 2000
def anneesPlanAscenseurs : Nat := 11
def travauxAscenseursParAn : Int := remplacementsAscenseursParAn * coutRemplacementAscenseurEuros / 1000000
def subventionAscenseursParAn : Int := travauxAscenseursParAn * partEtatAscenseursPm / 1000
def investissementPriveAscenseurs : Int :=
  (remplacementsAscenseursParAn - remplacementsAscenseursTendanciels) * coutRemplacementAscenseurEuros
    * (1000 - partEtatAscenseursPm) / 1000 / 1000000
def economieAscenseursGwhParAn : Int :=
  (remplacementsAscenseursParAn - remplacementsAscenseursTendanciels) * economieAscenseurKwh / 1000000

theorem ascenseurs_eq : travauxAscenseursParAn = 1125 ∧ subventionAscenseursParAn = 337 ∧
    investissementPriveAscenseurs = 635 ∧ economieAscenseursGwhParAn = 24 ∧
    remplacementsAscenseursParAn * anneesPlanAscenseurs = ascenseursAnciens := by decide

/-- Suppression des zones à faibles émissions à terme et de la vignette
Crit'Air (O-183). Droit en vigueur :
loi Climat et résilience de 2021 (ZFE obligatoires dans les agglomérations
de plus de 150 000 habitants ; Crit'Air 3 interdites à Paris et Lyon
depuis le 1er janvier 2025, sanctions à Lyon depuis juillet 2026, à Paris
pas avant 2027) ; l'abrogation votée dans la loi de simplification (avril
2026) a été censurée comme cavalier législatif (Conseil constitutionnel,
21 mai 2026) ; la proposition de loi d'abrogation n'a pas été votée le
8 octobre 2026. La mesure abroge les ZFE au 1er janvier 2029 (deux ans
pour les alternatives) et la vignette Crit'Air (la circulation différenciée
des pics de pollution, 0 à 3 jours par an, revient à l'alternance des
plaques). Effet sanitaire : les ZFE accélèrent le renouvellement du parc
(+5,8 points de Crit'Air 1 et E en deux ans, −4,6 points de NOx du parc,
Insee Analyses n° 124, août 2026) ; décès évités à terme par l'ensemble des
ZFE, si elles étaient appliquées : ≈ 150 par an (fourchette 30 à 350 ;
Airparif 2024 : −2,2 % des 5 040 décès attribuables du Grand Paris pour
l'étape Crit'Air 3 ; ORS Île-de-France 2018 : 110 à 340). Le modèle
compte ces décès non évités, par tiers de 2029 à 2031, sur les 40 000
décès attribuables aux particules fines du tendanciel. Finances : aides
spécifiques aux ZFE de l'État inférieures à 5 M€ par an depuis la fin de la
prime à la conversion (Sénat 2023) ; vignette (3,85 €, ≈ 2,5 millions par
an) au coût de fabrication, sans recette nette ; contrôle automatisé non
chiffré publiquement (pas d'économie comptée). Les 0,5 million de voitures
Crit'Air 3 et plus des territoires de Paris et Lyon (SDES 2024, attrition
d'un cinquième par an) ne sont plus remplacées par anticipation : dépense
des ménages reportée, sans effet net compté ; effet sur le parc électrique
négligeable (le renouvellement induit va surtout vers l'essence Crit'Air
1). -/
def decesZfeNonEvitesParAn : Int := 50
def anneesZfe : Nat := 3
def economieAidesZfe : Int := 5

/-- Compensation sanitaire de la fin des ZFE (O-183c) : 10 000 voitures
Crit'Air 5 ou non classées de plus par an remplacées par une électrique
d'occasion récente (12 000 € : hypothèse, prix moyen d'une citadine
électrique de trois à cinq ans ; part importée comme O-01), de 2029 à 2035
(sept vagues, 70 000 voitures), en plus des 90 000 d'O-01 : 160 000 des
1,2 million de Crit'Air 5 et non classées du parc. Le modèle en déduit
≈ 47 décès évités par an en 2035 (6,75 par vague de 10 000), de quoi
rester sous la mortalité du tendanciel après les ≈ 150 décès des ZFE. -/
def remplacementOccasion : Remplacement :=
  { remplacement with prixUnitaire := 12000 }
def vaguesOccasion : Nat := 7

/-- Formation aux premiers secours obligatoire au lycée (O-184). Droit : l'article L. 312-13-1 du code de
l'éducation (loi « citoyen sauveteur » du 3 juillet 2020) prévoit
l'apprentissage des gestes pendant la scolarité obligatoire, sans le lycée
ni objectif chiffré ; ≈ 30 % des élèves de 3e sont certifiés PSC1
(2022-2023, ministère ; 44 % en 2017-2018), aucun suivi au lycée ; la
proposition de loi Castiglione (100 % des 3e en 2030) a été retirée en
mai 2025. La mesure : formation PSC (7 h) en seconde pour les élèves non
certifiés et recyclage de 3 h en terminale pour tous. Effectifs (DEPP,
rentrée 2025) : 802 500 entrants au lycée (seconde générale et
technologique 558 700, seconde professionnelle 184 700, CAP 59 100), dont
≈ 70 % sans PSC1, soit 560 000 ; 684 000 élèves de terminale. Coût : 60 €
par formation complète (tarif moyen, ministère, 2023 ; 35 à 40 € en
interne avec les 7 000 enseignants formateurs) et 27 € par recyclage
(3 h : calcul au prorata), soit 34 + 18 = 52 M€ par an, arrondis à 50 M€
avec le matériel et la formation des formateurs (il faudrait les
doubler) ; dépense d'enseignement. Effet : 46 000 arrêts cardiaques
extrahospitaliers par an, survie ≈ 7 %, réanimation par un témoin dans
36 % des cas (RéAC, ARLoD 2024) contre 45 % au Danemark après la formation
scolaire de 2005 (21 % avant) et plus de 80 % en Norvège ; porter la survie
à 10-14 % éviterait 1 400 à 3 200 décès par an toutes mesures confondues ;
part attribuable à la seule formation lycéenne : 20 à 40 %, soit 300 à
1 300 décès par an à plein régime (calcul), retenus à 600, soit 1,5 % des
40 000 décès de la cause, atteints en quinze ans (≈ 300 par an en 2035).
Preuve causale faible (GRADE), mise en œuvre partielle des lois scolaires
ailleurs (Danemark : 28 % des classes formées huit ans après la loi). -/
def elevesSecondeAFormer : Int := 560000
def elevesTerminale : Int := 684000
def coutPscEuros : Int := 60
def coutRecyclagePscEuros : Int := 27
def depensePremiersSecours : Int := 50
def baisseDecesArretCardiaquePm : Int := 15

theorem premiers_secours_eq :
    (elevesSecondeAFormer * coutPscEuros + elevesTerminale * coutRecyclagePscEuros) / 1000000 = 52 ∧
    40000 * baisseDecesArretCardiaquePm / 1000 = 600 := by decide

/-- Remboursement de la chirurgie réfractive (O-185 : Lasik, PKR, SMILE,
implants). Aujourd'hui hors
nomenclature (acte « de confort », TVA à 20 %), prise en charge par les
complémentaires pour quatre assurés sur cinq (305 € par œil en moyenne,
DREES 2024) ; 150 000 à 200 000 yeux opérés par an (ANSM 2021, Revue du
Praticien 2021 ; retenu 180 000), 1 000 à 2 000 € par œil au laser
(retenu 1 300) ; aucun pays ne rembourse l'acte de routine (Pays-Bas :
indications médicales strictes). La mesure : tarif de responsabilité de
1 500 € par œil remboursé à 70 % (1 050 €), le reste pris par les
complémentaires sous contrat responsable. Demande : reste à charge
quasi nul, 3 % des amétropes opérés et 15 % intéressés (KCE 2013), flux
multiplié par 2,5 (fourchette 1,5 à 4) en trois ans, limité par l'offre
(5 800 ophtalmologistes, 130 lasers) : 180 000, 270 000 puis 450 000 yeux
par an, soit 189, 326 (à mi-montée) puis 473 M€ par an. Économie sur l'optique
remboursée : faible, l'Assurance maladie ne finance que 345 M€ des 8,3 Md€
d'optique (4 %, DREES 2024), ≈ 20 € par an et par opéré, soit ≈ 4,5 M€ par
cohorte de 225 000 opérés (calcul), déduite de la dépense ; les économies
des complémentaires (≈ 150 € par porteur et par an) et des ménages ne sont
pas publiques. TVA perdue sur l'activité existante : 234 M€ × 1/6 = 39 M€
par an (calcul ; les actes induits n'en payaient pas). Non comptés :
retouches (11 % à dix ans), presbytie après 45 ans, éviction de l'activité
médicale des ophtalmologistes (cataracte, rétine) vers le réfractif. -/
def yeuxOperesParAn : Int := 180000
def multiplicateurChirurgieRefractivePm : Int := 2500
def tarifResponsabiliteOeilEuros : Int := 1500
def tauxRemboursementOeilPm : Int := 700
def economieOptiqueParCohorte : Int := 45    -- dixièmes de M€ par an et par cohorte
def tvaPerdueChirurgieRefractive : Int := yeuxOperesParAn * 1300 / 6 / 1000000
def depenseOeil : Int := tarifResponsabiliteOeilEuros * tauxRemboursementOeilPm / 1000
/-- Yeux remboursés par année : montée en charge en trois ans. -/
def yeuxRembourses (k : Nat) : Int :=
  let plein := yeuxOperesParAn * multiplicateurChirurgieRefractivePm / 1000
  if k = 0 then yeuxOperesParAn else if k = 1 then (yeuxOperesParAn + plein) / 2 else plein
/-- Dépense nette de l'année `k`, M€ : remboursements moins l'optique
économisée par les cohortes déjà opérées. -/
def depenseChirurgieRefractive (k : Nat) : Int :=
  yeuxRembourses k * depenseOeil / 1000000 - Int.ofNat k * economieOptiqueParCohorte / 10
def chirurgieRefractiveNiveaux : List Int := (List.range 10).map depenseChirurgieRefractive

theorem chirurgie_refractive_eq : depenseOeil = 1050 ∧ tvaPerdueChirurgieRefractive = 39 ∧
    chirurgieRefractiveNiveaux = [189, 326, 463, 459, 454, 450, 445, 441, 436, 432] := by decide

/-- Avion de combat du futur de sixième génération (O-186). Le pilier « avion » du SCAF franco-allemand a été
abandonné en juin 2026 (constat d'échec Macron-Merz, ILA Berlin ; seuls les
drones et le réseau de combat survivent) ; la France développe seule l'ACF
avec Dassault, Safran et Thales : démonstration lancée en 2027,
développement à partir de 2029, démonstrateur en vol en 2031-2032,
service vers 2040 (ministre des Armées, 8 octobre 2026 ; chef d'état-major
de l'armée de l'air, 14 octobre 2026). Crédits inscrits : 2,74 Md€
d'autorisations d'engagement et 558 M€ de crédits de paiement en 2027
(PLF 2027, programme 146), dans une LPM actualisée (loi n° 2026-791) qui
n'avait budgété le SCAF qu'à hauteur de ≈ 0,5 Md€ par an. Coût d'un
programme national : « nettement en dessous de 50 Md€ » selon Dassault,
25 à 35 Md€ de développement sur 2027-2040 selon la presse spécialisée
(1,8 à 2,5 Md€ par an), le Rafale ayant coûté 44 Md€ (prix 2011) pour le
développement et la série ; le GCAP britannico-italo-japonais vise 2035
(Italie : 18,6 Md€ pour les phases 1 et 2). La mesure sécurise le
financement à 2,1 Md€ par an en rythme de croisière (30 Md€ sur quatorze
ans, hypothèse médiane) en ajoutant à la trajectoire de la LPM, qui
monte de 0,56 à ≈ 0,9 Md€ par an de crédits de paiement (hypothèse), la
différence : 0,3 Md€ en 2027, 0,6 en 2028, 1,0 en 2029, 1,2 Md€ par an
de 2030 à 2035, en dépense de défense (industrie nationale : Dassault,
Safran, Thales ; part importée de la dépense de défense du modèle). Elle
contredit en partie O-43 (−1 Md€ par an sur la défense), gardé : le
programme arbitre entre les équipements. -/
def avionCombatFutur : List Int := [300, 600, 1000, 1200]

/-- Contribution à l'Agence spatiale européenne dépassant l'allemande
(O-187). Conseil ministériel de Brême
(novembre 2025, 22,3 Md€ souscrits sur 2026-2028) : Allemagne 5,07 Md€
(5,4 aux conditions économiques de 2025, 23 %), France 3,6 Md€ (16 %, +12 %
par rapport à 2022), Italie 3,5, Espagne 1,85, Royaume-Uni 1,7 (ESA, DLR,
Sénat, avis PLF 2026 ; la France contribuait ≈ 1,07 Md€ par an en 2024,
plus de la moitié du programme 193). Dépasser l'Allemagne aux conditions
courantes demande ≈ 1,9 Md€ de plus sur trois ans (630 M€ par an, version
initiale) ; le 5 novembre 2026, l'auteur divise le supplément par deux
(« ESA +315 M€ ») : 315 M€ par an à partir de 2027, ≈ 0,95 Md€ sur trois
ans, soit ≈ 4,5 Md€ pour la France contre 5,07 pour l'Allemagne (la France
reste deuxième contributeur, devant l'Italie), souscrits aux programmes optionnels (lanceurs, Ariane 6 et
European Launcher Challenge, observation de la Terre, exploration,
connectivité), au bénéfice de la filière française par le retour
géographique (ArianeGroup, Airbus Defence and Space, Thales Alenia Space ;
≈ 30 000 emplois spatiaux, dont 20 000 industriels) ; dépense d'affaires
économiques (recherche), traitée comme une dépense intérieure (le retour
géographique de l'ESA approche 90 % ; hypothèse). -/
def contributionEsaSupplement : Int := 315

/-- Rachat de l'or et montée de l'État au capital des entreprises dès que le
déficit est résorbé (O-188). Dès
qu'une année se termine en excédent, la moitié de l'excédent est placée
l'année suivante, l'autre moitié remboursant la dette (opération
financière : la dette baisse moitié moins, le déficit n'en est pas
affecté) : pour moitié en rachat d'or par la Banque de France pour
le compte de l'État, jusqu'à reconstituer la valeur de la moitié vendue par
O-149 (`valeurOr / 2`, ≈ 128 Md€ au cours de 2025 : les 1 218 tonnes
vendues, hypothèse de cours constant), pour moitié en prises de
participation dans les entreprises (Agence des participations de l'État,
Bpifrance ; dividendes au rendement du portefeuille actuel, O-47 en
donne le rythme de 100 M€ par an sans attendre l'excédent). Au scénario
central, le déficit n'est pas résorbé avant 2035 sous le moteur de demande
(0,33 %) : la mesure ne joue que dans les scénarios favorables et sous les
moteurs d'offre et d'équilibre (excédent à partir de 2034-2035). -/
def partExcedentPlacePm : Int := 500
def partOrPlacementPm : Int := 500

/-- Banque de la démocratie (O-189). Historique : promise en 2017 (loi pour la confiance dans la vie
politique, habilitation à légiférer par ordonnance), enterrée en 2018 au
profit du médiateur du crédit aux candidats et aux partis (≈ 250 saisines
par an, 11 refus de prêt à la présidentielle de 2022, 53 refus écrits
essuyés par le RN depuis 2017, prêt hongrois de 10,6 M€ en 2022) ;
relancée par le Premier ministre en janvier 2025, proposition de loi
d'EPIC adossé à la Caisse des dépôts (avril 2026), Matignon négociant en
juillet 2026 un « pool » bancaire garanti par l'État. Besoins : à la
présidentielle de 2022, 11 M€ d'emprunts bancaires et 34,9 M€ de prêts
des partis (eux-mêmes empruntés à 1,3-1,8 %) pour 83,5 M€ de dépenses,
42,2 M€ remboursés par l'État (CNCCFP) ; ≈ 26 M€ d'emprunts bancaires
avec les législatives ; encours de pointe plausible de 40 à 60 M€ l'année présidentielle, 10 à 30 M€ les autres années
(calcul). La mesure : établissement public adossé à la Caisse des dépôts,
dotation de 75 M€ en 2027 (fourchette 50 à 100 M€, hypothèse ; opération
financière : dette, pas déficit), prêts aux candidats et aux partis à
taux coûtant sur nantissement du remboursement forfaitaire de l'État,
garantie des prêts bancaires, décisions motivées sur critères objectifs,
supervision de l'ACPR. Règle de remboursement préalable : aucun nouveau
prêt tant qu'un prêt antérieur n'est pas remboursé, la règle suivant les
dirigeants statutaires et les mandataires financiers du parti emprunteur
(périmètre des « partis liés » de la CNCCFP), pour empêcher la recréation
d'un parti coquille ; précédent le plus proche : le Canada rend le parti
responsable des prêts impayés de ses candidats. Coût de fonctionnement
5 M€ par an (≈ 20 ETP et systèmes, hypothèse ; la médiation actuelle
coûte 13 000 € hors salaires, la CNCCFP emploie 46 agents) et pertes
attendues 2 M€ par an (candidats sous 5 % et comptes rejetés : 2,7 % de
rejets aux législatives de 2024, 70 % seulement des prêts de particuliers
remboursés à temps ; hypothèse), dépense de fonctionnement. Risques :
article 4 de la Constitution (libre formation des partis) pour une règle
qui suit les dirigeants, droit des aides d'État, « filtre politique »
dénoncé par le Sénat en 2017 ; le médiateur du crédit juge un
établissement dédié peu viable (besoins cycliques). -/
def dotationBanqueDemocratie : Int := 75
def coutBanqueDemocratie : Int := 5 + 2

/-! ## O-190 à O-200 — Onze mesures sociales, éducatives et environnementales

Onze mesures pour compléter le
programme (celles qu'il porte déjà ne sont pas reprises : violences
sexistes, taxe numérique, leasing social, CSG progressive, exonérations,
Ehpad, enseignants) :

* enseignement supérieur, 20 000 postes en dix ans ;
* AAH au seuil de pauvreté ;
* reconversion de 500 000 actifs en dix ans (un million dans la version
  initiale) ;
* sport à 1 % du budget de l'État, en cinq ans ;
* taxe de 1 €/kg sur les emballages non recyclables, affectée au
  recyclage ;
* avantage en nature des voitures de fonction thermiques corrigé, pour la
  moitié des 4 Md€ de subvention implicite (hypothèse : l'autre moitié
  disparaît avec l'électrification des flottes, O-156) ;
* suppression des doublons entre l'État et les collectivités : la moitié
  des 7,5 Md€ d'économies annoncées dans les contre-budgets de 2026, en
  cinq ans (hypothèse prudente ; recouvrement avec O-26 limité aux
  fonctions de contrôle) ;
* aide humanitaire d'urgence portée à 1 Md€ par an, versée à l'étranger
  (sans effet sur la demande intérieure, comme O-114) ;
* asile : 30 000 places d'hébergement, 10 000 visas humanitaires par an,
  20 000 réinstallations en cinq ans ;
* mutuelle publique gratuite pour les 18-25 ans (1 Md€ par an) ;
* fonds vert des collectivités porté de 1,5 Md€, en investissement public.

Sources des coûts : SIES, DREES, Insee, France compétences, Sénat. -/
def coutEnseignantSuperieurEuros : Int := 59230000000 / 852752
def postesSuperieurCumul : List Int := ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List Int).map fun k => 2000 * k
def hausseAahTod : Int := 12700 * (133700 - 104159) / 104159
def reconversionsTod : Int := 50000
def coutReconversionTod : Int := reconversionsTod * 29220 / 1000000
def hausseSportTod : Int := 452700 / 100 - 550
def sportEcheancier : List Int := ([1, 2, 3, 4, 5] : List Int).map fun k => k * hausseSportTod / 5
def taxeEmballages : Int := 500
def avantageNatureThermique : Int := 4000 / 2
def doublonsEtatCollectivites : List Int := ([1, 2, 3, 4, 5] : List Int).map fun k => 0 - k * 7500 / 2 / 5
def aideHumanitaire : Int := 500
def coutAsileTod : Int := 30000 * 21 * 365 / 1000000 + 14000 * 21 * 365 / 1000000
def accueillisTodMilliers : Int := 14
def mutuelleJeunes : Int := 1000
def fondsVert : Int := 1500

theorem ps_proches_valeurs : coutEnseignantSuperieurEuros = 69457 ∧ hausseAahTod = 3601 ∧
    coutReconversionTod = 1461 ∧ hausseSportTod = 3977 ∧ sportEcheancier = [795, 1590, 2386, 3181, 3977] ∧
    doublonsEtatCollectivites = [-750, -1500, -2250, -3000, -3750] ∧ coutAsileTod = 336 := by decide

/-! ## O-201 à O-203 — Santé : DPI-A, maladies rares, imagerie

**O-201 — Autorisation et prise en charge du DPI-A** (diagnostic
préimplantatoire des aneuploïdies), interdit depuis le rejet de 2020 (loi
de bioéthique 2021 ; essai DEVIT annulé par le juge administratif en 2024
et 2025), autorisé en Espagne, Italie, Portugal, Belgique… ; proposition
de loi transpartisane n° 3314 du 13 octobre 2026 (cinq indications : plus
de 35 ans, échecs répétés d'implantation, fausses couches à répétition,
anomalie augmentant le risque, embryons 1PN/3PN ; prise en charge par
l'Assurance maladie, non chiffrée). Volumes : ≈ 61 700 ponctions de FIV et
ICSI par an (Agence de la biomédecine 2022), 52 % à 35 ans et plus, soit
≈ 32 000, plus ≈ 3 000 autres indications ; 70 % des cycles atteignent le
stade biopsiable (hypothèse) : ≈ 24 500 cycles à 2 000 € (biopsie et
séquençage en laboratoire hospitalier ; 1 500 à 3 000 € dans les
cliniques européennes), 49 M€ par an ; transferts et fausses couches
évités (3,7 → 1,8 transferts par naissance après 38 ans, PPL) : 10 à
30 M€ par an d'économies ; coût net retenu 30 M€ par an. Pas de gain de
naissances cumulées par ponction (Cochrane 2020, Yan et al. NEJM 2021) :
aucun effet sur la natalité du modèle.

**O-202 — Fonds de financement des soins des maladies rares, « fin des
cagnottes de soin »** : ≈ 3 millions de malades, 95 % sans traitement ;
PNMR4 2025-2030 : 220 M€ par an, presque entièrement absorbés par les
centres existants ; médicaments orphelins : 2,2 Md€ nets en 2022
(+20 % par an). Cagnottes en ligne pour des soins : GoFundMe France
15,7 M€ collectés en 2025 toutes causes, La Cagnotte des Proches ≈ 4 M€
pour 4 500 cagnottes santé (870 € en moyenne, plus grosse 190 000 € pour
un traitement aux États-Unis) : 20 à 40 M€ par an en tout (estimation).
Le fonds : 30 M€ pour se substituer aux cagnottes (soins et traitements
non remboursés, soins à l'étranger hors S2, matériel), 150 M€ de
couverture des restes à charge « invisibles » des malades rares (France
Assos Santé : > 1 500 € par an et par malade chronique ; plafond de
1 000 € pour ≈ 150 000 bénéficiaires sous conditions, hypothèse), 70 M€
d'accès compassionnel élargi (l'accès précoce et compassionnel coûte déjà
1,5 Md€, DREES 2023) : 250 M€ par an, dépense de santé.

**O-203 — Assouplissement des autorisations d'imagerie lourde** : les
scanners et IRM restent soumis à autorisation par site (jusqu'à 3
appareils sans nouvelle autorisation, 18 au plus, décrets de septembre
2022) ; parc 2024 : 1 312 IRM et 1 432 scanners, 17,9 IRM et 20,2 scanners
par million d'habitants contre 34,9 et 36,3 en Allemagne (IGAS-IGF 2025),
délai d'IRM ≈ 32 jours (dernière enquête nationale, 2018 ; objectif 20) ;
plus de 1 000 appareils installables selon la FHF. La mesure : autorisation
d'activité et non plus d'appareil, sans plafond par site (Cour des comptes
2016), avec la baisse des forfaits techniques recommandée par l'IGAS
(−11 %, les forfaits couvrant 163 % des coûts). Coût : +1 000 appareils en
cinq ans à ≈ 1 M€ d'activité remboursée chacun par an (forfait 0,5 M€,
honoraires 0,4 à 0,6 M€), dont une part de substitution : +450 M€ par an
au terme (fourchette IGAS-IGF : 116 M€ à 1 Md€), moins 170 M€ de baisse
des forfaits : 280 M€ nets par an atteints en 2031. Investissement privé
des cabinets (≈ 1 Md€ en cinq ans, appareils largement importés) et gains
de délais non modélisés (aucune étude française ne chiffre les années de
vie gagnées). -/
def dpiaCyclesParAn : Int := 24500
def dpiaCoutCycleEuros : Int := 2000
def dpiaEconomies : Int := 19
def dpiaCoutNet : Int := dpiaCyclesParAn * dpiaCoutCycleEuros / 1000000 - dpiaEconomies
def fondsMaladiesRares : Int := 30 + 150 + 70
def imagerieNiveaux : List Int := ([1, 2, 3, 4, 5] : List Int).map fun k => k * (450 - 170) / 5

theorem sante_proches_valeurs : dpiaCoutNet = 30 ∧ fondsMaladiesRares = 250 ∧
    imagerieNiveaux = [56, 112, 168, 224, 280] := by decide

/-- Panier de légumes bio à tarif préférentiel, acheté par l'État, avec
carte associée (O-204).

Principe : une plateforme publique passe des contrats pluriannuels avec
les maraîchers bio (prix garanti) et vend les légumes, par une carte, au
prix de détail du conventionnel ; l'État paie l'écart. Les caisses
alimentaires locales (Montpellier : 404 foyers, 100 € par mois, 82 % des
dépenses en bio, précarité alimentaire quantitative de 11 % à 5 %, chaire
Unesco, 2025 ; Gironde : 200 foyers, 150 € par mois) en sont le modèle ;
le chèque alimentaire national promis en 2020 n'a jamais été chiffré ni
mis en place (abandon, janvier 2024).

* Public : les ménages sous le seuil de pauvreté, 9 792 000 personnes en
  2023 (Insee, 15,4 %), 2,2 personnes par ménage (Insee) : ≈ 4,45 millions
  de ménages ; recours de 50 % (hypothèse ; l'aide alimentaire touche
  5,6 millions d'inscrits, Cour des comptes 2025).
* Quantité : 50,3 kg de légumes frais par ménage et par an (FranceAgriMer,
  fiche filière légumes 2026, panel Kantar 2024) : ≈ 112 000 t par an,
  ≈ 18 % de la production française de légumes bio (41 000 ha en 2024,
  Agence Bio ; 21,5 t/ha toutes cultures, FranceAgriMer, à 70 % en bio :
  hypothèse ≈ 615 000 t). Les 6 % de légumes bio déclassés en conventionnel
  faute de débouché (Interfel, 2025) couvrent d'emblée un tiers ; le reste
  par conversion (conversions en légumes frais +44 % en 2025, Agence Bio).
* Prix : fruits et légumes frais 2,88 €/kg en 2024 (Interfel, Kantar) ;
  le bio coûte 60 % de plus au détail (UFC-Que Choisir, mai 2026 : panier
  732 € contre 460 €), dont 38 % de l'écart revient aux producteurs et 57 %
  à la distribution. L'État achète au prix producteur bio et vend au prix
  de détail du conventionnel : la subvention par kilo est la prime
  producteur (0,38 × 60 % × 2,88 € ≈ 0,65 €) plus la logistique de la
  plateforme, 0,30 €/kg (hypothèse : ≈ 10 % du prix de détail ; aucune
  source publique ne chiffre la logistique de l'aide alimentaire) :
  ≈ 0,95 €/kg, ≈ 106 M€ par an, dont ≈ 73 M€ versés aux maraîchers
  (dépense dont l'emploi va à l'agriculture) et ≈ 34 M€ de logistique ;
  carte et gestion 2 € par carte et par an (hypothèse) : ≈ 4 M€.
* Calendrier : plateforme et contrats en 2027, cartes en 2028 (année 1).
  Les dépôts non réclamés de la consigne (O-205) abondent ce fonds à
  partir de 2029 et élargissent le panier (fruits, autres produits bio).
Non modélisés : l'effet sur la santé (le modèle n'a pas de lien entre
alimentation et mortalité), la baisse du recours à l'aide alimentaire
(−10 % à Montpellier). -/
def personnesPauvresMilliers : Int := 9792
def tailleMenageDixiemes : Int := 22
def menagesPauvresMilliers : Int := personnesPauvresMilliers * 10 / tailleMenageDixiemes
def recoursPanierPm : Int := 500
def legumesParMenageDixiemesKg : Int := 503
def panierBioTonnes : Int := menagesPauvresMilliers * recoursPanierPm / 1000 * legumesParMenageDixiemesKg / 10
def prixLegumesConventionnelCts : Int := 288
def surcoutBioDetailPm : Int := 600
def partProducteurSurcoutPm : Int := 380
def primeProducteurBioCts : Int := prixLegumesConventionnelCts * surcoutBioDetailPm / 1000 * partProducteurSurcoutPm / 1000
def logistiquePanierCts : Int := 30
def panierBioProducteursMeur : Int := panierBioTonnes * primeProducteurBioCts / 100000
def panierBioLogistiqueMeur : Int := panierBioTonnes * logistiquePanierCts / 100000
def cartesPanierMilliers : Int := menagesPauvresMilliers * recoursPanierPm / 1000
def gestionCartesMeur : Int := cartesPanierMilliers * 2 / 1000
def panierBioMeur : Int := panierBioProducteursMeur + panierBioLogistiqueMeur + gestionCartesMeur

/-- Retour de la consigne des bouteilles et canettes sur le modèle
portugais « Volta » (O-205).

* Le modèle : « Volta » est le système national de dépôt-remboursement du
  Portugal, opéré par SDR Portugal (association des producteurs de
  boissons et de la distribution, régulée par l'ERSAR) : dépôt uniforme de
  0,10 €, plastique et métal jusqu'à 3 l, verre exclu ; remboursement en
  bon d'achat ou en espèces, kiosques municipaux pour les petits commerces ;
  2 500 automates au lancement (10 avril 2026, obligatoire le 10 août 2026 ;
  licence du 31 mai 2024), ≈ 20 000 € par machine à la charge des
  enseignes ; 305 millions d'emballages rendus en cinq mois ; objectifs de
  retour 40 % (2026), 80 % (2027), 85 % (2028), 90 % (2029) ; dépôts non
  réclamés réinvestis dans le système ou partagés avec le Fonds
  environnemental.
* La France : taux de collecte des bouteilles en plastique 58 % (ADEME,
  2024) pour 77 % exigés en 2025 et 90 % en 2029 (directive plastiques à
  usage unique, PPWR) ; canettes 50 à 60 % recyclées. Gisement 16,6
  milliards de bouteilles et canettes par an (rapport Vernier, 2019 ;
  14 milliards de bouteilles selon le ministère, mai 2026) ; dépôt de 15 c€
  (Vernier ; 15 à 20 c€ selon l'ADEME 2023) ; 27 000 automates et 110 000
  points de reprise, coût brut 570 M€ par an, net ≈ 300 M€ (Vernier) ;
  surcoût de 181 à 229 M€ par an par rapport au bac jaune (ADEME 2023,
  Sénat) ; perte nette des collectivités ≈ 12 M€ par an (Vernier). Après
  l'abandon de 2023 et le plan plastique de mai 2026 (consigne obligatoire
  au 1er janvier 2029, puis repli sur une consigne volontaire en septembre
  2026), le programme la rend obligatoire au 1er janvier 2029, sur le
  modèle portugais (dépôt uniforme, espèces ou bon d'achat).
* Les gains : le remboursement est pris en espèces ou crédité sur la carte
  du panier bio (O-204) ; les dépôts non réclamés, au lieu de financer le
  système (Portugal, Irlande : 60 M€ en 2025), sont affectés par la loi au
  fonds du panier bio, qui élargit le panier d'autant ; le système est
  alors financé en entier par les producteurs (coût brut), répercuté dans
  les prix (non modélisé : 570 M€ sur 1 546 Md€ de consommation).
* Taux de retour (hypothèse, trajectoires de l'Irlande 66 % → 76 % en deux
  ans, de la Lettonie 62 % → 84 % en quatre ans, de la Roumanie 83 % la
  deuxième année) : 65 % en 2029, 75 %, 85 %, puis 90 % (objectif
  européen) : dépôts non réclamés 16,6 Md × 0,15 € × (1 − taux) = 871,
  622, 373 puis 249 M€ par an (ADEME : 161 à 252 M€ en régime de
  croisière).
* Dépenses publiques : compensation des collectivités 12 M€ par an,
  régulateur et contrôles 3 M€ par an (hypothèse : ERSAR portugaise).
Non modélisés : les emplois de la collecte (aucune source), le CO₂ évité
par le recyclage supplémentaire (résine PET largement importée : le gain
est surtout à l'étranger), l'investissement privé des enseignes (≈ 1 Md€
d'automates, ADEME ; 1,2 Md€ selon le Sénat). -/
def gisementConsigneMillions : Int := 16600
def depotConsigneCts : Int := 15
def tauxRetourConsignePm : List Int := [650, 750, 850, 900]
def depotsNonReclamesMeur : List Int :=
  tauxRetourConsignePm.map fun t => gisementConsigneMillions * depotConsigneCts * (1000 - t) / 100000
def compensationCollectivitesConsigne : Int := 12
def regulateurConsigne : Int := 3

theorem panier_consigne_valeurs :
    menagesPauvresMilliers = 4450 ∧ panierBioTonnes = 111917 ∧ primeProducteurBioCts = 65 ∧
    panierBioProducteursMeur = 72 ∧ panierBioLogistiqueMeur = 33 ∧ gestionCartesMeur = 4 ∧
    panierBioMeur = 109 ∧ depotsNonReclamesMeur = [871, 622, 373, 249] := by decide

/-- Trois liaisons ferroviaires à cadence de métro (O-206 à O-208).

Cadre commun : les services express régionaux métropolitains (SERM, loi du
27 décembre 2023) de Nice-Côte d'Azur, Aix-Marseille-Provence (labellisés
le 4 juillet 2024), Lyon et Saint-Étienne (été 2024) ont des dossiers de
statut déposés en 2025-2026 mais aucun programme d'investissement adopté ;
l'IGF-IGEDD (septembre 2025) chiffre les infrastructures des SERM
labellisés à plus de 20 Md€ (valeur 2023) sur vingt ans et le surcoût
d'exploitation ferroviaire des régions à 580 M€ par an en 2040 (rapport
d'information AN n° 3048, juillet 2026 ; GART : 100 à 200 M€ par an et
par SERM). Coûts de référence au kilomètre : Grand Paris Express ≈ 210 M€
(2020), métro E de Lyon 200 à 240 M€ (2025), traversée souterraine de
Marseille (LNPCA) ≈ 250 M€ gare comprise, accès français du Lyon-Turin
67 à 100 M€ (ligne nouvelle mixte). Coût d'exploitation : 17 € par
train-km en 2009 (Cour des comptes), 20 à 25 € aujourd'hui (hypothèse),
recettes 12 à 30 % (TER : 12 %, Cour des comptes 2019) : 25 % retenus
(hypothèse). CO₂ : 62 % des voyageurs gagnés viennent de la route (dossier
LNPCA, 2022), 0,13 kg CO₂e par voyageur-km en voiture (comparateur modal
SNCF 2024, Base Empreinte ADEME, hypothèse de 250 jours ouvrés).

**O-206 — Métro Nice – Monaco – Vintimille** : liaison souterraine
automatique ≈ 40 km (Nice-Ville – Monaco 18 km, Monaco – Vintimille
22 km : hypothèse), 225 M€ par km (milieu des références : 9 Md€ ; le
dossier monégasque d'octobre 2024, « 1,2 à 4 Md€ », 30 000 voyageurs par
jour, Nice – Monaco en 12 minutes, 6 à 8 ans de réalisation, a été jugé
« pas viable » par le ministre des transports le 21 novembre 2025).
Monaco finance 25 % (hypothèse : la Principauté paie déjà 30 % du parc de
rames de la ligne, 108 M€, et 8 M€ par an de desserte ; elle n'est pas au
protocole LNPCA). Études 2027-2029 (10 M€ par an, hypothèse), enquête publique et déclaration d'utilité publique
2030-2032 (5 M€ par an, hypothèse ; la LNPCA a mis six ans des études à
la DUP), travaux 2033-2040 (huit ans), mise en service 2041 : hors
horizon, donc ni exploitation ni CO₂ comptés avant 2035. Ce calendrier plutôt que des travaux dès 2030,
qui coûtaient une propriété de plus (règle de dette sous le moteur de
demande, 16 scénarios sur 36). La gare de
Monaco reçoit 9,4 millions de voyageurs (2025, ≈ 25 500 par jour) pour
60 000 frontaliers quotidiens ; capacité de pointe 12 000 voyageurs par
jour portée à 20 000 par l'ERTMS et les rames en 2028.

**O-207 — Lyon – Saint-Étienne, un train toutes les 15 minutes** : le
SERM stéphanois vise le quart d'heure en pointe (dossier de statut,
novembre 2025) ; Mobi'LYSE (État 400 M€ hors CPER : trains de trois
rames en 2029, 4 trains par heure vers Part-Dieu, atelier de
Châteaucreux, 19 rames Regio 2N) est acquis et reste dans le tendanciel.
Le programme ajoute la branche du SERM lyonnais vers Saint-Étienne
(quadruplement Saint-Fons – Givors, terminus) : 750 M€ (hypothèse, milieu
de 0,5 à 1 Md€ pris sur les 3 Md€ du SERM lyonnais, IGF-IGEDD), 2028-2032,
service au quart d'heure en 2033. Exploitation : 2 trains par heure et par
sens de plus pendant 18 h, 59 km, 365 jours : 1,55 million de train-km à
22,5 € (hypothèse) ≈ 35 M€ bruts, 25 M€ nets. Fréquentation 20 000
voyageurs par jour (ministre, novembre 2024), part du train 49 % des
navetteurs, 45 % des automobilistes prêts au report (Mobi'LYSE 2025) :
+10 000 voyageurs par jour (hypothèse), 62 % venus de la route :
≈ 12 kt de CO₂ évitées par an.

**O-208 — Aix – Marseille, un train toutes les 10 minutes** : la LNPCA
phases 1 et 2 (3 838 M€ 2020, 5,3 Md€ courants, lancée le 16 décembre
2025, 40 % État, 40 % collectivités, 20 % UE visés) donne le train toutes
les 10 minutes Aix – Marseille en 2035 ; elle est dans le tendanciel. Le
programme y ajoute le SERM d'Aix-Marseille-Provence (27 lignes de cars et
3 lignes ferroviaires, dossier transmis en octobre 2026) : 2,6 Md€ (seul
chiffre public, non officiel : hypothèse), 2028-2034, exploitation 100 M€
par an dès 2035 (borne basse du GART par SERM) ; +10 000 voyageurs par
jour reportés (hypothèse ; la LNPCA seule en gagne ≈ 20 000 tous axes),
62 % de la route, 37 km : ≈ 7 kt de CO₂ évitées par an. Aucun dossier ne
chiffre le CO₂ ni les décès évités par la pollution (l'Autorité
environnementale a demandé un bilan GES actualisé de la LNPCA). -/
def metroAzurKm : Int := 40
def coutMetroParKmMeur : Int := 225
def metroAzurMeur : Int := metroAzurKm * coutMetroParKmMeur
def partMonacoPm : Int := 250
def metroAzurFranceMeur : Int := metroAzurMeur * (1000 - partMonacoPm) / 1000
def anneesTravauxMetroAzur : Nat := 8
def metroAzurParAn : Int := metroAzurFranceMeur / anneesTravauxMetroAzur
def metroAzurNiveaux : List Int :=
  List.replicate 3 10 ++ List.replicate 3 5 ++ List.replicate anneesTravauxMetroAzur metroAzurParAn ++ [0]
def sermStEtienneMeur : Int := 750
def sermStEtienneNiveaux : List Int := List.replicate 5 (sermStEtienneMeur / 5) ++ [0]
def coutTrainKmDixiemes : Int := 225
def recettesTrainPm : Int := 250
def exploitationNetteMeur (trainsParHeureSens heures km : Int) : Int :=
  trainsParHeureSens * 2 * heures * km * 365 * coutTrainKmDixiemes / 10 / 1000000 * (1000 - recettesTrainPm) / 1000
def exploitationStEtienne : Int := exploitationNetteMeur 2 18 59
def partRoutePm : Int := 620
def gCo2ParVoyageurKm : Int := 130
def co2EviteKt (voyageursParJour km : Int) : Int :=
  voyageursParJour * partRoutePm / 1000 * 250 * km * gCo2ParVoyageurKm / 1000000000
def co2StEtienneKt : Int := co2EviteKt 10000 59
def sermAixMarseilleMeur : Int := 2600
def sermAixMarseilleNiveaux : List Int := List.replicate 7 (sermAixMarseilleMeur / 7) ++ [0]
def exploitationAixMarseille : Int := 100
def co2AixMarseilleKt : Int := co2EviteKt 10000 37

theorem metros_valeurs :
    metroAzurMeur = 9000 ∧ metroAzurFranceMeur = 6750 ∧ metroAzurParAn = 843 ∧
    exploitationStEtienne = 25 ∧ co2StEtienneKt = 11 ∧ co2AixMarseilleKt = 7 ∧
    sermStEtienneNiveaux = [150, 150, 150, 150, 150, 0] ∧
    sermAixMarseilleNiveaux = [371, 371, 371, 371, 371, 371, 371, 0] := by decide

/-- Encouragement fiscal au rachat de trimestres (O-209). Aujourd'hui (régime général) : rachat des années
d'études supérieures et des années incomplètes, 12 trimestres au plus,
barème actuariellement neutre (circulaire Cnav 2026-04 ; COR, juillet
2014), tarif réduit pour les études jusqu'à la fin de l'année des 40 ans
(loi du 14 avril 2023), montant déductible du revenu imposable (CGI,
art. 83). 6 629 rachats en 2022, 26 391 € en moyenne pour ≈ 6 trimestres,
racheteurs âgés de 53,8 ans en moyenne, 79 % d'hommes (COR, séance du
25 mai 2023 ; Cnav) : ≈ 175 M€ par an versés aux régimes (calcul).

La mesure : crédit d'impôt de 20 % du rachat, en plus de la déduction,
plafonné à 1 000 € par trimestre (le montant de l'aide aux étudiants
annoncée en 2013). Hypothèses : les rachats doublent (+6 629 par an) ; taux
marginal moyen des racheteurs 35 % (milieu de 30 à 41 %). Effets : +175 M€
versés aux régimes (recette sans effet de demande : épargne des
racheteurs) ; déduction des rachats supplémentaires 61 M€ et crédit sur
tous les rachats 70 M€ ; départs avancés : 6 629 racheteurs de plus sur
≈ 800 000 départs par an (8 ‰) partent 18 mois plus tôt (6 trimestres),
dans un programme sans âge légal (O-07). Les pensions supplémentaires
sont couvertes par les rachats sur la durée de la retraite (barème neutre),
pas année par année. -/
def rachatsSupplementaires : Int := 6629
def rachatMoyenEuros : Int := 26391
def recetteRachats : Int := rachatsSupplementaires * rachatMoyenEuros / 1000000
def tauxMarginalRacheteursPm : Int := 350
def deductionRachats : Int := recetteRachats * tauxMarginalRacheteursPm / 1000
def creditRachatPm : Int := 200
def creditRachats : Int := 2 * rachatsSupplementaires * rachatMoyenEuros / 1000000 * creditRachatPm / 1000
def partDepartsRachatPm : Int := rachatsSupplementaires * 1000 / 800000

/-- Liberté de capitalisation, plafonnée à 2,5 % des cotisations retraite
(O-210) : plafond de 5 % dans la version initiale, ramené à 2,5 % le 5 novembre 2026 (comme la Suède). Chaque actif peut orienter
jusqu'à 2,5 % de ses cotisations
vieillesse vers un compte individuel en capitalisation, géré par un fonds
public par défaut (sur le modèle du fonds AP7 Såfa de la pension premium
suédoise : 2,5 points des 18,5 % de cotisation, 5,8 millions d'épargnants ;
rendement annuel moyen de 8,4 % depuis 2000, AP7 2025) ; ses droits par
répartition baissent d'autant.

* Assiette : 277 Md€ de cotisations sur les revenus d'activité en 2025
  (COR, rapport 2026) : 2,5 % = 6,9 Md€ si tous choisissaient l'option
  (5 % = 13,9 Md€ dans la version précédente).
* Adhésion volontaire (opt-in) : 16 % des nouveaux entrants suédois
  faisaient un choix actif au début des années 2000, 1 à 2 % ensuite ;
  hypothèse : 10 % de l'assiette en 2028, 15 % en 2029, 20 % ensuite
  (cadres et hauts revenus, qui portent une grande part des cotisations).
* Effet : recettes des régimes en moins (0,7 puis 1,0 puis 1,4 Md€ par an ;
  le double avec le plafond de 5 %),
  sans effet de demande (épargne bloquée) ; les pensions ne baissent qu'au
  départ des épargnants, surtout après 2035 (non modélisé, prudent). Coût
  de transition comparable, à cette échelle, à ceux étudiés par le COR
  (Weil, 2025 : ≈ 20 Md€ par an pour une capitalisation de 10 à 15 % des
  pensions). -/
def cotisationsRetraite : Int := 277000
def plafondCapitalisationPm : Int := 25
def adhesionCapitalisationPm : List Int := [100, 150, 200]
def capitalisationNiveaux : List Int :=
  adhesionCapitalisationPm.map fun a => 0 - cotisationsRetraite * plafondCapitalisationPm / 1000 * a / 1000

/-- Huit EPR2 de plus (O-211). La PPE3 (décret
n° 2026-76 du 12 février 2026, action NUC.4) prévoit l'étude d'au moins
13 GW, soit huit EPR2, avec un chantier lancé au plus tard en 2030
(réponse ministérielle n° 10064, JO du 7 juillet 2026). Coût : 72,8 Md€
(euros 2020) pour les six premiers (devis EDF du 18 décembre 2025), soit
12,1 Md€ par réacteur ; effet de série de 10 % (hypothèse, entre 5 %,
Roland Berger 2020, et 19 %, EDF) : ≈ 87 Md€ pour huit. Financement comme
O-04 : prêt de l'État de la moitié du coût (60 % annoncés au Conseil de
politique nucléaire du 12 mars 2026 : variante), versé de 2030 à 2044 ;
mise en service à partir de 2040-2045, hors horizon. -/
def coutEPR2Unitaire : Int := 72800 / 6
def coutHuitEPR2 : Int := 8 * coutEPR2Unitaire * 90 / 100
def pretHuitEPR2 : Int := coutHuitEPR2 / 2 / 15

/-- Rénovation des logements des militaires (O-212). Parc familial de 28 462 logements en 2026, dont 8 876
domaniaux et 18 871 réservés chez des bailleurs (rapport AN n° 3063,
juillet 2026) ; parc « âgé, dégradé, énergivore », ≈ 60 ans d'âge moyen ;
57 % des demandes satisfaites (HCECM, 2025). Le contrat Ambition Logement
(Nové, 35 ans, ≈ 2,8 Md€ de subventions) vise 7 544 rénovations d'ici fin
2029 ; 1 900 sont faites au 1er juin 2026, au rythme de ≈ 900 par an
(QE n° 15181, juillet 2026).

La mesure, de 2027 à 2031 : (1) l'État finance 600 rénovations de plus par
an pour achever tout le parc domanial d'ici fin 2031 ; (2) il prend en
charge 30 % de la rénovation énergétique des logements réservés chez les
bailleurs, un dixième par an. Coût d'une rénovation : 57 000 € (logement
social, 2023, Banque des Territoires) : 34 + 32 M€ par an. -/
def renovationsDomaniales : Int := 600
def coutRenovationLogementEuros : Int := 57000
def logementsReserves : Int := 18871
def partEtatReservesPm : Int := 300
def renovationLogementsMilitaires : Int :=
  renovationsDomaniales * coutRenovationLogementEuros / 1000000
  + logementsReserves / 10 * coutRenovationLogementEuros / 1000000 * partEtatReservesPm / 1000

/-- Fin de la rusticité des installations militaires (O-213). 1 433 bâtiments d'hébergement : 23 % en mauvais état, 2 % en
très mauvais état (rapport AN n° 3063, 2026), ≈ 51 300 lits permanents ou
de passage ; chambres sans électricité, douches fermées, locaux insalubres
(HCECM, « Perspectives 2035 » ; Sénat, avis n° 141, 2025) ; dette grise de
4,4 Md€ (Cour des comptes, juin 2023) ; entretien courant ≈ 450 M€ par an
pour 600 M€ nécessaires (rapport Matteï, PLF 2026). Le plan Hébergement en
cours apporte ≈ 180 M€ par an.

La mesure : (1) remise aux normes des lits des bâtiments en mauvais ou très
mauvais état, 25 % des ≈ 51 300 lits, soit 12 800, à 60 000 € le lit
(plans Hébergement 2024-2025 : 56 000 à 60 000 €), de 2027 à 2031 ;
(2) entretien courant porté au besoin (+150 M€ par an). -/
def litsVetustes : Int := 51300 * 25 / 100
def coutLitEuros : Int := 60000
def renovationLitsParAn : Int := litsVetustes * coutLitEuros / 1000000 / 5
def entretienCasernements : Int := 600 - 450

/-- Crédit d'impôt normalisation (O-214).
Aujourd'hui, les réunions officielles de normalisation (AFNOR, CEN,
CENELEC, ETSI, ISO, CEI) entrent dans le crédit d'impôt recherche pour la
moitié des salaires des participants, majorés de 30 % (CGI, art. 244 quater
B, II, g ; BOFiP du 13 août 2025) : ≈ 19,5 % du coût salarial des seules
réunions (calcul), préparation exclue. Normalisation et veille pèsent
≈ 0,4 point de l'assiette du CIR (≈ 30 M€ de créance, MESR 2023) ; la
normalisation seule ≈ 15 M€ (hypothèse, la veille étant sortie du CIR en
2025). La subvention de l'État à l'AFNOR (7,9 M€ en 2024) a été supprimée
en 2025 ; 90 % des normes nouvelles sont européennes ou internationales ;
la France est deuxième au CEN et au CENELEC derrière l'Allemagne.

La mesure : la normalisation sort du CIR et reçoit son propre crédit
d'impôt, 50 % des dépenses de participation (salaires, préparation, frais,
cotisations), plafonné à 45 000 € par entreprise et par an (comme l'aide
allemande WIPANO, 70 % plafonnés à 45 000 €). Base actuelle : 15 M€ de
créance = 19,5 % de ≈ 77 M€ de salaires en réunion ; préparation égale au
temps de réunion (hypothèse) et participation en hausse de 20 %
(hypothèse) : ≈ 117 M€ de crédit, 102 M€ nets du CIR économisé. -/
def creanceNormalisationCir : Int := 15
def salairesReunionsNormalisation : Int := creanceNormalisationCir * 1000 / 195
def creditNormalisation : Int := salairesReunionsNormalisation * 13 / 10 * 2 * 120 / 100 / 2
def creditNormalisationNet : Int := creditNormalisation - creanceNormalisationCir

theorem nouvelles_mesures_valeurs :
    recetteRachats = 174 ∧ deductionRachats = 60 ∧ creditRachats = 69 ∧ partDepartsRachatPm = 8 ∧
    capitalisationNiveaux = [-692, -1038, -1385] ∧ coutHuitEPR2 = 87357 ∧ pretHuitEPR2 = 2911 ∧
    renovationLogementsMilitaires = 66 ∧ litsVetustes = 12825 ∧ renovationLitsParAn = 153 ∧
    creditNormalisation = 117 ∧ creditNormalisationNet = 102 := by decide

/-- Gestes d'isolation dans les territoires ruraux (O-63, précision de
novembre 2026 : « préciser que ça inclut les fenêtres… (comme O-90
existe) »). Depuis le 1er janvier 2026, l'isolation des murs, et depuis le
1er septembre 2026 (décret n° 2026-822) les fenêtres, l'isolation des
combles, des toitures et des planchers et la ventilation sortent de l'aide
par geste de MaPrimeRénov' : elles ne sont plus aidées que dans une
rénovation d'ampleur. En 2024, sur 296 000 travaux aidés par geste : 6,2 %
de fenêtres, 10,2 % d'isolation des murs, 2,8 % de combles et toitures
(SDES) : ≈ 56 900 gestes d'isolation (calcul), dont 48 % en commune rurale
(Anah, 2021) : ≈ 27 300 par an. Aide moyenne par geste ≈ 3 030 € (fenêtres
≈ 450 € pour six fenêtres à 40 à 100 €, murs ≈ 5 000 € pour 100 m² à 40 à
75 €/m², combles ≈ 1 600 € pour 80 m² : hypothèses sur les surfaces),
majorée de 25 % : 3 790 € ; économie ≈ 2 220 kWh par geste (pondération
de 800 kWh pour les fenêtres, 3 000 pour les murs, 2 500 pour les
combles : hypothèses). Le chauffage (pompes à chaleur) relève d'O-90. -/
def gestesIsolationRuraux : Int := 296000 * (62 + 102 + 28) / 1000 * 48 / 100
def aideGesteIsolationEuros : Int := 3030 * 125 / 100
def economieGesteKWh : Int := 2220

/-- TVA à 6 % sur des produits de base (O-215). Le droit européen
limite les taux réduits aux catégories de l'annexe III de la directive TVA
(modifiée par la directive (UE) 2022/542) : parmi les produits de base
encore à 20 % en France, seuls les produits d'hygiène absorbants (couches
pour bébé, protections pour l'incontinence ; point 3) et les vêtements et
chaussures pour enfants (point 24) peuvent passer au taux réduit ; savon,
dentifrice, papier toilette, lessives et fournitures scolaires ne le
peuvent pas sans modifier la directive à l'unanimité. Un taux réservé aux
produits fabriqués en France est interdit (TFUE, art. 110) : le « made in
France » se privilégie par le choix des catégories (habillement pour
enfants, où la filière textile française peut produire) et par la commande
publique, pas par le taux. Couches : moins de 10 % du marché fabriqué en
France (Xerfi, 2024).

Consommation (hypothèses, le détail Insee n'étant pas publié à ce niveau) :
couches pour bébé ≈ 1,0 Md€ TTC, protections pour l'incontinence
≈ 0,8 Md€, vêtements et chaussures pour enfants ≈ 13 % des 43,6 Md€
d'habillement et de chaussures (Insee Première n° 2110, 2025 ; les moins de
15 ans font 17 % de la population, dépense par tête plus faible) :
≈ 5,7 Md€. Passer de 23 % (taux normal du programme, O-29) à 6 % retire
0,23/1,23 − 0,06/1,06 ≈ 13 % du prix TTC (calcul) : ≈ 0,98 Md€ par an, à
répercussion pleine (le CPO, 2023, la juge partielle). -/
def consoCouches : Int := 1000
def consoIncontinence : Int := 800
def consoVetementsEnfants : Int := 43600 * 13 / 100
def ecartTauxBasiquesPm : Int := 23 * 1000 / 123 - 6 * 1000 / 106
def perteTvaBasiques : Int := (consoCouches + consoIncontinence + consoVetementsEnfants) * ecartTauxBasiquesPm / 1000

/-- Accès en train aux zones touristiques (O-216). (1) Desserte de
nuit sécurisée des six zones d'O-12, comme le TER 24 h sur 24 d'O-34 : six
liaisons de 120 km (hypothèse), un train par heure et par sens de 0 h à
5 h, agents à bord, en gare et aux parkings, aux coûts d'O-34 (23,40 € par
train-km, 46 heures d'agents par nuit à 35 €, 25 % couverts par les
recettes). Repères : ligne Montréjeau – Luchon rouverte le 22 juin 2025
(67 M€, six allers-retours par jour) ; ligne Nîmes – Le Grau-du-Roi
modernisée en 2024 (10,8 M€) ; trains de nuit Paris – Latour-de-Carol et
Paris – Lourdes. (2) Tarif touristique TGV + TER vers ces zones : 30 % de
réduction sur un billet moyen de 50 € pour 2 millions de trajets par an
(hypothèses), compensés aux transporteurs ; repères : offre Skirail de
Toulouse (train, navette et forfait de 39,50 à 49 €), train liO à 1 € pour
les moins de 27 ans (826 000 billets en 2024). -/
def liaisonsTouristiquesNuit : Int := 6
def distanceTouristiqueKm : Int := 120
def coutDessertesNuitTourisme : Int :=
  liaisonsTouristiquesNuit * 365 * (trainsParNuit * distanceTouristiqueKm * coutTrainKmCentimes / 100
    + heuresAgentsParNuit * coutHeureAgent) * (1000 - couvertureRecettesPm) / 1000000000
def trajetsTouristiquesMilliers : Int := 2000
def reductionTarifTouristiqueEuros : Int := 50 * 30 / 100
def tarifTouristique : Int := trajetsTouristiquesMilliers * reductionTarifTouristiqueEuros / 1000

theorem retours_novembre_valeurs :
    gestesIsolationRuraux = 27279 ∧ aideGesteIsolationEuros = 3787 ∧ cessionsBureaux = 675 ∧
    logementsSociauxBureaux = 2160 ∧ ecartTauxBasiquesPm = 130 ∧ perteTvaBasiques = 970 ∧
    coutDessertesNuitTourisme = 48 ∧ tarifTouristique = 30 := by decide

/-- Consultations citoyennes électroniques (O-217) et plateforme publique
de vote électronique (O-218).

Repères : vote par Internet des Français de l'étranger, 1,39 M€ prévus en
2022 (PLF 2022) pour ≈ 524 000 votes sur deux tours, ≈ 2,65 € par vote
(calcul) ; 416 601 puis 459 539 votants en ligne en 2024 (73 à 78 % des
votants) ; incidents de 2022 (SMS non reçus, trois élections annulées) et
de 2024 (surcharges), suivis par l'ANSSI ; Estonie : 2,32 € par vote
électronique contre 4,37 € en bureau (2017). Recommandation de la CNIL
n° 2026-045 du 19 mars 2026 : au niveau de risque 3, expertise
indépendante à chaque scrutin et code source du client publié. 45 millions
d'usagers de FranceConnect (2026). Plateforme du Grand débat : 1,1 M€.

* O-217 : deux consultations nationales par an au plus, consultatives,
  sur des sujets non législatifs, avec identification par FranceConnect ;
  plateforme publique développée en 2027 (5 M€, hypothèse : trois à quatre
  fois la plateforme du Grand débat, pour le niveau 3 de la CNIL et le
  code publié), puis 1,5 M€ par consultation (expertise indépendante,
  hébergement, assistance, hypothèse) et un test public d'intrusion par an
  (1 M€ : 38 000 CHF de primes en Suisse en 2026, plus son organisation,
  hypothèse) : 4 M€ par an.
* O-218 : la même plateforme ouverte aux partis, syndicats et
  collectivités, au prix coûtant de 1 € par électeur (marché de
  l'Éducation nationale 2026-2027 : ≈ 1,3 € HT par électeur, calcul ;
  marché de 49 à 1 490 € par scrutin, Archimag 2025) ; exploitation
  3 M€ par an (hypothèse), couverte à moitié par les redevances
  (hypothèse) : 1,5 M€ net par an, après 2 M€ d'adaptation en 2027. -/
def consultationsNiveaux : List Int := [5, 2 * 15 / 10 + 1]
def plateformeVoteNiveaux : List Int := [2, 3 * 500 / 1000]

/-- Sport pour tous (O-219 à O-221). Financées sur l'enveloppe d'O-193 (sport porté à
1 % du budget de l'État), qui baisse d'autant : pas de dépense en plus.

* O-219 : chèque sport de 50 € pour tous les 6-17 ans, en plus du
  Pass'Sport des familles modestes (50 € pour les 6-17 ans dont le
  quotient familial est au plus de 699 €, rentrée 2026). 9,3 à 9,7
  millions de 6-17 ans (Insee 2026, calcul) : 9,5 millions ; recours de
  40 % (hypothèse : 16 à 27 % pour le Pass'Sport ciblé, un chèque
  universel est plus simple) : 190 M€ par an. Pas d'évaluation causale de
  l'effet sur les licences (INJEP, attendue en 2026).
* O-220 : petits clubs : 63 % des clubs ont un budget de moins de
  10 000 € (CNOSF) ; 162 187 associations dans les réseaux du CNOSF.
  Caméras automatiques de captation et de diffusion, une pour dix petits
  clubs, prêtées par les districts et ligues comme en Dordogne (10 200
  caméras à 1 300 €, puis 800 € d'abonnement par an : Veo, calcul) et aide
  à la modernisation (numérique, gestion) de 1 000 € par an pour 20 000
  clubs (hypothèse ; aide moyenne du PSF à un club de football : 2 520 €) :
  13 M€ la première année, puis 28 M€ par an.
* O-221 : cybersécurité des fédérations : fuites de données de 2024 à 2026
  à la FFF, à la FFT, à la FFBB (près de 2 millions de licenciés), au
  handball, au rugby, au tir… et chez un prestataire commun à 40 à 45
  fédérations ; 119 fédérations agréées et 22 groupements nationaux
  (INJEP, ministère). Parcours de sécurisation sur le modèle des parcours
  cyber de l'ANSSI (100 M€ pour 945 entités, ≈ 106 000 € par entité) pour
  les 141, en 2027 et 2028 (7,5 M€ par an), puis maintien à 20 % du coût
  par an (hypothèse) : 3 M€ par an, avec la sécurisation mutualisée des
  prestataires communs. -/
def chequeSportEuros : Int := 50
def jeunes6a17Milliers : Int := 9500
def recoursChequeSportPm : Int := 400
def chequeSport : Int := jeunes6a17Milliers * recoursChequeSportPm / 1000 * chequeSportEuros / 1000
def camerasClubs : Int := 10200
def petitsClubs : List Int := [camerasClubs * 1300 / 1000000, camerasClubs * 800 / 1000000 + 20000 * 1000 / 1000000]
def federationsSportives : Int := 119 + 22
def cyberFederations : List Int := [federationsSportives * 106 / 1000 / 2, federationsSportives * 106 / 1000 / 2, (federationsSportives * 106 / 5 + 500) / 1000]
def sportAffecte : Int := chequeSport + 28 + 3
def sportEcheancierReste : List Int := sportEcheancier.map (· - sportAffecte)

theorem vote_sport_valeurs :
    consultationsNiveaux = [5, 4] ∧ plateformeVoteNiveaux = [2, 1] ∧ chequeSport = 190 ∧
    petitsClubs = [13, 28] ∧ cyberFederations = [7, 7, 3] ∧ sportAffecte = 221 := by decide

def mesuresNonClassees : List Mesure := [
  { id := "O-01"
    titre := "Remplacement gratuit par l'État de 10 000 voitures parmi les plus polluantes chaque année"
    source := s!"Texte Orientation D, mesure 1 ; 10 000 voitures Crit'Air 5 ou non classées par an pendant {vaguesRemplacement} ans ; prix unitaire et part importée : hypothèses (voir Programme.lean)"
    leviers := [.remplacementVehicules remplacement]
    repetitions := vaguesRemplacement
    variantes := [
      { nom := "véhicules fabriqués en France"
        leviers := [.remplacementVehicules remplacementFabriqueEnFrance] }]
    contrats := [
      { titre := "Le déficit commercial induit se résorbe d'année en année dès que le carburant évité vaut plus que l'électricité consommée"
        enonce := ∀ (h : HypAuto) (m n : Nat), 0 ≤ remplacement.gainAnnuelCts h → m ≤ n →
          remplacement.soldeCumuleCts h m ≤ remplacement.soldeCumuleCts h n
        preuve := fun h _ _ hg hmn => Remplacement.soldeCumule_mono h remplacement hg hmn },
      { titre := "L'année d'équilibre commercial annoncée est exacte : solde positif cette année-là, négatif l'année précédente"
        enonce := ∀ (h : HypAuto) (n : Nat), remplacement.anneeEquilibre h = some n →
          0 ≤ remplacement.soldeCumuleCts h n ∧ (0 < n → remplacement.soldeCumuleCts h (n - 1) < 0)
        preuve := fun h _ hn => Remplacement.anneeEquilibre_correcte h remplacement hn }] },

  { id := "O-02"
    titre := "Amendes SRU proportionnelles à la part de logements sociaux manquants"
    source := "Texte Orientation D, mesure 2 ; remplace la majoration préfectorale discrétionnaire (CCH L.302-9-1)"
    leviers := [.amendeSRU baremeSRU]
    variantes := [
      { nom := "plafond actuel (5 %)", leviers := [.amendeSRU baremeSRUPlafondActuel] },
      { nom := "modérée (×1 à ×3, plafond 5 %)", leviers := [.amendeSRU baremeSRUModere] },
      { nom := "sévère (×1 à ×10, plafond 15 %)", leviers := [.amendeSRU baremeSRUSevere] }]
    contrats := [
      { titre := "Nulle pour toute commune qui atteint son objectif"
        enonce := ∀ c : Commune, c.Valide → c.objectif ≤ c.logementsSociaux →
          baremeSRU.amende c = 0
        preuve := fun _ hc h => BaremeSRU.amende_nulle_si_conforme baremeSRU_valide hc h },
      { titre := "Ne dépasse jamais 10 % des dépenses réelles de fonctionnement"
        enonce := ∀ c : Commune, c.Valide → baremeSRU.amende c ≤ c.plafond 1000
        preuve := fun _ hc => BaremeSRU.amende_plafonnee baremeSRU_valide hc },
      { titre := "Construire des logements sociaux ne fait jamais payer plus"
        enonce := ∀ c : Commune, c.Valide → ∀ k, 0 ≤ k →
          baremeSRU.amende { c with logementsSociaux := c.logementsSociaux + k } ≤
            baremeSRU.amende c
        preuve := fun _ hc _ hk =>
          BaremeSRU.amende_decroit_avec_logements_sociaux baremeSRU_valide hc hk },
      { titre := "Jamais moins que le prélèvement de base actuel"
        enonce := ∀ c : Commune, c.Valide → SRU.prelevementActuel c ≤ baremeSRU.amende c
        preuve := fun _ hc => BaremeSRU.amende_ge_prelevement_actuel baremeSRU_valide hc
          (by decide) (by decide) (by decide) }] },

  { id := "O-03"
    titre := "Attributions de logements sociaux vérifiables par preuve à divulgation nulle de connaissance"
    source := "Texte Orientation D, mesure 3 ; chiffrage provisoire (hypothèses) : 20 M€ de développement, 5 M€/an d'exploitation ; effet sur l'immobilier non modélisé"
    leviers := [.depensePonctuelle 20, .depenseSur .logementEnvironnement 5]
    contrats := [
      { titre := "Dès qu'un candidat est éligible, la règle publiée désigne un attributaire"
        enonce := ∀ cs : List Candidat, (∃ c ∈ cs, c.eligible = true) → ∃ a, choisir cs = some a
        preuve := fun _ h => choisir_complet h },
      { titre := "L'attributaire désigné est éligible et aucun éligible ne passe devant lui"
        enonce := ∀ (cs : List Candidat) (a : Candidat), choisir cs = some a → Conforme cs a
        preuve := fun _ _ h => choisir_conforme h },
      { titre := "Pour une liste donnée, un seul attributaire est conforme : aucune marge d'appréciation"
        enonce := ∀ (cs : List Candidat) (a b : Candidat), (cs.map (·.id)).Nodup →
          Conforme cs a → Conforme cs b → a = b
        preuve := fun _ _ _ hnd ha hb => conforme_unique hnd ha hb },
      { titre := "Deux preuves ZK acceptées pour le même engagement désignent la même personne"
        enonce := ∀ (R : Type) (engager : List Candidat → R), (∀ x y, engager x = engager y → x = y) →
          ∀ (r : R) (i j : Nat), EnonceZK engager r i → EnonceZK engager r j → i = j
        preuve := fun _ _ hlie _ _ _ hi hj => zk_sans_discretion hlie hi hj },
      { titre := "La commission peut toujours produire la preuve pour l'attributaire légitime"
        enonce := ∀ (R : Type) (engager : List Candidat → R) (cs : List Candidat) (a : Candidat),
          (cs.map (·.id)).Nodup → choisir cs = some a → EnonceZK engager (engager cs) a.id
        preuve := fun _ engager _ _ hnd h => zk_complet engager hnd h }] },

  { id := "O-04"
    titre := "Construction de six EPR2, au niveau du programme gouvernemental"
    source := "Texte Orientation D, mesure 4 ; programme gouvernemental : devis EDF du 18 décembre 2025 (72,8 Md€₂₀₂₀ pour 6 EPR2), accord État-EDF du 19 juin 2025 (prêt de l'État ≥ 50 %, CfD 100 €/MWh), première mise en service 2038. Effets hors horizon : production, CfD, remboursements"
    leviers := [.pretEtat pretEPR2]
    debut := 0  -- décision finale d'investissement fin 2026, premiers décaissements 2027
    variantes := [
      { nom := "prêt de l'État couvrant la totalité du coût", leviers := [.pretEtat pretEPR2Total] }] },

  { id := "O-05"
    titre := "Prime de 4 000 € à l'achat d'une voiture électrique, 300 000 ménages par an"
    source := "Texte Orientation D, mesure 5 ; montant et nombre : hypothèses (bonus écologique 2025 : 2 000 à 4 000 € selon le revenu, ≈ 300 000 électriques neuves par an) ; 1,2 Md€/an"
    leviers := [.aideAchatElectrique 300000 4000]
    variantes := [
      { nom := "prime de 6 000 €, 400 000 ménages (2,4 Md€/an)", leviers := [.aideAchatElectrique 400000 6000] }] },

  { id := "O-06"
    titre := "50 000 points de recharge publics supplémentaires par an"
    source := "Texte Orientation D, mesure 6 ; coût moyen 8 000 € par point, accélérée et normale confondues (hypothèse, programme Advenir) ; 0,4 Md€/an"
    leviers := [.deploiementBornes 50000 8000] },

  { id := "O-07"
    titre := "Fin de l'âge légal : départ à la durée cotisée (172 trimestres, 174 avec O-44), réduite selon la pénibilité"
    source := "Texte Orientation D, mesure 7. Conversion : le modèle ne connaît qu'un âge moyen de départ ; sans borne d'âge, les carrières commencées avant 21 ans partent avant l'âge légal et la réduction pour pénibilité avance encore les métiers exposés : âge moyen de départ supposé plafonné à 63 ans et 6 mois, 6 mois sous les 64 ans du calendrier légal (hypothèse à étayer avec le COR) : le calendrier est suivi jusqu'à 63 ans et 6 mois (2031), puis s'arrête ; coût et actifs selon l'hypothèse économique du scénario"
    leviers := [.ageLegalCible 762 0]
    variantes := [
      { nom := "âge moyen avancé de 12 mois (pénibilité large)", leviers := [.ageLegalCible 756 0] },
      { nom := "écart de 6 mois au calendrier légal dès 2027", leviers := [.ageLegal (-6)] }] },

  { id := "O-07b"
    titre := "Âge moyen de départ relevé de trois mois en 2032"
    source := "Texte Orientation D, mesure 7, seconde étape (novembre 2026) : l'âge moyen de départ plafonné par O-07 à 63 ans et 6 mois est relevé de 3 mois en 2032, à 63 ans et 9 mois, toujours sous les 64 ans du calendrier légal ; actifs supplémentaires, emploi et pensions économisées par le modèle commun (voir `reculDepart`)"
    leviers := [.ageLegal 3]
    debut := 5 },

  { id := "O-08"
    titre := "Impôt sur les sociétés à 21 % (amendé : 15 % dans le texte)"
    source := s!"Texte Orientation D, mesure 8, amendée en octobre 2026 : {tauxISCible / 100} % au lieu de 15 %, le taux minimal de la directive (UE) 2022/2523 (pilier 2), pour rapprocher le déficit de 2 % en 2035 (voir `tauxISCible`) ; réponse de l'assiette appliquée par le modèle commun (axe économique)"
    leviers := [.impotSocietes tauxISCible]
    variantes := [
      { nom := "20 % (version précédente)", leviers := [.impotSocietes 2000] },
      { nom := "15 % (texte initial, taux minimal du pilier 2)", leviers := [.impotSocietes 1500] },
      { nom := "12 % (trois points au-dessus du taux hongrois de 9 %, version précédente)", leviers := [.impotSocietes 1200] },
      { nom := "17 % (minimum de 15 % du pilier 2 + 2 points)", leviers := [.impotSocietes 1700] },
      { nom := "IS maintenu à 25 % (abandon de la baisse, piste vers l'équilibre)", leviers := [] }] },

  { id := "O-09"
    titre := "La démission ouvre des droits au chômage : six mois d'indemnités, une fois tous les cinq ans"
    source := s!"Texte Orientation D, mesure 9 ; chiffrage : hypothèse de recours de 20 % sur 1,9 million de démissions de CDI, 1 300 €/mois × 6 : {coutDemission} M€/an"
    leviers := [.depenseSur .famille coutDemission]
    variantes := [
      { nom := "recours de 40 % (6 Md€/an)", leviers := [.depenseSur .famille 6000] }] },

  { id := "O-10"
    titre := "Moyens pour la justice : réduction des délais, prud'hommes en priorité"
    source := s!"Texte Orientation D, mesure 10 ; {postesJusticeO10.getLast?.getD 0} postes : greffes des prud'hommes et juges départiteurs ({equipesPrudhommes.getLast?.getD 0} équipes), magistrats du siège civil et leurs greffes ({magistratsCivil.getLast?.getD 0}), à {Hypotheses.Justice.coutEtptEuros} € l'ETPT (RAP 2025), locaux à {Hypotheses.Justice.coutLocauxPosteEuros} € par poste ; facteurs de traitement aux cibles 2027 du PAP ; délai d'écoulement du stock des prud'hommes : {virguleDixiemes ((delaisPrudhommes true).headD 0)} mois en 2026, {virguleDixiemes ((delaisPrudhommes true).getLast?.getD 0)} en 2035 ({virguleDixiemes ((delaisPrudhommes false).getLast?.getD 0)} sans mesure) ; matière civile : {virguleDixiemes ((delaisCivil true).headD 0)} puis {virguleDixiemes ((delaisCivil true).getLast?.getD 0)} mois (voir `anneesJustice`)"
    leviers := leviersJustice postesJusticeO10
    variantes := [
      { nom := "300 M€ par an (version précédente, sans modèle des délais)",
        leviers := [.depenseSur .securiteJustice 300] }] },

  { id := "O-11"
    titre := "Financement des lignes nouvelles Lyon-Turin, Bordeaux-Toulouse et Montpellier-Perpignan"
    source := s!"Texte Orientation D, mesure 11 ; ≈ 30 Md€ sur dix ans dont 80 % d'argent public français : {lignesNouvelles} M€/an (hypothèses, voir `lignesNouvelles`) ; emprise {surfaceLignesNouvellesHa} ha/an pendant dix ans (voir `surfaceLignesNouvellesHa`)"
    leviers := [.depenseSur .affairesEconomiques lignesNouvelles,
                .artificialisation .infrastructures (List.replicate 10 surfaceLignesNouvellesHa)] },

  { id := "O-12"
    titre := "Qualité d'accueil des touristes : six zones de rénovation de qualité, dont Le Grau-du-Roi et les Pyrénées"
    source := s!"Texte Orientation D, mesure 12 ; {zonesTouristiques} zones × {coutParZone} M€/an (hypothèse) ; effet +2 % de visiteurs et +3 % de dépense par touriste (hypothèse, voir `zonesTouristiques`) ; base 2024 : 100 M de visiteurs, 71 Md€ (Atout France, Banque de France)"
    leviers := [.accueilTouristique zonesTouristiques coutParZone 20 30]
    variantes := [
      { nom := "effet faible : +1 % de visiteurs, +1 % de dépense", leviers := [.accueilTouristique zonesTouristiques coutParZone 10 10] },
      { nom := "effet fort : +4 % de visiteurs, +5 % de dépense", leviers := [.accueilTouristique zonesTouristiques coutParZone 40 50] }] },

  { id := "O-13"
    titre := "Autorisation de la conduite autonome (FSD) ; indemnisation des chauffeurs de taxi titulaires d'une licence jusqu'à leur retraite"
    source := s!"Texte Orientation D, mesure 13 ; {titulairesTaxi} titulaires (hypothèse sur 62 800 ADS, Observatoire T3P 2024), pyramide des âges INSEE 2016 (moyenne 49 ans), {indemniteTaxi} € par an jusqu'à {ageRetraiteTaxi} ans : {indemnitesAnnee titulairesTaxi 0 0 0} M€ la première année, {indemnitesAnnee titulairesTaxi 0 0 8} M€ au bout de huit ans ; {sortiesTaxis titulairesTaxi} titulaires de {ageSortieTaxi} ans et plus quittent la population active, les autres se reclassent ; +0,05 % de PIB (voir `titulairesTaxi`)"
    leviers := leviersTaxis titulairesTaxi 0 0
    debut := 0
    variantes := [
      { nom := "toutes les ADS indemnisées (62 800)", leviers := leviersTaxis 62800 0 0 },
      { nom := "moins de 50 ans : deux ans d'indemnité et 15 000 € de formation", leviers := leviersTaxis titulairesTaxi 50 15000 }] },

  { id := "O-14"
    titre := "Partenaires d'accompagnement des normes et de lutte contre les accidents du travail, financés par l'État ; objectif : moyenne de l'Union européenne"
    source := s!"Texte Orientation D, mesure 14 ; {fondsPrevention} M€/an de fonds dédiés et taux d'accidents ramené de 190 à 110 pour 10 000 emplois (hypothèses, voir `fondsPrevention`) ; sources du sous-modèle : CNAM, rapport AT-MP 2023 ; Eurostat, accidents du travail 2022"
    leviers := [.preventionAccidents fondsPrevention baisseAccidentsPm]
    variantes := [
      { nom := "fonds doublés (1 Md€/an)", leviers := [.preventionAccidents 1000 baisseAccidentsPm] },
      { nom := "objectif à moitié atteint (−21 %)", leviers := [.preventionAccidents fondsPrevention 210] }] },

  { id := "O-15"
    titre := "Passage au logiciel libre pour tous les logiciels et tous les ordinateurs de l'État"
    source := s!"Texte Orientation D, mesure 15 ; migration {coutMigrationLibre} M€ en une fois puis {economieLibre} M€/an d'économies de licences à partir de la quatrième année (hypothèses, voir `economieLibre`)"
    leviers := [.depensePonctuelle coutMigrationLibre] },
  { id := "O-15b"
    titre := "Logiciel libre : économies de licences en régime de croisière"
    source := "Texte Orientation D, mesure 15 (suite) ; entrée en vigueur la quatrième année"
    leviers := [.economieSur .fonctionnement economieLibre]
    debut := 1 },

  { id := "O-16"
    titre := "Reprise de la dette des universités et apurement de leurs déficits"
    source := s!"Texte Orientation D, mesure 16 ; la reprise de dette est un transfert interne aux administrations publiques (neutre) ; apurement des déficits : {deficitsUniversites} M€/an (hypothèse, Cour des comptes 2025 : ≈ 60 universités en déficit)"
    leviers := [.depenseSur .enseignement deficitsUniversites] },

  { id := "O-17"
    titre := "Reconstruction aux normes des universités de Nanterre, Toulouse, Montpellier et Grenoble (démolition puis construction)"
    source := s!"Texte Orientation D, mesure 17 ; 4 × 1 Md€ sur huit ans à partir de 2027 : {reconstructionCampus} M€/an d'investissement (hypothèse), emplois dans la construction ; le modèle garde la dépense constante au-delà des huit ans (prudent)"
    leviers := [.investissement .enseignement reconstructionCampus]
    debut := 0 },

  { id := "O-18"
    titre := "Parcoursup ouvert aux étudiants étrangers, à nombre d'admis constant"
    source := "Texte Orientation D, mesure 18 ; à effectifs constants, sans effet budgétaire : procédure d'admission unifiée (remplace Études en France pour les candidats hors UE) ; enregistrée pour mémoire"
    leviers := [] },

  { id := "O-19"
    titre := "Ouverture de places pour tous les bacheliers sans affectation"
    source := s!"Texte Orientation D, mesure 19 ; ≈ 10 000 bacheliers sans proposition par an (SIES, Parcoursup 2025) × 3 ans, soit 30 000 étudiants (≈ 0,55 point de scolarisation des 18-24 ans) : places comptées dans la hausse de la scolarisation d'O-81 (3 points), qui en porte le coût ({placesSansFac} M€/an à 10 500 €) ; 2 000 postes d'enseignants-chercheurs annoncés"
    leviers := [.annonceEmplois 2000]
    variantes := [{ nom := "places en plus de celles d'O-81 (version précédente)",
                    leviers := [.depenseSur .enseignement placesSansFac, .annonceEmplois 2000] }] },

  { id := "O-20"
    titre := "Aide à l'apprentissage réservée aux niveaux infra-bac et aux PME"
    source := s!"Texte Orientation D, mesure 20 ; l'aide exceptionnelle s'éteint en 2027 à législation constante (décret n° 2026-168) ; aide maintenue pour l'infra-bac dans les entreprises de moins de 250 salariés : 3,9 Md€ (2024) − 2,94 Md€ d'économies (Cour des comptes, revue de dépenses, 2025) ≈ {aideApprentissageCiblee} M€/an (voir `aideApprentissageCiblee`)"
    leviers := [.depenseSur .famille aideApprentissageCiblee] },

  { id := "O-21"
    titre := "Commande publique : centrales d'achat, standardisation, lutte contre les ententes"
    source := s!"Texte Orientation D, mesure 21 ; {economieCommandePublique} M€/an (hypothèse médiane : Autorité de la concurrence sur les ententes, IGF sur la mutualisation des achats) ; répartie sur les services généraux"
    leviers := [.economieSur .fonctionnement economieCommandePublique] },

  { id := "O-22"
    titre := "Médicaments et dispositifs : génériques, biosimilaires, prix, pertinence ; agence française du médicament produisant les références en rupture"
    source := s!"Texte Orientation D, mesure 22 ; économies {economieMedicament} M€/an (Assurance maladie, charges et produits 2025) ; agence publique : {investissementAgence} M€ d'investissement puis {coutAgenceMedicament} M€/an de fonctionnement (hypothèses) ; 1 500 emplois industriels annoncés"
    leviers := [.economieSur .sante economieMedicament, .depensePonctuelle investissementAgence,
                .depenseSur .sante coutAgenceMedicament, .annonceEmplois 1500] },

  { id := "O-23"
    titre := "Lutte contre la fraude et le travail dissimulé (BTP, restauration, services à la personne)"
    source := s!"Texte Orientation D, mesure 23 ; HCFiPS 2024 : 6 à 8 Md€ de cotisations éludées par an ; récupération de {fraudeCotisations} M€ de cotisations et {fraudeTVA} M€ de TVA par an, en régime de croisière la troisième année ; le modèle applique sa fuite fiscale à ces recettes"
    leviers := [.prelevementSur .cotisations fraudeCotisations, .prelevementSur .tva fraudeTVA]
    debut := 0 },

  { id := "O-25"
    titre := "Rémunération des enseignants : +2 % par an"
    source := s!"Texte Orientation D, mesure 25 ; masse salariale hors CAS Pensions 59,23 Md€ en 2026 (PLF 2026), base 2027 {masseEnseignants2027} M€ ; +2 %/an au-delà de la tendance de 2027 à 2035 : {revalorisationsEnseignants.head!} M€ la première année, {revalorisationsEnseignants[8]!} M€ (euros 2027) la neuvième (2035)"
    leviers := [.remunerationPublique .traitement .enseignement revalorisationsEnseignants]
    debut := 0 },

  { id := "O-26"
    titre := "Automatisation des tâches administratives : 10 000 postes libérés par an pendant cinq ans, agents redéployés"
    source := s!"Texte Orientation D, mesure 26, amendée en octobre 2026 : {postesControleParAn} postes libérés par an × 5, agents redéployés (voir `postesControleParAn`) ; outil : {investissementParPoste} € par poste la même année puis {maintenanceParPoste} €/an (hypothèses)"
    leviers := [.depenseEcheancier .fonctionnement [postesControleParAn * investissementParPoste / 1000000, 0],
                .depenseSur .fonctionnement (postesControleParAn * maintenanceParPoste / 1000000)]
    debut := 0
    repetitions := 5
    variantes := [
      { nom := "postes supprimés (version précédente, 55 000 € par poste)",
        leviers := [.suppressionPostes .fonctionnement postesControleParAn coutPosteControle,
                    .depenseEcheancier .fonctionnement [postesControleParAn * investissementParPoste / 1000000, 0],
                    .depenseSur .fonctionnement (postesControleParAn * maintenanceParPoste / 1000000)]
      }] },

  { id := "O-27"
    titre := "Médecins généralistes : simplification des tâches administratives ; enquêteurs humains sur les cas anormaux à la place des contrôles systématiques"
    source := s!"Texte Orientation D, mesure 27 ; DREES 2019 : 5 h 30 de gestion par semaine sur 54 h ; moitié supprimée pour {generalistesLiberaux} généralistes libéraux : {heuresLibereesMilliers} milliers d'heures de soin libérées par an, ≈ {etpGeneralistesLiberes} généralistes à temps plein, {consultationsMilliers} milliers de consultations possibles ; {enqueteurs} enquêteurs à {coutEnqueteur} € (hypothèses)"
    leviers := [.depenseSur .sante (enqueteurs * coutEnqueteur / 1000000)]
    debut := 0
    variantes := [
      { nom := s!"temps libéré converti en consultations remboursées (+{coutConsultations} M€/an)",
        leviers := [.depenseSur .sante (enqueteurs * coutEnqueteur / 1000000), .depenseSur .sante coutConsultations] }] },

  { id := "O-24"
    titre := "Dette numérique : achat d'OAT tokenisées en stablecoin euro (mécanisme USDC), intérêts exonérés de PFU"
    source := s!"Texte Orientation D, mesure 24 ; OAT numériques réglées en jetons de monnaie électronique (MiCA, règlement (UE) 2023/1114, art. 50 : pas d'intérêt sur le jeton), régime pilote DLT (règlement (UE) 2022/858, à réviser) ; exonération du PFU de 31,4 % (LFSS 2026) pour les particuliers résidents ; tranche cible {cibleDetteNumerique} ‰ de la dette (+{rythmeDetteNumerique} ‰/an, première tranche fin 2028), capitalisation fiscale {capitalisationFiscale} ‰ (obligations municipales américaines), part des résidents {partResidents} ‰, part imposée auparavant {partImposeeAvant} ‰"
    leviers := [.detteNumerique cibleDetteNumerique rythmeDetteNumerique capitalisationFiscale
                  partResidents partImposeeAvant]
    debut := 0 },

  { id := "O-28"
    titre := "Désindexation des très hautes retraites : revalorisation limitée à la part sous 5 150 € par mois"
    source := s!"Texte Orientation D, mesure 28 ; 1 % des retraités au-delà de 5 150 € bruts, 6 470 € en moyenne (DREES) ; part au-delà du seuil {masseAuDelaSeuil} M€ (2027), revalorisation évitée {inflationPb} pb/an : {(desindexation masseAuDelaSeuil).head!} M€ la première année, {(desindexation masseAuDelaSeuil)[8]!} M€ en 2035 (euros 2027)"
    leviers := [.depenseEcheancier .retraites (desindexation masseAuDelaSeuil)]
    debut := 0
    variantes := [
      { nom := s!"gel de toute la pension au-delà du seuil ({masseTresHautes} M€ concernés)",
        leviers := [.depenseEcheancier .retraites (desindexation masseTresHautes)] }] },

  { id := "O-29"
    titre := "TVA : taux normal porté de 20 % à 23 %, taux de 10 % à 11 % et de 5,5 % à 6 %, le temps de rétablir les comptes"
    source := s!"Texte Orientation D, mesure 29 ; rendement d'un point (FIPECO, 2025) : {tvaPointNormal} M€ au taux normal, {tvaPointIntermediaire} M€ à 10 %, {tvaPointReduit} M€ à 5,5 % (un demi-point) : {tvaHausse} M€ de rendement statique, net de la fuite fiscale du modèle (voir `tvaHausse`)"
    leviers := [.prelevementSur .tva tvaHausse]
    debut := 0
    variantes := [
      { nom := "taux normal seul porté à 23 %, taux réduits inchangés", leviers := [.prelevementSur .tva (3 * tvaPointNormal)] },
      { nom := "version précédente : taux normal à 22 %", leviers := [.prelevementSur .tva (2 * tvaPointNormal)] },
      { nom := "taux réduit à 6,5 % (version de novembre 2026)", leviers := [.prelevementSur .tva (3 * tvaPointNormal + tvaPointIntermediaire + tvaPointReduit)] }] },

  { id := "O-30"
    titre := "Taxe forfaitaire à l'atterrissage des jets privés"
    source := s!"Texte Orientation D, mesure 30 ; {atterrissagesJets} atterrissages par an (84 885 départs en 2022, Greenpeace) × {taxeAtterrissage} € (hypothèse) ; fuite fiscale du modèle pour le report et la baisse des vols"
    leviers := [.prelevementSur .autres (atterrissagesJets * taxeAtterrissage / 1000000)]
    debut := 0
    variantes := [
      { nom := "taxe de 1 000 € par atterrissage", leviers := [.prelevementSur .autres (atterrissagesJets * 1000 / 1000000)] }] },

  { id := "O-31"
    titre := "Plan de conversion à l'électrique de l'ensemble des exploitations agricoles (dix ans)"
    source := s!"Texte Orientation D, mesure 31 ; {exploitationsAgricoles} exploitations (RA 2020) × {aideConversion} € sur dix ans (hypothèse) ; énergie agricole ≈ 37 TWh de produits pétroliers, {emissionsEnergieAgricole} Mt de CO₂ ; importations nettes −{(carburantAgricoleImporte - electriciteNonExportee) / 10} M€ par an"
    leviers := [.depenseEcheancier .affairesEconomiques [exploitationsAgricoles * aideConversion / 10 / 1000000, 0],
                .transition .agriculture (emissionsEnergieAgricole / 10) 0,
                .importationsNiveau (-((carburantAgricoleImporte - electriciteNonExportee) / 10))]
    debut := 0
    repetitions := 10 },

  { id := "O-32"
    titre := "Suppression du DPE pour les immeubles de Paris et des quartiers historiques ; climatisation réversible aidée par l'État"
    source := s!"Texte Orientation D, mesure 32 ; DPE : sans effet budgétaire ; {logementsClimatisation} logements par an × {aideClimatisation} € pendant dix ans (hypothèses) ; effet sur les émissions inférieur à la résolution du modèle (1 Mt)"
    leviers := [.depenseEcheancier .logementEnvironnement [logementsClimatisation * aideClimatisation / 1000000, 0]]
    debut := 0
    repetitions := 10 },

  { id := "O-33"
    titre := "Pas d'immeubles de grande hauteur dans les quartiers historiques ; quartiers nouveaux autour des pôles très desservis (Val de Fontenay)"
    source := s!"Texte Orientation D, mesure 33 ; interdiction sans effet budgétaire ; {logementsQuartiersGare} logements par an × {aideLogementQuartierGare} € d'équipements publics (hypothèses)"
    leviers := [.investissement .logementEnvironnement (logementsQuartiersGare * aideLogementQuartierGare / 1000000)]
    debut := 0 },

  { id := "O-34"
    titre := "TER 24 h sur 24 entre métropoles et villes moyennes (Orléans…), agents de sécurité à bord, en gare et aux parkings"
    source := s!"Texte Orientation D, mesure 34 ; {liaisonsTerNuit} liaisons de {distanceTerKm} km, {trainsParNuit} trains par nuit, 23,40 € par train-km (IFRAP 2024), {heuresAgentsParNuit} heures d'agents par nuit à {coutHeureAgent} €, {couvertureRecettesPm / 10} % couverts par les recettes : {coutTerNuit} M€ par an"
    leviers := [.depenseSur .affairesEconomiques coutTerNuit]
    debut := 0 },

  { id := "O-36"
    titre := "CSG sur les gros héritages, 20 Md€ par an"
    source := s!"Texte Orientation D, mesure 36 ; double du chiffrage de l'amendement de septembre 2026 (10 Md€, sans contre-expertise connue) : {csgHeritages} M€ statiques, nets de la fuite des transmissions dans le modèle ; prélevée comme la CSG mais assise sur les successions : imputée à la ligne des droits de succession, dont elle suit l'assiette (l'affectation à la Sécurité sociale est neutre sur le solde consolidé)"
    leviers := [.prelevementSur .droitsMutation csgHeritages]
    debut := 0
    variantes := [{ nom := "10 Md€ (version précédente, chiffrage de l'amendement)", leviers := [.prelevementSur .droitsMutation 10000] }] },

  { id := "O-37"
    titre := "Taxe sur les services numériques portée de 3 % à 15 %"
    source := s!"Texte Orientation D, mesure 37 ; 0,89 Md€ à 3 %, ≈ 4 Md€ à 15 % (commission des finances, octobre 2026) : +{taxeNumerique} M€ ; l'amendement de septembre 2026 annonce 10 Md€"
    leviers := [.prelevementSur .autres taxeNumerique]
    debut := 0
    variantes := [{ nom := "chiffrage de l'amendement (10 Md€)", leviers := [.prelevementSur .autres 10000] }] },

  { id := "O-38"
    titre := "Reconfiguration des exonérations de cotisations patronales, ciblée sur les salaires de 1,6 à 2,5 SMIC"
    source := s!"Texte Orientation D, mesure 38 ; chiffrage de l'amendement de septembre 2026 : {exonerationsCotisations} M€ ; amendée en octobre 2026 : la réduction porte sur la tranche de 1,6 à 2,5 SMIC (élasticité de l'emploi au coût du travail de 0,25 contre 0,4 sous 1,6 SMIC, modèle commun) au lieu d'une réduction au prorata, qui touchait surtout les bas salaires"
    leviers := [.allegementsCotisations .intermediaire (-exonerationsCotisations)]
    variantes := [{ nom := "réduction au prorata des allègements (version précédente)", leviers := [.reductionAllegements exonerationsCotisations] }]
    debut := 0 },

  { id := "O-39"
    titre := "Train de vie de l'État"
    source := s!"Texte Orientation D, mesure 39 ; part « train de vie » des 12,1 Md€ d'économies annoncées en septembre 2026, moins O-21 déjà compté : {trainDeVieEtat} M€ d'économies de fonctionnement (la lutte contre la fraude fiscale est en O-45)"
    leviers := [.economieSur .fonctionnement trainDeVieEtat]
    debut := 0 },

  { id := "O-40"
    titre := "Revue des niches fiscales : −10 % hors Pacte Dutreil et hors dispositifs pour les ménages modestes"
    source := s!"Texte Orientation D, mesure 40 ; 465 niches, 88,3 Md€ en 2026 (PLF 2026) ; {nichesFiscales} M€ (IR 4, IS 2, TVA 2) ; diminué de son taux appliqué au CIR (O-69) et aux heures supplémentaires (O-73) déjà réduits (voir `recouvrementNichesIr`)"
    leviers := [.prelevementSur .ir (4000 - recouvrementNichesIr / 10),
                .prelevementSur .impotSocietes (2000 - recouvrementNichesIs / 10), .prelevementSur .tva 2000]
    debut := 0 },

  { id := "O-41"
    titre := "Fiscalité du patrimoine : Pacte Dutreil divisé par deux (abattement 75 % → 37,5 %), taxe sur les holdings élargie"
    source := s!"Texte Orientation D, mesure 41 ; Cour des comptes, note du 21 septembre 2026 (1,3 Md€ pour 75 % → 50 %, proportionnel) : {pacteDutreil} M€ (Dutreil, 5,5 Md€ de coût en 2024) et {holdings} M€ (holdings)"
    leviers := [.prelevementSur .droitsMutation pacteDutreil, .prelevementSur .patrimoine holdings]
    debut := 0 },

  { id := "O-42"
    titre := "Norme de dépense : +0,5 % en volume pour les dépenses pilotables (hors retraites, famille, enseignement, défense)"
    source := s!"Texte Orientation D, mesure 42 ; {normeDepensePb} pb de moins par an sur ≈ 739 Md€ de dépenses pilotables (2025) : 2,3 % au lieu de 2,8 %"
    leviers := [.normeDepense normeDepensePb]
    debut := 0
    variantes := [{ nom := "zéro volume (100 pb)", leviers := [.normeDepense 100] }] },

  { id := "O-43"
    titre := "Budget de la défense : −1 Md€ par an"
    source := s!"Texte Orientation D, mesure 43 ; {economieDefense} M€ par an sur 53 Md€ (2025), en moins de la trajectoire de la LPM actualisée (loi n° 2026-791)"
    leviers := [.economieSur .defense economieDefense]
    debut := 0 },

  { id := "O-44"
    titre := "Durée de cotisation portée de 172 à 174 trimestres"
    source := s!"Texte Orientation D, mesure 44 ; +2 trimestres, {partDepartsDuree / 10} % des départs liés à la durée (hypothèse ; COR) : âge moyen de départ +4,8 mois (levier `dureeCotisation`, au millième de mois)"
    leviers := [.dureeCotisation 6 partDepartsDuree]
    debut := 0 },

  { id := "O-45"
    titre := "Lutte contre la fraude fiscale : facturation électronique, renfort du contrôle fiscal"
    source := s!"Texte Orientation D, mesure 45 ; écart de TVA 12,1 Md€ en 2023 (Commission européenne) ; facturation électronique : {fraudeFacturation} M€ de TVA par an à partir de 2028 (2 à 3 Md€ attendus par l'administration) ; {agentsControle} agents de contrôle pris parmi les agents redéployés par l'automatisation (O-26), sans coût supplémentaire, {rendementControle} M€ d'encaissements par an (hypothèse)"
    leviers := [.prelevementSur .tva (fraudeFacturation + rendementControle / 3),
                .prelevementSur .ir (rendementControle / 3),
                .prelevementSur .impotSocietes (rendementControle - 2 * (rendementControle / 3))]
    variantes := [{ nom := "agents de contrôle recrutés en plus des agents redéployés par O-26 (version précédente)",
                    leviers := [.prelevementSur .tva (fraudeFacturation + rendementControle / 3),
                                .prelevementSur .ir (rendementControle / 3),
                                .prelevementSur .impotSocietes (rendementControle - 2 * (rendementControle / 3)),
                                .depenseSur .fonctionnement (agentsControle * coutAgentControle / 1000000)] }]
    debut := 1 },

  { id := "O-46"
    titre := "CSG progressive pour les hauts revenus : +2 points au-delà de 100 000 € par an"
    source := s!"Texte Orientation D, mesure 46 ; +{pointsCsgHauts} points sur la part des revenus d'activité et de remplacement au-delà de {seuilCsgHauts} € ; 1 point de CSG = 17 Md€ (FIPECO 2024) ; {partAssietteAuDelaPm / 10} % de l'assiette au-delà du seuil (hypothèse) : {rendementCsgHauts} M€"
    leviers := [.prelevementSur .csgCrds rendementCsgHauts,
                -- taux marginal d'un salaire : 55,4 % + 2 points de CSG (calcul)
                .tauxMarginalSommet 574]
    debut := 0 },

  { id := "O-47"
    titre := "Investissements de l'État dans les entreprises stratégiques : 100 M€ par an"
    source := s!"Texte Orientation D, mesure 47 ; {participationsStrategiques} M€ par an de prises de participation (opération financière : dette sans déficit) ; dividendes au rendement du portefeuille de l'APE (≈ 1,9 %)"
    leviers := [.prisesDeParticipation participationsStrategiques]
    debut := 0 },

  { id := "O-48"
    titre := "Non-renouvellement des concessions autoroutières : exploitation publique à l'échéance (2031-2036)"
    source := s!"Texte Orientation D, mesure 48 ; échéances Sanef 2031, Escota 2032, SAPN 2033, Cofiroute 2034, APRR 2035, ASF et AREA 2036 ; EBITDA des historiques ≈ {ebitdaHistoriques} M€, renouvellement {investissementsHistoriques} M€, IS ≈ {isHistoriques} M€ (ART 2023, estimations) ; part reprise en 2035 : {partReprise 8} ‰, en 2037 : {partReprise 10} ‰"
    leviers := [.recetteEcheancier none (echeancierReprise (ebitdaHistoriques - investissementsHistoriques)),
                .recetteEcheancier (some .impotSocietes) (echeancierReprise (-isHistoriques))]
    debut := 0
    variantes := [
      { nom := "péages baissés de 20 % à la reprise",
        leviers := [.recetteEcheancier none (echeancierReprise (ebitdaHistoriques * 800 / 1000 - investissementsHistoriques)),
                    .recetteEcheancier (some .impotSocietes) (echeancierReprise (-isHistoriques))] }] },

  { id := "O-49"
    titre := "Rémunération des hauts fonctionnaires : −5 %"
    source := s!"Texte Orientation D, mesure 49 ; encadrement supérieur et dirigeant (21 500 agents, DGAFP), coût complet ≈ {masseHautsFonctionnaires} M€ : économie {economieHautsFonctionnaires} M€"
    leviers := [.remunerationPublique .traitement .fonctionnement [-(economieHautsFonctionnaires * 3 / 4)],
                .remunerationPublique .traitement .sante [-(economieHautsFonctionnaires - economieHautsFonctionnaires * 3 / 4)]]
    debut := 0 },

  { id := "O-50"
    titre := "Revenus des élus plafonnés à 10 000 € par mois tous mandats confondus (limiter le cumul)"
    source := s!"Texte Orientation D, mesure 50 ; plafond en vigueur {plafondCumulActuel} € bruts par mois (CGCT, art. L. 2123-20 II), plus strict que {plafondElus} € : sans effet budgétaire, enregistrée pour mémoire"
    leviers := []
    debut := 0 },

  { id := "O-51"
    titre := "Fin du prélèvement forfaitaire unique : revenus du capital au barème de l'impôt sur le revenu"
    source := s!"Texte Orientation D, mesure 51 ; coût du PFU chiffré par l'État : 1,3 à 1,9 Md€ (2018-2019), ≈ 1,8 Md€ (PLF 2022) ; France Stratégie : 1,4 à 1,7 Md€ durablement ; retenu {finPfu} M€ (voir `finPfu`)"
    leviers := [.prelevementSur .ir finPfu,
                -- revenus du capital au barème : 45 % + 4 % de contribution sur
                -- les hauts revenus + 17,2 % de prélèvements sociaux = 66,2 % (calcul)
                .tauxMarginalSommet 662]
    debut := 0
    variantes := [{ nom := "sans rendement : dividendes revenus à leur niveau d'avant 2018 (France Stratégie, 2023)", leviers := [.tauxMarginalSommet 662] }] },

  { id := "O-52"
    titre := "Taxe sur les rachats d'actions portée de 8 % à 20 %"
    source := s!"Texte Orientation D, mesure 52 ; assiette implicite ≈ 25 Md€ (amendement PLF 2026), +12 points = 3 Md€ mécaniques, report vers les dividendes : {rachatsActions} M€ retenus"
    leviers := [.prelevementSur .impotSocietes rachatsActions]
    debut := 0 },

  { id := "O-53"
    titre := "Dépenses de cabinets de conseil divisées par deux"
    source := s!"Texte Orientation D, mesure 53 ; 893,9 M€ en 2021 (commission d'enquête du Sénat) : {economieConseil} M€ d'économies"
    leviers := [.economieSur .fonctionnement economieConseil]
    debut := 0 },

  { id := "O-54"
    titre := "Prolongation de la CRDS au-delà de 2033 pour amortir la dette de l'ACOSS"
    source := "Texte Orientation D, mesure 54 ; CRDS 9,22 Md€ en 2026, fin prévue avec la CADES (2033) ; dette de l'ACOSS ≈ 65 Md€ fin 2026 sans ressource ; maintien de 9,55 Md€ (euros 2027) à partir de 2034"
    leviers := [.recetteEcheancier (some .csgCrds) crdsProlongee] },

  { id := "O-55"
    titre := "Norme de dépense renforcée : dépenses pilotables à −1 % par an en volume (avec O-42)"
    source := s!"Texte Orientation D, mesure 55 : 100 pb de modération dans la version initiale, 200 pb en octobre 2026, ramenée le 5 novembre 2026 à +{normeRenforceePb} pb, soit 200 pb avec O-42 : 0,8 % par an en valeur au lieu de 2,8 % ; les dépenses à échéancier du programme (postes, investissements) sont indexées hors norme"
    leviers := [.normeDepense normeRenforceePb]
    variantes := [
      { nom := "norme de 200 pb (version d'octobre 2026, 250 pb avec O-42 : −1,5 % par an en volume)", leviers := [.normeDepense 200] },
      { nom := "norme de 100 pb (version initiale, 150 pb avec O-42 : −0,5 % par an en volume)", leviers := [.normeDepense 100] },
      { nom := "norme renforcée de 100 pb de plus (300 pb avec O-42, piste vers l'équilibre)", leviers := [.normeDepense (normeRenforceePb + 100)] }] },
  { id := "O-55b"
    titre := "Normes de dépense : la santé n'y contribue qu'à hauteur d'un point par an (gains d'efficience de l'ONDAM), le reste portant sur les autres dépenses pilotables"
    source := s!"Après l'introduction du lien dépense de santé → espérance de vie (élasticité 0,04, Gallet et Doucouliagos 2017) : avec O-42 et O-55 pleinement appliquées à la santé, la dépense de santé tombait à 83 % de sa tendance en 2035 et l'espérance de vie perdait 0,36 an ; plafond {plafondNormeSantePb} pb par an, qui la ramène au niveau tendanciel (ordre de grandeur des gains d'efficience demandés chaque année à l'ONDAM : 3,5 à 4 Md€ sur ≈ 260 Md€, PLFSS 2025 et 2026, soit ≈ 1,5 %, dont une partie seulement sans effet sur les soins ; hypothèse)"
    leviers := [.plafondNormeSante plafondNormeSantePb] },

  { id := "O-56"
    titre := "Aides aux entreprises : exonérations de cotisations réduites de 1,5 Md€ par an pendant six ans, sous conditions"
    source := s!"Texte Orientation D, mesure 56 ; 211 Md€ d'aides publiques aux entreprises (commission d'enquête du Sénat, juillet 2025) ; {baisseAidesEntreprises} M€ de plus chaque année de 2027 à 2032"
    leviers := [.reductionAllegements baisseAidesEntreprises]
    repetitions := 6 },

  { id := "O-57"
    titre := "Niches fiscales : −2 % par an pendant cinq ans (en plus de O-40)"
    source := s!"Texte Orientation D, mesure 57 ; 88,3 Md€ de dépenses fiscales (PLF 2026) ; {rabotNiches} M€ de plus chaque année de 2027 à 2031 (IR, IS, TVA) ; diminué de son taux appliqué au CIR (O-69) et aux heures supplémentaires (O-73) déjà réduits (voir `recouvrementNichesIr`)"
    leviers := [.prelevementSur .ir (rabotNiches / 2 - recouvrementNichesIr * 2 / 100),
                .prelevementSur .impotSocietes (rabotNiches / 4 - recouvrementNichesIs * 2 / 100),
                .prelevementSur .tva (rabotNiches / 4)]
    repetitions := 5 },

  { id := "O-58"
    titre := "Durée de cotisation : +1 trimestre tous les trois ans à partir de 2028"
    source := s!"Texte Orientation D, mesure 58 ; logique de la réforme de 2014 ; +1 mois de durée requise par an, {partDepartsDuree / 10} % des départs liés à la durée (hypothèse) ; raison : la baisse de la natalité (fécondité 1,56 en 2025, Insee ; 1,8 cotisant par retraité en 2025, 1,3 en 2070, COR 2026)"
    leviers := [.dureeCotisation 1 partDepartsDuree]
    debut := 1
    repetitions := 8 },

  { id := "O-59"
    titre := "Maintien de la CVAE au taux de 0,28 %"
    source := "Texte Orientation D, mesure 59 ; la loi n° 2025-127 (art. 62) supprime la CVAE par étapes de 2028 à 2030 ; rendement à 0,28 % ≈ 3,4 Md€ (Sénat, amendement I-31 au PLF 2026 : 1,1 Md€ pour 0,09 point) ; voir `cvaeMaintenue`"
    leviers := [.recetteEcheancier (some .autres) cvaeMaintenue] },

  { id := "O-60"
    titre := "Pérennisation de la contribution exceptionnelle sur les bénéfices des grandes entreprises"
    source := s!"Texte Orientation D, mesure 60 ; 7,5 Md€ en 2026 (loi n° 2026-103), non reconduite à législation constante (le PLF 2027 propose 5 Md€ pour 2027) ; aux taux de 2026 sur l'IS des grands groupes, imposés à {max tauxISCible tauxMinimumPilier2 / 100} % avec O-08 : {contributionGrandesEntreprises} M€ (euros 2027)"
    leviers := [.recetteEcheancier (some .impotSocietes) [contributionGrandesEntreprises]] },

  { id := "O-61"
    titre := "Aides aux entreprises, deuxième étape : exonérations de cotisations réduites de 1,5 Md€ de plus par an de 2029 à 2034"
    source := s!"Texte Orientation D, mesure 61 ; même base que O-56 (211 Md€ d'aides, commission d'enquête du Sénat, juillet 2025) ; {aidesSecondeEtape} M€ de plus chaque année de 2029 à 2034, sous conditions (voir `aidesSecondeEtape`)"
    leviers := [.reductionAllegements aidesSecondeEtape]
    debut := 2
    repetitions := 6 },

  { id := "O-62"
    titre := "Niches fiscales : −1,5 Md€ de plus par an de 2029 à 2035"
    source := s!"Texte Orientation D, mesure 62 ; 88,3 Md€ de dépenses fiscales (PLF 2026) ; {nichesSecondeEtape} M€ de plus chaque année de 2029 à 2035 (IR, IS, TVA comme O-57) ; diminué de son taux appliqué au CIR (O-69) et aux heures supplémentaires (O-73) déjà réduits (voir `recouvrementNichesIr`)"
    leviers := [.prelevementSur .ir (nichesSecondeEtape / 2 - recouvrementNichesIr * nichesSecondeEtape / depensesFiscales2026),
                .prelevementSur .impotSocietes
                  (nichesSecondeEtape / 4 - recouvrementNichesIs * nichesSecondeEtape / depensesFiscales2026),
                .prelevementSur .tva (nichesSecondeEtape / 4)]
    debut := 2
    repetitions := 7 },

  { id := "O-63"
    titre := "Aide à la rénovation énergétique majorée de 25 % dans les territoires ruraux, fenêtres, isolation des murs, des combles et des planchers et ventilation comprises (le chauffage relève d'O-90)"
    source := s!"Texte Orientation D, mesure 63 ; +{bonusRenovationRurale} € par rénovation aidée dans les communes rurales (48 % des rénovations aidées, Anah 2021) ; aide par geste rétablie dans les communes rurales pour les fenêtres et l'isolation (sorties de MaPrimeRénov' par geste en 2026) : {gestesIsolationRuraux} gestes par an à {aideGesteIsolationEuros} €, {economieGesteKWh} kWh économisés par geste (hypothèses, SDES 2024) ; effets : sous-modèle rénovation du modèle commun (voir `gestesIsolationRuraux`)"
    leviers := [.bonusRenovation .rural bonusRenovationRurale,
                .renovationsAmpleur .rural gestesIsolationRuraux aideGesteIsolationEuros economieGesteKWh]
    variantes := [
      { nom := "majoration de 50 % (6 500 €)", leviers := [.bonusRenovation .rural (2 * bonusRenovationRurale)] }] },

  { id := "O-64"
    titre := "Accès à l'eau potable dans les outre-mer : réseaux, production, assainissement"
    source := s!"Texte Orientation D, mesure 64 ; besoins de 2,36 Md€ (Cour des comptes, mars 2025), moins les 730 M€ de la loi n° 2025-797 pour Mayotte : {eauOutreMer} M€ par an de 2027 à 2031 (voir `eauOutreMer`)"
    leviers := [.investissementOutreMer .logementEnvironnement [eauOutreMer, eauOutreMer, eauOutreMer, eauOutreMer, eauOutreMer, 0]] },

  { id := "O-65"
    titre := "Électrification totale des outre-mer : raccordement de tous les foyers"
    source := s!"Texte Orientation D, mesure 65 ; ≈ 22 100 foyers sans électricité à Mayotte et en Guyane (INSEE 2026) ; raccordement et sites isolés : 211 M€ sur trois ans (coûts unitaires : hypothèses) ; surcoût de péréquation des zones non interconnectées pour {foyersRaccordesParAn} foyers de plus par an (voir `electrificationOutreMer`)"
    leviers := [.investissementOutreMer .affairesEconomiques electrificationOutreMer] },

  { id := "O-66"
    titre := "Électrification des outre-mer : électricité des foyers raccordés (péréquation tarifaire)"
    source := s!"Texte Orientation D, mesure 65 (suite) ; {foyersRaccordesParAn} foyers raccordés par an de 2027 à 2029, consommation et surcoût de production des zones non interconnectées : axe énergie du modèle commun"
    leviers := [.raccordementZni foyersRaccordesParAn]
    repetitions := 3 },

  { id := "O-67"
    titre := "Dettes cachées : paiement immédiat des heures supplémentaires non payées des policiers"
    source := "Texte Orientation D, mesure 67 ; 14,3 millions d'heures au 31 décembre 2022 (Sénat, rapport n° 34, 2024-2025), 13,22 € l'heure : 189 M€ payés en 2027 (passif implicite du modèle commun)"
    leviers := [.apurementPassifs .heuresSupPolice .securiteJustice 1000] },

  { id := "O-68"
    titre := "Dettes cachées : RIFSEEP pour les enseignants, primes alignées sur les autres agents de catégorie A"
    source := s!"Texte Orientation D, mesure 68 ; primes à 17,2 % du brut contre 32,9 % pour la catégorie A (DGAFP 2025) ; ≈ 10 950 € par enseignant × 693 400 fonctionnaires (DEPP 2025) : {rifseepEnseignants} M€ par an (euros 2027), primes (voir `rifseepEnseignants`)"
    leviers := [.remunerationPublique .primes .enseignement [rifseepEnseignants]]
    variantes := [
      { nom := "montée en charge sur cinq ans", leviers := [.remunerationPublique .primes .enseignement
          [rifseepEnseignants / 5, 2 * rifseepEnseignants / 5, 3 * rifseepEnseignants / 5, 4 * rifseepEnseignants / 5, rifseepEnseignants]] }] },

  { id := "O-69"
    titre := "Crédit d'impôt recherche recentré : plafond de 50 M€ par groupe, fin du taux de 5 %"
    source := s!"Texte Orientation D, mesure 69 ; IGF (revue de dépenses, mars 2024) : au moins {cirRecentre} M€ ; amendements au PLF 2026 (AN I-754, Sénat I-674)"
    leviers := [.prelevementSur .impotSocietes cirRecentre] },

  { id := "O-70"
    titre := "Assurance-vie au barème des successions au-delà de 250 000 € par bénéficiaire"
    source := s!"Texte Orientation D, mesure 70 ; {assuranceVieBaremeCpo} M€ avec le seuil actuel de 152 500 € (Conseil des prélèvements obligatoires, 1er décembre 2025, recommandation n° 6) ; seuil relevé à 250 000 € : ≈ {assuranceVieBareme} M€ (hypothèse, voir `assuranceVieBareme`)"
    leviers := [.prelevementSur .droitsMutation assuranceVieBareme]
    variantes := [
      { nom := "seuil actuel de 152 500 € (proposition du CPO)", leviers := [.prelevementSur .droitsMutation assuranceVieBaremeCpo] }] },

  { id := "O-71"
    titre := "Contribution kilométrique des poids lourds sur le réseau national non concédé"
    source := s!"Texte Orientation D, mesure 71 ; écotaxe de 2014 : 1 129 M€ bruts à 0,13 €/km (Cour des comptes, 2017), {ecotaxePoidsLourds} M€ actualisés ; émissions visées {emissionsPoidsLourdsVisees} kt, coût +11 % ; élasticité-prix du modèle commun"
    leviers := [.taxeEnvironnementale .poidsLourds .autres emissionsPoidsLourdsVisees 110 ecotaxePoidsLourds] },

  { id := "O-72"
    titre := "Accise sur le kérosène des vols intérieurs métropolitains"
    source := s!"Texte Orientation D, mesure 72 ; 1,5 Mt de CO₂ (DGAC, 2024), taux du gazole : ≈ {kerosene} M€ avant comportements, billets +10 % ; élasticité-prix du modèle commun"
    leviers := [.taxeEnvironnementale .aerienInterieur .accisesEnergie 1500 100 kerosene] },

  { id := "O-73"
    titre := "Défiscalisation des heures supplémentaires réduite de moitié (impôt sur le revenu et cotisations salariales)"
    source := s!"Texte Orientation D, mesure 73 ; exonération d'IR ≈ {heuresSupIr} M€ (Voies et moyens) et réduction de cotisations salariales {heuresSupCotisations} M€ (PLFSS 2026), réduites de {partDefiscalisationSupprimeePm / 10} %"
    leviers := [.prelevementSur .ir (heuresSupIr * partDefiscalisationSupprimeePm / 1000),
                .prelevementSur .cotisations (heuresSupCotisations * partDefiscalisationSupprimeePm / 1000)]
    variantes := [
      { nom := "suppression totale (comme en 2012)", leviers := [.prelevementSur .ir heuresSupIr, .prelevementSur .cotisations heuresSupCotisations] }] },

  { id := "O-74"
    titre := "Dettes cachées : paiement immédiat des heures supplémentaires non payées des hôpitaux publics"
    source := "Texte Orientation D, mesure 74 ; 18,5 millions d'heures, 463 M€ fin 2018 (Cour des comptes, 2020) ; ≈ 720 M€ d'après le bilan social des hôpitaux 2022 (ATIH) et les effectifs DREES 2024 : payés en 2027 (passif implicite du modèle commun)"
    leviers := [.apurementPassifs .heuresSupHopital .sante 1000] },

  { id := "O-75"
    titre := "85 000 places de prison, la moitié des places nouvelles en modulaire : construction, surveillants et fonctionnement"
    source := s!"Texte Orientation D, mesure 75 (100 000 places dans le texte ; {placesPrisonCible} places au plus) ; 63 303 places pour 89 668 détenus au 1er août 2026 (ministère de la Justice) ; plan 15 000 ({placesPlan15000Restantes} places restantes) et programme modulaire du ministère ({placesModulairesGouvernement} places) dans la tendance ; {placesPrisonNouvelles} places de plus, dont {placesModulaires} en modulaire à {coutPlaceModulaireKEuros} k€ (ministère, juillet 2025 ), ouvertes de 2028 à 2030, et {placesClassiques} en établissements classiques à {coutPlacePrisonKEuros} k€ la place nette (Cour des comptes, décembre 2025), ouvertes de 2032 à 2035 ; {coutAnnuelPlaceEuros} € par place ouverte et par an (0,48 surveillant par place, voir `placesPrisonNouvelles`) ; emprise : 17 ha pour 700 places (voir `surfacesPrisonsPour`)"
    leviers := [.investissementEcheancier .securiteJustice (constructionPrisons coutPlacePrisonKEuros),
                .depenseEcheancier .securiteJustice fonctionnementPrisons,
                .artificialisation .autres surfacesPrisons]
    variantes := [
      { nom := "100 000 places, cible du texte (moitié des places nouvelles en modulaire)", leviers :=
          [.investissementEcheancier .securiteJustice (constructionPrisonsPour placesPrisonCibleTexte partModulairePm coutPlacePrisonKEuros),
           .depenseEcheancier .securiteJustice (fonctionnementPrisonsPour placesPrisonCibleTexte partModulairePm),
           .artificialisation .autres (surfacesPrisonsPour placesPrisonCibleTexte partModulairePm)] },
      { nom := "sans modulaire (établissements classiques seuls, 270 k€ la place)", leviers :=
          [.investissementEcheancier .securiteJustice (constructionPrisonsPour placesPrisonCible 0 coutPlacePrisonKEuros),
           .depenseEcheancier .securiteJustice (fonctionnementPrisonsPour placesPrisonCible 0),
           .artificialisation .autres (surfacesPrisonsPour placesPrisonCible 0)] },
      { nom := "places classiques au coût des centres pénitentiaires (450 k€ la place)", leviers :=
          [.investissementEcheancier .securiteJustice (constructionPrisons coutPlacePrisonCpKEuros),
           .depenseEcheancier .securiteJustice fonctionnementPrisons,
           .artificialisation .autres surfacesPrisons] }] },

  { id := "O-76"
    titre := "Allègements recentrés : sortie à 2 SMIC au lieu de 3, économie reversée aux salaires de 1 à 1,6 SMIC, à coût constant"
    source := s!"Texte Orientation D, mesure 76 ; CAE, note n° 49 (2019) ; Bozio et Wasmer (2024) : suppression des bandeaux avec recyclage, +50 000 emplois ; part des allègements de 1,6 à 2,5 SMIC au-delà de 2 SMIC : {partAllegementsAuDela2Smic} ‰ (calcul, barème de 2026) ; élasticités de l'emploi par tranche du modèle commun"
    leviers := [.recentrageAllegements partAllegementsAuDela2Smic 1000]
    variantes := [
      { nom := "sortie à 1,6 SMIC (tout reversé sous 1,6 SMIC)", leviers := [.recentrageAllegements 1000 1000] }] },

  { id := "O-77"
    titre := "Accompagnement renforcé des demandeurs d'emploi : 10 000 conseillers de plus à France Travail, pourvus par les agents redéployés de l'automatisation (O-26)"
    source := s!"Texte Orientation D, mesure 77 ; expériences aléatoires : Behaghel, Crépon et Gurgand (2014), Böheim, Eppel et Mahringer (WIFO, 2022), Hainmueller et al. (2016) ; {conseillersFranceTravail} conseillers à {coutConseillerEuros} € par an (hypothèse) ; chômage d'équilibre du modèle commun (5 chômeurs de moins par conseiller, éviction comprise)"
    leviers := [.accompagnementDemandeurs conseillersFranceTravail coutFormationConseillerEuros]
    variantes := [
      { nom := "10 000 conseillers recrutés en plus des agents redéployés (version précédente : O-26b et O-77 distinctes, 20 000 conseillers)"
        leviers := [.accompagnementDemandeurs conseillersFranceTravail coutConseillerEuros,
                    .accompagnementDemandeurs conseillersFranceTravail 0] },
      { nom := "5 000 conseillers", leviers := [.accompagnementDemandeurs (conseillersFranceTravail / 2) coutConseillerEuros] },
      { nom := "15 000 conseillers", leviers := [.accompagnementDemandeurs (conseillersFranceTravail * 3 / 2) coutConseillerEuros] }] },

  { id := "O-78"
    titre := "Prix minimum de l'alcool : 0,50 € par verre standard"
    source := s!"Texte Orientation D, mesure 78 ; Etilé et al., INCa-MILDECA (2022) : −22 % de décès par cancers liés à l'alcool pour {prixMinimumAlcoolCentimes} centimes ; Écosse : −13,4 % des décès entièrement dus à l'alcool (Lancet, 2023) ; décès et délais d'effet du modèle commun"
    leviers := [.prixMinimumAlcool prixMinimumAlcoolCentimes] },

  { id := "O-79"
    titre := "Prix du tabac +20 % par les accises (paquet ≈ 15 €)"
    source := s!"Texte Orientation D, mesure 79 ; élasticité-prix −0,4 (Santé publique France), 68 000 décès attribuables en 2023 ; hausse de {hausseprixTabacPm / 10} % ; recettes et décès évités calculés par le modèle commun"
    leviers := [.prixTabac hausseprixTabacPm] },

  { id := "O-80"
    titre := "Dépistage organisé du cancer colorectal : 65 % de participation"
    source := s!"Texte Orientation D, mesure 80 ; participation de 30,7 % en 2024-2025 ; Barré et al. (2020) : −22 % de mortalité de 34 % à 65 % ; coût par dépistage du modèle commun (hypothèse)"
    leviers := [.depistageColorectal participationDepistageCible] },

  { id := "O-81"
    titre := "Scolarisation des 18-24 ans : +1 point par an pendant trois ans (places, bourses)"
    source := s!"Texte Orientation D, mesure 81 ; +{hausseScolarisationParAn / 10} point de scolarisation à chaque âge de 18 à 24 ans par an, 13 300 € par étudiant (DEPP 2024) ; durée attendue de scolarisation de l'IDH"
    leviers := [.scolarisationJeunes hausseScolarisationParAn]
    repetitions := 3
    variantes := [
      { nom := "+5 points (250 000 places)", leviers := [.scolarisationJeunes 17] }] },

  { id := "O-82"
    titre := "Loi intégrale contre les violences sexistes et sexuelles : besoins de la Fondation des femmes, 600 magistrats spécialisés et leurs greffes"
    source := s!"Texte Orientation D, mesure 82 ; Fondation des femmes, hypothèse basse (2023), nette des crédits dédiés de 2023 ligne à ligne : {violencesHorsPolesMeur} M€ par an hors pôles spécialisés (police, accueil, mise en sécurité, santé, emploi, pilotage, recherche) ; {magistratsO82} magistrats spécialisés avec leurs greffes ({postesJusticeO82.getLast?.getD 0} postes, locaux compris) au lieu des pôles chiffrés par la Fondation ; cours criminelles départementales : délai d'écoulement du stock {virguleDixiemes ((delaisCriminels true).headD 0)} mois en 2026, {virguleDixiemes ((delaisCriminels true).getLast?.getD 0)} en 2035 ({virguleDixiemes ((delaisCriminels false).getLast?.getD 0)} sans mesure) (voir `violencesHorsPolesMeur`, `anneesJustice`)"
    leviers := [.depenseSur .securiteJustice ((violencesPoliceDixiemes + violencesJusticeAutresDixiemes) / 10),
                .depenseSur .famille ((violencesSecuriteDixiemes + violencesAccueilDixiemes + violencesEmploiDixiemes) / 10),
                .depenseSur .sante (violencesSanteDixiemes / 10),
                .depenseSur .enseignement (violencesRechercheDixiemes / 10),
                .depenseSur .fonctionnement (violencesPilotageDixiemes / 10)]
               ++ leviersJustice postesJusticeO82
    variantes := [
      { nom := "haut de la fourchette (5,4 Md€, montant global)", leviers := [.depenseSur .securiteJustice (5400 - creditsViolencesExistants)] },
      { nom := "pôles spécialisés au montant de la Fondation (130 M€), sans modèle de justice", leviers :=
          [.depenseSur .securiteJustice ((violencesPoliceDixiemes + violencesJusticeAutresDixiemes + violencesPolesDixiemes) / 10),
           .depenseSur .famille ((violencesSecuriteDixiemes + violencesAccueilDixiemes + violencesEmploiDixiemes) / 10),
           .depenseSur .sante (violencesSanteDixiemes / 10),
           .depenseSur .enseignement (violencesRechercheDixiemes / 10),
           .depenseSur .fonctionnement (violencesPilotageDixiemes / 10)] }] },

  { id := "O-83"
    titre := "Allocations familiales dès le premier enfant : 70 € par mois"
    source := s!"Texte Orientation D, mesure 83 ; proposition de loi adoptée en première lecture le 5 juin 2025 ; direction de la Sécurité sociale (rapport AN n° 1473, p. 19-20) : {allocationsPremierEnfantBrut} M€ bruts, {allocationsPremierEnfantNet} M€ nets des moindres versements de RSA et de prime d'activité"
    leviers := [.depenseSur .famille allocationsPremierEnfantBrut,
                .economieSur .famille (allocationsPremierEnfantBrut - allocationsPremierEnfantNet)]
    variantes := [
      { nom := "75 € par mois, modulés selon le revenu (LexImpact : 3,58 Md€ bruts)",
        leviers := [.depenseSur .famille 3580,
                    .economieSur .famille (3580 * (allocationsPremierEnfantBrut - allocationsPremierEnfantNet) / allocationsPremierEnfantBrut)] }] },

  { id := "O-85"
    titre := "Santé mentale : 100 M€ de moyens supplémentaires par an"
    source := s!"Texte Orientation D, mesure 85 ; +{santeMentale} M€ par an, ≈ 0,4 % des 23 Md€ remboursés pour les troubles psychiques (voir `santeMentale`)"
    leviers := [.depenseSur .sante santeMentale] },

  { id := "O-86"
    titre := "Liberté fiscale des collectivités : taux de taxe foncière sans plafond ni lien, taxe d'habitation rétablissable"
    source := s!"Texte Orientation D, mesure 86 ; plafond actuel du taux de taxe foncière : 2,5 fois le taux moyen (CGI, art. 1636 B septies) ; taxe d'habitation des résidences principales : {produitTaxeHabitation} M€ avant sa suppression, compensés (DGCL) ; sans effet sur le solde à taux inchangés (voir `produitTaxeHabitation`)"
    leviers := []
    variantes := [
      { nom := "taxe d'habitation rétablie par des collectivités pesant 10 % de l'ancien produit (2,3 Md€), compensations maintenues",
        leviers := [.prelevementSur .autres (produitTaxeHabitation / 10)] }] },

  { id := "O-87"
    titre := "Référendum d'initiative citoyenne"
    source := s!"Texte Orientation D, mesure 87 ; révision constitutionnelle ; {coutReferendum} M€ par scrutin non dématérialisé (ministre de l'Intérieur, 11 mai 2025) ; hypothèse : un scrutin par an, non couplé à une élection (voir `coutReferendum`)"
    leviers := [.depenseSur .fonctionnement coutReferendum,
                .revisionConstitution "art. 11 et 89" "référendum d'initiative citoyenne"]
    variantes := [
      { nom := "scrutins dématérialisés (100 M€)", leviers := [.depenseSur .fonctionnement (coutReferendum / 2)] },
      { nom := "scrutins couplés aux élections (sans coût d'organisation propre)", leviers := [] }] },

  { id := "O-88"
    titre := "Médecins scolaires : effectif doublé, 800 de plus en quatre ans"
    source := s!"Texte Orientation D, mesure 88 ; 818 médecins en 2022, un pour 13 300 élèves, 44 % de postes vacants ; +{medecinsScolairesNouveaux} médecins à {coutMedecinScolaireEuros / 1000} k€ par an, revalorisation comprise (hypothèse) : {medecinsScolairesNouveaux * coutMedecinScolaireEuros / 1000000} M€ par an une fois tous recrutés, par quarts (voir `medecinsScolairesNouveaux`)"
    leviers := [.creationPostes .enseignement (([1, 2, 3, 4] : List Int).map fun k => medecinsScolairesNouveaux * k / 4)
                  coutMedecinScolaireEuros]
    variantes := [
      { nom := "retour au niveau de 2013 (1 143 médecins, 325 de plus)",
        leviers := [.creationPostes .enseignement (([1, 2, 3, 4] : List Int).map fun k => 325 * k / 4) coutMedecinScolaireEuros] }] },

  { id := "O-89"
    titre := "Fin de l'octroi de mer, compensée aux collectivités par l'État"
    source := s!"Texte Orientation D, mesure 89 ; 1,644 Md€ en 2022 (Cour des comptes, 5 mars 2024), {octroiDeMer2025} M€ en 2025 (calcul, voir `octroiDeMer2025`) ; effet sur la demande d'un impôt national (la part importée de la consommation des outre-mer n'est pas isolée)"
    leviers := [.prelevementSur .autres (-octroiDeMer2025)]
    variantes := [
      { nom := "remplacé par une TVA régionale de même rendement (scénario de rupture de la Cour des comptes)", leviers := [] }] },

  { id := "O-90"
    titre := "Pompes à chaleur gratuites dans les zones rurales, 100 000 par an, financées en partie par les coûts de réseau de gaz évités"
    source := s!"Texte Orientation D, mesure 90 ; {pacRuralesParAn} PAC par an (hypothèse) à {coutPacEuros} €, coût moyen d'une PAC air/eau ; chaleur de 12 MWh, coefficient de performance 2,9 (ADEME), 75 % de chaudières au fioul ou au GPL en zone rurale (SDES) ; coûts de réseau de gaz évités de 67 € par an et par logement (CRE) ; effet d'aubaine des aides à la rénovation (voir `pacRuralesParAn`)"
    leviers := [.pompesAChaleur .rural pacRuralesParAn coutPacEuros]
    variantes := [
      { nom := "50 000 PAC par an", leviers := [.pompesAChaleur .rural (pacRuralesParAn / 2) coutPacEuros] },
      { nom := "200 000 PAC par an", leviers := [.pompesAChaleur .rural (2 * pacRuralesParAn) coutPacEuros] }] },

  { id := "O-91"
    titre := "Zones d'électrification industrielle : tarif d'électricité négocié, hors ZAN"
    source := s!"Texte Orientation D, mesure 91 ; consommation industrielle de la trajectoire « rapide » de RTE au lieu de la « lente » : +{zonesGwh} GWh par an en cinq ans ({zonesMw} MW) ; {zonesEmplois} emplois (ratio de Dunkerque) ; {zonesHa} ha hors ZAN (ratio des sites clés en main) ; tarif de long terme d'EDF sur une électricité sinon modulée, sans coût budgétaire (voir `zonesGwh`)"
    leviers := [.consommationElectrique (zonesGwh / 5), .implantations .industrie (zonesEmplois / 5),
                .annonceEmplois (zonesEmplois / 5), .artificialisationHorsZan .activites [zonesHa / 5]]
    repetitions := 5
    variantes := [
      { nom := "foncier dans l'enveloppe du ZAN",
        leviers := [.consommationElectrique (zonesGwh / 5), .implantations .industrie (zonesEmplois / 5),
                    .annonceEmplois (zonesEmplois / 5), .artificialisation .activites [zonesHa / 5]] }] },

  { id := "O-92"
    titre := "Déserts médicaux : 50 000 € à l'installation en zone prioritaire, puis 5 000 € par an pendant cinq ans"
    source := s!"Texte Orientation D, mesure 92 ; {installationsZip} premières installations de généralistes en zone prioritaire en 2025 (Cnam) ; aide portée de 10 000 à 50 000 € (ancienne CAIM) : {installationsZip * aideInstallationZip / 1000000} M€ par an ; 5 000 € par an pendant cinq ans (ancien COSCOM) : jusqu'à {primesZip.getLastD 0} M€ par an (voir `installationsZip`)"
    leviers := [.depenseSur .sante (installationsZip * aideInstallationZip / 1000000),
                .depenseEcheancier .sante primesZip]
    variantes := [
      { nom := "aide de 100 000 € à l'installation",
        leviers := [.depenseSur .sante (installationsZip * (100000 - 10000) / 1000000),
                    .depenseEcheancier .sante primesZip] }] },

  { id := "O-93"
    titre := "Minimum de pension des retraités agricoles porté à 100 % du SMIC net"
    source := s!"Texte Orientation D, mesure 93 ; garantie des chefs d'exploitation à carrière complète de 85 % à 100 % du SMIC net agricole (+214,30 € par mois) ; 224 681 bénéficiaires du complément différentiel (MSA, fin 2025) : {minimumAgricole} M€ par an (calcul, voir `minimumAgricole`)"
    leviers := [.depenseSur .retraites minimumAgricole]
    variantes := [
      { nom := "extrapolation de la loi Chassaigne de 2020 (283 M€ pour 10 points de SMIC) : 425 M€",
        leviers := [.depenseSur .retraites 425] }] },

  { id := "O-94"
    titre := "Emplois aidés ciblés sur l'industrie : 20 000 contrats initiative emploi"
    source := s!"Texte Orientation D, mesure 94 ; {contratsIndustrie} contrats en cours (hypothèse), aide de 47 % du SMIC brut (plafond du CIE) : {aideCieEuros} € par contrat et par an ; 0,16 emploi net par contrat (Dares) (voir `contratsIndustrie`)"
    leviers := [.emploisAides .industrie contratsIndustrie aideCieEuros 840]
    variantes := [
      { nom := "0,25 emploi net par contrat (emplois d'avenir du secteur marchand)",
        leviers := [.emploisAides .industrie contratsIndustrie aideCieEuros 750] }] },

  { id := "O-95"
    titre := "Divisions régionales de cybersécurité de la police : 18 divisions de 50 enquêteurs et ingénieurs"
    source := s!"Texte Orientation D, mesure 95 ; {agentsCyber} agents à {coutAgentPoliceEuros} € (coût moyen d'un emploi de la police nationale, PLF 2026) : {coutCyberPolice} M€ par an, recrutés en trois ans ; laboratoires 1 M€ par division (hypothèse) ; en plus de l'OFAC (720 enquêteurs en 2027) (voir `divisionsCyber`)"
    leviers := [.creationPostes .securiteJustice [agentsCyber / 3, 2 * agentsCyber / 3, agentsCyber] coutAgentPoliceEuros,
                .investissementEcheancier .securiteJustice [divisionsCyber, 0],
                .annonceEmplois agentsCyber] },

  { id := "O-96"
    titre := "Revenu minimum au niveau du SMIC net pendant les cinq premières années d'exploitation agricole"
    source := s!"Texte Orientation D, mesure 96 ; écart au SMIC des agriculteurs : 3,3 Md€ par an en moyenne 2015-2024 (Observatoire Max Havelaar) ; part des installés depuis moins de cinq ans (5 × {installationsAgricoles} sur {chefsExploitation} chefs, MSA) : {revenuMinimumInstalles} M€ par an en régime, une promotion de plus par an (calcul, voir `revenuMinimumInstalles`)"
    leviers := [.depenseEcheancier .affairesEconomiques revenuMinimumRampe]
    variantes := [
      { nom := "écart au SMIC de 2024 (5,22 Md€)",
        leviers := [.depenseEcheancier .affairesEconomiques
          (([1, 2, 3, 4, 5] : List Int).map fun k => 5220 * (5 * installationsAgricoles) / chefsExploitation * k / 5)] }] },

  { id := "O-97"
    titre := "Prime de 100 000 € à l'installation des médecins à Mayotte et en Guyane"
    source := s!"Texte Orientation D, mesure 97 ; densité de 76 (Mayotte) et 261 (Guyane) médecins pour 100 000 habitants contre 346 (Insee, 2025) ; {installationsOutreMer} installations par an pour atteindre la densité nationale en dix ans ; 20 000 € par an pendant cinq ans (voir `installationsOutreMer`)"
    leviers := [.depenseEcheancier .sante (primesOutreMer 20000)]
    variantes := [
      { nom := "prime de 50 000 €", leviers := [.depenseEcheancier .sante (primesOutreMer 10000)] }] },

  { id := "O-98"
    titre := "Accompagnement des entreprises en cybersécurité : chèque cyber pour 50 000 TPE et PME par an, Cybermalveillance.gouv.fr et CSIRT régionaux"
    source := s!"Texte Orientation D, mesure 98 ; chèque de 50 % des dépenses, au plus 2 500 € (TPE) ou 10 000 € (PME), modèle de l'Île-de-France ; 40 000 TPE et 10 000 PME par an (hypothèse) : {chequesCyber} M€ ; Cybermalveillance.gouv.fr à 3 M€ et CSIRT régionaux : {cyberGipCsirt} M€ (voir `chequesCyber`)"
    leviers := [.depenseSur .affairesEconomiques (chequesCyber + cyberGipCsirt)]
    variantes := [
      { nom := "chèque pour 25 000 entreprises par an", leviers := [.depenseSur .affairesEconomiques (chequesCyber / 2 + cyberGipCsirt)] }] },

  { id := "O-99"
    titre := "Amende automatique de 2 % du chiffre d'affaires mondial en cas de fuite de données massive dans une entreprise de plus de 50 M€ de chiffre d'affaires"
    source := s!"Texte Orientation D, mesure 99 ; plafond de l'article 83.4 du RGPD appliqué d'office au-delà d'un million de personnes touchées ; ≈ 40 violations par an de cette ampleur (CNIL) ; hypothèses : {fuitesAutomatiques} par an dans des entreprises de plus de 50 M€, {caMedianFuitesMeur} M€ de chiffre d'affaires médian, 95 % de recouvrement : {amendesFuitesSupplementaires} M€ par an (voir `amendesFuitesSupplementaires`)"
    leviers := [.recetteEcheancier none [amendesFuitesSupplementaires]]
    variantes := [
      { nom := "seuil relevé à 1 Md€ de chiffre d'affaires (5 fuites par an, 3 Md€ de chiffre d'affaires médian)",
        leviers := [.recetteEcheancier none [5 * 3000 * 2 / 100 * 95 / 100]] },
      { nom := "dissuasion complète : plus aucune fuite de cette ampleur", leviers := [] }] },

  { id := "O-100"
    titre := "2 000 douaniers de plus et contrôle renforcé des produits agricoles et industriels importés"
    source := s!"Texte Orientation D, mesure 100 ; {douaniersSupplementaires} douaniers (1 220 pour revenir aux plafonds de 2019, 780 pour les contrôles de conformité des importations) à {coutDouanierEuros} € (coût moyen du programme 302, PLF 2026) : {coutDouaniers} M€ par an, recrutés en trois ans ; recettes des contrôles non comptées (voir `douaniersSupplementaires`)"
    leviers := [.creationPostes .securiteJustice
                  [douaniersSupplementaires / 3, 2 * douaniersSupplementaires / 3, douaniersSupplementaires] coutDouanierEuros,
                .annonceEmplois douaniersSupplementaires] },

  { id := "O-101"
    titre := "Liberté d'installation des médecins ; aides aux déserts médicaux financées par une contribution des médecins des zones bien dotées"
    source := s!"Texte Orientation D, mesure 101 ; pas de régulation de l'installation ; contribution des généralistes libéraux des zones surdotées (un quart des {generalistesLiberaux2025}, hypothèse) égale au coût des aides d'O-92 et O-97 : {fondsDesertsMedicaux.getLastD 0} M€ par an au complet, {contributionMedecinEuros} € par médecin (voir `fondsDesertsMedicaux`)"
    leviers := [.recetteEcheancier (some .autres) fondsDesertsMedicaux] },

  { id := "O-102"
    titre := "Cotisations salariales réduites de 3 points dans les départements d'outre-mer"
    source := s!"Texte Orientation D, mesure 102 ; {salariesPrivesOutreMer} salariés du privé (Insee, fin 2024, en partie calculés) à {salaireBrutOutreMerEuros} € bruts par mois : masse salariale de {masseSalarialeOutreMer} M€ ; −3 points : {baisseCotisationsOutreMer} M€ par an (voir `baisseCotisationsOutreMer`)"
    leviers := [.prelevementSur .cotisations (-baisseCotisationsOutreMer)]
    variantes := [
      { nom := "−1,5 point", leviers := [.prelevementSur .cotisations (-(baisseCotisationsOutreMer / 2))] }] },

  { id := "O-103"
    titre := "Aide de 30 centimes par litre sur le GNR agricole, dégressive au rythme de l'électrification des exploitations"
    source := s!"Texte Orientation D, mesure 103 ; demande de la FNSEA (22 septembre 2026) ; {litresGnrAgricoles} millions de litres ; 1,11 Md€ par an, −10 % par an au rythme d'O-31, à zéro au terme du plan (voir `aideGnr`)"
    leviers := [.depenseEcheancier .affairesEconomiques (aideGnr 30)]
    variantes := [
      { nom := "15 centimes par litre (prolongement de l'aide de crise de 2026)",
        leviers := [.depenseEcheancier .affairesEconomiques (aideGnr 15)] }] },

  { id := "O-104"
    titre := "Coopérative d'État d'engrais azotés bas carbone : deux usines de 500 000 t, apport en capital de 2,6 Md€ de 2027 à 2035"
    source := s!"Texte Orientation D, mesure 104 ; usines sur le modèle de FertigHy (1,3 Md€ chacune, 500 000 t de CAN27, 15 % de la consommation française ; AFP, mai 2024) ; apport de {capitalEngrais} M€ par an pendant neuf ans (dette sans déficit) (voir `capitalEngrais`)"
    leviers := [.prisesDeParticipation capitalEngrais] },

  { id := "O-104b"
    titre := "Production de la coopérative d'engrais : première usine en service en 2031"
    source := s!"Texte Orientation D, mesure 104 ; 250 emplois directs (FertigHy) ; {ammoniacParUsineKt} 000 t d'ammoniac à 12,12 MWh par tonne (AFT, ALTERFI) : {electriciteEngraisGwh} GWh d'électricité par an (voir `electriciteEngraisGwh`)"
    leviers := [.implantations .industrie 250, .annonceEmplois 250, .consommationElectrique electriciteEngraisGwh]
    debut := 4 },

  { id := "O-105"
    titre := "Légalisation encadrée du cannabis après référendum : vente sous licence aux majeurs, 9 € le gramme"
    source := s!"Texte Orientation D, mesure 105 ; hypothèse d'un oui au référendum de 2027, ventes en 2029 ; modèle du CAE (note n° 52, 2019) : {acciseCannabisCentimes} centimes d'accise et {tvaCannabisCentimes} de TVA par gramme ; {cannabisTonnes} t (OFDT, 2023) ; part légale portée à 72 % en cinq ans (Canada, 2024) : accise jusqu'à {acciseCannabis.getLastD 0} M€, TVA {tvaCannabis.getLastD 0} M€ ; 10 % de l'accise à la prévention ; amendes forfaitaires perdues : {recettesAfd} M€ (voir `cannabisTonnes`)"
    leviers := [.recetteEcheancier (some .autres) acciseCannabis,
                .recetteEcheancier (some .tva) tvaCannabis,
                .depenseEcheancier .sante preventionCannabis,
                .recetteEcheancier none [-recettesAfd]]
    debut := 2
    variantes := [
      { nom := "moitié des coûts de police et de justice de la répression économisée (255 M€)",
        leviers := [.recetteEcheancier (some .autres) acciseCannabis,
                    .recetteEcheancier (some .tva) tvaCannabis,
                    .depenseEcheancier .sante preventionCannabis,
                    .recetteEcheancier none [-recettesAfd],
                    .economieSur .securiteJustice (repressionCannabis * 90 / 100 / 2)] }] },

  { id := "O-105b"
    titre := "Filière légale du cannabis : production et distribution sous licence (emplois)"
    source := s!"Texte Orientation D, mesure 105 ; 55 emplois par tonne (CAE, bas de la fourchette) sur la part légale du marché : {emploisCannabisAnnuels} emplois de plus chaque année de 2029 à 2033, dont {emploisCannabisAgriculture} dans l'agriculture (voir `emploisCannabisAnnuels`)"
    leviers := [.implantations .agriculture emploisCannabisAgriculture,
                .implantations .tertiaireMarchand (emploisCannabisAnnuels - emploisCannabisAgriculture),
                .annonceEmplois emploisCannabisAnnuels]
    debut := 2
    repetitions := 5 },

  { id := "O-106"
    titre := "Légalisation de la prostitution sur le modèle allemand après référendum : activité déclarée, établissements autorisés, fin de la pénalisation des clients"
    source := s!"Texte Orientation D, mesure 106 ; hypothèse d'un oui au référendum de 2027 ; manque à gagner de {manqueAGagnerProstitution} M€ (ProstCost, 2015, contesté) ; part déclarée de {partDeclareeProstitutionPm} ‰, celle de l'Allemagne (32 300 enregistrées sur 200 000 à 400 000) : {recettesProstitution} M€ par an à partir de 2029 (voir `recettesProstitution`)"
    leviers := [.prelevementSur .cotisations recettesProstitution]
    debut := 2
    variantes := [
      { nom := "estimation basse du nombre de personnes en Allemagne (200 000) : 16 % déclarés",
        leviers := [.prelevementSur .cotisations (manqueAGagnerProstitution * 32300 / 200000)] }] },

  { id := "O-107"
    titre := "Rénovation des passoires thermiques dans les villes moyennes : 27 670 rénovations d'ampleur de plus par an"
    source := s!"Texte Orientation D, mesure 107 ; 244 villes Action cœur de ville (23 % de la population) ; {renovationsAmpleur2025} rénovations d'ampleur en 2025 (Anah), {renovationsVillesMoyennes} de plus par an à {aideRenovationAmpleurEuros} € d'aide ; {economieRenovationAmpleurKWh} kWh économisés par logement (SDES) ; 1,12 Md€ par an (voir `renovationsVillesMoyennes`)"
    leviers := [.renovationsAmpleur .national renovationsVillesMoyennes aideRenovationAmpleurEuros economieRenovationAmpleurKWh]
    variantes := [
      { nom := "moitié du volume (13 835 rénovations par an)",
        leviers := [.renovationsAmpleur .national (renovationsVillesMoyennes / 2) aideRenovationAmpleurEuros economieRenovationAmpleurKWh] }] },

  { id := "O-108"
    titre := "Décarbonation des sites industriels : 3,25 Mt évitées de plus chaque année de 2027 à 2030, 3,97 Md€ d'aides par an"
    source := s!"Texte Orientation D, mesure 108 ; écart de 8 Mt à l'objectif SNBC-3 de l'industrie en 2030, porté à 13 Mt en octobre 2026 pour tenir le plafond de 300 Mt (voir `ktSupplementairesIndustrie`) ; soutien public de {soutienParMt} M€ par Mt évitée (DGE, 22 Md€ de 2024 à 2030 pour 18 Mt) : {aideDecarbonation + aideDecarbonationSupplementaire} M€ par an pendant quatre ans (voir `soutienParMt`)"
    leviers := [.depenseEcheancier .affairesEconomiques [aideDecarbonation + aideDecarbonationSupplementaire, 0],
                .transition .industrie mtParAnIndustrie 0, .transitionKt .industrie ktSupplementairesIndustrie 0]
    repetitions := 4
    variantes := [
      { nom := "2 Mt par an (version précédente, objectif SNBC-3 de l'industrie)",
        leviers := [.depenseEcheancier .affairesEconomiques [aideDecarbonation, 0], .transition .industrie mtParAnIndustrie 0] }] },

  { id := "O-109"
    titre := "Ehpad publics : 52 000 places de plus, construites de 2027 à 2031"
    source := s!"Texte Orientation D, mesure 109 ; part publique (48 %) des 108 000 résidents de plus en 2030 (DREES) : {placesEhpadPubliques} places, {placesEhpadParAn} par an à {coutPlaceEhpadEuros} € (Anap-CNSA 2012, actualisé par l'ICC) : {investissementEhpad} M€ par an pendant cinq ans (voir `placesEhpadPubliques`)"
    leviers := [.investissementEcheancier .sante [investissementEhpad, investissementEhpad, investissementEhpad,
                                                  investissementEhpad, investissementEhpad, 0]] },

  { id := "O-109b"
    titre := "Ehpad publics : fonctionnement des places ouvertes (soins et APA)"
    source := s!"Texte Orientation D, mesure 109 ; {fonctionnementPlaceEhpadEuros} € par place et par an à la charge des administrations (soins 12 755 €, APA 338 € par mois, 2019) : jusqu'à {fonctionnementEhpad.getLastD 0} M€ par an en 2032 (voir `fonctionnementEhpad`)"
    leviers := [.depenseEcheancier .sante fonctionnementEhpad]
    debut := 1 },

  { id := "O-110"
    titre := "Police de proximité : 20 000 adjoints de sécurité et 6 700 policiers pour les encadrer"
    source := s!"Texte Orientation D, mesure 110 ; 39 015 € par adjoint (hypothèse), {coutTitulairePoliceEuros} € par titulaire (moyenne de la police nationale, AN n° 1996, calcul), {coutPoliceProximite} M€ par an en année pleine, montée en charge en cinq ans ; BAC maintenues (voir `coutPoliceProximite`)"
    leviers := [.creationPostes .securiteJustice agentsProximite coutAgentProximiteEuros,
                .annonceEmplois (adjointsSecurite + encadrantsProximite)] },

  { id := "O-111"
    titre := "Bpifrance : 5 % des financements orientés vers des projets choisis par un vote en ligne, avec identification par FranceConnect"
    source := s!"Texte Orientation D, mesure 111 ; {financementsBpifrance} M€ injectés par Bpifrance en 2025 : {financementsVotes} M€ par an soumis au vote, parmi des projets instruits par la banque ; un vote par personne, identifiée par FranceConnect ; opérations financières hors solde public (voir `financementsVotes`)"
    leviers := [] },

  { id := "O-112"
    titre := "Titres de séjour : 500 agents de plus dans les préfectures pour réduire les délais"
    source := s!"Texte Orientation D, mesure 112 ; {agentsPrefectures} emplois à {coutAgentPrefectureEuros} € (amendement II-333 au PLF 2026) : {renfortPrefectures} M€ par an (voir `renfortPrefectures`)"
    leviers := [.creationPostes .fonctionnement [agentsPrefectures] coutAgentPrefectureEuros, .annonceEmplois agentsPrefectures]
    variantes := [
      { nom := "1 000 agents", leviers := [.creationPostes .fonctionnement [2 * agentsPrefectures] coutAgentPrefectureEuros, .annonceEmplois (2 * agentsPrefectures)] }] },

  { id := "O-113"
    titre := "Algérie : réponse aux demandes mémorielles (archives, disparus, essais nucléaires, restes humains)"
    source := s!"Texte Orientation D, mesure 113 ; copie numérique des archives (2 M€ par an pendant cinq ans, hypothèse) ; {victimesAlgeriennes} victimes des essais indemnisées en dix ans (hypothèse) à {indemniteMoyenneCivenEuros} € (moyenne du CIVEN) ; fonds de dépollution de 100 M€ sur cinq ans (hypothèse) ; versements en Algérie hors demande intérieure (voir `transfertsAlgerie`)"
    leviers := [.depenseEcheancier .culture archivesAlgerie, .recetteEcheancier none transfertsAlgerie]
    variantes := [
      { nom := "5 000 victimes indemnisées en dix ans",
        leviers := [.depenseEcheancier .culture archivesAlgerie,
                    .recetteEcheancier none (transfertsAlgerie.map fun x => if x = 0 then 0 else x - 4 * indemnisationAlgerie)] }] },

  { id := "O-114"
    titre := "Haïti : remboursement des sommes versées au titre de l'indemnité de 1825 (485 M€ en cinq ans)"
    source := s!"Texte Orientation D, mesure 114 ; {sommesVerseesHaitiMusd} M$ actuels versés par Haïti (New York Times, 2022), {remboursementHaiti} M€ au cours de la BCE du 16 septembre 2026 ; fonds franco-haïtien, versements à l'étranger (voir `remboursementHaiti`)"
    leviers := [.recetteEcheancier none (versementsHaiti.map (- ·))]
    variantes := [
      { nom := "bas des pertes de croissance estimées (21 Md$) en vingt ans",
        leviers := [.recetteEcheancier none (List.replicate 20 (-(pertesHaitiBasses / 20)) ++ [0])] }] },

  { id := "O-115"
    titre := "Afrique : restitution des biens culturels, recherche de provenance, reconnaissance d'actes coloniaux"
    source := s!"Texte Orientation D, mesure 115 ; 90 000 objets d'Afrique subsaharienne dans les collections publiques (Sarr-Savoy, 2018) ; recherche de provenance portée à {provenanceAfrique} M€ par an (hypothèse) ; appui aux musées des pays bénéficiaires, 35 M€ tous les deux ans (hypothèse) ; reconnaissances sans coût (voir `provenanceAfrique`)"
    leviers := [.depenseSur .culture provenanceAfrique, .recetteEcheancier none appuiMuseesEcheancier] },

  { id := "O-116"
    titre := "Zones commerciales densifiées : parkings mutualisés en silo, 105 ha libérés par an pour les activités"
    source := s!"Texte Orientation D, mesure 116 ; 50 000 ha de zones d'entrée de ville (gouvernement), 28 % de parkings (Institut Paris Région) ; 10 % traités en dix ans (hypothèse) : {placesSiloParAn} places en silo par an à {coutPlaceSiloEuros} € (RNA 2019), 30 % par l'État (hypothèse) : {aideSilos} M€ par an ; {haLiberesParAn} ha libérés par an (voir `aideSilos`)"
    leviers := [.investissementEcheancier .logementEnvironnement ((List.replicate 10 aideSilos) ++ [0]),
                .artificialisation .activites ((List.replicate 9 (-haLiberesParAn)))] },

  { id := "O-117"
    titre := "Fret ferroviaire augmenté de moitié : part modale de 8,9 % à 13,4 % en 2032, plan d'investissement et aide au wagon isolé relevés de 50 %"
    source := s!"Texte Orientation D, mesure 117 ; {fretReporteMtkm} millions de tonnes-km reportées de la route à {mgCo2ParTkm} mg par tonne-km (SDES, Citepa) : {co2EviteFretKt} kt évitées en 2032 ; +50 % (au lieu du doublement du texte) : Ulysse Fret ({investissementFret} M€ par an de plus de 2027 à 2032) et wagon isolé (+{aideWagonIsole} M€ par an) (voir `co2EviteFretKt`)"
    leviers := [.investissementEcheancier .affairesEconomiques ((List.replicate 6 investissementFret) ++ [0]),
                .depenseSur .affairesEconomiques aideWagonIsole] },

  { id := "O-117b"
    titre := "Fret ferroviaire : émissions des poids lourds évitées (montée en six ans)"
    source := s!"Texte Orientation D, mesure 117 ; {co2EviteFretParAnKt} kt de CO₂e évitées de plus chaque année de 2027 à 2032 (voir `co2EviteFretParAnKt`)"
    leviers := [.transitionKt .transports co2EviteFretParAnKt 0]
    repetitions := 6 },

  { id := "O-118"
    titre := "Autoroutes à vitesse libre sur certains tronçons (10 % du réseau), sur le modèle allemand"
    source := s!"Texte Orientation D, mesure 118 ; {troncons} km (10 % de 11 752 km, hypothèse) ; 6,7 Mt évitées en Allemagne par une limite à 120 km/h sur ≈ {autobahnLibreKm} km libres (UBA 2023, BASt) ; moitié pour 130 km/h → libre (hypothèse) : +{hausseCo2AutobahnKt} kt par an ; accidentalité non modélisée (voir `hausseCo2AutobahnKt`)"
    leviers := [.transitionKt .transports (-hausseCo2AutobahnKt) 0]
    variantes := [
      { nom := "20 % du réseau", leviers := [.transitionKt .transports (-(2 * hausseCo2AutobahnKt)) 0] }] },

  { id := "O-119"
    titre := "Plan contre les fuites d'eau : 1 Md€ par an pendant cinq ans pour renouveler les canalisations"
    source := s!"Texte Orientation D, mesure 119 ; 1 milliard de m³ perdus par an, un litre sur cinq (SISPEA) ; {fondsFuitesEau} M€ par an (1,5 Md€ de l'amendement n° 2034 au PLF 2025, moins 500 M€), cinq ans (hypothèse) (voir `fondsFuitesEau`)"
    leviers := [.investissementEcheancier .logementEnvironnement ((List.replicate 5 fondsFuitesEau) ++ [0])]
    variantes := [
      { nom := "1,5 Md€ par an (version précédente, amendement n° 2034)",
        leviers := [.investissementEcheancier .logementEnvironnement ((List.replicate 5 1500) ++ [0])] }] },

  { id := "O-120"
    titre := "Grand âge : salaires des 475 000 aides à domicile revalorisés de 10 %"
    source := s!"Texte Orientation D, mesure 120 ; {aidesDomicile} aides à domicile, {revenuNetAideDomicileEuros} € nets par an en moyenne (DREES, 2025) ; +10 % (hypothèse) par l'APA et le crédit d'impôt : {revalorisationAidesDomicile} M€ par an (voir `revalorisationAidesDomicile`)"
    leviers := [.depenseSur .sante revalorisationAidesDomicile] },

  { id := "O-121"
    titre := "Écoles : 90 000 enseignants, AESH et infirmières scolaires de plus en quatre ans"
    source := s!"Texte Orientation D, mesure 121 ; {postesEcole} postes à {coutPosteEcoleEuros} € (4 000 postes = 150 M€, gouvernement, janvier 2025) : {postesEcoleEcheancier.getLastD 0} M€ par an en 2030, recrutés en quatre ans (voir `postesEcoleEcheancier`)"
    leviers := [.creationPostes .enseignement postesEcoleCumul coutPosteEcoleEuros, .annonceEmplois postesEcole] },

  { id := "O-122"
    titre := "Pouvoir d'achat : cotisations salariales réduites d'un demi-point pour tous les salariés"
    source := s!"Texte Orientation D, mesure 122 ; 0,5 % des {masseSalarialeBrute2025} M€ de salaires bruts de 2025 (Insee) : {baisseCotisationsSalariales} M€ par an (voir `baisseCotisationsSalariales`)"
    leviers := [.prelevementSur .cotisations (-baisseCotisationsSalariales)]
    variantes := [
      { nom := "un point entier", leviers := [.prelevementSur .cotisations (-pointCotisationsSalariales)] }] },

  { id := "O-123"
    titre := "Solaire : 3 000 € d'aide pour 3 kWc sur le toit de 50 000 ménages modestes par an"
    source := s!"Texte Orientation D, mesure 123 ; prime à l'autoconsommation supprimée le 1er juin 2026 ; ≈ 2 000 € par kWc (Selectra) ; moitié payée pour {installationsSolaires} installations par an (hypothèse) : {aideSolaire} M€ et {mwSolaireParAn} MW par an sur toiture (voir `aideSolaire`)"
    leviers := [.depenseSur .logementEnvironnement aideSolaire, .solaireToiture mwSolaireParAn] },

  { id := "O-124"
    titre := "Composante carbone remise sur sa trajectoire : 100 €/t en 2030, 2,5 Md€ reversés en chèque énergie"
    source := s!"Loi n° 2015-992, art. 1 (100 €/t en 2030) ; composante gelée à 44,6 €/t depuis 2018 ; +55,4 €/t en quatre étapes (2027-2030) sur les voitures particulières ({assietteVoituresKt} kt) et le chauffage au fioul et au gaz ({assietteChauffageKt} kt) ; rendement statique {rendementCarboneVoitures + rendementCarboneChauffage} M€, dont {chequeCarbone} M€ reversés en chèque énergie (voir `assietteVoituresKt`) ; recul des activités selon les élasticités-prix du modèle commun"
    leviers := [.taxeEnvironnementale .carburantsRoutiers .accisesEnergie assietteVoituresKt 24 (rendementCarboneVoitures / 4),
                .taxeEnvironnementale .chauffageFossile .accisesEnergie assietteChauffageKt 31 (rendementCarboneChauffage / 4),
                .depenseSur .famille (chequeCarbone / 4)]
    repetitions := 4
    variantes := [
      { nom := "moitié du rendement reversée en chèque énergie (version précédente, 3,1 Md€)",
        leviers := [.taxeEnvironnementale .carburantsRoutiers .accisesEnergie assietteVoituresKt 24 (rendementCarboneVoitures / 4),
                    .taxeEnvironnementale .chauffageFossile .accisesEnergie assietteChauffageKt 31 (rendementCarboneChauffage / 4),
                    .depenseSur .famille (chequeCarboneMoitie / 4)] },
      { nom := "≈ 488 €/t en 2030 (essai : hausse multipliée par 8)",
        leviers := [.taxeEnvironnementale .carburantsRoutiers .accisesEnergie assietteVoituresKt (24 * multipleCarboneEssai) (multipleCarboneEssai * rendementCarboneVoitures / 4),
                    .taxeEnvironnementale .chauffageFossile .accisesEnergie assietteChauffageKt (31 * multipleCarboneEssai) (multipleCarboneEssai * rendementCarboneChauffage / 4),
                    .depenseSur .famille (multipleCarboneEssai * chequeCarbone / 4)] }] },

  { id := "O-125"
    titre := "Amendes proportionnelles aux revenus, sans pouvoir être inférieures au montant actuel"
    source := s!"Sur le modèle des jours-amendes nordiques ; amendes de la circulation et du stationnement : {amendesCirculation} M€ en 2025 (Cour des comptes) ; montant actuel × niveau de vie / niveau de vie médian, plancher au montant actuel : +{recettesAmendesProportionnelles} M€ par an (Insee 2024, calcul ; voir `recettesAmendesProportionnelles`)"
    leviers := [.recetteEcheancier none [recettesAmendesProportionnelles]] },

  { id := "O-127"
    titre := "Contrats aidés non marchands : 175 000 parcours emploi compétences, aidés à 60 %"
    source := s!"32 000 PEC financés en 2025 (DGEFP) ; {contratsAidesParAn} de plus en 2027 puis en 2028, à {aideContratAideEuros} € par contrat et par an (60 % du SMIC brut sur 26 heures) ; 0,6 emploi net par contrat (Insee, décembre 2019) (voir `contratsAidesParAn`)"
    leviers := [.emploisAides .tertiaireNonMarchand contratsAidesParAn aideContratAideEuros 400]
    repetitions := 2
    variantes := [
      { nom := "200 000 contrats (version précédente)",
        leviers := [.emploisAides .tertiaireNonMarchand 100000 aideContratAideEuros 400] }] },

  { id := "O-128"
    titre := "Leasing social électrique : 135 000 voitures par an à 100 € par mois"
    source := s!"{leasingSocialParAn} voitures par an à {leasingSocialAideEuros} € d'aide (coût unitaire de PP-04) ; 50 000 voitures par édition depuis 2024 ; émissions évitées par le sous-modèle automobile (voir `leasingSocialParAn`)"
    leviers := [.aideAchatElectrique leasingSocialParAn leasingSocialAideEuros .modestes]
    variantes := [
      { nom := "150 000 voitures par an (version précédente)",
        leviers := [.aideAchatElectrique 150000 leasingSocialAideEuros .modestes] }] },

  { id := "O-129"
    titre := "Rémunération des dirigeants d'institutions publiques (Louvre, DGFiP, Haut-commissariat au plan…) : −20 %"
    source := s!"{cadresDirigeants} cadres dirigeants de l'État (Diese, 2025), {dirigeantsOperateurs} opérateurs (jaune, PLF 2026), {presidentsAutorites} autorités indépendantes ; 15 points de plus qu'O-49 pour les cadres dirigeants, 20 pour les autres ; coût complet × 1,5 : économie {economieDirigeants} M€ (voir `economieDirigeants`)"
    leviers := [.remunerationPublique .traitement .fonctionnement [-economieDirigeants]] },

  { id := "O-130"
    titre := "Un commissariat dans chaque ville de plus de 30 000 habitants"
    source := s!"{communesZoneGendarmerie30000} villes en zone gendarmerie (La Réunion, Saint-Laurent-du-Maroni) passées en police d'État : {policiersCommissariats} policiers (un pour {habitantsParPolicier} habitants) à {coutPolicierEuros} € ; {communesZonePoliceSansCommissariat} villes en zone police sans commissariat (hypothèse), servies par leur circonscription ; {investissementCommissariats} M€ de construction de 2027 à 2030 (voir `policiersCommissariats`)"
    leviers := [.creationPostes .securiteJustice postesCommissariats coutPolicierEuros,
                .investissementEcheancier .securiteJustice
                  ((List.replicate 4 (investissementCommissariats / 4)) ++ [0])] },

  { id := "O-131"
    titre := "Indemnisation forfaitaire des personnes blessées lors d'une intervention de police ou de gendarmerie"
    source := s!"{forfaitBlesseGraveEuros} € au-delà de 8 jours d'ITT ({blessesGraves} blessés par an, IGPN et IGGN), {forfaitBlesseLegerEuros} € en deçà ({blessesLegers}, hypothèse) : {indemnisationBlesses} M€ par an (voir `indemnisationBlesses`)"
    leviers := [.depenseSur .famille indemnisationBlesses] },

  { id := "O-132"
    titre := "Escroquerie : la victime remboursée par l'escroc condamné, préjudice majoré de 100 %"
    source := "Sans avance de l'État : aucun effet budgétaire direct. 448 300 victimes d'escroqueries et de fraudes aux moyens de paiement enregistrées en 2025 (réponse à la question écrite n° 16778, 2026) ; préjudice de 4,5 Md€ en 2023 (SSMSI, Interstats Analyse n° 68) ; 23 % des escroqueries élucidées à un an (Insee, 2021) ; recouvrement auprès des condamnés de 11 % en 2010 (SARVI). Dommages punitifs absents du droit français (réparation intégrale) : innovation législative"
    leviers := [] },

  { id := "O-133"
    titre := "Second porte-avions de nouvelle génération"
    source := s!"Premier PANG : {coutPremierPorteAvions} M€ (LFI 2025) ; second à −30 % d'effet de série : {coutSecondPorteAvions} M€, dont {echeancierPorteAvions.foldl (· + ·) 0} M€ d'ici 2035 (études, chaufferies, début de réalisation ; voir `echeancierPorteAvions`)"
    leviers := [.depenseEcheancier .defense echeancierPorteAvions] },

  { id := "O-134"
    titre := "Programme de lancements de satellites sur lanceurs français et européens"
    source := s!"Deux Ariane 62 et un Vega-C de plus par an (prix des contrats de l'ESA) et des achats d'ancrage de mini-lanceurs français : {programmeLancements} M€ par an, lancement seul (voir `programmeLancements`)"
    leviers := [.depenseSur .enseignement programmeLancements] },

  { id := "O-135"
    titre := "Plan méthane des déchets : captage du biogaz des décharges porté de 45 % à 55 % en 2030, TGAP modulée selon le captage, aide aux biodéchets rétablie, Fonds économie circulaire ramené à son niveau de 2024"
    source := s!"Stockage : {emissionsStockageKt} kt CO₂e en 2024 (Secten 2026) ; captage aidé à 50 % (hypothèse) à {coutAbattementCaptageEuros} €/t évitée (E-CUBE, 2023) : {aideCaptageBiogaz} M€, contrôles {controlesIsdnd} M€, biodéchets {aideBiodechets} M€ (Fonds vert), Fonds économie circulaire +{fondsEconomieCirculaire2024 - fondsEconomieCirculaire2026} M€ (Sénat) : {planMethaneDechets} M€ par an (voir `planMethaneDechets`)"
    leviers := [.depenseSur .logementEnvironnement planMethaneDechets] },

  { id := "O-135b"
    titre := "Plan méthane des déchets : émissions évitées par le captage (montée en quatre ans)"
    source := s!"2,5 points de captage de plus par an à {ktParPointCaptage} kt par point (calcul, GIEC, méthane projeté en 2028) : {captageEviteParAnKt} kt de plus chaque année de 2027 à 2030 ; détournement du stockage supposé dans la tendance (voir `captageEviteParAnKt`)"
    leviers := [.transitionKt .dechets captageEviteParAnKt 0]
    repetitions := anneesMontee
    variantes := [
      { nom := "+7 points de captage en 2030 au lieu de +10",
        leviers := [.transitionKt .dechets (ktParPointCaptage * pointsCaptageBas / anneesMontee) 0] }] },

  { id := "O-136"
    titre := "Plan azote et effluents : fosses à lisier couvertes avec torchère dans 5 000 élevages de 2027 à 2030, aidées à 60 %"
    source := s!"{elevagesFossesParAn} élevages par an, {investissementFosseEuros} € d'investissement (INRA 2013, +30 %, hypothèse) aidés à 60 % (hypothèse) : {aideFosses} M€ par an de 2027 à 2030 (voir `aideFosses`)"
    leviers := [.depenseEcheancier .affairesEconomiques ((List.replicate anneesMontee aideFosses) ++ [0])] },

  { id := "O-136b"
    titre := "Plan azote et effluents : fosses couvertes, 300 000 ha de légumineuses et additif anti-méthane pour 300 000 vaches laitières en 2030, émissions évitées (montée en quatre ans)"
    source := s!"Fosses couvertes {tonnesEviteesParFosse} t par élevage (hypothèse), légumineuses {legumineusesEviteesKt azoteEviteKgParHa} kt ({azoteEviteKgParHa} kg d'azote par ha, hypothèse), additif {additifEviteKt} kt ({evitementAdditifKgParVache} kg par vache) : {agricultureEviteeParAnKt} kt de plus chaque année de 2027 à 2030 ; aides aux légumineuses et à l'additif : {aidesAgricolesParAn} M€ de plus chaque année de 2027 à 2030, puis reconduites (voir `agricultureEviteeParAnKt`)"
    leviers := [.transitionKt .agriculture agricultureEviteeParAnKt 0,
                .depenseSur .affairesEconomiques aidesAgricolesParAn]
    repetitions := anneesMontee
    variantes := [
      { nom := "hypothèses basses : 95 t par élevage, 80 kg d'azote par ha, additif non pris en compte par l'inventaire",
        leviers := [.transitionKt .agriculture agricultureEviteeParAnBasKt 0,
                    .depenseSur .affairesEconomiques aidesAgricolesParAn] }] },

  { id := "O-137"
    titre := "Déchetteries publiques gratuites pour tous, artisans compris et sans quota, contre les dépôts sauvages"
    source := s!"Recettes des professionnels perdues {recettesProsDechetteries recettesProsCentimesParHabitant} M€ (1 € par habitant, hypothèse) et quotas {quotasDechetteries} M€, compensées par l'État ; {tonnagesDechetteriesKt} kt reçues en plus (hypothèse) à {coutMarginalDechetterieEurosParT} €/t : {tonnagesDechetteries tonnagesDechetteriesKt} M€ ; nettoyage des dépôts sauvages évité : {nettoyageEvite} M€ (voir `nettoyageEvite`)"
    leviers := [.recetteEcheancier none [-(recettesProsDechetteries recettesProsCentimesParHabitant + quotasDechetteries)],
                .depenseSur .logementEnvironnement (tonnagesDechetteries tonnagesDechetteriesKt),
                .economieSur .logementEnvironnement nettoyageEvite]
    variantes := [
      { nom := "fourchette haute : 2 € par habitant de recettes perdues, 1 Mt reçue en plus",
        leviers := [.recetteEcheancier none [-(recettesProsDechetteries recettesProsCentimesParHabitantHaut + quotasDechetteries)],
                    .depenseSur .logementEnvironnement (tonnagesDechetteries tonnagesDechetteriesHautKt),
                    .economieSur .logementEnvironnement nettoyageEvite] }] },

  { id := "O-138"
    titre := "Rétrofit électrique massif : 540 000 voitures thermiques converties de 2027 à 2030"
    source := s!"Mesure originale (octobre 2026) ; {retrofitsParAn} conversions par an pendant quatre ans, ordre de grandeur du scénario haut de l'ADEME (2021) ; aide de {aideRetrofitEuros} € (17 500 € de coût moins 3 000 € de consentement à payer, Forum Vies Mobiles 2024) ; 60 % du kit importé (hypothèse), soit 35 % de la valeur de la conversion ; risque d'exécution très élevé (≈ 740 conversions par an en 2025) (voir `aideRetrofitEuros`)"
    leviers := [.retrofitElectrique retrofitsParAn aideRetrofitEuros partImporteeKitPm 0]
    repetitions := anneesRetrofit
    variantes := [{ nom := "obligation de verdissement des flottes d'entreprises et de location, +100 000 voitures par an chaque année, sans coût public (hypothèse)", leviers :=
      [.aideAchatElectrique 100000 0 .obligation] }] },
  { id := "O-139"
    titre := "Drones de masse et bouclier anti-drones des points d'importance vitale"
    source := s!"Mesure originale (octobre 2026), en plus de la loi n° 2026-791 ; drones : {coutDronesParAn} M€ par an (3 000 munitions téléopérées longue portée à 110 000 €, 25 000 FPV à 4 000 €, 20 000 micro-drones à 1 000 €) ; anti-drones : {systemesAntiDrones} systèmes de type PARADE à 5,5 M€ de 2027 à 2030 ; {defenseOriginale} M€ (voir `defenseOriginale`)"
    leviers := [.depenseEcheancier .defense defenseOriginale] },
  { id := "O-140"
    titre := "Captation de la moitié de la plus-value des terrains rendus constructibles"
    source := s!"Mesure originale (octobre 2026), sur le modèle suisse (au moins 20 %, loi sur l'aménagement du territoire) ; 12 000 ha consommés par an (hypothèse, 15 119 en 2024, Cerema), dont 69 % vendus, 223 400 € de plus-value par ha (Safer 2024, calcul), taux de 50 %, rétention foncière de 20 % (hypothèse), moins les taxes existantes (≈ 100 M€) ; moitié la première année : {captationPlusValues} M€ (voir `captationPlusValues`)"
    leviers := [.recetteEcheancier (some .patrimoine) captationPlusValues] },
  { id := "O-141"
    titre := "Contribution de 50 % sur la rémunération des réserves excédentaires des banques"
    source := s!"Mesure originale (octobre 2026) ; ≈ 21 % de la liquidité excédentaire de la zone euro (Banque de France, BCE), en baisse avec la réduction des portefeuilles de politique monétaire (enquête de la BCE, septembre 2026), au taux de la facilité de dépôt, érosion de 20 % : {contributionReserves} M€ (euros 2027) de 2027 à 2030 (voir `contributionReserves`) ; risque juridique élevé (compétence de la BCE)"
    leviers := [.recetteEcheancier (some .impotSocietes) contributionReserves] },
  { id := "O-142"
    titre := "Biokérosène porté à 20 % du kérosène des vols intérieurs en 2030, surcoût payé par l'État"
    source := s!"3,5 points de plus par an de 2027 à 2030 au-delà de ReFuelEU (6 % en 2030) : {biokeroseneAnnuelKt} kt de plus chaque année (1,33 Mt de kérosène domestique, Citepa 2024, calcul), {biokeroseneEviteKt} kt de CO₂ évitées (3,15 t par t) pour {biokeroseneCout} M€ (surcoût du HEFA de 1 285 €/t, EASA 2025) ; biokérosène affecté aux vols intérieurs (hypothèse ; variante : répartition au prorata, DGAC) (voir `biokeroseneAnnuelKt`)"
    leviers := [.transitionKt .transports biokeroseneEviteKt 0, .depenseSur .affairesEconomiques biokeroseneCout]
    repetitions := anneesBiokerosene
    variantes := [{ nom := "répartition au prorata des ventes (DGAC) : ≈ 20 % de l'effet compté", leviers :=
      [.transitionKt .transports biokeroseneProrataKt 0, .depenseSur .affairesEconomiques biokeroseneCout] }] },
  { id := "O-142b"
    titre := "Biokérosène : ReFuelEU impose 20 % en 2035, l'écart de la mesure disparaît"
    source := s!"Règlement (UE) 2023/2405, annexe I : 20 % de carburant aviation durable en 2035 ; les {anneesBiokerosene * biokeroseneEviteKt} kt et {anneesBiokerosene * biokeroseneCout} M€ d'O-142 sortent en 2035"
    leviers := [.transitionKt .transports (0 - (anneesBiokerosene : Int) * biokeroseneEviteKt) 0,
                .depenseSur .affairesEconomiques (0 - (anneesBiokerosene : Int) * biokeroseneCout)]
    debut := 8 },
  { id := "O-143"
    titre := "Frein automatique au déficit : au-delà de 5,5 % du PIB, norme de dépense durcie de 5 points l'année suivante"
    source := s!"Mesure originale (octobre 2026), inspirée des freins à l'endettement suisse et allemand (qui portent, eux, sur le solde corrigé du cycle) ; seuil de {freinSeuilPb} pb, durcissement de {freinNormePb} pb de la norme des fonctions pilotables (santé, affaires économiques, sécurité et justice, logement et environnement, culture, services généraux) l'année qui suit un déficit au-dessus du seuil ; calé pour ne jouer que dans les scénarios défavorables (hypothèse)"
    leviers := [.freinDeficit freinSeuilPb freinNormePb]
    variantes := [{ nom := "seuil de 4,5 %, durcissement de 2 points (joue au scénario central)", leviers := [.freinDeficit 450 200] }] },
  { id := "O-144"
    titre := "Centrales au fioul des outre-mer converties au bioliquide dès 2027-2028"
    source := s!"Mesure originale (octobre 2026) : avance de cinq ans le plan « Émeraude » d'EDF (≈ 2,5 Mt par an en 2033) pour Pointe Jarry, Bellefontaine et Mayotte ; {emissionsZniEviteesKt} kt évitées par an en 2027 et en 2028 (1,5 Mt hors Port Est, Larivot et Ricanto, déjà engagés) ; {coutZni} M€ de charges de service public par étape ({coutTonneZniEuros} €/t, ratio de Port Est, CRE 2022) (voir `coutZni`)"
    leviers := [.transitionKt .energie emissionsZniEviteesKt 0, .depenseSur .affairesEconomiques coutZni]
    repetitions := 2 },
  { id := "O-144b"
    titre := "Centrales des outre-mer : en 2033, la conversion aurait eu lieu sans la mesure"
    source := s!"Plan « Émeraude » d'EDF (2033) : les {2 * emissionsZniEviteesKt} kt et {2 * coutZni} M€ d'O-144 sortent en 2033, la tendance les rejoignant"
    leviers := [.transitionKt .energie (0 - 2 * emissionsZniEviteesKt) 0, .depenseSur .affairesEconomiques (0 - 2 * coutZni)]
    debut := 6 },
  { id := "O-145"
    titre := "Fin du soutien public aux cogénérations au gaz à l'échéance des contrats"
    source := s!"Mesure originale (octobre 2026) ; 600,7 M€ de charges de service public pour la cogénération et les autres thermiques en 2027 (CRE, délibération 2026-149), éteints en quatre ans (hypothèse) : {extinctionCogenerations} M€ ; effet sur les émissions non compté"
    leviers := [.depenseEcheancier .affairesEconomiques extinctionCogenerations] },
  { id := "O-146"
    titre := "Pôles régionaux solaire, stockage hydraulique souterrain et chaleur : construction (13 pôles)"
    source := s!"{solaireParAnMw} MW de photovoltaïque au sol par an de 2027 à 2029 (300 MWc par pôle), soutien de {soutienSolaireEurosMWh} €/MWh ({soutienSolaire} M€) ; stockage hydraulique souterrain de 1,3 GW et 7,8 GWh à 2 500 €/kW ({stepInvestissement} M€ en sept ans, prêt de l'État de {stepPretParAn} M€ par an à un opérateur public) ; chaleur : fosses enterrées, capteurs solaires et géothermie, {chaleurAide} M€ d'aide du Fonds chaleur en 2027-2028 (voir `polesRegionaux`)"
    leviers := [.capaciteElectrique .solaire solaireParAnMw,
                .investissementPriveTransition .solaire [investissementSolaire solaireParAnMw 0, investissementSolaire solaireParAnMw 0, investissementSolaire solaireParAnMw 0, 0],
                .depenseEcheancier .affairesEconomiques soutienSolaire,
                .pretEtat stepPretParAn,
                .investissementTransition .reseauChaleur [chaleurAide / 2, chaleurAide - chaleurAide / 2, 0],
                .investissementPriveTransition .reseauChaleur [chaleurPrive / 2, chaleurPrive - chaleurPrive / 2, 0]] },
  { id := "O-146b"
    titre := "Pôles régionaux : réseaux de chaleur solaires et géothermiques en service"
    source := s!"Fosses de 200 000 m³ et 70 000 m² de capteurs (Vojens : 28 GWh par an) et un doublet de géothermie (≈ 25 GWh) par pôle : {polesRegionaux * chaleurParPoleGwh} GWh à la place du gaz des réseaux de chaleur, {chaleurEviteeKt} kt de CO₂ évitées (0,22 t par MWh, Fonds chaleur 2025) à partir de 2029"
    leviers := [.transitionEcologique { secteurGes := .energie, reductionKt := chaleurEviteeKt, energie := .gaz }]
    debut := 2 },
  { id := "O-146c"
    titre := "Pôles régionaux : fin du programme solaire (3,9 GW installés)"
    source := s!"Trois années d'installation (2027 à 2029) : {polesRegionaux * solaireParPoleMw} MW en tout"
    leviers := [.capaciteElectrique .solaire (0 - solaireParAnMw)]
    debut := 3 },
  { id := "O-146d"
    titre := "Pôles régionaux : stockage hydraulique souterrain en service (1,3 GW, 6 heures)"
    source := s!"Mise en service en 2034 après sept ans de construction ; 1,3 GW × 6 h, un cycle par jour pendant 300 jours, rendement de 75 % : ≈ 1,75 TWh restitués à la place du gaz (0,36 t par MWh) ; fin du prêt de construction"
    leviers := [.stockageElectrique (polesRegionaux * stepParPoleMw) stepHeures 300 750 360,
                .pretEtat (0 - stepPretParAn)]
    debut := anneesConstructionStep },
  { id := "O-147"
    titre := "Métro entièrement accessible aux personnes handicapées en 2035 (Paris, Marseille)"
    source := s!"{stationsATraiterParis} stations parisiennes à rendre accessibles (320, dont ≈ 30 accessibles) pour {coutAccessibiliteParis} M€ (Région Île-de-France, 2024 : « 20 Md€ sur environ 20 ans ») et {stationsATraiterMarseille} à Marseille ({coutAccessibiliteMarseille} M€) ; études en 2027, puis {travauxAccessibiliteParAn} M€ par an de 2028 à 2035, ≈ {stationsAccessiblesParAn} stations par an, quatre fois le meilleur rythme observé dans le monde : faisabilité très faible (voir `stationsMetroParis`)"
    leviers := [.investissementEcheancier .affairesEconomiques metroAccessible]
    variantes := [{ nom := "variante réaliste : ligne 6 et 50 stations de correspondance en 2035 (≈ 34 % des stations parisiennes), le reste vers 2045-2050", leviers :=
      [.investissementEcheancier .affairesEconomiques metroAccessibleRealiste] }] },
  { id := "O-149"
    titre := "Vente de la moitié de l'or de la Banque de France (2027-2032), plus-value versée à l'État pour réduire la dette"
    source := s!"Mesure originale (octobre 2026) ; 2 436,8 t (≈ {valeurOr} M€ à 4 000 $ l'once) ; la moitié vendue en six ans (deux tiers, puis tout l'or, dans les versions précédentes), plus-value (coût d'entrée de 246,37 € l'once, 1999) de {plusValueOrParAn} M€ par an versée à l'État ; opération financière (Eurostat, 1997) : la dette baisse, pas le déficit ; risque juridique élevé (BCE) (voir `onceOrMillions`)"
    leviers := [.pretEtat (0 - plusValueOrParAn)] },
  { id := "O-149b"
    titre := "Vente d'or : fin des versements (2033)"
    source := "Six années de vente (2027 à 2032)"
    leviers := [.pretEtat plusValueOrParAn]
    debut := anneesVenteOr },
  { id := "O-150"
    titre := "Réserves du FRR, du RAFP et de l'Ircantec placées en titres de l'État (consolidation de la dette publique)"
    source := s!"Mesure originale (octobre 2026) ; {reservesFonds} M€ de réserves (FRR 20,8 Md€, RAFP 57 Md€, Ircantec 18,6 Md€), dont {reservesConverties} M€ convertis en OAT en 2027-2028 (un quart supposé déjà en titres publics) ; revenus perdus ≈ {revenusPerdus} M€ par an (2,5 %, hypothèse) (voir `reservesFonds`)"
    leviers := [.pretEtat (0 - reservesConverties / 2),
                .recetteEcheancier none [0 - revenusPerdus / 2, 0 - revenusPerdus]] },
  { id := "O-150b"
    titre := "Consolidation des réserves : conversion achevée (2029)"
    source := "Deux années de conversion (2027 et 2028)"
    leviers := [.pretEtat (reservesConverties / 2)]
    debut := 2 },
  { id := "O-151"
    titre := "Contribution nationale sur la valeur du sol, progressive selon la surface de la parcelle (0,25 %, 0,5 %, 1 %), terrains agricoles et industriels exclus"
    source := s!"Mesure originale (octobre 2026), barème par surface demandé par l'auteur (novembre 2026) ; terrains bâtis hors administrations et hors industriel ≈ 5 600 Md€ (Insee, Cerema, SDES), classes de 500 et 2 000 m² par logement ; abattement de 50 000 € pour ≈ {proprietairesOccupantsMilliers} milliers de propriétaires occupants ; {contributionSol} M€ à plein taux, statique (2030, taux moyen de 0,34 %), {contributionSolNette} M€ après capitalisation dans le prix des terrains ; demi-taux en 2029 (voir `valeurSolClasses`, `solNet`)"
    leviers := [.recetteEcheancier (some .taxeFonciere) [0, 0, contributionSolNette / 2, contributionSolNette]]
    variantes := [{ nom := "taux unique de 0,5 % (version précédente, 24,7 Md€)", leviers :=
      [.recetteEcheancier (some .taxeFonciere) [0, 0, solNet 24693 / 2, solNet 24693]] }] },
  { id := "O-152"
    titre := "Fin de l'effacement des plus-values latentes au décès (modèle canadien)"
    source := s!"Mesure originale en France (octobre 2026) ; ≈ {plusValuesDeces} M€ par an (Terra Nova, 2022) (voir `plusValuesDeces`)"
    leviers := [.recetteEcheancier (some .patrimoine) [plusValuesDeces]] },
  { id := "O-153"
    titre := "Trésorerie de précaution de l'État réduite de 25 Md€ (dette brute en baisse, dette nette inchangée)"
    source := s!"Mesure originale (octobre 2026) ; écart dette brute − dette nette de 215 Md€ fin 2025 (Insee) ; {reductionTresorerie} M€ de dette en moins en 2027 (voir `reductionTresorerie`)"
    leviers := [.pretEtat (0 - reductionTresorerie)] },
  { id := "O-153b"
    titre := "Trésorerie de l'État : réduction achevée"
    source := "Une seule année (2027)"
    leviers := [.pretEtat reductionTresorerie]
    debut := 1 },
  { id := "O-154"
    titre := "Vote obligatoire, vote blanc compté parmi les suffrages exprimés, tirage au sort au-delà de 50 % de blancs"
    source := "Révision constitutionnelle (articles 3, 6 et 24) ; contravention de 1re classe (38 € au plus ; Belgique 50 €, Australie 20 dollars australiens, Sénat, 2022) ; blancs : 6,35 % des votants au second tour de 2022 ; amendes ≈ 50 M€ par scrutin au plus : sans effet budgétaire mesurable (voir `voteObligatoirePourMemoire`)"
    leviers := [.revisionConstitution "art. 3 et 24" "vote blanc parmi les suffrages exprimés et tirage au sort des sièges"] },
  { id := "O-155"
    titre := "Sobriété routière : 110 km/h sur autoroute, 100 sur voies rapides, poids lourds à 80, télétravail de deux jours, semaine de quatre jours dans la fonction publique"
    source := s!"Sans toucher au prix du carburant ; −{sobrieteRoutiereKt} kt dans les transports et −{sobrieteRoutiereBatimentsKt} kt dans les bâtiments en 2030 (Espagne 2011, A62, Umweltbundesamt 2023, ADEME, Insee) (voir `sobrieteRoutiereKt`)"
    leviers := [.transitionEcologique { secteurGes := .transports, reductionKt := sobrieteRoutiereKt / 4, energie := .carburant },
                .transitionEcologique { secteurGes := .batiments, reductionKt := sobrieteRoutiereBatimentsKt / 4, energie := .gaz }]
    repetitions := anneesMonteeClimat },
  { id := "O-155c"
    titre := "Sobriété routière : covoiturage aidé"
    source := "0,1 à 0,4 Md€ par an ; accises et TVA perdues : calculées par le levier `transitionEcologique` d'O-155"
    leviers := [.depenseEcheancier .affairesEconomiques [100, 200, 300, 400]] },
  { id := "O-156"
    titre := "Flottes 100 % électriques : voitures de société à la belge, VUL d'entreprise, loueurs, taxis et VTC, livraisons urbaines, camions"
    source := s!"−{flottesKt} kt dans les transports en 2030, +{flottesGwh} GWh d'électricité (ICCT 2025, T&E, ANFA, Pays-Bas, Allemagne) (voir `flottesKt`)"
    leviers := [.transitionEcologique { secteurGes := .transports, reductionKt := flottesKt / 4, energie := .carburant,
                                        electriciteGwh := flottesGwh / 4 }]
    repetitions := anneesMonteeClimat },
  { id := "O-156c"
    titre := "Flottes électriques : aides de 2027 à 2030"
    source := s!"{flottesAides} M€ par an de 2027 à 2030 (VUL 5 000 €, camions, livraisons, loueurs), part importée des utilitaires ; accises et TVA perdues : calculées par le levier `transitionEcologique` d'O-156"
    leviers := [.investissementTransition .vehiculeUtilitaire [flottesAides, flottesAides, flottesAides, flottesAides, 0]] },
  { id := "O-157"
    titre := "Biocarburants payés par l'État, prix à la pompe inchangé : HVO dans le gazole, B100 pour les poids lourds, bus et cars, E85"
    source := s!"−{biocarburantsKt} kt dans les transports en 2030 pour {biocarburantsCout} M€ par an (Neste, Greenea 2026 : marché du HVO en pénurie) (voir `biocarburantsKt`)"
    leviers := [.transitionEcologique { secteurGes := .transports, reductionKt := 3000 / 4, energie := .carburant,
                                        substitutImportePm := partImporteeHvo, taxesMaintenues := true },
                .transitionEcologique { secteurGes := .transports, reductionKt := 2500 / 4, energie := .carburant,
                                        substitutImportePm := partImporteeBiogazole, taxesMaintenues := true },
                .transitionEcologique { secteurGes := .transports, reductionKt := 500 / 4, energie := .carburant,
                                        substitutImportePm := partImporteeBioethanol, taxesMaintenues := true }]
    repetitions := anneesMonteeClimat },
  { id := "O-157c"
    titre := "Biocarburants : surcoût payé par l'État"
    source := s!"{biocarburantsCout} M€ par an à partir de 2030"
    leviers := [.investissementTransition .hvo ((List.range 4).map fun (k : Nat) => 750 * (Int.ofNat k + 1) / 4),
                .investissementTransition .biogazole ((List.range 4).map fun (k : Nat) => 300 * (Int.ofNat k + 1) / 4),
                .investissementTransition .bioethanol ((List.range 4).map fun (k : Nat) => 300 * (Int.ofNat k + 1) / 4)] },
  { id := "O-158"
    titre := "Plan « Liberty ships » du chauffage : 700 000 pompes à chaleur gratuites par an (dont les 100 000 rurales d'O-90, comptées là), PAC air-air en relève de chaudières, biofioul F30 obligatoire, thermostats à 19 °C"
    source := s!"−{chauffageKt} kt dans les bâtiments en 2030, +{chauffageGwh} GWh (Uniclima, plan PAC 2024, Royaume-Uni 1967-1977) ; pompes à chaleur jusqu'en 2033 (voir `chauffageKt`)"
    leviers := [.transitionEcologique { secteurGes := .batiments, reductionKt := chauffageGazKt / 4, energie := .gaz,
                                        electriciteGwh := chauffageGwh / 4 },
                .transitionEcologique { secteurGes := .batiments, reductionKt := chauffageFioulKt / 4, energie := .fioul },
                .transitionEcologique { secteurGes := .batiments, reductionKt := biofioulKt / 4, energie := .fioul,
                                        substitutImportePm := partImporteeBiogazole, taxesMaintenues := true }]
    repetitions := anneesMonteeClimat },
  { id := "O-158b"
    titre := "Plan « Liberty ships » : pompes à chaleur de 2031 à 2033"
    source := s!"700 000 PAC par an : −{chauffageSuiteKt} kt et +{chauffageSuiteGwh} GWh par an"
    leviers := [.transitionEcologique { secteurGes := .batiments, reductionKt := chauffageSuiteKt * 600 / 1000, energie := .gaz,
                                        electriciteGwh := chauffageSuiteGwh },
                .transitionEcologique { secteurGes := .batiments, reductionKt := chauffageSuiteKt * 400 / 1000, energie := .fioul }]
    debut := anneesMonteeClimat
    repetitions := 3 },
  { id := "O-158c"
    titre := "Plan « Liberty ships » : investissement public"
    source := s!"{chauffageInvestissement} M€ (8 500 € par PAC, PAC air-air, kits F30, thermostats)"
    leviers := [.investissementTransition .pompeAChaleur chauffageInvestissement] },
  { id := "O-159"
    titre := "Tertiaire : 19 °C contrôlé, sanctions du décret tertiaire, quotas des grands bâtiments (modèle de Tokyo), chauffage collectif, fluides frigorigènes"
    source := s!"−{tertiaireKt} kt dans les bâtiments en 2030, {tertiaireCout} M€ par an (voir `tertiaireKt`)"
    leviers := [.transitionEcologique { secteurGes := .batiments, reductionKt := (tertiaireKt - 1200) / 4, energie := .gaz,
                                        partPubliquePm := partPubliqueTertiairePm },
                .transitionEcologique { secteurGes := .batiments, reductionKt := 1200 / 4 }]
    repetitions := anneesMonteeClimat },
  { id := "O-159c"
    titre := "Tertiaire : contrôles et aides"
    source := s!"{tertiaireCout} M€ par an"
    leviers := [.depenseEcheancier .logementEnvironnement [tertiaireCout]] },
  { id := "O-160"
    titre := "Production d'énergie : Fonds chaleur doublé, chaudières électriques dans les réseaux de chaleur, fermeture et reconversion de la raffinerie de Donges (2029)"
    source := s!"−{energieKt} kt dans l'énergie, −{energieIndustrieKt} dans l'industrie, −{energieBatimentsKt} dans les bâtiments en 2030 (ADEME 2025) ; émissions de Donges reportées sur les importations de gazole (voir `energieKt`)"
    leviers := [.transitionEcologique { secteurGes := .energie, reductionKt := (780 + 300) / 4, energie := .gaz,
                                        electriciteGwh := energieGwh / 4 },
                .transitionEcologique { secteurGes := .energie, reductionKt := 1150 / 4,
                                        activitePerdueMeur := valeurAjouteeDonges / 4, secteurActivite := .industrie,
                                        activiteImporteePm := 1000 },
                .transitionEcologique { secteurGes := .industrie, reductionKt := energieIndustrieKt / 4, energie := .gaz },
                .transitionEcologique { secteurGes := .batiments, reductionKt := energieBatimentsKt / 4, energie := .gaz }]
    repetitions := anneesMonteeClimat },
  { id := "O-160c"
    titre := "Production d'énergie : Fonds chaleur et reconversion de Donges"
    source := s!"{energieInvestissement} M€"
    leviers := [.investissementTransition .reseauChaleur [800],
                .investissementEcheancier .logementEnvironnement [0, 0, 500, 500, 0]] },
  { id := "O-161"
    titre := "Agriculture : rachat volontaire de 20 % du cheptel bovin, 3-NOP, repas végétariens en restauration collective, plafond d'azote à la danoise, fosses couvertes"
    source := s!"−{agricultureKt} kt en 2030 (Pays-Bas, Danemark, Cour des comptes 2023) ; ≈ 15 000 à 20 000 exploitations en moins (hypothèse) (voir `agricultureKt`)"
    leviers := [.transitionEcologique { secteurGes := .agriculture, reductionKt := agricultureKt / 4,
                                        activitePerdueMeur := valeurAjouteeCheptel / 4, secteurActivite := .agriculture,
                                        activiteImporteePm := partCheptelImporteePm },
                .transitionEcologique { secteurGes := .agriculture, reductionKt := 0,
                                        activitePerdueMeur := valeurAjouteeAvalBovin / 4, secteurActivite := .industrie }]
    repetitions := anneesMonteeClimat },
  { id := "O-161c"
    titre := "Agriculture : rachats et compensations"
    source := s!"{agricultureCout} M€"
    leviers := [.depenseEcheancier .affairesEconomiques agricultureCout] },
  { id := "O-162"
    titre := "Déchets : captage du biogaz des décharges porté à 70 %"
    source := s!"−{dechetsKt} kt en 2030 (paramètre d'O-135), {dechetsCout} M€ par an (voir `dechetsKt`)"
    leviers := [.transitionEcologique { secteurGes := .dechets, reductionKt := dechetsKt / 4 }]
    repetitions := anneesMonteeClimat },
  { id := "O-162c"
    titre := "Déchets : captage du biogaz"
    source := s!"{dechetsCout} M€ par an"
    leviers := [.investissementTransition .biogaz [dechetsCout]] },
  { id := "O-163"
    titre := "Électricité renouvelable avec l'électrification : 1,5 GW de solaire de plus par an et un million de logements de plus aux PAC air-air"
    source := s!"Les O-156, O-158 et O-160 ajoutent ≈ 18 TWh de consommation en 2030 ; +{solaireSupplementMw} MW au sol et sur toitures par an de 2027 à 2030, −{sobrieteSupplementGwh} GWh par an de sobriété (voir `solaireSupplementMw`)"
    leviers := [.capaciteElectrique .solaire solaireSupplementMw, .solaireToiture solaireSupplementMw,
                .investissementPriveTransition .solaire ((List.replicate 4 (investissementSolaire solaireSupplementMw solaireSupplementMw)) ++ [0]),
                .depenseEcheancier .affairesEconomiques soutienSolaireSupplement] },
  { id := "O-163b"
    titre := "Électricité : fin du supplément solaire (2031)"
    source := "Quatre années d'installation"
    leviers := [.capaciteElectrique .solaire (0 - solaireSupplementMw), .solaireToiture (0 - solaireSupplementMw)]
    debut := 4 },
  { id := "O-163c"
    titre := "Électricité : sobriété supplémentaire (un million de PAC air-air à la place de convecteurs électriques, distinctes des PAC en relève de chaudières d'O-158)"
    source := s!"−{sobrieteSupplementGwh} GWh par an de 2027 à 2030 ; 400 M€ par an (estimation, comme l'ancienne O-148c)"
    leviers := [.consommationElectrique (0 - sobrieteSupplementGwh), .investissementTransition .pompeAChaleur [400, 0]]
    repetitions := anneesMonteeClimat },
  { id := "O-164"
    titre := "Vente de la moitié des devises et versement de la réserve RRRODE ; trésorerie de l'État réduite de 15 Md€ de plus"
    source := s!"Devises {devisesVendues} M€, RRRODE {rrrode} M€, trésorerie {tresorerieSupplementaire} M€ en 2027 ; opérations financières, risque juridique élevé (BCE) ; le dernier tiers de l'or est retiré (voir `devisesVendues`)"
    leviers := [.pretEtat (0 - devisesVendues - rrrode - tresorerieSupplementaire)] },
  { id := "O-164b"
    titre := "Fin des versements exceptionnels de 2027"
    source := "Devises, RRRODE et trésorerie : une seule année"
    leviers := [.pretEtat (devisesVendues + rrrode + tresorerieSupplementaire)]
    debut := 1 },
  { id := "O-167"
    titre := "Patrimoine : fin des avantages du démembrement, plus-values immobilières indexées et résidence principale plafonnée à l'américaine, fin du reste du Pacte Dutreil"
    source := s!"Démembrement {demembrement} M€ (CAE 2021) ; plus-values {plusValuesImmobilieres} M€ (Cour des comptes 2025) ; Dutreil {finDutreil} M€ (voir `demembrement`)"
    leviers := [.recetteEcheancier (some .patrimoine) demembrement,
                .recetteEcheancier (some .patrimoine) plusValuesImmobilieres,
                .recetteEcheancier (some .patrimoine) [finDutreil]] },
  { id := "O-168"
    titre := "Taxe sur les transactions financières étendue aux achats-reventes du jour et aux dérivés ; Caisse des dépôts et fréquences"
    source := s!"TTF {ttfElargie} M€ (modèle italien) ; fonds d'épargne {prelevementFondsEpargne} M€ ; fréquences {redevanceFrequences} M€ (Ofcom) (voir `ttfElargie`)"
    leviers := [.recetteEcheancier (some .autres) [ttfElargie],
                .recetteEcheancier none [prelevementFondsEpargne + redevanceFrequences]] },
  { id := "O-170"
    titre := "Foncière de l'État : un quart des bureaux de l'État cédés en dix ans, la reconversion en logements sociaux privilégiée"
    source := s!"900 M€ par an de cessions (Sénat, PLF 2025 : 23 millions de m², 73,7 Md€), la moitié aux organismes HLM avec une décote de 50 % (hypothèses ; loi du 18 janvier 2013) : {cessionsBureaux} M€ par an, ≈ {logementsSociauxBureaux} logements sociaux par an ; sans reprise en location (voir `cessionsBureaux`)"
    leviers := [.investissementEcheancier .fonctionnement [0 - cessionsBureaux]] },
  { id := "O-171"
    titre := "Confiscation des avoirs criminels sans condamnation (directive (UE) 2024/1260)"
    source := s!"{avoirsConfisques} M€ (2025 : 212 M€ confisqués, ministère de la Justice) (voir `avoirsConfisques`)"
    leviers := [.recetteEcheancier none avoirsConfisques] },
  { id := "O-172"
    titre := "Budget réglementaire : coûts administratifs des entreprises réduits de 25 % en cinq ans, une norme créée pour deux supprimées, autorité indépendante de mesure"
    source := s!"Coûts administratifs ≥ 3 % du PIB (Sénat, 2023) ; −25 % → ≈ +1,2 % de PIB (Commission européenne, COM(2007)23, calcul), moitié retenue : +{gainSimplificationParAnPb} pb de PIB par an de 2027 à 2031 ; autorité : {autoriteNormes} M€ par an (voir `coutAdministratifPibPb`)"
    leviers := [.automatisation gainSimplificationParAnPb 0 0]
    repetitions := anneesSimplification },
  { id := "O-172b"
    titre := "Budget réglementaire : autorité indépendante de mesure des coûts"
    source := s!"{autoriteNormes} M€ par an (hypothèse, modèle néerlandais ATR)"
    leviers := [.depenseSur .fonctionnement autoriteNormes] },
  { id := "O-173"
    titre := "Visa diplômé France : trois ans de séjour et de travail pour tout diplômé de master ou de doctorat d'un établissement français"
    source := s!"118 000 premiers titres étudiants (2025), rétention de 21 % portée à 31 % (CAE, 2021 ; hypothèse) : +{visaDiplomeMilliersParAn} milliers par an au solde migratoire (voir `premiersTitresEtudiants`)"
    leviers := [.migration visaDiplomeMilliersParAn] },
  { id := "O-174"
    titre := "Droit au rachat de cinq jours de RTT par an, majorés de 10 %, sans exonération"
    source := s!"8 millions de salariés à RTT, recours de moitié (hypothèse) : +{heuresRachatPm} ‰ d'heures par emploi ; neutre pour les finances publiques (voir `salariesRttMilliers`)"
    leviers := [.dureeTravail heuresRachatPm] },
  { id := "O-175"
    titre := "Concurrence : liberté d'installation des notaires, huissiers, pharmacies et taxis, capital des professions ouvert, tarifs réglementés revus, fin des monopoles de distribution"
    source := s!"OCDE (2015) : +0,3 % de PIB à cinq ans, +0,4 % à dix ans pour la loi croissance et activité : +{concurrenceGainParAnPb} pb par an de 2027 à 2031, +{concurrenceGainSuitePb} pb ensuite ; coût public nul (voir `concurrenceGainParAnPb`)"
    leviers := [.automatisation concurrenceGainParAnPb 0 0]
    repetitions := anneesConcurrence },
  { id := "O-175b"
    titre := "Concurrence : effets de long terme (2032-2036)"
    source := s!"+{concurrenceGainSuitePb} pb de PIB par an"
    leviers := [.automatisation concurrenceGainSuitePb 0 0]
    debut := anneesConcurrence
    repetitions := anneesConcurrence },
  { id := "O-176"
    titre := "Emploi des seniors : surcote doublée de l'âge légal à 67 ans, cumul emploi-retraite libre dans les métiers en tension"
    source := s!"+1,5 point de taux d'emploi des 60-64 ans (Benallah 2011, Song et Manchester 2007 ; hypothèse) : +{seniorsActifsParAn} actifs par an de 2027 à 2030, 90 % en emploi ; surcote : +{surcoteCoutParCohorte} M€ par cohorte, cumulatif (voir `seniorsActifsParAn`)"
    leviers := [.offreTravail seniorsActifsParAn seniorsTauxEmploiPm,
                .depenseSur .retraites surcoteCoutParCohorte]
    repetitions := 4 },
  { id := "O-176b"
    titre := "Emploi des seniors : coût cumulé de la surcote après 2030"
    source := s!"+{surcoteCoutParCohorte} M€ par cohorte"
    leviers := [.depenseSur .retraites surcoteCoutParCohorte]
    debut := 4
    repetitions := 6 },
  { id := "O-177"
    titre := "Petite enfance : 100 000 places de crèche de plus (2027-2030), droit opposable à une place dès un an"
    source := s!"0,25 mère en emploi par place (Bauernschuster et Schlotter 2015, Givord et Marbot 2015 ; hypothèse) : +{meresEmploiParAn} par an ; {postesCreche.getLastD 0} postes à 45 000 € en 2030 ; investissement {investissementCreche.getD 0 0} M€ par an (voir `placesCrecheParAn`)"
    leviers := [.offreTravail meresEmploiParAn 900]
    repetitions := 4 },
  { id := "O-177b"
    titre := "Petite enfance : postes et investissement des crèches"
    source := s!"{postesCreche.getLastD 0} postes en 2030 (0,3 ETP par place), {investissementCreche.getD 0 0} M€ d'investissement par an de 2027 à 2030"
    leviers := [.creationPostes .famille postesCreche 45000,
                .investissementEcheancier .famille investissementCreche] },
  { id := "O-178"
    titre := "Droit au temps complet : passage à temps plein de droit sauf motif économique, heures complémentaires majorées de 25 % dès la première"
    source := s!"0,9 million de temps partiels subis (Insee 2025) ; un huitième résorbé (hypothèse) : +{2 * heuresTempsPartielPm} ‰ d'heures par emploi, par moitiés en 2027 et 2028 ; coût public nul (voir `heuresTempsPartielPm`)"
    leviers := [.dureeTravail heuresTempsPartielPm]
    repetitions := 2 },
  { id := "O-179"
    titre := "Dette cachée d'entretien et maintenance renforcée : ouvrages d'art, chaussées et voies navigables, 1,8 Md€ par an pendant douze ans (1 Md€ de résorption du retard, 0,8 Md€ d'entretien courant)"
    source := s!"Retard d'entretien ≈ 12 Md€ fin 2025, +0,8 Md€ par an (Cerema 2025, Sénat 2022, audit 2018, Cour des comptes 2025) ; {entretienInfrastructuresParAn} M€ de travaux par an de 2027 à 2038, retirés du passif, qui cesse de croître (voir `entretienInfrastructuresParAn`)"
    leviers := [.entretienPassifs .entretienInfrastructures .affairesEconomiques entretienInfrastructuresParAn]
    repetitions := anneesEntretien },
  { id := "O-180"
    titre := "Suppression des effets de seuil : tout droit sous condition de ressources décroît de façon continue, sans marche (C2S, MaPrimeRénov', CSG des retraités, bourses, PAJE, chèque énergie, taxe foncière des aînés)"
    source := s!"Lissage par le haut, sans perdant : prestations {lissageSeuilsFamille + lissageSeuilsSante + lissageSeuilsLogement} M€ par an, CSG {lissageSeuilsCsg} M€, taxe foncière {lissageSeuilsTaxeFonciere} M€ (ordres de grandeur, ≈ 2,5 Md€, fourchette 1,5 à 3,5) ; effet sur l'emploi non compté (voir `lissageSeuilsFamille`)"
    leviers := [.depenseSur .famille lissageSeuilsFamille, .depenseSur .sante lissageSeuilsSante,
                .depenseSur .logementEnvironnement lissageSeuilsLogement,
                .prelevementSur .csgCrds (0 - lissageSeuilsCsg), .prelevementSur .taxeFonciere (0 - lissageSeuilsTaxeFonciere)] },
  { id := "O-181"
    titre := "Pas de modulation du nucléaire : la production en surplus est écrêtée sur le solaire et l'éolien, le parc nucléaire produit à plein"
    source := "Le nucléaire existant est à coût annuel fixe (61 €/MWh pour 365 TWh, CRE 2025) : chaque TWh modulé renchérit le reste ; les contrats de soutien récents ne rémunèrent pas les heures de prix négatifs (lignes directrices CEEAG 2022, cahiers des charges des appels d'offres depuis 2021-2024), l'électricité écrêtée n'est donc pas payée (hypothèse ; les contrats anciens restent indemnisés, non compté). Le volume écrêté n'entre pas dans la part renouvelable."
    leviers := [.prioriteNucleaire] },
  { id := "O-182"
    titre := "Plan de rénovation des ascenseurs : remplacement des 165 000 appareils de plus de 40 ans en onze ans, subvention de 30 % (ANAH, ANRU), prêts de la Banque des Territoires pour le reste"
    source := s!"{remplacementsAscenseursParAn} remplacements par an à {coutRemplacementAscenseurEuros} € (Fédération des Ascenseurs 2025-2026, rapport AN n° 704), subvention {subventionAscenseursParAn} M€ par an, investissement privé déclenché {investissementPriveAscenseurs} M€ par an (aubaine : {remplacementsAscenseursTendanciels} remplacements tendanciels), −{economieAscenseursGwhParAn} GWh par an d'électricité par cohorte (voir `ascenseursAnciens`)"
    leviers := [.investissementTransition .ascenseur (List.replicate anneesPlanAscenseurs subventionAscenseursParAn ++ [0]),
                .investissementPriveTransition .ascenseur (List.replicate anneesPlanAscenseurs investissementPriveAscenseurs ++ [0]),
                .consommationElectrique (0 - economieAscenseursGwhParAn)]
    repetitions := anneesPlanAscenseurs },
  { id := "O-183"
    titre := "Suppression des zones à faibles émissions au 1er janvier 2029 et de la vignette Crit'Air"
    source := s!"Loi Climat et résilience 2021, censure du 21 mai 2026, Insee Analyses n° 124 (août 2026), Airparif 2024, ORS-IDF 2018 ; {decesZfeNonEvitesParAn} décès par an non évités pendant {anneesZfe} ans (≈ 150 à terme, fourchette 30 à 350), {economieAidesZfe} M€ d'aides par an économisés (voir `decesZfeNonEvitesParAn`)"
    leviers := [.economieSur .affairesEconomiques economieAidesZfe]
    debut := 2 },
  { id := "O-183b"
    titre := "Suppression des ZFE : décès non évités par le renouvellement du parc que les ZFE auraient accéléré (par tiers, 2029 à 2031)"
    source := s!"{decesZfeNonEvitesParAn} décès par an pendant {anneesZfe} ans, ≈ 150 à terme (Airparif 2024, ORS-IDF 2018, Insee 2026 ; voir `decesZfeNonEvitesParAn`)"
    leviers := [.pollutionAir decesZfeNonEvitesParAn]
    debut := 2
    repetitions := anneesZfe },
  { id := "O-183c"
    titre := "Compensation de la fin des ZFE : 10 000 voitures Crit'Air 5 de plus remplacées chaque année par une électrique d'occasion récente, de 2029 à 2035"
    source := s!"{remplacementOccasion.nombre} voitures par an à {remplacementOccasion.prixUnitaire} € (hypothèse) pendant {vaguesOccasion} ans, Crit'Air 5 et non classées (1,2 million au 1er janvier 2026, SDES) ; voir `remplacementOccasion`"
    leviers := [.remplacementVehicules remplacementOccasion]
    debut := 2
    repetitions := vaguesOccasion },
  { id := "O-184"
    titre := "Formation aux premiers secours obligatoire au lycée : PSC de 7 h en seconde pour les élèves non certifiés, recyclage de 3 h en terminale"
    source := s!"{elevesSecondeAFormer} élèves à {coutPscEuros} € et {elevesTerminale} recyclages à {coutRecyclagePscEuros} € (DEPP 2025, ministère 2023), {depensePremiersSecours} M€ par an ; {40000 * baisseDecesArretCardiaquePm / 1000} décès par arrêt cardiaque évités par an à plein régime en quinze ans (RéAC, Wissenberg et al. 2013 ; calcul, incertain ; voir `elevesSecondeAFormer`)"
    leviers := [.depenseSur .enseignement depensePremiersSecours, .baisseMortalite .arretCardiaque baisseDecesArretCardiaquePm] },
  { id := "O-185"
    titre := "Remboursement de la chirurgie réfractive (Lasik, PKR, SMILE, implants) : tarif de responsabilité de 1 500 € par œil pris en charge à 70 %"
    source := s!"{yeuxOperesParAn} yeux par an aujourd'hui (ANSM, Revue du Praticien), flux × 2,5 en trois ans (hypothèse d'après KCE 2013), {depenseOeil} € par œil, dépense nette {chirurgieRefractiveNiveaux.headD 0} à {chirurgieRefractiveNiveaux.getD 2 0} M€ par an moins l'optique économisée, TVA perdue {tvaPerdueChirurgieRefractive} M€ (voir `yeuxOperesParAn`)"
    leviers := [.depenseEcheancier .sante chirurgieRefractiveNiveaux, .prelevementSur .tva (0 - tvaPerdueChirurgieRefractive)] },
  { id := "O-186"
    titre := "Avion de combat du futur de sixième génération, programme national (Dassault, Safran, Thales) : financement sécurisé à 2,1 Md€ par an, démonstrateur en 2031, service vers 2040"
    source := s!"Abandon du pilier avion du SCAF en juin 2026, ACF national (ministère des Armées, octobre 2026) ; PLF 2027 : 558 M€ de crédits de paiement ; coût de développement 25 à 35 Md€ sur 2027-2040 (presse spécialisée ; Dassault : « nettement sous 50 Md€ ») ; complément à la LPM : {avionCombatFutur} M€ (voir `avionCombatFutur`)"
    leviers := [.depenseEcheancier .defense avionCombatFutur] },
  { id := "O-187"
    titre := "Contribution à l'Agence spatiale européenne relevée de 315 M€ par an, souscrits aux programmes optionnels (≈ 4,5 Md€ sur 2026-2028, deuxième derrière l'Allemagne)"
    source := s!"Conseil ministériel de Brême, novembre 2025 : Allemagne 5,07 Md€ (5,4 aux conditions 2025), France 3,6 Md€ sur 2026-2028 (ESA, DLR, Sénat) ; {contributionEsaSupplement} M€ par an (voir `contributionEsaSupplement`)"
    leviers := [.depenseSur .affairesEconomiques contributionEsaSupplement] },
  { id := "O-188"
    titre := "Dès que le déficit est résorbé : la moitié de l'excédent rachète l'or vendu (jusqu'à la moitié du stock) et augmente les parts de l'État dans les entreprises, moitié-moitié ; l'autre moitié rembourse la dette"
    source := s!"{partExcedentPlacePm / 10} % de l'excédent de l'année précédente placés, {partOrPlacementPm / 10} % en or jusqu'à {valeurOr / 2} M€ (valeur 2025 de la moitié vendue par O-149), le reste en participations ; opérations financières, hors déficit (voir `partExcedentPlacePm`)"
    leviers := [.placementExcedent partExcedentPlacePm partOrPlacementPm (valeurOr / 2)] },
  { id := "O-189"
    titre := "Banque de la démocratie : établissement public adossé à la Caisse des dépôts prêtant aux candidats et aux partis sur le remboursement de l'État ; aucun nouveau prêt avant remboursement du précédent, la règle suivant les dirigeants du parti"
    source := s!"Projet de 2017 abandonné en 2018, proposition de loi d'avril 2026, pool bancaire négocié en juillet 2026 ; CNCCFP 2022 (11 M€ d'emprunts bancaires, 34,9 M€ de prêts de partis, 42,2 M€ remboursés) ; dotation {dotationBanqueDemocratie} M€ en 2027 (hypothèse), fonctionnement et pertes {coutBanqueDemocratie} M€ par an (hypothèse) (voir `dotationBanqueDemocratie`)"
    leviers := [.pretEtat dotationBanqueDemocratie, .depenseSur .fonctionnement coutBanqueDemocratie] },
  { id := "O-189b"
    titre := "Banque de la démocratie : la dotation est versée une fois (2027)"
    source := "Fin du versement dès 2028 ; les prêts et remboursements ultérieurs s'équilibrent dans l'établissement"
    leviers := [.pretEtat (0 - dotationBanqueDemocratie)]
    debut := 1 },
  { id := "O-190"
    titre := "Enseignement supérieur : 20 000 postes en dix ans"
    source := s!"2 000 postes par an à {coutEnseignantSuperieurEuros} € (masse salariale et effectifs des enseignants, calcul)"
    leviers := [.creationPostes .enseignement postesSuperieurCumul coutEnseignantSuperieurEuros, .annonceEmplois 20000] },
  { id := "O-191"
    titre := "Allocation aux adultes handicapés portée au seuil de pauvreté (1 337 € par mois)"
    source := s!"AAH de 1 041,59 € relevée au seuil de pauvreté de 2024 (Insee), 12,7 Md€ de dépense en proportion : {hausseAahTod} M€ par an (DREES, calcul)"
    leviers := [.depenseSur .famille hausseAahTod] },
  { id := "O-192"
    titre := "Reconversion de 500 000 actifs en dix ans, salaire maintenu pendant un an"
    source := s!"Un million en dix ans dans la version initiale, divisé par deux le 5 novembre 2026 ; {reconversionsTod} reconversions par an à 29 220 € (France compétences, projets de transition professionnelle), {coutReconversionTod} M€ par an"
    leviers := [.depenseSur .affairesEconomiques coutReconversionTod] },
  { id := "O-193"
    titre := "Sport porté à 1 % du budget de l'État en cinq ans"
    source := s!"1 % de 452,7 Md€ (budget général 2026) moins le programme « Sport » (0,55 Md€) : +{hausseSportTod} M€ par an au terme, par cinquièmes, dont {sportAffecte} M€ par an pour le chèque sport, les petits clubs et la cybersécurité des fédérations (O-219 à O-221), comptés là (voir `sportAffecte`)"
    leviers := [.depenseEcheancier .culture sportEcheancierReste] },
  { id := "O-194"
    titre := "Taxe de 1 € par kilogramme sur les emballages non recyclables, affectée au recyclage"
    source := s!"{taxeEmballages} M€ par an de recette et autant de dépense pour le recyclage"
    leviers := [.prelevement taxeEmballages, .depenseSur .logementEnvironnement taxeEmballages] },
  { id := "O-195"
    titre := "Avantage en nature des voitures de fonction thermiques imposé à sa valeur réelle"
    source := s!"Subvention implicite ≈ 4 Md€ par an, corrigée pour moitié ({avantageNatureThermique} M€ : l'autre moitié disparaît avec l'électrification des flottes, O-156 ; hypothèse)"
    leviers := [.prelevement avantageNatureThermique] },
  { id := "O-196"
    titre := "Suppression des doublons entre l'État et les collectivités : 3,75 Md€ d'économies en cinq ans"
    source := s!"7,5 Md€ d'économies annoncées dans les contre-budgets de 2026 ; la moitié, par cinquièmes (hypothèse prudente ; les fonctions de contrôle automatisées par O-26 ne sont pas recomptées)"
    leviers := [.depenseEcheancier .fonctionnement doublonsEtatCollectivites] },
  { id := "O-197"
    titre := "Aide humanitaire d'urgence portée à 1 Md€ par an"
    source := s!"De 0,5 à 1 Md€ : +{aideHumanitaire} M€ par an versés à l'étranger, sans effet sur la demande intérieure (comme O-114)"
    leviers := [.recetteEcheancier none [0 - aideHumanitaire]] },
  { id := "O-198"
    titre := "Asile : 30 000 places d'hébergement, 10 000 visas humanitaires par an, 20 000 réinstallations en cinq ans"
    source := s!"21 € par jour et par place (Sénat 2023), {coutAsileTod} M€ par an, solde migratoire +{accueillisTodMilliers} 000 par an"
    leviers := [.depenseSur .famille coutAsileTod, .migration accueillisTodMilliers] },
  { id := "O-199"
    titre := "Mutuelle publique gratuite pour les 18-25 ans"
    source := s!"Mutuelle des 18-25 ans : {mutuelleJeunes} M€ par an"
    leviers := [.depenseSur .sante mutuelleJeunes] },
  { id := "O-200"
    titre := "Fonds vert des collectivités porté de 1,5 Md€ par an (investissement public)"
    source := s!"Fonds vert : {fondsVert} M€ par an d'investissement des collectivités (bâtiments, mobilités, renaturation)"
    leviers := [.investissementEcheancier .logementEnvironnement [fondsVert]] },
  { id := "O-201"
    titre := "Diagnostic préimplantatoire des aneuploïdies (DPI-A) autorisé dans les indications de la proposition de loi n° 3314 et pris en charge par l'Assurance maladie"
    source := s!"{dpiaCyclesParAn} cycles par an à {dpiaCoutCycleEuros} € (Agence de la biomédecine 2022, tarifs européens ; hypothèses), moins {dpiaEconomies} M€ de transferts et fausses couches évités : {dpiaCoutNet} M€ nets par an ; pas d'effet sur la natalité (Cochrane 2020, NEJM 2021)"
    leviers := [.depenseSur .sante dpiaCoutNet] },
  { id := "O-202"
    titre := "Fonds de financement des soins des maladies rares : fin des cagnottes de soin, restes à charge couverts, accès compassionnel élargi"
    source := s!"{fondsMaladiesRares} M€ par an (30 de substitution aux cagnottes, 150 de restes à charge plafonnés, 70 d'accès compassionnel ; GoFundMe 2025, La Cagnotte des Proches 2024, France Assos Santé 2024, DREES 2023 ; hypothèses)"
    leviers := [.depenseSur .sante fondsMaladiesRares] },
  { id := "O-203"
    titre := "Imagerie lourde : autorisation d'activité sans plafond d'appareils par site, forfaits techniques ramenés vers les coûts (−11 %)"
    source := s!"+1 000 scanners et IRM en cinq ans (FHF), ≈ 1 M€ d'activité remboursée par appareil, moins 170 M€ de baisse des forfaits (IGAS-IGF 2025) : {imagerieNiveaux} M€ par an (fourchette 116 M€ à 1 Md€)"
    leviers := [.depenseEcheancier .sante imagerieNiveaux] },

  { id := "O-204"
    titre := "Panier de légumes bio à tarif préférentiel : achat public à prix garanti aux maraîchers bio, vente au prix du conventionnel par une carte"
    source := s!"{menagesPauvresMilliers} milliers de ménages sous le seuil de pauvreté (Insee 2023), recours 50 % (hypothèse), {legumesParMenageDixiemesKg / 10} kg de légumes par ménage et par an (FranceAgriMer 2026) : {panierBioTonnes / 1000} kt ; prime producteur bio {primeProducteurBioCts} c€/kg (38 % de l'écart de 60 %, UFC-Que Choisir 2026) : {panierBioProducteursMeur} M€ aux maraîchers, logistique {panierBioLogistiqueMeur} M€ (0,30 €/kg, hypothèse), cartes {gestionCartesMeur} M€ ; cartes en 2028 (voir `panierBioMeur`)"
    leviers := [.depenseSecteur .agriculture panierBioProducteursMeur,
                .depenseSur .affairesEconomiques (panierBioLogistiqueMeur + gestionCartesMeur)]
    debut := 1 },

  { id := "O-205"
    titre := "Consigne obligatoire des bouteilles et canettes au 1er janvier 2029 sur le modèle portugais « Volta », remboursement en espèces ou sur la carte du panier bio, dépôts non réclamés affectés au panier bio"
    source := s!"Gisement {gisementConsigneMillions / 1000} milliards d'emballages (Vernier 2019), dépôt {depotConsigneCts} c€, taux de retour 65 %, 75 %, 85 % puis 90 % (hypothèse ; Irlande, Lettonie, Roumanie) : dépôts non réclamés {depotsNonReclamesMeur} M€ par an, affectés au fonds du panier bio (O-204) et dépensés en produits bio ; collectivités compensées {compensationCollectivitesConsigne} M€ (Vernier), régulateur {regulateurConsigne} M€ (hypothèse) (voir `depotsNonReclamesMeur`)"
    leviers := [.recetteEcheancier none depotsNonReclamesMeur,
                .depenseEcheancier .affairesEconomiques depotsNonReclamesMeur,
                .depenseSur .logementEnvironnement (compensationCollectivitesConsigne + regulateurConsigne)]
    debut := 2 },

  { id := "O-206"
    titre := "Métro automatique Nice – Monaco – Vintimille : études 2027-2029, enquête publique 2030-2032, travaux 2033-2040, mise en service 2041"
    source := s!"{metroAzurKm} km (hypothèse) à {coutMetroParKmMeur} M€ par km (Grand Paris Express, métro E de Lyon, traversée de Marseille) : {metroAzurMeur} M€, dont 25 % payés par Monaco (hypothèse) ; 10 M€ d'études par an, 5 M€ d'enquête publique, puis {metroAzurParAn} M€ par an pendant huit ans à partir de 2033 (travaux dès 2030 coûtaient une propriété) ; projet monégasque de 2024 jugé « pas viable » par le ministre (novembre 2025) ; service en 2041, hors horizon (voir `metroAzurMeur`)"
    leviers := [.investissementEcheancier .affairesEconomiques metroAzurNiveaux] },

  { id := "O-207"
    titre := "Lyon – Saint-Étienne : un train toutes les 15 minutes en 2033 (branche stéphanoise du SERM lyonnais)"
    source := s!"{sermStEtienneMeur} M€ de 2028 à 2032 (hypothèse : quadruplement Saint-Fons – Givors, part du SERM lyonnais à 3 Md€, IGF-IGEDD 2025), en plus de Mobi'LYSE (acquis, tendanciel) (voir `sermStEtienneNiveaux`)"
    leviers := [.investissementEcheancier .affairesEconomiques sermStEtienneNiveaux]
    debut := 1 },

  { id := "O-207b"
    titre := "Lyon – Saint-Étienne au quart d'heure : exploitation et report modal dès 2033"
    source := s!"2 trains par heure et par sens de plus, 18 h, 59 km, 22,5 € par train-km, recettes 25 % (hypothèses ; Cour des comptes 2009 et 2019) : {exploitationStEtienne} M€ nets par an ; +10 000 voyageurs par jour dont 62 % venus de la route (LNPCA), 0,13 kg CO₂e par voyageur-km (SNCF 2024) : {co2StEtienneKt} kt évitées (voir `exploitationNetteMeur`)"
    leviers := [.depenseSur .affairesEconomiques exploitationStEtienne,
                .transitionKt .transports co2StEtienneKt 0]
    debut := 6 },

  { id := "O-208"
    titre := "Aix – Marseille : un train toutes les 10 minutes, SERM d'Aix-Marseille-Provence (3 lignes ferroviaires, 27 lignes de cars) en plus de la LNPCA"
    source := s!"{sermAixMarseilleMeur} M€ de 2028 à 2034 (seul chiffre public du SERM, non officiel : hypothèse), la LNPCA phases 1-2 (5,3 Md€, lancée en décembre 2025, 10 minutes Aix – Marseille en 2035) restant dans le tendanciel (voir `sermAixMarseilleNiveaux`)"
    leviers := [.investissementEcheancier .affairesEconomiques sermAixMarseilleNiveaux]
    debut := 1 },

  { id := "O-208b"
    titre := "SERM d'Aix-Marseille-Provence : exploitation et report modal dès 2035"
    source := s!"{exploitationAixMarseille} M€ par an (borne basse du GART par SERM, rapport AN n° 3048, 2026) ; +10 000 voyageurs par jour reportés (hypothèse), 62 % de la route, 37 km : {co2AixMarseilleKt} kt évitées (voir `co2EviteKt`)"
    leviers := [.depenseSur .affairesEconomiques exploitationAixMarseille,
                .transitionKt .transports co2AixMarseilleKt 0]
    debut := 8 },

  { id := "O-209"
    titre := "Rachat de trimestres encouragé : crédit d'impôt de 20 % du rachat, plafonné à 1 000 € par trimestre, en plus de la déduction"
    source := s!"6 629 rachats en 2022, 26 391 € en moyenne (COR, 2023) ; rachats doublés (hypothèse) : +{recetteRachats} M€ aux régimes, déduction {deductionRachats} M€ (taux marginal de 35 %, hypothèse), crédit {creditRachats} M€ ; {partDepartsRachatPm} ‰ des départs avancés de 18 mois (voir `rachatsSupplementaires`)"
    leviers := [.recetteEcheancier none [recetteRachats],
                .prelevementSur .ir (0 - deductionRachats - creditRachats),
                .dureeCotisation (-18) partDepartsRachatPm]
    debut := 1 },

  { id := "O-210"
    titre := "Liberté de capitalisation : chacun peut placer jusqu'à 2,5 % de ses cotisations retraite sur un compte individuel, fonds public par défaut"
    source := s!"277 Md€ de cotisations (COR, 2026) ; adhésion volontaire de 10 %, 15 % puis 20 % de l'assiette (hypothèse ; Suède : 16 % de choix actif au début, 1 à 2 % ensuite) : {capitalisationNiveaux} M€ de recettes des régimes par an ; pensions réduites au départ des épargnants, après 2035 (voir `capitalisationNiveaux`)"
    leviers := [.recetteEcheancier none capitalisationNiveaux]
    debut := 1
    variantes := [
      { nom := "adhésion de 50 % de l'assiette (option par défaut, sortie possible)", leviers := [.recetteEcheancier none [0 - cotisationsRetraite * plafondCapitalisationPm / 1000 * 500 / 1000]] },
      { nom := "plafond de 5 % (version précédente)", leviers := [.recetteEcheancier none (capitalisationNiveaux.map (· * 2))] }] },

  { id := "O-211"
    titre := "Huit EPR2 de plus, comme le prévoit la PPE3 : chantier lancé en 2030, prêt de l'État de la moitié du coût"
    source := s!"PPE3 (décret du 12 février 2026) : 13 GW à l'étude, chantier au plus tard en 2030 ; {coutHuitEPR2} M€ (12,1 Md€ par réacteur, devis EDF 2025, effet de série de 10 %, hypothèse) ; prêt de {pretHuitEPR2} M€ par an de 2030 à 2044 ; mise en service après 2040 (voir `coutHuitEPR2`)"
    leviers := [.pretEtat pretHuitEPR2]
    debut := 3
    variantes := [{ nom := "prêt de l'État de 60 % du coût (Conseil de politique nucléaire, mars 2026)", leviers := [.pretEtat (coutHuitEPR2 * 60 / 100 / 15)] }] },

  { id := "O-212"
    titre := "Logements des militaires rénovés : tout le parc domanial d'ici 2031, 30 % de la rénovation des logements réservés chez les bailleurs"
    source := s!"28 462 logements dont 8 876 domaniaux et 18 871 réservés (AN, rapport n° 3063, 2026) ; 1 900 rénovations faites sur 7 544 visées fin 2029 (QE n° 15181) ; +600 rénovations par an et 30 % d'un dixième des réservés chaque année, à 57 000 € (Banque des Territoires, 2023) : {renovationLogementsMilitaires} M€ par an de 2027 à 2031 (voir `renovationLogementsMilitaires`)"
    leviers := [.investissementEcheancier .defense (List.replicate 5 renovationLogementsMilitaires ++ [0])] },

  { id := "O-213"
    titre := "Fin de la rusticité des casernements : 12 800 lits remis aux normes d'ici 2031, entretien courant porté au besoin"
    source := s!"25 % des 1 433 bâtiments d'hébergement en mauvais ou très mauvais état (AN, rapport n° 3063) : {litsVetustes} lits à 60 000 € (plans Hébergement 2024-2025) : {renovationLitsParAn} M€ par an de 2027 à 2031 ; entretien +{entretienCasernements} M€ par an (450 M€ pour 600 M€ nécessaires, rapport Matteï, PLF 2026) (voir `litsVetustes`)"
    leviers := [.investissementEcheancier .defense (List.replicate 5 renovationLitsParAn ++ [0]),
                .depenseSur .defense entretienCasernements] },

  { id := "O-214"
    titre := "Crédit d'impôt normalisation : 50 % des dépenses de participation aux normes françaises et européennes, plafonné à 45 000 € par an ; la normalisation sort du crédit d'impôt recherche"
    source := s!"Aujourd'hui ≈ 19,5 % du coût des seules réunions dans le CIR (CGI, art. 244 quater B), ≈ {creanceNormalisationCir} M€ (hypothèse, MESR 2023) ; nouveau crédit ≈ {creditNormalisation} M€ (préparation égale aux réunions, participation +20 %, hypothèses ; plafond de l'aide allemande WIPANO), {creditNormalisationNet} M€ nets (voir `creditNormalisation`)"
    leviers := [.prelevementSur .impotSocietes (0 - creditNormalisationNet)] },

  { id := "O-215"
    titre := "TVA à 6 % sur les couches, les protections pour l'incontinence et les vêtements et chaussures pour enfants (produits de base que le droit européen permet de taxer au taux réduit)"
    source := s!"Directive (UE) 2022/542, annexe III, points 3 et 24 ; savon, dentifrice, papier toilette et lessives exclus par la directive, taux selon l'origine interdit (TFUE, art. 110) ; ≈ {(consoCouches + consoIncontinence + consoVetementsEnfants) / 100 / 10},{(consoCouches + consoIncontinence + consoVetementsEnfants) / 100 % 10} Md€ de consommation (hypothèses, Insee 2025), {ecartTauxBasiquesPm / 10} % du prix TTC : −{perteTvaBasiques} M€ par an (voir `perteTvaBasiques`)"
    leviers := [.prelevementSur .tva (0 - perteTvaBasiques)] },

  { id := "O-216"
    titre := "Zones touristiques (Le Grau-du-Roi, les Pyrénées…) desservies en train 24 h sur 24, avec agents de sécurité, et tarif touristique TGV + TER"
    source := s!"Six liaisons de nuit de 120 km aux coûts d'O-34 : {coutDessertesNuitTourisme} M€ par an ; 30 % de réduction sur 2 millions de trajets à 50 € (hypothèses) : {tarifTouristique} M€ par an (voir `coutDessertesNuitTourisme`)"
    leviers := [.depenseSur .affairesEconomiques (coutDessertesNuitTourisme + tarifTouristique)]
    debut := 1 },

  { id := "O-217"
    titre := "Consultations citoyennes électroniques sur des sujets non législatifs (candidature aux Jeux olympiques, nom du futur porte-avions…), identification par FranceConnect"
    source := s!"Plateforme publique au niveau 3 de la recommandation CNIL n° 2026-045 (expertise indépendante à chaque scrutin, code publié), 5 M€ en 2027 puis 4 M€ par an pour deux consultations et un test public d'intrusion (hypothèses ; vote des Français de l'étranger ≈ 2,65 € par vote en 2022, plateforme du Grand débat 1,1 M€) (voir `consultationsNiveaux`)"
    leviers := [.depenseEcheancier .fonctionnement consultationsNiveaux] },

  { id := "O-218"
    titre := "Plateforme publique de vote électronique ouverte aux partis, aux syndicats et aux collectivités, au prix coûtant"
    source := s!"Même plateforme qu'O-217, 1 € par électeur (marché de l'Éducation nationale 2026-2027 : ≈ 1,3 € HT, calcul) ; 2 M€ d'adaptation en 2027, exploitation 3 M€ par an couverte à moitié par les redevances (hypothèses) (voir `plateformeVoteNiveaux`)"
    leviers := [.depenseEcheancier .fonctionnement plateformeVoteNiveaux] },

  { id := "O-219"
    titre := "Chèque sport universel : 50 € par an pour chaque jeune de 6 à 17 ans, en plus du Pass'Sport des familles modestes"
    source := s!"9,5 millions de 6-17 ans (Insee 2026, calcul), recours de 40 % (hypothèse ; Pass'Sport ciblé : 16 à 27 %) : {chequeSport} M€ par an, pris sur l'enveloppe d'O-193 (voir `chequeSport`)"
    leviers := [.depenseSur .culture chequeSport] },

  { id := "O-220"
    titre := "Petits clubs : caméras de captation pour diffuser leurs matchs, prêtées par les districts et ligues, et aide à la modernisation"
    source := s!"63 % des clubs sous 10 000 € de budget (CNOSF) ; {camerasClubs} caméras à 1 300 € et 800 € d'abonnement par an (Veo), 1 000 € par an pour 20 000 clubs (hypothèse) : {petitsClubs} M€, pris sur l'enveloppe d'O-193 (voir `petitsClubs`)"
    leviers := [.depenseEcheancier .culture petitsClubs] },

  { id := "O-221"
    titre := "Cybersécurité des fédérations sportives : parcours de sécurisation pour les 141 fédérations et groupements, prestataires communs sécurisés"
    source := s!"Fuites de données à la FFF, à la FFT, à la FFBB… (2024-2026) ; parcours cyber de l'ANSSI : ≈ 106 000 € par entité : {cyberFederations} M€ par an, pris sur l'enveloppe d'O-193 (voir `cyberFederations`)"
    leviers := [.depenseEcheancier .culture cyberFederations] }
]

/-! ## Classement des mesures : rubicons, paramétrables, négociables

* **Négociables** (17 mesures sur 214, ≈ 8 %) : celles qui suscitent les
  oppositions les plus fortes, dans l'opinion ou chez les partenaires d'une
  coalition (cheptel bovin, vitesse libre, sobriété routière, ZFE,
  composante carbone, mémoire…) ; elles
  peuvent être cédées en
  échange d'autre chose. Note : ce qui les rend discutées.
* **Paramétrables** (59) : principe acquis, discuté sur ses paramètres
  (taux de TVA, d'IS, part de l'or vendue, barème de la contribution sur le
  sol, norme de dépense, durée de cotisation, capitalisation…). Note : ce
  qui se règle ; les
  variantes chiffrées en donnent souvent l'effet.
* **Rubicons** (138) : tout le reste, non négociable. Révision
  (novembre 2026) : O-87, O-105, O-106, O-154 et O-24 deviennent des
  rubicons, O-198 paramétrable, O-58, O-84 et O-197 négociables ; le
  5 novembre, O-84 est retirée ; la suppression de la journée de
  solidarité (O-222), ajoutée parmi les négociables, est retirée le même
  jour (la journée existante est maintenue).

Une mesure en plusieurs étapes (O-117 et O-117b) a le statut et le domaine
de sa première étape. Le classement n'entre pas dans l'évaluation : il sert
à la présentation (README, programme complet en PDF, synthèse). -/

/-- Numéro de base d'une mesure : `"O-117b"` → `"O-117"`. -/
def numeroBase (id : String) : String :=
  String.mk ((id.toList.reverse.dropWhile Char.isLower).reverse)

def domainesMesures : List (Domaine × List String) :=
  [(.economie, ["O-09", "O-12", "O-14", "O-20", "O-47", "O-77", "O-91", "O-94", "O-111", "O-127", "O-172", "O-174", "O-175", "O-178", "O-192", "O-214"]),
   (.fiscalite, ["O-08", "O-23", "O-29", "O-30", "O-36", "O-37", "O-38", "O-40", "O-41", "O-45", "O-46", "O-51", "O-52", "O-54", "O-56", "O-57", "O-59", "O-60", "O-61", "O-62", "O-69", "O-70", "O-71", "O-72", "O-73", "O-76", "O-86", "O-122", "O-124", "O-140", "O-141", "O-151", "O-152", "O-167", "O-168", "O-194", "O-195", "O-215"]),
   (.financesPubliques, ["O-21", "O-24", "O-26", "O-39", "O-42", "O-49", "O-53", "O-55", "O-129", "O-143", "O-149", "O-150", "O-153", "O-164", "O-170", "O-188", "O-196"]),
   (.defense, ["O-43", "O-133", "O-134", "O-139", "O-186", "O-187", "O-212", "O-213"]),
   (.securiteJustice, ["O-10", "O-67", "O-75", "O-82", "O-95", "O-100", "O-110", "O-125", "O-130", "O-131", "O-132", "O-171"]),
   (.energieClimat, ["O-04", "O-63", "O-90", "O-107", "O-108", "O-119", "O-123", "O-135", "O-137", "O-142", "O-145", "O-146", "O-157", "O-158", "O-159", "O-160", "O-162", "O-163", "O-181", "O-205", "O-211"]),
   (.transports, ["O-01", "O-05", "O-06", "O-11", "O-13", "O-34", "O-48", "O-117", "O-118", "O-128", "O-138", "O-147", "O-155", "O-156", "O-179", "O-183", "O-206", "O-207", "O-208", "O-216"]),
   (.logementTerritoires, ["O-02", "O-03", "O-32", "O-33", "O-116", "O-182", "O-200"]),
   (.agriculture, ["O-31", "O-93", "O-96", "O-103", "O-104", "O-136", "O-161", "O-204"]),
   (.education, ["O-16", "O-17", "O-18", "O-19", "O-25", "O-68", "O-81", "O-88", "O-121", "O-184", "O-190", "O-193", "O-219", "O-220"]),
   (.sante, ["O-22", "O-27", "O-74", "O-78", "O-79", "O-80", "O-85", "O-92", "O-101", "O-185", "O-199", "O-201", "O-202", "O-203"]),
   (.solidarites, ["O-07", "O-28", "O-44", "O-58", "O-83", "O-109", "O-120", "O-176", "O-177", "O-180", "O-191", "O-209", "O-210"]),
   (.institutions, ["O-50", "O-87", "O-154", "O-189", "O-217", "O-218"]),
   (.societe, ["O-105", "O-106"]),
   (.international, ["O-112", "O-113", "O-114", "O-115", "O-173", "O-197", "O-198"]),
   (.outreMer, ["O-64", "O-65", "O-66", "O-89", "O-97", "O-102", "O-144"]),
   (.numerique, ["O-15", "O-98", "O-99", "O-221"])]

def negociables : List (String × String) :=
  [("O-09", "coût et risque d'abus pour l'assurance chômage ; patronat et partenaires sociaux opposés"),
   ("O-13", "conduite autonome encore non homologuée en Europe ; indemnisation des taxis contestée"),
   ("O-18", "places de Parcoursup ouvertes aux étrangers : sujet d'immigration très clivant"),
   ("O-32", "suppression du DPE dans les quartiers historiques : opposition des écologistes et des locataires"),
   ("O-43", "baisse du budget de la défense en pleine LPM, à contre-courant des autres mesures de défense"),
   ("O-58", "allongement continu de la durée de cotisation, contesté ; il répond à la baisse de la natalité, qui réduit les cotisants de demain"),
   ("O-89", "fin de l'octroi de mer : première recette des collectivités d'outre-mer, élus locaux opposés"),
   ("O-101", "contribution des médecins des zones bien dotées : syndicats médicaux opposés"),
   ("O-113", "demandes mémorielles de l'Algérie : sujet diplomatique et politique très clivant"),
   ("O-114", "remboursement de l'indemnité d'Haïti : précédent de réparations contesté"),
   ("O-118", "vitesse libre sur autoroute : sécurité routière et émissions, à contre-courant de la sobriété"),
   ("O-124", "composante carbone relevée : souvenir des gilets jaunes, coût pour les ménages chauffés au fioul et au gaz"),
   ("O-155", "110 km/h, poids lourds à 80, semaine de quatre jours dans la fonction publique : contraintes du quotidien"),
   ("O-161", "rachat de 20 % du cheptel bovin, repas végétariens : éleveurs et syndicats agricoles opposés"),
   ("O-175", "concurrence chez les notaires, pharmacies et taxis : professions réglementées opposées"),
   ("O-183", "suppression des ZFE : écologistes et médecins opposés (pollution de l'air)"),
   ("O-197", "aide versée à l'étranger (+500 M€ par an) : priorité discutée face aux besoins du pays")]

def parametrables : List (String × String) :=
  [("O-02", "barème des amendes SRU selon la part de logements sociaux manquants"),
   ("O-08", "taux de l'impôt sur les sociétés (21 % retenu ; 20 % et 15 % en variantes)"),
   ("O-28", "seuil de la désindexation des pensions (5 150 € par mois)"),
   ("O-29", "taux de TVA (23 %, 11 %, 6,5 %) et calendrier"),
   ("O-36", "seuil et taux de la CSG sur les héritages"),
   ("O-37", "taux de la taxe sur les services numériques (15 %)"),
   ("O-38", "bande de salaires des exonérations (1,6 à 2,5 SMIC)"),
   ("O-40", "ampleur de la revue des niches (−10 %)"),
   ("O-41", "abattement du Pacte Dutreil (37,5 %) et assiette de la taxe sur les holdings"),
   ("O-42", "norme de dépense (+0,5 % en volume)"),
   ("O-44", "durée de cotisation (174 trimestres)"),
   ("O-46", "seuil (100 000 €) et taux (+2 points) de la CSG progressive"),
   ("O-49", "baisse de rémunération des hauts fonctionnaires (−5 %)"),
   ("O-51", "taux du prélèvement sur les revenus du capital (barème ou forfait relevé)"),
   ("O-52", "taux de la taxe sur les rachats d'actions (20 %)"),
   ("O-55", "norme de dépense (−1 % par an) et plafond de la santé (1 point par an)"),
   ("O-56", "montant et conditions de la baisse des aides aux entreprises"),
   ("O-57", "rythme de la baisse des niches (−2 % par an)"),
   ("O-59", "taux de la CVAE maintenu (0,28 %)"),
   ("O-60", "taux et seuil de la contribution des grandes entreprises"),
   ("O-61", "montant de la deuxième baisse des aides aux entreprises"),
   ("O-62", "montant de la troisième baisse des niches"),
   ("O-69", "plafond du crédit d'impôt recherche (50 M€ par groupe)"),
   ("O-70", "seuil de l'assurance-vie au barème des successions (250 000 €)"),
   ("O-71", "barème de la contribution kilométrique des poids lourds"),
   ("O-72", "taux de l'accise sur le kérosène des vols intérieurs"),
   ("O-73", "part de la défiscalisation des heures supplémentaires conservée (moitié)"),
   ("O-76", "point de sortie des allègements (2 SMIC) et bande reversée aux salaires"),
   ("O-78", "prix minimum par verre (0,50 €)"),
   ("O-79", "hausse du prix du tabac (+20 %)"),
   ("O-86", "encadrement des taux locaux (taxe foncière, taxe d'habitation)"),
   ("O-99", "taux de l'amende sur le chiffre d'affaires (2 %) et seuil des entreprises visées"),
   ("O-125", "barème des amendes selon le revenu"),
   ("O-129", "baisse de rémunération des dirigeants publics (−20 %)"),
   ("O-140", "part de la plus-value d'urbanisme captée (moitié)"),
   ("O-141", "taux de la contribution sur les réserves bancaires (50 %)"),
   ("O-143", "seuil (5,5 %) et ampleur (5 points) du frein au déficit"),
   ("O-149", "part de l'or vendue (la moitié) et rythme des ventes"),
   ("O-150", "part des réserves du FRR, du RAFP et de l'Ircantec placées en titres de l'État"),
   ("O-151", "barème de la contribution sur le sol (0,25 %, 0,5 %, 1 %) et exclusions"),
   ("O-152", "seuil de l'imposition des plus-values latentes au décès"),
   ("O-156", "calendrier et champ des obligations de flottes électriques"),
   ("O-159", "température de consigne (19 °C), sanctions et seuil des grands bâtiments"),
   ("O-160", "calendrier de la fermeture de la raffinerie de Donges et dotation du Fonds chaleur"),
   ("O-164", "part des devises vendues et réduction de la trésorerie"),
   ("O-167", "plafond de la résidence principale et fin du démembrement"),
   ("O-168", "champ et taux de la taxe sur les transactions financières"),
   ("O-173", "durée du visa diplômé (trois ans) et diplômes concernés"),
   ("O-178", "majoration des heures complémentaires (25 %) et motifs de refus"),
   ("O-185", "tarif de responsabilité (1 500 € par œil) et taux de prise en charge (70 %)"),
   ("O-187", "supplément à l'ESA (+315 M€ par an)"),
   ("O-188", "part de l'excédent placée (moitié) et partage entre or et participations"),
   ("O-194", "taux de la taxe sur les emballages non recyclables (1 € par kg)"),
   ("O-195", "barème de l'avantage en nature des voitures thermiques"),
   ("O-198", "nombre de places d'hébergement (30 000), de visas humanitaires (10 000 par an) et de réinstallations (20 000 en cinq ans)"),
   ("O-209", "taux du crédit d'impôt (20 %) et plafond par trimestre (1 000 €)"),
   ("O-210", "plafond de la part capitalisée (2,5 % des cotisations) et fonds par défaut"),
   ("O-211", "nombre de réacteurs supplémentaires (huit) et date de lancement (2030)"),
   ("O-215", "liste des produits de base au taux réduit, dans les limites de la directive TVA")]

def classer (m : Mesure) : Mesure :=
  let b := numeroBase m.id
  let d := ((domainesMesures.find? fun (_, ids) => ids.contains b).map (·.1)).getD .nonClasse
  match negociables.lookup b, parametrables.lookup b with
  | some n, _ => { m with statut := .negociable, domaine := d, noteStatut := n }
  | none, some n => { m with statut := .parametrable, domaine := d, noteStatut := n }
  | none, none => { m with statut := .rubicon, domaine := d }

def mesures : List Mesure := mesuresNonClassees.map classer

theorem classement_tailles :
    negociables.length = 17 ∧ parametrables.length = 59 ∧
    (domainesMesures.map (·.2.length)).sum = 214 := by decide

/-- Paires de mesures de sens opposé repérées par la vérification de
cohérence interne (`Modele/Coherence.lean`) et déclarées compatibles par
l'auteur (5 novembre 2026 : « il ne s'agit pas de vraies oppositions »). Les
deux paires avec la suppression de la journée de solidarité (O-174 et O-178
contre O-222) ont disparu avec le retrait d'O-222. -/
def arbitrages : List Arbitrage :=
  let cotisation := "Pas une vraie opposition (auteur, 5 novembre 2026) : la durée de cotisation augmente, mais on peut racheter plus facilement des trimestres si on le souhaite."
  [⟨"O-44", "O-209", cotisation⟩, ⟨"O-58", "O-209", cotisation⟩]

def programme : Programme where
  id := "TexteOrientationD"
  nom := "Texte Orientation D"
  description := "Texte Orientation D : remplacement des voitures les plus polluantes, amendes SRU proportionnelles, attributions HLM vérifiables par preuve ZK, six EPR2, prime à l'électrique et bornes, retraite à la durée cotisée sans âge légal, IS à 20 %, démission indemnisée, moyens pour la justice, lignes nouvelles ferroviaires, qualité d'accueil touristique, conduite autonome avec indemnisation des taxis par cohorte d'âge, prévention des accidents du travail, logiciel libre, universités (dette, reconstruction, Parcoursup, places), économies et recettes (apprentissage, commande publique, médicament, fraude), dette numérique en stablecoin exonérée de PFU, enseignants (+2 %/an), automatisation des contrôles administratifs, simplification pour les généralistes, désindexation des très hautes retraites, taxe sur les jets privés, agriculture électrique, DPE et climatisation dans les quartiers historiques, urbanisme des quartiers de gare, TER 24 h sur 24, redressement des comptes (CSG sur les gros héritages, taxe numérique, cotisations, fraude, niches, patrimoine, norme de dépense), défense −1 Md€, 174 trimestres, lutte contre la fraude fiscale, CSG progressive pour les hauts revenus, participations dans les entreprises stratégiques, fin des concessions autoroutières, hauts fonctionnaires −5 %, revenus des élus, fin du PFU, rachats d'actions, cabinets de conseil, trajectoire de baisse continue du déficit (CRDS prolongée, norme renforcée, aides aux entreprises, niches, durée de cotisation), CVAE maintenue et contribution des grandes entreprises pérennisée, rénovation majorée en zone rurale, eau potable et électricité pour tous dans les outre-mer, remboursement des dettes cachées (heures supplémentaires des policiers, RIFSEEP des enseignants), CIR recentré, assurance-vie au barème, contribution des poids lourds, kérosène des vols intérieurs, défiscalisation des heures supplémentaires réduite de moitié, heures supplémentaires non payées des hôpitaux, 85 000 places de prison dont la moitié des nouvelles en modulaire, allègements recentrés sous 2 SMIC, accompagnement renforcé des demandeurs d'emploi, prix minimum de l'alcool, prix du tabac, dépistage du cancer colorectal, scolarisation des 18-24 ans, loi intégrale contre les violences sexistes et sexuelles, allocations familiales dès le premier enfant, santé mentale, liberté fiscale des collectivités (taxe foncière, taxe d'habitation), référendum d'initiative citoyenne, médecins scolaires, fin de l'octroi de mer, pompes à chaleur gratuites en zone rurale, zones d'électrification industrielle hors ZAN, aides à l'installation dans les déserts médicaux, minimum de pension agricole, emplois aidés dans l'industrie, divisions régionales de cybersécurité de la police, revenu minimum des nouveaux exploitants agricoles, prime à l'installation des médecins à Mayotte et en Guyane, accompagnement des entreprises en cybersécurité, amendes automatiques en cas de fuite de données massive, douaniers et contrôles des importations, liberté d'installation des médecins et contribution des zones bien dotées, cotisations salariales réduites outre-mer, aide au GNR agricole dégressive, coopérative d'État d'engrais bas carbone, légalisation du cannabis et de la prostitution après référendum, TVA à 23 %, 11 % et 6 % (temporaire), produits de base au taux réduit, rénovation des passoires des villes moyennes, décarbonation des sites industriels, places en Ehpad publics, police de proximité, financements de Bpifrance orientés par un vote en ligne, renfort des préfectures pour les titres de séjour, réponse aux demandes mémorielles de l'Algérie, remboursement de la dette d'Haïti, restitutions et reconnaissance d'actes coloniaux en Afrique, zones commerciales densifiées, fret ferroviaire doublé, autoroutes à vitesse libre sur certains tronçons, plan contre les fuites d'eau, aides à domicile revalorisées, 90 000 postes à l'école, cotisations salariales réduites d'un demi-point, aide ciblée au solaire sur toiture, composante carbone remise sur sa trajectoire, amendes proportionnelles aux revenus, contrats aidés non marchands, leasing social électrique, rémunération des dirigeants d'institutions publiques −20 %, un commissariat dans chaque ville de plus de 30 000 habitants, indemnisation forfaitaire des blessés d'interventions de police, escroqueries remboursées au double par l'escroc, second porte-avions, lancements de satellites sur lanceurs européens, plan méthane des déchets, plan azote et effluents d'élevage, déchetteries gratuites pour tous, rétrofit électrique massif, drones de masse et bouclier anti-drones, captation des plus-values d'urbanisme, contribution sur la rémunération des réserves bancaires, biokérosène pour les vols intérieurs, frein automatique au déficit, centrales des outre-mer au bioliquide, fin du soutien aux cogénérations au gaz, pôles régionaux solaire, stockage hydraulique souterrain et chaleur, métro entièrement accessible aux personnes handicapées en 2035, priorité au nucléaire sans modulation, plan de rénovation des ascenseurs, suppression des ZFE et de Crit'Air, premiers secours au lycée, chirurgie réfractive remboursée, avion de combat de sixième génération, contribution à l'ESA au-dessus de l'allemande, rachat de l'or et participations dès l'excédent, banque de la démocratie, onze mesures sociales, éducatives et environnementales (enseignement supérieur, AAH, reconversion, sport, emballages, voitures de fonction, doublons État-collectivités, aide humanitaire, asile, mutuelle des jeunes, fonds vert), DPI-A, fonds maladies rares, imagerie lourde libérée, vente d'une partie de l'or, consolidation des réserves publiques, contribution sur la valeur du sol, plus-values au décès, trésorerie de l'État, vote obligatoire et vote blanc reconnu, paquet climat sans signal-prix sur le carburant et son financement."
  mainteneurs := ["@TOrientationD"]
  source := "Programme de TOrientationD (texte en cours de rédaction)"
  mesures := mesures
  entreeEnVigueur := 2
  arbitrages := arbitrages

end Programmes.TexteOrientationD
