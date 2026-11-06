import Programmes
import Moteurs
import Lean.Data.Json

/-!
# Rapport d'évaluation

`lake exe rapport [--json FICHIER] [--md FICHIER]`

Calcule la matrice programme × scénario × propriété et l'état des
engagements, puis écrit :
* un JSON stable (comparé entre la branche de base et la PR par
  `scripts/diff_rapport.py`) ;
* un Markdown lisible (résumé de job CI, commentaire de PR).

Le rapport ne dépend **pas** de `Engagements` : il se construit même quand un
engagement est cassé, et c'est lui qui dit lequel.

Code de sortie : 0 si la structure est saine, 1 en cas d'identifiants
dupliqués ou de scénario invalide (erreurs de registre).
-/

open Modele Lean

namespace Rapport

/-! ## Mise en forme -/

/-- `581` (pb) ↦ `"5,81"`. -/
def fmtPb (x : Int) : String :=
  let signe := if x < 0 then "-" else ""
  let a := x.natAbs
  let frac := toString (a % 100)
  let frac := if frac.length < 2 then "0" ++ frac else frac
  s!"{signe}{a / 100},{frac}"

def coche (b : Bool) : String := if b then "✅" else "❌"

/-- Pastille de la part des scénarios où une propriété tient, en dégradé du
rouge (aucun scénario) au vert (tous) en passant par l'orange (la moitié).
Les tableaux Markdown de GitHub n'acceptent pas de couleur de fond : quatre
paliers d'émojis ; les PDF de synthèse ont le dégradé continu. -/
def pastille (k n : Nat) : String :=
  if n = 0 then "" else
  if k = n then "🟩" else if 3 * n ≤ 4 * k then "🟨" else if n ≤ 4 * k then "🟧" else "🟥"

def legendePastilles : String :=
  "🟥 moins d'un quart des scénarios · 🟧 d'un quart à trois quarts · 🟨 trois quarts ou plus · 🟩 tous"

theorem pastille_paliers :
    pastille 0 36 = "🟥" ∧ pastille 8 36 = "🟥" ∧ pastille 9 36 = "🟧" ∧ pastille 18 36 = "🟧" ∧
    pastille 27 36 = "🟨" ∧ pastille 35 36 = "🟨" ∧ pastille 36 36 = "🟩" := by decide

def ligne (cellules : List String) : String :=
  "| " ++ " | ".intercalate cellules ++ " |"

def separateur (n : Nat) : String :=
  ligne (List.replicate n "---")

/-- `1218750` ↦ `"1 218 750 €"` (espace fine insécable). -/
def fmtEuros (x : Int) : String :=
  let chiffres := (toString x.natAbs).toList
  let groupes := (chiffres.reverse.toArray.toList.foldl (fun (acc : List (List Char)) ch =>
    match acc with
    | g :: rest => if g.length < 3 then (ch :: g) :: rest else [ch] :: g :: rest
    | [] => [[ch]]) []).map String.ofList
  (if x < 0 then "-" else "") ++ " ".intercalate groupes ++ " €"

/-- Coefficient en pm ↦ `"×1,48"`. -/
def fmtCoef (pm : Int) : String :=
  let frac := toString ((pm.natAbs % 1000) / 10)
  s!"×{pm.natAbs / 1000},{if frac.length < 2 then "0" ++ frac else frac}"

/-! ## Calculs -/

structure Evaluation where
  moteur : Moteur
  scenario : Scenario
  tendanciel : Etat
  avec : Etat
  /-- Chaque propriété est évaluée à son année propre (`Propriete.horizon`). -/
  resultats : List (Propriete × Bool)

def evaluer (M : Moteur) (p : Programme) (H : Scenario) : Evaluation :=
  { moteur := M, scenario := H, tendanciel := tendanciel M H, avec := p.resultat M H
    resultats := Proprietes.toutes.map fun q => (q, decide (p.Verifie M H q)) }

def engagementTenu (p : Programme) (e : Engagement) : Bool :=
  decide (p.Verifie e.moteur e.scenario e.propriete)

def moteurs : List Moteur := Moteurs.tous
def standard : Moteur := Hypotheses.Moteurs.standard

/-- Variantes du bloc de demande exportées pour les synthèses : un point de
PIB par canal (demande mondiale : +1 %). -/
def variantesDemande : List (String × String × ChocsDemande) := [
  ("investissement", "Investissement public", { investissement := 10000 }),
  ("consommationPublique", "Consommation publique", { consoPublique := 10000 }),
  ("transferts", "Transferts et prélèvements sur les ménages", { revenu := 10000 }),
  ("taxesConsommation", "TVA et accises", { taxesConsommation := 10000 }),
  ("coutTravail", "Coût du travail (sans les emplois du levier)", { coutTravail := 10000 }),
  ("entreprises", "Impôt sur les sociétés et aides", { entreprises := 10000 }),
  ("demandeMondiale", "Demande mondiale (+1 %)", { demandeMondiale := 10000 }) ]

/-- Conflit de cohérence interne (voir `Modele.Coherence`). -/
def conflitJson (c : Conflit) : Json :=
  Json.mkObj [("nature", toJson c.nature.id), ("reglage", toJson c.reglage.id),
    ("reglageNom", toJson c.reglage.nom), ("mesures", toJson [c.mesure1, c.mesure2]),
    ("valeurs", toJson [c.valeur1, c.valeur2])]

/-- Cohérence interne du programme : conflits non arbitrés, conflits
arbitrés avec la raison de l'auteur, arbitrages devenus sans objet. -/
def coherenceJson (p : Programme) : Json :=
  Json.mkObj [("coherent", toJson p.coherent),
    ("conflits", Json.arr (p.conflits.toArray.map conflitJson)),
    ("arbitres", Json.arr <| p.conflitsArbitres.toArray.map fun (c, r) =>
      Json.mkObj [("conflit", conflitJson c), ("raison", toJson r)]),
    ("arbitragesSansObjet", Json.arr <| p.arbitragesSansObjet.toArray.map fun a =>
      Json.mkObj [("mesures", toJson [a.mesure1, a.mesure2]), ("raison", toJson a.raison)])]

/-- Une ligne lisible par conflit : « O1 (114) / O4 (-103) — sens opposés :
durée du travail ». -/
def conflitTexte (c : Conflit) : String :=
  let quoi := match c.nature with
    | .valeurs => "deux valeurs différentes"
    | .sens => "sens opposés"
  s!"{c.mesure1} ({c.valeur1}) / {c.mesure2} ({c.valeur2}) — {quoi} : {c.reglage.nom}"

/-- Contrats des mesures : (mesure, titre). Ils sont prouvés par
construction : un contrat faux empêche la compilation. -/
def contrats (p : Programme) : List (String × String) :=
  p.mesures.flatMap fun m => m.contrats.map fun k => (m.id, k.titre)

/-- Mesures utilisant le levier `amendeSRU`, avec leur barème. -/
def baremesSRU (p : Programme) : List (String × BaremeSRU) :=
  p.mesures.flatMap fun m => m.leviers.filterMap fun
    | .amendeSRU b => some (m.id, b)
    | _ => none

structure LigneSRU where
  commune : Commune
  actuel : Int
  maxActuel : Int
  amende : Int
  plafonnee : Bool

def panelSRU (b : BaremeSRU) : List LigneSRU :=
  Hypotheses.Communes.panel.map fun c =>
    { commune := c, actuel := SRU.prelevementActuel c
      maxActuel := SRU.majorationMaxActuelle Hypotheses.Communes.medianePFH c
      amende := b.amende c
      plafonnee := decide (c.plafond b.plafondPb < b.brut c) }

/-- Variantes SRU des mesures : (mesure, nom de la variante, barème). -/
def variantesSRU (p : Programme) : List (String × String × BaremeSRU) :=
  p.mesures.flatMap fun m => m.variantes.flatMap fun v => v.leviers.filterMap fun
    | .amendeSRU b => some (m.id, v.nom, b)
    | _ => none

/-- Remplacements de véhicules : (mesure, version, opération), version
retenue puis variantes. -/
def remplacements (p : Programme) : List (String × String × Remplacement) :=
  p.mesures.flatMap fun m =>
    (m.leviers.filterMap fun
      | .remplacementVehicules r => some (m.id, "retenue", r)
      | _ => none) ++
    (m.variantes.flatMap fun v => v.leviers.filterMap fun
      | .remplacementVehicules r => some (m.id, v.nom, r)
      | _ => none)

/-- Centimes ↦ `"-166,6 M€"` (arrondi au dixième). -/
def fmtMEurosCts (cts : Int) : String :=
  let d := (cts.natAbs + 5000000) / 10000000
  s!"{if cts < 0 && d > 0 then "-" else ""}{d / 10},{d % 10} M€"

def equilibreTexte (h : HypAuto) (r : Remplacement) : String :=
  match r.anneeEquilibre h with
  | some n => s!"{n} ans"
  | none => "jamais"

/-- Identifiants présents plusieurs fois dans une liste. -/
def doublons (ids : List String) : List String :=
  (ids.filter fun i => (ids.filter (· == i)).length > 1).eraseDups

def erreursRegistre : List String := Id.run do
  let mut errs : List String := []
  for d in doublons (Programmes.tous.map (·.id)) do
    errs := errs ++ [s!"identifiant de programme dupliqué : {d}"]
  for d in doublons (Hypotheses.tous.map (·.id)) do
    errs := errs ++ [s!"identifiant de scénario dupliqué : {d}"]
  for d in doublons (Proprietes.toutes.map (·.id)) do
    errs := errs ++ [s!"identifiant de propriété dupliqué : {d}"]
  for p in Programmes.tous do
    for d in doublons (p.mesures.map (·.id)) do
      errs := errs ++ [s!"{p.id} : identifiant de mesure dupliqué : {d}"]
  for H in Hypotheses.tous do
    unless decide H.Valide do
      errs := errs ++ [s!"scénario invalide (hors bornes de plausibilité) : {H.id}"]
  return errs

/-! ## JSON -/

def etatChamps (s : Etat) : List (String × Json) :=
  [
    ("pib", toJson s.pib), ("indicePrix", toJson s.indicePrix), ("recettes", toJson s.recettes),
    ("depenses", toJson s.depenses), ("dette", toJson s.dette),
    ("deficitPb", toJson s.deficitPb), ("dettePb", toJson s.dettePb),
    ("chomagePb", toJson s.chomagePb), ("smicMensuel", toJson s.smicMensuel),
    ("emissionsMt", toJson s.emissionsMt), ("ageLegalMois", toJson s.ageLegalMois),
    ("passifsImplicites", toJson s.passifsImplicites), ("detteEtenduePb", toJson s.detteEtenduePb),
    ("passifsPolice", toJson s.passifs.police), ("passifsHopital", toJson s.passifs.hopital),
    ("passifsInfrastructures", toJson s.passifs.infrastructures),
    ("emissionsSecteursKt", Json.mkObj <| SecteurGes.tous.map fun g => (g.id, toJson (s.emissionsKt.get g))),
    ("capacitesMw", Json.mkObj <| Filiere.tous.map fun f => (f.id, toJson (s.capacitesMw.get f))),
    ("productionGwh", Json.mkObj <| Filiere.tous.map fun f => (f.id, toJson (s.productionGwh.get f))),
    ("consommationGwh", toJson s.consommationGwh),
    ("prixElectriciteEntreprisesEurosMWh", toJson s.prixElectriciteEntreprisesEurosMWh),
    ("emploisImplantationsEnergie", toJson s.emploisImplantationsEnergie),
    ("modulationGwh", toJson s.modulationGwh),
    ("ecretementGwh", toJson s.ecretementGwh),
    ("surfacesHa", Json.mkObj <| Destination.tous.map fun d => (d.id, toJson (s.surfacesHa.get d))),
    ("surfacesAnneeHa", Json.mkObj <| Destination.tous.map fun d => (d.id, toJson (s.surfacesAnneeHa.get d))),
    ("ecartZanPm", toJson s.ecartZanPm),
    ("surfacesHorsZanHa", toJson s.surfacesHorsZanHa),
    ("populationMilliers", toJson s.populationMilliers),
    ("actifs", toJson s.actifs),
    ("emploiTotal", toJson s.emploiTotal),
    ("pibParHabitant", toJson s.pibParHabitant),
    ("autresRecettes", toJson s.autresRecettes),
    ("chargeInterets", toJson s.chargeInterets),
    ("heuresParEmploi", toJson s.heuresParEmploi),
    ("emploisEtp", toJson s.emploisEtp),
    ("emploisAnnonces", toJson s.emploisAnnonces),
    ("touristesMilliers", toJson s.touristesMilliers),
    ("depenseParTouriste", toJson s.depenseParTouriste),
    ("recettesTourisme", toJson s.recettesTourisme),
    ("exportations", toJson s.exportations), ("importations", toJson s.importations),
    ("balanceCommerciale", toJson s.balanceCommerciale),
    ("balanceCourante", toJson s.balanceCourante), ("balanceCourantePb", toJson s.balanceCourantePb),
    ("robotisationPb", toJson s.robotisationPb),
    ("tauxAccidentsPdm", toJson s.tauxAccidentsPdm),
    ("accidentsTravail", toJson s.accidentsTravail),
    ("migrationAnnuelleMilliers", toJson s.migrationAnnuelleMilliers),

    ("heuresTotalesMillions", toJson s.heuresTotales),
    ("heuresParHabitant", toJson s.heuresParHabitant),
    ("pibParHeure", toJson s.pibParHeure),
    ("depensesParFonction", Json.mkObj <| Fonction.tous.map fun f => (f.id, toJson (s.depensesF.get f))),
    ("tauxApparentPb", toJson s.tauxApparentPb),
    ("tauxMarginalPb", toJson s.tauxMarginalCourantPb),
    ("tauxEmissionPb", toJson s.tauxEmissionPb),
    ("chargeIndexationMeur", toJson s.chargeIndexationMeur),
    ("detteDebut", toJson s.detteDebut),
    ("masseSalariale", toJson s.masseSalariale),
    ("consommationMenages", toJson s.consommationMenages),
    ("soldePrimaire", toJson s.soldePrimaire),
    ("decesPollutionAir", toJson s.decesPollutionAir),
    ("parcElectriqueMilliers", toJson s.parcElectriqueMilliers),
    ("bornesMilliers", toJson s.bornesMilliers),
    ("operationsFinancieres", toJson s.operationsFinancieres),
    ("partDetteNumeriquePm", toJson s.partDetteNumeriquePm),
    ("economieInteretsNumeriqueMeur", toJson s.economieInteretsNumeriqueMeur),
    ("pertePfuMeur", toJson s.pertePfuMeur),
    ("chomeursExcedentaires", toJson s.chomeursExcedentaires),
    ("emploisCoutTravailRestants", toJson s.emploisCoutTravailRestants),
    ("idhMillioniemes", toJson s.idhMillioniemes),
    ("esperanceVieTendanceCentiemes", toJson s.esperanceVieTendanceCentiemes),
    ("dureeAttendueCentiemes", toJson s.dureeAttendueCentiemes),
    ("dureeMoyenneCentiemes", toJson s.dureeMoyenneCentiemes),
    ("anneesVieGagneesParAn", toJson s.anneesVieGagneesParAn),
    ("complementChomageMeur", toJson s.complementChomageMeur),
    ("allegementsTranche", Json.mkObj <| TrancheSalaire.tous.map fun t => (t.id, toJson (s.allegementsTranche.get t))),
    ("participationsEtat", toJson s.participationsEtat),
    ("capitalPublicMesures", toJson s.capitalPublicMesures),
    ("orRacheteMeur", toJson s.orRacheteMeur),
    ("dividendesEtat", toJson s.dividendesEtat),
    ("impots", Json.mkObj <| Impot.tous.map fun i => (i.id, toJson (s.impots.get i))),
    ("emploi", Json.mkObj <| Secteur.tous.map fun x => (x.id, toJson (s.emploi.get x)))]

def etatJson (s : Etat) : Json := Json.mkObj (etatChamps s)

/-- État d'une trajectoire de la synthèse (année `anneeDepart + k`), avec
la répartition de la charge d'intérêts entre ses bénéficiaires. -/
def etatAnneeJson (k : Nat) (s : Etat) : Json :=
  Json.mkObj (etatChamps s ++ [("interetsBeneficiaires", Json.mkObj <|
    (Hypotheses.Detention.repartition k s).champs.map fun (c, v) => (c, toJson v))])

def rapportJson : Json :=
  Json.mkObj [
    ("version", toJson (2 : Nat)),
    ("moteurs", Json.arr <| moteurs.toArray.map fun M =>
      Json.mkObj [("id", toJson M.id), ("nom", toJson M.nom), ("description", toJson M.description)]),
    ("scenarios", Json.arr <| Hypotheses.tous.toArray.map fun H =>
      Json.mkObj [("id", toJson H.id), ("demo", toJson H.demo.id),
        ("natalite", toJson H.natalite.id), ("eco", toJson H.eco.id),
        ("energie", toJson H.energie.id), ("droit", toJson H.droit.id),
        ("horizon", toJson H.horizon)]),
    ("proprietes", Json.arr <| Proprietes.toutes.toArray.map fun q =>
      Json.mkObj [("id", toJson q.id), ("titre", toJson q.titre),
        ("description", toJson q.description), ("annee", toJson q.annee)]),
    ("programmes", Json.arr <| Programmes.tous.toArray.map fun p =>
      Json.mkObj [
        ("id", toJson p.id), ("nom", toJson p.nom),
        ("nbMesures", toJson p.mesures.length),
        ("coherence", coherenceJson p),
        ("evaluations", Json.arr <| (moteurs.toArray.flatMap fun M => Hypotheses.tous.toArray.map fun H =>
          let ev := evaluer M p H
          Json.mkObj [
            ("moteur", toJson M.id), ("scenario", toJson H.id),
            ("tendanciel", etatJson ev.tendanciel),
            ("programme", etatJson ev.avec),
            ("proprietes", Json.mkObj <| ev.resultats.map fun (q, b) => (q.id, toJson b))])),
        ("engagements", Json.arr <| p.engagements.toArray.map fun e =>
          Json.mkObj [("moteur", toJson e.moteur.id), ("scenario", toJson e.scenario.id),
            ("propriete", toJson e.propriete.id),
            ("tenu", toJson (engagementTenu p e))]),
        ("contrats", Json.arr <| (contrats p).toArray.map fun (m, t) =>
          Json.mkObj [("mesure", toJson m), ("titre", toJson t)]),
        ("sru", Json.arr <| (baremesSRU p).toArray.flatMap fun (m, b) =>
          (panelSRU b).toArray.map fun l =>
            Json.mkObj [("mesure", toJson m), ("commune", toJson l.commune.id),
              ("actuel", toJson l.actuel), ("maxActuel", toJson l.maxActuel),
              ("amende", toJson l.amende), ("plafonnee", toJson l.plafonnee)]),
        ("automobile", Json.arr <| (remplacements p).toArray.flatMap fun (m, v, r) =>
          Hypotheses.Automobile.toutes.toArray.map fun h =>
            Json.mkObj [("mesure", toJson m), ("version", toJson v), ("hypothese", toJson h.id),
              ("coutEuros", toJson r.cout), ("importsInitialesCts", toJson r.importsInitialesCts),
              ("gainAnnuelCts", toJson (r.gainAnnuelCts h)),
              ("solde5ansCts", toJson (r.soldeCumuleCts h 5)),
              ("solde10ansCts", toJson (r.soldeCumuleCts h 10)),
              ("equilibre", toJson (equilibreTexte h r))])]),
    ("erreurs", toJson erreursRegistre)]

/-! ## Synthèse (données des graphiques et tableaux du PDF) -/

/-- Horizon de la synthèse, en années. -/
def horizonSynthese : Nat := 10

def sourcesJson (l : List String) : Json := toJson l

/-- Mesure dont l'effet dépend de l'état de l'économie (frein automatique
au déficit) : seule sur le tendanciel, elle jouerait là où le programme
complet ne la déclenche pas. -/
def mesureConditionnelle (m : Mesure) : Bool :=
  m.leviers.any fun l => match l with
    | .freinDeficit .. => true
    | _ => false

/-- Identifiant de base d'une ligne de mesure : « O-150b » → « O-150 ». Les
lignes qui partagent une base forment une seule mesure (sa mise en œuvre
étalée, ses aides, sa fin programmée…). -/
def baseMesure (id : String) : String :=
  String.ofList (id.toList.reverse.dropWhile Char.isLower).reverse

/-- Lignes liées à `m` (même base, hors mesures conditionnelles), dans
l'ordre du programme ; la première porte l'effet de l'ensemble. -/
def lignesLiees (p : Programme) (m : Mesure) : List Mesure :=
  if mesureConditionnelle m then [m]
  else p.mesures.filter fun m' => baseMesure m'.id = baseMesure m.id && !mesureConditionnelle m'

/-- Effet d'une mesure prise isolément : le programme réduit à cette seule
mesure, projeté `n` années sous le scénario central, comparé au tendanciel
et au programme complet. Mesure la contribution de chaque mesure à la
croissance, au solde et à l'emploi. Les lignes liées (`lignesLiees` :
O-150 et O-150b…) sont mesurées ensemble, sur la première ligne ; les
suivantes renvoient à elle (`compteAvec`), leurs effets à zéro : prises
seules, elles n'ont pas de sens (une fin de dispositif sans son début). Une
mesure conditionnelle (`mesureConditionnelle`) est mesurée par différence :
programme complet moins programme sans elle. -/
def effetMesure (M : Moteur) (p : Programme) (m : Mesure) (n : Nat) : Json :=
  let H := Hypotheses.central
  let liees := lignesLiees p m
  let chef := (liees.head?.map (·.id)).getD m.id
  if chef ≠ m.id then
    Json.mkObj [("mesure", toJson m.id), ("moteur", toJson M.id), ("compteAvec", toJson chef),
      ("pibPb", toJson (0 : Int)), ("deficitPb", toJson (0 : Int)), ("dettePb", toJson (0 : Int)),
      ("chomagePb", toJson (0 : Int)), ("idhMillioniemes", toJson (0 : Int)), ("emplois", toJson (0 : Int)),
      ("recettes", toJson (0 : Int)), ("depenses", toJson (0 : Int)), ("exportations", toJson (0 : Int)),
      ("importations", toJson (0 : Int)), ("balanceCourante", toJson (0 : Int))]
  else
  let seul : Programme := { p with mesures := liees }
  let sans : Programme := { p with mesures := p.mesures.filter (·.id ≠ m.id) }
  let a := if mesureConditionnelle m then sans.resultatA M H n else tendancielA M H n
  let s := if mesureConditionnelle m then p.resultatA M H n else seul.resultatA M H n
  Json.mkObj [
    ("mesure", toJson m.id), ("moteur", toJson M.id),
    ("lignes", toJson (liees.map (·.id))),
    ("pibPb", toJson (ratioPb (s.pib - a.pib) a.pib)),
    ("deficitPb", toJson (s.deficitPb - a.deficitPb)),
    ("dettePb", toJson (s.dettePb - a.dettePb)),
    ("chomagePb", toJson (s.chomagePb - a.chomagePb)),
    ("idhMillioniemes", toJson (s.idhMillioniemes - a.idhMillioniemes)),
    ("emplois", toJson (s.emploiTotal - a.emploiTotal)),
    ("recettes", toJson (s.recettes - a.recettes)),
    ("depenses", toJson (s.depenses - a.depenses)),
    ("exportations", toJson (s.exportations - a.exportations)),
    ("importations", toJson (s.importations - a.importations)),
    ("balanceCourante", toJson (s.balanceCourante - a.balanceCourante))]

/-- Variantes des mesures : programme complet dont la mesure prend les
leviers de la variante, comparé au programme retenu, moteur standard,
scénario central, à l'horizon de la synthèse. -/
def effetsVariantes (p : Programme) (n : Nat) : List Json :=
  let H := Hypotheses.central
  let retenu := p.resultatA standard H n
  p.mesures.flatMap fun m => m.variantes.map fun v =>
    let pv : Programme := { p with mesures := p.mesures.map fun m' =>
      if m'.id = m.id then { m' with leviers := v.leviers } else m' }
    let s := pv.resultatA standard H n
    Json.mkObj [("mesure", toJson m.id), ("variante", toJson v.nom),
      ("deficitPb", toJson s.deficitPb), ("ecartDeficitPb", toJson (s.deficitPb - retenu.deficitPb)),
      ("ecartPibPb", toJson (ratioPb (s.pib - retenu.pib) retenu.pib)),
      ("ecartEmplois", toJson (s.emploiTotal - retenu.emploiTotal)),
      ("idhMillioniemes", toJson s.idhMillioniemes),
      ("chomagePb", toJson s.chomagePb)]

def ecartRetroJson (e : EcartRetro) : Json :=
  Json.mkObj [
    ("annee", toJson e.annee),
    ("prelevementsModele", toJson e.prelevementsModele), ("prelevementsObserves", toJson e.prelevementsObserves),
    ("evolutionSpontaneeModelePb", toJson e.evolutionSpontaneeModelePb),
    ("evolutionSpontaneeObserveePb", toJson e.evolutionSpontaneeObserveePb),
    ("interetsModele", toJson e.interetsModele), ("interetsObserves", toJson e.interetsObserves),
    ("indexationModele", toJson e.indexationModele), ("indexationObservee", toJson e.indexationObservee),
    ("chomageModelePb", toJson e.chomageModelePb), ("chomageObservePb", toJson e.chomageObservePb),
    ("depensesPrimairesRegle", toJson e.depensesPrimairesRegle),
    ("depensesPrimairesObservees", toJson e.depensesPrimairesObservees),
    ("deficitModelePb", toJson e.deficitModelePb), ("deficitObservePb", toJson e.deficitObservePb),
    ("detteModelePb", toJson e.detteModelePb), ("detteObserveePb", toJson e.detteObserveePb),
    ("masseSalarialeModele", toJson e.masseSalarialeModele),
    ("masseSalarialeObservee", toJson e.masseSalarialeObservee),
    ("consommationModele", toJson e.consommationModele),
    ("consommationObservee", toJson e.consommationObservee)]

/-- Rétro-test (scénario central, moteur standard) : à un an, et sur
plusieurs années depuis chaque point de départ de `Hypotheses.departsRetro`. -/
def retroJson : Json :=
  let H := Hypotheses.central
  let base := Hypotheses.reference2026.etat
  let obs := Hypotheses.observations
  Json.mkObj [
    ("unAn", Json.arr <| (retroUnAn standard H base obs).toArray.map ecartRetroJson),
    ("plusieursAnnees", Json.arr <| Hypotheses.departsRetro.toArray.map fun a =>
      Json.mkObj [("depart", toJson a),
        ("annees", Json.arr <| (retroPlusieursAnnees standard H base
          (obs.dropWhile (·.annee + 1 < a))).toArray.map ecartRetroJson)])]

def rapportSyntheseJson : Json :=
  let annee0 := Hypotheses.reference2026.annee
  let scens := Hypotheses.tous
  Json.mkObj [
    ("version", toJson (1 : Nat)),
    ("anneeDepart", toJson annee0),
    ("annees", toJson ((List.range (horizonSynthese + 1)).map (annee0 + ·))),
    ("horizonProprietes", toJson Hypotheses.horizon),
    ("enveloppeZanHa", toJson Hypotheses.central.sols.enveloppeHa),
    ("rythmeZanHa", toJson Hypotheses.central.sols.rythmeZanHa),
    ("rythmeSansZanHa", toJson Hypotheses.central.sols.consommationSansZanHa.total),
    ("nbScenarios", toJson scens.length),
    ("moteurs", Json.arr <| moteurs.toArray.map fun M =>
      Json.mkObj [("id", toJson M.id), ("nom", toJson M.nom), ("description", toJson M.description)]),
    ("moteurStandard", toJson standard.id),
    ("secteurs", Json.arr <| Secteur.tous.toArray.map fun x =>
      Json.mkObj [("id", toJson x.id), ("nom", toJson x.nom)]),
    ("impots", Json.arr <| Impot.tous.toArray.map fun i =>
      Json.mkObj [("id", toJson i.id), ("nom", toJson i.nom)]),
    ("filieres", Json.arr <| Filiere.tous.toArray.map fun f =>
      Json.mkObj [("id", toJson f.id), ("nom", toJson f.nom)]),
    ("destinations", Json.arr <| Destination.tous.toArray.map fun d =>
      Json.mkObj [("id", toJson d.id), ("nom", toJson d.nom)]),
    ("secteursGes", Json.arr <| SecteurGes.tous.toArray.map fun g =>
      Json.mkObj [("id", toJson g.id), ("nom", toJson g.nom)]),
    ("fonctions", Json.arr <| Fonction.tous.toArray.map fun f =>
      Json.mkObj [("id", toJson f.id), ("nom", toJson f.nom)]),
    ("statuts", Json.arr <| Statut.tous.toArray.map fun s =>
      Json.mkObj [("id", toJson s.id), ("nom", toJson s.nom)]),
    -- bloc de demande : variantes d'un choc permanent d'un point de PIB par
    -- canal (demande mondiale : +1 %), scénario central, sur dix ans
    ("multiplicateurs", Json.arr <| (variantesDemande.toArray.map fun (id, nom, ch) =>
      let r := simulerChoc Hypotheses.central.eco.demande 1000 920 Hypotheses.central.eco.flexionPm ch 10
      Json.mkObj [("canal", toJson id), ("nom", toJson nom),
        ("pibPpm", toJson (r.map (·.pib))), ("prixPpm", toJson (r.map (·.prixConso))),
        ("emploiPpm", toJson (r.map (·.emploi)))])),
    ("domaines", Json.arr <| Domaine.tous.toArray.map fun d =>
      Json.mkObj [("id", toJson d.id), ("nom", toJson d.nom)]),
    ("proprietes", Json.arr <| Proprietes.toutes.toArray.map fun q =>
      Json.mkObj [("id", toJson q.id), ("titre", toJson q.titre),
        ("description", toJson q.description), ("annee", toJson q.annee)]),
    ("programmes", Json.arr <| Programmes.tous.toArray.map fun p =>
      Json.mkObj [("id", toJson p.id), ("nom", toJson p.nom),
        ("description", toJson p.description), ("nbMesures", toJson p.mesures.length),
        ("entreeEnVigueur", toJson p.entreeEnVigueur),
        ("coherence", coherenceJson p),
        ("mesures", Json.arr <| p.mesures.toArray.map fun m =>
          Json.mkObj [("id", toJson m.id), ("titre", toJson m.titre), ("source", toJson m.source),
            ("debut", toJson m.debut), ("repetitions", toJson m.repetitions),
            ("statut", toJson m.statut.id), ("domaine", toJson m.domaine.id),
            ("noteStatut", toJson m.noteStatut),
            ("variantes", toJson (m.variantes.map (·.nom)))]),
        ("contrats", toJson ((contrats p).map fun (m, t) => s!"{m} — {t}")),
        -- effet de chaque mesure seule, à l'horizon de la synthèse, par moteur
        ("effetsMesures", Json.arr <| (moteurs.toArray.flatMap fun M =>
          p.mesures.toArray.map fun m => effetMesure M p m horizonSynthese)),
        ("effetsVariantes", Json.arr (effetsVariantes p horizonSynthese).toArray),
        ("effetTotal", Json.arr <| moteurs.toArray.map fun M =>
          let H := Hypotheses.central
          let a := tendancielA M H horizonSynthese
          let s := p.resultatA M H horizonSynthese
          Json.mkObj [("moteur", toJson M.id), ("pibPb", toJson (ratioPb (s.pib - a.pib) a.pib)),
            ("deficitPb", toJson (s.deficitPb - a.deficitPb)), ("emplois", toJson (s.emploiTotal - a.emploiTotal))]),
        ("engagements", Json.arr <| p.engagements.toArray.map fun e =>
          Json.mkObj [("moteur", toJson e.moteur.id), ("scenario", toJson e.scenario.id),
            ("propriete", toJson e.propriete.id), ("tenu", toJson (engagementTenu p e))]),
        -- par moteur : nombre de scénarios où chaque propriété tient, et statut au scénario central
        ("matrice", Json.mkObj <| moteurs.map fun M =>
          (M.id, Json.mkObj <| Proprietes.toutes.map fun q =>
            (q.id, toJson (scens.filter fun H => decide (p.Verifie M H q)).length))),
        ("central", Json.mkObj <| moteurs.map fun M =>
          (M.id, Json.mkObj <| Proprietes.toutes.map fun q =>
            (q.id, toJson (decide (p.Verifie M Hypotheses.central q)))))]),
    ("variantes", Json.arr <| Hypotheses.variantesSynthese.toArray.map fun (vid, nom, H) =>
      Json.mkObj [("id", toJson vid), ("nom", toJson nom), ("scenario", toJson H.id),
        ("natalite", toJson H.natalite.description), ("energie", toJson H.energie.description),
        ("icfCentiemes", toJson H.natalite.icfCentiemes),
        ("naissancesMilliers", toJson H.natalite.naissancesMilliers),
        ("prixBrentDollars", toJson H.energie.prixBrentDollars),
        ("prixReferenceDollars", toJson H.energie.prixReferenceDollars),
        ("effetPibPar10DollarsPb", toJson H.energie.effetPibPar10DollarsPb),
        ("decesEvitesParMillionVehicules", toJson H.energie.decesEvitesParMillionVehicules),
        ("vehiculesParBorne", toJson H.energie.vehiculesParBorne),
        ("chomageFrictionnelPb", toJson H.eco.chomageFrictionnelPb),
        ("coutParAccidentEuros", toJson H.eco.coutParAccidentEuros),
        ("joursPerdusParAccident", toJson H.eco.joursPerdusParAccident),
        ("letaliteAccidentsPdm", toJson H.eco.letaliteAccidentsPdm),
        ("tauxAccidentsUEPdm", toJson H.eco.tauxAccidentsUEPdm),
        ("soldeMigratoireMilliers", toJson H.demo.soldeMigratoireMilliers),
        ("partActiveMigrantsPm", toJson H.demo.partActiveMigrantsPm),
        ("moteurs", Json.mkObj <| moteurs.map fun M =>
          (M.id, Json.mkObj [
            ("tendanciel", Json.arr <| (trajectoire M H horizonSynthese (etatDepart H)).toArray.mapIdx etatAnneeJson),
            ("programmes", Json.mkObj <| Programmes.tous.map fun p =>
              (p.id, Json.arr <| (p.trajectoire M H horizonSynthese 0 (etatDepart H)).toArray.mapIdx etatAnneeJson))]))]),
    ("retro", retroJson),
    ("beneficiairesInterets", Json.mkObj [
      ("beneficiaires", Json.arr <| Hypotheses.Detention.beneficiaires.toArray.map fun b =>
        Json.mkObj [("id", toJson b.id), ("nom", toJson b.nom)]),
      ("portefeuilleBdfMeur", toJson ((List.range (horizonSynthese + 1)).map Hypotheses.Detention.portefeuilleMoyen)),
      ("rendementBdfPb", toJson Hypotheses.Detention.rendementBdfPb),
      ("structureDixMilliemes", Json.mkObj [
        ("nonResidents", toJson Hypotheses.Detention.partNonResidents),
        ("banqueDeFrance", toJson Hypotheses.Detention.partBdf),
        ("banques", toJson Hypotheses.Detention.partBanques),
        ("autresResidents", toJson Hypotheses.Detention.partAutresResidents)])]),
    ("textesEuropeens", Json.arr <| Hypotheses.Europe.textes.toArray.map fun t =>
      Json.mkObj [("id", toJson t.id), ("titre", toJson t.titre), ("reference", toJson t.reference),
        ("critere", toJson t.critere)]),
    ("textesConstitutionnels", Json.arr <| Hypotheses.Constitution.textes.toArray.map fun t =>
      Json.mkObj [("id", toJson t.id), ("titre", toJson t.titre), ("reference", toJson t.reference),
        ("critere", toJson t.critere)]),
    ("prixEnergieComparaison", Json.arr <| Hypotheses.Electricite.electriciteFrance.prixComparaison.toArray.map fun (pays, elec, gaz) =>
      Json.mkObj [("pays", toJson pays), ("electriciteEurosMWh", toJson elec), ("gazEurosMWh", toJson gaz)]),
    ("hypotheses", Json.mkObj [
      ("reference", Json.mkObj [("description", toJson Hypotheses.reference2026.description),
        ("sources", sourcesJson Hypotheses.reference2026.sources)]),
      ("demographie", Json.arr <| Hypotheses.Demo.toutes.toArray.map fun d =>
        Json.mkObj [("id", toJson d.id), ("description", toJson d.description),
          ("sources", sourcesJson d.sources)]),
      ("natalite", Json.arr <| Hypotheses.Natalite.toutes.toArray.map fun n =>
        Json.mkObj [("id", toJson n.id), ("description", toJson n.description),
          ("sources", sourcesJson n.sources)]),
      ("economie", Json.arr <| Hypotheses.Eco.toutes.toArray.map fun e =>
        Json.mkObj [("id", toJson e.id), ("description", toJson e.description),
          ("sources", sourcesJson e.sources)]),
      ("energie", Json.arr <| Hypotheses.Energie.toutes.toArray.map fun e =>
        Json.mkObj [("id", toJson e.id), ("description", toJson e.description),
          ("sources", sourcesJson e.sources)]),
      ("droit", Json.arr <| Hypotheses.Droit.toutes.toArray.map fun j =>
        Json.mkObj [("id", toJson j.id), ("description", toJson j.description),
          ("sources", sourcesJson j.sources)])])]

/-! ## Markdown -/

def rapportMarkdown : String := Id.run do
  let props := Proprietes.toutes
  let scens := Hypotheses.tous
  let nS := scens.length
  let mut out : Array String := #[]
  out := out.push "# Rapport d'évaluation"
  out := out.push ""
  out := out.push s!"{Programmes.tous.length} programmes × {nS} scénarios × {props.length} propriétés."
  out := out.push ""

  let errs := erreursRegistre
  unless errs.isEmpty do
    out := out.push "## ⛔ Erreurs de registre"
    for e in errs do out := out.push s!"- {e}"
    out := out.push ""

  -- Engagements
  out := out.push "## Engagements revendiqués"
  out := out.push ""
  out := out.push (ligne ["Programme", "Moteur", "Scénario", "Propriété", "Tenu"])
  out := out.push (separateur 5)
  let tousIds := scens.map (·.id)
  for p in Programmes.tous do
    for M in moteurs do
      for q in props do
        let es := p.engagements.filter fun e => e.propriete.id == q.id && e.moteur.id == M.id
        let couverts := (es.map (·.scenario.id)).eraseDups
        if !es.isEmpty && tousIds.all couverts.contains then
          -- engagement universel : une seule ligne
          let casses := es.filter fun e => !engagementTenu p e
          let detail := if casses.isEmpty then coche true
            else s!"{coche false} ({", ".intercalate (casses.map (·.scenario.id))})"
          out := out.push (ligne [p.id, M.id, s!"**tous** ({nS})", q.id, detail])
        else
          for e in es do
            out := out.push (ligne [p.id, M.id, e.scenario.id, q.id, coche (engagementTenu p e)])
  out := out.push ""

  -- Nombre de scénarios où chaque propriété tient, par moteur, programme et
  -- propriété : calculé une fois pour le score global et les tableaux.
  let comptes : List (Moteur × List (Programme × List Nat)) := moteurs.map fun M =>
    (M, Programmes.tous.map fun p =>
      (p, props.map fun q => (scens.filter fun H => decide (p.Verifie M H q)).length))
  let casesParMoteur := props.length * nS
  let scoreDe (M : Moteur) (p : Programme) : Nat :=
    match comptes.find? (fun (M', _) => M'.id == M.id) with
    | some (_, ls) => match ls.find? (fun (p', _) => p'.id == p.id) with
      | some (_, ks) => ks.foldl (· + ·) 0
      | none => 0
    | none => 0
  let cellScore (k n : Nat) : String :=
    s!"{pastille k n} {k}/{n} ({if n = 0 then 0 else (k * 100 + n / 2) / n} %)"

  -- Score global
  out := out.push "## Score global : propriétés tenues sur l'ensemble des scénarios"
  out := out.push ""
  out := out.push s!"Somme, sur les {props.length} propriétés, du nombre de scénarios où chacune tient ({props.length} × {nS} = {casesParMoteur} cases par moteur). Classement selon la somme des {moteurs.length} moteurs."
  out := out.push ""
  out := out.push legendePastilles
  out := out.push ""
  out := out.push (ligne (["Rang", "Programme"] ++ moteurs.map (·.nom) ++ ["Ensemble"]))
  out := out.push (separateur (moteurs.length + 3))
  let totaux := Programmes.tous.map fun p => (p, moteurs.foldl (fun acc M => acc + scoreDe M p) 0)
  let classes := totaux.mergeSort fun a b => b.2 ≤ a.2
  let mut rang := 0
  for (p, total) in classes do
    rang := rang + 1
    out := out.push (ligne ([toString rang, p.id] ++ moteurs.map (fun M => cellScore (scoreDe M p) casesParMoteur)
      ++ [cellScore total (casesParMoteur * moteurs.length)]))
  out := out.push ""

  -- Cohérence interne
  out := out.push "## Cohérence interne"
  out := out.push ""
  out := out.push "Deux mesures d'un même programme qui fixent un réglage à deux valeurs différentes, ou le déplacent dans des sens opposés (durée du travail, âge légal, taux de l'IS…), repérées à partir des leviers seuls. Un conflit arbitré est déclaré voulu par l'auteur, avec sa raison."
  out := out.push ""
  out := out.push (ligne ["Programme", "Cohérent", "Conflits", "Arbitrés"])
  out := out.push (separateur 4)
  for p in Programmes.tous do
    out := out.push (ligne [p.id, coche p.coherent, toString p.conflits.length,
      toString p.conflitsArbitres.length])
  out := out.push ""

  -- Synthèse par moteur
  for (M, lignes) in comptes do
    out := out.push s!"## Synthèse, moteur « {M.nom} » : scénarios où la propriété tient"
    out := out.push ""
    out := out.push M.description
    out := out.push ""
    out := out.push legendePastilles
    out := out.push ""
    out := out.push (ligne ("Programme" :: props.map (·.id) ++ ["Score"]))
    out := out.push (separateur (props.length + 2))
    for (p, ks) in lignes do
      let cellules := ks.map fun k => s!"{pastille k nS} {k}/{nS}"
      out := out.push (ligne (p.id :: cellules ++ [cellScore (ks.foldl (· + ·) 0) casesParMoteur]))
    out := out.push ""

  -- Détail par programme
  for p in Programmes.tous do
    out := out.push s!"## {p.nom}"
    out := out.push ""
    out := out.push p.description
    out := out.push ""
    out := out.push s!"<details><summary>Propriétés par scénario (moteur « {standard.nom} »)</summary>"
    out := out.push ""
    out := out.push (ligne ("Scénario" :: props.map (·.id)))
    out := out.push (separateur (props.length + 1))
    for H in scens do
      let ev := evaluer standard p H
      out := out.push (ligne (H.id :: ev.resultats.map fun (_, b) => coche b))
    out := out.push ""
    out := out.push "</details>"
    out := out.push ""
    out := out.push s!"<details><summary>Indicateurs à l'horizon, moteur « {standard.nom} » (tendanciel → programme)</summary>"
    out := out.push ""
    out := out.push (ligne ["Scénario", "Déficit % PIB", "Dette % PIB", "Chômage %", "Émissions Mt"])
    out := out.push (separateur 5)
    for H in scens do
      let ev := evaluer standard p H
      let a := ev.tendanciel
      let s := ev.avec
      out := out.push (ligne [H.id,
        s!"{fmtPb a.deficitPb} → {fmtPb s.deficitPb}",
        s!"{fmtPb a.dettePb} → {fmtPb s.dettePb}",
        s!"{fmtPb a.chomagePb} → {fmtPb s.chomagePb}",
        s!"{a.emissionsMt} → {s.emissionsMt}"])
    out := out.push ""
    out := out.push "</details>"
    out := out.push ""
    unless p.conflits.isEmpty do
      out := out.push "**Cohérence interne** — conflits non arbitrés :"
      out := out.push ""
      for c in p.conflits do out := out.push s!"- ❌ {conflitTexte c}"
      out := out.push ""
    unless p.conflitsArbitres.isEmpty do
      out := out.push "**Cohérence interne** — conflits arbitrés par l'auteur :"
      out := out.push ""
      for (c, r) in p.conflitsArbitres do out := out.push s!"- ⚖️ {conflitTexte c} : {r}"
      out := out.push ""
    for a in p.arbitragesSansObjet do
      out := out.push s!"- ⚠️ Arbitrage sans objet ({a.mesure1} / {a.mesure2}) : aucun conflit entre ces mesures, à retirer."
    let ks := contrats p
    unless ks.isEmpty do
      out := out.push "**Contrats des mesures** (prouvés pour tous les cas, vérifiés à la compilation) :"
      out := out.push ""
      for (m, t) in ks do
        out := out.push s!"- ✅ {m} — {t}"
      out := out.push ""
    for (m, b) in baremesSRU p do
      let lignes := panelSRU b
      out := out.push s!"<details><summary>{m} — panel communal SRU (communes fictives)</summary>"
      out := out.push ""
      out := out.push "Neutre sur le solde consolidé des APU (transfert communes → FNAP / EPF) : aucun effet sur la matrice ci-dessus."
      out := out.push ""
      out := out.push (ligne ["Commune", "Logements sociaux", "Part manquante", "Droit actuel (base)",
        "Maximum préfectoral actuel", s!"Amende {m}", "Coefficient"])
      out := out.push (separateur 7)
      for l in lignes do
        let c := l.commune
        out := out.push (ligne [c.id, s!"{fmtPb c.tauxLogementsSociauxPb} % / {fmtPb c.tauxLegalPb} %",
          s!"{fmtPb (c.partManquantePm * 10)} %", fmtEuros l.actuel, fmtEuros l.maxActuel,
          fmtEuros l.amende,
          if c.manquants = 0 then "—"
          else if l.plafonnee then s!"{fmtCoef (b.coefPm c)} → plafonné"
          else fmtCoef (b.coefPm c)])
      let total (f : LigneSRU → Int) := lignes.foldl (fun acc l => acc + f l) 0
      out := out.push (ligne ["**Total**", "", "", fmtEuros (total (·.actuel)),
        fmtEuros (total (·.maxActuel)), fmtEuros (total (·.amende)), ""])
      out := out.push ""
      out := out.push "</details>"
      out := out.push ""
      let versions := (("retenue", b) :: (variantesSRU p).filterMap fun (m', nom, b') =>
        if m' == m then some (nom, b') else none)
      if versions.length > 1 then
        let panel := Hypotheses.Communes.panel
        let tot (f : Commune → Int) := panel.foldl (fun acc c => acc + f c) 0
        out := out.push s!"<details><summary>{m} — comparaison des taux d'amende (communes fictives)</summary>"
        out := out.push ""
        out := out.push (ligne ["Version", "Barème", "Total du panel", "Communes plafonnées",
          "Charge maximale (% des DRF)"])
        out := out.push (separateur 5)
        out := out.push (ligne ["Droit actuel, prélèvement de base", "×1, plafond 5 %",
          fmtEuros (tot SRU.prelevementActuel), "", ""])
        out := out.push (ligne ["Droit actuel, maximum préfectoral", "jusqu'à ×5, plafond 5 % ou 7,5 %",
          fmtEuros (tot (SRU.majorationMaxActuelle Hypotheses.Communes.medianePFH)), "", ""])
        for (nom, b') in versions do
          let plafonnees := (panel.filter fun c => decide (c.plafond b'.plafondPb < b'.brut c)).length
          let charge := panel.foldl (fun acc c =>
            max acc (ratioPb (b'.amende c) c.depensesReellesFonctionnement)) 0
          out := out.push (ligne [nom,
            s!"{fmtCoef b'.coefMinPm} à {fmtCoef b'.coefMaxPm}, plafond {fmtPb b'.plafondPb} %",
            fmtEuros (tot b'.amende), s!"{plafonnees}/{panel.length}", s!"{fmtPb charge} %"])
        out := out.push ""
        out := out.push ("Destination des fonds : le prélèvement net va à l'EPCI délégataire des aides " ++
          "à la pierre ou à l'établissement public foncier, la majoration au FNAP. Effet direct sur " ++
          "le budget de l'État : nul. Ordre de grandeur : en PACA, bilan 2020-2022, 63,2 M€ nets et " ++
          "32,6 M€ de majorations (préfecture de région PACA).")
        out := out.push ""
        out := out.push "</details>"
        out := out.push ""

    let rs := remplacements p
    unless rs.isEmpty do
      out := out.push "<details><summary>Remplacement de véhicules — balance commerciale à 5 et 10 ans</summary>"
      out := out.push ""
      out := out.push ("Sous-modèle `Modele/Automobile.lean` : importations de véhicules l'année 0, puis " ++
        "chaque année carburant importé évité moins électricité non exportée. Pour mémoire, déficit " ++
        "commercial automobile de la France en 2025 ≈ 20 Md€ (Douanes).")
      out := out.push ""
      out := out.push (ligne ["Mesure", "Version", "Hypothèse", "Coût budgétaire", "Importations an 0",
        "Effet annuel", "Solde à 5 ans", "Solde à 10 ans", "Équilibre"])
      out := out.push (separateur 9)
      for (m, v, r) in rs do
        for h in Hypotheses.Automobile.toutes do
          out := out.push (ligne [m, v, h.id, fmtMEurosCts (r.cout * 100),
            fmtMEurosCts (-r.importsInitialesCts), s!"{fmtMEurosCts (r.gainAnnuelCts h)}/an",
            fmtMEurosCts (r.soldeCumuleCts h 5), fmtMEurosCts (r.soldeCumuleCts h 10),
            equilibreTexte h r])
      out := out.push ""
      out := out.push "</details>"
      out := out.push ""

  -- Légende
  out := out.push "## Propriétés"
  out := out.push ""
  for q in props do
    out := out.push s!"- **{q.id}** — {q.titre}. {q.description}"
  out := out.push ""
  out := out.push "_Modèle et hypothèses provisoires : voir README._"
  return "\n".intercalate out.toList ++ "\n"

end Rapport

/-- Valeur de l'option `--nom` dans `args`, sinon `defaut`. -/
def option (args : List String) (nom defaut : String) : String :=
  match args.dropWhile (· != nom) with
  | _ :: v :: _ => v
  | _ => defaut

def main (args : List String) : IO UInt32 := do
  let fJson := option args "--json" "rapport.json"
  let fMd := option args "--md" "rapport.md"
  if args.contains "--synthese" then
    let f := option args "--synthese" "synthese.json"
    IO.FS.writeFile f (Rapport.rapportSyntheseJson.compress ++ "\n")
    IO.println s!"Synthèse écrite : {f}"
  IO.FS.writeFile fJson (Rapport.rapportJson.pretty ++ "\n")
  IO.FS.writeFile fMd Rapport.rapportMarkdown
  let errs := Rapport.erreursRegistre
  let casses := Programmes.tous.foldl (fun n p =>
    n + (p.engagements.filter fun e => !Rapport.engagementTenu p e).length) 0
  IO.println s!"Rapport écrit : {fJson}, {fMd}"
  IO.println s!"Engagements non tenus : {casses}"
  for e in errs do IO.eprintln s!"ERREUR : {e}"
  return if errs.isEmpty then 0 else 1
