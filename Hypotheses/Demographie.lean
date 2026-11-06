import Modele

/-!
# Axe démographique

Ajouter une hypothèse : définir une valeur ci-dessous **et** l'ajouter à
`toutes`. Elle sera automatiquement croisée avec tous les autres axes.
-/

namespace Hypotheses.Demo
open Modele

/-- Décès attribuables (année de départ) : tabac 68 000 en 2023, 11 % des
décès (Santé publique France, février 2026) ; alcool 41 000 en 2015, dont
16 000 cancers (Santé publique France, BEH 2019 ; pas de mise à jour) ;
cancer colorectal ≈ 17 000 (Barré et al., Revue d'épidémiologie et de santé
publique, 2020) ; arrêt cardiaque extrahospitalier ≈ 43 000 décès (≈ 46 000
arrêts par an, survie ≈ 7 % ; registre RéAC, séminaire ARLoD 2024,
Fédération française de cardiologie), arrondis à 40 000. -/
def decesAttribuables2025 : ParCause :=
  { tabac := 68000, alcool := 41000, cancerColorectal := 17000, arretCardiaque := 40000 }

/-- Années de vie perdues par décès, dixièmes d'année (hypothèses : âge moyen
au décès par cause non publié) : 15 ans pour le tabac et l'alcool, 12 pour
le cancer colorectal. Pollution de l'air : 11 ans, calés sur l'estimation de
Santé publique France (40 000 décès attribuables aux PM2,5, ≈ 8 mois
d'espérance de vie : 0,67 an × 651 000 décès / 40 000). Accidents du
travail mortels : 30 ans (hypothèse). -/
def anneesVieParDecesAnciennes : ParCause :=
  { tabac := 150, alcool := 150, cancerColorectal := 120, arretCardiaque := 100 }

/-- Espérance de vie résiduelle par âge, dixièmes d'année, ensemble des
deux sexes : table de mortalité 2020-2022 de l'Insee (60 ans : 25,1 ;
65 : 21,0 ; 70 : 17,2 ; 75 : 13,5 ; 80 : 10,0 ; années Covid comprises,
≈ 0,5 an de moins que 2024-2025 : 20,0 ans à 65 ans pour les hommes et
23,6 pour les femmes en 2025, Insee). Interpolation linéaire entre 60 et
80 ans. -/
def esperanceResiduelleDixiemes (age : Int) : Int :=
  let table : List (Int × Int) := [(60, 251), (65, 210), (70, 172), (75, 135), (80, 100)]
  let a := max 60 (min 80 age)
  let rec go : List (Int × Int) → Int
    | (a0, e0) :: (a1, e1) :: reste => if a ≤ a1 then e0 + (e1 - e0) * (a - a0) / (a1 - a0) else go ((a1, e1) :: reste)
    | [(_, e)] => e
    | [] => 0
  go table

/-- Âge médian au décès par cause : cancer du poumon 69 ans (hommes) et
68 (femmes), pris pour les décès du tabac (57 % de cancers ; Santé
publique France 2020) ; alcool ≈ 69 ans (calcul d'après Bonaldi et Hill,
BEH 2019 : 483 décès de 15 à 34 ans, 13 164 de 35 à 64, 27 433 à 65 ans et
plus, aux âges moyens de 28, 55 et 76 ans) ; cancer colorectal 74 ans
(médiane au décès tous cancers 73 hommes et 75 femmes, INCa 2024 ; 8 décès
sur 10 à 65 ans et plus, Santé publique France) ; arrêt cardiaque
extrahospitalier 68 ans (registre RéAC, Luc et al. 2019). -/
def ageDecesParCause : ParCause :=
  { tabac := 69, alcool := 69, cancerColorectal := 74, arretCardiaque := 68 }

/-- Années de vie perdues par décès, dixièmes : espérance de vie résiduelle
à l'âge médian au décès de la cause (lien table de mortalité × âge au
décès, qui remplace les anciennes hypothèses de 15, 15, 12 et 10 ans :
borne haute, les décès attribuables touchant des personnes dont la santé
est en moyenne moins bonne). -/
def anneesVieParDeces : ParCause :=
  { tabac := esperanceResiduelleDixiemes ageDecesParCause.tabac
    alcool := esperanceResiduelleDixiemes ageDecesParCause.alcool
    cancerColorectal := esperanceResiduelleDixiemes ageDecesParCause.cancerColorectal
    arretCardiaque := esperanceResiduelleDixiemes ageDecesParCause.arretCardiaque }

theorem anneesVie_eq : anneesVieParDeces = { tabac := 179, alcool := 179, cancerColorectal := 142, arretCardiaque := 187 } := by
  decide

/-- Élasticité de l'espérance de vie à la dépense de santé réelle par
habitant : 0,04 (Gallet et Doucouliagos, méta-régression de 65 études,
Social Science & Medicine 2017, corrigée du biais de publication ; OCDE,
Health at a Glance 2017 : +3,5 mois pour +10 % de dépense, soit ≈ 0,035 ;
fourchette 0,02 à 0,06). Appliquée à l'écart de la dépense de santé à sa
trajectoire tendancielle : une norme de dépense qui freine la santé coûte
de l'espérance de vie, une dépense de santé en plus en rapporte. -/
def elasticiteEsperanceSante : Int := 40

/-- Délai pour que l'effet d'une mesure sur la mortalité soit complet, années
(hypothèses : les cancers dus au tabac répondent en 10 à 30 ans, ceux de
l'alcool plus vite, le dépistage en quelques années ; une formation
scolaire aux premiers secours n'agit qu'à mesure que les générations
formées peuplent les lieux des arrêts cardiaques : 15 ans pour l'effet
complet, hypothèse d'après le Danemark, où le taux de réanimation par un
témoin a doublé en dix ans, de 21 à 45 %, après la formation scolaire
obligatoire de 2005, le secourisme au permis de 2006 et le déploiement des
défibrillateurs : Wissenberg et al., JAMA 2013 ; les victimes ont 71 ans en
moyenne et le témoin est souvent le conjoint, d'où un effet lent). -/
def delaisEffet : ParCause := { tabac := 20, alcool := 10, cancerColorectal := 8, arretCardiaque := 15 }

def centrale : Demographie where
  id := "demo-centrale"
  description := "Mortalité et migrations de 2025 prolongées, population active quasi stable"
  partPlus65Pb := 2350
  decesMilliers := 651
  hausseDecesMilliers := 9
  soldeMigratoireMilliers := 176
  croissanceActifsPb := -23        -- hors migrations : +0,1 %/an au total − 176 000 × 60 % ≈ −73 000/an
  partActiveMigrantsPm := 600
  gainEsperanceVieCentiemes := 12   -- INSEE, projections 2021 : 80,3 → 87,5 ans (hommes), 85,9 → 90,0 (femmes) de 2025 à 2070
  decesAttribuables := decesAttribuables2025
  anneesVieParDecesDixiemes := anneesVieParDeces
  elasticiteEsperanceSantePm := elasticiteEsperanceSante
  delaiEffetMortaliteAns := delaisEffet
  anneesVieParDecesPollutionDixiemes := 110
  anneesVieParDecesAccidentDixiemes := 300
  sources := [
    "Décès 651 000 et solde migratoire +176 000 en 2025 (INSEE, bilan démographique 2025)",
    "Hausse des décès : 651 000 en 2025, 690 752 en 2030, 738 019 en 2035 (INSEE, projections de population à l'horizon 2070, scénario central, Insee Première n° 2108, 8 juin 2026), soit ≈ +9 000 par an",
    "Population active : +0,1 %/an au total, ordre de grandeur de la projection INSEE 2022 hors réforme (30 194 milliers en 2030) ; l'effet de l'âge légal passe par les mesures",
    "Part active des migrants : ≈ 60 % du solde migratoire en âge de travailler et actif (INSEE, immigrés et descendants d'immigrés, 2023 : taux d'activité des immigrés 15-64 ans ≈ 68 %, part des 15-64 ans dans les entrées ≈ 85 %)",
    "Part des 65 ans et plus à l'horizon : hypothèse (22,2 % au 1er janvier 2026)"]

def vieillissementRapide : Demographie where
  id := "demo-vieillissement"
  description := "Vieillissement plus rapide : plus de décès, moins de migrations, population active stable"
  partPlus65Pb := 2450
  decesMilliers := 670
  hausseDecesMilliers := 9
  soldeMigratoireMilliers := 140
  croissanceActifsPb := -26        -- hors migrations : population active stable − 140 000 × 60 %
  partActiveMigrantsPm := 600
  gainEsperanceVieCentiemes := 8    -- hypothèse : gains plus lents
  decesAttribuables := decesAttribuables2025
  anneesVieParDecesDixiemes := anneesVieParDeces
  elasticiteEsperanceSantePm := elasticiteEsperanceSante
  delaiEffetMortaliteAns := delaisEffet
  anneesVieParDecesPollutionDixiemes := 110
  anneesVieParDecesAccidentDixiemes := 300
  sources := ["Part des 65 ans et plus : +1,0 point par rapport au scénario central, comme le scénario « population âgée » des projections INSEE 2021-2070 en 2035 (26,3 % contre 25,3 %, Insee Première n° 1881, figure 5a)",
    "Solde migratoire de 140 000 : entre le central et la variante basse des projections INSEE de 2026 (150 000 et 70 000 par an, Insee Première n° 2108) ; décès et gains d'espérance de vie : hypothèses",
    "Hausse des décès du scénario central de l'INSEE (2026)"]

def toutes : List Demographie := [centrale, vieillissementRapide]

end Hypotheses.Demo
