import Modele
import Hypotheses
import Proprietes

/-!
# La France insoumise — Mélenchon 2027 (extraits)

Transcription **partielle et non officielle** de melenchon2027.fr
(consulté le 21 octobre 2026) et du « budget rectificatif » 2027 présenté
par J.-L. Mélenchon et É. Coquerel le 14 octobre 2026 (Public Sénat,
France Épargne) : le plan d'investissement productif « Automobile »
(L-01 à L-09), deux mesures phares de *L'Avenir en commun* 2025 (L-10
retraite à 60 ans, L-11 SMIC à 1 700 € net, chiffre du budget rectificatif) et les recettes et dépenses
chiffrées du budget rectificatif (L-12 à L-32 : 106,4 Md€ de recettes et 81,7 Md€
de dépenses, théorème `budget_totaux` ; brochure « Comment nous allons
remettre de l'ordre dans les comptes publics », octobre 2026). Les mesures
automobiles reprennent chacune une ligne du tableau « Les investissements
supplémentaires », en millions d'euros par an.

Le budget rectificatif 2027 retient le retour à 62 ans (9 Md€) ; le
programme vise 60 ans : c'est l'objectif du programme qui est modélisé
(L-10), sa première étape étant comprise dedans.

Seule la colonne **État** est imputée aux dépenses publiques. La colonne
« pôle public bancaire et autres » relève d'acteurs hors administrations
publiques dans le modèle (prêts, prises de participation) ; elle est citée
dans le champ `source` de chaque mesure.

Ajouts du 28 octobre 2026 (L-34 à L-50) : plans « BTP et logement »
(24 septembre 2026) et ESR (26 octobre 2026), mesures de *L'Avenir en
commun* 2025 avec le chiffrage du parti de 2022 ou, à défaut, un chiffrage
indépendant ou un calcul sur données officielles (constantes ci-dessous).

Les mesures sans montant dans la source (sanctions des flottes
d'entreprises, critères de production française, moratoire sur les
fermetures, prix national de l'électricité…) ne sont pas traduites en
leviers : voir README.md. Aucun engagement n'est déclaré, la source n'en
formulant pas dans les termes des propriétés du dépôt.

Secteur bénéficiaire des emplois (levier `depenseSecteur`, nomenclature
agrégée de l'INSEE) : industrie pour les lignes de production, les aides à
l'achat conditionnées à la production locale, la sous-traitance, les
batteries et le recyclage (la gestion des déchets relève de l'industrie
dans cette nomenclature, la réparation automobile du tertiaire : la ligne
L-06 est classée en industrie, part majoritaire supposée) ; tertiaire
marchand pour la location (activité de location, NAF 77) et la recherche
et développement (NAF 72). Ce classement est une interprétation, ouverte
à la discussion par issue.
-/

namespace Programmes.LFI
open Modele

/-- Référence commune des mesures. -/
def budget : String :=
  "Budget rectificatif 2027 de LFI, « Comment nous allons remettre de l'ordre dans les comptes publics » (melenchon2027.fr, octobre 2026 ; présenté le 14 octobre 2026)"

/-- Chiffrage du budget rectificatif, M€ par an (brochure, p. 8 à 14) :
recettes (p. 13-14) et dépenses (p. 8-12), avec la ligne du programme qui
les porte. Le retour à 62 ans (9 Md€) est la première étape de L-10 ;
violences sexistes et sexuelles : 2,6 Md€ de plus « pour atteindre
3 milliards » (p. 10). -/
def recettesBudget : List (String × Int) :=
  [("L-13", 9000), ("L-12", 10000), ("L-16", 22000), ("L-30", 3000), ("L-14", 15000),
   ("L-15", 20000), ("L-30", 3000), ("L-30", 5000), ("L-31", 3900), ("L-30", 5000),
   ("L-17", 5000), ("L-17", 2500), ("L-32", 1000), ("L-32", 2000)]
def depensesBudget : List (String × Int) :=
  [("L-18", 17000), ("L-21", 8000), ("L-26", 3000), ("L-19", 9500), ("L-25", 500),
   ("L-22", 3600), ("L-27", 3500), ("L-23", 3000), ("L-28", 2600), ("L-28", 2000),
   ("L-29", 7000), ("L-20", 10000), ("L-10", 9000), ("L-24", 3000)]

/-- Les totaux de la brochure : 106,4 Md€ de recettes, 81,7 Md€ de
dépenses, 24,7 Md€ de déficit en moins (p. 14). -/
theorem budget_totaux :
    (recettesBudget.map (·.2)).sum = 106400 ∧ (depensesBudget.map (·.2)).sum = 81700 ∧
    (recettesBudget.map (·.2)).sum - (depensesBudget.map (·.2)).sum = 24700 := by
  decide

def page : String :=
  "melenchon2027.fr/programme/plans-investissement/automobile, tableau « Les investissements supplémentaires »"

/-! ## Ajouts du 28 octobre 2026 : plans thématiques, *L'Avenir en commun* 2025, chiffrages de 2022

Le programme complet (5e édition de *L'Avenir en commun*) paraît le
6 novembre 2026 ; à défaut, les montants viennent des plans publiés sur
melenchon2027.fr (colonne État), de chiffrages du parti en 2022 pour les
mesures reprises dans l'édition 2025, ou de chiffrages indépendants et de
données officielles (calculs ci-dessous). -/

/-- Plan « BTP et logement » (melenchon2027.fr/programme/plans-investissement/btp-logement,
24 septembre 2026, modifié le 10 octobre 2026), colonne État, M€ par an :
construction de 200 000 logements publics par an, 3 100 ; isolation de
700 000 logements par an, 5 300 ; rénovation de logements sociaux, 250 ;
confort d'été, 500 ; bâtiments publics, associatifs et tertiaires, 1 000 ;
sortie du fioul et baisse du gaz, 1 000 ; formation, 60 ; déchets et
réemploi, 200 ; patrimoine, 600. Total : les « 12 milliards » de l'État du
plan (calcul). La colonne du pôle public bancaire (≈ 16 Md€ pour la
construction, ≈ 19 Md€ pour la rénovation) n'est pas imputée. -/
def planConstruction : Int := 3100
def planRenovation : Int := 5300 + 250 + 500 + 1000 + 1000 + 60 + 200
def planPatrimoine : Int := 600

theorem plan_btp_logement : planRenovation = 8310 ∧
    planConstruction + planRenovation + planPatrimoine = 12010 := by decide

/-- Grand âge : « au moins 210 000 personnes » formées et recrutées (AEC
2025). Coût par ETP du chiffrage de l'Institut Montaigne pour la mesure
comparable de Y. Jadot (2022) : 7,7 Md€ pour 203 000 ETP en Ehpad, soit
37 931 € (calcul) ; montée en charge en cinq ans (hypothèse). -/
def coutEtpGrandAgeEuros : Int := 7700000000 / 203000
def coutGrandAge : Int := 210000 * coutEtpGrandAgeEuros / 1000000
def grandAgeEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * coutGrandAge / 5

theorem grand_age_valeurs : coutEtpGrandAgeEuros = 37931 ∧ coutGrandAge = 7965 ∧
    grandAgeEcheancier = [1593, 3186, 4779, 6372, 7965] := by decide

/-- 10 000 places par an en Ehpad publics pendant cinq ans (AEC 2025).
Mêmes coûts que la mesure O-109 du Texte Orientation D : construction
≈ 85 000 € HT par place en 2012 (Anap et CNSA), actualisés par l'indice du
coût de la construction (1 617 au 1er trimestre 2012, 2 058 au 4e trimestre
2025, Insee) ; fonctionnement à la charge des administrations : soins
(12 755 € par place et par an) et APA en établissement (338 € par mois),
valeurs 2019 (rapport Libault, DREES) ; l'hébergement reste payé par les
résidents. -/
def placesEhpadParAn : Int := 10000
def coutPlaceEhpadEuros : Int := 85000 * 2058 / 1617
def fonctionnementPlaceEhpadEuros : Int := 12755 + 338 * 12
def investissementEhpad : Int := placesEhpadParAn * coutPlaceEhpadEuros / 1000000
def fonctionnementEhpad : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * placesEhpadParAn * fonctionnementPlaceEhpadEuros / 1000000

theorem ehpad_valeurs : coutPlaceEhpadEuros = 108181 ∧ investissementEhpad = 1081 ∧
    fonctionnementEhpad = [168, 336, 504, 672, 840] := by decide

/-- SMIC net visé (L-11) : 1 700 € dans le budget rectificatif du
14 octobre 2026 (AFP, LCP), 1 600 € dans *L'Avenir en commun* 2025
(variante). Conversion au brut au ratio net/brut du SMIC au 1er janvier
2026 (1 443,11 / 1 823,03, cotisations salariales de 20,84 %), calcul. -/
def smicNetCible : Int := 1700
def smicNetAec : Int := 1600
def smicBrut (net : Int) : Int := net * 182303 / 144311

/-- Agents publics au SMIC (L-11) : `smicCibleBrut … false` ne compte pas la
composante publique, que L-18 (17 Md€ de rémunérations publiques) ne
couvre qu'en partie : 17 Md€ ≈ 6,7 % des traitements, d'après la
conversion de PC-19 (10 % de point d'indice ≈ 25,3 Md€ ; calcul). Les
points de hausse du SMIC au-delà (hausse sur le SMIC projeté de 2027,
≈ 1 875 € bruts) sont ajoutés en rémunération publique, au coût du modèle
commun par point (`Hypotheses.Eco.smicParPoint`, 316 M€). -/
def smicProjete2027 : Int := 1875
def hausseSmicPb (net : Int) : Int := smicBrut net * 10000 / smicProjete2027 - 10000
def couvertureL18Pb : Int := 17000 * 1000 / 25300
def agentsPublicsNonCouverts (net : Int) : Int :=
  max 0 (hausseSmicPb net - couvertureL18Pb) * Hypotheses.Eco.smicParPoint.remunerationPubliqueMeur / 100

/-- AAH au niveau du SMIC (AEC 2025) : 12,7 Md€ versés en 2023 à
1 352 800 allocataires, montant maximal de 1 033,32 € au 1er avril 2025
(DREES, minima sociaux, édition 2025) ; porté au SMIC net de L-11, dépense
relevée en proportion (calcul ; les nouveaux entrants dus au relèvement du
plafond ne sont pas comptés). -/
def hausseAAH : Int := 12700 * (smicNetCible * 100 - 103332) / 103332

/-- Minimum vieillesse au seuil de pauvreté (AEC 2025) : ASPA de 1 034,28 €,
4,1 Md€ versés en 2023 à 723 000 allocataires (DREES) ; seuil de pauvreté
2024 : 1 337 € (Insee, juillet 2026) ; dépense relevée en proportion
(calcul). -/
def hausseASPA : Int := 4100 * (133700 - 103428) / 103428

theorem minima_valeurs : smicBrut smicNetCible = 2147 ∧ smicBrut smicNetAec = 2021 ∧
    hausseSmicPb smicNetCible = 1450 ∧ couvertureL18Pb = 671 ∧
    agentsPublicsNonCouverts smicNetCible = 2461 ∧ agentsPublicsNonCouverts smicNetAec = 338 ∧
    hausseAAH = 8193 ∧ hausseASPA = 1200 := by decide

/-- Coût moyen d'un enseignant, hors pensions : 59,23 Md€ de masse salariale
hors CAS Pensions pour 852 752 enseignants en 2026 (PLF 2026, rapport du
Sénat sur la mission Enseignement scolaire), soit 69 457 € (calcul),
appliqué aux personnels de l'enseignement supérieur (hypothèse). Plan ESR
(melenchon2027.fr, 26 octobre 2026) : 40 000 personnels statutaires « à
minima » sur cinq ans. -/
def coutEnseignantEuros : Int := 59230000000 / 852752
def postesEsrEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * 8000 * coutEnseignantEuros / 1000000

theorem esr_valeurs : coutEnseignantEuros = 69457 ∧
    postesEsrEcheancier = [555, 1111, 1666, 2222, 2778] := by decide

/-- Contrats doctoraux (plan ESR, PDF sur melenchon2027.fr, octobre 2026) :
« 8 000 contrats doctoraux supplémentaires par an », contrats de trois ans ;
coût employeur de 132 012 € pour 36 mois (appel 2026 de la Fondation pour la
recherche médicale, au salaire minimum de 2 300 € bruts du 1er janvier
2026, MESR), soit 44 004 € par an (calcul). -/
def coutDoctorantEuros : Int := 132012 / 3
def doctorantsEcheancier : List Int := [8000, 16000, 24000]
def coutDoctorants : List Int :=
  ([1, 2, 3, 3, 3, 3] : List Int).map fun k => k * 8000 * coutDoctorantEuros / 1000000

/-- Recherche publique (plan ESR) : R&D « à au moins 3 % du PIB, dont
1,5 % pour le secteur public en 2032 ». Dépense intérieure de R&D des
administrations : 0,75 % du PIB en 2024 ; DIRD de 64,1 Md€, 2,18 % du PIB
(SIES, note flash n° 16, juillet 2026), d'où un PIB 2024 de ≈ 2 940 Md€
(calcul). Écart de 0,75 point (euros de 2024, montant minoré), atteint en
six paliers égaux de 2027 à 2032 (hypothèse), net des postes de L-44 et des
contrats doctoraux de L-52, qui en font partie (calcul). -/
def pib2024 : Int := 64100 * 10000 / 218
def ecartRecherchePublique : Int := pib2024 * 75 / 10000
def rechercheBrute : List Int :=
  ([1, 2, 3, 4, 5, 6] : List Int).map fun k => k * ecartRecherchePublique / 6
def rechercheNette : List Int :=
  ((rechercheBrute.zip (postesEsrEcheancier ++ [postesEsrEcheancier.getLastD 0])).zip coutDoctorants).map
    fun ((r, p), d) => r - p - d

/-- Logements étudiants (plan ESR) : « à hauteur de 30 000 par an » ; 60 000 €
par logement, chiffre de la présidente du Cnous repris par LFI (amendement
II-CF1739 au PLF 2026, 3 novembre 2025), soit 1,8 Md€ par an (calcul). -/
def logementsEtudiantsParAn : Int := 30000
def coutLogementEtudiantEuros : Int := 60000
def logementsEtudiants : Int := logementsEtudiantsParAn * coutLogementEtudiantEuros / 1000000

theorem esr_ajouts_valeurs : coutDoctorantEuros = 44004 ∧
    coutDoctorants = [352, 704, 1056, 1056, 1056, 1056] ∧
    pib2024 = 2940366 ∧ ecartRecherchePublique = 22052 ∧
    rechercheNette = [2768, 5535, 8304, 11423, 14542, 18218] ∧
    logementsEtudiants = 1800 := by decide

/-- Cotisation vieillesse relevée de 0,25 point par an pendant le
quinquennat (AEC 2025, d'après Votons 2027) : 0,25 % des 1 157,2 Md€ de
salaires bruts de 2025 (Insee, compte des ménages), soit 2 893 M€ par
hausse (calcul ; assiette : hypothèse). -/
def quartDePointCotisations : Int := 1157200 / 400
def cotisationVieillesse : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * quartDePointCotisations

theorem cotisation_vieillesse_valeurs : quartDePointCotisations = 2893 ∧
    cotisationVieillesse = [2893, 5786, 8679, 11572, 14465] := by decide

/-- Aide publique au développement portée à 0,7 % du RNB (AEC 2025). En
2025 : 12,9 Md€, soit 0,42 % du RNB (75 Secondes, 30 août 2026, d'après
les données préliminaires de l'OCDE d'avril 2026) ; RNB implicite
12 900 / 0,42 % (calcul) ; écart de 0,28 point, atteint en cinq ans
(hypothèse). -/
def apd2025 : Int := 12900
def rnb2025 : Int := apd2025 * 10000 / 42
def hausseApd : Int := rnb2025 * 28 / 10000
def apdEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * hausseApd / 5

theorem apd_valeurs : rnb2025 = 3071428 ∧ hausseApd = 8599 ∧
    apdEcheancier = [1719, 3439, 5159, 6879, 8599] := by decide

/-! ## Ajouts du 6 novembre 2026 : plan santé et pôle public bancaire

Plan « Reconstruire notre système de santé » (plans thématiques de
*L'Avenir en commun*, édition 2027) et dossier « Pour un pôle public bancaire
au service des besoins » (novembre 2026). Les sources ne chiffrent presque
rien : montants d'après des données officielles ou des chiffrages
indépendants (calculs ci-dessous). -/

def planSante : String :=
  "Plan « Reconstruire notre système de santé » (plans thématiques de L'Avenir en commun, édition 2027)"
def dossierPole : String :=
  "Dossier « Pour un pôle public bancaire au service des besoins » (novembre 2026)"

/-- Franchises médicales et participations forfaitaires : 2,5 Md€ de moindres
dépenses en 2025, tous régimes de base (Cour des comptes, *La Sécurité
sociale 2026*, chap. V, mai 2026). Plafonds annuels portés de 50 à 70 €
chacun au 1er octobre 2026 (décret n° 2026-858) : rendement non publié ; la
version à 100 € par plafond valait ≈ 750 M€ (Le Monde, 23 juillet 2026) et
la tranche de 50 à 70 € touche tous les assurés qui dépassent 50 €, soit au
moins 40 % de cette version (20 € sur 50) : 300 M€ (calcul, borne basse).
Hors du « 100 % Sécu » (L-36) : le chiffrage de l'Institut Montaigne reprend
le transfert des remboursements des complémentaires (HCAAM, 2022), et les
contrats responsables ne remboursent ni franchises ni participations. -/
def franchises : Int := 2500 + 750 * 40 / 100

/-- Cotisations employeur d'un titulaire de la fonction publique
hospitalière, % du brut : CNRACL 37,65 % en 2026, maladie 9,88 %,
allocations familiales 5,25 %, FNAL, CSA, ATIACL, RAFP sur les primes,
≈ 48 % au total (calcul, hors primes à taux réduits). -/
def chargesEmployeurFphPct : Int := 148

/-- Psychologue hospitalier : 2 633 € nets par mois en équivalent temps
plein en 2023 (DREES, *Les établissements de santé*, édition 2026,
fiche 08), ramenés au brut par le rapport brut/net de la fonction publique
hospitalière en 2024 (3 558 / 2 896 €, Insee Première n° 2102), plus les
cotisations employeur (calcul). -/
def coutPsychologueEuros : Int := 2633 * 3558 / 2896 * 12 * chargesEmployeurFphPct / 100

/-- Emploi hospitalier : 3 657 € bruts par mois en moyenne dans les
hôpitaux publics en 2024, personnels médicaux compris (7 % des ETP de la
fonction publique hospitalière ; Insee Première n° 2102), plus les
cotisations employeur (calcul). 100 000 soignants et médecins de plus à
l'hôpital, nets des 10 000 postes de L-23 et des 2 500 psychologues de L-55,
en cinq ans (hypothèse : montée en charge linéaire). -/
def coutEmploiHopitalEuros : Int := 3657 * 12 * chargesEmployeurFphPct / 100
def emploisHopital : Int := 100000 - 10000 - 2500
def emploisHopitalEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * emploisHopital / 5

/-- 360 lits de pédopsychiatrie (2 475 lits à temps plein fin 2024, DREES,
fiche 11) : 860 € par journée d'hospitalisation (amendement AS437 au PLFSS
2026, d'après le besoin relevé par la Cour des comptes en mars 2023), soit
113 M€ par an, la moitié la première année (hypothèse) ; investissement non
chiffré faute de coût par lit publié. -/
def litsPedopsychiatrie : Int := 860 * 365 * 360 / 1000000

/-- Point d'indice relevé de 10 % pour les soignants : +1,5 % au 1er juillet
2023 a coûté 709 M€ en année pleine à la fonction publique hospitalière
(fiche d'impact du décret du 29 juin 2023, Acteurs publics). L-18 relève
déjà les traitements de ≈ 6,7 % (`couvertureL18Pb`) : le complément à 10 %
(3,3 points) pour la seule fonction publique hospitalière (calcul, valeur
2023). -/
def complementPointIndiceFph : Int := 709 * (1000 - couvertureL18Pb) / 150

/-- Médico-social et Ehpad : 300 000 professionnels de plus, soit 90 000 au-delà
des 210 000 de L-38, au même coût par ETP (`coutEtpGrandAgeEuros`), en cinq
ans. -/
def emploisMedicoSocial : Int := 300000 - 210000
def medicoSocialEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * emploisMedicoSocial * coutEtpGrandAgeEuros / 5 / 1000000

/-- Contrats d'études au SMIC dans toutes les formations paramédicales :
181 130 inscrits en 2024, dont 103 100 en soins infirmiers (trois années)
et 31 900 aides-soignants (DREES, *Formations aux professions de santé non
médicales et sage-femme en 2024*, octobre 2025), payés au SMIC brut de L-11 ;
contrats ouverts aux promotions entrantes, plein effet en trois ans
(hypothèse). Indemnités de stage et bourses existantes non déduites. -/
def etudiantsParamedicaux : Int := 181130
def contratsEtudes : Int := etudiantsParamedicaux * smicBrut smicNetCible * 12 / 1000000
def contratsEtudesEcheancier : List Int := [contratsEtudes / 3, contratsEtudes * 2 / 3, contratsEtudes]

/-- Contrats d'engagement de service public : objectif de 10 000 contrats
conclus à la fin du quinquennat, contre ≈ 800 par an aujourd'hui (596 en
médecine et 202 en odontologie ouverts en 2026, arrêtés de juin et juillet
2026) : 1 200 contrats de plus par an, allocation de 1 200 € bruts par mois
(14 400 € par an), quatre ans de versement en moyenne (hypothèse). -/
def cespEcheancier : List Int :=
  ([1, 2, 3, 4] : List Int).map fun k => k * 1200 * 14400 / 1000000

/-- Indemnités journalières : la baisse du plafond de 1,8 à 1,4 SMIC
(décret du 20 février 2025) économise 600 M€ en année pleine (PLFSS 2025) ;
l'annuler coûte autant. Les limitations de durée des arrêts de la LFSS 2026
ne sont pas chiffrées. -/
def plafondIndemnitesJournalieres : Int := 600

/-- Cannabis légalisé sous monopole d'État : ≈ 2 Md€ de recettes (CAE, note
n° 52, juin 2019 : 500 tonnes à 9 € le gramme ; 1,3 Md€ selon Terra Nova,
2014), affectées à la prévention des addictions (la source). Économies de
répression : nulles pour le CAE (la répression du trafic continue),
0,52 Md€ pour Terra Nova (variante). -/
def recettesCannabis : Int := 2000
def repressionCannabis : Int := 523

/-- Plafond du livret A porté de 23 000 à 30 000 € : 40 Md€ d'encours de
plus (estimation haute du directeur général de la Caisse des dépôts, citée
par la source), au taux du livret A (1,7 % depuis le 1er août 2026),
exonérés d'impôt sur le revenu et de prélèvements sociaux. Borne haute :
l'épargne est supposée venir de placements imposés au prélèvement forfaitaire
unique (12,8 % d'impôt sur le revenu, 18,6 % de prélèvements sociaux). -/
def interetsLivretAPlafond : Int := 40000 * 170 / 10000
def perteIrLivretA : Int := interetsLivretAPlafond * 128 / 1000
def pertePrelevementsSociauxLivretA : Int := interetsLivretAPlafond * 186 / 1000

/-- Taux du livret A au moins égal à l'inflation : la formule (moyenne de
l'inflation et du taux interbancaire, ici le taux court du scénario) n'est
en dessous de l'inflation que si le taux court l'est. Au scénario central
(inflation 2,3 % en 2026, 1,8 % en 2027, 1,6 % en 2028, puis 1,75 % ; taux
court 2,5 % puis 3,0 %), jamais : coût nul. Chaque point d'écart coûterait
≈ 2,0 Md€ par an d'aides à la pierre pour compenser les bailleurs sociaux
(203,4 Md€ de prêts du Fonds d'épargne au logement social fin 2025, indexés
sur le livret A ; rapport du Fonds d'épargne 2025), plus la dépense fiscale
(≈ 5 Md€ en 2025 pour tous les livrets, Banque de France). -/
def pretsLogementSocial : Int := 203400
def coutParPointLivretA : Int := pretsLogementSocial / 100

theorem livret_a_au_dessus_inflation :
    (List.range 10).all (fun k =>
      decide (Hypotheses.central.eco.inflationConsoA k ≤ Hypotheses.central.eco.tauxCourtA k)) = true := by
  decide

/-- Pôle public bancaire : financements portés de 100 à 200 Md€ par an
(dossier), hors administrations publiques selon la source (la Caisse des
dépôts est classée en « autres intermédiaires financiers », Banque de
France). Risque : Eurostat range dans les administrations publiques une
institution financière publique qui prête selon des objectifs fixés par
l'État sans rendement de marché (SNCI, Luxembourg, 2014 ; SBCI, Irlande,
2015 ; Eximbank, Hongrie, 2016), ou réachemine dans les comptes de l'État
des opérations faites sur instruction (atelier du CMFB, novembre 2018). -/
def financementsPoleSupplementaires : Int := 100000

theorem lfi_sante_valeurs :
    franchises = 2800 ∧ coutPsychologueEuros = 57435 ∧ coutEmploiHopitalEuros = 64948 ∧
    emploisHopitalEcheancier = [17500, 35000, 52500, 70000, 87500] ∧
    litsPedopsychiatrie = 113 ∧ complementPointIndiceFph = 1555 ∧
    medicoSocialEcheancier = [682, 1365, 2048, 2731, 3413] ∧
    contratsEtudes = 4666 ∧ cespEcheancier = [17, 34, 51, 69] ∧
    interetsLivretAPlafond = 680 ∧ perteIrLivretA = 87 ∧ pertePrelevementsSociauxLivretA = 126 ∧
    coutParPointLivretA = 2034 := by
  decide

def mesures : List Mesure := [
  { id := "L-01", titre := "Nouvelles lignes de production"
    source := s!"{page} : État 100 M€/an, pôle public bancaire et autres 200 M€/an"
    leviers := [.depenseSecteur .industrie 100, .annonceEmplois 40000] },
  { id := "L-02", titre := "Service public de la location abordable"
    source := s!"{page} : État 300 M€/an, pôle public bancaire et autres 700 M€/an ; parc public de 1,4 million de véhicules d'ici 2032"
    leviers := [.depenseSecteur .tertiaireMarchand 300] },
  { id := "L-03", titre := "Aides à l'achat électrique et local"
    source := s!"{page} : État 200 M€/an, pôle public bancaire et autres 200 M€/an ; conversion : 50 000 véhicules aidés par an à 4 000 € (hypothèse de prime unitaire)"
    leviers := [.aideAchatElectrique 50000 4000] },
  { id := "L-04", titre := "Sous-traitance et équipementiers (Fonds Avenir Automobile)"
    source := s!"{page} : État 200 M€/an, pôle public bancaire et autres 800 M€/an"
    leviers := [.depenseSecteur .industrie 200] },
  { id := "L-05", titre := "Batteries"
    source := s!"{page} : État 500 M€/an, pôle public bancaire et autres 900 M€/an ; cible d'au moins 100 GWh de capacité annuelle"
    leviers := [.depenseSecteur .industrie 500] },
  { id := "L-06", titre := "Réparation, recyclage, réemploi"
    source := s!"{page} : État 50 M€/an, pôle public bancaire et autres 240 M€/an"
    leviers := [.depenseSecteur .industrie 50] },
  { id := "L-07", titre := "Bornes de recharge"
    source := s!"{page} : État 0, pôle public bancaire et autres 20 M€/an"
    leviers := [] },
  { id := "L-08", titre := "Formation"
    source := s!"{page} : État 0, pôle public bancaire et autres 10 M€/an"
    leviers := [] },
  { id := "L-09", titre := "Recherche et développement : minibus autonomes"
    source := s!"{page} : État 20 M€/an, pôle public bancaire et autres 30 M€/an"
    leviers := [.depenseSecteur .tertiaireMarchand 20] },
  { id := "L-10", titre := "Retraite à 60 ans après 40 annuités"
    source := "L'Avenir en commun 2025, chap. 8 « Travailler tous, travailler moins, travailler mieux », § 8 (melenchon2027.fr/programme2025/livre/chapitre8/s8) ; âge légal fixé à 60 ans dès l'entrée en vigueur (−33 mois en 2027, puis l'écart au calendrier légal se creuse jusqu'à 48 mois en 2033), 40 annuités non modélisées ; le coût suit l'hypothèse économique du scénario"
    leviers := [.ageLegalCible 720 0]
    variantes := [{ nom := "budget rectificatif : 62 ans dès 2027 (9 Md€), 60 ans à une date non annoncée", leviers := [.ageLegalCible 744 0] }] },
  { id := "L-11", titre := "SMIC porté à 1 700 € net"
    source := s!"Budget rectificatif 2027 du 14 octobre 2026 (AFP, LCP) : 1 700 € net ({smicNetAec} € dans L'Avenir en commun 2025, variante). Conversion au brut au ratio net/brut du SMIC (1 443,11 / 1 823,03 au 1er janvier 2026, cotisations salariales de 20,84 %) : {smicBrut smicNetCible} € bruts ; la hausse se calcule sur le SMIC projeté de 2027 (≈ 1 875 € bruts, indexé sur les prix depuis 1 801,80 € en 2025), soit ≈ +14,5 % : au-delà d'une dizaine de points, l'effet est sans doute plus que proportionnel ; L-18 relève les traitements d'≈ 6,7 % : les points au-delà sont ajoutés pour les agents publics, {agentsPublicsNonCouverts smicNetCible} M€ (voir `agentsPublicsNonCouverts`)"
    leviers := [.smicCibleBrut (smicBrut smicNetCible) false,
                .remunerationPublique .traitement .fonctionnement [agentsPublicsNonCouverts smicNetCible]]
    variantes := [{ nom := "1 600 € net (L'Avenir en commun 2025)", leviers :=
      [.smicCibleBrut (smicBrut smicNetAec) false,
       .remunerationPublique .traitement .fonctionnement [agentsPublicsNonCouverts smicNetAec]] }] },
  { id := "L-12", titre := "ISF climatique"
    source := s!"{budget} : 10 Md€/an"
    leviers := [.prelevementSur .autres 10000] },
  { id := "L-13", titre := "Suppression de la flat tax (PFU)"
    source := s!"{budget} : 9 Md€/an, imputés à l'impôt sur le revenu"
    leviers := [.prelevementSur .ir 9000] },
  { id := "L-14", titre := "Taxe Zucman sur les patrimoines de plus de 100 M€"
    source := s!"{budget} : 15 Md€/an"
    leviers := [.prelevementSur .autres 15000] },
  { id := "L-15", titre := "Réforme des droits de succession (exonération sous 150 000 €, barème sur l'ensemble des transmissions reçues)"
    source := s!"{budget} : 20 Md€/an (droits de succession et de donation)"
    leviers := [.prelevementSur .droitsMutation 20000] },
  { id := "L-16", titre := "Rabot des niches fiscales (pacte Dutreil, crédit d'impôt recherche…)"
    source := s!"{budget} : 22 Md€/an, imputés pour moitié à l'IS et pour moitié aux autres impôts (répartition : hypothèse)"
    leviers := [.prelevementSur .impotSocietes 11000, .prelevementSur .autres 11000] },
  { id := "L-17", titre := "Taxes sur les rachats d'actions et les transactions financières"
    source := s!"{budget} : 7,5 Md€/an"
    leviers := [.prelevementSur .autres 7500] },
  { id := "L-18", titre := "Rémunération des agents publics"
    source := s!"{budget} : 17 Md€/an"
    leviers := [.depenseSur .fonctionnement 17000] },
  { id := "L-19", titre := "Garantie d'autonomie de 1 337 €/mois pour les jeunes"
    source := s!"{budget} : 9,5 Md€/an"
    leviers := [.depenseSur .famille 9500] },
  { id := "L-20", titre := "Action climatique"
    source := s!"{budget} : 10 Md€/an ; réduction d'émissions non chiffrée par la source, emplois dans la construction (hypothèse)"
    leviers := [.depenseSur .logementEnvironnement 10000] },
  { id := "L-21", titre := "Indexation des pensions et prestations, APL +10 %"
    source := s!"{budget} : 8 Md€/an"
    leviers := [.depenseSur .famille 8000] },
  { id := "L-22", titre := "Gratuité des cantines"
    source := s!"{budget} : 3,6 Md€/an"
    leviers := [.depenseSur .enseignement 3600] },
  { id := "L-23", titre := "Plan d'urgence hospitalier, 10 000 postes"
    source := s!"{budget} : 3 Md€/an"
    leviers := [.depenseSur .sante 3000, .annonceEmplois 10000] },
  { id := "L-24", titre := "Assurance chômage"
    source := s!"{budget} : 3 Md€/an"
    leviers := [.depenseSur .famille 3000] },
  { id := "L-25", titre := "10 000 postes d'enseignants"
    source := s!"{budget} : 0,5 Md€/an, soit 50 000 € par poste (calcul) ; postes publics comptés un pour un (levier `creationPostes`)"
    leviers := [.creationPostes .enseignement [10000] 50000, .annonceEmplois 10000] },
  { id := "L-26", titre := "Logement d'urgence et réquisitions contre le sans-abrisme"
    source := s!"{budget} : +3 Md€/an (chiffrage du parti)"
    leviers := [.depenseSur .logementEnvironnement 3000] },
  { id := "L-27", titre := "Université : 250 000 places supplémentaires"
    source := s!"{budget} : +3,5 Md€/an (chiffrage du parti) ; 250 000 places = +4,5 points de scolarisation à chaque âge de 18 à 24 ans (800 000 jeunes par génération) : coût et durée attendue de scolarisation calculés par le modèle commun (≈ 3,4 Md€)"
    leviers := [.scolarisationJeunes 45] },
  { id := "L-28", titre := "Violences sexistes et sexuelles, violences faites aux enfants"
    source := s!"{budget}, p. 10 : +2,6 Md€ « pour atteindre 3 milliards » contre les violences sexistes et sexuelles (budget demandé par les associations ; le plan santé, édition 2027, § 2.9, cite ces 3 milliards) et +2 Md€ (plan contre les violences faites aux enfants), chiffrage du parti"
    leviers := [.depenseSur .securiteJustice 2600, .depenseSur .famille 2000] },
  { id := "L-29", titre := "Réindexation des budgets ministériels coupés en 2026 (travail, logement, culture, sport, diplomatie, aide au développement)"
    source := s!"{budget} : +7 Md€/an, sans ventilation (chiffrage du parti) : non ventilé"
    leviers := [.depense 7000] },
  { id := "L-30", titre := "Grandes entreprises : taxe sur les superprofits, taxe universelle sur les multinationales, CVAE rétablie, IS réformé"
    source := s!"{budget} : 5 + 5 + 3 Md€ d'IS et 3 Md€ de CVAE (chiffrage du parti, sans contre-expertise ; « les 100 milliards ne seraient pas du tout 100 milliards », M. Plane, OFCE, AFP 14/10/2026)"
    leviers := [.prelevementSur .impotSocietes 13000, .prelevementSur .autres 3000] },
  { id := "L-31", titre := "Taxe sur les géants du numérique de 3 % à 15 %"
    source := s!"{budget} : +3,9 Md€ (chiffrage du parti ; la taxe actuelle rapportait ≈ 0,7 Md€ en 2024, Sénat)"
    leviers := [.prelevementSur .autres 3900] },
  { id := "L-32", titre := "Fraude fiscale et crypto-actifs"
    source := s!"{budget} : +2 Md€ (fraude) et +1 Md€ (crypto-actifs), chiffrage du parti"
    leviers := [.prelevementSur .autres 3000] },
  { id := "L-33", titre := "Fin des exonérations de cotisations au-delà de 2 SMIC"
    source := s!"{budget} : non chiffré par le parti ; modèle commun : allègements de 2 à 2,5 SMIC (34,3 % de la tranche 1,6-2,5 SMIC, calcul avec le barème de 2026) et au-delà de 2,5 SMIC, soit ≈ 4,2 Md€ (2025)"
    leviers := [.allegementsCotisations .intermediaire (-(8850 * 343 / 1000)), .allegementsCotisations .haut (-1200)] },
  { id := "L-34", titre := "200 000 logements publics par an pendant cinq ans"
    source := s!"Plan « BTP et logement » (melenchon2027.fr, 24 septembre 2026) : 400 000 logements abordables par an, dont 200 000 logements publics (140 000 très sociaux) ; État {planConstruction} M€ par an, pôle public bancaire et autres ≈ 16,3 Md€ (non imputés) ; cohérent avec 163 800 à 189 200 € par logement (Institut Montaigne, 2022) pour 100 000 logements de plus que les ≈ 100 000 actuels (USH). Recoupe en partie L-26 (hébergement d'urgence)"
    leviers := [.investissement .logementEnvironnement planConstruction] },
  { id := "L-35", titre := "Rénovation : 700 000 isolations par an sans reste à charge, bâtiments publics, sortie du fioul, patrimoine"
    source := s!"Plan « BTP et logement » (melenchon2027.fr, 24 septembre 2026), colonne État : {planRenovation} M€ par an de rénovation (isolation 5 300, logements sociaux 250, confort d'été 500, bâtiments publics et tertiaires 1 000, fioul et gaz 1 000, formation 60, déchets 200) et {planPatrimoine} M€ pour le patrimoine (voir `planRenovation`) ; économies d'énergie non chiffrées par la source, non modélisées. Recoupement possible avec L-20 (planification écologique, 10 Md€)"
    leviers := [.investissement .logementEnvironnement planRenovation, .investissement .culture planPatrimoine] },
  { id := "L-36", titre := "« 100 % Sécu » : remboursement intégral des soins prescrits, mutuelles intégrées à la Sécurité sociale"
    source := "L'Avenir en commun 2025 ; le parti le dit compensé (frais de gestion 3,5 à 4 Md€, dépassements 3 Md€, médicaments 2,5 Md€, niches des complémentaires 7,25 Md€, chiffrage 2022) ; retenu : coût net de 17,1 Md€ par an (Institut Montaigne, 14 février 2022, fourchette 15 à 26 ; base HCAAM de 22,5 Md€ moins 5,4 Md€ de frais de gestion évités)"
    leviers := [.depenseSur .sante 17100] },
  { id := "L-37", titre := "Conscription citoyenne de neuf mois, rémunérée au SMIC, pour les moins de 25 ans"
    source := "L'Avenir en commun 2025 (abrogation du SNU) ; chiffrage du parti en 2022 : 7,4 Md€ par an (750 000 jeunes, 11,4 Md€ de coûts et 4 Md€ d'économies) ; l'Institut Montaigne l'évaluait à 18,5 Md€ (variante). Imputé à la défense (hypothèse). Même population que L-19"
    leviers := [.depenseSur .defense 7400]
    variantes := [
      { nom := "chiffrage de l'Institut Montaigne (18,5 Md€)", leviers := [.depenseSur .defense 18500] }] },
  { id := "L-38", titre := "Grand âge : 210 000 professionnels formés et recrutés"
    source := s!"L'Avenir en commun 2025 : « au moins 210 000 personnes » ; non chiffré par le parti : {coutEtpGrandAgeEuros} € par ETP (Institut Montaigne, 2022), {coutGrandAge} M€ par an en cinq ans (voir `coutEtpGrandAgeEuros`)"
    leviers := [.depenseEcheancier .sante grandAgeEcheancier, .annonceEmplois 210000] },
  { id := "L-39", titre := "Ehpad publics : 10 000 places par an pendant cinq ans"
    source := s!"L'Avenir en commun 2025 ; non chiffré par le parti : {coutPlaceEhpadEuros} € par place construite, {investissementEhpad} M€ par an de 2027 à 2031, puis {fonctionnementPlaceEhpadEuros} € par place et par an de soins et d'APA (voir `coutPlaceEhpadEuros`)"
    leviers := [.investissementEcheancier .sante [investissementEhpad, investissementEhpad, investissementEhpad,
                                                  investissementEhpad, investissementEhpad, 0],
                .depenseEcheancier .sante fonctionnementEhpad] },
  { id := "L-40", titre := "AAH portée au niveau du SMIC"
    source := s!"L'Avenir en commun 2025 ; non chiffré : AAH portée au SMIC net de L-11 (1 700 €, budget rectificatif), 12,7 Md€ × ({smicNetCible} − 1 033,32) / 1 033,32 = {hausseAAH} M€ (dépense de 2023, AAH de 2025 : légère sous-estimation) par an (DREES ; voir `hausseAAH`)"
    leviers := [.depenseSur .famille hausseAAH] },
  { id := "L-41", titre := "Minimum vieillesse au niveau du seuil de pauvreté"
    source := s!"L'Avenir en commun 2025 ; non chiffré : 4,1 Md€ × (1 337 − 1 034,28) / 1 034,28 = {hausseASPA} M€ par an (DREES, Insee ; voir `hausseASPA`) ; le volet « pensions au SMIC pour une carrière complète » n'est pas chiffré"
    leviers := [.depenseSur .retraites hausseASPA] },
  { id := "L-42", titre := "500 000 places en crèche en cinq ans"
    source := "L'Avenir en commun 2025 ; chiffrage du parti en 2022 : 17,5 Md€ d'investissement (3,5 Md€ par an pendant cinq ans) et 9,5 Md€ par an de fonctionnement à plein régime, montée en charge linéaire (hypothèse) ; l'Institut Montaigne retenait 4,3 Md€ de fonctionnement public la cinquième année"
    leviers := [.investissementEcheancier .famille [3500, 3500, 3500, 3500, 3500, 0],
                .depenseEcheancier .famille [1900, 3800, 5700, 7600, 9500]] },
  { id := "L-43", titre := "Gratuité réelle de l'école publique (fournitures, périscolaire, transports)"
    source := "L'Avenir en commun 2025 ; chiffrage du parti en 2022 : 7,9 Md€ cantine comprise, moins les 3,6 Md€ de la gratuité des cantines (L-22) : 4,3 Md€ (calcul ; 3,3 Md€ selon l'Institut Montaigne)"
    leviers := [.depenseSur .enseignement 4300] },
  { id := "L-44", titre := "Enseignement supérieur et recherche : 40 000 personnels statutaires en cinq ans"
    source := s!"Plan ESR (melenchon2027.fr, 26 octobre 2026) ; non chiffré : 8 000 postes par an à {coutEnseignantEuros} € (hypothèse, voir `coutEnseignantEuros`), {postesEsrEcheancier.getLastD 0} M€ par an en 2031 ; les 8 000 contrats doctoraux de plus par an sont en L-52"
    leviers := [.creationPostes .enseignement [8000, 16000, 24000, 32000, 40000] coutEnseignantEuros,
                .annonceEmplois 40000] },
  { id := "L-45", titre := "Gratuité de l'enseignement supérieur"
    source := "L'Avenir en commun 2025 et plan ESR ; droits d'inscription 342 M€ et compensation des boursiers 112 M€ (Institut Montaigne, 2022), contribution de vie étudiante 194 M€ attendus en 2026 (amendement CF341 au PLF 2026), soit 424 M€ par an (calcul, années de référence différentes) ; le repas à 1 € au CROUS est déjà ouvert à tous les étudiants depuis mai 2026 (143 M€ au PLF 2027) : sans coût de plus"
    leviers := [.depenseSur .enseignement 424] },
  { id := "L-46", titre := "Police de proximité rétablie, BAC et BRAV-M démantelées"
    source := "L'Avenir en commun 2025 ; chiffrage du parti en 2022 : 0,35 Md€ par an (0,83 Md€ net selon l'Institut Montaigne : 26 700 agents, économie de 0,41 Md€ sur les BAC)"
    leviers := [.depenseSur .securiteJustice 350] },
  { id := "L-47", titre := "Impôt sur le revenu à 14 tranches"
    source := "L'Avenir en commun 2025 ; « au cours du mandat », non chiffré en 2026 ; chiffrage du parti en 2022 : 10 Md€ de baisse et 5 Md€ de hausse, soit −5 Md€ nets (calcul) ; crédit d'impôt par enfant à la place du quotient familial et CSG progressive non chiffrés"
    leviers := [.prelevementSur .ir (-5000),
                -- tranche à 90 % au-delà de 400 000 € (L'Avenir en commun, 2017 et 2022 ;
                -- reconduite en 2025, hypothèse) : au-dessus du seuil censuré en 2012 (75 %)
                .tauxMarginalSommet 900] },
  { id := "L-48", titre := "Cotisation vieillesse : +0,25 point par an pendant le quinquennat"
    source := s!"L'Avenir en commun 2025 (via Votons 2027) ; non chiffré : {quartDePointCotisations} M€ par quart de point (voir `quartDePointCotisations`), {cotisationVieillesse.getLastD 0} M€ en 2031"
    leviers := [.recetteEcheancier (some .cotisations) cotisationVieillesse] },
  { id := "L-49", titre := "Sixième semaine de congés payés"
    source := "L'Avenir en commun 2025 : « généraliser une sixième semaine de congés payés » ; conversion : 35 heures sur 1 607 heures annuelles, −2,2 % de durée du travail (calcul)"
    leviers := [.dureeTravail (-22)] },
  { id := "L-50", titre := "Aide publique au développement portée à 0,7 % du RNB"
    source := s!"L'Avenir en commun 2025 ; non chiffré : de 0,42 % à 0,7 % du RNB, +{hausseApd} M€ par an atteints en cinq ans ; versements à l'étranger, sans effet sur la demande intérieure (recette non fiscale négative, comme O-114) (voir `apd2025`)"
    leviers := [.recetteEcheancier none (apdEcheancier.map (fun x => -x))] },
  { id := "L-51", titre := "Recherche publique portée à 1,5 % du PIB en 2032"
    source := s!"Plan ESR (melenchon2027.fr, octobre 2026) : « 3 % du PIB, dont 1,5 % pour le secteur public en 2032 » ; non chiffré : 0,75 % du PIB en 2024 (SIES), écart de {ecartRecherchePublique} M€ atteint en six paliers, net de L-44 et L-52 : {rechercheNette} M€ (voir `rechercheNette`) ; recouvrement possible avec L-16 (crédit d'impôt recherche supprimé, non réaffecté)"
    leviers := [.depenseEcheancier .enseignement rechercheNette] },
  { id := "L-52", titre := "8 000 contrats doctoraux de plus par an"
    source := s!"Plan ESR (melenchon2027.fr, octobre 2026) ; non chiffré : contrats de trois ans à {coutDoctorantEuros} € par an (coût employeur, FRM 2026 ; voir `coutDoctorantEuros`), 24 000 doctorants de plus à partir de 2029"
    leviers := [.creationPostes .enseignement doctorantsEcheancier coutDoctorantEuros] },
  { id := "L-53", titre := "30 000 logements étudiants par an"
    source := s!"Plan ESR (melenchon2027.fr, octobre 2026) ; non chiffré : {coutLogementEtudiantEuros} € par logement (Cnous, repris par LFI au PLF 2026), {logementsEtudiants} M€ par an (calcul) ; recouvrement possible avec les 200 000 logements publics de L-34"
    leviers := [.investissement .enseignement logementsEtudiants] },
  { id := "L-54", titre := "Suppression des franchises médicales et des participations forfaitaires"
    source := s!"{planSante}, § 1.1 ; non chiffré : 2,5 Md€ de moindres dépenses en 2025 (Cour des comptes) et ≥ 0,3 Md€ du relèvement des plafonds à 70 € au 1er octobre 2026 (calcul), {franchises} M€ par an (voir `franchises`) ; hors du chiffrage du 100 % Sécu (L-36)"
    leviers := [.depenseSur .sante franchises] },
  { id := "L-55", titre := "2 500 postes de psychologues dans les centres médico-psychologiques"
    source := s!"{planSante}, § 1.3 ; non chiffré : {coutPsychologueEuros} € par poste (DREES, Insee, cotisations d'un titulaire ; voir `coutPsychologueEuros`), moitié des recrutements la première année (hypothèse)"
    leviers := [.creationPostes .sante [1250, 2500] coutPsychologueEuros] },
  { id := "L-56", titre := "360 lits de pédopsychiatrie"
    source := s!"{planSante}, § 1.3 ; non chiffré : 860 € par journée (amendement AS437 au PLFSS 2026), {litsPedopsychiatrie} M€ par an, moitié la première année (voir `litsPedopsychiatrie`)"
    leviers := [.depenseEcheancier .sante [litsPedopsychiatrie / 2, litsPedopsychiatrie]] },
  { id := "L-57", titre := "Point d'indice des soignants relevé de 10 %"
    source := s!"{planSante}, § 1.2 ; non chiffré : complément à 10 % des ≈ 6,7 % de L-18 pour la fonction publique hospitalière, {complementPointIndiceFph} M€ par an (709 M€ pour 1,5 % en 2023 ; voir `complementPointIndiceFph`) ; le point d'indice étant commun aux trois fonctions publiques, l'étendre aux autres coûterait ≈ 8,3 Md€ (25,3 − 17)"
    leviers := [.remunerationPublique .traitement .sante [complementPointIndiceFph]] },
  { id := "L-58", titre := "100 000 soignants et médecins de plus à l'hôpital"
    source := s!"{planSante}, § 2.4 ; non chiffré : {emploisHopital} emplois nets de L-23 et L-55, en cinq ans, à {coutEmploiHopitalEuros} € (salaire moyen des hôpitaux publics, Insee, plus cotisations ; voir `coutEmploiHopitalEuros`)"
    leviers := [.creationPostes .sante emploisHopitalEcheancier coutEmploiHopitalEuros, .annonceEmplois emploisHopital] },
  { id := "L-59", titre := "300 000 professionnels de plus dans le médico-social et les Ehpad"
    source := s!"{planSante}, § 2.4 ; non chiffré : {emploisMedicoSocial} au-delà des 210 000 de L-38, au coût de L-38 ({coutEtpGrandAgeEuros} € par ETP), {medicoSocialEcheancier.getLastD 0} M€ par an en cinq ans (voir `medicoSocialEcheancier`) ; coût sans doute bas (aide-soignant en Ehpad : 43 391 €, CNSA, 2017-2018)"
    leviers := [.depenseEcheancier .sante medicoSocialEcheancier, .annonceEmplois emploisMedicoSocial] },
  { id := "L-60", titre := "Contrats d'études au SMIC dans les formations paramédicales"
    source := s!"{planSante}, § 2.4 ; non chiffré : {etudiantsParamedicaux} inscrits (DREES, 2024) au SMIC brut de L-11, {contratsEtudes} M€ par an en trois ans (voir `contratsEtudes`) ; recouvrement possible avec la garantie d'autonomie (L-19) pour les moins de 25 ans"
    leviers := [.remunerationPublique .traitement .sante contratsEtudesEcheancier] },
  { id := "L-61", titre := "10 000 contrats d'engagement de service public à la fin du quinquennat"
    source := s!"{planSante}, § 2.4 ; non chiffré : 1 200 contrats de plus par an à 14 400 € (voir `cespEcheancier`), {cespEcheancier.getLastD 0} M€ par an au bout de quatre ans"
    leviers := [.depenseEcheancier .sante cespEcheancier] },
  { id := "L-62", titre := "Indemnités journalières : fin des restrictions"
    source := s!"{planSante}, § 1.1 ; non chiffré : retour du plafond à 1,8 SMIC, {plafondIndemnitesJournalieres} M€ par an (PLFSS 2025) ; limitations de durée de la LFSS 2026 non chiffrées"
    leviers := [.depenseSur .famille plafondIndemnitesJournalieres] },
  { id := "L-63", titre := "Cannabis légalisé sous monopole d'État, recettes affectées à la prévention"
    source := s!"{planSante}, § 2.10 ; non chiffré : {recettesCannabis} M€ de recettes (CAE, note n° 52, 2019), dépensées en prévention et réduction des risques (la source) ; économies de répression nulles (CAE), {repressionCannabis} M€ en variante (Terra Nova, 2014)"
    leviers := [.recetteEcheancier (some .autres) [recettesCannabis], .depenseSur .sante recettesCannabis]
    variantes := [{ nom := "avec les économies de répression de Terra Nova (0,52 Md€)", leviers :=
      [.recetteEcheancier (some .autres) [recettesCannabis], .depenseSur .sante recettesCannabis,
       .economieSur .securiteJustice repressionCannabis] }] },
  { id := "L-64", titre := "Pôle public bancaire : financements portés de 100 à 200 Md€ par an"
    source := s!"{dossierPole} : hors administrations publiques selon la source (statut actuel de la Caisse des dépôts), non imputé ; variante : requalification par Eurostat, les {financementsPoleSupplementaires} M€ par an de financements nouveaux s'ajoutant à la dette publique, sans les intérêts que rapporteraient ces prêts (borne haute ; voir `financementsPoleSupplementaires`)"
    leviers := []
    variantes := [{ nom := "requalifié dans les administrations publiques (100 Md€ par an de dette en plus)", leviers :=
      [.pretEtat financementsPoleSupplementaires] }] },
  { id := "L-65", titre := "Livret A : plafond à 30 000 € et taux au moins égal à l'inflation"
    source := s!"{dossierPole} ; non chiffré : 40 Md€ d'encours de plus, {interetsLivretAPlafond} M€ d'intérêts exonérés, soit {perteIrLivretA} M€ d'impôt sur le revenu et {pertePrelevementsSociauxLivretA} M€ de prélèvements sociaux perdus (borne haute ; voir `interetsLivretAPlafond`) ; taux à l'inflation : coût nul aux hypothèses centrales (`livret_a_au_dessus_inflation`), {coutParPointLivretA} M€ d'aides à la pierre par point d'écart ; livret B et refinancement auprès de la BCE non chiffrés"
    leviers := [.recetteEcheancier (some .ir) [-perteIrLivretA],
                .recetteEcheancier (some .csgCrds) [-pertePrelevementsSociauxLivretA]] }
]

def programme : Programme where
  id := "LFI"
  nom := "La France insoumise — Mélenchon 2027 (extraits)"
  description := "Transcription partielle et non officielle : plan « Automobile » (1,37 Md€/an), retraite à 60 ans (L'Avenir en commun 2025) et SMIC à 1 700 € net (budget rectificatif), recettes (106,4 Md€, toutes transcrites) et dépenses (72,7 sur 81,7) du budget rectificatif 2027 du 14 octobre 2026, université (250 000 places), fin des exonérations au-delà de 2 SMIC. Ajouts du 28 octobre 2026 (plans « BTP et logement » et ESR, L'Avenir en commun 2025, chiffrages de 2022) : 200 000 logements publics par an, rénovation, 100 % Sécu, conscription citoyenne, grand âge et Ehpad, AAH et minimum vieillesse, crèches, gratuité de l'école et du supérieur, police de proximité, IR à 14 tranches, cotisation vieillesse, sixième semaine de congés, aide au développement à 0,7 % du RNB. Ajouts du 30 octobre 2026 (plan ESR) : recherche publique à 1,5 % du PIB en 2032, contrats doctoraux, logements étudiants. Ajouts du 6 novembre 2026 (plan santé, édition 2027, et dossier du pôle public bancaire) : franchises supprimées, psychiatrie, point d'indice des soignants, 100 000 emplois à l'hôpital et 300 000 dans le médico-social, contrats d'études paramédicaux, CESP, indemnités journalières, cannabis, pôle public bancaire, livret A."
  mainteneurs := ["@TOrientationD"]
  source := "https://melenchon2027.fr/programme/plans-investissement/automobile/ (consulté le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.LFI
