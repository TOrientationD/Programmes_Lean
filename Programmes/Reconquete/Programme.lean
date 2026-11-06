import Modele
import Hypotheses
import Proprietes

/-!
# Reconquête — Éric Zemmour 2027

Transcription **partielle et non officielle** des propositions chiffrées de
la campagne d'Éric Zemmour, candidat déclaré le 17 septembre 2026 (BFMTV).
Aucun programme 2027 n'est publié au 28 octobre 2026 : une consultation
(« Le Programme pour la France ») est en cours. Les montants viennent du
plan d'économies de Sarah Knafo, vice-présidente du parti (contre-budget
d'octobre 2025 : 80 Md€ d'économies et 20 Md€ de baisses d'impôts ; livre
« Le Casse du siècle », Fayard, 2 septembre 2026, ≈ 130 Md€) et des
déclarations de campagne de 2026. Les mesures du programme de 2022
(« Pour que la France reste la France ») ne sont reprises que lorsqu'elles
ont été réaffirmées en 2025 ou 2026.

Règle de transcription : seules les propositions avec un montant ou un
paramètre que le modèle représente deviennent des leviers ; le montant du
parti est retenu, sa source et ses limites sont dans le champ `source`.
Aucun engagement n'est déclaré.
-/

namespace Programmes.Reconquete
open Modele

def knafo : String :=
  "Plan d'économies de S. Knafo (contre-budget d'octobre 2025 ; « Le Casse du siècle », Fayard, 2 septembre 2026)"

/-- Non-remplacement de 800 000 départs dans l'administration en cinq ans,
enseignants, soignants, policiers et militaires exclus : 40 Md€ (Sud
Radio, 14 septembre 2026), soit 50 000 € par poste ; 160 000 départs non
remplacés par an (calcul). -/
def economiePostes : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => -(k * 40000 / 5)

/-- Aide publique au développement : 12,9 Md€ en 2025 (0,42 % du RNB ;
75 Secondes, 30 août 2026, d'après les données préliminaires de l'OCDE).
Le parti chiffre la suppression à 14 à 15 Md€ ; l'économie ne peut dépasser
l'aide versée (plafond retenu). -/
def apd2025 : Int := 12900

/-- Baisse d'un tiers de l'accise sur les produits pétroliers (É. Zemmour,
« La France en face », Europe 1 et CNews, 19 mai 2026) : un tiers de la
TICPE de la référence du modèle (30,5 Md€, calcul). -/
def baisseAccise : Int := 30500 / 3

/-- Remigration : « on peut imaginer 100 000 renvois par an » (Europe 1,
23 mars 2022), principe réaffirmé le 17 septembre 2026 (renvoi des
détenus étrangers, des étrangers condamnés, des clandestins et des
étrangers au chômage depuis plus d'un an, BFMTV). Coût d'un éloignement :
90,6 M€ pour 31 404 éloignements en 2019, ≈ 2 900 € (cité par l'Institut
Montaigne, 2022). -/
def renvoisParAn : Int := 100000
def coutEloignementEuros : Int := 2900
def coutRenvois : Int := renvoisParAn * coutEloignementEuros / 1000000

theorem valeurs :
    economiePostes = [-8000, -16000, -24000, -32000, -40000] ∧ baisseAccise = 10166 ∧
    coutRenvois = 290 := by decide

def mesures : List Mesure := [
  { id := "RQ-01", titre := "Non-remplacement de 800 000 départs dans l'administration en cinq ans"
    source := "S. Knafo, Sud Radio, 14 septembre 2026 : 40 Md€ ; enseignants, soignants, policiers et militaires exclus ; 160 000 départs non remplacés par an à 50 000 € (voir `economiePostes`), emplois publics retirés un pour un (levier `suppressionPostes`)"
    leviers := [.suppressionPostes .fonctionnement 160000 50000]
    repetitions := 5 },
  { id := "RQ-02", titre := "Prestations non contributives réservées aux Français (RSA, APL, allocations familiales, minimum vieillesse)"
    source := s!"{knafo} : 15 à 20 Md€ (bas de la fourchette retenu ; 20 Md€ en 2022 ; 6,7 Md€ selon l'Institut Montaigne en 2022) ; suppose une révision constitutionnelle"
    leviers := [.economieSur .famille 15000] },
  { id := "RQ-03", titre := "Suppression de l'aide publique au développement"
    source := s!"{knafo} : 14 à 15 Md€ ; plafonné à l'aide versée en 2025, {apd2025} M€ (voir `apd2025`) ; versements à l'étranger, leur suppression ne réduit pas la demande intérieure (recette non fiscale, comme O-114)"
    leviers := [.recetteEcheancier none [apd2025]] },
  { id := "RQ-04", titre := "Contribution de la France au budget européen ramenée à son niveau d'avant le Covid"
    source := s!"{knafo} : 14 Md€ (Votons 2027 : « diminuer de 20 % la contribution annuelle […] avec un plafond à 20 milliards d'euros par an »)"
    leviers := [.economieSur .fonctionnement 14000] },
  { id := "RQ-05", titre := "Fin du soutien aux énergies renouvelables intermittentes"
    source := s!"{knafo} : 8 Md€ ; installations : fin des volumes aidés de la PPE3, soit les appels d'offres de 2,9 GW/an de solaire et 2 × 800 MW/an d'éolien terrestre (Maire-info, TaiyangNews, février 2026 ; même traduction que RN-16 et LR-04)"
    leviers := [.economieSur .affairesEconomiques 8000,
                .capaciteElectrique .solaire (-2900), .capaciteElectrique .eolienTerrestre (-1600)] },
  { id := "RQ-06", titre := "Suppression de la politique de la ville"
    source := s!"{knafo} : ≈ 8 Md€ par an (chiffrage du parti, périmètre non détaillé)"
    leviers := [.economieSur .logementEnvironnement 8000] },
  { id := "RQ-07", titre := "Agences supprimées ou réduites : Anah, Ademe, France Travail (mise en relation), ARS, CESE"
    source := s!"{knafo} : Anah 6 Md€, Ademe 3,4 Md€, France Travail 4 Md€, ARS 1 Md€, CESE 66 M€ (chiffrages du parti)"
    leviers := [.economieSur .logementEnvironnement 9400, .economieSur .famille 4000,
                .economieSur .sante 1000, .economieSur .fonctionnement 66] },
  { id := "RQ-08", titre := "RSA limité à trois ans pour les personnes en capacité de travailler"
    source := s!"{knafo} : 4,8 Md€"
    leviers := [.economieSur .famille 4800] },
  { id := "RQ-09", titre := "Privatisation de l'audiovisuel public"
    source := s!"{knafo} : ≈ 4 Md€ (3 Md€ en 2022 ; 1,2 Md€ selon l'Institut Montaigne en 2022)"
    leviers := [.economieSur .culture 4000] },
  { id := "RQ-10", titre := "Remigration : 100 000 renvois par an"
    source := s!"É. Zemmour, Europe 1, 23 mars 2022, principe réaffirmé le 17 septembre 2026 (BFMTV) : solde migratoire réduit de {renvoisParAn} personnes par an (hypothèse : renvois en plus des départs de référence), {coutRenvois} M€ par an d'éloignements (voir `coutEloignementEuros`)"
    leviers := [.migration (-(renvoisParAn / 1000)), .depenseSur .securiteJustice coutRenvois] },
  { id := "RQ-11", titre := "Renvoi des étrangers au chômage depuis plus d'un an"
    source := "BFMTV, 17 septembre 2026 ; non chiffré : 109 000 chômeurs étrangers de plus d'un an (Insee, cité par l'Institut Montaigne) × 12 200 € d'allocations par an, moins ≈ 0,31 Md€ de renvois, soit ≈ 1,0 Md€ d'économie (calcul d'après le chiffrage de la mesure de 2022) ; les départs sont comptés dans RQ-10"
    leviers := [.economieSur .famille 1000] },
  { id := "RQ-12", titre := "Suppression des droits de succession"
    source := "S. Knafo (AFP, via La Gazette France, septembre 2026) : suppression financée par les économies ; droits de succession de 16,2 Md€ en 2025 (Legifiscal, 23 septembre 2026), donations maintenues"
    leviers := [.prelevementSur .droitsMutation (-16200)] },
  { id := "RQ-13", titre := "Accise sur les produits pétroliers baissée d'un tiers"
    source := s!"É. Zemmour, « La France en face », Europe 1 et CNews, 19 mai 2026 : « baisser d'un tiers l'accise », financée par une baisse des dépenses ; −{baisseAccise} M€ par an (voir `baisseAccise`)"
    leviers := [.prelevementSur .accisesEnergie (-baisseAccise)] },
  { id := "RQ-14", titre := "Fin des subventions aux associations « politisées »"
    source := s!"{knafo} : 1 à 2 Md€ (bas de la fourchette retenu)"
    leviers := [.economieSur .fonctionnement 1000] },
  { id := "RQ-15", titre := "Retraites : réforme de 2023 maintenue, « 64 voire 65 ans »"
    source := "É. Zemmour, BFMTV, 17 septembre 2026 (« 64 voire 65 ans ») ; contre l'abrogation de la réforme de 2023 (franceinfo, 30 septembre 2026), capitalisation progressive (via isoloir2027 et Selectra) ; 64 ans est le calendrier de la référence : sans levier ; variante : 65 ans, +3 mois par an (rythme de H-01) ; durée de cotisation et part de capitalisation non trouvées"
    leviers := []
    variantes := [{ nom := "65 ans, +3 mois par an", leviers := [.ageLegalCible 780 3] }] }
]

def programme : Programme where
  id := "Reconquete"
  nom := "Reconquête — Éric Zemmour 2027"
  description := "Transcription partielle et non officielle des propositions chiffrées de la campagne d'Éric Zemmour (programme 2027 non publié) : plan d'économies de Sarah Knafo (fonction publique, prestations réservées aux Français, aide au développement, contribution européenne, renouvelables, politique de la ville, agences, RSA, audiovisuel public), remigration, suppression des droits de succession, accise sur les carburants baissée d'un tiers. Ajout du 30 octobre 2026 : retraites (réforme de 2023 maintenue, 65 ans en variante). Objectif annoncé : au moins 100 Md€ de baisse des dépenses publiques par an."
  mainteneurs := ["@TOrientationD"]
  source := "Contre-budget de S. Knafo (octobre 2025), « Le Casse du siècle » (septembre 2026), Sud Radio (14 septembre 2026), BFMTV (17 septembre 2026), Europe 1 (19 mai 2026), consultés le 28 octobre 2026"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.Reconquete
