import Modele
import Hypotheses
import Proprietes

/-!
# Parti communiste français — Plan climat « Empreinte 2050 »

Transcription **partielle et non officielle** du plan climat du PCF
(ecologie.pcf.fr/plan-climat, document « Empreinte 2050 » du 6 novembre
2023, consulté le 21 octobre 2026). Le plan chiffre un investissement
supplémentaire total de 186 Md€/an (7,9 % du PIB), public et privé
confondus, sans en isoler la part des administrations publiques.

Règle de transcription : une mesure devient un levier seulement si la
source donne un montant annuel d'argent public, ou un objectif que le
modèle commun représente (réduction d'émissions). Les prêts à taux zéro,
les financements du pôle public bancaire et les investissements privés
sont cités mais pas imputés aux administrations publiques. Les hypothèses
de conversion sont écrites dans le champ `source`. Aucun engagement n'est
déclaré.

Les parties C (électricité), D (financement) et E du document n'ont pas
pu être lues intégralement : les mesures du nucléaire sont reprises du
discours de présentation et de la presse (voir README.md).
-/

namespace Programmes.PCF
open Modele

def plan : String := "Empreinte 2050 (PCF, 6 novembre 2023)"

/-- Coût du programme gouvernemental de 6 EPR2 : 72,8 Md€ (euros 2020),
devis EDF du 18 décembre 2025, dont au moins la moitié financée par un prêt
de l'État (accord État-EDF, juin 2025). Hypothèse : même coût unitaire et
même schéma de financement pour les 20 EPR2 du plan, prêt versé de 2027
(année 2 de la projection) à 2050, soit 24 ans : 72 800 / 6 × 20 / 2 / 24
≈ 5 055 M€/an. Les 12 SMR ne sont
pas chiffrés. -/
def pretEPR : Int := 5055

/-- TVA sur les carburants de 20 % à 5,5 % (F. Roussel, AFP des 11 et
19 septembre 2026 : « 30 centimes en moins » par litre ; non chiffré par le
parti). TVA sur les carburants des voitures particulières : 8 Md€ en 2024
(É. Pichet, Connaissance des Énergies, 5 septembre 2026, déjà utilisé par
l'axe énergie), × 14,5 / 20 (calcul) : voitures seulement (les
entreprises récupèrent la TVA), prix de 2024. Ordre de grandeur : le
modèle retire déjà 155 € de TVA par voiture électrique de plus (érosion de
l'assiette au taux plein), où le taux réduit n'en retirerait que ≈ 43 € ;
avec les voitures électriques de PC-10, le recouvrement atteint quelques
centaines de M€ en 2030, non corrigé. Variante : 12 Md€,
bas de la fourchette du gouvernement (12 à 15 Md€, AFP, 22 septembre 2026).
La directive TVA n'autorise pas de taux réduit sur les carburants (Public
Sénat, 26 mars 2026). La hausse de consommation due à la baisse du prix
(≈ −12 % TTC) n'est pas modélisée. -/
def tvaCarburantsVoitures : Int := 8000
def baisseTvaCarburants : Int := tvaCarburantsVoitures * (200 - 55) / 200

theorem tva_carburants_valeur : baisseTvaCarburants = 5800 := by decide

def mesures : List Mesure := [
  { id := "PC-01", titre := "Investissement ferroviaire supplémentaire"
    source := s!"{plan}, B.1 Transports, p. 15 : « 10 milliards d'euros par an » ; trafic voyageurs × 2,6, part du rail en longue distance de 10 à 40 % d'ici 2045"
    leviers := [.depenseSur .affairesEconomiques 10000] },
  { id := "PC-02", titre := "Réseau cyclable : 100 000 km de voies"
    source := s!"{plan}, B.1 Transports, p. 14 : « 1 milliard d'euros par an » ; part modale du vélo de 1 à 6 %"
    leviers := [.depenseSur .affairesEconomiques 1000] },
  { id := "PC-03", titre := "Rénovation thermique du parc de logements privés"
    source := s!"{plan}, B.2 Logement, p. 22 : « 10 milliards d'euros d'argent public seront investis chaque année », complétés par 15 Md€/an de prêts à taux zéro (banques et Action logement, non imputés) ; 900 000 rénovations moyennes et 264 000 profondes par an dès 2032"
    leviers := [.depenseSur .logementEnvironnement 10000] },
  { id := "PC-04", titre := "Rénovation du parc de bâtiments publics"
    source := s!"{plan}, B.2 Logement, p. 22 : « 7 milliards d'euros par an »"
    leviers := [.depenseSur .logementEnvironnement 7000] },
  { id := "PC-05", titre := "Rénovation du parc social"
    source := s!"{plan}, B.2 Logement, p. 22 : « jusqu'à 8 milliards d'euros par an », financeur non précisé (bailleurs sociaux hors administrations publiques) : non imputé"
    leviers := [] },
  { id := "PC-06", titre := "Décarbonation du bâtiment : −53 % d'émissions d'ici 2030"
    source := s!"{plan}, B.2 Logement, p. 20 et 25 : « −53 % d'ici 2030 », sortie du fioul en 2030, pompes à chaleur dans 65 % des logements. Conversion : 60 Mt CO₂e d'émissions du bâtiment en 2023 (Citepa, hypothèse) × 53 % ≈ 32 Mt ; coût porté par PC-03 et PC-04"
    leviers := [.transition .batiments 32 0] },
  { id := "PC-07", titre := "Décarbonation des transports : −11 % d'émissions en 2030"
    source := s!"{plan}, B.1 Transports, p. 13 et 19 : « baisse de 11 % en 2030, 43 % en 2035 » ; fin des ventes de véhicules thermiques neufs en 2035. Conversion : 126 Mt CO₂e des transports en 2023 (Citepa, hypothèse) × 11 % ≈ 14 Mt ; coût porté par PC-01 et PC-02"
    leviers := [.transition .transports 14 0] },
  { id := "PC-08", titre := "Programme nucléaire : 20 EPR2 et 12 SMR d'ici 2050"
    source := s!"Discours de présentation du plan (F. Roussel, 6 novembre 2023) : « 20 réacteurs EPR2 et 12 réacteurs modulaires (SMR NUWARD) d'ici 2050 », prolongation du parc au-delà de 60 ans. Financement : hypothèse du schéma gouvernemental (voir `pretEPR`), soit {pretEPR} M€/an de prêt de l'État à EDF"
    leviers := [.pretEtat pretEPR]
    debut := 0 },
  { id := "PC-10", titre := "Électrification du parc : fin des ventes thermiques en 2035, 2,5 millions de voitures par an"
    source := s!"{plan}, B.1 Transports, p. 17-18 et B.3, p. 29 : parc entièrement électrifié en 2048, capacité de 2,5 millions de voitures par an d'ici 2035 ; conversion : +500 000 électriques par an au-delà de la tendance, sans prime (interdiction), coût public nul ; bornes correspondantes non chiffrées par la source"
    leviers := [.aideAchatElectrique 500000 0 .obligation] },
  { id := "PC-09", titre := "Nationalisation de BNP Paribas et de TotalEnergies"
    source := "Discours de présentation du plan (6 novembre 2023) et presse ; TotalEnergies réaffirmée dans le tract carburant de septembre 2026 ; la Société Générale est ajoutée par une tribune du bulletin CommunisteS n° 1104 (14 octobre 2026), pas par le candidat ; achat ponctuel sans montant dans la source : non imputé (le levier de prise de participation est un flux annuel)"
    leviers := [] },
  { id := "PC-11", titre := "Allocations familiales dès le premier enfant"
    source := "Proposition de loi d'É. Bénard (groupe GDR), adoptée en première lecture le 5 juin 2025 ; coût 2,8 Md€ bruts pour 70 € par mois (direction de la Sécurité sociale ; 1,8 Md€ nets ; 3,58 Md€ pour 75 € selon LexImpact), rapport AN n° 1473"
    leviers := [.depenseSur .famille 2800] },
  { id := "PC-12", titre := "90 000 enseignants, AESH, infirmières et médecins scolaires"
    source := "pcf.fr, 14 octobre 2026 ; non chiffré : 4 000 postes coûtent 150 M€ en année pleine (gouvernement, janvier 2025), soit ≈ 3,4 Md€ (calcul, hypothèse)"
    leviers := [.creationPostes .enseignement [90000] 37500, .annonceEmplois 90000] },
  { id := "PC-13", titre := "5 Md€ pour la jeunesse et la rénovation du bâti scolaire"
    source := "pcf.fr, 14 octobre 2026 : 5 Md€ « immédiatement »"
    leviers := [.depenseSur .enseignement 5000] },
  { id := "PC-14", titre := "Refus de la hausse du budget militaire prévue au PLF 2027"
    source := "Hausse de 6,4 Md€ des crédits des Armées au PLF 2027 (Acteurs publics, 16 juillet 2026 ; bulletin du PCF CommunisteS n° 1104, 14 octobre 2026, p. 2, pour un budget de 63,4 Md€), appliquée à la loi de programmation militaire que la référence suit ; variante : 7 Md€ (page pcf.fr du 14 octobre 2026 telle que lue le 21 octobre)"
    leviers := [.economieSur .defense 6400]
    variantes := [{ nom := "7 Md€ (pcf.fr)", leviers := [.economieSur .defense 7000] }] },
  { id := "PC-15", titre := "ISF rétabli et triplé"
    source := "Comparateur IFRAP 2027 ; discours de F. Roussel, 15 septembre 2026 ; non chiffré : l'ISF rapportait 4,1 Md€ en 2017, triplé ≈ 12,3 Md€ statiques, moins l'IFI supprimé (2,3 Md€), soit ≈ 10 Md€ (calcul, hypothèse)"
    leviers := [.prelevementSur .patrimoine 10000] },
  { id := "PC-16", titre := "SMIC porté à 1 600 € net"
    source := "20 mesures des parlementaires communistes (Public Sénat, 29 janvier 2025) : « revalorisation du SMIC à 1 600 euros net mensuels ». Conversion au brut au ratio net/brut du SMIC (1 443,11 / 1 823,03 au 1er janvier 2026, cotisations salariales de 20,84 %) : 2 021 € bruts, hausse calculée sur le SMIC projeté de 2027, ≈ +7,7 % (même conversion que L-11) ; agents publics déjà relevés de 10 % par PC-19 : composante publique non comptée"
    leviers := [.smicCibleBrut 2021 false] },
  { id := "PC-17", titre := "Retraite à 60 ans à taux plein"
    source := "pcf.fr, « Retraites : pour une réforme digne des jours heureux » : « rétablir l'âge de départ à 60 ans », financé en taxant les revenus financiers (PC-18) ; reprise en 2026 (France-Vote, 5 octobre 2026). Âge légal fixé à 60 ans dès l'entrée en vigueur ; le coût suit l'hypothèse économique du scénario"
    leviers := [.ageLegalCible 720 0] },
  { id := "PC-18", titre := "Cotisation sociale sur les revenus financiers des entreprises"
    source := "F. Roussel (Public Sénat, 9 septembre 2019) : « récupérer tout de suite 30 milliards d'euros » en soumettant à cotisation dividendes et placements (assiette de 298,8 Md€ de revenus financiers en 2018, L'Info Durable, 14 septembre 2019) ; chiffrage du parti de 2019, non actualisé, sans contre-expertise"
    leviers := [.prelevementSur .cotisations 30000] },
  { id := "PC-19", titre := "Point d'indice de la fonction publique relevé de 10 %"
    source := "20 mesures des parlementaires communistes (29 janvier 2025) : « hausse de 10 % du point d'indice » ; non chiffré : l'Institut Montaigne évaluait la hausse de 30 % du programme de 2022 à 76 Md€ par an, soit ≈ 25,3 Md€ pour 10 % (calcul, proportionnel)"
    leviers := [.remunerationPublique .traitement .fonctionnement [25300]] },
  { id := "PC-20", titre := "Logement social : 15 Md€ par an d'aides à la pierre, 200 000 logements par an"
    source := "F. Roussel, propositions logement (Journal de l'Agence, 28 octobre 2026) : « produire un million de logements sociaux » en cinq ans et « rétablissement de 15 milliards d'euros par an d'aides à la pierre de l'État » ; TVA à 5,5 % sur le logement social et fin de la réduction de loyer de solidarité non chiffrées"
    leviers := [.investissement .logementEnvironnement 15000] },
  { id := "PC-21", titre := "« 100 % Sécu » : remboursement intégral des soins"
    source := "Positions 2026 (France-Vote, 5 octobre 2026) : « cent pour cent Sécurité sociale » ; non chiffré par le parti : 17,1 Md€ par an (Institut Montaigne, 14 février 2022, même mesure de la NUPES, fourchette 15 à 26)"
    leviers := [.depenseSur .sante 17100] },
  { id := "PC-22", titre := "Impôt sur les sociétés rétabli à 33 %"
    source := "20 mesures des parlementaires communistes (29 janvier 2025) : « rétablissement de l'impôt sur les sociétés à 33 % » ; taux normal porté de 25 % à 33,33 %, rendement calculé par le modèle (pilier 2, réponse de l'assiette)"
    leviers := [.impotSocietes 3333] },
  { id := "PC-23", titre := "TVA sur les carburants ramenée de 20 % à 5,5 %"
    source := s!"F. Roussel, AFP des 11 et 19 septembre 2026 (« 30 centimes en moins ») ; non chiffré par le parti : 8 Md€ de TVA sur les carburants des voitures en 2024 (Pichet) × 14,5/20 = {baisseTvaCarburants} M€ (calcul, voir `baisseTvaCarburants`) ; contraire à la directive TVA ; hausse de consommation et recouvrement avec l'érosion de TVA par les voitures électriques non modélisés"
    leviers := [.prelevementSur .tva (0 - baisseTvaCarburants)]
    variantes := [{ nom := "12 Md€ (bas de la fourchette du gouvernement)", leviers := [.prelevementSur .tva (-12000)] }] }
]

def programme : Programme where
  id := "PCF"
  nom := "Parti communiste français — Empreinte 2050"
  description := "Transcription partielle et non officielle du plan climat « Empreinte 2050 » : 28 Md€/an de dépenses publiques chiffrées (ferroviaire, vélo, rénovation), réductions d'émissions annoncées pour 2030, programme de 20 EPR2 financé par prêt de l'État. La source annonce 186 Md€/an d'investissement total, public et privé. Propositions de 2026 (F. Roussel candidat, pas de programme 2027 chiffré) : allocations familiales dès le premier enfant, 90 000 enseignants, 5 Md€ pour la jeunesse, refus de la hausse du budget militaire, ISF triplé. Ajouts du 28 octobre 2026 (propositions des parlementaires communistes et de F. Roussel) : SMIC à 1 600 € net, retraite à 60 ans, cotisation sur les revenus financiers, point d'indice +10 %, 15 Md€ d'aides à la pierre, 100 % Sécu, IS à 33 %. Ajout du 30 octobre 2026 : TVA sur les carburants à 5,5 % ; refus de la hausse militaire ramené à 6,4 Md€ (PLF 2027)."
  mainteneurs := ["@TOrientationD"]
  source := "https://ecologie.pcf.fr/plan-climat/ et document « Empreinte 2050 » (consultés le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.PCF
