import Modele
import Hypotheses
import Proprietes

/-!
# Nouvelle Énergie — David Lisnard (octobre 2026)

Transcription **partielle et non officielle** des propositions de David
Lisnard, maire de Cannes, candidat à l'élection présidentielle de 2027
(Nouvelle Énergie), d'après le site du parti (pages « Questions » mises à
jour le 16 octobre 2026, pages « Notre programme »), le discours de
Saint-Raphaël (3 juillet 2026, texte écrit), le discours de La Gagne
(29 août 2026) et l'émission « Objectif Élysée 2027 » (CNEWS et Europe 1,
27 octobre 2026), consultés le 30 octobre 2026.

Le parti chiffre une enveloppe globale : 80 Md€ d'économies dès la
première année, 200 Md€ « à l'horizon 2032 », répartis à 60 % en salaire
net, 20 % en impôts de production et 20 % en désendettement. Il ne ventile
pas les économies par poste, et aucune expertise indépendante n'a validé
ces montants (L'Essentiel de l'éco, 21 octobre 2026). Le modèle retient le
chiffrage du parti : les économies identifiées (postes, prestations, AME)
sont des leviers propres, le reste de l'enveloppe est une économie non
ventilée (NE-01).

Règle de transcription : seules les propositions avec un montant annuel
ou un paramètre que le modèle représente deviennent des leviers ; les
conversions sont écrites dans `source`. Aucun engagement n'est déclaré.
-/

namespace Programmes.NouvelleEnergie
open Modele

def site : String := "unenouvelleenergie.fr"
def emission27oct : String :=
  "D. Lisnard, « Objectif Élysée 2027 », CNEWS et Europe 1, 27 octobre 2026 (unenouvelleenergie.fr, 28 octobre 2026)"

/-- Enveloppe d'économies, M€ par an de 2027 à 2032 : 80 Md€ la première
année (Europe 1, 27 mai 2026 ; discours de Saint-Raphaël, 3 juillet 2026),
200 Md€ « à l'horizon 2032 » (CNEWS et Europe 1, 27 octobre 2026 ;
« a minima 200 milliards par an à la fin du quinquennat » dans le texte de
Saint-Raphaël). Aucune trajectoire intermédiaire n'est publiée : montée
linéaire en euros courants (hypothèse). Les échéanciers du modèle sont en
euros de l'année d'entrée en vigueur, puis indexés : chaque niveau est
ramené en euros 2027 au taux de croissance nominale du scénario central
(3 % par an, convention d'O-59 au Texte Orientation D ; calcul), pour que
l'enveloppe atteigne ≈ 200 Md€ courants en 2032. Contrôle : 7 points de
PIB, objectif affiché de dépense publique, font ≈ 209 Md€ sur un PIB de
≈ 2 991 Md€ (3 460,5 Md€ de dette pour 115,7 % du PIB, L'Essentiel de
l'éco, 21 octobre 2026 ; calcul). -/
def economiesPremiereAnnee : Int := 80000
def economiesCible : Int := 200000
def anneesMontee : Int := 5
def croissanceNominalePm : Int := 30
/-- Indice des prix et volumes du scénario central, base 10 000 en 2027. -/
def deflateur (k : Nat) : Int := 10000 * (1000 + croissanceNominalePm) ^ k / 1000 ^ k
def enveloppeCourante : List Int :=
  ([0, 1, 2, 3, 4, 5] : List Int).map fun k =>
    economiesPremiereAnnee + k * (economiesCible - economiesPremiereAnnee) / anneesMontee
def enveloppe : List Int :=
  (enveloppeCourante.zip [0, 1, 2, 3, 4, 5]).map fun (e, k) => e * 10000 / deflateur k

/-- Clé de répartition des économies (page « Que ferait David Lisnard des
200 milliards d'économies ? », 16 octobre 2026, appliquée aussi aux 80 Md€
de la première année) : 60 % au salaire net, 20 % aux impôts de
production, 20 % à la dette (sans levier : c'est la part non redistribuée).
La page du parti sur les fonctionnaires et L'Essentiel de l'éco donnent
« 20 % pour la modernisation de l'État » à la place de la dette (variante
de NE-01). -/
def partSalaireNetPm : Int := 600
def partProductionPm : Int := 200
def partModernisationPm : Int := 200
def part (pm : Int) : List Int := enveloppe.map fun e => e * pm / 1000

/-- Postes publics (NE-02) : « plus de 400 000 suppressions » et 200 000 à
300 000 redéploiements (27 octobre 2026) ; 80 000 par an sur cinq ans
(hypothèse) ; 62 500 € par poste et par an, ratio du plan Retailleau
(25 Md€ pour 400 000 postes) déjà retenu pour LR-01 et H-02. Les
redéploiements sont neutres et ne sont pas modélisés. -/
def postesParAn : Int := 80000
def coutPosteEuros : Int := 62500
def economiesPostes : List Int :=
  ([1, 2, 3, 4, 5, 5] : List Int).map fun k => k * postesParAn * coutPosteEuros / 1000000

/-- Prestations non contributives réservées aux étrangers résidant depuis
cinq ans (NE-03) : 8 Md€ par an (discours de La Gagne, 29 août 2026, page
« Le programme de David Lisnard est-il chiffré ? ») ; 2 à 3 Md€ dès la
première année (27 octobre 2026), milieu retenu ; montée linéaire
(hypothèse). -/
def prestationsPremiereAnnee : Int := 2500
def prestationsCible : Int := 8000
def economiesPrestations : List Int :=
  ([0, 1, 2, 3, 4, 5] : List Int).map fun k =>
    prestationsPremiereAnnee + k * (prestationsCible - prestationsPremiereAnnee) / anneesMontee

/-- AME remplacée par une aide médicale d'urgence (NE-04) : 700 M€
d'économies (page « Immigration » du parti). -/
def economieAme : Int := 700

/-- Économies non ventilées (NE-01) : l'enveloppe moins NE-02, NE-03 et
NE-04 (calcul), en négatif (économie). -/
def residuNonVentile : List Int :=
  ((enveloppe.zip economiesPostes).zip economiesPrestations).map fun ((e, p), s) =>
    0 - (e - p - s - economieAme)

/-- 20 000 places de prison (NE-07) : « Nous construirons enfin les 20 000
places de prison manquantes » (texte de Saint-Raphaël ; Le Crayon,
15 octobre 2026). Places en plus du plan 15 000 (hypothèse). Paramètres
du Texte Orientation D (O-75) : 270 k€ par place nette (Cour des comptes,
17 décembre 2025), 44 984 € par place ouverte et par an (0,48 surveillant
par place à 80 800 €, plus 6 200 € d'entretien et d'énergie) ;
construction de 2028 à 2032, 4 000 places ouvertes par an de 2029 à 2033
(hypothèse : le quinquennat). Variante : contre-chiffrage de l'Institut
Montaigne pour la même mesure de LR en 2022, 236 k€ par place. Emprise :
17 ha pour 700 places (centre de Saint-Saulve, ministère de la Justice,
23 juin 2023). -/
def placesPrison : Int := 20000
def coutPlaceKEuros : Int := 270
def coutPlaceMontaigneKEuros : Int := 236
def coutAnnuelPlaceEuros : Int := 480 * 80800 / 1000 + 6200
def anneesConstruction : Nat := 5
def constructionPrisons (coutKEuros : Int) : List Int :=
  0 :: List.replicate anneesConstruction (placesPrison * coutKEuros / 1000 / anneesConstruction) ++ [0]
def fonctionnementPrisons : List Int :=
  ([0, 0, 1, 2, 3, 4, 5] : List Int).map fun k =>
    k * (placesPrison / anneesConstruction) * coutAnnuelPlaceEuros / 1000000
/-- Le premier niveau d'`artificialisation` vaut pour l'année suivant
l'entrée en vigueur (2028), comme la construction. -/
def surfacesPrisons : List Int :=
  List.replicate anneesConstruction (placesPrison * 17 / 700 / anneesConstruction)

/-- Enseignants : rémunération +20 % en cinq ans, sous conditions (page
« Éducation » du parti) ; même paramètre que H-09 : 20 % de 59,23 Md€ de
masse salariale hors CAS Pensions (PLF 2026, rapport du Sénat sur la
mission Enseignement scolaire), en cinq hausses égales (calcul). -/
def hausseEnseignants : Int := 59230 * 20 / 100
def enseignantsEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * hausseEnseignants / 5

/-- Immigration (NE-09) : 80 000 entrées légales par an, visas étudiants
compris (27 octobre 2026), pour un point de départ de 500 000 retenu par
le candidat (Saint-Raphaël), soit une division par 6,25 ; la page
« Immigration » dit « diviser par huit » les titres (176 × 7/8 = 154,
non retenu). Conversion : solde migratoire de 2025 (176 000, INSEE) réduit
dans la même proportion (hypothèse et majorant : les titres ne sont pas le
solde, méthode de H-05). -/
def soldeMigratoire2025Milliers : Int := 176
def entreesCible : Int := 80
def entreesDepart : Int := 500
def baisseSoldeMilliers : Int := soldeMigratoire2025Milliers * (entreesDepart - entreesCible) / entreesDepart

theorem valeurs :
    enveloppeCourante = [80000, 104000, 128000, 152000, 176000, 200000] ∧
    deflateur 5 = 11592 ∧
    enveloppe = [80000, 100970, 120652, 139104, 156374, 172532] ∧
    part partSalaireNetPm = [48000, 60582, 72391, 83462, 93824, 103519] ∧
    part partProductionPm = [16000, 20194, 24130, 27820, 31274, 34506] ∧
    economiesPostes = [5000, 10000, 15000, 20000, 25000, 25000] ∧
    economiesPrestations = [2500, 3600, 4700, 5800, 6900, 8000] ∧
    residuNonVentile = [-71800, -86670, -100252, -112604, -123774, -138832] ∧
    coutAnnuelPlaceEuros = 44984 ∧
    constructionPrisons coutPlaceKEuros = [0, 1080, 1080, 1080, 1080, 1080, 0] ∧
    fonctionnementPrisons = [0, 0, 179, 359, 539, 719, 899] ∧
    surfacesPrisons = [97, 97, 97, 97, 97] ∧
    enseignantsEcheancier = [2369, 4738, 7107, 9476, 11846] ∧
    baisseSoldeMilliers = 147 := by decide

def mesures : List Mesure := [
  { id := "NE-01", titre := "Économies non ventilées : opérateurs et agences, dépense sociale, assurance chômage, budgets en base zéro, ministères supprimés"
    source := s!"{site}, « Que ferait David Lisnard des 200 milliards d'économies ? » (16 octobre 2026) et {emission27oct} : 80 Md€ la première année, 200 Md€ courants en 2032, montée linéaire (hypothèse) ramenée en euros 2027 (voir `enveloppe`) ; le parti ne ventile pas les économies (pistes sans montant : 1 153 opérateurs, ARS, DREAL, DDTM, allocation sociale unique plafonnée, désindexation des pensions au-dessus de 2 200 €) ; enveloppe moins NE-02, NE-03 et NE-04, soit {residuNonVentile} M€ (voir `residuNonVentile`) ; aucune expertise indépendante (L'Essentiel de l'éco, 21 octobre 2026)"
    leviers := [.depenseEcheancier .nonVentile residuNonVentile]
    variantes := [
      { nom := "20 % des économies à la modernisation de l'État au lieu de la dette", leviers :=
          [.depenseEcheancier .nonVentile residuNonVentile,
           .depenseEcheancier .fonctionnement (part partModernisationPm)] }] },
  { id := "NE-02", titre := "Plus de 400 000 postes publics supprimés, 200 000 à 300 000 redéployés"
    source := s!"{emission27oct} : environ 12 % des effectifs, plan détaillé annoncé pour décembre 2026 ; conversion : {postesParAn} postes par an pendant cinq ans (hypothèse), {coutPosteEuros} € par poste et par an (ratio de LR-01 et H-02) ; redéploiements non modélisés"
    leviers := [.suppressionPostes .fonctionnement postesParAn coutPosteEuros]
    repetitions := 5 },
  { id := "NE-03", titre := "Prestations non contributives réservées aux étrangers résidant depuis cinq ans"
    source := s!"Discours de La Gagne, 29 août 2026 ({site}, « Le programme est-il chiffré ? ») : 8 Md€ par an ; {emission27oct} : 2 à 3 Md€ la première année ; montée linéaire (hypothèse)"
    leviers := [.depenseEcheancier .famille (economiesPrestations.map fun x => 0 - x)] },
  { id := "NE-04", titre := "Aide médicale d'État remplacée par une aide médicale d'urgence"
    source := s!"{site}, « Immigration » : {economieAme} M€ d'économies (chiffrage du parti ; coût de l'AME « près d'1,4 milliard » selon le discours de Saint-Raphaël)"
    leviers := [.economieSur .sante economieAme] },
  { id := "NE-05", titre := "Salaire net relevé par la baisse des prélèvements salariaux, dont CSG d'activité de 9,2 % à 6,6 %"
    source := s!"{site}, « Pouvoir d'achat » et « Impôts » : 60 % des économies, 120 Md€ courants en 2032, « sans augmenter le coût du travail », la même clé dès la première année (calcul, euros 2027 : {part partSalaireNetPm} M€) ; CSG à 6,6 % : {emission27oct} ; imputé aux cotisations sociales (la part de la CSG assise sur les revenus d'activité n'est pas sourcée)"
    leviers := [.recetteEcheancier (some .cotisations) ((part partSalaireNetPm).map fun x => 0 - x)] },
  { id := "NE-06", titre := "Baisse des impôts de production, à commencer par la C3S"
    source := s!"{site}, entretien du 21 janvier 2026 : 20 % des économies, 40 Md€ courants en 2032 (calcul, euros 2027 : {part partProductionPm} M€) ; C3S ≈ 5,4 Md€ (Legifiscal, 12 décembre 2025) ; même imputation que RN-02 et H-07 ; la CVAE, déjà supprimée par la loi en 2030, n'est pas visée"
    leviers := [.recetteEcheancier (some .autres) ((part partProductionPm).map fun x => 0 - x)] },
  { id := "NE-07", titre := "20 000 places de prison"
    source := s!"Discours de Saint-Raphaël, 3 juillet 2026 ; Le Crayon, 15 octobre 2026 ; non chiffré : {placesPrison} places en plus du plan 15 000 (hypothèse) à {coutPlaceKEuros} k€ la place (Cour des comptes, paramètre d'O-75), construites de 2028 à 2032, puis {coutAnnuelPlaceEuros} € par place ouverte et par an ; emprise : 17 ha pour 700 places"
    leviers := [.investissementEcheancier .securiteJustice (constructionPrisons coutPlaceKEuros),
                .depenseEcheancier .securiteJustice fonctionnementPrisons,
                .artificialisation .autres surfacesPrisons]
    variantes := [
      { nom := "coût de l'Institut Montaigne (236 k€ la place)", leviers :=
          [.investissementEcheancier .securiteJustice (constructionPrisons coutPlaceMontaigneKEuros),
           .depenseEcheancier .securiteJustice fonctionnementPrisons,
           .artificialisation .autres surfacesPrisons] }] },
  { id := "NE-08", titre := "Enseignants : rémunération relevée de 20 % en cinq ans"
    source := s!"{site}, « Éducation » : +20 % sous conditions ; non chiffré : 20 % de 59,23 Md€, {hausseEnseignants} M€ par an atteints en cinq ans (paramètre de H-09)"
    leviers := [.remunerationPublique .traitement .enseignement enseignantsEcheancier] },
  { id := "NE-09", titre := "Immigration légale ramenée à 80 000 entrées par an"
    source := s!"{emission27oct} : 80 000 entrées par an, visas étudiants compris, pour 500 000 aujourd'hui selon le candidat (la page « Immigration » dit « diviser par huit ») ; conversion : solde migratoire réduit de {baisseSoldeMilliers} 000 par an (176 000 × 420/500, hypothèse et majorant)"
    leviers := [.migration (0 - baisseSoldeMilliers)] },
  { id := "NE-10", titre := "Droits de succession supprimés"
    source := "Discours de La Gagne, 29 août 2026 : « totalement libérer l'héritage » ; transmission d'entreprise « totalement libérée » (Benfeld, 25 septembre 2026) ; 16,2 Md€ de droits de succession (Legifiscal, 23 septembre 2026, montant de RQ-12). Le livre « Ainsi va la France » propose un barème allégé (taux marginal de 20 %), non chiffré"
    leviers := [.prelevementSur .droitsMutation (-16200)] },
  { id := "NE-11", titre := "Quotient familial déplafonné"
    source := "Page programme « Réussir une nouvelle ambition française » ; non chiffré par le parti : relever le plafond de 1 845 € à 2 500 € par demi-part coûterait 2,1 Md€ (Conseil des prélèvements obligatoires, octobre 2024, cité par l'amendement I-CF1675 au PLF 2027) ; minorant d'un déplafonnement total (hypothèse)"
    leviers := [.prelevementSur .ir (-2100)] },
  { id := "NE-12", titre := "Âge légal à 65 ans"
    source := s!"Page programme non datée : « la norme de l'âge légal de 65 ans est un impératif national urgent » ; non redit avec un chiffre en 2026 (pages du 16 octobre, {emission27oct}) : pour mémoire, sans levier ; variante au rythme de H-01 (+3 mois par an), dont les économies recouvrent en partie l'enveloppe NE-01"
    leviers := []
    variantes := [{ nom := "65 ans, +3 mois par an", leviers := [.ageLegalCible 780 3] }] }
]

def programme : Programme where
  id := "NouvelleEnergie"
  nom := "Nouvelle Énergie — David Lisnard 2027"
  description := "Transcription partielle et non officielle des propositions d'octobre 2026 : 80 Md€ d'économies la première année et 200 Md€ en 2032, répartis à 60 % en salaire net (baisse des prélèvements salariaux, dont CSG), 20 % en impôts de production et 20 % en désendettement ; plus de 400 000 postes publics supprimés ; prestations non contributives après cinq ans de résidence ; AME remplacée ; 20 000 places de prison ; enseignants +20 % ; 80 000 entrées légales par an ; droits de succession supprimés ; quotient familial déplafonné. Les économies non ventilées par le parti sont une enveloppe non ventilée. Capitalisation, allocation sociale unique et désindexation n'ont pas de montant publié."
  mainteneurs := ["@TOrientationD"]
  source := "unenouvelleenergie.fr (pages « Questions » du 16 octobre 2026, « Notre programme ») ; discours de Saint-Raphaël (3 juillet 2026) et de La Gagne (29 août 2026) ; CNEWS et Europe 1, 27 octobre 2026 ; consultés le 30 octobre 2026"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.NouvelleEnergie
