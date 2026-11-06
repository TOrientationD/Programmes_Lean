import Modele
import Hypotheses
import Proprietes

/-!
# Révolution permanente — Anasse Kazib 2027

Transcription **partielle et non officielle** des premières mesures de la
candidature d'Anasse Kazib (Révolution permanente), déclarée le 1er juin
2026 : page « Notre programme — Présidentielle 2027 » (anasse2027.fr,
consultée le 28 octobre 2026, « en cours de rédaction ») et articles de
revolutionpermanente.fr (1er juin, 16 septembre et 14 octobre 2026). Le
programme ne publie aucun chiffrage ; son financement (« par les
patrons », expropriations sans indemnité) n'a pas de montant.

Règle de transcription : seules les propositions avec un montant ou un
paramètre que le modèle représente deviennent des leviers ; à défaut de
chiffrage du parti, les montants sont calculés sur des données
officielles ou des chiffrages indépendants de mesures comparables
(calculs ci-dessous, marqués « hypothèse » ou « calcul »). Aucun
engagement n'est déclaré.
-/

namespace Programmes.RevolutionPermanente
open Modele

def programme2027 : String :=
  "anasse2027.fr, « Notre programme — Présidentielle 2027 » (consulté le 28 octobre 2026)"

/-- SMIC à 2 000 € net : 2 526 € bruts au ratio net/brut du SMIC
(1 443,11 / 1 823,03 au 1er janvier 2026) ; la hausse se calcule sur le SMIC
projeté de 2027 (≈ 1 876 € bruts), soit ≈ +34,6 % (calcul) ; les agents publics
sont déjà augmentés de 500 € nets par RP-02 : composante publique du levier
non comptée. -/
def smicCibleBrutEuros : Int := 2000 * 10000 / 7916

theorem smicCible_valeur : smicCibleBrutEuros = 2526 := by decide

/-- +500 € net pour tous les salariés : seule la part des agents publics a
un coût budgétaire direct. 500 € net valent 631 € brut au même ratio
net/brut (calcul), pour 5,6 millions d'agents (Institut Montaigne, 2022),
douze mois par an. La hausse dans le secteur privé n'a pas de levier dans
le modèle. -/
def hausseBruteMensuelleEuros : Int := 500 * 180180 / 142630
def agentsPublics : Int := 5600000
def coutHausseAgents : Int := hausseBruteMensuelleEuros * 12 * agentsPublics / 1000000

/-- Semaine de 28 heures sans baisse de salaire : 28 / 35 = −20 % d'heures
(−200 ‰). Coût des embauches publiques nécessaires : l'Institut Montaigne
chiffrait les 32 heures (−8,6 % d'heures) à 6,2 Md€ par an pour les
administrations (14 février 2022, enseignants et militaires exclus),
extrapolé linéairement à −20 % (calcul, hypothèse). -/
def coutEmbauches28h : Int := 6200 * 200 / 86

/-- Revenu étudiant au niveau du SMIC (2 000 € net par mois) : 3 049 600
étudiants inscrits en 2025-2026 (SIES, note flash n° 2026-17, juillet
2026), douze mois (calcul ; les bourses existantes, qu'il remplacerait en
partie, ne sont pas déduites). -/
def etudiants : Int := 3049600
def coutRevenuEtudiant : Int := etudiants * 2000 * 12 / 1000000

/-- Suppression de la présidence de la République et du Sénat : dotations
de l'État pour 2026, 122,56 M€ et 353,47 M€ (Sénat, rapport sur la
mission « Pouvoirs publics », PLF 2026). -/
def dotationsSupprimees : Int := (122564 + 353471) / 1000

theorem valeurs :
    hausseBruteMensuelleEuros = 631 ∧ coutHausseAgents = 42403 ∧
    coutEmbauches28h = 14418 ∧ coutRevenuEtudiant = 73190 ∧ dotationsSupprimees = 476 := by decide

def mesures : List Mesure := [
  { id := "RP-01", titre := "SMIC à 2 000 € net"
    source := s!"{programme2027} : « SMIC à 2000 € net », allocations revalorisées et indexées ; {smicCibleBrutEuros} € bruts (voir `smicCibleBrutEuros`)"
    leviers := [.smicCibleBrut smicCibleBrutEuros false] },
  { id := "RP-02", titre := "+500 € net sur tous les salaires, indexés sur les prix : part des agents publics"
    source := s!"{programme2027} : « augmentation des salaires de 500 € » ; agents publics : {coutHausseAgents} M€ bruts par an (voir `hausseBruteMensuelleEuros`) ; hausse dans le privé non modélisée"
    leviers := [.remunerationPublique .traitement .fonctionnement [coutHausseAgents]] },
  { id := "RP-03", titre := "Retraite à 60 ans, 55 ans pour les métiers pénibles, sans condition d'annuités"
    source := s!"{programme2027} ; RP, 1er juin 2026 ; âge légal fixé à 60 ans dès l'entrée en vigueur, le coût suit l'hypothèse économique du scénario ; 55 ans pour les métiers pénibles et suppression de la condition de durée non modélisés (coût sous-estimé)"
    leviers := [.ageLegalCible 720 0] },
  { id := "RP-04", titre := "Aucune pension sous le SMIC"
    source := "Votons 2027 (pensions et minimum vieillesse au SMIC) ; non chiffré : minimum contributif porté au SMIC, 13,9 Md€ par an (Institut Montaigne, programme du Nouveau Front populaire, 2024, pour un SMIC à 1 600 € net), plancher pour un SMIC à 2 000 €"
    leviers := [.depenseSur .retraites 13900] },
  { id := "RP-05", titre := "Semaine de 28 heures par partage du travail, sans baisse de salaire"
    source := s!"RP, 16 septembre 2026 ; {programme2027} : « 28h » ; −20 % de durée du travail ; embauches publiques : {coutEmbauches28h} M€ par an (extrapolation du chiffrage des 32 heures, voir `coutEmbauches28h`)"
    leviers := [.dureeTravail (-200), .depenseSur .fonctionnement coutEmbauches28h] },
  { id := "RP-06", titre := "Sécurité sociale couvrant l'ensemble des soins, financée par les employeurs"
    source := "RP, 16 septembre 2026 ; non chiffré : « 100 % Sécu », 17,1 Md€ par an (Institut Montaigne, 14 février 2022, fourchette 15 à 26) ; financement patronal sans taux, non modélisé"
    leviers := [.depenseSur .sante 17100] },
  { id := "RP-07", titre := "Revenu étudiant au niveau du SMIC, financé par les employeurs"
    source := s!"{programme2027} ; non chiffré : {etudiants} étudiants × 2 000 € × 12 = {coutRevenuEtudiant} M€ par an (SIES ; voir `etudiants`) ; financement patronal sans taux, non modélisé"
    leviers := [.depenseSur .enseignement coutRevenuEtudiant] },
  { id := "RP-08", titre := "Suppression de la présidence de la République et du Sénat"
    source := s!"Poligraph (20 août 2026) ; RP, 1er juin 2026 : assemblée unique élue pour deux ans, élus payés au salaire médian ; dotations supprimées : {dotationsSupprimees} M€ par an (voir `dotationsSupprimees`) ; Conseil constitutionnel et rémunération des élus non chiffrés"
    leviers := [.economieSur .fonctionnement dotationsSupprimees,
                .revisionConstitution "titres II, IV et XVI" "suppression de la présidence de la République et du Sénat, assemblée unique"] }
]

def programme : Programme where
  id := "RevolutionPermanente"
  nom := "Révolution permanente — Anasse Kazib 2027"
  description := "Transcription partielle et non officielle des premières mesures de la candidature d'Anasse Kazib (anasse2027.fr, programme en cours de rédaction) : SMIC à 2 000 € net, +500 € sur les salaires, retraite à 60 ans, pensions au SMIC, semaine de 28 heures, Sécurité sociale intégrale, revenu étudiant au SMIC, suppression de la présidence et du Sénat. Aucun chiffrage publié ; expropriations sans indemnité et financement patronal sans montant."
  mainteneurs := ["@TOrientationD"]
  source := "anasse2027.fr/programme et revolutionpermanente.fr (1er juin, 16 septembre et 14 octobre 2026), consultés le 28 octobre 2026"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.RevolutionPermanente
