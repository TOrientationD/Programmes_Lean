import Modele.Programme

/-!
# Cohérence interne d'un programme

Un programme peut contenir deux mesures qui se contredisent : l'une passe
la durée du travail à 39 heures, l'autre à 35 heures ; l'une fixe l'impôt
sur les sociétés à 20 %, l'autre à 25 %. Le modèle les additionne sans
broncher. Ce module les repère, à partir des leviers seuls (aucun calcul de
projection, aucune hypothèse) :

* **valeurs** : deux mesures fixent un même réglage (taux de l'IS, SMIC
  visé, âge légal visé…) à deux valeurs différentes ;
* **sens** : deux mesures déplacent un même réglage (durée du travail, âge
  légal, durée de cotisation…) dans des sens opposés.

Les étapes d'une même mesure (`O-117` et `O-117b`) ne sont pas comparées
entre elles : un calendrier n'est pas une contradiction. L'auteur peut
déclarer qu'une paire repérée est voulue (`Programme.arbitrages`, avec sa
raison) : elle n'est plus comptée comme conflit, mais le rapport l'affiche.

`Programme.coherent` vaut `false` dès qu'il reste un conflit non arbitré.
La vérification ne voit que ce que les leviers disent : deux mesures
contradictoires modélisées par des leviers différents lui échappent.
-/

namespace Modele

/-- Réglage de politique publique qu'un levier fixe ou déplace. -/
inductive Reglage where
  | dureeTravail | ageLegal | dureeCotisation | smic | migration | prixTabac
  | smicVise | tauxIS | ageLegalVise | regimeZan | prixMinimumAlcool
  | plafondNormeSante | freinDeficit | detteNumerique
  deriving DecidableEq, Repr

namespace Reglage

def id : Reglage → String
  | .dureeTravail => "dureeTravail"
  | .ageLegal => "ageLegal"
  | .dureeCotisation => "dureeCotisation"
  | .smic => "smic"
  | .migration => "migration"
  | .prixTabac => "prixTabac"
  | .smicVise => "smicVise"
  | .tauxIS => "tauxIS"
  | .ageLegalVise => "ageLegalVise"
  | .regimeZan => "regimeZan"
  | .prixMinimumAlcool => "prixMinimumAlcool"
  | .plafondNormeSante => "plafondNormeSante"
  | .freinDeficit => "freinDeficit"
  | .detteNumerique => "detteNumerique"

def nom : Reglage → String
  | .dureeTravail => "durée du travail"
  | .ageLegal => "âge légal de départ"
  | .dureeCotisation => "durée de cotisation requise"
  | .smic => "SMIC"
  | .migration => "solde migratoire"
  | .prixTabac => "prix du tabac"
  | .smicVise => "SMIC brut visé"
  | .tauxIS => "taux de l'impôt sur les sociétés"
  | .ageLegalVise => "âge légal visé"
  | .regimeZan => "régime de zéro artificialisation nette"
  | .prixMinimumAlcool => "prix minimum de l'alcool"
  | .plafondNormeSante => "plafond de la norme de dépense de santé"
  | .freinDeficit => "frein au déficit"
  | .detteNumerique => "dette numérique (part visée)"

end Reglage

/-- Le levier fixe le réglage à une valeur : deux valeurs différentes dans
un même programme se contredisent. -/
def Levier.fixe : Levier → Option (Reglage × Int)
  | .smicCibleBrut e _ => some (.smicVise, e)
  | .impotSocietes t => some (.tauxIS, t)
  | .ageLegalCible c _ => some (.ageLegalVise, c)
  | .regimeZan e => some (.regimeZan, e)
  | .prixMinimumAlcool c => some (.prixMinimumAlcool, c)
  | .plafondNormeSante p => some (.plafondNormeSante, p)
  | .freinDeficit s _ => some (.freinDeficit, s)
  | .detteNumerique c _ _ _ _ => some (.detteNumerique, c)
  | _ => none

/-- Le levier déplace le réglage de la variation donnée : deux variations de
signes opposés dans un même programme se contredisent. -/
def Levier.deplace : Levier → Option (Reglage × Int)
  | .dureeTravail v => some (.dureeTravail, v)
  | .ageLegal d => some (.ageLegal, d)
  | .dureeCotisation m _ => some (.dureeCotisation, m)
  | .revalorisationSmic h => some (.smic, h)
  | .migration d => some (.migration, d)
  | .prixTabac h => some (.prixTabac, h)
  | _ => none

inductive NatureConflit where
  /-- Deux valeurs différentes pour un même réglage. -/
  | valeurs
  /-- Deux sens opposés sur un même réglage. -/
  | sens
  deriving DecidableEq, Repr

def NatureConflit.id : NatureConflit → String
  | .valeurs => "valeurs"
  | .sens => "sens"

/-- Deux mesures d'un programme qui se contredisent sur un réglage. -/
structure Conflit where
  nature : NatureConflit
  reglage : Reglage
  mesure1 : String
  valeur1 : Int
  mesure2 : String
  valeur2 : Int
  deriving DecidableEq, Repr

namespace Coherence

/-- Identifiant de la mesure sans suffixe d'étape (`O-117b` → `O-117`). -/
def base (id : String) : String :=
  String.ofList (id.toList.reverse.dropWhile Char.isLower).reverse

/-- Toutes les paires (x, y) avec x avant y dans la liste. -/
def paires {α : Type} : List α → List (α × α)
  | [] => []
  | x :: xs => xs.map (fun y => (x, y)) ++ paires xs

/-- Réglages fixés (resp. déplacés) par chaque mesure. -/
def releves (f : Levier → Option (Reglage × Int)) (p : Programme) :
    List (String × Reglage × Int) :=
  p.mesures.flatMap fun m => (m.leviers.filterMap f).map fun (r, v) => (m.id, r, v)

def opposes (a b : Int) : Bool := (a > 0 && b < 0) || (a < 0 && b > 0)

/-- Conflits repérés, arbitrés ou non. -/
def bruts (p : Programme) : List Conflit :=
  let distinctes (i j : String) : Bool := base i != base j
  let v := (paires (releves Levier.fixe p)).filterMap fun ((i, r, a), (j, r', b)) =>
    if r == r' && a != b && distinctes i j then some ⟨.valeurs, r, i, a, j, b⟩ else none
  let s := (paires (releves Levier.deplace p)).filterMap fun ((i, r, a), (j, r', b)) =>
    if r == r' && opposes a b && distinctes i j then some ⟨.sens, r, i, a, j, b⟩ else none
  v ++ s

end Coherence

/-- L'arbitrage porte sur la paire de mesures du conflit (dans un ordre ou
dans l'autre). -/
def Arbitrage.couvre (a : Arbitrage) (c : Conflit) : Bool :=
  (a.mesure1 == c.mesure1 && a.mesure2 == c.mesure2) ||
  (a.mesure1 == c.mesure2 && a.mesure2 == c.mesure1)

namespace Programme

/-- Conflits que l'auteur n'a pas arbitrés. -/
def conflits (p : Programme) : List Conflit :=
  (Coherence.bruts p).filter fun c => !(p.arbitrages.any (Arbitrage.couvre · c))

/-- Conflits arbitrés, avec la raison donnée par l'auteur. -/
def conflitsArbitres (p : Programme) : List (Conflit × String) :=
  (Coherence.bruts p).filterMap fun c =>
    (p.arbitrages.find? (Arbitrage.couvre · c)).map fun a => (c, a.raison)

/-- Arbitrages qui ne couvrent aucun conflit (mesure renommée, conflit
disparu) : à retirer du programme. -/
def arbitragesSansObjet (p : Programme) : List Arbitrage :=
  p.arbitrages.filter fun a => !((Coherence.bruts p).any a.couvre)

/-- Le programme est cohérent : aucun conflit non arbitré. -/
def coherent (p : Programme) : Bool := p.conflits.isEmpty

end Programme

end Modele
