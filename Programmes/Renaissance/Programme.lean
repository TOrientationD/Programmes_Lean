import Modele
import Hypotheses
import Proprietes

/-!
# Renaissance — Gabriel Attal 2027

Transcription **partielle et non officielle** des propositions de Gabriel
Attal (attalpresident.fr, 75 mesures ; interviews d'avril à octobre 2026),
d'après la presse (RMC, 6 octobre 2026 ; Le Parisien, 23 mai 2026 ;
CNews, 30 avril 2026), consultée le 22 octobre 2026. Le programme ne
publie pas de chiffrage d'ensemble : une seule proposition a un montant.

Règle de transcription : seules les propositions avec un montant annuel ou
un paramètre que le modèle représente deviennent des leviers. Aucun
engagement n'est déclaré.
-/

namespace Programmes.Renaissance
open Modele

/-- 350 députés au lieu de 577, 200 sénateurs au lieu de 348
(attalpresident.fr, via Votons 2027). Dotations de l'État pour 2026 :
607,65 M€ pour l'Assemblée nationale, 353,47 M€ pour le Sénat (Sénat,
rapport sur la mission « Pouvoirs publics », PLF 2026), réduites en
proportion du nombre d'élus (hypothèse : majorant, une partie des coûts
étant fixe). Calendrier (hypothèse) : Assemblée élue en 2027, Sénat réduit
de moitié aux renouvellements de 2029 et de 2032. -/
def economieAssemblee : Int := 607648 * (577 - 350) / 577 / 1000
def economieSenat : Int := 353471 * (348 - 200) / 348 / 1000
def economieParlement : List Int :=
  [-economieAssemblee, -economieAssemblee, -(economieAssemblee + economieSenat / 2),
   -(economieAssemblee + economieSenat / 2), -(economieAssemblee + economieSenat / 2),
   -(economieAssemblee + economieSenat)]

theorem parlement_valeurs : economieAssemblee = 239 ∧ economieSenat = 150 ∧
    economieParlement = [-239, -239, -314, -314, -314, -389] := by decide

/-- Un mois d'engagement civique obligatoire avant 25 ans
(attalpresident.fr, 11 octobre 2026 ; LyonMag, 10 octobre 2026), sans coût
publié. Méthode de PP-06 ramenée à un mois : génération de 822 914 jeunes
moins les 72 000 missions de service civique déjà financées, × 605 €
(indemnité de 505 € et tutorat de 100 €, Maire-info), montée en charge en
cinq ans (hypothèse). -/
def coutEngagement : Int := (822914 - 72000) * 605 / 1000000
def engagementEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * coutEngagement / 5

theorem engagement_valeurs : coutEngagement = 454 ∧
    engagementEcheancier = [90, 181, 272, 363, 454] := by decide

def mesures : List Mesure := [
  { id := "RE-01", titre := "« Droit au brut » : baisse des cotisations salariales, jusqu'à 250 € net par mois au salaire médian"
    source := "G. Attal, RMC, 6 octobre 2026 : coût estimé 40 Md€/an, financement non précisé ; imputé aux cotisations sociales"
    leviers := [.prelevementSur .cotisations (-40000)] },
  { id := "RE-02", titre := "Réforme de l'assurance chômage « qui incite au travail »"
    source := "attalpresident.fr/programme (via Votons 2027) : « 100 000 emplois supplémentaires » ; sans montant : seul l'objectif d'emplois est enregistré"
    leviers := [.annonceEmplois 100000] },
  { id := "RE-03", titre := "Année blanche sur les prestations sociales en 2028, petites retraites épargnées"
    source := "G. Attal, Le Parisien, 2 juillet 2026 (via MoneyVox) ; conversion : non-indexation d'un an de ≈ 700 Md€ de prestations hors petites retraites, inflation 1,5 % → ≈ 10 Md€/an d'économie permanente, répartie 6 Md€ retraites et 4 Md€ autres prestations (hypothèses) ; entrée en vigueur la troisième année (2028)"
    leviers := [.economieSur .retraites 6000, .economieSur .famille 4000]
    debut := 1 },
  { id := "RE-04", titre := "100 000 postes de fonctionnaires supprimés par départs volontaires et non-remplacements"
    source := "G. Attal, Le Parisien, 2 juillet 2026 (via MoneyVox) : Éducation, Armées, Justice et Intérieur préservés ; conversion : 62 500 € par poste → 6,25 Md€/an en régime de croisière ; 20 000 postes par an pendant le quinquennat, emplois publics retirés un pour un (levier `suppressionPostes`)"
    leviers := [.suppressionPostes .fonctionnement 20000 62500]
    repetitions := 5 },
  { id := "RE-05", titre := "Taxe sur les rachats d'actions"
    source := "Programme de juin 2024 repris en 2026 (Europe 1, Ifrap) : ≈ 300 M€/an"
    leviers := [.prelevementSur .impotSocietes 300] },
  { id := "RE-06", titre := "« Frein d'urgence » sur les dépenses sociales"
    source := "Comparateur IFRAP 2027 ; meeting de Lyon, 10 octobre 2026 : 20 Md€ (chiffrage du parti), dont l'année blanche de RE-03 (≈ 10 Md€) : reste ≈ 10 Md€, réparti comme elle (6 Md€ retraites, 4 Md€ autres prestations, hypothèse)"
    leviers := [.economieSur .retraites 6000, .economieSur .famille 4000] },
  { id := "RE-07", titre := "Impôt des classes moyennes, pensions alimentaires non imposables pour le parent qui les reçoit"
    source := "Comparateur IFRAP 2027 : 2 Md€ ; université d'été de la monoparentalité, 28 août 2026 (LCP) : « autour d'un milliard » (chiffrages du parti)"
    leviers := [.prelevementSur .ir (-3000)] },
  { id := "RE-08", titre := "1 000 € sur un plan d'épargne retraite à chaque naissance"
    source := "Amendement au PLF 2026 (Le Parisien, via Econostrum), repris au programme : 660 000 naissances × 1 000 € ≈ 0,66 Md€ par an"
    leviers := [.depenseSur .famille 660] },
  { id := "RE-09", titre := "350 députés et 200 sénateurs"
    source := s!"attalpresident.fr/programme (via Votons 2027) : « ramener le nombre de députés à 350 et celui des sénateurs à 200 » ; non chiffré : jusqu'à {economieAssemblee + economieSenat} M€ par an (voir `economieAssemblee`)"
    leviers := [.depenseEcheancier .fonctionnement economieParlement] },
  { id := "RE-10", titre := "Enseignants : +200 € net par mois pour tous, jusqu'à +500 € en milieu de carrière"
    source := "G. Attal, Le Monde, 25 août 2026 (AFP, via La Gazette France) : revalorisation « immédiate », 2,5 Md€ par an « selon son entourage », lus comme un montant brut (hypothèse) ; contrôle : 852 752 enseignants × 200 € × 12 ≈ 2,05 Md€ net pour le seul socle (calcul), ≈ 2,6 Md€ brut : le chiffrage est une borne basse"
    leviers := [.remunerationPublique .traitement .enseignement [2500]] },
  { id := "RE-11", titre := "Un mois d'engagement civique obligatoire avant 25 ans"
    source := s!"attalpresident.fr, 11 octobre 2026 ; non chiffré : méthode de PP-06 sur un mois, {coutEngagement} M€ par an atteints en cinq ans (voir `coutEngagement`)"
    leviers := [.depenseEcheancier .culture engagementEcheancier] }
]

def programme : Programme where
  id := "Renaissance"
  nom := "Renaissance — Gabriel Attal 2027"
  description := "Transcription partielle et non officielle : « droit au brut » (−40 Md€ de cotisations), année blanche 2028 sur les prestations, 100 000 postes de fonctionnaires, taxe sur les rachats d'actions, objectif de 100 000 emplois par la réforme du chômage, « frein d'urgence » sur les dépenses sociales, impôt des classes moyennes, 1 000 € d'épargne retraite par naissance. Ajout du 28 octobre 2026 : 350 députés et 200 sénateurs. Ajouts du 30 octobre 2026 : enseignants, un mois d'engagement civique. Retraite universelle par points, quotas d'immigration : sans montant publié. Objectif annoncé : 120 à 150 Md€ d'économies et déficit sous 3 % avant 2032."
  mainteneurs := ["@TOrientationD"]
  source := "attalpresident.fr/programme et presse (RMC 6 octobre 2026, Le Parisien 23 mai 2026, CNews 30 avril 2026), consultés le 22 octobre 2026"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.Renaissance
