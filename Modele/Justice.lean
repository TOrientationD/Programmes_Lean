import Modele.Unites

/-!
# Justice : capacité de jugement, stocks et délais

Un contentieux est décrit par son flux annuel d'affaires nouvelles, son stock
d'affaires en cours et sa capacité actuelle, mesurée par les affaires
terminées dans l'année. Une mesure agit sur la capacité de deux façons :

* le **facteur de traitement** multiplie la capacité des effectifs en place
  (‰ : 1000 = inchangée), par exemple quand l'équipe autour du magistrat ou
  la numérisation accélèrent le travail ;
* les **renforts** ajoutent des unités de jugement (une équipe de greffe, un
  magistrat et son équipe, une formation de jugement), chacune traitant un
  nombre donné d'affaires par an.

Chaque année, les affaires terminées sont la plus petite des deux quantités
« stock + affaires nouvelles » et « capacité » ; le stock de fin d'année est
ce qui reste. La durée moyenne de traitement est approchée par le délai
théorique d'écoulement du stock (indicateur des projets annuels de
performances de la mission Justice ; « disposition time » de la CEPEJ) :
12 × stock / affaires terminées, en mois. C'est la loi de Little en régime
stationnaire (durée moyenne de séjour = stock / débit) ; hors régime
stationnaire, elle mesure le temps qu'il faudrait pour juger le stock au
rythme de l'année.

Le coût suit le personnel et les bâtiments : les postes créés sont des
emplois publics au coût moyen d'un ETPT ; chaque poste nouveau demande des
locaux (investissement l'année de la création) et coûte chaque année son
fonctionnement immobilier.
-/

namespace Modele.Justice

/-- Un contentieux : affaires nouvelles par an (supposées constantes), stock
au début de la projection et affaires terminées par an avec les moyens
actuels. -/
structure Contentieux where
  nouvellesParAn : Int
  stockDebut : Int
  termineesParAn : Int
  deriving Repr

/-- Capacité de chaque année, sur `annees` années : capacité actuelle ×
facteur de traitement (‰), plus les unités de renfort × affaires par unité.
Les deux listes commencent la même année ; chacune est prolongée par son
dernier niveau. -/
def capacites (c : Contentieux) (annees : Nat) (facteursPm renforts : List Int) (affairesParUnite : Int) :
    List Int :=
  let n := annees
  let prolonger (l : List Int) (d : Int) := l ++ List.replicate (n - l.length) (l.getLast?.getD d)
  List.zipWith (fun f r => c.termineesParAn * f / 1000 + r * affairesParUnite)
    ((prolonger facteursPm 1000).take n) ((prolonger renforts 0).take n)

/-- Trajectoire (stock de fin d'année, affaires terminées), année par année. -/
def trajectoire (nouvelles : Int) : Int → List Int → List (Int × Int)
  | _, [] => []
  | stock, cap :: reste =>
      let terminees := min (stock + nouvelles) (max cap 0)
      let stockFin := stock + nouvelles - terminees
      (stockFin, terminees) :: trajectoire nouvelles stockFin reste

/-- Délai théorique d'écoulement du stock, dixièmes de mois. -/
def delaiDixiemesMois (stock terminees : Int) : Int :=
  if terminees ≤ 0 then 0 else stock * 120 / terminees

/-- Délais d'écoulement de chaque année, dixièmes de mois. -/
def delais (c : Contentieux) (caps : List Int) : List Int :=
  (trajectoire c.nouvellesParAn c.stockDebut caps).map fun p => delaiDixiemesMois p.1 p.2

/-- Délai de départ (dixièmes de mois), avec la capacité actuelle. -/
def Contentieux.delaiDepart (c : Contentieux) : Int :=
  delaiDixiemesMois c.stockDebut c.termineesParAn

/-- Durée moyenne de traitement recalée : la durée moyenne publiée l'année de
départ, multipliée par le rapport entre le délai d'écoulement de l'année et
celui de départ (hypothèse : les deux évoluent dans la même proportion),
dixièmes de mois. -/
def dureesRecalees (c : Contentieux) (dureeDepartDixiemes : Int) (caps : List Int) : List Int :=
  (delais c caps).map fun d =>
    if c.delaiDepart = 0 then 0 else dureeDepartDixiemes * d / c.delaiDepart

/-- Suite strictement décroissante. -/
def strictementDecroissante : List Int → Bool
  | a :: b :: reste => decide (b < a) && strictementDecroissante (b :: reste)
  | _ => true

/-- Une équipe de renfort : composition en ‰ d'ETP (magistrats, greffiers,
autres agents de greffe) et affaires traitées par an (facteur de traitement
de l'équipe). -/
structure Equipe where
  magistratsPm : Int
  greffiersPm : Int
  autresAgentsPm : Int
  affairesParAn : Int
  deriving Repr

/-- ETP d'une équipe, ‰. -/
def Equipe.etpPm (e : Equipe) : Int := e.magistratsPm + e.greffiersPm + e.autresAgentsPm

/-- Postes créés, cumulés année par année, pour un échéancier d'équipes. -/
def postes (e : Equipe) (equipes : List Int) : List Int :=
  equipes.map fun n => n * e.etpPm / 1000

/-- Magistrats créés, cumulés année par année. -/
def magistrats (e : Equipe) (equipes : List Int) : List Int :=
  equipes.map fun n => n * e.magistratsPm / 1000

/-- Investissement immobilier, M€ par an : locaux des postes créés dans
l'année (variation du cumul) au coût d'un poste de travail en juridiction. -/
def investissementLocaux (postesCumules : List Int) (coutPosteEuros : Int) : List Int :=
  (List.zipWith (fun a b => (a - b) * coutPosteEuros / 1000000) postesCumules (0 :: postesCumules)) ++ [0]

/-- Fonctionnement immobilier, M€ par an : postes cumulés × coût annuel par
ETPT. -/
def fonctionnementLocaux (postesCumules : List Int) (coutAnnuelEuros : Int) : List Int :=
  postesCumules.map fun p => p * coutAnnuelEuros / 1000000

end Modele.Justice
