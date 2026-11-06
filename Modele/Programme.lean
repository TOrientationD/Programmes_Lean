import Modele.Propriete

/-!
# Mesures, programmes, engagements

* Une `Mesure` est une liste de leviers, avec la référence de la page du
  programme d'où elle est tirée (traçabilité), et d'éventuels **contrats** :
  des propriétés du dispositif prouvées pour tous les cas (toute commune,
  tout ménage…).
* Un `Programme` est une liste de mesures, plus des **engagements** : les
  couples (scénario, propriété) que ses auteurs revendiquent.

Deux niveaux de vérification :

1. **Engagements** — chaque programme prouve `EngagementsTenus` dans son
   fichier `Engagements.lean`. Si une PR (même sur les hypothèses communes)
   casse un engagement, la compilation échoue : le programme doit retirer
   l'engagement ou modifier ses mesures.
2. **Évaluation** — la matrice complète programme × scénario × propriété est
   calculée par le rapport. Elle est informative : un programme n'est pas
   tenu de satisfaire toutes les propriétés sous tous les scénarios.
-/

namespace Modele

/-- Propriété d'une mesure prouvée une fois pour toutes, typiquement « pour
toute commune » ou « pour tout ménage ». Un contrat ne peut pas exister sans
sa preuve : s'il devient faux (changement de la mesure ou du modèle
commun), la compilation échoue et Lean désigne le contrat cassé.

Différence avec un engagement : un engagement porte sur l'état macro sous
un scénario et se décide par calcul ; un contrat est un énoncé universel
sur le dispositif lui-même et se prouve. -/
structure Contrat where
  titre : String
  enonce : Prop
  preuve : enonce

/-- Variante d'une mesure : même intention, autres paramètres (taux,
origine des véhicules…). Le rapport la compare à la version retenue ; elle
n'entre pas dans l'évaluation du programme. -/
structure Variante where
  nom : String
  leviers : List Levier

/-- Place d'une mesure dans une négociation (classement de l'auteur du
programme ; n'entre pas dans l'évaluation) :

* `rubicon` : non négociable, la mesure fait le programme ;
* `parametrable` : le principe est acquis, ses paramètres (taux, montant,
  calendrier) se règlent ;
* `negociable` : la mesure peut être cédée en échange d'autre chose ;
* `nonClasse` : programme qui ne classe pas ses mesures (par défaut). -/
inductive Statut where
  | rubicon | parametrable | negociable | nonClasse
  deriving Repr, DecidableEq, Inhabited

namespace Statut

def tous : List Statut := [.rubicon, .parametrable, .negociable, .nonClasse]

def id : Statut → String
  | .rubicon => "rubicon"
  | .parametrable => "parametrable"
  | .negociable => "negociable"
  | .nonClasse => "nonClasse"

def nom : Statut → String
  | .rubicon => "Rubicons (non négociables)"
  | .parametrable => "Paramétrables"
  | .negociable => "Négociables"
  | .nonClasse => "Non classées"

end Statut

/-- Domaine d'une mesure, pour la présenter (sous-catégories d'un
classement par `Statut`) ; n'entre pas dans l'évaluation. Distinct des
fonctions de la dépense publique (`Fonction`), qui disent où le modèle
impute la dépense. -/
inductive Domaine where
  | economie | fiscalite | financesPubliques | defense | securiteJustice
  | energieClimat | transports | logementTerritoires | agriculture | education
  | sante | solidarites | institutions | societe | international | outreMer
  | numerique | nonClasse
  deriving Repr, DecidableEq, Inhabited

namespace Domaine

def tous : List Domaine :=
  [.economie, .fiscalite, .financesPubliques, .defense, .securiteJustice,
   .energieClimat, .transports, .logementTerritoires, .agriculture, .education,
   .sante, .solidarites, .institutions, .societe, .international, .outreMer,
   .numerique, .nonClasse]

def id : Domaine → String
  | .economie => "economie"
  | .fiscalite => "fiscalite"
  | .financesPubliques => "financesPubliques"
  | .defense => "defense"
  | .securiteJustice => "securiteJustice"
  | .energieClimat => "energieClimat"
  | .transports => "transports"
  | .logementTerritoires => "logementTerritoires"
  | .agriculture => "agriculture"
  | .education => "education"
  | .sante => "sante"
  | .solidarites => "solidarites"
  | .institutions => "institutions"
  | .societe => "societe"
  | .international => "international"
  | .outreMer => "outreMer"
  | .numerique => "numerique"
  | .nonClasse => "nonClasse"

def nom : Domaine → String
  | .economie => "Économie, entreprises et travail"
  | .fiscalite => "Fiscalité et prélèvements"
  | .financesPubliques => "Finances publiques et État"
  | .defense => "Défense et espace"
  | .securiteJustice => "Sécurité et justice"
  | .energieClimat => "Énergie, climat et environnement"
  | .transports => "Transports et mobilité"
  | .logementTerritoires => "Logement et territoires"
  | .agriculture => "Agriculture et alimentation"
  | .education => "Éducation, recherche et sport"
  | .sante => "Santé"
  | .solidarites => "Retraites, solidarités et grand âge"
  | .institutions => "Institutions et démocratie"
  | .societe => "Libertés et société"
  | .international => "International, immigration et mémoire"
  | .outreMer => "Outre-mer"
  | .numerique => "Numérique et cybersécurité"
  | .nonClasse => "Non classées"

end Domaine

structure Mesure where
  /-- Identifiant unique dans le programme, ex. `"R-03"`. -/
  id : String
  titre : String
  /-- Référence dans le document source (page, section, URL). -/
  source : String
  leviers : List Levier
  /-- Propriétés prouvées du dispositif (voir `Contrat`). -/
  contrats : List Contrat := []
  /-- Variantes comparées dans le rapport (voir `Variante`). -/
  variantes : List Variante := []
  /-- Année d'entrée en vigueur, comptée depuis l'entrée en vigueur du
  programme (0 = dès la première année du programme). Une mesure dont le
  début dépasse l'horizon n'a aucun effet. -/
  debut : Nat := 0
  /-- Nombre d'années consécutives d'application (1 par défaut) : une mesure
  « 10 000 postes par an pendant cinq ans » s'applique cinq fois. -/
  repetitions : Nat := 1
  /-- Place dans une négociation et domaine (présentation seulement, voir
  `Statut` et `Domaine`). -/
  statut : Statut := .nonClasse
  domaine : Domaine := .nonClasse
  /-- Pour une mesure paramétrable, ce qui se règle ; pour une mesure
  négociable, ce qui la rend discutée. -/
  noteStatut : String := ""

def Mesure.appliquer (M : Moteur) (H : Scenario) (m : Mesure) (s : Etat) : Etat :=
  m.leviers.foldl (fun s l => l.appliquer M H s) s

/-- Arbitrage déclaré par l'auteur d'un programme : deux de ses mesures
agissent en sens opposé sur un même réglage (ou le fixent à deux valeurs),
et l'auteur explique pourquoi elles restent compatibles. L'arbitrage lève
l'alerte de cohérence (`Modele.Coherence`) mais reste affiché avec sa
raison dans le rapport. -/
structure Arbitrage where
  mesure1 : String
  mesure2 : String
  raison : String

structure Engagement where
  scenario : Scenario
  propriete : Propriete
  /-- Moteur sous lequel l'engagement est revendiqué. -/
  moteur : Moteur

/-- Engagement sous le moteur donné. -/
def Engagement.sous (M : Moteur) (H : Scenario) (q : Propriete) : Engagement :=
  ⟨H, q, M⟩

structure Programme where
  /-- Identifiant = nom du dossier dans `Programmes/`. -/
  id : String
  nom : String
  description : String
  /-- Comptes GitHub responsables (repris dans CODEOWNERS). -/
  mainteneurs : List String
  /-- Document source du programme. -/
  source : String
  mesures : List Mesure
  engagements : List Engagement := []
  /-- Année d'entrée en vigueur du programme, comptée depuis l'année de départ
  (2025) : 2 pour un programme présidentiel ou législatif de 2027. Aucune
  mesure ne s'applique avant. -/
  entreeEnVigueur : Nat := 0
  /-- Paires de mesures opposées que l'auteur déclare compatibles, avec la
  raison (voir `Arbitrage` et `Modele.Coherence`). -/
  arbitrages : List Arbitrage := []

namespace Programme

/-- La mesure s'applique l'année `t` (entrée en vigueur ou répétition). -/
def _root_.Modele.Mesure.sAppliqueA (m : Mesure) (t : Nat) : Bool :=
  decide (m.debut ≤ t) && decide (t < m.debut + m.repetitions)

/-- Applique les mesures qui s'appliquent l'année `t` (rien avant l'entrée en
vigueur du programme ; le début des mesures est compté depuis celle-ci). -/
def appliquerAnnee (p : Programme) (M : Moteur) (H : Scenario) (t : Nat) (s : Etat) : Etat :=
  if t < p.entreeEnVigueur then s else
  match p.mesures.filter (·.sAppliqueA (t - p.entreeEnVigueur)) with
  | [] => s
  -- l'indemnisation du chômage suit les emplois créés ou détruits ; le bloc de
  -- demande résout l'année avec les chocs des mesures
  | ms => bouclerDemande M H (stabilisateurChomage M H (ms.foldl (fun s m => m.appliquer M H s) s))

/-- Situation de départ après application des mesures immédiates. -/
def etatInitial (p : Programme) (M : Moteur) (H : Scenario) : Etat :=
  p.appliquerAnnee M H 0 (etatDepart H)

/-- Projection sur `n` années à partir de l'année `t` : mesures de l'année,
puis une année de projection. -/
def projeterDepuis (p : Programme) (M : Moteur) (H : Scenario) : Nat → Nat → Etat → Etat
  | 0, t, s => p.appliquerAnnee M H t s
  | n + 1, t, s =>
    p.projeterDepuis M H n (t + 1) (anneeSuivante M H (p.appliquerAnnee M H t s))

/-- États successifs sur `n` années (`n + 1` états), mesures appliquées à
leur année d'entrée en vigueur. -/
def trajectoire (p : Programme) (M : Moteur) (H : Scenario) : Nat → Nat → Etat → List Etat
  | 0, t, s => [p.appliquerAnnee M H t s]
  | n + 1, t, s =>
    let s' := p.appliquerAnnee M H t s
    s' :: p.trajectoire M H n (t + 1) (anneeSuivante M H s')

/-- Situation avec le programme après `n` années. -/
def resultatA (p : Programme) (M : Moteur) (H : Scenario) (n : Nat) : Etat :=
  p.projeterDepuis M H n 0 (etatDepart H)

/-- Situation à l'horizon avec le programme. -/
def resultat (p : Programme) (M : Moteur) (H : Scenario) : Etat :=
  p.resultatA M H H.horizon

/-- La propriété `q` tient pour le programme sous le moteur et le scénario,
à l'année propre à la propriété (horizon du scénario par défaut). -/
def Verifie (p : Programme) (M : Moteur) (H : Scenario) (q : Propriete) : Prop :=
  match q.trajectoire with
  | none => q.tient H (tendancielA M H (q.horizon H)) (p.resultatA M H (q.horizon H))
  | some f => f H p.entreeEnVigueur (Modele.trajectoire M H (q.horizon H) (etatDepart H))
      (p.trajectoire M H (q.horizon H) 0 (etatDepart H)) = true

instance (p : Programme) (M : Moteur) (H : Scenario) (q : Propriete) :
    Decidable (p.Verifie M H q) := by
  unfold Verifie; split <;> infer_instance

/-- Tous les engagements revendiqués sont tenus. -/
def EngagementsTenus (p : Programme) : Prop :=
  ∀ e ∈ p.engagements, p.Verifie e.moteur e.scenario e.propriete

instance (p : Programme) : Decidable p.EngagementsTenus :=
  inferInstanceAs (Decidable (∀ e ∈ p.engagements, _))

end Programme

/-- Une propriété vraie sur chaque bloc de `n` éléments d'une liste (les `m`
premiers blocs, puis le reste) l'est sur toute la liste. Sert à vérifier
les engagements par blocs : le noyau garde en mémoire les calculs d'une
même vérification, et un programme aux engagements nombreux la ferait
dépasser la mémoire disponible. -/
theorem forall_mem_blocs {α : Type} (P : α → Prop) (n : Nat) :
    ∀ (m : Nat) (L : List α), (∀ k, k < m → ∀ e ∈ (L.drop (n * k)).take n, P e) →
      (∀ e ∈ L.drop (n * m), P e) → ∀ e ∈ L, P e := by
  intro m
  induction m with
  | zero => intro L _ h e he; exact h e (by simpa using he)
  | succ m ih =>
    intro L hb hr e he
    rw [← List.take_append_drop n L] at he
    rcases List.mem_append.mp he with h | h
    · exact hb 0 (by omega) e (by simpa using h)
    · refine ih (L.drop n) (fun k hk x hx => hb (k + 1) (by omega) x ?_) (fun x hx => hr x ?_) e h
      · rw [List.drop_drop] at hx
        rwa [show n * (k + 1) = n + n * k by rw [Nat.mul_succ]; omega]
      · rw [List.drop_drop] at hx
        rwa [show n * (m + 1) = n + n * m by rw [Nat.mul_succ]; omega]

end Modele
