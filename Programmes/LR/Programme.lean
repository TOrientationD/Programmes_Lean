import Modele
import Hypotheses
import Proprietes

/-!
# Les Républicains — plan Retailleau du 12 octobre 2026

Transcription **partielle et non officielle** du plan de redressement des
finances publiques présenté par Bruno Retailleau le 12 octobre 2026
(Public Sénat, Europe 1, AFP, consultés le 21 octobre 2026) : 197 Md€
d'économies « jusqu'en 2032 », 51 à 56 Md€ d'allègements fiscaux,
excédent primaire en 2030, déficit sous 3 % du PIB en 2031 et 2,2 % en
fin de quinquennat.

Règle de transcription : les montants sont lus comme des économies
**annuelles en régime de croisière** (2032) et appliqués par le modèle dès
l'année 0, sans montée en charge. Les mesures dont le mécanisme n'est pas
détaillé (retraites) sont transcrites comme économie forfaitaire. Aucun
engagement n'est déclaré.
-/

namespace Programmes.LR
open Modele

def plan : String := "Plan Retailleau, 12 octobre 2026 (Public Sénat, Europe 1, AFP)"

/-- Huit EPR2 de plus commandés « dès les deux premières années du
mandat » si les six en cours avancent bien (republicains.fr, via Votons
2027). Même hypothèse de financement que PC-08 (PCF) : coût unitaire du
programme gouvernemental (72,8 Md€ en euros 2020 pour 6 EPR2, devis EDF du
18 décembre 2025), moitié prêtée par l'État, prêt versé de 2027 à 2050 :
72 800 / 6 × 8 / 2 / 24 (calcul). Les réacteurs entreraient en service
après l'horizon de la projection : pas d'effet sur la production. -/
def pretEPR : Int := 72800 * 8 / 6 / 2 / 24

theorem pretEPR_eq : pretEPR = 2022 := by decide

/-- Impôts de production (LR-12), livret « Travail gagnant » (via Votons
2027) : 14,3 Md€, dont C3S 5,3, CVAE 4,3, forfait social 2,8 et CFE
industrielle 1,9. La CVAE est déjà supprimée en 2030 par la loi
(n° 2025-127, art. 62) que la référence suit : la mesure n'en retire que le
rendement restant, 3 400, 2 310 puis 1 090 M€ (euros 2025) de 2027 à 2029
(`Hypotheses/Reference.lean`), ×1,0609 en euros 2027 (3 % de croissance
nominale par an du scénario central, convention d'O-59 ; calcul) ; le
forfait social est une contribution patronale (cotisations). -/
def c3sEtCfe : Int := 5300 + 1900
def forfaitSocial : Int := 2800
def cvaeRestante : List Int := ([3400, 2310, 1090, 0] : List Int).map fun x => x * 10609 / 10000

/-- Variante de LR-08 (LCI, 22 septembre 2026) : « 40 milliards d'euros
d'économies cumulées sur cinq ans », en montée linéaire (hypothèse) :
k × 40 000 / 15 M€ la k-ième année, somme ≈ 40 Md€ (calcul). -/
def retraitesCumulees : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => 0 - k * 40000 / 15

theorem lr_valeurs : cvaeRestante = [3607, 2450, 1156, 0] ∧
    retraitesCumulees = [-2666, -5333, -8000, -10666, -13333] := by decide

/-- Enseignants (LR-22) : +135 € net par mois en début de carrière, +300 €
en milieu de carrière, « près de 2 milliards d'euros » (B. Retailleau,
31 août 2026 ; Parlons Politique, 1er septembre ; BFMTV), lus comme un
montant brut (hypothèse). -/
def enseignants : Int := 2000

def mesures : List Mesure := [
  { id := "LR-01", titre := "Non-remplacement de 400 000 agents publics partant à la retraite"
    source := s!"{plan} : 25 Md€ (sur 5,9 millions d'agents), soit 62 500 € par poste (calcul) ; 80 000 départs non remplacés par an pendant le quinquennat, emplois publics retirés un pour un (levier `suppressionPostes`)"
    leviers := [.suppressionPostes .fonctionnement 80000 62500]
    repetitions := 5 },
  { id := "LR-02", titre := "Opérateurs de l'État : départs volontaires, suppressions"
    source := s!"{plan} : 5 + 7,5 = 12,5 Md€"
    leviers := [.economieSur .fonctionnement 12500] },
  { id := "LR-03", titre := "Budgets en base zéro, délégation au privé, formation professionnelle aux régions"
    source := s!"{plan} : 11,5 + 5 + 6 = 22,5 Md€"
    leviers := [.economieSur .fonctionnement 22500] },
  { id := "LR-04", titre := "Fin de soutiens : nouvelles installations photovoltaïques et éoliennes, aide au développement, culture et audiovisuel public, contrats aidés, SNU, MaPrimeRénov'"
    source := s!"{plan} : 23 Md€ (agrégat) ; installations : fin des volumes aidés de la PPE3, soit les appels d'offres de 2,9 GW/an de solaire et 2 × 800 MW/an d'éolien terrestre (Maire-info, TaiyangNews, février 2026) ; parcs en mer déjà attribués maintenus"
    leviers := [.economieSur .affairesEconomiques 23000,
                .capaciteElectrique .solaire (-2900), .capaciteElectrique .eolienTerrestre (-1600)] },
  { id := "LR-05", titre := "Immigration : prestations non contributives après cinq ans, asile hors des frontières"
    source := s!"{plan} : 10 Md€, dont 4,5 conditionnés à une révision constitutionnelle"
    leviers := [.economieSur .famille 10000] },
  { id := "LR-06", titre := "Lutte contre la fraude fiscale et sociale"
    source := s!"{plan} : 5 Md€ ; traité comme recette (le modèle lui applique sa fuite fiscale)"
    leviers := [.prelevement 5000] },
  { id := "LR-07", titre := "Subventions publiques aux associations"
    source := s!"{plan} : 3 Md€"
    leviers := [.economieSur .culture 3000] },
  { id := "LR-08", titre := "Retraites : décote entre 63 et 65 ans et autres mesures"
    source := s!"{plan} : « environ 42 Md€ d'amélioration, dont 12 Md€ pour la décote entre 63 et 65 ans » jusqu'en 2032 ; transcrit comme économie forfaitaire (l'âge légal du modèle reste inchangé). Paramètres (LCP, 23 septembre 2026, émission LCI du 22 septembre) : âge minimal de 63 ans, décote de 7 % par an avant 65 ans sans carrière complète de 43 ans, taux plein automatique à 65 ans ; le reste des 42 Md€ viendrait de la capitalisation, du placement des réserves, de la convergence Agirc-Arrco et des régimes spéciaux, qui ne sont pas tous des économies de pensions ; LCI : « 40 milliards d'euros d'économies cumulées sur cinq ans » (variantes)"
    leviers := [.economieSur .retraites 42000]
    variantes := [
      { nom := "décote seule (12 Md€) et âge minimal de 63 ans", leviers := [.ageLegalCible 756 0, .economieSur .retraites 12000] },
      { nom := "40 Md€ cumulés sur cinq ans (LCI, 22 septembre 2026)", leviers :=
          [.depenseEcheancier .retraites retraitesCumulees] }] },
  { id := "LR-09", titre := "Assurance chômage et prestations : plafond de 70 % du SMIC pour les aides non contributives"
    source := s!"{plan} : 30 Md€"
    leviers := [.economieSur .famille 30000] },
  { id := "LR-10", titre := "Jour de carence d'ordre public dans le privé"
    source := s!"{plan} : 4 Md€ d'arrêts maladie"
    leviers := [.economieSur .sante 4000] },
  { id := "LR-11", titre := "Effort des collectivités de plus de 10 M€ de budget"
    source := s!"{plan} : 10 Md€ sur 335 Md€ de dépenses, fonctionnement hors personnel et prestations"
    leviers := [.economieSur .fonctionnement 10000] },
  { id := "LR-12", titre := "Baisse des impôts de production"
    source := s!"{plan} : 30 Md€ d'allègements pour les entreprises, dont 15 Md€ d'impôts de production (comparateur IFRAP 2027 ; les 15 Md€ de cotisations patronales sont en LR-14) ; livret « Travail gagnant » : C3S et CFE industrielle {c3sEtCfe} M€, forfait social {forfaitSocial} M€ (cotisations), CVAE limitée à son rendement restant, la loi la supprimant déjà en 2030 (voir `cvaeRestante`)"
    leviers := [.prelevementSur .autres (0 - c3sEtCfe), .prelevementSur .cotisations (0 - forfaitSocial),
                .recetteEcheancier (some .autres) (cvaeRestante.map fun x => 0 - x)]
    variantes := [{ nom := "15 Md€ d'autres impôts (avant correction de la CVAE)", leviers := [.prelevementSur .autres (-15000)] }] },
  { id := "LR-13", titre := "Exonération de cotisations sur les heures supplémentaires et autres allègements des ménages"
    source := s!"{plan} : 21 Md€, imputés aux cotisations sociales"
    leviers := [.prelevementSur .cotisations (-21000)] },
  { id := "LR-14", titre := "Baisse de 15 Md€ des cotisations patronales"
    source := s!"{plan} ; comparateur IFRAP 2027 : la moitié des 30 Md€ d'allègements pour les entreprises ; sans ciblage précisé, allègements relevés au prorata des tranches (modèle commun)"
    leviers := [.reductionAllegements (-15000)] },
  { id := "LR-15", titre := "Revenu familial dès le premier enfant (240 € par mois, près de 1 000 € au troisième) à la place de 12 dispositifs ; congé de naissance de six mois à 70 %"
    source := "B. Retailleau, AFP 30 avril 2026 ; Public Sénat, 9 octobre 2026 : 40,3 Md€ bruts financés par 41 Md€ d'aides supprimées et 0,6 à 0,8 Md€ d'économies de gestion, soit ≈ 1,4 Md€ d'économie nette (calcul) ; congé de naissance +0,7 Md€ (chiffrage du parti)"
    leviers := [.economieSur .famille 1400, .depenseSur .famille 700] },
  { id := "LR-16", titre := "Réduction d'impôt sur les intérêts d'emprunt des familles"
    source := "Le Figaro (via SeLoger, 29 septembre 2026) : 220 000 familles par an ; non chiffré : 220 000 × ≈ 1 200 € ≈ 0,27 Md€ par génération de prêts (calcul, hypothèse), cumulés sur la durée des prêts"
    leviers := [.prelevementSur .ir (-270)]
    repetitions := 9 },
  { id := "LR-17", titre := "Fin des 35 heures : durée annuelle de référence portée de 1 607 à 1 623 heures"
    source := "B. Retailleau, Public Sénat, 7 janvier 2026 : +16 heures par an, +1,0 % de durée du travail (calcul)"
    leviers := [.dureeTravail 10] },
  { id := "LR-18", titre := "Suppression du zéro artificialisation nette (ZAN)"
    source := "Hors du plan du 12 octobre 2026 : proposition de loi n° 3332 (E. Rey-Rinchet, apparentée Droite républicaine, 13 octobre 2026) « visant à supprimer le dispositif du ZAN » ; amendements n° 1063 et 2639 (Boucard, Wauquiez, 2025) : « Le ZAN doit être supprimé ». Consommation d'espaces ramenée au rythme 2011-2021 (modèle commun)"
    leviers := [.regimeZan 1000]
    variantes := [
      { nom := "assouplissement de la proposition de loi TRACE (Sénat, 18 mars 2025), non chiffré : ZAN maintenu", leviers := [] }] },
  { id := "LR-19", titre := "Suppression des doublons entre l'État et les collectivités"
    source := "Plan Retailleau, 12 octobre 2026 (Acteurs publics) : 4 Md€ (chiffrage du parti), en plus de l'effort des collectivités (LR-11)"
    leviers := [.economieSur .fonctionnement 4000] },
  { id := "LR-20", titre := "Fonds France Production pour la modernisation industrielle"
    source := "Livret « Travail gagnant » (LR, décembre 2025, présenté le 7 janvier 2026) : 600 M€ par an, « intégralement financé » ; sur-amortissement industriel non chiffré ; la « hausse mécanique de l'IS » de 4 Md€ attendue par le livret n'est pas reprise (le modèle calcule ses propres effets)"
    leviers := [.depenseSur .affairesEconomiques 600] },
  { id := "LR-21", titre := "Nucléaire : huit EPR2 supplémentaires commandés en début de mandat"
    source := s!"republicains.fr (via Votons 2027) : commande « dès les deux premières années du mandat » si les six EPR2 en cours avancent bien, exploitation des réacteurs existants sur 80 ans ; prêt de l'État à EDF de {pretEPR} M€ par an (hypothèse de PC-08, voir `pretEPR`) ; 13 GW pour huit réacteurs (AFP, 18 juin 2025), en service après 2035"
    leviers := [.pretEtat pretEPR] },
  { id := "LR-22", titre := "Enseignants : +135 € net par mois en début de carrière, +300 € en milieu de carrière"
    source := s!"B. Retailleau, 31 août 2026, Boulogne-Billancourt (Parlons Politique, 1er septembre ; Sud Radio, 3 septembre) : « près de 2 milliards d'euros », financés selon lui par la baisse du nombre d'élèves (non modélisé) ; {enseignants} M€ par an de traitement (montant brut : hypothèse)"
    leviers := [.remunerationPublique .traitement .enseignement [enseignants]] }
]

def programme : Programme where
  id := "LR"
  nom := "Les Républicains — plan Retailleau 2027"
  description := "Transcription partielle et non officielle du plan du 12 octobre 2026 : 197 Md€ d'économies (État, protection sociale, collectivités) et 51 Md€ d'allègements fiscaux, déficit sous 3 % en 2031 ; revenu familial, intérêts d'emprunt des familles, fin des 35 heures ; les 30 Md€ pour les entreprises répartis entre impôts de production et cotisations patronales. Ajouts du 28 octobre 2026 : doublons État-collectivités, fonds France Production, huit EPR2 de plus. Ajouts du 30 octobre 2026 : enseignants ; CVAE limitée à son rendement restant (déjà supprimée par la loi en 2030)."
  mainteneurs := ["@TOrientationD"]
  source := "Présentation du 12 octobre 2026 (Public Sénat, Europe 1, AFP, consultés le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.LR
