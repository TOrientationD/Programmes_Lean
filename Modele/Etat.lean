import Modele.Unites
import Modele.Demande

/-!
# État macro suivi par le modèle

Un `Etat` est la photographie d'une année. Le modèle compare toujours deux
états à l'horizon du scénario : le **tendanciel** (sans programme) et
l'état **avec programme**.

Les recettes publiques sont décomposées par grand impôt (`ParImpot`),
l'emploi par grand secteur (`ParSecteur`). Les recettes totales, l'emploi
total et le taux de chômage sont calculés, jamais stockés : ils ne peuvent
pas se désynchroniser de leur décomposition. L'emploi et la population
active sont comptés en personnes, pour que même une petite mesure ait un
effet visible sur l'emploi.

Ajouter un champ ici est une modification du modèle commun : elle doit être
discutée en issue avant toute PR (voir CONTRIBUTING.md).
-/

namespace Modele

/-! ## Secteurs d'activité -/

/-- Grands secteurs de la nomenclature agrégée de l'INSEE. -/
inductive Secteur where
  | agriculture | industrie | construction | tertiaireMarchand | tertiaireNonMarchand
  deriving Repr, DecidableEq, Inhabited

namespace Secteur

def tous : List Secteur :=
  [.agriculture, .industrie, .construction, .tertiaireMarchand, .tertiaireNonMarchand]

def nom : Secteur → String
  | .agriculture => "Agriculture"
  | .industrie => "Industrie"
  | .construction => "Construction"
  | .tertiaireMarchand => "Tertiaire marchand"
  | .tertiaireNonMarchand => "Tertiaire non marchand"

def id : Secteur → String
  | .agriculture => "agriculture"
  | .industrie => "industrie"
  | .construction => "construction"
  | .tertiaireMarchand => "tertiaireMarchand"
  | .tertiaireNonMarchand => "tertiaireNonMarchand"

end Secteur

/-- Une valeur par secteur. -/
structure ParSecteur where
  agriculture : Int
  industrie : Int
  construction : Int
  tertiaireMarchand : Int
  tertiaireNonMarchand : Int
  deriving Repr, DecidableEq, Inhabited

namespace ParSecteur

def get (v : ParSecteur) : Secteur → Int
  | .agriculture => v.agriculture
  | .industrie => v.industrie
  | .construction => v.construction
  | .tertiaireMarchand => v.tertiaireMarchand
  | .tertiaireNonMarchand => v.tertiaireNonMarchand

def ajouter (v : ParSecteur) (s : Secteur) (d : Int) : ParSecteur :=
  match s with
  | .agriculture => { v with agriculture := v.agriculture + d }
  | .industrie => { v with industrie := v.industrie + d }
  | .construction => { v with construction := v.construction + d }
  | .tertiaireMarchand => { v with tertiaireMarchand := v.tertiaireMarchand + d }
  | .tertiaireNonMarchand => { v with tertiaireNonMarchand := v.tertiaireNonMarchand + d }

def total (v : ParSecteur) : Int :=
  v.agriculture + v.industrie + v.construction + v.tertiaireMarchand + v.tertiaireNonMarchand

/-- Tous les secteurs sont positifs ou nuls. -/
abbrev Positif (v : ParSecteur) : Prop :=
  0 ≤ v.agriculture ∧ 0 ≤ v.industrie ∧ 0 ≤ v.construction ∧
  0 ≤ v.tertiaireMarchand ∧ 0 ≤ v.tertiaireNonMarchand

/-- Répartit `d` : entièrement sur `cible` si elle est donnée, sinon au
prorata, parts arrondies vers zéro (le reste va au tertiaire marchand). Le
total augmente exactement de `d`. -/
def repartir (v : ParSecteur) (d : Int) : Option Secteur → ParSecteur
  | some s => v.ajouter s d
  | none =>
    let t := v.total
    if t = 0 then v.ajouter .tertiaireMarchand d else
    let part (x : Int) := if d < 0 then -((-d) * x / t) else d * x / t
    let a := part v.agriculture
    let i := part v.industrie
    let c := part v.construction
    let n := part v.tertiaireNonMarchand
    { agriculture := v.agriculture + a, industrie := v.industrie + i
      construction := v.construction + c
      tertiaireMarchand := v.tertiaireMarchand + (d - a - i - c - n)
      tertiaireNonMarchand := v.tertiaireNonMarchand + n }

end ParSecteur

/-! ## Tranches de salaire -/

/-- Tranches de salaire du secteur privé, en multiples du SMIC (allègements
généraux de cotisations patronales, coût du travail). -/
inductive TrancheSalaire where
  /-- De 1 à 1,6 SMIC. -/
  | bas
  /-- De 1,6 à 2,5 SMIC. -/
  | intermediaire
  /-- Au-delà de 2,5 SMIC. -/
  | haut
  deriving Repr, DecidableEq, Inhabited

namespace TrancheSalaire

def tous : List TrancheSalaire := [.bas, .intermediaire, .haut]

def id : TrancheSalaire → String
  | .bas => "bas"
  | .intermediaire => "intermediaire"
  | .haut => "haut"

def nom : TrancheSalaire → String
  | .bas => "1 à 1,6 SMIC"
  | .intermediaire => "1,6 à 2,5 SMIC"
  | .haut => "Au-delà de 2,5 SMIC"

end TrancheSalaire

/-- Une valeur par tranche de salaire. -/
structure ParTranche where
  bas : Int := 0
  intermediaire : Int := 0
  haut : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace ParTranche

def get (v : ParTranche) : TrancheSalaire → Int
  | .bas => v.bas
  | .intermediaire => v.intermediaire
  | .haut => v.haut

def ajouter (v : ParTranche) (t : TrancheSalaire) (d : Int) : ParTranche :=
  match t with
  | .bas => { v with bas := v.bas + d }
  | .intermediaire => { v with intermediaire := v.intermediaire + d }
  | .haut => { v with haut := v.haut + d }

def total (v : ParTranche) : Int := v.bas + v.intermediaire + v.haut

/-- Chaque tranche croît du même taux (pb). -/
def croitre (v : ParTranche) (tauxPb : Int) : ParTranche :=
  { bas := v.bas + appliquerPb v.bas tauxPb
    intermediaire := v.intermediaire + appliquerPb v.intermediaire tauxPb
    haut := v.haut + appliquerPb v.haut tauxPb }

/-- Toutes les composantes sont dans `[lo, hi]`. -/
def toutEntre (v : ParTranche) (lo hi : Int) : Bool :=
  TrancheSalaire.tous.all fun t => decide (lo ≤ v.get t ∧ v.get t ≤ hi)

theorem total_ajouter (v : ParTranche) (t : TrancheSalaire) (d : Int) :
    (v.ajouter t d).total = v.total + d := by
  cases t <;> simp [ajouter, total] <;> omega

end ParTranche

/-! ## Causes de décès évitables (santé publique) -/

/-- Causes de décès sur lesquelles agissent des leviers de santé publique. -/
inductive CauseDeces where
  | tabac | alcool | cancerColorectal | arretCardiaque
  deriving Repr, DecidableEq, Inhabited

namespace CauseDeces
def tous : List CauseDeces := [.tabac, .alcool, .cancerColorectal, .arretCardiaque]
def id : CauseDeces → String
  | .tabac => "tabac" | .alcool => "alcool" | .cancerColorectal => "cancerColorectal"
  | .arretCardiaque => "arretCardiaque"
end CauseDeces

/-- Une valeur par cause de décès. -/
structure ParCause where
  tabac : Int := 0
  alcool : Int := 0
  cancerColorectal : Int := 0
  arretCardiaque : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace ParCause
def get (v : ParCause) : CauseDeces → Int
  | .tabac => v.tabac | .alcool => v.alcool | .cancerColorectal => v.cancerColorectal
  | .arretCardiaque => v.arretCardiaque
def ajouter (v : ParCause) (c : CauseDeces) (d : Int) : ParCause :=
  match c with
  | .tabac => { v with tabac := v.tabac + d }
  | .alcool => { v with alcool := v.alcool + d }
  | .cancerColorectal => { v with cancerColorectal := v.cancerColorectal + d }
  | .arretCardiaque => { v with arretCardiaque := v.arretCardiaque + d }
/-- Toutes les composantes sont dans `[lo, hi]`. -/
def toutEntre (v : ParCause) (lo hi : Int) : Bool :=
  CauseDeces.tous.all fun c => decide (lo ≤ v.get c ∧ v.get c ≤ hi)
end ParCause

/-! ## Émissions de gaz à effet de serre par secteur -/

/-- Secteurs d'émission (inventaire national, format SECTEN du Citepa). -/
inductive SecteurGes where
  | transports | batiments | agriculture | industrie | energie | dechets
  deriving Repr, DecidableEq, Inhabited

namespace SecteurGes

def tous : List SecteurGes := [.transports, .batiments, .agriculture, .industrie, .energie, .dechets]

def nom : SecteurGes → String
  | .transports => "Transports"
  | .batiments => "Bâtiments"
  | .agriculture => "Agriculture"
  | .industrie => "Industrie"
  | .energie => "Production d'énergie"
  | .dechets => "Déchets"

def id : SecteurGes → String
  | .transports => "transports"
  | .batiments => "batiments"
  | .agriculture => "agriculture"
  | .industrie => "industrie"
  | .energie => "energie"
  | .dechets => "dechets"

end SecteurGes

/-- Une valeur par secteur d'émission (kt CO₂e, ou pm pour des taux). -/
structure ParSecteurGes where
  transports : Int
  batiments : Int
  agriculture : Int
  industrie : Int
  energie : Int
  dechets : Int
  deriving Repr, DecidableEq, Inhabited

namespace ParSecteurGes

def get (v : ParSecteurGes) : SecteurGes → Int
  | .transports => v.transports
  | .batiments => v.batiments
  | .agriculture => v.agriculture
  | .industrie => v.industrie
  | .energie => v.energie
  | .dechets => v.dechets

def ajouter (v : ParSecteurGes) (s : SecteurGes) (d : Int) : ParSecteurGes :=
  match s with
  | .transports => { v with transports := v.transports + d }
  | .batiments => { v with batiments := v.batiments + d }
  | .agriculture => { v with agriculture := v.agriculture + d }
  | .industrie => { v with industrie := v.industrie + d }
  | .energie => { v with energie := v.energie + d }
  | .dechets => { v with dechets := v.dechets + d }

def total (v : ParSecteurGes) : Int :=
  v.transports + v.batiments + v.agriculture + v.industrie + v.energie + v.dechets

/-- Chaque secteur multiplié par `1 + écart` (écart en ppm). -/
def ajusterPpm (v : ParSecteurGes) (ecart : ParSecteurGes) : ParSecteurGes :=
  { transports := v.transports * (1000000 + ecart.transports) / 1000000
    batiments := v.batiments * (1000000 + ecart.batiments) / 1000000
    agriculture := v.agriculture * (1000000 + ecart.agriculture) / 1000000
    industrie := v.industrie * (1000000 + ecart.industrie) / 1000000
    energie := v.energie * (1000000 + ecart.energie) / 1000000
    dechets := v.dechets * (1000000 + ecart.dechets) / 1000000 }

/-- Baisse de chaque secteur à son taux (pm du niveau). -/
def baisser (v : ParSecteurGes) (taux : ParSecteurGes) : ParSecteurGes :=
  { transports := v.transports - appliquerPm v.transports taux.transports
    batiments := v.batiments - appliquerPm v.batiments taux.batiments
    agriculture := v.agriculture - appliquerPm v.agriculture taux.agriculture
    industrie := v.industrie - appliquerPm v.industrie taux.industrie
    energie := v.energie - appliquerPm v.energie taux.energie
    dechets := v.dechets - appliquerPm v.dechets taux.dechets }

theorem total_ajouter (v : ParSecteurGes) (s : SecteurGes) (d : Int) :
    (v.ajouter s d).total = v.total + d := by
  cases s <;> simp [ajouter, total] <;> omega

end ParSecteurGes

/-! ## Électricité et sols -/

/-- Filières de production d'électricité (nomenclature du bilan électrique de
RTE). -/
inductive Filiere where
  | nucleaire | hydraulique | eolienTerrestre | eolienMer | solaire | thermique | bioenergies
  deriving Repr, DecidableEq, Inhabited

namespace Filiere

def tous : List Filiere :=
  [.nucleaire, .hydraulique, .eolienTerrestre, .eolienMer, .solaire, .thermique, .bioenergies]

def id : Filiere → String
  | .nucleaire => "nucleaire"
  | .hydraulique => "hydraulique"
  | .eolienTerrestre => "eolienTerrestre"
  | .eolienMer => "eolienMer"
  | .solaire => "solaire"
  | .thermique => "thermique"
  | .bioenergies => "bioenergies"

def nom : Filiere → String
  | .nucleaire => "Nucléaire"
  | .hydraulique => "Hydraulique"
  | .eolienTerrestre => "Éolien terrestre"
  | .eolienMer => "Éolien en mer"
  | .solaire => "Solaire"
  | .thermique => "Thermique fossile"
  | .bioenergies => "Bioénergies"

end Filiere

/-- Une valeur par filière (capacités en MW, production en GWh, facteurs de
charge en pm). -/
structure ParFiliere where
  nucleaire : Int := 0
  hydraulique : Int := 0
  eolienTerrestre : Int := 0
  eolienMer : Int := 0
  solaire : Int := 0
  thermique : Int := 0
  bioenergies : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace ParFiliere

def get (v : ParFiliere) : Filiere → Int
  | .nucleaire => v.nucleaire
  | .hydraulique => v.hydraulique
  | .eolienTerrestre => v.eolienTerrestre
  | .eolienMer => v.eolienMer
  | .solaire => v.solaire
  | .thermique => v.thermique
  | .bioenergies => v.bioenergies

def ajouter (v : ParFiliere) (f : Filiere) (d : Int) : ParFiliere :=
  match f with
  | .nucleaire => { v with nucleaire := v.nucleaire + d }
  | .hydraulique => { v with hydraulique := v.hydraulique + d }
  | .eolienTerrestre => { v with eolienTerrestre := v.eolienTerrestre + d }
  | .eolienMer => { v with eolienMer := v.eolienMer + d }
  | .solaire => { v with solaire := v.solaire + d }
  | .thermique => { v with thermique := v.thermique + d }
  | .bioenergies => { v with bioenergies := v.bioenergies + d }

def total (v : ParFiliere) : Int :=
  v.nucleaire + v.hydraulique + v.eolienTerrestre + v.eolienMer + v.solaire + v.thermique + v.bioenergies

/-- Somme terme à terme ; une capacité ne devient jamais négative. -/
def plusPositif (v w : ParFiliere) : ParFiliere :=
  { nucleaire := max 0 (v.nucleaire + w.nucleaire), hydraulique := max 0 (v.hydraulique + w.hydraulique)
    eolienTerrestre := max 0 (v.eolienTerrestre + w.eolienTerrestre)
    eolienMer := max 0 (v.eolienMer + w.eolienMer), solaire := max 0 (v.solaire + w.solaire)
    thermique := max 0 (v.thermique + w.thermique), bioenergies := max 0 (v.bioenergies + w.bioenergies) }

/-- Somme terme à terme. -/
def plus (v w : ParFiliere) : ParFiliere :=
  { nucleaire := v.nucleaire + w.nucleaire, hydraulique := v.hydraulique + w.hydraulique
    eolienTerrestre := v.eolienTerrestre + w.eolienTerrestre, eolienMer := v.eolienMer + w.eolienMer
    solaire := v.solaire + w.solaire, thermique := v.thermique + w.thermique
    bioenergies := v.bioenergies + w.bioenergies }

/-- Plancher nul terme à terme (des installations annuelles ne sont jamais
négatives : un levier réduit les installations nouvelles, il ne démantèle
pas). -/
def plancherNul (v : ParFiliere) : ParFiliere :=
  { nucleaire := max 0 v.nucleaire, hydraulique := max 0 v.hydraulique
    eolienTerrestre := max 0 v.eolienTerrestre, eolienMer := max 0 v.eolienMer
    solaire := max 0 v.solaire, thermique := max 0 v.thermique, bioenergies := max 0 v.bioenergies }

/-- Moyenne terme à terme (capacité moyenne de l'année : début et fin). -/
def moyenne (v w : ParFiliere) : ParFiliere :=
  { nucleaire := (v.nucleaire + w.nucleaire) / 2, hydraulique := (v.hydraulique + w.hydraulique) / 2
    eolienTerrestre := (v.eolienTerrestre + w.eolienTerrestre) / 2
    eolienMer := (v.eolienMer + w.eolienMer) / 2, solaire := (v.solaire + w.solaire) / 2
    thermique := (v.thermique + w.thermique) / 2, bioenergies := (v.bioenergies + w.bioenergies) / 2 }

/-- Production annuelle, GWh, de capacités `c` (MW) aux facteurs de charge
`fc` (pm) : MW × fc × 8 760 h. -/
def production (c fc : ParFiliere) : ParFiliere :=
  let p (x f : Int) := x * f * 876 / 100000
  { nucleaire := p c.nucleaire fc.nucleaire, hydraulique := p c.hydraulique fc.hydraulique
    eolienTerrestre := p c.eolienTerrestre fc.eolienTerrestre, eolienMer := p c.eolienMer fc.eolienMer
    solaire := p c.solaire fc.solaire, thermique := p c.thermique fc.thermique
    bioenergies := p c.bioenergies fc.bioenergies }

end ParFiliere

/-- Destinations des surfaces consommées. Les quatre premières suivent la
nomenclature des fichiers fonciers du Cerema (habitat, activité,
infrastructures routières et ferroviaires ; « mixte » et « inconnu »
regroupés) ; l'énergie est l'emprise des installations nouvelles de
production d'électricité, calculée par le sous-modèle électrique. -/
inductive Destination where
  | logement | activites | infrastructures | autres | energie
  deriving Repr, DecidableEq, Inhabited

namespace Destination

def tous : List Destination := [.logement, .activites, .infrastructures, .autres, .energie]

/-- Destinations décomptées dans la consommation d'espaces naturels,
agricoles et forestiers (ENAF) au sens de la loi Climat et résilience. -/
def enaf : List Destination := [.logement, .activites, .infrastructures, .autres]

def id : Destination → String
  | .logement => "logement"
  | .activites => "activites"
  | .infrastructures => "infrastructures"
  | .autres => "autres"
  | .energie => "energie"

def nom : Destination → String
  | .logement => "Logement"
  | .activites => "Activités et industrie"
  | .infrastructures => "Infrastructures de transport"
  | .autres => "Mixte, équipements, non renseigné"
  | .energie => "Énergie (emprise solaire au sol et éolien)"

end Destination

/-- Une surface par destination, ha. -/
structure ParDestination where
  logement : Int := 0
  activites : Int := 0
  infrastructures : Int := 0
  autres : Int := 0
  energie : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace ParDestination

def get (v : ParDestination) : Destination → Int
  | .logement => v.logement
  | .activites => v.activites
  | .infrastructures => v.infrastructures
  | .autres => v.autres
  | .energie => v.energie

def ajouter (v : ParDestination) (d : Destination) (x : Int) : ParDestination :=
  match d with
  | .logement => { v with logement := v.logement + x }
  | .activites => { v with activites := v.activites + x }
  | .infrastructures => { v with infrastructures := v.infrastructures + x }
  | .autres => { v with autres := v.autres + x }
  | .energie => { v with energie := v.energie + x }

def total (v : ParDestination) : Int :=
  v.logement + v.activites + v.infrastructures + v.autres + v.energie

/-- Consommation d'espaces naturels, agricoles et forestiers (hors
emprise énergétique). -/
def totalEnaf (v : ParDestination) : Int := v.total - v.energie

/-- Application terme à terme. -/
def map (f : Int → Int) (v : ParDestination) : ParDestination :=
  { logement := f v.logement, activites := f v.activites, infrastructures := f v.infrastructures
    autres := f v.autres, energie := f v.energie }

/-- Combinaison terme à terme. -/
def zip (f : Int → Int → Int) (v w : ParDestination) : ParDestination :=
  { logement := f v.logement w.logement, activites := f v.activites w.activites
    infrastructures := f v.infrastructures w.infrastructures, autres := f v.autres w.autres
    energie := f v.energie w.energie }

def plus (v w : ParDestination) : ParDestination := zip (· + ·) v w

/-- Répartition d'un total `x` selon une structure `v` en pm. -/
def echelle (v : ParDestination) (x : Int) : ParDestination := v.map (· * x / 1000)

/-- `v + part × (w − v)`, part en pm, terme à terme. -/
def interpoler (v w : ParDestination) (partPm : Int) : ParDestination :=
  zip (fun a b => a + (b - a) * partPm / 1000) v w

/-- Plafond `v` dans lequel s'imputent les surfaces `m` : chaque
destination de `v` cède, au prorata de son poids, le total de `m` (sans
devenir négative), puis reçoit sa part de `m`. Le total vaut celui de `v`
tant que `m` y tient. -/
def imputer (v m : ParDestination) : ParDestination :=
  let t := v.total
  let mt := m.total
  zip (fun a b => (if t = 0 then 0 else max 0 (a - mt * a / t)) + b) v m

end ParDestination

/-! ## Impôts et cotisations -/

/-- Grands prélèvements obligatoires. -/
inductive Impot where
  | tva | ir | csgCrds | cotisations | impotSocietes | accisesEnergie | taxeFonciere
  | droitsMutation
  /-- Droits de mutation à titre onéreux (ventes immobilières) : leur
  assiette est la valeur des transactions. -/
  | mutationsOnereuses
  /-- Impôts sur le stock de patrimoine (IFI, taxes sur la fortune ou sur les
  holdings) : payés par les ménages les plus aisés, d'où un faible effet sur
  la demande (voir `Economie.incidencePrelevementPm`). -/
  | patrimoine
  | autres
  deriving Repr, DecidableEq, Inhabited

namespace Impot

def tous : List Impot :=
  [.tva, .ir, .csgCrds, .cotisations, .impotSocietes, .accisesEnergie, .taxeFonciere,
   .droitsMutation, .mutationsOnereuses, .patrimoine, .autres]

def nom : Impot → String
  | .tva => "TVA"
  | .ir => "Impôt sur le revenu"
  | .csgCrds => "CSG et CRDS"
  | .cotisations => "Cotisations sociales"
  | .impotSocietes => "Impôt sur les sociétés"
  | .accisesEnergie => "Accise sur les énergies (TICPE)"
  | .taxeFonciere => "Taxe foncière"
  | .droitsMutation => "Droits de succession et de donation"
  | .mutationsOnereuses => "Droits de mutation à titre onéreux (DMTO)"
  | .patrimoine => "Impôts sur le patrimoine (IFI, fortune)"
  | .autres => "Autres impôts"

def id : Impot → String
  | .tva => "tva"
  | .ir => "ir"
  | .csgCrds => "csgCrds"
  | .cotisations => "cotisations"
  | .impotSocietes => "impotSocietes"
  | .accisesEnergie => "accisesEnergie"
  | .taxeFonciere => "taxeFonciere"
  | .droitsMutation => "droitsMutation"
  | .mutationsOnereuses => "mutationsOnereuses"
  | .patrimoine => "patrimoine"
  | .autres => "autres"

end Impot

/-- Un montant par prélèvement, M€. -/
structure ParImpot where
  tva : Int
  ir : Int
  csgCrds : Int
  cotisations : Int
  impotSocietes : Int
  accisesEnergie : Int
  taxeFonciere : Int
  /-- Droits de mutation à titre gratuit (successions et donations). Leur
  assiette suit le flux successoral, pas le PIB (voir la projection). -/
  droitsMutation : Int
  /-- Droits de mutation à titre onéreux (ventes immobilières) : leur
  assiette est la valeur des transactions (voir la projection). -/
  mutationsOnereuses : Int
  /-- Impôts sur le stock de patrimoine (IFI…). -/
  patrimoine : Int
  autres : Int
  deriving Repr, DecidableEq, Inhabited

namespace ParImpot

def get (v : ParImpot) : Impot → Int
  | .tva => v.tva
  | .ir => v.ir
  | .csgCrds => v.csgCrds
  | .cotisations => v.cotisations
  | .impotSocietes => v.impotSocietes
  | .accisesEnergie => v.accisesEnergie
  | .taxeFonciere => v.taxeFonciere
  | .droitsMutation => v.droitsMutation
  | .mutationsOnereuses => v.mutationsOnereuses
  | .patrimoine => v.patrimoine
  | .autres => v.autres

def ajouter (v : ParImpot) (i : Impot) (d : Int) : ParImpot :=
  match i with
  | .tva => { v with tva := v.tva + d }
  | .ir => { v with ir := v.ir + d }
  | .csgCrds => { v with csgCrds := v.csgCrds + d }
  | .cotisations => { v with cotisations := v.cotisations + d }
  | .impotSocietes => { v with impotSocietes := v.impotSocietes + d }
  | .accisesEnergie => { v with accisesEnergie := v.accisesEnergie + d }
  | .taxeFonciere => { v with taxeFonciere := v.taxeFonciere + d }
  | .droitsMutation => { v with droitsMutation := v.droitsMutation + d }
  | .mutationsOnereuses => { v with mutationsOnereuses := v.mutationsOnereuses + d }
  | .patrimoine => { v with patrimoine := v.patrimoine + d }
  | .autres => { v with autres := v.autres + d }

def total (v : ParImpot) : Int :=
  v.tva + v.ir + v.csgCrds + v.cotisations + v.impotSocietes + v.accisesEnergie
    + v.taxeFonciere + v.droitsMutation + v.mutationsOnereuses + v.patrimoine + v.autres

/-- La même valeur pour chaque impôt. -/
def uniforme (x : Int) : ParImpot :=
  { tva := x, ir := x, csgCrds := x, cotisations := x, impotSocietes := x, accisesEnergie := x,
    taxeFonciere := x, droitsMutation := x, mutationsOnereuses := x, patrimoine := x, autres := x }

/-- Toutes les composantes sont dans `[lo, hi]`. -/
def toutEntre (v : ParImpot) (lo hi : Int) : Bool :=
  Impot.tous.all fun i => decide (lo ≤ v.get i ∧ v.get i ≤ hi)

/-- Chaque prélèvement croît du même taux (pb), assiettes supposées
proportionnelles au PIB nominal. -/
def croitre (v : ParImpot) (tauxPb : Int) : ParImpot :=
  { tva := v.tva + appliquerPb v.tva tauxPb, ir := v.ir + appliquerPb v.ir tauxPb
    csgCrds := v.csgCrds + appliquerPb v.csgCrds tauxPb
    cotisations := v.cotisations + appliquerPb v.cotisations tauxPb
    impotSocietes := v.impotSocietes + appliquerPb v.impotSocietes tauxPb
    accisesEnergie := v.accisesEnergie + appliquerPb v.accisesEnergie tauxPb
    taxeFonciere := v.taxeFonciere + appliquerPb v.taxeFonciere tauxPb
    droitsMutation := v.droitsMutation + appliquerPb v.droitsMutation tauxPb
    mutationsOnereuses := v.mutationsOnereuses + appliquerPb v.mutationsOnereuses tauxPb
    patrimoine := v.patrimoine + appliquerPb v.patrimoine tauxPb
    autres := v.autres + appliquerPb v.autres tauxPb }

/-- Croissance avec le cycle : chaque prélèvement croît du taux `tauxPb`
(PIB nominal) plus `(ε − 1)` fois `ecartPb` (variation de l'écart de
production), `ε` étant son élasticité à l'écart de production (pm). -/
def croitreCycle (v : ParImpot) (tauxPb ecartPb : Int) (e : ParImpot) : ParImpot :=
  let g (x el : Int) := x + appliquerPb x (tauxPb + (el - 1000) * ecartPb / 1000)
  { tva := g v.tva e.tva, ir := g v.ir e.ir, csgCrds := g v.csgCrds e.csgCrds
    cotisations := g v.cotisations e.cotisations
    impotSocietes := g v.impotSocietes e.impotSocietes
    accisesEnergie := g v.accisesEnergie e.accisesEnergie
    taxeFonciere := g v.taxeFonciere e.taxeFonciere
    droitsMutation := g v.droitsMutation e.droitsMutation
    mutationsOnereuses := g v.mutationsOnereuses e.mutationsOnereuses
    patrimoine := g v.patrimoine e.patrimoine
    autres := g v.autres e.autres }

/-- Chaque prélèvement croît de son propre taux (pb), celui de son
assiette. -/
def croitreTaux (v t : ParImpot) : ParImpot :=
  let g (x r : Int) := x + appliquerPb x r
  { tva := g v.tva t.tva, ir := g v.ir t.ir, csgCrds := g v.csgCrds t.csgCrds
    cotisations := g v.cotisations t.cotisations
    impotSocietes := g v.impotSocietes t.impotSocietes
    accisesEnergie := g v.accisesEnergie t.accisesEnergie
    taxeFonciere := g v.taxeFonciere t.taxeFonciere
    droitsMutation := g v.droitsMutation t.droitsMutation
    mutationsOnereuses := g v.mutationsOnereuses t.mutationsOnereuses
    patrimoine := g v.patrimoine t.patrimoine
    autres := g v.autres t.autres }

/-- Avec un même taux pour tous, `croitreTaux` est `croitre`. -/
theorem croitreTaux_uniforme (v : ParImpot) (t : Int) :
    v.croitreTaux ⟨t, t, t, t, t, t, t, t, t, t, t⟩ = v.croitre t := by
  simp [croitreTaux, croitre]

/-- Avec des élasticités unitaires, `croitreCycle` est la croissance
proportionnelle au PIB (`croitre`), quel que soit le cycle. -/
theorem croitreCycle_unitaire (v : ParImpot) (t c : Int) :
    v.croitreCycle t c ⟨1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000⟩ = v.croitre t := by
  simp [croitreCycle, croitre]

/-- Variation de chaque prélèvement pour une variation `dPib` du niveau du
PIB due à la demande (cyclique) : `ε × dPib / PIB × prélèvement`. -/
def variationCycle (v : ParImpot) (dPib pib : Int) (e : ParImpot) : ParImpot :=
  let d (x el : Int) := if pib = 0 then 0 else x * dPib * el / (pib * 1000)
  { tva := d v.tva e.tva, ir := d v.ir e.ir, csgCrds := d v.csgCrds e.csgCrds
    cotisations := d v.cotisations e.cotisations
    impotSocietes := d v.impotSocietes e.impotSocietes
    accisesEnergie := d v.accisesEnergie e.accisesEnergie
    taxeFonciere := d v.taxeFonciere e.taxeFonciere
    droitsMutation := d v.droitsMutation e.droitsMutation
    mutationsOnereuses := d v.mutationsOnereuses e.mutationsOnereuses
    patrimoine := d v.patrimoine e.patrimoine
    autres := d v.autres e.autres }

/-- Somme terme à terme. -/
def plus (v w : ParImpot) : ParImpot :=
  { tva := v.tva + w.tva, ir := v.ir + w.ir, csgCrds := v.csgCrds + w.csgCrds
    cotisations := v.cotisations + w.cotisations, impotSocietes := v.impotSocietes + w.impotSocietes
    accisesEnergie := v.accisesEnergie + w.accisesEnergie
    taxeFonciere := v.taxeFonciere + w.taxeFonciere
    droitsMutation := v.droitsMutation + w.droitsMutation
    mutationsOnereuses := v.mutationsOnereuses + w.mutationsOnereuses
    patrimoine := v.patrimoine + w.patrimoine, autres := v.autres + w.autres }

theorem total_plus (v w : ParImpot) : (v.plus w).total = v.total + w.total := by
  simp [plus, total]; omega

/-- Répartit `d` au prorata des prélèvements, parts arrondies vers zéro (reste
sur « autres »). -/
def repartir (v : ParImpot) (d : Int) : ParImpot :=
  let t := v.total
  if t = 0 then v.ajouter .autres d else
  let part (x : Int) := if d < 0 then -((-d) * x / t) else d * x / t
  let a := part v.tva
  let b := part v.ir
  let c := part v.csgCrds
  let e := part v.cotisations
  let f := part v.impotSocietes
  let g := part v.accisesEnergie
  let h := part v.taxeFonciere
  let m := part v.droitsMutation
  let o := part v.mutationsOnereuses
  let p := part v.patrimoine
  { tva := v.tva + a, ir := v.ir + b, csgCrds := v.csgCrds + c
    cotisations := v.cotisations + e, impotSocietes := v.impotSocietes + f
    accisesEnergie := v.accisesEnergie + g, taxeFonciere := v.taxeFonciere + h
    droitsMutation := v.droitsMutation + m, mutationsOnereuses := v.mutationsOnereuses + o
    patrimoine := v.patrimoine + p
    autres := v.autres + (d - a - b - c - e - f - g - h - m - o - p) }

end ParImpot

/-! ## Fonctions de dépense (nomenclature COFOG agrégée) -/

inductive Fonction where
  | retraites | sante | famille | enseignement | affairesEconomiques | defense
  | securiteJustice | logementEnvironnement | culture | interets | fonctionnement | nonVentile
  deriving Repr, DecidableEq, Inhabited

namespace Fonction

def tous : List Fonction :=
  [.retraites, .sante, .famille, .enseignement, .affairesEconomiques, .defense,
   .securiteJustice, .logementEnvironnement, .culture, .interets, .fonctionnement, .nonVentile]

def nom : Fonction → String
  | .retraites => "Retraites"
  | .sante => "Santé"
  | .famille => "Famille, chômage, exclusion, handicap"
  | .enseignement => "Enseignement et recherche"
  | .affairesEconomiques => "Affaires économiques, transports"
  | .defense => "Défense"
  | .securiteJustice => "Sécurité et justice"
  | .logementEnvironnement => "Logement, environnement, transition"
  | .culture => "Culture, sport, loisirs"
  | .interets => "Charge d'intérêts"
  | .fonctionnement => "Services généraux, collectivités, UE"
  | .nonVentile => "Non ventilé"

def id : Fonction → String
  | .retraites => "retraites"
  | .sante => "sante"
  | .famille => "famille"
  | .enseignement => "enseignement"
  | .affairesEconomiques => "affairesEconomiques"
  | .defense => "defense"
  | .securiteJustice => "securiteJustice"
  | .logementEnvironnement => "logementEnvironnement"
  | .culture => "culture"
  | .interets => "interets"
  | .fonctionnement => "fonctionnement"
  | .nonVentile => "nonVentile"

/-- Fonctions soumises à une norme de dépense : toutes sauf les transferts
sociaux (retraites, famille-chômage), les priorités (enseignement, défense)
et la charge d'intérêts. -/
def pilotable : Fonction → Bool
  | .sante | .affairesEconomiques | .securiteJustice | .logementEnvironnement | .culture
  | .fonctionnement | .nonVentile => true
  | _ => false

/-- Secteur qui reçoit les emplois d'une dépense de cette fonction (sinon :
au prorata des secteurs). -/
def secteur : Fonction → Option Secteur
  | .sante | .enseignement | .defense | .securiteJustice | .culture => some .tertiaireNonMarchand
  | .logementEnvironnement => some .construction
  | _ => none

end Fonction

/-- Canal de demande d'une dépense selon sa fonction : les retraites et la
famille (prestations, chômage) sont des transferts aux ménages ; le reste,
de la consommation publique (y compris la santé, transferts en nature, et
les affaires économiques : transports, infrastructures et aides, que les
leviers ne distinguent pas ; leur incidence de 0,85 tient compte de la part
des aides, voir `Economie.incidenceDepensePm`). -/
def Fonction.canal : Fonction → Canal
  | .retraites | .famille => .transferts
  | _ => .consommationPublique

/-- Fonction de référence d'un canal de dépense : son incidence vaut
1 000 ‰ dans le canal (le canal des transferts est calé sur les variantes
de pensions ; les autres fonctions y sont pondérées relativement aux
retraites). Sans fonction de référence, l'incidence est prise telle quelle
(consommation publique : dépense générique à 1 000 ‰). -/
def Canal.fonctionReference : Canal → Option Fonction
  | .transferts => some .retraites
  | _ => none

/-- Canal de demande d'un prélèvement : TVA et accises sur la consommation ;
impôt sur les sociétés sur les entreprises (coût d'usage du capital) ; le
reste sur les ménages (« autres impôts » compris, avec leur incidence
propre, voir `Economie.incidencePrelevementPm`). -/
def Impot.canal : Impot → Canal
  | .tva | .accisesEnergie => .taxesConsommation
  | .impotSocietes => .entreprises
  | _ => .prelevementsMenages

/-- Impôt de référence d'un canal : son incidence vaut 1 000 ‰ dans le
canal (les autres impôts du canal sont pondérés relativement à lui). -/
def Canal.impotReference : Canal → Impot
  | .taxesConsommation => .tva
  | .entreprises => .impotSocietes
  | _ => .ir

/-- Un montant par fonction, M€. -/
structure ParFonction where
  retraites : Int
  sante : Int
  famille : Int
  enseignement : Int
  affairesEconomiques : Int
  defense : Int
  securiteJustice : Int
  logementEnvironnement : Int
  culture : Int
  interets : Int
  fonctionnement : Int
  nonVentile : Int
  deriving Repr, DecidableEq, Inhabited

namespace ParFonction

def get (v : ParFonction) : Fonction → Int
  | .retraites => v.retraites
  | .sante => v.sante
  | .famille => v.famille
  | .enseignement => v.enseignement
  | .affairesEconomiques => v.affairesEconomiques
  | .defense => v.defense
  | .securiteJustice => v.securiteJustice
  | .logementEnvironnement => v.logementEnvironnement
  | .culture => v.culture
  | .interets => v.interets
  | .fonctionnement => v.fonctionnement
  | .nonVentile => v.nonVentile

def ajouter (v : ParFonction) (f : Fonction) (d : Int) : ParFonction :=
  match f with
  | .retraites => { v with retraites := v.retraites + d }
  | .sante => { v with sante := v.sante + d }
  | .famille => { v with famille := v.famille + d }
  | .enseignement => { v with enseignement := v.enseignement + d }
  | .affairesEconomiques => { v with affairesEconomiques := v.affairesEconomiques + d }
  | .defense => { v with defense := v.defense + d }
  | .securiteJustice => { v with securiteJustice := v.securiteJustice + d }
  | .logementEnvironnement => { v with logementEnvironnement := v.logementEnvironnement + d }
  | .culture => { v with culture := v.culture + d }
  | .interets => { v with interets := v.interets + d }
  | .fonctionnement => { v with fonctionnement := v.fonctionnement + d }
  | .nonVentile => { v with nonVentile := v.nonVentile + d }

def total (v : ParFonction) : Int :=
  v.retraites + v.sante + v.famille + v.enseignement + v.affairesEconomiques + v.defense
    + v.securiteJustice + v.logementEnvironnement + v.culture + v.interets + v.fonctionnement
    + v.nonVentile

/-- Fonctions dont la dépense bénéficie des gains de productivité de la
robotisation (services généraux, affaires économiques, santé). -/
def _root_.Modele.Fonction.automatisable : Fonction → Bool
  | .sante | .affairesEconomiques | .fonctionnement => true
  | _ => false

/-- Taux de croissance tendanciel d'une fonction, pb : le taux propre à la
fonction (`taux`), moins `robotisationPb` pour les fonctions automatisables
et `moderationPb` pour celles soumises à une norme de dépense
(`Fonction.pilotable`) ; nul pour la charge d'intérêts, calculée à part. -/
def tauxCroissance (f : Fonction) (taux : ParFonction) (robotisationPb : Int) (moderationPb : Int := 0) : Int :=
  match f with
  | .interets => 0
  | _ => taux.get f - (if f.automatisable then robotisationPb else 0)
           - (if f.pilotable then moderationPb else 0)

/-- Chaque fonction sauf la charge d'intérêts croît de son `tauxCroissance`. -/
def croitrePrimaires (v : ParFonction) (taux : ParFonction) (robotisationPb : Int) (moderationPb : Int := 0) :
    ParFonction :=
  let g (f : Fonction) (x : Int) := x + appliquerPb x (tauxCroissance f taux robotisationPb moderationPb)
  { retraites := g .retraites v.retraites, sante := g .sante v.sante, famille := g .famille v.famille
    enseignement := g .enseignement v.enseignement
    affairesEconomiques := g .affairesEconomiques v.affairesEconomiques
    defense := g .defense v.defense, securiteJustice := g .securiteJustice v.securiteJustice
    logementEnvironnement := g .logementEnvironnement v.logementEnvironnement
    culture := g .culture v.culture, interets := v.interets
    fonctionnement := g .fonctionnement v.fonctionnement, nonVentile := g .nonVentile v.nonVentile }

/-- Vecteur de taux construit fonction par fonction. -/
def depuis (g : Fonction → Int) : ParFonction :=
  { retraites := g .retraites, sante := g .sante, famille := g .famille
    enseignement := g .enseignement, affairesEconomiques := g .affairesEconomiques
    defense := g .defense, securiteJustice := g .securiteJustice
    logementEnvironnement := g .logementEnvironnement, culture := g .culture
    interets := g .interets, fonctionnement := g .fonctionnement, nonVentile := g .nonVentile }

theorem depuis_get (g : Fonction → Int) (f : Fonction) : (depuis g).get f = g f := by
  cases f <;> rfl

/-- Toutes les composantes sont dans `[lo, hi]`. -/
def toutEntre (v : ParFonction) (lo hi : Int) : Bool :=
  Fonction.tous.all fun f => decide (lo ≤ v.get f ∧ v.get f ≤ hi)

/-- Cohérence : hors intérêts, `croitrePrimaires` fait croître chaque fonction
exactement de son `tauxCroissance` (utilisé pour indexer les échéanciers). -/
theorem croitrePrimaires_get (v t : ParFonction) (r m : Int) (f : Fonction) (h : f ≠ .interets) :
    (v.croitrePrimaires t r m).get f = v.get f + appliquerPb (v.get f) (tauxCroissance f t r m) := by
  cases f <;> first | exact absurd rfl h | rfl

/-- Cohérence : la norme de dépense retire exactement `m` au taux de
croissance des fonctions pilotables, et rien aux autres. -/
theorem tauxCroissance_norme (f : Fonction) (t : ParFonction) (r m : Int) (h : f ≠ .interets) :
    tauxCroissance f t r m = tauxCroissance f t r 0 - (if f.pilotable then m else 0) := by
  cases f <;> simp_all [tauxCroissance, Fonction.pilotable] <;> omega

end ParFonction

/-- Types de passifs implicites (« dettes cachées ») suivis par le modèle. -/
inductive TypePassif where
  /-- Heures supplémentaires non payées ni récupérées des policiers. -/
  | heuresSupPolice
  /-- Heures supplémentaires non payées ni récupérées à l'hôpital public. -/
  | heuresSupHopital
  /-- Retard d'entretien des infrastructures publiques (ouvrages d'art,
  chaussées, voies navigables) : travaux nécessaires non faits. -/
  | entretienInfrastructures
  deriving Repr, DecidableEq, Inhabited

/-- Un montant par type de passif implicite, M€. -/
structure ParPassif where
  police : Int := 0
  hopital : Int := 0
  infrastructures : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace ParPassif

def get (v : ParPassif) : TypePassif → Int
  | .heuresSupPolice => v.police
  | .heuresSupHopital => v.hopital
  | .entretienInfrastructures => v.infrastructures

def ajouter (v : ParPassif) (t : TypePassif) (d : Int) : ParPassif :=
  match t with
  | .heuresSupPolice => { v with police := v.police + d }
  | .heuresSupHopital => { v with hopital := v.hopital + d }
  | .entretienInfrastructures => { v with infrastructures := v.infrastructures + d }

def total (v : ParPassif) : Int := v.police + v.hopital + v.infrastructures

theorem total_ajouter (v : ParPassif) (t : TypePassif) (d : Int) :
    (v.ajouter t d).total = v.total + d := by
  cases t <;> simp [ajouter, total] <;> omega

end ParPassif

/-- Nature d'une rémunération publique supplémentaire : elle fixe les
prélèvements qui en reviennent aussitôt aux administrations publiques. -/
inductive NatureRemuneration where
  /-- Traitement indiciaire : CSG-CRDS, retenue pour pension, impôt sur le revenu. -/
  | traitement
  /-- Primes et indemnités : CSG-CRDS, RAFP, impôt sur le revenu. -/
  | primes
  /-- Heures supplémentaires : CSG-CRDS ; exonérées d'impôt sur le revenu
  (dans la limite de 7 500 € par an) et de la plupart des cotisations. -/
  | heuresSup
  deriving Repr, DecidableEq, Inhabited

/-- Échéancier d'une dépense : niveaux annuels fixés à l'avance (indemnités
versées jusqu'à la retraite, revalorisations cumulées…), exprimés en euros de
l'année d'entrée en vigueur et indexés sur la croissance tendancielle de leur
fonction. Une fois la liste épuisée, le dernier niveau est conservé. -/
structure Echeance where
  fonction : Fonction
  /-- Secteur qui reçoit l'effet de demande (par défaut : celui de la
  fonction ; la construction pour un investissement). -/
  secteur : Option Secteur := none
  /-- Part de la dépense adressée à la production intérieure, pm ; le reste
  est importé (investissement outre-mer). -/
  partInterieurePm : Int := 1000
  /-- Rémunération d'agents publics déjà en poste : pas de production ni
  d'emplois en plus ; une part revient en prélèvements, le reste soutient la
  consommation des ménages (effet de demande d'un transfert). -/
  remuneration : Option NatureRemuneration := none
  /-- Postes publics créés (levier `creationPostes`) : coût complet d'un poste
  l'année d'entrée en vigueur, €. Chaque variation du niveau crée (ou
  supprime) les emplois publics correspondants, un pour un. -/
  coutParPosteEuros : Option Int := none
  /-- Investissement privé entraîné par une mesure (levier
  `investissementPriveTransition`) : effet de demande et importations, sans
  dépense publique ni canal du capital public. -/
  privee : Bool := false
  /-- Part du niveau, pm, qui remplace une autre dépense privée de l'année
  (équipement fossile qui n'est plus acheté, investissement évincé par le
  financement d'un investissement privé) : retirée de l'effet de demande,
  au contenu importé moyen (levier `investissementTransition`). -/
  substitutionPm : Int := 0
  /-- La dépense crée un équipement public (canal du capital public) ; faux
  pour une aide à l'équipement des ménages et des entreprises. -/
  capitalPublic : Bool := true
  /-- Niveaux des années suivantes, M€ de l'année d'entrée en vigueur. -/
  restants : List Int
  /-- Niveau de l'année, M€ courants. -/
  niveau : Int
  /-- Indice de croissance de la fonction depuis l'entrée en vigueur, base 10 000. -/
  indice : Int
  deriving Repr, DecidableEq, Inhabited

/-- Échéancier d'une recette : impôt (`some i`) ou recette non fiscale
(`none`), niveaux annuels fixés à l'avance (fin de la CRDS avec la CADES,
péages d'autoroutes revenus à l'État…), en euros de l'année d'entrée en
vigueur, indexés sur le PIB nominal comme les assiettes. Le dernier niveau
est conservé une fois la liste épuisée. -/
structure EcheanceRecette where
  impot : Option Impot
  restants : List Int
  niveau : Int
  indice : Int
  deriving Repr, DecidableEq, Inhabited

/-! ## État -/

/-- État du bloc de demande (`Modele/Demande.lean`) d'une année à l'autre. -/
structure EtatDemande where
  /-- Écarts de l'année, des deux années précédentes, et écarts déjà rendus
  effectifs dans l'état (PIB, recettes, emploi). -/
  ecarts : EcartsDemande := {}
  prec : EcartsDemande := {}
  prec2 : EcartsDemande := {}
  appliques : EcartsDemande := {}
  /-- Chocs cumulés des mesures, fin de l'année et fin de l'année précédente. -/
  chocs : ChocsDemande := {}
  chocsPrec : ChocsDemande := {}
  /-- Répartition des chocs par secteur visé (ppm, en valeur absolue), pour
  l'emploi, et leur total. -/
  cibles : List (Secteur × Int) := []
  totalPpm : Int := 0
  deriving Repr, DecidableEq, Inhabited

/-- Suivi de la dette à moyen et long terme par blocs, pour la charge
d'intérêts (`anneeSuivante`). -/
structure BlocsDette where
  /-- Taux de fin d'année de la dette à moyen et long terme en vie au début
  de l'année (refinancement de l'année acquis en entier), ppm ; il sert de
  taux du stock l'année suivante. Avec la convention de mi-année
  (`emissionsMiAnnee`), il diffère du taux moyen de l'année
  (`tauxApparentPpm`) ; 0 = à reprendre de `tauxApparentPpm`. -/
  tauxFinPpm : Int := 0
  /-- Échéancier (`echeancesDettePpm`) : dette à moyen et long terme
  existante au départ, M€ (base de l'échéancier) ; 0 = pas encore fixée
  (situation de départ). -/
  detteExistanteDepartMeur : Int := 0
  /-- Part de cette dette encore en vie en fin d'année, M€. -/
  detteExistanteMeur : Int := 0
  /-- Taux moyen de cette dette encore en vie, ppm. -/
  tauxExistantPpm : Int := 0
  /-- Dette émise depuis le départ encore en vie en fin d'année, hors
  émissions de l'année, M€ : elle se renouvelle à `renouvellementDettePm`. -/
  detteNouvelleRestanteMeur : Int := 0
  /-- Taux moyen de la dette émise depuis le départ, ppm. -/
  tauxNouvellePpm : Int := 0
  deriving Repr, DecidableEq, Inhabited

structure Etat where
  /-- PIB, M€ courants. -/
  pib : Int
  /-- Impôts et cotisations sociales, par prélèvement, M€. -/
  impots : ParImpot
  /-- Recettes non fiscales (ventes, revenus de la propriété…), M€. -/
  autresRecettes : Int
  /-- Dépenses des administrations publiques par fonction, M€, charge
  d'intérêts comprise (fonction `interets`). -/
  depensesF : ParFonction
  /-- Taux d'intérêt apparent de l'année, hors indexation du capital des
  titres indexés : intérêts (hors indexation) / dette de fin d'année
  précédente, pb. La projection le fait évoluer avec la dette nouvelle et la
  part du stock refinancée, émises au taux de l'année (`tauxEmissionPb`). -/
  tauxApparentPb : Int
  /-- Dette publique (Maastricht) à la fin de l'année précédente, M€. La dette
  de fin d'année s'en déduit (`Etat.dette`) : déficit de l'année, opérations
  financières, ajustement de l'année. -/
  detteDebut : Int
  /-- Opérations financières annuelles des administrations publiques (prêts,
  prises de participation), M€/an : elles accroissent la dette sans entrer
  dans le déficit (traitement de Maastricht). -/
  operationsFinancieres : Int
  /-- SMIC mensuel brut, €. -/
  smicMensuel : Int
  /-- Émissions territoriales de gaz à effet de serre par secteur, kt CO₂e
  (hors puits). Le total en Mt : `Etat.emissionsMt`. -/
  emissionsKt : ParSecteurGes
  /-- Âge légal de départ à la retraite, mois. -/
  ageLegalMois : Int
  /-- Population, milliers. -/
  populationMilliers : Int
  /-- Population active au sens du BIT, personnes. -/
  actifs : Int
  /-- Personnes en emploi, par secteur. -/
  emploi : ParSecteur
  /-- Durée annuelle effective du travail par personne en emploi, heures. -/
  heuresParEmploi : Int
  /-- Écart de solde migratoire dû aux mesures, milliers par an (flux porté
  par la projection, positif = plus d'entrées nettes). -/
  migrationAnnuelleMilliers : Int
  /-- Emplois que le programme annonce créer (objectif déclaré, cumulé),
  personnes. Sans effet sur le modèle : sert à vérifier que l'objectif
  tient dans la population active. -/
  emploisAnnonces : Int
  /-- Touristes internationaux accueillis dans l'année, milliers. -/
  touristesMilliers : Int
  /-- Dépense moyenne d'un touriste international pendant son séjour, €. -/
  depenseParTouriste : Int
  /-- Exportations de biens et services, M€ (recettes touristiques comprises). -/
  exportations : Int
  /-- Importations de biens et services, M€. -/
  importations : Int
  /-- Revenus primaires et secondaires nets reçus du reste du monde, M€. -/
  revenusNets : Int
  /-- Variation d'importations due aux mesures, M€ par an (flux porté par la
  projection ; négatif = carburant évité…). -/
  variationImportsAnnuelle : Int
  /-- Accidents du travail avec arrêt pour 10 000 personnes en emploi, par an. -/
  tauxAccidentsPdm : Int
  /-- Gains de productivité par robotisation et automatisation des services,
  pb par an : réduisent la croissance des dépenses de fonctionnement, des
  affaires économiques et de santé (tendance du scénario + mesures). -/
  robotisationPb : Int
  /-- Décès annuels attribuables à la pollution de l'air (particules fines). -/
  decesPollutionAir : Int
  /-- Parc de voitures électriques, milliers. -/
  parcElectriqueMilliers : Int
  /-- Points de recharge ouverts au public, milliers. -/
  bornesMilliers : Int
  /-- Électrification supplémentaire du parc due aux obligations des
  mesures, milliers de véhicules par an (flux porté par la projection). -/
  electrificationAnnuelleMilliers : Int
  /-- Voitures aidées par les mesures, milliers par an, pondérées par la part
  qu'une aide rend électrique (`fractionReponsePm`) ; la projection en retire
  chaque année la part des ventes déjà électrique (aubaine). -/
  electrificationAideePondereeMilliers : Int := 0
  /-- Bornes supplémentaires dues aux mesures, milliers par an. -/
  bornesAnnuellesMilliers : Int
  /-- Part de la dette émise en OAT numériques (titres tokenisés réglés en
  jetons de monnaie électronique), pm de la dette. Nulle sans mesure. -/
  partDetteNumeriquePm : Int := 0
  /-- Part cible des OAT numériques, pm de la dette (flux porté). -/
  cibleDetteNumeriquePm : Int := 0
  /-- Hausse annuelle de la part des OAT numériques, pm (flux porté). -/
  rythmeDetteNumeriquePm : Int := 0
  /-- Décote du taux servi sur la tranche numérique, pm du taux apparent :
  part de l'exonération fiscale capitalisée dans le prix des titres. -/
  decoteDetteNumeriquePm : Int := 0
  /-- Part des intérêts de la tranche numérique qui, sans exonération,
  auraient été imposés au prélèvement forfaitaire unique, pm. -/
  partDefiscaliseePm : Int := 0
  /-- Économie d'intérêts de l'année due à la décote, M€ (suivi). -/
  economieInteretsNumeriqueMeur : Int := 0
  /-- Recettes de PFU perdues dans l'année du fait de l'exonération, M€
  (déjà retranchées des impôts ; mémorisées pour la projection). -/
  pertePfuMeur : Int := 0
  /-- Écart entre l'emploi d'équilibre et l'emploi effectif dû aux chocs
  d'offre de travail des mesures (migrations, âge de départ, réallocations
  par automatisation), personnes : emploi d'équilibre = taux d'emploi
  d'avant le choc × variation de la population active. Résorbé chaque année
  au taux `absorptionChomagePm` du scénario. -/
  chomeursExcedentaires : Int := 0
  /-- Emplois encore à venir des variations du coût du travail dues aux
  mesures (allègements de cotisations par tranche), personnes : la demande
  de travail s'ajuste progressivement (`ajustementCoutTravailPm`). -/
  emploisCoutTravailRestants : Int := 0
  /-- Canal du capital public (moteurs qui l'activent, `Moteur.canalCapitalPm`) :
  investissement public annuel du levier `investissement`, par fonction, M€
  courants (reconduit au rythme de la dépense de la fonction, norme
  comprise ; les échéanciers de construction sont lus sur leurs échéances) ;
  stock de capital public constitué par les mesures, net de la dépréciation,
  M€ courants ; effet sur le PIB potentiel déjà appliqué, ppm du PIB (avant
  pondération par le moteur). -/
  investissementPublicMesures : ParFonction := ParFonction.depuis (fun _ => 0)
  capitalPublicMesures : Int := 0
  effetCapitalPublicPpm : Int := 0
  /-- Écart de PIB dû aux effets de demande des mesures (bloc de demande,
  résorption du moteur comprise), M€ courants, indexé sur le PIB nominal ;
  il entre dans l'écart de production du solde structurel. -/
  ecartDemandeMeur : Int := 0
  /-- État du bloc de demande (`Modele/Demande.lean`). -/
  demande : EtatDemande := {}
  /-- Écart de production cumulé dû à la trajectoire du scénario (croissance
  en volume moins croissance potentielle, années passées), pb du PIB ; avec
  l'écart de départ et les effets de demande des mesures, il forme l'écart
  de production (`Etat.ecartProductionPb`), dont dépendent l'inflation
  (courbe de Phillips) et le solde structurel. -/
  ecartCycleScenarioPb : Int := 0
  /-- Taux marginal maximal d'imposition d'un revenu, toutes impositions
  confondues (impôt sur le revenu, contribution exceptionnelle sur les hauts
  revenus, CSG-CRDS ou prélèvements sociaux), pm. Départ : 554 pour un
  salaire (barème à 45 %, contribution de 4 % au-delà de 500 000 €, CSG-CRDS
  de 9,7 % dont 6,8 points déductibles : 9,7 + 49 × (1 − 0,068) ≈ 55,4 %,
  calcul ; hors cotisations) ; 340 pour un revenu du capital (prélèvement
  forfaitaire de 30 % et contribution de 4 %). Les mesures le relèvent par
  le levier `tauxMarginalSommet` (déclaratif : le modèle ne connaît pas les
  barèmes). -/
  tauxMarginalSommetPm : Int := 554
  /-- Articles de la Constitution dont le programme déclare qu'il doit les
  réviser (levier `revisionConstitution`). -/
  revisionsConstitution : List String := []
  /-- Canal du capital des entreprises : écart du taux effectif d'IS fixé par
  les mesures au taux du scénario, pb ; variation des recettes d'IS due à ce
  taux (réponse de l'assiette comprise), M€ courants, qui croît comme l'IS ;
  effet sur le PIB potentiel déjà appliqué, ppm du PIB (avant pondération
  par le moteur). -/
  ecartTauxISPb : Int := 0
  isTauxMeur : Int := 0
  /-- Effet du prix du pétrole déjà appliqué aux émissions des transports et
  des bâtiments, ppm du niveau (voir `Projection.emissionsSuivantes`). -/
  effetPrixTransportsPpm : Int := 0
  effetPrixBatimentsPpm : Int := 0
  /-- Prélèvements dus aux hausses du SMIC (allègements en plus, nets des
  cotisations, de la CSG et de l'impôt sur les salaires), M€ courants,
  indexés sur le PIB nominal : ils compensent le coût du travail, dont
  l'effet sur l'emploi est compté à part, et ne sont pas une baisse
  d'impôt pour l'effet générique des prélèvements (moteur d'offre). -/
  smicPrelevementsMeur : Int := 0
  effetCapitalPrivePpm : Int := 0
  /-- Indice des prix (base 10 000 l'année de départ) : déflate le PIB pour le
  RNB par habitant en volume de l'IDH. -/
  indicePrix : Int := 10000
  /-- Espérance de vie à la naissance tendancielle, centièmes d'année (hors
  effets des mesures). -/
  esperanceVieTendanceCentiemes : Int := 0
  /-- Dépense de santé qu'aurait donnée la seule tendance (croissance
  tendancielle de la fonction, sans mesure ni norme de dépense), M€ :
  référence du lien dépense de santé → espérance de vie. -/
  depenseSanteTendanceMeur : Int := 0
  /-- Années de vie gagnées chaque année grâce aux mesures (décès évités ×
  années de vie que chacun aurait perdues), années. -/
  anneesVieGagneesParAn : Int := 0
  /-- Durée attendue de scolarisation, et durée moyenne de scolarisation des
  25 ans et plus, centièmes d'année (IDH). -/
  dureeAttendueCentiemes : Int := 0
  dureeMoyenneCentiemes : Int := 0
  /-- Indice de développement humain de l'année, millionièmes (calculé). -/
  idhMillioniemes : Int := 0
  /-- Santé publique : baisse visée par les mesures des décès attribuables à
  chaque cause, et baisse atteinte (elle rejoint la cible au rythme du délai
  d'effet de la cause), pm. -/
  baisseMortaliteCiblePm : ParCause := {}
  baisseMortaliteAtteintePm : ParCause := {}
  /-- Les mêmes, pondérés par le coût du travail par emploi de leur tranche
  rapporté à la moyenne (un emploi au voisinage du SMIC produit moins qu'un
  emploi moyen) : base de l'effet sur le PIB, personnes. -/
  emploisPonderesCoutTravailRestants : Int := 0
  /-- Allègements généraux de cotisations patronales en vigueur, par tranche
  de salaire, M€ (indexés sur le PIB nominal ; déjà retranchés des
  cotisations). -/
  allegementsTranche : ParTranche := {}
  /-- Dépense d'assurance chômage due au franchissement du seuil de chômage
  des règles contracycliques (complément de fin de droits), M€ (suivi). -/
  complementChomageMeur : Int := 0
  /-- Norme de dépense : moindre croissance annuelle des fonctions pilotables
(`Fonction.pilotable`), pb. -/
  moderationDepensesPb : Int := 0
  /-- Plafond de la modération appliquée à la santé par les normes de
  dépense, pb par an (0 : pas de plafond ; levier `plafondNormeSante`). -/
  plafondModerationSantePb : Int := 0
  /-- Frein automatique au déficit (levier `freinDeficit`) : seuil de déficit,
  pb du PIB, au-delà duquel la norme de dépense est durcie l'année suivante
  (le frein est actif dès que `freinDeficitPb` n'est pas nul). -/
  freinDeficitSeuilPb : Int := 0
  /-- Durcissement de la norme de dépense, pb, l'année qui suit un déficit
  au-dessus du seuil. -/
  freinDeficitPb : Int := 0
  /-- Taux marginal de l'année (taux du scénario corrigé de la prime de risque
  liée au déficit), pb (suivi). -/
  tauxMarginalCourantPb : Int := 0
  /-- Taux moyen auquel la dette est émise dans l'année (nominale au taux
  marginal, indexée au taux réel), pb : celui de la dette nouvelle et de la
  part refinancée du stock. -/
  tauxEmissionPb : Int := 0
  /-- Taux apparent de la dette à moyen et long terme, ppm (1 pb = 100 ppm) :
  précision portée par la projection, la charge d'intérêts d'un stock de
  ≈ 4 700 Md€ sautant de ≈ 470 M€ par pb d'arrondi ; 0 = à reprendre de
  `tauxApparentPb` (situation de départ, rétro-test). -/
  tauxApparentPpm : Int := 0
  /-- Taux d'émission de l'année, ppm ; 0 = à reprendre de `tauxEmissionPb`. -/
  tauxEmissionPpm : Int := 0
  /-- Suivi de la dette à moyen et long terme par blocs (taux de fin
  d'année, échéancier : voir `BlocsDette`). -/
  blocsDette : BlocsDette := {}
  /-- Écart de l'année entre variation de la dette et déficit qui ne relève
  pas des opérations financières suivies (trésorerie, primes d'émission…),
  M€ : observé pour l'année de départ, nul ensuite. -/
  ajustementDetteAnnee : Int := 0
  /-- Dépenses à échéancier en cours (voir `Echeance`). -/
  echeances : List Echeance := []
  /-- Recettes à échéancier en cours (voir `EcheanceRecette`). -/
  echeancesRecettes : List EcheanceRecette := []
  /-- Valeur des participations de l'État dans les entreprises, M€. Elle suit
  le PIB nominal, plus les prises de participation. -/
  participationsEtat : Int := 0
  /-- Dividendes reçus par l'État, M€ : compris dans `autresRecettes`. Ils
  valent `participationsEtat` × rendement du portefeuille de départ. -/
  dividendesEtat : Int := 0
  /-- Prises de participation annuelles dues aux mesures, M€/an (flux porté) :
  elles accroissent la dette sans entrer dans le déficit (opérations
  financières) et augmentent le portefeuille. -/
  investissementsParticipations : Int := 0
  /-- Placement de l'excédent (levier `placementExcedent`) : part de
  l'excédent budgétaire de l'année précédente placée, pm (0 : inactif), et
  part de ce placement consacrée au rachat d'or, le reste à des prises de
  participation ; plafond cumulé du rachat d'or, M€. -/
  placementExcedentPm : Int := 0
  partOrPlacementPm : Int := 0
  plafondOrRacheteMeur : Int := 0
  /-- Placements de l'année écoulée (or, participations), M€, et or racheté
  cumulé, M€ : opérations financières, dans la dette, pas dans le déficit. -/
  placementOrAnnee : Int := 0
  placementParticipationsAnnee : Int := 0
  orRacheteMeur : Int := 0
  /-- Calendrier légal de l'âge de départ : hausses des années suivantes,
  mois par an (tête = année prochaine). -/
  calendrierAgeLegal : List Int := []
  /-- Hausses d'âge dont les effets (dépenses de retraite, population active)
  sont déjà dans la tendance du scénario, mois par an. La projection
  n'applique les effets que de l'écart entre les deux calendriers. -/
  calendrierAgeTendanciel : List Int := []
  /-- Ventes tendancielles de voitures électriques neuves de l'année,
  milliers (flux porté par la projection). -/
  electrificationTendanceMilliers : Int := 0
  /-- Contribution différentielle sur les hauts revenus, M€ (comprise dans
  `impots.ir`) : due jusqu'à ce que le déficit public passe sous 3 % du PIB
  (loi n° 2025-127) ; la projection la supprime l'année qui suit. -/
  cdhrMeur : Int := 0
  /-- Décès de l'année, milliers (montent de `hausseDecesMilliers` par an). -/
  decesMilliers : Int := 0
  /-- Économies annuelles de fioul et de gaz dues aux rénovations
  supplémentaires des mesures, MWh par an (flux porté par la projection :
  chaque année ajoute ce volume aux économies déjà acquises). -/
  economiesFioulMWhAnnuelles : Int := 0
  economiesGazMWhAnnuelles : Int := 0
  /-- Chômeurs déjà couverts par les dépenses d'indemnisation inscrites
  (stabilisateur automatique : la projection ajuste ces dépenses à l'écart
  avec le nombre courant de chômeurs). -/
  chomeursComptes : Int := 0
  /-- Passifs implicites des administrations publiques (« dettes cachées ») :
  obligations nées mais non payées ni inscrites dans la dette de
  Maastricht, par type, M€. -/
  passifs : ParPassif := {}
  /-- Nouveaux passifs implicites accumulés chaque année, par type, M€/an
  (flux porté, indexé sur le PIB nominal). -/
  fluxPassifs : ParPassif := {}
  /-- Inflation des prix à la consommation de l'année, pb : base de la
  revalorisation des pensions et des prestations l'année suivante. -/
  inflationConsoPb : Int := 0
  /-- Rang de l'année dans la projection (0 = année de départ) : indexe les
  trajectoires de l'axe économique (`Economie.croissanceVolumeA`…). -/
  rang : Nat := 0
  /-- Part de la charge d'intérêts de l'année due à l'indexation du capital
  des titres indexés sur l'inflation, M€ (comprise dans `depensesF.interets`). -/
  chargeIndexationMeur : Int := 0
  /-- Rémunération moyenne par emploi, € par an : rémunération des salariés
  de la comptabilité nationale (salaires bruts et cotisations des
  employeurs) rapportée à l'emploi total. Avec l'emploi, elle donne la masse
  salariale (`masseSalariale`), assiette des cotisations, de la CSG sur les
  revenus d'activité et de l'impôt sur le revenu des salaires : toute
  variation de l'emploi, quelle qu'en soit la cause, change l'assiette. -/
  remunerationParEmploiEuros : Int := 0
  /-- Dépense de consommation finale des ménages, M€ : assiette de la TVA. -/
  consommationMenages : Int := 0
  /-- Croissance du bénéfice fiscal (assiette de l'impôt sur les sociétés)
  de l'exercice de l'année, pb : l'IS des deux années suivantes en dépend
  (acomptes calculés sur l'exercice précédent, solde l'année suivante). -/
  croissanceBeneficePb : Int := 0
  /-- Même croissance, l'exercice d'avant, pb. -/
  croissanceBeneficeAvantPb : Int := 0
  /-- Capacités installées de production d'électricité, MW. -/
  capacitesMw : ParFiliere := {}
  /-- Capacités ajoutées chaque année par les mesures, MW/an (flux porté ;
  négatif : moins d'installations que la tendance). -/
  ajoutsCapaciteMw : ParFiliere := {}
  /-- Part de `ajoutsCapaciteMw.solaire` posée sur des toitures ou des
  ombrières (sans emprise au sol), MW/an. -/
  ajoutsToitureMw : Int := 0
  /-- Production d'électricité de l'année, par filière, GWh. -/
  productionGwh : ParFiliere := {}
  /-- Production nucléaire écartée faute de débouchés (consommation et
  plafond du solde exportateur), GWh. -/
  modulationGwh : Int := 0
  /-- Priorité au nucléaire (levier `prioriteNucleaire`) : la production en
  surplus est écrêtée sur le solaire puis l'éolien, le nucléaire n'est
  modulé qu'ensuite. -/
  prioriteNucleaire : Bool := false
  /-- Production renouvelable écrêtée faute de débouchés, GWh. -/
  ecretementGwh : Int := 0
  /-- Coût complet moyen de l'électricité pour les entreprises l'année
  écoulée, €/MWh hors TVA (`Electricite.prixEntreprisesEurosMWh`) ; 0 avant
  la première projection. -/
  prixElectriciteEntreprisesEurosMWh : Int := 0
  /-- Emplois industriels gagnés (perdus) par le facteur d'implantation lié
  au prix réel de l'électricité, cumul (niveau atteint). -/
  emploisImplantationsEnergie : Int := 0
  /-- Consommation d'électricité hors voitures électriques et hors mesures,
  GWh (tendance du scénario). -/
  consommationBaseGwh : Int := 0
  /-- Consommation d'électricité ajoutée par les mesures, GWh/an (niveau). -/
  consommationMesuresGwh : Int := 0
  /-- Électricité restituée par les stockages des mesures à la place de la
  production thermique fossile, GWh/an (levier `stockageElectrique`). -/
  dechargeStockageGwh : Int := 0
  /-- Consommation d'électricité de l'année, GWh : base, voitures
  électriques du parc, mesures. -/
  consommationGwh : Int := 0
  /-- Surfaces consommées depuis le 1er janvier 2021 (début de la première
  tranche du ZAN), par destination, ha. -/
  surfacesHa : ParDestination := {}
  /-- Surfaces consommées dans l'année, ha. -/
  surfacesAnneeHa : ParDestination := {}
  /-- Surfaces que les mesures consommeront, ha, année par année (élément 0 :
  prochaine année projetée) ; sous le ZAN, elles s'imputent sur
  l'enveloppe. -/
  surfacesMesuresHa : List ParDestination := []
  /-- Surfaces que les mesures consommeront hors de l'enveloppe du ZAN
  (exemption légale), ha, année par année (élément 0 : prochaine année). -/
  surfacesHorsZanMesuresHa : List ParDestination := []
  /-- Espaces naturels, agricoles et forestiers consommés hors enveloppe
  depuis 2021, ha (compris dans `surfacesHa`, exclus du décompte du ZAN). -/
  surfacesHorsZanHa : Int := 0
  /-- Hausse annuelle de la consommation d'électricité due aux pompes à
  chaleur des mesures, GWh (flux porté : chaque année l'ajoute à
  `consommationMesuresGwh`). -/
  consommationPacHausseGwh : Int := 0
  /-- Logements qui quittent le gaz chaque année grâce aux mesures (flux
  porté). -/
  deraccordementsGazParAn : Int := 0
  /-- Écart au régime de zéro artificialisation nette choisi par les
  mesures, pm : 0 = ZAN en vigueur, 1000 = abrogé (consommation d'espaces de
  la décennie précédant la loi). -/
  ecartZanPm : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace Etat

/-- Masse salariale (rémunération des salariés), M€ : emploi × rémunération
moyenne par emploi. -/
def masseSalariale (s : Etat) : Int := s.emploi.total * s.remunerationParEmploiEuros / 1000000

/-- Recettes des administrations publiques, M€. -/
def recettes (s : Etat) : Int := s.impots.total + s.autresRecettes

/-- Dépenses des administrations publiques, M€, charge d'intérêts comprise. -/
def depenses (s : Etat) : Int := s.depensesF.total

/-- Intérêts versés sur la dette, M€. -/
def chargeInterets (s : Etat) : Int := s.depensesF.interets

/-- Heures travaillées dans l'année, millions d'heures. -/
def heuresTotales (s : Etat) : Int := s.emploi.total * s.heuresParEmploi / 1000000

/-- PIB par heure travaillée, €. -/
def pibParHeure (s : Etat) : Int :=
  if s.heuresTotales ≤ 0 then 0 else s.pib * 1000000 / (s.emploi.total * s.heuresParEmploi / 1000)
    / 1000

/-- Emplois en équivalent temps plein (1 607 h), personnes. -/
def emploisEtp (s : Etat) : Int := s.emploi.total * s.heuresParEmploi / 1607

/-- Emploi maximal compatible avec le chômage frictionnel `fricPb`, personnes. -/
def emploiMaximal (s : Etat) (fricPb : Int) : Int := s.actifs * (10000 - fricPb) / 10000

/-- Recettes du tourisme international, M€ (exportations de voyages). -/
def recettesTourisme (s : Etat) : Int := s.touristesMilliers * s.depenseParTouriste / 1000

/-- Accidents du travail avec arrêt dans l'année. -/
def accidentsTravail (s : Etat) : Int := s.emploi.total * s.tauxAccidentsPdm / 10000

/-- Coût annuel des accidents du travail (indemnités, soins, rentes), M€,
pour un coût unitaire donné en €. -/
def coutAccidentsTravail (s : Etat) (coutUnitaire : Int) : Int :=
  s.accidentsTravail * coutUnitaire / 1000000

/-- Journées de travail perdues par accidents, milliers. -/
def joursPerdusAccidents (s : Etat) (joursParAccident : Int) : Int :=
  s.accidentsTravail * joursParAccident / 1000

/-- Décès au travail dans l'année, pour une létalité donnée en décès pour
10 000 accidents. -/
def decesTravail (s : Etat) (letalitePdm : Int) : Int :=
  s.accidentsTravail * letalitePdm / 10000

/-- Balance commerciale (biens et services), M€. -/
def balanceCommerciale (s : Etat) : Int := s.exportations - s.importations

/-- Solde des transactions courantes (balance des paiements), M€. -/
def balanceCourante (s : Etat) : Int := s.balanceCommerciale + s.revenusNets

/-- Solde courant en pb du PIB. -/
def balanceCourantePb (s : Etat) : Int := ratioPb s.balanceCourante s.pib

/-- Heures travaillées par habitant et par an. -/
def heuresParHabitant (s : Etat) : Int :=
  if s.populationMilliers ≤ 0 then 0 else s.emploi.total * s.heuresParEmploi / (s.populationMilliers * 1000)

/-- Déficit public, M€ (positif = déficit). -/
def deficit (s : Etat) : Int := s.depenses - s.recettes

/-- Taux de prélèvements obligatoires, pb du PIB. -/
def prelevementsPb (s : Etat) : Int := ratioPb s.impots.total s.pib

/-- Dépenses hors charge d'intérêts, M€. -/
def depensesPrimaires (s : Etat) : Int := s.depenses - s.chargeInterets

/-- Solde primaire, M€ (positif = excédent). -/
def soldePrimaire (s : Etat) : Int := s.recettes - s.depensesPrimaires

/-- Déficit en pb du PIB. -/
def deficitPb (s : Etat) : Int := ratioPb s.deficit s.pib


/-- Dette publique (Maastricht) en fin d'année, M€ : celle de fin d'année
précédente, plus le déficit de l'année (mesures comprises), les opérations
financières et l'ajustement dette-déficit de l'année. -/
def dette (s : Etat) : Int :=
  s.detteDebut + s.deficit + s.operationsFinancieres + s.investissementsParticipations
    + s.placementOrAnnee + s.placementParticipationsAnnee + s.ajustementDetteAnnee

/-- Émissions totales, Mt CO₂e (arrondi au Mt le plus proche). -/
def emissionsMt (s : Etat) : Int := (s.emissionsKt.total + 500) / 1000

/-- Émissions d'un secteur, Mt CO₂e (arrondi). -/
def emissionsSecteurMt (s : Etat) (sec : SecteurGes) : Int := (s.emissionsKt.get sec + 500) / 1000

/-- Réduit les émissions du secteur `sec` de `kt` kilotonnes (négatif : hausse). -/
def reduireEmissions (sec : SecteurGes) (kt : Int) (s : Etat) : Etat :=
  { s with emissionsKt := s.emissionsKt.ajouter sec (-kt) }

theorem reduireEmissions_total (sec : SecteurGes) (kt : Int) (s : Etat) :
    (s.reduireEmissions sec kt).emissionsKt.total = s.emissionsKt.total - kt := by
  simp [reduireEmissions, ParSecteurGes.total_ajouter]
  omega

/-- Passifs implicites, tous types, M€. -/
def passifsImplicites (s : Etat) : Int := s.passifs.total

/-- Dette y compris passifs implicites, en pb du PIB. -/
def detteEtenduePb (s : Etat) : Int := ratioPb (s.dette + s.passifsImplicites) s.pib

/-- Dette en pb du PIB. -/
def dettePb (s : Etat) : Int := ratioPb s.dette s.pib

/-- Identité dette-déficit : la dette de fin d'année est celle de fin
d'année précédente plus le déficit, les opérations financières et
l'ajustement de l'année. -/
theorem dette_identite (s : Etat) :
    s.dette - s.detteDebut = s.deficit + s.operationsFinancieres + s.investissementsParticipations
      + s.placementOrAnnee + s.placementParticipationsAnnee + s.ajustementDetteAnnee := by
  simp [dette]; omega

/-- Emploi total, personnes. -/
def emploiTotal (s : Etat) : Int := s.emploi.total

/-- Taux de chômage au sens du BIT, pb (`750` = 7,5 %) : part des actifs
sans emploi. -/
def chomagePb (s : Etat) : Int :=
  if s.actifs ≤ 0 then 0 else (s.actifs - s.emploiTotal) * 10000 / s.actifs

/-- PIB par habitant, €. -/
def pibParHabitant (s : Etat) : Int :=
  if s.populationMilliers = 0 then 0 else s.pib * 1000 / s.populationMilliers

/-- Ajoute `d` aux recettes, au prorata de toutes les recettes (variation
d'assiette générale, par exemple un surcroît d'activité). -/
def ajouterRecettesProrata (s : Etat) (d : Int) : Etat :=
  let r := s.recettes
  let dImpots := if r = 0 then 0 else d * s.impots.total / r
  { s with impots := s.impots.repartir dImpots, autresRecettes := s.autresRecettes + (d - dImpots) }

end Etat

end Modele
