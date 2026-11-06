import Modele
import Hypotheses
import Proprietes

/-!
# Rassemblement national — contre-budget du 6 octobre 2026

Transcription **partielle et non officielle** du dossier de presse « Pour la
Renaissance de la France : l'urgence de réparer les finances publiques »
(RN, 6 octobre 2026), connu par la note de contexte de l'Institut de
l'Entreprise (IDEP, octobre 2026) et la presse ; le dossier lui-même n'est
pas publié en ligne à la date de consultation (21 octobre 2026). Le RN
annonce une amélioration nette du solde de 141,7 Md€ en 2031, un déficit
de 2,2 % du PIB et une dette de 112,1 % en 2032.

Règle de transcription : montants **annuels 2031** du dossier (année
pleine), appliqués par le modèle dès l'année 0 ; les montées en charge ne
sont pas reproduites. Les agrégats sans détail de mesure sont transcrits
comme une seule mesure, dont le champ `source` donne le calcul. Le modèle
applique ses propres hypothèses (fuite fiscale, multiplicateur, coût d'un
mois d'âge légal) aux montants annoncés. Aucun engagement n'est déclaré.
-/

namespace Programmes.RN
open Modele

def dossier : String :=
  "RN, « Pour la Renaissance de la France », 6 octobre 2026, via la note IDEP (Institut de l'Entreprise)"

/-- Impôts de production (RN-02) : la CVAE est déjà supprimée en 2030 par
la loi (n° 2025-127, art. 62) que la référence suit (3 400, 2 310 puis
1 090 M€ en euros 2025 de 2027 à 2029, `Hypotheses/Reference.lean`),
×1,0609 en euros 2027 (convention d'O-59 ; calcul). Les 17 Md€ du dossier
ne sont pas ventilés : la part de la CVAE est supposée égale à son
rendement de 2027 (hypothèse) ; la mesure ne retire que son rendement
restant. -/
def impotsProduction : Int := 17000
def cvaeRestante : List Int := ([3400, 2310, 1090, 0] : List Int).map fun x => x * 10609 / 10000

/-- Collectivités (RN-07) : 8,2 / 12 / 14,5 / 16,9 / 18,4 Md€ de 2027 à
2031 (dossier, p. 12, cité par Public Sénat le 14 octobre 2026), montant
2031 retenu (règle du programme). Dont effectifs 3,75 Md€, 35 heures dans
la fonction publique territoriale 1,3, compétences 2,1, intercommunalités
1,25 (Acteurs publics). Les effectifs sont retirés : 116 000 des 201 000
postes de RN-06 sont dans les collectivités (France Transactions, cité par
Planète Grandes Écoles), déjà comptés par RN-06. -/
def collectivites2031 : Int := 18400
def effectifsCollectivites : Int := 3750
def collectivitesHorsEffectifs : Int := collectivites2031 - effectifsCollectivites

theorem collectivites_valeur : collectivitesHorsEffectifs = 14650 ∧
    cvaeRestante = [3607, 2450, 1156, 0] ∧ impotsProduction - cvaeRestante.headD 0 = 13393 := by decide

def mesures : List Mesure := [
  { id := "RN-01", titre := "TVA à 5,5 % sur les énergies"
    source := s!"{dossier} : −12,2 Md€/an (chiffrage du parti ; carburants inclus)"
    leviers := [.prelevementSur .tva (-12200)] },
  { id := "RN-02", titre := "Suppression de la CFE, de la CVAE et de la C3S"
    source := s!"{dossier} : −17 Md€/an d'impôts de production (presse) ; l'agrégat « ensemble des entreprises » du dossier est de −11,1 Md€ en 2031, suramortissement et surcroît d'IS compris ; la CVAE, déjà supprimée par la loi en 2030, est limitée à son rendement restant (voir `cvaeRestante`)"
    leviers := [.prelevementSur .autres (0 - (impotsProduction - cvaeRestante.headD 0)),
                .recetteEcheancier (some .autres) (cvaeRestante.map fun x => 0 - x)]
    variantes := [{ nom := "17 Md€ (avant correction de la CVAE)", leviers := [.prelevementSur .autres (-17000)] }] },
  { id := "RN-03", titre := "Fiscalité des grandes entreprises : rachats d'actions, IS sur le chiffre d'affaires, superdividendes"
    source := s!"{dossier} : +5,6 Md€ en 2031 (agrégat « grandes entreprises », dont IS sur le chiffre d'affaires 7,5), imputé à l'impôt sur les sociétés"
    leviers := [.prelevementSur .impotSocietes 5600] },
  { id := "RN-04", titre := "Autres baisses d'impôts des ménages : TVA à 0 % sur 100 produits, part fiscale, IR des moins de 30 ans, IFF"
    source := s!"{dossier} : agrégat « ménages, fiscalité » −22,1 Md€ en 2031, dont −12,2 de TVA énergies (RN-01) : reste −9,9 Md€, imputé aux « autres impôts »"
    leviers := [.prelevementSur .autres (-9900)] },
  { id := "RN-05", titre := "Retraite à 62 ans avec 42 annuités"
    source := s!"{dossier} : le parti chiffre 9 Md€/an ; le modèle applique son propre coût par mois d'âge légal (hypothèse économique du scénario) ; 62 ans dès l'entrée en vigueur, écart au calendrier légal de 9 mois en 2027 et 24 mois en 2033"
    leviers := [.ageLegalCible 744 0] },
  { id := "RN-06", titre := "Non-renouvellement de 201 000 postes publics"
    source := s!"{dossier} : ≈ 13,5 Md€/an en 2032 (presse), soit 67 164 € par poste (calcul) ; 40 200 postes non renouvelés par an de 2027 à 2031, emplois publics retirés un pour un (levier `suppressionPostes`)"
    leviers := [.suppressionPostes .fonctionnement 40200 67164]
    repetitions := 5 },
  { id := "RN-07", titre := "Effort des collectivités territoriales"
    source := s!"{dossier} : 8,2 Md€ en 2027, {collectivites2031} M€ en 2031 (Public Sénat, 6 et 14 octobre 2026), moins les effectifs ({effectifsCollectivites} M€), comptés dans RN-06 (voir `collectivitesHorsEffectifs`)"
    leviers := [.economieSur .fonctionnement collectivitesHorsEffectifs]
    variantes := [{ nom := "8,2 Md€ (montant de 2027)", leviers := [.economieSur .fonctionnement 8200] }] },
  { id := "RN-08", titre := "Priorité nationale : prestations de solidarité après cinq ans de résidence, prestations familiales"
    source := s!"{dossier} : 12,2 + 5,9 = 18,1 Md€ en 2031 (agrégat « immigration » : 29,0 avec l'AMU, la taxe sur les transferts et la taxe à l'embauche, non détaillées) ; suppose une révision constitutionnelle"
    leviers := [.economieSur .famille 18100] },
  { id := "RN-09", titre := "Baisse unilatérale de la contribution à l'Union européenne"
    source := s!"{dossier} : 13,1 Md€ en 2031"
    leviers := [.economieSur .fonctionnement 13100] },
  { id := "RN-10", titre := "TVA prélevée à la source et lutte contre les cartels de marchés publics"
    source := s!"{dossier} : 18,0 + 5,8 = 23,8 Md€ en 2031 ; traité comme une recette de TVA (le modèle lui applique sa fuite fiscale et son effet de demande)"
    leviers := [.prelevementSur .tva 23800] },
  { id := "RN-11", titre := "Suppression d'agences de l'État et parc immobilier"
    source := s!"{dossier} : 10,1 + 5,1 = 15,2 Md€ en 2031"
    leviers := [.economieSur .fonctionnement 15200] },
  { id := "RN-12", titre := "Sécurité sociale : réparation des retraites, dépenses indues, coûts hospitaliers"
    source := s!"{dossier} : 15,0 + 9,5 + 8,3 = 32,8 Md€ en 2031 (agrégat « Sécurité sociale » : 53,1 avec ALD et carte Vitale biométrique, non détaillées)"
    leviers := [.economieSur .sante 32800] },
  { id := "RN-13", titre := "Rebudgétisation des certificats d'économies d'énergie"
    source := s!"{dossier} : 8,0 Md€ en 2031 ; charge transférée des fournisseurs d'énergie au budget, comptée par le dossier comme recette : traitée comme prélèvement sur les « autres impôts »"
    leviers := [.prelevementSur .autres 8000] },
  { id := "RN-14", titre := "Dispositif « 100 % Rénov' »"
    source := s!"{dossier} : +3,8 Md€/an (presse)"
    leviers := [.depenseSur .logementEnvironnement 3800] },
  { id := "RN-15", titre := "Recherche publique"
    source := s!"{dossier} : +9 Md€/an (presse)"
    leviers := [.depenseSur .enseignement 9000] },
  { id := "RN-16", titre := "Fin des subventions aux énergies renouvelables"
    source := "Contre-budget 2027 (J.-P. Tanguy, cité par Planète Grandes Écoles, 7 octobre 2026) : +5 Md€ la première année (chiffrage du parti) ; recouvrement possible avec RN-13 (certificats d'économies d'énergie) ; installations : fin des volumes aidés de la PPE3, soit les appels d'offres de 2,9 GW/an de solaire et 2 × 800 MW/an d'éolien terrestre (Maire-info, TaiyangNews, février 2026) ; parcs en mer déjà attribués maintenus"
    leviers := [.economieSur .affairesEconomiques 5000,
                .capaciteElectrique .solaire (-2900), .capaciteElectrique .eolienTerrestre (-1600)] },
  { id := "RN-17", titre := "Taxe de 1 000 € par an et par salarié extra-européen"
    source := "Contre-budget 2027, p. 24 ; amendement au PLF 2027 rejeté en commission (Public Sénat, 9 octobre 2026) : 1,3 million de salariés × 1 000 € = 1,3 Md€ bruts (le parti compte 1,0 Md€ nets de 300 000 emplois perdus ; le modèle commun calcule les effets)"
    leviers := [.prelevementSur .autres 1300] },
  { id := "RN-18", titre := "Jeunesse : permis de conduire gratuit, prime d'activité étudiante"
    source := "LCP, 6 octobre 2026 : 0,7 Md€ (700 000 × 1 000 €, « estimation basse ») et 0,6 Md€ (chiffrage du parti)"
    leviers := [.depenseSur .enseignement 700, .depenseSur .famille 600] },
  { id := "RN-19", titre := "Proches aidants, soins dentaires"
    source := "Contre-budget 2027 (Contrepoints, 6 octobre 2026) : 2 Md€ (aidants) et 1,4 Md€ (dentaire), chiffrage du parti"
    leviers := [.depenseSur .famille 2000, .depenseSur .sante 1400] },
  { id := "RN-20", titre := "30 000 places de prison"
    source := "Comparateur IFRAP 2027 ; non chiffré : 30 000 × 236 k€ = 7,1 Md€ sur cinq ans (Institut Montaigne, 2022), puis ≈ 45 000 € par place ouverte et par an (surveillants, entretien : hypothèse du modèle commun, voir Texte Orientation D, O-75), places ouvertes de 2029 à 2033 ; emprise : 17 ha pour 700 places (centre de Saint-Saulve, ministère de la Justice, 23 juin 2023), soit 728 ha sur cinq ans"
    leviers := [.investissementEcheancier .securiteJustice [1420, 1420, 1420, 1420, 1420, 0],
                .artificialisation .autres (List.replicate 5 (30000 * 17 / 700 / 5)),
                .depenseEcheancier .securiteJustice [0, 0, 270, 540, 810, 1080, 1350]] },
  { id := "RN-21", titre := "7 000 policiers et gendarmes de plus"
    source := "Comparateur IFRAP 2027 ; ≈ 85 000 € par poste (Institut Montaigne, 2022, coût d'un recrutement dans la justice, hypothèse) : ≈ 0,6 Md€"
    leviers := [.creationPostes .securiteJustice [7000] 85000, .annonceEmplois 7000] },
  { id := "RN-22", titre := "Abrogation du zéro artificialisation nette (ZAN)"
    source := "Hors du contre-budget : amendement n° 1555 (J.-P. Meurin, cosigné par M. Le Pen, 4 avril 2025) : l'article 191 de la loi Climat et résilience « est abrogé » ; K. Mauvieux (28 mai 2025) : « Nous ne voulons plus du ZAN ». Consommation d'espaces ramenée au rythme 2011-2021 (modèle commun)"
    leviers := [.regimeZan 1000] },
  { id := "RN-23", titre := "Défense : au moins 3 % du PIB en 2030"
    source := "Amendement n° 565 au projet de loi d'actualisation de la LPM (n° 2695), déposé le 29 avril 2026 par des députés RN : « une trajectoire visant au minimum 3 % du produit intérieur brut à l'horizon 2030 », contre 2,5 % dans la loi n° 2026-791 que la référence suit. Non financé par le contre-budget. Conversion : 0,5 point du PIB de 2025 (2 992 Md€), soit 14 960 M€, atteint linéairement de 2027 à 2030 (hypothèse)"
    leviers := [.depenseEcheancier .defense [3740, 7480, 11220, 14960]] },
  { id := "RN-24", titre := "Énergie, réseaux et concessions : prix national de l'électricité, autoroutes, dividendes et tarifs de réseau"
    source := s!"{dossier} : agrégat de +29,0 Md€ en 2031, dont CEE 8,0 (RN-13). Prix de l'électricité (−30 % pour les entreprises) : 9,3 Md€ en 2031, « comptabilisé comme une baisse de dépenses […] sans mécanisme explicité » (IDEP) ; reste ≈ 11,7 Md€ de « prélèvements implicites sur l'énergie, les réseaux et les concessions », autoroutes nationalisées comprises (calcul), traité comme recette non fiscale. L'indemnisation des concessions (≈ 40 Md€, Institut Montaigne 2022) n'est pas comptée. Recoupement possible avec RN-16"
    leviers := [.economieSur .affairesEconomiques 9300, .recetteEcheancier none [11700]] },
  { id := "RN-25", titre := "Familles de travailleurs et troisième enfant"
    source := s!"{dossier} : agrégat « ménages, prestations » de −19,1 Md€ en 2031, moins la retraite à 62 ans (9,5, RN-05) et les aidants et le dentaire (3,4, RN-19) : 6,2 Md€ (calcul) ; mesures citées sans montant propre"
    leviers := [.depenseSur .famille 6200] },
  { id := "RN-26", titre := "Droits de douane et fiscalité du tabac"
    source := s!"{dossier} : agrégat « Union européenne » de 19,5 Md€ en 2031, moins la baisse de la contribution (13,1, RN-09) : 6,4 Md€ (calcul) ; imputé aux « autres impôts »"
    leviers := [.prelevementSur .autres 6400] },
  { id := "RN-27", titre := "Composante carbone de l'accise sur les carburants ramenée à son niveau de 2017"
    source := s!"{dossier} : coût de 3,9 Md€ par an de 2027 à 2031 selon la correction de l'IDEP (l'annexe du parti ne le compte qu'en 2027)"
    leviers := [.prelevementSur .accisesEnergie (-3900)] },
  { id := "RN-28", titre := "Pacte Dutreil renforcé et suramortissement"
    source := s!"{dossier} : allègements pour les entreprises de 21,0 Md€, moins CFE, CVAE et C3S (17,1, RN-02) : 3,9 Md€ (IDEP, calcul) ; partagés à parts égales entre droits de mutation et IS (hypothèse)"
    leviers := [.prelevementSur .droitsMutation (-1950), .prelevementSur .impotSocietes (-1950)] },
  { id := "RN-29", titre := "Fin des subventions aux associations « ne relevant pas de l'intérêt général »"
    source := "Contre-budget 2027 (Vert, 7 octobre 2026) : 3,7 Md€ à partir de 2028 (chiffrage du parti ; 3,2 Md€ dans la version de 2026)"
    leviers := [.depenseEcheancier .fonctionnement [0, -3700]] },
  { id := "RN-30", titre := "Taxe de 14 % sur les transferts d'argent vers les pays tiers"
    source := s!"{dossier} : ≈ 2 Md€ par an de 2027 à 2031 (La Grande Conversation, 13 octobre 2026 : assiette implicite de 13,7 Md€ « documentée nulle part ») ; comprise dans l'agrégat « immigration » (29,0 Md€ en 2031, dont 18,1 en RN-08)"
    leviers := [.prelevementSur .autres 2000] },
  { id := "RN-31", titre := "Aide médicale d'État remplacée par une aide médicale d'urgence"
    source := "Chiffrage du parti dans le contre-budget de 2026 : 1,3 Md€ (0,7 Md€ selon l'Institut Montaigne en 2024, pour une AME de 1,2 Md€) ; comprise sans montant dans l'agrégat « immigration » de 2027"
    leviers := [.economieSur .sante 1300] },
  { id := "RN-32", titre := "Privatisation de l'audiovisuel public"
    source := "Citée sans montant dans le contre-budget ; Institut Montaigne (2024) : ≈ 2 Md€ par an après trois à cinq ans, sur un périmètre de 3,64 Md€ (hors France Médias Monde), montée en charge sur quatre ans (hypothèse) ; la recette de cession (≈ 1,5 Md€, une fois) réduit la dette, non modélisée. Recoupement possible avec RN-06 et RN-11"
    leviers := [.depenseEcheancier .culture [-500, -1000, -1500, -2000]] },
  { id := "RN-33", titre := "Frais de scolarité des étudiants étrangers"
    source := "Contre-budget 2027 : 1,1 Md€ en 2031 (La Grande Conversation, 13 octobre 2026) ; recette des établissements, sans effet sur la demande intérieure"
    leviers := [.recetteEcheancier none [1100]] }
]

def programme : Programme where
  id := "RN"
  nom := "Rassemblement national — contre-budget 2027"
  description := "Transcription partielle et non officielle du dossier « Pour la Renaissance de la France » (6 octobre 2026) : baisses de TVA et d'impôts de production, retraite à 62 ans, économies sur l'État, les collectivités, l'Union européenne, les prestations et la Sécurité sociale. Le RN annonce 141,7 Md€ d'amélioration du solde en 2031. Ajouts : fin des subventions aux renouvelables, taxe sur les salariés extra-européens, jeunesse, aidants et dentaire, 30 000 places de prison, 7 000 policiers et gendarmes. Ajouts du 28 octobre 2026 : défense à 3 % du PIB en 2030, énergie et concessions, familles, douanes et tabac, composante carbone, Dutreil, associations, transferts d'argent, AME, audiovisuel public, frais de scolarité des étudiants étrangers."
  mainteneurs := ["@TOrientationD"]
  source := "Dossier de presse du 6 octobre 2026, via Institut de l'Entreprise (note IDEP) et presse (consultés le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.RN
