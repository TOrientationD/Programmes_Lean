import Modele.Projection

/-!
# Rétro-test : le modèle face aux comptes observés

Le modèle aurait-il trouvé le bon déficit les années passées ? Pour chaque
année observée `t`, on part des comptes publics observés de l'année `t − 1`
et on projette une année avec **la même fonction que les projections**
(`anneeSuivante`), en lui donnant ce qui était hors de son ressort :

* l'environnement macroéconomique observé de l'année `t` : croissance en
  volume, déflateur du PIB, inflation (prix à la consommation, titres
  indexés), taux de l'OAT à 10 ans, croissance potentielle estimée, durée
  de vie moyenne et part indexée de la dette, valeur des transactions
  immobilières, coefficient légal de revalorisation des valeurs locatives ;
* les décisions de l'année `t` : mesures nouvelles de prélèvements
  obligatoires (chiffrage officiel), dépenses primaires et recettes hors
  prélèvements obligatoires effectivement constatées.

Le modèle calcule ce qui relève de ses mécanismes : les assiettes
(masse salariale par l'emploi et les rémunérations, consommation, excédent
des entreprises) et l'évolution spontanée de chaque prélèvement sur la
sienne (`Assiettes.taux`), la charge d'intérêts (dette nouvelle et refinancement au taux
de l'année, indexation), le chômage (loi d'Okun) et la dette. Le déficit
« conditionnel » ainsi obtenu est comparé au déficit observé : l'écart
mesure l'erreur des mécanismes, pas celle des choix politiques.
L'évolution tendancielle des dépenses (`Economie.tauxDepenses`) est
comparée à part aux dépenses observées : l'écart mêle mesures d'économies,
crises et erreur de règle.

Les prélèvements obligatoires sont pris au sens de l'INSEE (nets des
crédits d'impôt), comme les mesures nouvelles officielles : le déficit
conditionnel ne dépend pas du traitement des crédits d'impôt (seuls les
prélèvements et les intérêts sont remplacés par ceux du modèle).

Deux exercices : à un an (on repart chaque année des comptes observés) et
sur plusieurs années (les erreurs s'accumulent dans les prélèvements, la
dette et les intérêts).
-/

namespace Modele

/-- Comptes et environnement observés d'une année. Montants en M€ courants,
taux en pb. -/
structure AnneeObservee where
  annee : Nat
  /-- PIB en valeur. -/
  pib : Int
  /-- Croissance du PIB en volume, évolution du déflateur du PIB, croissance
  potentielle estimée. -/
  croissanceVolumePb : Int
  deflateurPb : Int
  croissancePotentiellePb : Int
  /-- Inflation des prix à la consommation (moyenne annuelle) ; inflation des
  titres indexés (moyenne annuelle des indices de la zone euro et de la
  France, pondérée par les encours d'OAT€i et d'OATi). -/
  inflationConsoPb : Int
  inflationIndexationPb : Int
  /-- Taux moyen de l'OAT à 10 ans ; taux moyen à l'émission des titres à
  court terme de l'État (BTF). -/
  tauxOat10Pb : Int
  tauxCourtPb : Int
  /-- Taux de chômage BIT moyen. -/
  chomagePb : Int
  /-- Recettes totales des administrations publiques, dont prélèvements
  obligatoires (au sens de l'INSEE). -/
  recettes : Int
  prelevements : Int
  /-- Dépenses totales, dont charge d'intérêts (intérêts versés), dont
  indexation du capital des titres indexés de l'État (droits constatés). -/
  depenses : Int
  interets : Int
  chargeIndexation : Int
  /-- Dette de Maastricht en fin d'année ; dette négociable de l'État, dont
  titres à court terme (BTF) et titres indexés (valeur indexée), en fin
  d'année ; durée de vie moyenne de la dette négociable de l'État,
  dixièmes d'année. -/
  dette : Int
  detteNegociableEtat : Int
  detteCourtTerme : Int
  titresIndexes : Int
  dureeVieDixiemes : Int
  /-- Mesures nouvelles de prélèvements obligatoires de l'année (chiffrage
  officiel, nettes, au sens des prélèvements nets des crédits d'impôt). -/
  mesuresNouvellesPO : Int
  /-- Assiettes : rémunération des salariés (masse salariale) et dépense de
  consommation finale des ménages, en valeur. -/
  remunerationSalaries : Int
  consommationMenages : Int
  /-- Croissance du bénéfice fiscal de l'exercice (assiette de l'IS des
  deux années suivantes), pb. -/
  croissanceBeneficeFiscalPb : Int
  /-- Croissance de la valeur des transactions immobilières (nombre de
  ventes de logements anciens × prix), pb : assiette des droits de mutation
  à titre onéreux. -/
  croissanceTransactionsPb : Int
  /-- Coefficient légal de revalorisation des valeurs locatives de l'année,
  pb. -/
  revalorisationFoncierePb : Int
  deriving Repr, Inhabited

namespace AnneeObservee

def deficit (o : AnneeObservee) : Int := o.depenses - o.recettes
def deficitPb (o : AnneeObservee) : Int := ratioPb o.deficit o.pib
def depensesPrimaires (o : AnneeObservee) : Int := o.depenses - o.interets
def recettesHorsPO (o : AnneeObservee) : Int := o.recettes - o.prelevements
def dettePb (o : AnneeObservee) : Int := ratioPb o.dette o.pib

/-- Part de la dette indexée sur l'inflation en fin d'année, pm. -/
def partIndexeePm (o : AnneeObservee) : Int := if o.dette = 0 then 0 else o.titresIndexes * 1000 / o.dette
/-- Part de la dette à court terme en fin d'année, pm. -/
def partCourtTermePm (o : AnneeObservee) : Int := if o.dette = 0 then 0 else o.detteCourtTerme * 1000 / o.dette
/-- Part de la dette à moyen et long terme refinancée par an, pm : inverse
de sa durée de vie moyenne, déduite de celle de toute la dette négociable
de l'État (les titres à court terme ne comptant presque pas dans la
moyenne). -/
def renouvellementPm (o : AnneeObservee) : Int :=
  if o.dureeVieDixiemes ≤ 0 ∨ o.detteNegociableEtat ≤ 0 then 1000
  else (o.detteNegociableEtat - o.detteCourtTerme) * 10000 / (o.dureeVieDixiemes * o.detteNegociableEtat)

end AnneeObservee

def partProrata (d x t : Int) : Int := if d < 0 then -((-d) * x / t) else d * x / t

/-- Répartit `d` au prorata des dépenses primaires (la charge d'intérêts est
inchangée), parts arrondies vers zéro (reste sur le fonctionnement). -/
def ParFonction.repartirPrimaires (v : ParFonction) (d : Int) : ParFonction :=
  let t := v.total - v.interets
  if t = 0 then v.ajouter .fonctionnement d else
  let part (x : Int) := partProrata d x t
  let a := part v.retraites
  let b := part v.sante
  let c := part v.famille
  let e := part v.enseignement
  let f := part v.affairesEconomiques
  let g := part v.defense
  let h := part v.securiteJustice
  let i := part v.logementEnvironnement
  let j := part v.culture
  let n := part v.nonVentile
  { v with retraites := v.retraites + a, sante := v.sante + b, famille := v.famille + c
           enseignement := v.enseignement + e, affairesEconomiques := v.affairesEconomiques + f
           defense := v.defense + g, securiteJustice := v.securiteJustice + h
           logementEnvironnement := v.logementEnvironnement + i, culture := v.culture + j
           nonVentile := v.nonVentile + n
           fonctionnement := v.fonctionnement + (d - a - b - c - e - f - g - h - i - j - n) }

/-- Ramène les dépenses primaires de l'état à `cible` (structure par fonction
conservée), charge d'intérêts inchangée. -/
def Etat.avecDepensesPrimaires (s : Etat) (cible : Int) : Etat :=
  { s with depensesF := s.depensesF.repartirPrimaires (cible - s.depensesPrimaires) }

/-- État observé de fin d'année `o` (année précédente `p`), construit sur la
structure d'un état de référence `base` : répartition des prélèvements
(pour les élasticités) et des dépenses par fonction, emploi par secteur,
champs non financiers. Le taux apparent est celui de l'année (intérêts hors
indexation / dette de fin d'année précédente), le taux d'émission celui de
l'OAT de l'année diminué du rendement réel de la part indexée. -/
def etatObserve (H : Scenario) (base : Etat) (p o : AnneeObservee) : Etat :=
  let depF := base.depensesF.repartirPrimaires (o.depensesPrimaires - (base.depensesF.total - base.depensesF.interets))
  let depF := depF.ajouter .interets (o.interets - depF.interets)
  let actifs := base.actifs
  let emploiCible := actifs - actifs * o.chomagePb / 10000
  { base with
    pib := o.pib
    impots := base.impots.repartir (o.prelevements - base.impots.total)
    autresRecettes := o.recettesHorsPO
    depensesF := depF
    detteDebut := p.dette
    ajustementDetteAnnee := o.dette - p.dette - o.deficit
    operationsFinancieres := 0
    investissementsParticipations := 0
    tauxApparentPb := ratioPb (o.interets - o.chargeIndexation - appliquerPb p.detteCourtTerme o.tauxCourtPb)
      (p.dette - p.detteCourtTerme)
    tauxEmissionPb := o.tauxOat10Pb - appliquerPm H.eco.inflationPb (p.partIndexeePm)
    tauxMarginalCourantPb := o.tauxOat10Pb
    chargeIndexationMeur := o.chargeIndexation
    inflationConsoPb := o.inflationConsoPb
    emploi := base.emploi.repartir (emploiCible - base.emploi.total) none
    -- assiettes observées : rémunération par emploi (masse salariale de
    -- l'année), consommation, croissance du bénéfice fiscal des deux derniers
    -- exercices (IS)
    remunerationParEmploiEuros := if emploiCible = 0 then 0 else o.remunerationSalaries * 1000000 / emploiCible
    consommationMenages := o.consommationMenages
    croissanceBeneficePb := o.croissanceBeneficeFiscalPb
    croissanceBeneficeAvantPb := p.croissanceBeneficeFiscalPb
    chomeursComptes := actifs - emploiCible
    chomeursExcedentaires := 0
    emploisCoutTravailRestants := 0
    emploisPonderesCoutTravailRestants := 0
    echeances := []
    echeancesRecettes := []
    calendrierAgeLegal := []
    calendrierAgeTendanciel := []
    cdhrMeur := 0
    complementChomageMeur := 0
    pertePfuMeur := 0
    moderationDepensesPb := 0
    freinDeficitSeuilPb := 0
    dechargeStockageGwh := 0
    freinDeficitPb := 0
    electrificationTendanceMilliers := 0
    electrificationAnnuelleMilliers := 0
    electrificationAideePondereeMilliers := 0
    -- taux observés : la précision en ppm repart de leur valeur en pb
    tauxApparentPpm := 0
    tauxEmissionPpm := 0
    blocsDette := {}
    effetPrixTransportsPpm := 0
    effetPrixBatimentsPpm := 0
    -- champs que `etatDepart` initialise à partir du scénario
    decesMilliers := H.demo.decesMilliers
    robotisationPb := H.eco.robotisationTendanciellePb
    rang := 0 }

/-- Scénario de l'année suivant `o` : référence = état `e` de l'année `o`,
environnement macroéconomique observé de l'année suivante `s`, structure de
la dette (part indexée, renouvellement) de fin d'année `o`. -/
def scenarioRetro (H : Scenario) (e : Etat) (o s : AnneeObservee) : Scenario :=
  { H with
    reference := { H.reference with etat := e, annee := o.annee }
    -- électrification du parc : celle d'aujourd'hui ne vaut pas pour le passé ;
    -- l'emploi est observé : pas de facteur d'implantation
    energie := { H.energie with electrificationTendancielleMilliers := 0, hausseElectrificationMilliers := 0,
                                ajustementPrixEmissionsPm := 0,
                                electricite := { H.energie.electricite with elasticiteEmploiIndustrielPrixElecPm := 0 } }
    eco := { H.eco with
      -- le PIB est observé : il contient déjà les effets de demande
      multiplicateurPm := 0
      -- l'inflation est observée : pas de courbe de Phillips
      pentePhillipsPm := 0
      primeDettePb := 0
      -- échéancier et plancher de l'écart avec le Bund : ceux du départ de la
      -- projection, sans objet pour le passé (renouvellement uniforme de
      -- l'année observée, prime non bornée)
      echeancesDettePpm := []
      tauxEcheancesPpm := []
      tauxBundPb := 0
      ecartProductionDepartPb := 0
      -- émissions (non comparées au passé) : ni écart d'activité ni effet du
      -- prix du pétrole
      elasticitesEmissionsActivitePm :=
        { transports := 0, batiments := 0, agriculture := 0, industrie := 0, energie := 0, dechets := 0 }
      croissancePotentielleAnneesPb := [s.croissancePotentiellePb]
      croissanceVolumeAnneesPb := [s.croissanceVolumePb]
      inflationAnneesPb := [s.deflateurPb]
      inflationConsoAnneesPb := [s.inflationConsoPb]
      inflationIndexationAnneesPb := [s.inflationIndexationPb]
      tauxMarginalAnneesPb := [s.tauxOat10Pb]
      tauxCourtAnneesPb := [s.tauxCourtPb]
      revalorisationFoncierAnneesPb := [s.revalorisationFoncierePb]
      croissanceImmobilierAnneesPb := [s.croissanceTransactionsPb]
      partDetteCourtTermePm := o.partCourtTermePm
      partDetteIndexeePm := o.partIndexeePm
      renouvellementDettePm := o.renouvellementPm } }

/-- Résultat d'une année de rétro-test, M€ et pb : valeurs du modèle et
valeurs observées. -/
structure EcartRetro where
  annee : Nat
  /-- Prélèvements obligatoires (mesures nouvelles comprises). -/
  prelevementsModele : Int
  prelevementsObserves : Int
  /-- Évolution spontanée des prélèvements (hors mesures nouvelles), pb du
  niveau de l'année précédente. -/
  evolutionSpontaneeModelePb : Int
  evolutionSpontaneeObserveePb : Int
  /-- Charge d'intérêts, dont indexation. -/
  interetsModele : Int
  interetsObserves : Int
  indexationModele : Int
  indexationObservee : Int
  /-- Dépenses primaires selon la règle tendancielle du modèle (à titre
  d'information) et observées. -/
  depensesPrimairesRegle : Int
  depensesPrimairesObservees : Int
  /-- Déficit conditionnel (observé, prélèvements et intérêts du modèle) et
  observé, pb du PIB observé. -/
  deficitModelePb : Int
  deficitObservePb : Int
  /-- Dette de fin d'année, pb du PIB observé. -/
  detteModelePb : Int
  detteObserveePb : Int
  /-- Taux de chômage (loi d'Okun), pb. -/
  chomageModelePb : Int
  chomageObservePb : Int
  /-- Assiettes : masse salariale et consommation des ménages, M€. -/
  masseSalarialeModele : Int
  masseSalarialeObservee : Int
  consommationModele : Int
  consommationObservee : Int
  deriving Repr

namespace EcartRetro

def erreurDeficitPb (e : EcartRetro) : Int := e.deficitModelePb - e.deficitObservePb
def erreurPrelevements (e : EcartRetro) : Int := e.prelevementsModele - e.prelevementsObserves
def erreurInterets (e : EcartRetro) : Int := e.interetsModele - e.interetsObserves
def erreurDettePb (e : EcartRetro) : Int := e.detteModelePb - e.detteObserveePb
/-- Erreurs sur les assiettes, pb de la valeur observée. -/
def erreurMasseSalarialePb (e : EcartRetro) : Int :=
  ratioPb (e.masseSalarialeModele - e.masseSalarialeObservee) e.masseSalarialeObservee
def erreurConsommationPb (e : EcartRetro) : Int :=
  ratioPb (e.consommationModele - e.consommationObservee) e.consommationObservee

end EcartRetro

/-- Une année de projection conditionnelle depuis l'état `e` (comptes de
l'année `o`, observés ou simulés) vers l'année `s` : `anneeSuivante`, puis
les décisions de l'année `s` (mesures nouvelles de prélèvements, dépenses
primaires et recettes hors prélèvements observées). Le PIB est celui de la
trajectoire observée : aucune impulsion de demande n'est ajoutée, l'activité
observée les contenant déjà. Renvoie aussi la dépense primaire selon la
règle tendancielle et les prélèvements avant mesures nouvelles. -/
def anneeConditionnelle (M : Moteur) (H : Scenario) (e : Etat) (o s : AnneeObservee) : Etat × Int × Int :=
  let H' := scenarioRetro H e o s
  let s₁ := anneeSuivante M H' e
  let regle := s₁.depensesPrimaires
  let spontanes := s₁.impots.total
  let s₂ := { s₁ with impots := s₁.impots.ajouter .autres s.mesuresNouvellesPO
                      autresRecettes := s.recettesHorsPO }
  (s₂.avecDepensesPrimaires s.depensesPrimaires, regle, spontanes)

/-- Écart d'une année simulée `x` à l'année observée `s` (année précédente
observée `o`, prélèvements de départ `po0`). -/
def ecartAnnee (x : Etat) (regle spontanes po0 : Int) (o s : AnneeObservee) : EcartRetro :=
  { annee := s.annee
    prelevementsModele := x.impots.total, prelevementsObserves := s.prelevements
    evolutionSpontaneeModelePb := ratioPb (spontanes - po0) po0
    evolutionSpontaneeObserveePb := ratioPb (s.prelevements - s.mesuresNouvellesPO - o.prelevements) o.prelevements
    interetsModele := x.chargeInterets, interetsObserves := s.interets
    indexationModele := x.chargeIndexationMeur, indexationObservee := s.chargeIndexation
    depensesPrimairesRegle := regle, depensesPrimairesObservees := s.depensesPrimaires
    deficitModelePb := ratioPb x.deficit s.pib, deficitObservePb := s.deficitPb
    detteModelePb := ratioPb x.dette s.pib, detteObserveePb := s.dettePb
    chomageModelePb := x.chomagePb, chomageObservePb := s.chomagePb
    masseSalarialeModele := x.masseSalariale, masseSalarialeObservee := s.remunerationSalaries
    consommationModele := x.consommationMenages, consommationObservee := s.consommationMenages }

/-- Rétro-test à un an : pour chaque triplet d'années consécutives
`(p, o, s)`, on part des comptes observés de `o` (année précédente `p`) et
on simule `s`. -/
def retroUnAn (M : Moteur) (H : Scenario) (base : Etat) : List AnneeObservee → List EcartRetro
  | p :: o :: s :: r =>
    let e := etatObserve H base p o
    let (x, regle, spontanes) := anneeConditionnelle M H e o s
    ecartAnnee x regle spontanes e.impots.total o s :: retroUnAn M H base (o :: s :: r)
  | _ => []

/-- Rétro-test sur plusieurs années : on part des comptes observés de la
deuxième année de la liste, puis chaque année est simulée à partir de
l'année simulée précédente (prélèvements, intérêts et dette du modèle ;
dépenses primaires, recettes hors prélèvements et mesures observées). -/
def retroPlusieursAnnees (M : Moteur) (H : Scenario) (base : Etat) : List AnneeObservee → List EcartRetro
  | p :: o :: r =>
    let rec boucle (e : Etat) (o : AnneeObservee) : List AnneeObservee → List EcartRetro
      | [] => []
      | s :: r' =>
        let (x, regle, spontanes) := anneeConditionnelle M H e o s
        -- l'année simulée devient le départ de la suivante (rang remis à 0 :
        -- trajectoire d'un an)
        ecartAnnee x regle spontanes e.impots.total o s :: boucle { x with rang := 0 } s r'
    boucle (etatObserve H base p o) o r
  | _ => []

/-- Moyenne des valeurs absolues (arrondi par défaut). -/
def moyenneAbsolue (l : List Int) : Int :=
  if l.length = 0 then 0 else ((l.map Int.natAbs).sum / l.length : Nat)

/-- Moyenne (arrondi vers moins l'infini). -/
def moyenne (l : List Int) : Int :=
  if l.length = 0 then 0 else l.sum / l.length

end Modele
