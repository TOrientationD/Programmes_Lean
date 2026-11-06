import Modele
import Hypotheses
import Proprietes

/-!
# Parti socialiste — Le Projet socialiste (2026)

Transcription **partielle et non officielle** du Projet socialiste adopté
par les adhérents en 2026, porté par Chloé Ridel (projet-socialiste.fr,
six parties et vingt chapitres, consultés le 21 et le 30 octobre 2026). La
source ne publie pas de chiffrage global. Complété par le contre-budget
2027 des députés socialistes (16 septembre 2026, chiffres du parti
rapportés par la presse ; document non consulté directement).
Candidat issu de la primaire « Choisir 2027 » (9-11 octobre 2026) :
R. Glucksmann, dont les propositions sont transcrites dans
`Programmes/PlacePublique/`. Par choix du dépôt, ce programme
reste celui du Projet socialiste, quel que soit le candidat.

Règle de transcription : une proposition devient un levier seulement si la
source donne un montant annuel, ou un paramètre que le modèle commun
représente directement (SMIC, âge légal). Les conversions faites ici sont
écrites dans le champ `source` de la mesure. Les autres propositions sont
listées dans README.md, sans levier. Aucun engagement n'est déclaré.
-/

namespace Programmes.PS
open Modele

def site : String := "projet-socialiste.fr"
def partie (chemin : String) : String := s!"projet-socialiste.fr/projet/{chemin}/"

def contreBudget : String :=
  "Contre-budget 2027 des députés socialistes, 16 septembre 2026 (Selectra, JDN, LCP, Planet ; chiffres du parti, sans contre-expertise)"

/-- Coût moyen d'un enseignant, hors pensions : 59,23 Md€ de masse salariale
hors CAS Pensions pour 852 752 enseignants en 2026 (PLF 2026, rapport du
Sénat sur la mission Enseignement scolaire), soit 69 457 € (calcul),
appliqué aux postes de l'enseignement supérieur (hypothèse). -/
def coutEnseignantEuros : Int := 59230000000 / 852752
def postesSuperieur : List Int :=
  ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List Int).map fun k => k * 2000 * coutEnseignantEuros / 1000000

/-- Petite enfance, 200 000 solutions d'accueil de plus : construction à
35 000 € par place (17,5 Md€ pour 500 000 places, Institut Montaigne,
2022, calcul) en cinq ans ; fonctionnement à 15 381 € par place et par an
(coût CNAF cité par l'Institut Montaigne), tous financeurs (majorant de la
part publique). -/
def placesAccueil : Int := 200000
def investissementAccueil : Int := placesAccueil * 35000 / 5 / 1000000
def fonctionnementAccueil : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * placesAccueil * 15381 / 5 / 1000000

/-- Aide publique au développement portée à 0,7 % du RNB (chap. 20). En
2025 : 12,9 Md€, soit 0,42 % du RNB (75 Secondes, 30 août 2026, d'après
les données préliminaires de l'OCDE) ; écart de 0,28 point du RNB implicite
(calcul), atteint en cinq ans (hypothèse). -/
def hausseApd : Int := 12900 * 10000 / 42 * 28 / 10000
def apdEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * hausseApd / 5

/-- Exonérations sociales de 2 à 3,5 SMIC (chap. 16 : « Supprimer les
exonérations sociales qui n'ont pas d'effet sur l'emploi, entre 2 et 3,5
SMIC », « une économie de 11 milliards d'euros par an »). Le chiffre précède
la réforme de 2026, qui a fondu les dispositifs en une réduction dégressive
unique s'éteignant à 3 SMIC : il reste les allègements de 2 à 2,5 SMIC
(34,3 % de la tranche de 1,6 à 2,5 SMIC, 8 850 M€, barème de 2026) et
au-delà (1 200 M€), répartition du modèle commun (`Hypotheses/Reference.lean`),
soit ≈ 4,2 Md€ (calcul, même traduction que L-33). -/
def allegementsIntermediaires : Int := 8850
def partAuDela2SmicPm : Int := 343
def allegementsHauts : Int := 1200
def exonerationsSupprimees : Int := allegementsIntermediaires * partAuDela2SmicPm / 1000 + allegementsHauts

/-- Enseignants (chap. 11) : salaires des enseignants expérimentés « 16 % en
dessous de la moyenne OCDE » : le rattrapage demande +16/84 ≈ +19 %
(calcul), appliqué à toute la masse salariale, 59,23 Md€ hors CAS Pensions
(PLF 2026), cotisations patronales hors pensions comprises (majorant), en
cinq hausses égales (hypothèse). -/
def ecartOcdePm : Int := 160 * 1000 / (1000 - 160)
def rattrapageEnseignants : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * (59230 * ecartOcdePm / 1000) / 5

/-- AAH au seuil de pauvreté (chap. 12) : AAH maximale de 1 041,59 € au
1er avril 2026 (monparcourshandicap.gouv.fr), seuil de pauvreté 2024 de
1 337 € (Insee, juillet 2026), 12,7 Md€ de dépense (DREES, même base que
L-40) relevée en proportion (calcul). -/
def hausseAAH : Int := 12700 * (133700 - 104159) / 104159

/-- Recherche publique à 1 % du PIB d'ici 2030 (chap. 5) : dépense de R&D
des administrations de 20,9 Md€ en 2023, 0,74 % du PIB (SIES, note 25.12),
écart de 0,26 point (euros de 2023), atteint en quatre paliers (hypothèse),
net des postes de l'enseignement supérieur de P-20, qui en font partie
(calcul, comme L-51). -/
def rechercheAdministrations2023 : Int := 20900
def ecartRecherche : Int := rechercheAdministrations2023 * (100 - 74) / 74
def rechercheEcheancier : List Int :=
  ([1, 2, 3, 4, 4, 4, 4, 4, 4, 4] : List Int).map fun k => k * ecartRecherche / 4
def rechercheNette : List Int :=
  (rechercheEcheancier.zip postesSuperieur).map fun (r, p) => r - p

/-- Prévention (chap. 6) : portée « de 4 à 8 % » des dépenses de santé, lue
comme un doublement (hypothèse). La DREES mesure 8,73 Md€ de dépenses de
prévention en 2024, 2,6 % de la dépense courante de santé (comptes de la
santé 2025, fiches 22 et 23) : la base du Projet ne correspond pas à sa
mesure ; montée en cinq ans (hypothèse). -/
def preventionDrees2024 : Int := 8730
def preventionEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * preventionDrees2024 / 5

/-- Reconversion (chap. 3) : un million d'actifs en dix ans, payés à 100 %
de leur salaire pendant un an ; 29 220 € par projet de transition
professionnelle (France compétences, rapport 2024 : 943 heures en moyenne),
100 000 par an (calcul). -/
def reconversionsParAn : Int := 100000
def coutReconversionEuros : Int := 29220
def coutReconversion : Int := reconversionsParAn * coutReconversionEuros / 1000000

/-- Sport à 1 % du budget (chap. 16) : budget général de 452,7 Md€ en 2026
(Sénat) ; programme « Sport » ≈ 0,55 Md€ (LFI 2026), seul périmètre retenu
(hypothèse) ; calcul. -/
def budgetGeneral2026 : Int := 452700
def budgetSport2026 : Int := 550
def hausseSport : Int := budgetGeneral2026 / 100 - budgetSport2026

/-- Asile et accueil (chap. 17 et 19) : 30 000 places d'hébergement pour
les demandeurs d'asile, 10 000 visas humanitaires par an et 20 000
réinstallations sur cinq ans ; 21 € par jour et par place en centre
d'accueil (coût cible 2023, Sénat), un an d'accueil par personne
accueillie (hypothèse) ; les places existantes de réinstallation ne sont
pas déduites (majorant). -/
def coutJourAccueilEuros : Int := 21
def placesAsile : Int := 30000
def accueillisParAn : Int := 10000 + 20000 / 5
def soldeAccueilMilliers : Int := accueillisParAn / 1000
def coutPlacesAsile : Int := placesAsile * coutJourAccueilEuros * 365 / 1000000
def coutAccueil : Int := accueillisParAn * coutJourAccueilEuros * 365 / 1000000

theorem ajouts_valeurs :
    exonerationsSupprimees = 4235 ∧
    ecartOcdePm = 190 ∧ rattrapageEnseignants = [2250, 4501, 6751, 9002, 11253] ∧
    hausseAAH = 3601 ∧ ecartRecherche = 7343 ∧
    rechercheNette = [1697, 3394, 5091, 6788, 6649, 6510, 6371, 6232, 6093, 5954] ∧
    preventionEcheancier = [1746, 3492, 5238, 6984, 8730] ∧
    coutReconversion = 2922 ∧ hausseSport = 3977 ∧
    coutPlacesAsile = 229 ∧ accueillisParAn = 14000 ∧ coutAccueil = 107 := by decide

theorem valeurs :
    postesSuperieur = [138, 277, 416, 555, 694, 833, 972, 1111, 1250, 1389] ∧
    investissementAccueil = 1400 ∧ fonctionnementAccueil = [615, 1230, 1845, 2460, 3076] ∧
    hausseApd = 8599 ∧ apdEcheancier = [1719, 3439, 5159, 6879, 8599] := by decide

def mesures : List Mesure := [
  { id := "P-01", titre := "SMIC porté à 1 690 € net"
    source := s!"{partie "vivre-libres"}, chap. 1 « Redonner du sens et de la valeur au travail » : « Réhausser le SMIC à 1 690 € net » (1 700 € net, « objectif arrondi », dans le contre-budget du 16 septembre 2026 : non retenu, le Projet prime). Conversion au brut au ratio net/brut du SMIC (1 443,11 / 1 823,03 au 1er janvier 2026, cotisations salariales de 20,84 %) : 2 135 € bruts, hausse calculée sur le SMIC projeté de 2027 (≈ +13,8 %)"
    leviers := [.smicCibleBrut 2135] },
  { id := "P-02", titre := "Âge légal de départ ramené à 62 ans"
    source := s!"{site}, chap. 1 « Pouvoir profiter de sa retraite » (avec 43 annuités et 10 critères de pénibilité, non modélisés) ; 62 ans dès l'entrée en vigueur : −9 mois en 2027, l'écart au calendrier légal atteint 24 mois en 2033"
    leviers := [.ageLegalCible 744 0] },
  { id := "P-03", titre := "Exonérations sociales supprimées entre 2 et 3,5 SMIC"
    source := s!"{partie "refaire-societe"}, chap. 16 « Imposer la justice fiscale » : « Supprimer les exonérations sociales qui n'ont pas d'effet sur l'emploi, entre 2 et 3,5 SMIC », « 11 milliards d'euros par an » ; chiffre antérieur à la réforme des allègements de 2026 : il reste ≈ {exonerationsSupprimees} M€ d'allègements au-delà de 2 SMIC (modèle commun, voir `exonerationsSupprimees`), effets sur l'emploi calculés par le modèle ; la puce sur les niches fiscales, sans montant, est en P-23"
    leviers := [.allegementsCotisations .intermediaire (0 - allegementsIntermediaires * partAuDela2SmicPm / 1000),
                .allegementsCotisations .haut (0 - allegementsHauts)]
    variantes := [{ nom := "11 Md€ du Projet, imputés aux cotisations", leviers := [.prelevementSur .cotisations 11000] }] },
  { id := "P-04", titre := "Impôt sur les grandes successions"
    source := s!"{site}, chap. 16 : rendement cumulé de 400 Md€ sur 2025-2040, soit 25 Md€/an en moyenne (400 / 16), imputés aux droits de succession et de donation dès 2027 ; l'assiette successorale croissant plus vite que le PIB, le rendement modélisé dépasse ensuite cette moyenne"
    leviers := [.prelevementSur .droitsMutation 25000]
    variantes := [{ nom := "contre-budget 2027 : CSG sur les héritages de plus de 500 000 € par héritier, 10 Md€", leviers :=
      [.prelevementSur .droitsMutation 10000] }] },
  { id := "P-05", titre := "Suppression des doublons entre l'État et les collectivités"
    source := s!"{site}, chap. 18 « Achever la décentralisation » : économie de « plus de 7,5 Mds € »"
    leviers := [.economieSur .fonctionnement 7500] },
  { id := "P-06", titre := "Taxe de 1 €/kg sur les emballages non recyclables, affectée au recyclage"
    source := s!"{site}, chap. 7 : taxe de 1 €/kg pour financer le recyclage « à hauteur de 500 M€/an »"
    leviers := [.prelevement 500, .depenseSur .logementEnvironnement 500] },
  { id := "P-07", titre := "Loi intégrale contre les violences sexistes et sexuelles"
    source := s!"{site}, chap. 13 : « mobiliser 2,6 milliards d'euros par an ». Traité comme dépense nouvelle ; à réduire de la part déjà engagée si la source la précise"
    leviers := [.depenseSur .securiteJustice 2600] },
  { id := "P-08", titre := "Aide humanitaire d'urgence portée à 1 Md€ par an"
    source := s!"{site}, chap. 19 : de 500 M€ en 2025 à 1 Md€ par an, soit +500 M€/an"
    leviers := [.depenseSur .fonctionnement 500] },
  { id := "P-09", titre := "CSG progressive sur les revenus d'activité jusqu'à 2 700 € net"
    source := s!"{contreBudget} : ≈ 10 Md€ de moindres recettes (21 millions d'actifs ; CSG au SMIC de 9,2 % à moins de 1 %)"
    leviers := [.prelevementSur .csgCrds (-10000)] },
  { id := "P-10", titre := "Taxe sur les géants du numérique"
    source := s!"{contreBudget} : +10 Md€ (l'assiette dépasserait de loin celle de la taxe actuelle, ≈ 0,7 Md€)"
    leviers := [.prelevementSur .autres 10000] },
  { id := "P-11", titre := "Accès aux soins : hôpitaux et EHPAD publics, mutuelle publique gratuite pour les 18-25 ans"
    source := s!"{contreBudget} : +5 Md€ (3 Md€ hôpitaux et EHPAD, 1 Md€ mutuelle des 18-25 ans)"
    leviers := [.depenseSur .sante 5000] },
  { id := "P-12", titre := "Climat : fonds de sécurité climatique, fonds vert des collectivités"
    source := s!"{contreBudget} : +10 Md€ pour le climat (dont 5 Md€ de fonds de sécurité climatique et 1,5 Md€ de fonds vert)"
    leviers := [.depenseSur .logementEnvironnement 10000] },
  { id := "P-13", titre := "École, agriculteurs, sécurité civile"
    source := s!"{contreBudget} : +2 Md€ (école), +2 Md€ (agriculteurs) ; la sécurité civile doublée à 1 Md€ est comprise dans les 10 Md€ du climat (P-12) : les 22 Md€ de dépenses du contre-budget font climat 10 + santé 5 + violences sexistes 3 + agriculteurs 2 + école 2 (Selectra, Économie Matin)"
    leviers := [.depenseSur .enseignement 2000, .depenseSur .affairesEconomiques 2000] },
  { id := "P-14", titre := "Révision des exonérations de cotisations patronales"
    source := s!"{contreBudget} : +4 Md€, version mise à jour des exonérations de 2 à 3,5 SMIC du Projet (P-03, ≈ 4,2 Md€ après la réforme de 2026) : comprise dans P-03, sans levier propre"
    leviers := [] },
  { id := "P-15", titre := "Fraude, travail dissimulé, économies sur l'État et sur les marges du secteur de la santé"
    source := s!"{contreBudget} : fraude fiscale 2,4 Md€, travail dissimulé 1,1 Md€, État 3,6 Md€, santé 4 Md€ (Selectra ; 15,1 Md€ détaillés sur 17,5 annoncés)"
    leviers := [.prelevementSur .autres 2400, .prelevementSur .cotisations 1100,
                .economieSur .fonctionnement 3600, .economieSur .sante 4000] },
  { id := "P-16", titre := "Taxe Zucman : 2 % sur les patrimoines de plus de 100 M€"
    source := s!"{site}, chap. 16 « Refaire société » : « taxe Zucman de 2 % sur le patrimoine des grandes fortunes de plus de 100 millions d'euros » ; 15 Md€ par an dans les contre-budgets 2026 (30 août 2025) et 2027 (16 septembre 2026), chiffrage du parti (≈ 20 Md€ selon G. Zucman ; « 2 à 3 milliards » selon le rapporteur du Sénat, 4 juin 2025) ; même imputation que L-14 et E-05"
    leviers := [.prelevementSur .autres 15000] },
  { id := "P-17", titre := "Fiscalité des dividendes : prélèvement forfaitaire unique relevé"
    source := s!"{site}, chap. 16 : « suppression du prélèvement forfaitaire unique et hausse de la CSG sur les revenus du capital » ; chiffrage du parti dans le contre-budget 2026 (LCP, Public Sénat, 30 août 2025) : flat tax de 30 % à 32 %, 3,8 Md€ (la suppression coûterait davantage aux contribuables : 3,2 Md€ avec l'exit tax selon l'Institut Montaigne, 2024)"
    leviers := [.prelevementSur .ir 3800] },
  { id := "P-18", titre := "Leasing social : un million de voitures électriques à 100 € par mois"
    source := s!"{site} (via Votons 2027) ; non chiffré par le PS : même traduction que PP-04 (6 Md€ pour un million de voitures selon R. Glucksmann, AFP, 2 octobre 2026), sur cinq ans : 200 000 voitures par an à 6 000 € d'aide"
    leviers := [.aideAchatElectrique 200000 6000 .modestes] },
  { id := "P-19", titre := "Classes de 19 élèves au plus, de 22,4 à 18,2 élèves en moyenne en dix ans"
    source := s!"{site}, chap. 11 ; non chiffré : 6,8 Md€ par an pour les classes à 19 (Institut Montaigne, 2022, même mesure de LFI, fourchette 4,6 à 11 Md€ ; traduction de E-12), atteints en dix ans (hypothèse)"
    leviers := [.depenseEcheancier .enseignement (([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List Int).map fun k => k * 680)] },
  { id := "P-20", titre := "Enseignement supérieur : 20 000 postes en dix ans"
    source := s!"{site}, chap. 11 : « créer 20 000 postes sur dix ans » ; non chiffré : 2 000 postes par an à {coutEnseignantEuros} € (hypothèse, voir `coutEnseignantEuros`), {postesSuperieur.getLastD 0} M€ par an la dixième année"
    leviers := [.creationPostes .enseignement (([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List Int).map fun k => 2000 * k)
                  coutEnseignantEuros, .annonceEmplois 20000] },
  { id := "P-21", titre := "Service public de la petite enfance : 200 000 solutions d'accueil de plus"
    source := s!"{site}, chap. 10 : combler « le déficit de 200 000 solutions d'accueil » de 3 mois à 3 ans ; non chiffré : {investissementAccueil} M€ par an de construction pendant cinq ans, fonctionnement jusqu'à {fonctionnementAccueil.getLastD 0} M€ par an (voir `placesAccueil`)"
    leviers := [.investissementEcheancier .famille [investissementAccueil, investissementAccueil, investissementAccueil,
                                                    investissementAccueil, investissementAccueil, 0],
                .depenseEcheancier .famille fonctionnementAccueil] },
  { id := "P-22", titre := "Aide publique au développement portée à 0,7 % du RNB"
    source := s!"{site}, chap. 20 : « augmenter le niveau de l'APD pour atteindre 0,7 % du RNB » ; non chiffré : de 0,42 % à 0,7 %, +{hausseApd} M€ par an atteints en cinq ans ; versements à l'étranger, sans effet sur la demande intérieure (recette non fiscale négative, comme O-114) (voir `hausseApd`)"
    leviers := [.recetteEcheancier none (apdEcheancier.map (fun x => -x))] },
  { id := "P-23", titre := "Réforme des niches fiscales « jugées inefficaces »"
    source := s!"{partie "refaire-societe"}, chap. 16 (sans montant) ; {contreBudget} : +4 Md€ (Renseignement Économique, Selectra) ; imputé aux autres impôts"
    leviers := [.prelevement 4000] },
  { id := "P-24", titre := "Avantage en nature des voitures de fonction thermiques corrigé"
    source := s!"{partie "vivre-libres"}, chap. 2 : « avantage en nature sous-taxé », « subvention implicite d'environ 4 milliards d'euros par an aux véhicules fossiles » ; correction totale (hypothèse) ; partage entre cotisations et impôt sur le revenu non publié : imputé aux autres impôts ; recouvrement possible avec P-23"
    leviers := [.prelevement 4000] },
  { id := "P-25", titre := "Salaires des enseignants au niveau de la moyenne de l'OCDE"
    source := s!"{partie "sepanouir-a-egalite"}, chap. 11 : salaires « 16 % en dessous de la moyenne OCDE » ; non chiffré : rattrapage de +19 % (16/84) de 59,23 Md€ (PLF 2026) en cinq ans, majorant (l'écart porte sur les enseignants expérimentés, la masse comprend des cotisations patronales) (voir `rattrapageEnseignants`)"
    leviers := [.remunerationPublique .traitement .enseignement rattrapageEnseignants] },
  { id := "P-26", titre := "AAH au niveau du seuil de pauvreté"
    source := s!"{partie "sepanouir-a-egalite"}, chap. 12 ; non chiffré : 12,7 Md€ × (1 337 − 1 041,59) / 1 041,59 = {hausseAAH} M€ par an (DREES, Insee ; voir `hausseAAH` ; dépense de 2023, AAH de 2026 : sous-estimation d'≈ 7 %)"
    leviers := [.depenseSur .famille hausseAAH] },
  { id := "P-27", titre := "Recherche publique portée à 1 % du PIB d'ici 2030"
    source := s!"{partie "vivre-libres"}, chap. 5 ; non chiffré : 0,74 % du PIB en 2023 (SIES), écart de {ecartRecherche} M€ atteint en 2030, net des postes de P-20 : {rechercheNette} M€ (voir `rechercheNette`)"
    leviers := [.depenseEcheancier .enseignement rechercheNette] },
  { id := "P-28", titre := "Prévention doublée dans les dépenses de santé"
    source := s!"{partie "etre-en-securites"}, chap. 6 : de 4 à 8 % des dépenses de santé ; lu comme un doublement des 8,73 Md€ de prévention de 2024 (DREES), atteint en cinq ans (hypothèse ; +13,3 ou +17,9 Md€ selon d'autres lectures)"
    leviers := [.depenseEcheancier .sante preventionEcheancier] },
  { id := "P-29", titre := "Reconversion d'un million d'actifs en dix ans, à 100 % du salaire pendant un an"
    source := s!"{partie "vivre-libres"}, chap. 3 ; non chiffré : {reconversionsParAn} reconversions par an à {coutReconversionEuros} € (France compétences, projets de transition professionnelle), {coutReconversion} M€ par an (calcul ; 17 762 dossiers existaient en 2023, non déduits)"
    leviers := [.depenseSur .affairesEconomiques coutReconversion] },
  { id := "P-30", titre := "Sport porté à 1 % du budget de l'État"
    source := s!"{partie "refaire-societe"}, chap. 16 ; non chiffré : 1 % de 452,7 Md€ (budget général 2026, Sénat) moins ≈ 0,55 Md€ du programme « Sport », {hausseSport} M€ par an (périmètre : hypothèse) ; la culture à 2 % du budget n'est pas modélisée (de 0 à +4,6 Md€ selon le périmètre)"
    leviers := [.depenseSur .culture hausseSport] },
  { id := "P-31", titre := "Asile : 30 000 places d'hébergement, 10 000 visas humanitaires par an, 20 000 réinstallations"
    source := s!"{partie "refaire-societe"}, chap. 17 et {partie "pacifier-le-monde"}, chap. 19 ; non chiffré : 21 € par jour et par place (Sénat, coût cible 2023), {coutPlacesAsile} M€ pour les places et {coutAccueil} M€ pour un an d'accueil des {accueillisParAn} personnes de plus par an (calcul, majorant : places existantes non déduites) ; solde migratoire +{accueillisParAn} par an, réinstallations poursuivies au même rythme après cinq ans (hypothèse)"
    leviers := [.depenseSur .famille (coutPlacesAsile + coutAccueil), .migration soldeAccueilMilliers] }
]

def programme : Programme where
  id := "PS"
  nom := "Parti socialiste — Le Projet socialiste (2026)"
  description := "Transcription partielle et non officielle du Projet socialiste porté par Chloé Ridel (environ 800 points), gardé par choix du dépôt quel que soit le candidat, et du contre-budget 2027 des députés socialistes (16 septembre 2026 : CSG progressive, taxe numérique, santé, climat, école, exonérations, fraude et économies). Ajouts du 28 octobre 2026 : taxe Zucman, dividendes, leasing social, classes à 19 élèves, 20 000 postes dans le supérieur, petite enfance, aide au développement à 0,7 % du RNB. Ajouts du 30 octobre 2026 : niches fiscales, voitures de fonction, salaires des enseignants au niveau de l'OCDE, AAH au seuil de pauvreté, recherche publique à 1 % du PIB, prévention, reconversion, sport, asile ; exonérations de 2 à 3,5 SMIC traduites en allègements."
  mainteneurs := ["@TOrientationD"]
  source := "https://projet-socialiste.fr/ (consulté le 21 et le 30 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.PS
