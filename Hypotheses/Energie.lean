import Modele
import Hypotheses.Electricite

/-!
# Axe énergie et transports : prix du pétrole, électrification, air

Prix du Brent appliqué comme un choc de niveau sur le PIB de départ, pour le
tendanciel comme pour chaque programme : −0,25 % de PIB par tranche de
+10 $ au-dessus du prix de référence de 63 $.

* Élasticité : +10 $ par baril réduit le PIB de 0,2 à 0,3 % à long terme
  (INSEE, Note de conjoncture, mars 2019, éclairage « pétrole » : modèles
  Mésange, SVAR, NiGEM) ; valeur médiane retenue.
* Référence : 63 $ par baril, hypothèse de la Note de conjoncture de
  l'INSEE de décembre 2025 pour le premier semestre 2026.

## Électrification du parc (règlement (UE) 2023/851)

Le règlement impose 0 g CO₂/km aux voitures neuves vendues à partir de 2035.
Sa révision n'est pas adoptée : la Commission a proposé 90 % en décembre
2025, le compromis en discussion au Parlement européen retient 87,5 %
(vote en plénière attendu en décembre 2026, puis Conseil) ; le modèle
applique le droit en vigueur. Ventes de voitures électriques neuves : 331 200 en
2025 (19,9 % de 1 665 000 immatriculations, PFA / AAA Data), portées
linéairement à la totalité des ventes neuves en 2035 : +133 000 par an. Les
voitures que les aides rendent électriques (voir « Aubaine ») et celles des
obligations s'ajoutent dans la limite des ventes neuves.

Chaque voiture thermique remplacée retire de l'assiette fiscale (É. Pichet,
Kedge, Connaissance des Énergies, 5 septembre 2026 : 16 Md€ d'accises et 8 Md€ de TVA sur les carburants des 38,6 M de
voitures thermiques, moins ≈ 112 € de taxes sur l'électricité consommée) :
354 € d'accises et 155 € de TVA par an. La projection retire ces montants
chaque année pour les nouvelles électriques ; ils suivent ensuite le PIB
nominal comme le reste de l'assiette.

Bornes : l'ouverture de points publics (30 000 en 2025) suit les ventes
tendancielles d'électriques. Puissance moyenne d'un point : 16,6 kW, calée
sur la référence (1,6 M de voitures électriques, 175 000 points) pour
retrouver les 140 % de l'objectif AFIR mesurés fin mars 2026 (Transport &
Environment) ; les hybrides rechargeables (0,8 kW chacun dans l'AFIR) ne
sont pas suivis par le modèle, d'où une puissance moyenne prudente.

CO₂ : une voiture thermique du parc émet 156 g CO₂e/km (SDES, 2023) sur
11 600 km/an (SDES, 2026), soit 1,81 t/an ; une électrique consomme
20,6 kWh/100 km pertes de recharge comprises (ICCT, 2021), soit 2 390 kWh
à 46,1 g/kWh (ADEME, mix moyen 2025) : 0,11 t/an. `co2EviteParVehiculeKg`
= 1 700 kg par an (fabrication exclue). Seules les voitures électriques
ajoutées par les mesures comptent : celles des ventes tendancielles sont
déjà dans la baisse tendancielle des émissions.

Particules selon la vignette Crit'Air (`pmRelatifCritAirPm`, pm de la
moyenne du parc thermique) : limites d'émission des normes Euro (diesel
Euro 2 : 80 mg/km, Euro 3 : 50, Euro 4 : 25, Euro 5-6 : 4,5 ; essence
Euro 5-6 : 4,5 ; Crit'Air 3 supposée pour moitié diesel Euro 4 et pour
moitié essence Euro 2-3, ≈ 3 mg/km, soit 14) pondérées par le parc au
1er janvier 2026 (SDES : Crit'Air 1 38,0 %, 2 34,2 %, 3 16,6 %, 4 4,6 %,
5 et non classées 3,0 %, électriques 3,5 %) : moyenne 10,7 mg/km. Facteurs :
Crit'Air 1 et 2 0,42, Crit'Air 3 1,31, Crit'Air 4 4,69, Crit'Air 5 7,5.
Les limites d'homologation servent d'indicateur relatif ; les vieilles
voitures roulent moins que la moyenne, ce qui réduit l'effet (non modélisé).

## Rénovation énergétique des logements (sous-modèle `Renovation`)

* Volume et aide moyenne : budget 2026 de 3,5 Md€ pour au moins 120 000
  rénovations d'ampleur et 150 000 gestes (réponse ministérielle à la
  question n° 9948, JO du 17 mars 2026) : 270 000 rénovations, 13 000 €
  d'aide en moyenne (2025 : 307 731 logements, 3,81 Md€, bilan de l'Anah
  du 20 février 2026). Les dépôts de dossiers d'ampleur ont été divisés par
  quatre au premier semestre 2026 après la baisse des plafonds (AFP,
  27 juillet 2026).
* Part rurale : 47,7 % des logements aidés par l'Anah en 2021 étaient en
  zone rurale (bassins de vie ; réponse à la question écrite Sénat
  n° 00291, 2022) : `partRuralePm` = 480. Aucune donnée plus récente.
* Travaux : 59 474 € en moyenne par rénovation d'ampleur (Anah, bilan
  2025) et 12 100 € par geste (ONRE) : 33 000 € pour le mélange 2026. Les
  rénovations suscitées sont des travaux adressés à la construction (aide
  et part des ménages) ; le bonus versé aux rénovations qui auraient eu
  lieu est un transfert aux ménages.
* Effet d'aubaine : aucune estimation propre à MaPrimeRénov' ; ≈ 80 % de
  bénéficiaires non additionnels pour le crédit d'impôt CITE (CAE, Focus
  n° 107, juin 2024), aubaine supposée nulle par France Stratégie (2024),
  qui juge lui-même l'hypothèse irréaliste. `aubainePm` = 500 (hypothèse
  intermédiaire, aide mieux ciblée que le CITE). Avec une demande
  linéaire en l'aide, une hausse de 1 % de l'aide suscite 0,5 % de
  rénovations en plus.
* Économies : 17,1 MWh/an conventionnels par rénovation d'ampleur et
  5,9 MWh/an par geste (ONRE, 2026), soit 10,9 MWh/an pour le mélange
  2026 ; les économies réelles valent 42 % des conventionnelles pour
  l'isolation (INSEE-SDES, document de travail 2025-16) et la moitié pour
  les certificats d'économies d'énergie (Wald et Glachant, 2023) :
  `economieKWhParRenovation` = 5 400.
* Chauffage (INSEE Première n° 2088, janvier 2026, données 2022) : fioul
  8,5 % des résidences principales, 16,7 % en rural ; gaz 35 % ; part du
  gaz en rural non publiée, 20 % supposés (réseau moins dense).
* Facteurs : fioul 324,7 g CO₂e/kWh, gaz 239 g/kWh PCI (Base Carbone
  v23.9) ; accise sur le fioul ≈ 15 €/MWh et sur le gaz 16,66 €/MWh
  (août 2026) ; TVA de 20 % ≈ 18 €/MWh pour un prix TTC de ≈ 110 €/MWh
  (hypothèse) ; valeur importée du fioul 56 €/MWh au prix de référence
  (0,56 €/L, comme le carburant du sous-modèle automobile), du gaz
  35 €/MWh (hypothèse : prix de gros européen moyen).
* Non modélisés : l'électricité économisée (exportable), l'effet de levier
  sur les travaux financés par les ménages (≈ 1 € par € d'aide, CAE) et la
  captation d'une partie de l'aide par les prix (IPP, travaux en cours).

## Élasticités-prix des activités taxées (levier `taxeEnvironnementale`)

Valeurs de long terme, en valeur absolue : recul de l'activité (et de ses
émissions) pour +1 % de coût.
* Vols intérieurs : 0,9 (demande nationale −0,8, courts-courriers ×1,1 :
  InterVISTAS pour l'IATA, 2007 ; −0,4 à −1,1 à court terme pour le trafic
  intérieur français, Sauvant, Notes de synthèse du SES, 2003).
* Poids lourds : 0,5 (véhicules-kilomètres au prix au kilomètre, meilleure
  estimation de long terme de 0,6 dans une fourchette de 0,1 à 0,5, report
  modal compris : Significance et CE Delft pour la Commission européenne,
  2010 ; valeur médiane retenue).
* Carburants routiers : 0,6 (consommation de carburant au prix, long terme :
  Goodwin, Dargay et Hanly, Transport Reviews, 2004 ; France : 0,6 à 0,7,
  Calvet et Marical, Économie et Statistique n° 446, 2011 ; méta-analyse :
  0,72 pour l'essence, 0,60 pour le gazole, Labandeira et al., Energy
  Policy, 2017 ; 0,40, Clerc et Marcus, INSEE, 2009).
* Chauffage fossile : 0,3 (fioul : 0,20, Clerc et Marcus, 2009 ; 0,75,
  Labandeira et al., 2017 ; valeur prudente dans la fourchette).

## Prix du pétrole et émissions (loi économique d'octobre 2026)

Un Brent écarté du prix de référence change le prix TTC des carburants et
du fioul, donc, à long terme, les émissions des voitures et utilitaires
légers et celles du fioul des bâtiments, selon les élasticités-prix
ci-dessus :
* élasticité du prix TTC au Brent, structure des prix de 2024 (DGEC, « Prix
  des produits pétroliers en 2024 » : brut ≈ 46,5 c€/L ; gazole 169 c€/L
  TTC, SP95-E10 178, fioul 120 ; TVA de 20 % comprise ; calcul) : gazole
  0,33, SP95-E10 0,31, retenu 0,33 pour les carburants (gazole
  majoritaire : hypothèse), fioul 0,47 ; le prix du gaz ne suit plus le pétrole
  (82 % des prix européens formés sur les marchés gaziers, IGU, 2025) et
  n'est pas indexé ;
* part des émissions des transports due aux voitures et utilitaires légers :
  (66,5 + 19,3) / 124,9 Mt en 2024 (SDES, Chiffres clés des transports ;
  calcul) ; les poids lourds, dont le carburant ne fait qu'une partie du coût
  au kilomètre, ne sont pas comptés ;
* part des émissions des bâtiments due au fioul : 85 % des émissions des
  bâtiments viennent du chauffage fossile (hypothèse, celle de la composante
  carbone du Texte Orientation D), dont la part du fioul se déduit des parts
  de logements chauffés au fioul (8,5 %) et au gaz (35 %) et de leurs
  facteurs d'émission (325 et 239 kg/MWh) du sous-modèle de la rénovation
  (calcul) ;
* ajustement : 40 % de l'écart à l'effet de long terme comblé chaque année,
  rapport des élasticités de court et de long terme (0,19 / 0,40, Clerc et
  Marcus, 2009 ; ≈ 0,3 / 0,65, Calvet et Marical, 2011 ; 0,23 / 0,72,
  Labandeira et al., 2017 ; calcul).
Au Brent de 100 $ (référence 63 $), l'effet de long terme vaut ≈ −8 % des
émissions des transports ; à 50 $, ≈ +3 %. Seules les émissions suivent :
l'assiette des accises, la TVA sur les carburants et la facture importée ne
sont pas corrigées de ces volumes (elles le sont des seules voitures
électriques). L'effet de la croissance sur les
émissions est dans `Hypotheses.Eco` (`elasticitesEmissionsActivitePm`).

## Aubaine des aides à l'achat de voitures électriques (octobre 2026)

Forme réduite calée sur les études françaises : une aide de `A` k€ rend
électriques `1 − e^(−β A)` des achats qui ne l'auraient pas été, la part
des ventes déjà électrique (trajectoire tendancielle et obligations des
mesures) étant ôtée chaque année ; la dépense paie toutes les voitures
aidées. Sensibilités :
* aide générale, β = 55 pm par k€ : 0,045 par k€ (IPP, Perspectives
  budgétaires 2026, chapitre 4 : 81 % d'aubaine pour le bonus de 6 000 € de
  2022) et ≈ 0,07 (France Stratégie, rapport France Relance, 2024 : +3,3
  points de part de marché électrique en 2021) ; calcul. Une prime de
  4 000 € rend électriques 19,7 % des achats non électriques : ≈ 13 % des
  voitures aidées en 2027, ≈ 8 % en 2030 ;
* aide réservée aux ménages modestes (leasing social), β = 115 pm par k€ :
  semi-élasticité au prix des déciles 1 à 5 2,1 fois la moyenne (0,25 contre
  0,119 : DGE, Théma n° 37, 2025 ; calcul) ; ≈ 50 % des acheteurs sous le
  revenu médian rendus électriques par les aides (Sheldon, Dua et Alharbi,
  Energy Economics, 2023). Une aide de 6 000 € : 49,8 % des achats non
  électriques ;
* une obligation (fin de ventes thermiques, quotas) compte chaque voiture
  visée.
Aucune évaluation causale du leasing social n'est publiée ; l'IPP trouve
34 à 37 % d'additionnalité pour les centiles de revenu 11 à 30 avec 6 000 €.

Outre-mer (zones non interconnectées) : l'électricité y coûte bien plus à
produire que le tarif péréqué ne rapporte ; le surcoût est compensé par les
charges de service public de l'énergie (3,18 Md€ en 2025, 3,27 Md€ en
2026 ; CRE, délibération 2026-149), financées depuis août 2025 par une
part de l'accise sur l'électricité. Coût de production en 2022 : Mayotte
445 €/MWh, Guadeloupe 351, Martinique 323, Guyane 274, Réunion 267 (CRE,
délibération 2024-65) ; ≈ 1 000 €/MWh dans les communes de l'intérieur de
la Guyane (CRE, délibération 2019-006). À Mayotte, les recettes couvrent
≈ 20 % du coût (43,7 M€ sur 219,5 M€ prévus en 2026, CRE 2025-180) :
`surcoutPerequationZniEurosMWh` = 360 (80 % de 445, base Mayotte ;
prudent pour les sites isolés de Guyane). Consommation d'un foyer
nouvellement raccordé : `consommationFoyerZniKWh` = 2 500 kWh/an
(hypothèse : moitié des 5 100 kWh d'un foyer guadeloupéen, OREC 2024, pour
des ménages modestes jusque-là sans électricité).

Non modélisé : effet du prix du pétrole et de l'ETS2 sur l'inflation et sur
les volumes de carburant (et donc les accises) ; importations de véhicules
électriques (le sous-modèle automobile les traite pour le remplacement
public).
-/

namespace Hypotheses.Energie
open Modele

def sources : List String := [
  "INSEE, Note de conjoncture mars 2019, éclairage pétrole : +10 $ → −0,2 à −0,3 % de PIB",
  "INSEE, Note de conjoncture décembre 2025 : Brent figé à 63 $ au premier semestre 2026",
  "Électrification : 331 200 voitures électriques neuves en 2025, 19,9 % de 1 665 000 immatriculations (PFA, AAA Data) ; 100 % des ventes neuves en 2035 (règlement (UE) 2023/851) ; bornes : ≈ 30 000 points publics ouverts par an (Avere-France, 200 045 points au 31 juillet 2026)",
  "Érosion fiscale par voiture électrique : 354 € d'accises et 155 € de TVA par an (É. Pichet, « La voiture électrique peut-elle faire disparaître 20 milliards de recettes fiscales ? », Connaissance des Énergies, 5 septembre 2026 : 16 et 8 Md€ en 2024 sur 38,6 M de voitures thermiques, 4 à 5 Md€ de taxes sur l'électricité pour un parc entièrement électrique)",
  "AFIR (règlement (UE) 2023/1804, art. 3) : 1,3 kW par voiture électrique à batterie ; la France à 140 % de l'objectif fin mars 2026 (Transport & Environment, cité par Auto Infos, 23 juillet 2026)",
  "CO₂ évité par voiture : 156 g/km (SDES, « Quels freins à la baisse des émissions du parc automobile », 3 juillet 2023) × 11 600 km (SDES, 40 millions de voitures au 1er janvier 2026) − 2 390 kWh (ICCT, Bieker 2021) × 46,1 g/kWh (ADEME, Base Empreinte, mix moyen 2025)",
  "Particules : limites des normes Euro (directives et règlements UE, d'après Wikipédia « European emission standards ») ; vignettes Crit'Air (arrêté du 21 juin 2016) ; parc par vignette au 1er janvier 2026 (SDES, 10 juillet 2026)",
  "Décès évités : 40 000 décès/an attribuables aux PM2,5 (Santé publique France, 2021) ; le trafic routier pèse ≈ 15 % des PM2,5 primaires (Citepa), dont la moitié à l'échappement ; rapporté à 39 millions de voitures : ≈ 90 décès/an par million de véhicules remplacés (hypothèse de calcul, à affiner)",
  "Infrastructure : 1 point de recharge public pour 10 véhicules électriques (recommandation AFIR / objectif français de 400 000 points, hypothèse)",
  "Gain commercial par véhicule remplacé : 770 L × valeur à l'import du carburant (0,45 / 0,56 / 0,78 €/L selon le Brent) − 1 870 kWh × 60 €/MWh d'électricité non exportée (sous-modèle automobile)",
  "Facture énergétique importée : ≈ 60 Md€ en 2024 (Douanes, Le chiffre du commerce extérieur), supposée proportionnelle au prix du Brent",
  "Rénovation : Anah (chiffres clés 2024, bilan 2025) ; réponse ministérielle n° 9948 (JO du 17 mars 2026) ; ONRE (2026) ; INSEE Première n° 2088 (janvier 2026) ; INSEE-SDES DT 2025-16 ; CAE Focus n° 107 (juin 2024) ; Base Carbone v23.9",
  "Outre-mer : CRE, délibérations 2026-149, 2025-180, 2024-65, 2019-006 ; OREC Guadeloupe, bilan de l'énergie 2024"]

/-- Particules à l'échappement par vignette Crit'Air (indice 0 : moyenne du
parc thermique ; 1 à 5 : Crit'Air 1 à 5), pm de la moyenne. -/
def pmRelatifCritAir : List Int := [1000, 420, 420, 1310, 4690, 7500]

/-- Rénovation énergétique aidée (MaPrimeRénov'), commune aux trois
variantes ; la valeur importée du fioul suit le prix du Brent dans la
projection. Sources et calculs : docstring du module. -/
def renovation : Renovation where
  renovationsAideesParAn := 270000
  partRuralePm := 480
  aideMoyenneEuros := 13000
  aubainePm := 500
  economieKWhParRenovation := 5400
  coutTravauxMoyenEuros := 33000
  partFioulNationalPm := 85
  partGazNationalPm := 350
  partFioulRuralPm := 167
  partGazRuralPm := 200
  co2FioulKgMWh := 325
  co2GazKgMWh := 239
  importFioulEurosMWh := 56
  importGazEurosMWh := 35
  accisesFioulEurosMWh := 15
  tvaFioulEurosMWh := 18
  accisesGazEurosMWh := 17
  tvaGazEurosMWh := 18

/-- Pompes à chaleur air/eau des mesures, à la place de chaudières au fioul
ou au gaz.

* Chaleur fournie : une maison au fioul consomme ≈ 1 500 L par an, soit
  ≈ 15 MWh (5 millions de m³ pour 3,3 millions de logements, FF3C via
  Connaissance des énergies, 25 novembre 2025) ; au rendement saisonnier
  de 0,8 d'une chaudière (ADEME, via Hello Watt, 2025), 12 000 kWh de
  chaleur (calcul).
* Coefficient de performance saisonnier mesuré : 2,9 en moyenne sur 90 PAC
  air/eau (ADEME, campagne « 100 PAC », 7 octobre 2025).
* Énergie remplacée en zone rurale : maisons rurales chauffées au fioul
  20 %, au GPL 4 %, au gaz de réseau 8 % (SDES, enquête Logement 2020,
  publiée le 28 octobre 2024) ; fioul et GPL, combustibles livrés, comptés
  ensemble : 750 pm (calcul). Moyenne nationale : fioul 8,5 % et gaz (GPL
  compris) 35 % des résidences principales (Insee Première n° 2088,
  13 janvier 2026) : 195 pm (calcul).
* Effet d'aubaine : celui des aides à la rénovation du modèle commun.
* Électricité résidentielle : accise de 30,62 €/MWh depuis le 1er août
  2026 (DGFiP, formulaire 2040-TIC-SD) ; TVA à 20 % sur un prix hors TVA
  de 166,75 €/MWh accise comprise (tarif réglementé Base 6 kVA, 0,2001 €
  TTC le kWh au 1er août 2026) : 33 €/MWh (calcul).
* Réseau de gaz : charges d'exploitation de GRDF de 1 714 M€ par an pour
  ≈ 11,5 millions de clients (CRE, ATRD7, 25 janvier 2024 et 16 avril
  2026), ≈ 149 € par client (calcul) ; les coûts baissent moins vite que le
  nombre de clients : dans le scénario de la CRE où les usagers de la
  distribution baissent de 60 %, 27 % du réseau devient abandonnable (CRE,
  « Avenir des infrastructures gazières », 1er juillet 2026), soit 45 % des
  charges d'un client qui part : 67 € par an (calcul). Le coût de
  l'abandon des conduites (≈ 200 € par mètre, ≈ 100 € par branchement,
  même rapport) reste dans le tarif de réseau. -/
def pompesAChaleur : PompesAChaleur where
  besoinChaleurKWh := 15000 * 800 / 1000
  rendementChaudierePm := 800
  scopCentiemes := 290
  partFioulRuralPm := (20 + 4) * 1000 / (20 + 4 + 8)
  partFioulNationalPm := 85 * 1000 / (85 + 350)
  aubainePm := renovation.aubainePm
  accisesElecEurosMWh := 3062 / 100
  tvaElecEurosMWh := 16675 * 20 / 100 / 100
  reseauGazEvitesEuros := 1714000000 / 11500000 * 27 / 60

theorem pompesAChaleur_valeurs :
    pompesAChaleur.besoinChaleurKWh = 12000 ∧ pompesAChaleur.partFioulRuralPm = 750 ∧
    pompesAChaleur.partFioulNationalPm = 195 ∧ pompesAChaleur.accisesElecEurosMWh = 30 ∧
    pompesAChaleur.tvaElecEurosMWh = 33 ∧ pompesAChaleur.reseauGazEvitesEuros = 67 := by decide

/-- Chauffage des bâtiments publics : consommation de gaz et de fioul, GWh
par an, par catégorie, et part dans celle du tertiaire. -/
structure ChauffagePublic where
  /-- État et opérateurs (universités comprises). -/
  etatOperateursGwh : Int
  /-- Communes et intercommunalités (écoles, mairies, équipements). -/
  blocCommunalGwh : Int
  /-- Collèges (départements). -/
  collegesGwh : Int
  /-- Lycées (régions). -/
  lyceesGwh : Int
  /-- Hôpitaux publics. -/
  hopitauxGwh : Int
  /-- Gaz et fioul de tout le tertiaire, public et privé. -/
  tertiaireFossileGwh : Int
  deriving Repr

namespace ChauffagePublic
def totalGwh (c : ChauffagePublic) : Int :=
  c.etatOperateursGwh + c.blocCommunalGwh + c.collegesGwh + c.lyceesGwh + c.hopitauxGwh
/-- Part des administrations publiques dans le gaz et le fioul du tertiaire, pm. -/
def partPubliquePm (c : ChauffagePublic) : Int :=
  if c.tertiaireFossileGwh = 0 then 0 else c.totalGwh * 1000 / c.tertiaireFossileGwh
/-- Facture hors taxes de ce gaz et de ce fioul, M€ par an, au prix du gaz
tertiaire. -/
def factureHtMeur (c : ChauffagePublic) (prixEurosMWh : Int) : Int := c.totalGwh * prixEurosMWh / 1000
end ChauffagePublic

/-- Gaz et fioul des bâtiments publics (sources et calculs) :
* État et opérateurs : ≈ 16 TWh par an, dont deux tiers d'énergies
  fossiles (DPT « Politique immobilière de l'État », PLF 2025 ; ministère
  de la Transformation et de la Fonction publiques, communiqué n° 689 du
  14 mars 2023) → 10 666 GWh (calcul) ; les universités, opérateurs de
  l'État, y sont comprises.
* Communes et intercommunalités : 39,7 TWh en 2017, dont 48 % de gaz
  (ADEME, enquête « Dépenses énergétiques des collectivités locales »,
  citée par le Sénat, rapport d'information n° 832, 2022-2023) → 19 056 GWh
  (calcul ; fioul non publié, non compté).
* Collèges : 37,3 millions de m² (Sénat, rapport d'information n° 800,
  2022-2023, « Le bâti scolaire à l'épreuve de la transition écologique »)
  × 135 kWh/m² (écoles, ADEME 2017, d'après le rapport Demarcq du CGE,
  février 2020 ; hypothèse pour les collèges) × 82 % de gaz et de fioul
  (DEPP, rentrée 2018, même rapport) → 4 129 GWh (calcul).
* Lycées : 44,1 millions de m² (lycées généraux et technologiques 25,4,
  professionnels 8,8, cités scolaires 9,9 : Sénat, n° 800) × 135 kWh/m² ×
  77 % (DEPP 2018) → 4 584 GWh (calcul).
* Hôpitaux publics : chauffage des établissements de santé, publics et
  privés, 12,3 TWh dont 75 % fossiles (Pouget Consultants pour la DHUP,
  « Alternatives aux énergies fossiles dans le tertiaire », 2023-2024,
  données CEREN 2020) × 70 % pour le public (part des séjours
  d'hospitalisation complète en médecine, chirurgie, obstétrique en 2022 :
  DREES, « Les établissements de santé », édition 2024 ; hypothèse : les
  surfaces suivent les séjours) → 6 457 GWh (calcul).
* Tertiaire : 107 TWh d'énergies fossiles en 2020 (Pouget Consultants pour
  la DHUP, données CEREN).
Total : ≈ 45 TWh, soit ≈ 42 % du gaz et du fioul du tertiaire (calcul) ;
au prix du gaz des clients non résidentiels, ≈ 2,9 Md€ par an hors taxes
(64,7 €/MWh PCS hors TVA en 2024, 65,7 en 2025 : SDES, « Prix du gaz
naturel en France et dans l'Union européenne », 9 juillet 2025 et
23 juillet 2026). Chiffres d'années différentes (2017 à 2022) : ordre de
grandeur. -/
def chauffagePublic : ChauffagePublic where
  etatOperateursGwh := 16000 * 2 / 3
  blocCommunalGwh := 39700 * 48 / 100
  collegesGwh := 373 * 135 * 82 / 1000
  lyceesGwh := 441 * 135 * 77 / 1000
  hopitauxGwh := 12300 * 75 * 70 / 10000
  tertiaireFossileGwh := 107000

theorem chauffagePublic_valeurs :
    chauffagePublic.totalGwh = 44892 ∧ chauffagePublic.partPubliquePm = 419 ∧
    chauffagePublic.factureHtMeur 65 = 2917 := by decide

/-- Prix du pétrole et émissions, et aubaine des aides à l'électrique : voir
le docstring du module. -/
def elasticitePrixCarburantsBrent : Int := 330
def elasticitePrixFioulBrent : Int := 470
def partTransportsVoitures : Int := (66500 + 19300) * 1000 / 124900
def partBatimentsFossile : Int := 850
def partBatimentsFioul : Int :=
  partBatimentsFossile * (renovation.partFioulNationalPm * renovation.co2FioulKgMWh * 1000
    / (renovation.partFioulNationalPm * renovation.co2FioulKgMWh
      + renovation.partGazNationalPm * renovation.co2GazKgMWh)) / 1000

theorem prixPetrole_valeurs : partTransportsVoitures = 686 ∧ partBatimentsFioul = 210 := by decide
def ajustementPrixEmissions : Int := 400
def sensibiliteAideGenerale : Int := 55
def sensibiliteAideModestes : Int := 115

/-- Élasticités-prix de long terme (valeur absolue, pm) : voir le docstring
du module. -/
def elasticitesPrix : ElasticitesPrix :=
  { aerienInterieur := 900, poidsLourds := 500, carburantsRoutiers := 600, chauffageFossile := 300 }

/-- Part importée de la dépense de transition, par technologie, pm
(leviers `investissementTransition` et `investissementPriveTransition`) ;
recherche documentaire d'octobre 2026, valeurs centrales.

* Pompes à chaleur : 450. Air-eau et hybrides ≈ 40 % (≈ 80 % de celles
  vendues en France sont fabriquées en France ou en Europe, AFPAC 2022 ;
  compresseurs non fabriqués en Europe ; solde extérieur des PAC
  aérothermiques −262 M€ en 2022 pour 8,9 Md€ de marché, ADEME, « Marchés et
  emplois concourant à la transition énergétique », 2024) ; air-air ≈ 60 %
  (800 000 vendues par an, l'essentiel importé d'Asie, Hello Watt, juillet
  2026) ; moyenne pondérée par les dépenses (calcul, hypothèse).
* Voitures électriques : 750 (VE vendus en France en 2025 : 27,2 % fabriqués
  en France, Mobilians ; matériel de transport acheté par les ménages :
  84,3 % importé, Insee Première n° 1756, 2019).
* Utilitaires et camions électriques : 620 (VUL ≈ 60 % : Kangoo, Trafic,
  Master produits en France, Inovev 2024 ; camions ≈ 65 %, batteries
  importées ; hypothèses).
* Solaire : 340 (centrales au sol ≈ 38 % : modules 0,12 €/W et onduleurs
  0,04 sur 0,87 €/W raccordement compris ; toitures de 100 à 500 kW ≈ 30 % ;
  IEA-PVPS, National Survey Report France 2025 ; moyenne des deux, calcul).
* Éolien terrestre : 600 (turbine : 64 à 84 % du coût, aucun turbinier
  terrestre en France ; IRENA-ETSAP 2016, France Renouvelables 2023).
* Rénovation : 200 (construction : 20,3 % de contenu importé, Insee Première
  n° 1756 ; isolation : importations directes 5 %, ADEME 2024).
* Réseaux de chaleur et géothermie : 200 (génie civil local, tubes et
  chaudières en partie importés ; hypothèse).
* HVO : 800 (bioraffineries de La Mède et Grandpuits seules, matières
  premières importées ; Énergies et Mobilités, juin 2026).
* Biogazole (EMAG, B100) : 550 (autosuffisance de 48 % en 2024, colza à 49 %
  français ; FranceAgriMer, janvier 2026).
* Bioéthanol (E85) : 100 (solde extérieur des biocarburants essence
  positif, ADEME 2024).
* Biogaz (captage en décharge, fosses couvertes) : 350 (moteurs et torchères
  importés ; hypothèse).
* Ascenseurs (remplacement et modernisation) : 250 (matériel ≈ la moitié du
  coût d'une opération, le reste en pose, études et main-d'œuvre ; sur le
  matériel, Otis fabrique à Gien ≈ 13 000 appareils et kits par an, les
  autres grands fabricants importent ; 85 % des pièces viennent de France
  ou d'Europe selon la Fédération des Ascenseurs ; hypothèse : moitié du
  matériel importée). -/
def partImporteeTransition : ParTechno :=
  { pompeAChaleur := 450, vehiculeElectrique := 750, vehiculeUtilitaire := 620, solaire := 340,
    eolien := 600, renovation := 200, reseauChaleur := 200, hvo := 800, biogazole := 550,
    bioethanol := 100, biogaz := 350, ascenseur := 250 }

/-- Achats d'équipements fossiles remplacés par la dépense de transition,
pm de la dépense saisie (champ `substitutionBruneTransitionPm`).

* Pompes à chaleur : 130. Une chaudière gaz à condensation posée coûte
  ≈ 5 350 € TTC (4 500 à 6 200 €, La Maison Saint-Gobain, décembre 2025),
  une pompe à chaleur air-eau en rénovation ≈ 13 900 € (ADEME et In Numeri,
  « Marchés et emplois concourant à la transition énergétique », 2024 :
  6,8 Md€ pour 490 000 PAC en 2022), soit 38 % ; un tiers des PAC
  remplacent une chaudière en fin de vie (hypothèse, entre 5 à 7 % si les
  PAC étaient attribuées sans lien avec l'âge de la chaudière et ≈ 60 % si
  toutes prenaient la place des 422 000 chaudières vendues en 2025,
  Uniclima, bilan 2025) : 1/3 × 38 % ≈ 13 % (calcul). Ordre de grandeur de
  la DG Trésor pour l'ensemble du bâtiment : 6 Md€ d'« alternative
  carbonée » évitée pour 39 Md€ d'investissement brut en 2030 (15 %,
  document de travail 2024/2, tableau 1).
* Autres technologies : 0 (véhicules et biocarburants saisis en surcoût ;
  rénovation de l'enveloppe, réseaux de chaleur, solaire, éolien et biogaz
  sans équipement fossile remplacé, hypothèse). -/
def substitutionBruneTransition : ParTechno :=
  { pompeAChaleur := 130, vehiculeElectrique := 0, vehiculeUtilitaire := 0, solaire := 0,
    eolien := 0, renovation := 0, reseauChaleur := 0, hvo := 0, biogazole := 0,
    bioethanol := 0, biogaz := 0 }

def bas : Energie where
  id := "petrole-bas"
  description := "Brent à 50 $"
  prixBrentDollars := 50
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  electrificationTendancielleMilliers := 331
  hausseElectrificationMilliers := 133
  ventesNeuvesMilliers := 1665
  bornesTendanciellesMilliers := 30
  accisesParVehiculeEuros := 354
  tvaParVehiculeEuros := 155
  puissanceParBorneW := 16600
  puissanceAfirParVehiculeW := 1300
  co2EviteParVehiculeKg := 1700
  pmRelatifCritAirPm := pmRelatifCritAir
  renovation := renovation
  partImporteeTransitionPm := partImporteeTransition
  substitutionBruneTransitionPm := substitutionBruneTransition
  elasticitesPrix := elasticitesPrix
  consommationFoyerZniKWh := 2500
  surcoutPerequationZniEurosMWh := 360
  decesEvitesParMillionVehicules := 90
  electricite := Hypotheses.Electricite.electriciteFrance
  pac := pompesAChaleur
  vehiculesParBorne := 10
  gainCommercialParVehiculeEuros := 238
  factureEnergetiqueMeur := 60000
  elasticitePrixCarburantsBrentPm := elasticitePrixCarburantsBrent
  elasticitePrixFioulBrentPm := elasticitePrixFioulBrent
  partTransportsVoituresPm := partTransportsVoitures
  partBatimentsFioulPm := partBatimentsFioul
  ajustementPrixEmissionsPm := ajustementPrixEmissions
  sensibiliteAideGeneralePmParKeur := sensibiliteAideGenerale
  sensibiliteAideModestesPmParKeur := sensibiliteAideModestes
  sources := sources

def central : Energie where
  id := "petrole-central"
  description := "Brent à 63 $"
  prixBrentDollars := 63
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  electrificationTendancielleMilliers := 331
  hausseElectrificationMilliers := 133
  ventesNeuvesMilliers := 1665
  bornesTendanciellesMilliers := 30
  accisesParVehiculeEuros := 354
  tvaParVehiculeEuros := 155
  puissanceParBorneW := 16600
  puissanceAfirParVehiculeW := 1300
  co2EviteParVehiculeKg := 1700
  pmRelatifCritAirPm := pmRelatifCritAir
  renovation := renovation
  partImporteeTransitionPm := partImporteeTransition
  substitutionBruneTransitionPm := substitutionBruneTransition
  elasticitesPrix := elasticitesPrix
  consommationFoyerZniKWh := 2500
  surcoutPerequationZniEurosMWh := 360
  decesEvitesParMillionVehicules := 90
  electricite := Hypotheses.Electricite.electriciteFrance
  pac := pompesAChaleur
  vehiculesParBorne := 10
  gainCommercialParVehiculeEuros := 319
  factureEnergetiqueMeur := 60000
  elasticitePrixCarburantsBrentPm := elasticitePrixCarburantsBrent
  elasticitePrixFioulBrentPm := elasticitePrixFioulBrent
  partTransportsVoituresPm := partTransportsVoitures
  partBatimentsFioulPm := partBatimentsFioul
  ajustementPrixEmissionsPm := ajustementPrixEmissions
  sensibiliteAideGeneralePmParKeur := sensibiliteAideGenerale
  sensibiliteAideModestesPmParKeur := sensibiliteAideModestes
  sources := sources

def haut : Energie where
  id := "petrole-haut"
  description := "Brent à 100 $ (choc)"
  prixBrentDollars := 100
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  electrificationTendancielleMilliers := 331
  hausseElectrificationMilliers := 133
  ventesNeuvesMilliers := 1665
  bornesTendanciellesMilliers := 30
  accisesParVehiculeEuros := 354
  tvaParVehiculeEuros := 155
  puissanceParBorneW := 16600
  puissanceAfirParVehiculeW := 1300
  co2EviteParVehiculeKg := 1700
  pmRelatifCritAirPm := pmRelatifCritAir
  renovation := renovation
  partImporteeTransitionPm := partImporteeTransition
  substitutionBruneTransitionPm := substitutionBruneTransition
  elasticitesPrix := elasticitesPrix
  consommationFoyerZniKWh := 2500
  surcoutPerequationZniEurosMWh := 360
  decesEvitesParMillionVehicules := 90
  electricite := Hypotheses.Electricite.electriciteFrance
  pac := pompesAChaleur
  vehiculesParBorne := 10
  gainCommercialParVehiculeEuros := 488
  factureEnergetiqueMeur := 60000
  elasticitePrixCarburantsBrentPm := elasticitePrixCarburantsBrent
  elasticitePrixFioulBrentPm := elasticitePrixFioulBrent
  partTransportsVoituresPm := partTransportsVoitures
  partBatimentsFioulPm := partBatimentsFioul
  ajustementPrixEmissionsPm := ajustementPrixEmissions
  sensibiliteAideGeneralePmParKeur := sensibiliteAideGenerale
  sensibiliteAideModestesPmParKeur := sensibiliteAideModestes
  sources := sources

def toutes : List Energie := [bas, central, haut]

end Hypotheses.Energie
