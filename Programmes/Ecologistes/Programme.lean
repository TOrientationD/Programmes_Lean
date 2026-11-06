import Modele
import Hypotheses
import Proprietes

/-!
# Les Écologistes — « Pour une prospérité écologique » (2027)

Transcription **partielle et non officielle** du programme des Écologistes
adopté le 13 juillet 2026 (lesecologistes.fr, « Projet 2027 », 557
mesures ; pages citées d'après MonVote2027 et Votons 2027, consultés le
22 octobre 2026). La source ne publie pas de chiffrage global.

Règle de transcription : une mesure devient un levier si la source donne
un montant annuel ou un paramètre que le modèle représente (SMIC, âge
légal) ; les conversions sont écrites dans `source`. Aucun engagement n'est
déclaré.
-/

namespace Programmes.Ecologistes
open Modele

def projet : String := "Les Écologistes, « Pour une prospérité écologique », 13 juillet 2026"

/-- Aide publique au développement à 0,7 % du PNB (programme, p. 205). En
2025 : 12,9 Md€, soit 0,42 % du RNB (75 Secondes, 30 août 2026, d'après
les données préliminaires de l'OCDE) ; écart de 0,28 point du RNB implicite
(calcul), atteint en cinq ans (hypothèse). -/
def hausseApd : Int := 12900 * 10000 / 42 * 28 / 10000
def apdEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * hausseApd / 5

theorem apd_valeurs : apdEcheancier = [1719, 3439, 5159, 6879, 8599] := by decide

/-- Plan d'adaptation (E-03) : « 7 milliards d'euros par an d'ici 2032 »
(programme) ; montée linéaire de 2027 à 2032 (hypothèse). -/
def adaptationCible : Int := 7000
def adaptationEcheancier : List Int :=
  ([1, 2, 3, 4, 5, 6] : List Int).map fun k => k * adaptationCible / 6

/-- Parc social d'un million de voitures électriques (E-21) : proposition
de loi n° 3375 (C. Arrighi, P. Amirshahi et 35 députés écologistes,
20 octobre 2026) : au moins un million de voitures achetées par la Caisse
des dépôts du 1er janvier 2028 au 31 décembre 2035, louées 150 € par mois
aux ménages des cinq premiers déciles, subvention annuelle d'équilibre de
l'État de 350 M€ (montant de référence) ; 125 000 voitures par an (calcul :
un million sur huit ans), soit 2 800 € de coût public par voiture
(calcul), retenus comme l'aide (même convention que PP-04 et O-128). L'encours
de la Caisse des dépôts (plafonné à 8,5 Md€) n'est pas compté : la Caisse
est classée hors des administrations publiques (hypothèse non vérifiée). -/
def voituresParcSocial : Int := 1000000
def anneesParcSocial : Int := 8
def subventionParcSocial : Int := 350
def voituresParcSocialParAn : Int := voituresParcSocial / anneesParcSocial
def aideParcSocialEuros : Int := subventionParcSocial * 1000000 / voituresParcSocialParAn

/-- Rénovation du bâti scolaire (E-22) : proposition de loi n° 3358
(A. Bonnet et groupe Écologiste et Social, 20 octobre 2026) : 5 200 M€ par
an de 2027 à 2036, « objectifs minimaux », en soutien des collectivités.
Variante : 4 Md€ par an sur dix ans, à parts égales entre l'État et les
collectivités (conférence de presse du 26 août 2026, L'Info Durable). -/
def batiScolaire (montant : Int) : List Int := List.replicate 10 montant ++ [0]

theorem ajouts_valeurs :
    adaptationEcheancier = [1166, 2333, 3500, 4666, 5833, 7000] ∧
    voituresParcSocialParAn = 125000 ∧ aideParcSocialEuros = 2800 := by decide

def mesures : List Mesure := [
  { id := "E-01", titre := "SMIC porté à 2 000 € brut dès 2027"
    source := s!"{projet}, p. 55 ; hausse calculée sur le SMIC projeté de 2027 (≈ 1 875 € bruts, indexé sur les prix depuis 1 801,80 € en 2025), soit ≈ +6,6 %"
    leviers := [.smicCibleBrut 2000] },
  { id := "E-02", titre := "Âge légal ramené de 64 à 62 ans, objectif 60 ans selon la pénibilité"
    source := s!"{projet}, p. 116 ; 62 ans dès l'entrée en vigueur, écart au calendrier légal de 9 mois en 2027 et 24 mois en 2033 (l'objectif de 60 ans n'est pas modélisé)"
    leviers := [.ageLegalCible 744 0] },
  { id := "E-03", titre := "Plan national d'adaptation au changement climatique"
    source := s!"{projet} : « 7 milliards d'euros par an d'ici 2032 », montée linéaire de 2027 à 2032 (hypothèse, voir `adaptationEcheancier`) ; le contre-budget du 30 septembre 2026 cite un plan climat « de l'ordre de dix milliards d'euros » sans ventilation (AFP), non ajouté pour ne pas doubler E-03, E-22 et E-23"
    leviers := [.depenseEcheancier .logementEnvironnement adaptationEcheancier]
    variantes := [{ nom := "7 Md€ dès 2027", leviers := [.depenseSur .logementEnvironnement 7000] }] },
  { id := "E-04", titre := "Loi intégrale contre les violences sexistes et sexuelles"
    source := s!"{projet} : « dotée de 3 milliards d'euros » (traités comme dépense annuelle nouvelle)"
    leviers := [.depenseSur .securiteJustice 3000] },
  { id := "E-05", titre := "Taxe Zucman : 2 % du patrimoine au-delà de 100 M€"
    source := s!"{projet}, p. 66 ; rendement non chiffré par la source : 15 Md€/an retenus (chiffrage du budget rectificatif LFI 2027 pour la même mesure, hypothèse)"
    leviers := [.prelevementSur .autres 15000] },
  { id := "E-06", titre := "Justice : 9 000 magistrats, 10 000 greffiers, 7 000 attachés de justice sur dix ans"
    source := s!"{projet} ; conversion : 26 000 postes × 60 000 € = 1,56 Md€/an en régime de croisière (hypothèse de coût unitaire), atteint en dix ans (2 600 postes par an), emplois publics comptés un pour un (levier `creationPostes`)"
    leviers := [.creationPostes .securiteJustice
                  (([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List Int).map fun k => 2600 * k) 60000,
                .annonceEmplois 26000] },
  { id := "E-07", titre := "Enseignants : +15 % de salaire en cinq ans ; recherche publique : +10 %"
    source := s!"{projet} ; conversion : masse salariale enseignante ≈ 60 Md€ × 15 % = 9 Md€, recherche publique ≈ 10 Md€ × 10 % = 1 Md€ (hypothèses)"
    leviers := [.depenseSur .enseignement 10000] },
  { id := "E-08", titre := "AAH augmentée de 250 € par mois"
    source := s!"{projet} ; conversion : 1,3 million d'allocataires × 250 € × 12 = 3,9 Md€/an (hypothèse)"
    leviers := [.depenseSur .famille 3900] },
  { id := "E-09", titre := "32 heures sans perte de salaire dans les métiers pénibles ou de nuit"
    source := s!"{projet}, p. 57 ; conversion : −8,6 % d'heures pour 15 % des salariés (métiers exposés, hypothèse) → −1,3 % d'heures par emploi"
    leviers := [.dureeTravail (-13)] },
  { id := "E-10", titre := "Contribution pour les générations futures : successions de plus de 4 M€, Dutreil réduit, plus-values latentes imposées au décès"
    source := "Les Écologistes, contre-budget 2027 (30 septembre 2026 ; Zoominvest, 27 août 2026) : +10 Md€ en 2027, 15 Md€ à terme (chiffrage du parti)"
    leviers := [.recetteEcheancier (some .droitsMutation) [10000, 11500, 13000, 15000]] },
  { id := "E-11", titre := "Taxe sur le surcroît de chiffre d'affaires des groupes pétro-gaziers, chèque carburant de 450 €"
    source := "E. Sas, 30 septembre 2026 (AFP) : +2,8 Md€ (33 % du chiffre d'affaires supplémentaire 2026-2027), chèque de 450 € pour ≈ 6 millions de ménages (≈ 2,7 Md€, calcul) ; temporaires, 2027 seulement"
    leviers := [.recetteEcheancier (some .impotSocietes) [2800, 0], .depenseEcheancier .famille [2700, 0]] },
  { id := "E-12", titre := "Classes à 19 élèves en 2032, 12 en éducation prioritaire"
    source := s!"{projet} ; non chiffré : 6,8 Md€ par an au bout de cinq ans pour les classes à 19 (Institut Montaigne, 2022, même mesure de LFI ; fourchette 4,6 à 11 Md€), hypothèse ; montée en charge linéaire"
    leviers := [.depenseEcheancier .enseignement [1360, 2720, 4080, 5440, 6800]] },
  { id := "E-13", titre := "Garantie d'autonomie à 50 % du SMIC net dès 18 ans"
    source := s!"{projet} ; non chiffré : RSA ouvert aux 18-25 ans ≈ 6,6 Md€ (DG Trésor, 2016), hypothèse basse (le montant visé, ≈ 739 €, dépasse le RSA)"
    leviers := [.depenseSur .famille 6600] },
  { id := "E-14", titre := "APL +10 %, allocations familiales dès le premier enfant"
    source := s!"{projet} ; APL : 16,1 Md€ en 2026 (Sénat) → +1,6 Md€ (calcul) ; allocations dès le premier enfant : 2,8 Md€ bruts (direction de la Sécurité sociale, rapport AN n° 1473)"
    leviers := [.depenseSur .famille 4400] },
  { id := "E-15", titre := "Taxe sur les services numériques de 3 % à 5 %"
    source := "Comparateur IFRAP 2027 ; ≈ 0,47 Md€ statiques sur une base de 0,7 Md€ (calcul)"
    leviers := [.prelevementSur .autres 470] },
  { id := "E-16", titre := "Impôt sur la fortune rétabli"
    source := s!"{projet}, p. 66 (via MonVote2027) : « rétablir l'Impôt sur la Fortune (ISF) » ; non chiffré : l'ISF rapportait 4,2 Md€ en 2017, l'IFI 2,3 Md€ en 2025 (La Relève et La Peste, 28 octobre 2026), soit +1,9 Md€ (calcul) ; recoupement possible avec la taxe Zucman (E-05)"
    leviers := [.prelevementSur .patrimoine 1900] },
  { id := "E-17", titre := "Fin des exonérations de cotisations patronales au-delà de 1,6 SMIC"
    source := s!"{projet}, p. 67 (via MonVote2027) ; non chiffré : allègements généraux de la tranche de 1,6 à 2,5 SMIC et au-delà supprimés, ≈ 10,1 Md€ en 2025 (répartition du modèle commun selon la RGDU 2026) ; effets sur l'emploi calculés par le modèle"
    leviers := [.allegementsCotisations .intermediaire (-8850), .allegementsCotisations .haut (-1200)] },
  { id := "E-18", titre := "Remboursement à 100 % par l'Assurance maladie, fin des franchises"
    source := s!"{projet}, p. 111 (via MonVote2027) ; non chiffré : 17,1 Md€ par an pour le « 100 % Sécu » (Institut Montaigne, 14 février 2022, fourchette 15 à 26), majorant si le périmètre se limite aux soins essentiels"
    leviers := [.depenseSur .sante 17100] },
  { id := "E-19", titre := "Aide publique au développement portée à 0,7 % du PNB"
    source := s!"{projet}, p. 205 ; non chiffré : de 0,42 % à 0,7 %, +{hausseApd} M€ par an atteints en cinq ans ; versements à l'étranger, sans effet sur la demande intérieure (recette non fiscale négative, comme O-114) (voir `hausseApd`)"
    leviers := [.recetteEcheancier none (apdEcheancier.map (fun x => -x))] },
  { id := "E-20", titre := "Congé climatique de cinq jours par an"
    source := s!"{projet} (via Votons 2027 et MonVote2027) ; conversion : 35 heures sur 1 607 heures annuelles, −2,2 % de durée du travail (calcul)"
    leviers := [.dureeTravail (-22)] },
  { id := "E-21", titre := "Parc social d'un million de voitures électriques louées 150 € par mois"
    source := s!"Proposition de loi n° 3375 du groupe écologiste (20 octobre 2026) : un million de voitures de 2028 à 2035, ménages des cinq premiers déciles, subvention d'équilibre de l'État de {subventionParcSocial} M€ par an ; {voituresParcSocialParAn} voitures par an à {aideParcSocialEuros} € de coût public chacune (calcul), aide réservée aux ménages modestes (voir `aideParcSocialEuros`)"
    leviers := [.aideAchatElectrique voituresParcSocialParAn aideParcSocialEuros .modestes]
    debut := 1 },
  { id := "E-22", titre := "Plan décennal de rénovation du bâti scolaire"
    source := "Proposition de loi n° 3358 du groupe Écologiste et Social (20 octobre 2026) : 5,2 Md€ par an de 2027 à 2036 en soutien des collectivités ; variante : 4 Md€ par an (conférence de presse du 26 août 2026) ; le Fonds vert (E-23) finance aussi des bâtiments publics"
    leviers := [.investissementEcheancier .enseignement (batiScolaire 5200)]
    variantes := [{ nom := "4 Md€ par an (26 août 2026)", leviers :=
      [.investissementEcheancier .enseignement (batiScolaire 4000)] }] },
  { id := "E-23", titre := "Fonds vert rétabli et MaPrimeRénov' relevée"
    source := "Conférence de presse des Écologistes, 26 août 2026 (L'Info Durable, La Gazette France) : « rétablissement du fonds vert (+1,9 md d'euros) », MaPrimeRénov' augmentée « à hauteur de 1,4 milliard d'euros » (chiffrage du parti) ; le Fonds vert est un investissement des collectivités aidé, MaPrimeRénov' une aide aux ménages (montant par rénovation non publié : les économies d'énergie et l'aubaine du levier `bonusRenovation` ne sont pas comptées)"
    leviers := [.investissement .logementEnvironnement 1900, .depenseSur .logementEnvironnement 1400] }
]

def programme : Programme where
  id := "Ecologistes"
  nom := "Les Écologistes — Prospérité écologique 2027"
  description := "Transcription partielle et non officielle du programme du 13 juillet 2026 : SMIC à 2 000 € brut, retraite à 62 ans, adaptation climatique (7 Md€/an en 2032), loi VSS, taxe Zucman, justice, salaires enseignants et chercheurs, AAH. Ajouts : contribution sur les grosses successions (contre-budget 2027), taxe pétro-gazière et chèque carburant, classes à 19 élèves, garantie d'autonomie et APL (hypothèses chiffrées), taxe numérique à 5 %. 500 000 rénovations par an, ISF climatique, TVA verte et sortie du nucléaire : sans montant publié. Ajouts du 28 octobre 2026 : ISF, fin des exonérations au-delà de 1,6 SMIC, 100 % Sécu, aide au développement à 0,7 %, congé climatique. Ajouts du 30 octobre 2026 : parc social d'un million de voitures électriques (proposition de loi), rénovation du bâti scolaire, Fonds vert et MaPrimeRénov' ; plan d'adaptation en montée jusqu'en 2032."
  mainteneurs := ["@TOrientationD"]
  source := "lesecologistes.fr, Projet 2027 « Pour une prospérité écologique » (via MonVote2027 et Votons 2027, consultés le 22 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.Ecologistes
