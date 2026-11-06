import Modele.Unites

/-!
# Bloc de demande : le PIB par la demande, en écarts au tendanciel

Les mesures d'un programme agissent sur la demande par un **canal** (voir
`Canal`) : consommation publique, investissement, transferts aux ménages,
prélèvements sur les ménages, taxes sur la consommation, coût du travail,
coût du capital, échanges extérieurs. Le bloc calcule chaque année l'écart
au tendanciel de chaque composante de la demande, par une équation propre :

* **consommation des ménages** : revenu disponible réel (salaires nets,
  prestations indexées avec un an de retard, transferts et prélèvements des
  mesures), à correction d'erreur, plus un effet transitoire du chômage
  (épargne de précaution) ;
* **investissement des entreprises** : accélérateur sur la production
  marchande et coût d'usage du capital (impôts sur les sociétés) ;
* **dépense publique** : les chocs des mesures (consommation publique,
  emplois publics, investissement) ;
* **exportations** : demande mondiale et compétitivité-prix ;
* **importations** : contenu en importations de chaque composante et prix
  relatifs ;
* **PIB = consommation + investissement + dépense publique + exportations −
  importations.**

Le multiplicateur budgétaire n'est plus un paramètre : il résulte de ces
équations, différent selon le canal et l'horizon (délais de diffusion). Il
est comparé aux « variantes usuelles » publiées par Mésange (Insee–DG
Trésor), FR-BDF (Banque de France) et e-mod.fr (OFCE) dans
`Tests/Demande.lean`.

**Offre.** L'emploi rejoint la production marchande avec retard (cycle de
productivité) ; le chômage s'écarte de celui de la trajectoire de référence,
qui tient lieu de chômage d'équilibre (aucune estimation récente du NAWRU n'a
pu être sourcée, voir `Hypotheses/Economie.lean`) ; les salaires suivent les
prix à la consommation (à long terme, leur part intérieure : la part
importée suit les prix mondiaux) et baissent quand le chômage monte (courbe
de salaire de Mésange) ; les prix de valeur ajoutée suivent le coût salarial
unitaire, les marges des entreprises absorbant d'abord une partie des
baisses de coût du travail ; l'écart de production tire un peu les prix.
L'investissement des entreprises accumule un capital qui relève le PIB
potentiel (fonction de production à rendements constants) : il réduit
l'écart de production, donc la hausse des prix.

**Limites connues.** Les emplois publics créés n'entrent ni dans le revenu
des ménages ni dans le chômage du bloc (leurs salaires et la baisse du
chômage sont comptés hors du bloc : prélèvements en retour, loi d'Okun) ;
les emplois dus aux allègements de cotisations, aux migrations et à la loi
d'Okun n'y entrent pas non plus, si bien que la courbe de salaire ne voit
pas ces emplois. Les dépenses prévues par les échéanciers de la référence
(loi de programmation militaire…) nourrissent aussi le bloc au tendanciel,
alors que la trajectoire de référence les comprend déjà.

**Forme des équations.** Chaque comportement est une équation à correction
d'erreur annuelle : `y_t = y_{t−1} + b Δz_t + b₂ Δz_{t−1} + a (L z_{t−1} −
y_{t−1})`, dont les coefficients reproduisent le profil des élasticités
publié par Mésange (réponse à 1, 2 et 5 ans d'un choc permanent). Les
équations d'une même année sont résolues ensemble par huit itérations de
point fixe.

**Unités.** Entiers : quantités en millionièmes du PIB courant (ppm), prix,
salaires et emploi en ppm d'écart relatif, chômage en ppm de point de taux
(10 000 ppm = 1 point), coefficients en pour mille.
-/

namespace Modele

/-- Canal par lequel une mesure agit sur la demande : chaque canal a sa
propre réponse (multiplicateur et délais de diffusion), comme les
« variantes usuelles » des modèles macroéconométriques, qui distinguent
l'investissement public, la consommation publique, les transferts aux
ménages, les prélèvements sur les ménages, la TVA et les impôts sur les
entreprises. -/
inductive Canal where
  /-- Consommation publique : fonctionnement, santé, enseignement, défense… -/
  | consommationPublique
  /-- Rémunération d'emplois publics créés : demande publique, sans effet sur
  l'emploi marchand (les postes sont comptés par le levier). -/
  | emploisPublics
  /-- Investissement, public ou privé (construction, équipements). -/
  | investissement
  /-- Part intérieure d'un investissement dont la part importée est déjà
  inscrite par le levier (outre-mer, équipements de transition). -/
  | investissementInterieur
  /-- Transferts aux ménages : prestations, rémunérations nettes versées. -/
  | transferts
  /-- Prélèvements sur les ménages : impôt sur le revenu, CSG, cotisations,
  taxe foncière, patrimoine, droits. -/
  | prelevementsMenages
  /-- Taxes sur la consommation : TVA, accises. -/
  | taxesConsommation
  /-- Coût du travail : cotisations des employeurs, allègements. -/
  | coutTravail
  /-- Entreprises : impôt sur les sociétés (coût d'usage du capital). -/
  | entreprises
  /-- Échanges extérieurs : exportations, importations évitées. -/
  | exterieur
  deriving Repr, DecidableEq, Inhabited

namespace Canal

def tous : List Canal :=
  [.consommationPublique, .emploisPublics, .investissement, .investissementInterieur, .transferts,
   .prelevementsMenages, .taxesConsommation, .coutTravail, .entreprises, .exterieur]

def id : Canal → String
  | .consommationPublique => "consommationPublique"
  | .emploisPublics => "emploisPublics"
  | .investissement => "investissement"
  | .investissementInterieur => "investissementInterieur"
  | .transferts => "transferts"
  | .prelevementsMenages => "prelevementsMenages"
  | .taxesConsommation => "taxesConsommation"
  | .coutTravail => "coutTravail"
  | .entreprises => "entreprises"
  | .exterieur => "exterieur"

def nom : Canal → String
  | .consommationPublique => "Consommation publique"
  | .emploisPublics => "Emplois publics"
  | .investissement => "Investissement"
  | .investissementInterieur => "Investissement (part intérieure)"
  | .transferts => "Transferts aux ménages"
  | .prelevementsMenages => "Prélèvements sur les ménages"
  | .taxesConsommation => "TVA et accises"
  | .coutTravail => "Coût du travail"
  | .entreprises => "Impôt sur les sociétés"
  | .exterieur => "Échanges extérieurs"

end Canal

/-- Paramètres du bloc de demande (pour mille sauf mention), sourcés dans
`Hypotheses/Economie.lean`. Les noms en `…Court` sont l'effet de l'année du
choc, `…Retard` celui de la variation de l'année précédente, `…Rappel` la
force de rappel annuelle, `…Long` l'élasticité de long terme. -/
structure ParametresDemande where
  /-- Parts dans le PIB : consommation des ménages, revenu disponible brut,
  investissement des entreprises non financières, exportations,
  importations, salaires nets, prestations sociales, rémunérations
  (coût du travail), excédent brut d'exploitation des sociétés non
  financières. -/
  partConsoPm : Int
  partRevenuPm : Int
  partInvestPm : Int
  partExportPm : Int
  partImportPm : Int
  partSalairesNetsPm : Int
  partPrestationsPm : Int
  partRemunerationsPm : Int
  partEbePm : Int
  /-- Consommation : revenu disponible réel. -/
  consoCourtPm : Int
  consoRappelPm : Int
  /-- Consommation : effet d'un point de chômage en plus (pour mille de la
  consommation par point), qui s'efface au rythme `consoChomagePersistancePm`. -/
  consoChomagePm : Int
  consoChomagePersistancePm : Int
  /-- Investissement des entreprises : accélérateur. -/
  investCourtPm : Int
  investRetardPm : Int
  investRappelPm : Int
  /-- Investissement des entreprises : coût d'usage du capital. -/
  coutCapitalCourtPm : Int
  coutCapitalRappelPm : Int
  coutCapitalLongPm : Int
  /-- Exportations : demande mondiale et compétitivité-prix. -/
  exportDemandeCourtPm : Int
  exportDemandeRappelPm : Int
  exportPrixCourtPm : Int
  exportPrixRappelPm : Int
  exportPrixLongPm : Int
  /-- Importations : demande pondérée par le contenu en importations, prix
  relatifs. -/
  importDemandeCourtPm : Int
  importDemandeRappelPm : Int
  importPrixCourtPm : Int
  importPrixRappelPm : Int
  importPrixLongPm : Int
  /-- Contenu en importations : consommation des ménages, investissement,
  exportations, consommation publique. -/
  contenuImportConsoPm : Int
  contenuImportInvestPm : Int
  contenuImportExportPm : Int
  contenuImportConsoPubliquePm : Int
  /-- Emploi : réponse à la production marchande. -/
  emploiCourtPm : Int
  emploiRappelPm : Int
  /-- Salaires : prix à la consommation (court terme, retard), rappel vers
  les prix hors taxes indirectes ; chômage (court terme, rappel, long
  terme en pour mille de salaire par point). -/
  salairesPrixCourtPm : Int
  salairesPrixRetardPm : Int
  salairesPrixRappelPm : Int
  salairesChomageCourtPm : Int
  salairesChomageRappelPm : Int
  salairesChomageLongPm : Int
  /-- Prix de valeur ajoutée : coût salarial unitaire, tension (écart de
  production). -/
  prixCoutCourtPm : Int
  prixCoutRappelPm : Int
  prixTensionPm : Int
  /-- Part importée des prix à la consommation et à l'exportation. -/
  partImporteePrixConsoPm : Int
  partImporteePrixExportPm : Int
  /-- Transmission d'un choc de coût du travail aux prix (marges). -/
  coutTravailCourtPm : Int
  coutTravailRappelPm : Int
  /-- Transmission des taxes sur la consommation aux prix à la consommation
  la première année. -/
  transmissionTaxesPm : Int
  /-- Capital des entreprises : dépréciation, ratio au PIB, élasticité du PIB
  potentiel. -/
  depreciationCapitalPm : Int
  capitalPibPm : Int
  elasticitePibCapitalPm : Int
  /-- Valeur de `Economie.multiplicateurPm` pour laquelle les réponses du
  bloc sont prises telles quelles (scénario central). -/
  multiplicateurReferencePm : Int
  deriving Repr

/-- Chocs cumulés des mesures, par canal : millionièmes du PIB courant au
moment du choc (signe : positif quand la mesure soutient la demande). -/
structure ChocsDemande where
  consoPublique : Int := 0
  emploisPublics : Int := 0
  investissement : Int := 0
  investissementInterieur : Int := 0
  revenu : Int := 0
  taxesConsommation : Int := 0
  coutTravail : Int := 0
  entreprises : Int := 0
  exterieur : Int := 0
  /-- Demande mondiale (ppm d'écart relatif) : sans mesure qui la porte,
  utilisée par les tests de variantes. -/
  demandeMondiale : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace ChocsDemande

/-- Ajoute l'impulsion `ppm` au canal `c`. -/
def ajouter (h : ChocsDemande) (c : Canal) (ppm : Int) : ChocsDemande :=
  match c with
  | .consommationPublique => { h with consoPublique := h.consoPublique + ppm }
  | .emploisPublics => { h with emploisPublics := h.emploisPublics + ppm }
  | .investissement => { h with investissement := h.investissement + ppm }
  | .investissementInterieur => { h with investissementInterieur := h.investissementInterieur + ppm }
  | .transferts | .prelevementsMenages => { h with revenu := h.revenu + ppm }
  | .taxesConsommation => { h with taxesConsommation := h.taxesConsommation + ppm }
  | .coutTravail => { h with coutTravail := h.coutTravail + ppm }
  | .entreprises => { h with entreprises := h.entreprises + ppm }
  | .exterieur => { h with exterieur := h.exterieur + ppm }

end ChocsDemande

/-- Écarts d'une année au tendanciel (voir le module pour les unités). -/
structure EcartsDemande where
  /-- PIB, PIB marchand (sans les emplois publics), PIB avant résorption. -/
  pib : Int := 0
  pibMarchand : Int := 0
  pibBrut : Int := 0
  /-- Consommation (hors effet du chômage) et effet du chômage (ppm de la
  consommation). -/
  conso : Int := 0
  consoChomage : Int := 0
  /-- Investissement des entreprises : accélérateur et coût du capital. -/
  invest : Int := 0
  investCout : Int := 0
  /-- Exportations : demande mondiale, prix ; importations : demande, prix ;
  demande pondérée par le contenu en importations. -/
  exportDemande : Int := 0
  exportPrix : Int := 0
  importDemande : Int := 0
  importPrix : Int := 0
  demandeImportee : Int := 0
  /-- Revenu disponible réel des ménages. -/
  revenu : Int := 0
  /-- Emploi (ppm), chômage (ppm de point). -/
  emploi : Int := 0
  chomage : Int := 0
  /-- Salaires : composantes prix et chômage. -/
  salairesPrix : Int := 0
  salairesChomage : Int := 0
  /-- Coût du travail transmis, coût salarial unitaire. -/
  coutTravail : Int := 0
  coutUnitaire : Int := 0
  /-- Prix de valeur ajoutée, à la consommation, à l'exportation. -/
  prixVa : Int := 0
  prixConso : Int := 0
  prixExport : Int := 0
  /-- Écart résorbé par le moteur (moteurs d'offre). -/
  resorbe : Int := 0
  /-- Capital des entreprises accumulé par l'accélérateur (ppm du PIB). -/
  capital : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace EcartsDemande

def salaires (e : EcartsDemande) : Int := e.salairesPrix + e.salairesChomage

def consommation (P : ParametresDemande) (e : EcartsDemande) : Int :=
  e.conso + e.consoChomage * P.partConsoPm / 1000

def exportations (e : EcartsDemande) : Int := e.exportDemande + e.exportPrix

def importations (e : EcartsDemande) : Int := e.importDemande + e.importPrix

/-- Effet sur le PIB potentiel du capital accumulé (ppm du PIB). -/
def potentielCapital (P : ParametresDemande) (e : EcartsDemande) : Int :=
  if P.capitalPibPm = 0 then 0 else e.capital * P.elasticitePibCapitalPm / P.capitalPibPm

end EcartsDemande

/-- Équation à correction d'erreur annuelle (voir le module). -/
def ecm (yPrec z zPrec zPrec2 b b2 a l : Int) : Int :=
  yPrec + (b * (z - zPrec) + b2 * (zPrec - zPrec2) + a * (l * zPrec / 1000 - yPrec)) / 1000

/-- Une année du bloc : écarts de l'année à partir de ceux des deux années
précédentes, des chocs cumulés (`ch`) et de ceux de l'année précédente
(`chPrec`). `mult` (pour mille) module toutes les réponses de demande
(axe économique) ; `tauxEmploiPm` est le rapport emploi / actifs ;
`flexionPm` l'effet de flexion ; `resorptionPm` et `durablePm` les
paramètres de résorption du moteur. -/
def resoudre (P : ParametresDemande) (mult tauxEmploiPm flexionPm resorptionPm durablePm : Int)
    (prec prec2 : EcartsDemande) (ch chPrec : ChocsDemande) : EcartsDemande :=
  let sC := P.partConsoPm
  let sR := P.partRevenuPm
  let sI := P.partInvestPm
  let sX := P.partExportPm
  let sM := P.partImportPm
  -- chocs de l'année : taxes sur la consommation → prix ; coût du travail ;
  -- coût du capital (ppm d'écart relatif)
  let prixTaxes := if sC = 0 then 0 else -(ch.taxesConsommation * P.transmissionTaxesPm / sC)
  let cout := if P.partRemunerationsPm = 0 then 0 else -(ch.coutTravail * 1000 / P.partRemunerationsPm)
  let coutPrec := if P.partRemunerationsPm = 0 then 0 else -(chPrec.coutTravail * 1000 / P.partRemunerationsPm)
  let ck := if P.partEbePm = 0 then 0 else -(ch.entreprises * 1000 / P.partEbePm)
  let ckPrec := if P.partEbePm = 0 then 0 else -(chPrec.entreprises * 1000 / P.partEbePm)
  -- résorption par le moteur (valeurs de l'année précédente)
  let resorbe := prec.resorbe
    + resorptionPm * ((1000 - durablePm) * prec.pibBrut / 1000 - prec.resorbe) / 1000
  let capital := (1000 - P.depreciationCapitalPm) * prec.capital / 1000 + prec.invest
  -- fonction de production : le capital accumulé relève le PIB potentiel,
  -- ce qui réduit l'écart de production qui tire les prix
  let potentiel := if P.capitalPibPm = 0 then 0 else capital * P.elasticitePibCapitalPm / P.capitalPibPm
  -- une itération de point fixe
  let pas (e : EcartsDemande) : EcartsDemande :=
    let emploi := ecm prec.emploi e.pibMarchand prec.pibMarchand prec2.pibMarchand
      P.emploiCourtPm 0 P.emploiRappelPm 1000
    -- une part `flexion / (1 + flexion)` des emplois vient de l'inactivité
    let chomage := -(emploi * 1000 / (1000 + flexionPm) * tauxEmploiPm / 1000)
    let salairesPrix := prec.salairesPrix
      + (P.salairesPrixCourtPm * (e.prixConso - prec.prixConso)
        + P.salairesPrixRetardPm * (prec.prixConso - prec2.prixConso)
        + P.salairesPrixRappelPm * ((1000 - P.partImporteePrixConsoPm) * prec.prixVa / 1000
            - prec.salairesPrix)) / 1000
    let salairesChomage := ecm prec.salairesChomage chomage prec.chomage prec2.chomage
      (-P.salairesChomageCourtPm) 0 P.salairesChomageRappelPm (-P.salairesChomageLongPm)
    let coutTravail := ecm prec.coutTravail cout coutPrec coutPrec
      P.coutTravailCourtPm 0 P.coutTravailRappelPm 1000
    let coutUnitaire := salairesPrix + salairesChomage + coutTravail
    let prixVa := ecm prec.prixVa coutUnitaire prec.coutUnitaire prec2.coutUnitaire
      P.prixCoutCourtPm 0 P.prixCoutRappelPm 1000 + P.prixTensionPm * (e.pib - potentiel) / 1000
    let prixConso := (1000 - P.partImporteePrixConsoPm) * prixVa / 1000 + prixTaxes
    let prixExport := (1000 - P.partImporteePrixExportPm) * prixVa / 1000
    let revenu := ch.revenu
      + P.partSalairesNetsPm * (emploi + salairesPrix + salairesChomage - prixConso) / 1000
      + P.partPrestationsPm * (prec.prixConso - prixConso) / 1000
      - (sR - P.partSalairesNetsPm - P.partPrestationsPm) * prixConso / 1000
    let zC := if sR = 0 then 0 else sC * revenu / sR
    let zCPrec := if sR = 0 then 0 else sC * prec.revenu / sR
    let zCPrec2 := if sR = 0 then 0 else sC * prec2.revenu / sR
    let conso := ecm prec.conso zC zCPrec zCPrec2 P.consoCourtPm 0 P.consoRappelPm 1000
    let consoChomage := P.consoChomagePersistancePm * prec.consoChomage / 1000
      - P.consoChomagePm * (chomage - prec.chomage) / 1000
    -- accélérateur : la production marchande (les emplois publics ajoutés
    -- n'appellent pas d'investissement des entreprises)
    let invest := ecm prec.invest (sI * e.pibMarchand / 1000) (sI * prec.pibMarchand / 1000)
      (sI * prec2.pibMarchand / 1000)
      P.investCourtPm P.investRetardPm P.investRappelPm 1000
    let investCout := ecm prec.investCout (sI * ck / 1000) (sI * ckPrec / 1000) (sI * ckPrec / 1000)
      (-P.coutCapitalCourtPm) 0 P.coutCapitalRappelPm (-P.coutCapitalLongPm)
    let exportDemande := ecm prec.exportDemande (sX * ch.demandeMondiale / 1000)
      (sX * chPrec.demandeMondiale / 1000) (sX * chPrec.demandeMondiale / 1000)
      P.exportDemandeCourtPm 0 P.exportDemandeRappelPm 1000
    let exportPrix := ecm prec.exportPrix (sX * prixExport / 1000) (sX * prec.prixExport / 1000)
      (sX * prec2.prixExport / 1000) (-P.exportPrixCourtPm) 0 P.exportPrixRappelPm (-P.exportPrixLongPm)
    let exportations := exportDemande + exportPrix + ch.exterieur
    let consommation := conso + consoChomage * sC / 1000
    let demandeImportee := (P.contenuImportConsoPm * consommation
      + P.contenuImportInvestPm * (invest + investCout + ch.investissement)
      + P.contenuImportConsoPubliquePm * ch.consoPublique
      + P.contenuImportExportPm * exportations) / 1000
    let importDemande := ecm prec.importDemande demandeImportee prec.demandeImportee prec2.demandeImportee
      P.importDemandeCourtPm 0 P.importDemandeRappelPm 1000
    let importPrix := ecm prec.importPrix (sM * prixVa / 1000) (sM * prec.prixVa / 1000)
      (sM * prec2.prixVa / 1000) P.importPrixCourtPm 0 P.importPrixRappelPm P.importPrixLongPm
    let pibBrut := (consommation + invest + investCout + ch.consoPublique + ch.emploisPublics
      + ch.investissement + ch.investissementInterieur + exportations - importDemande - importPrix)
      * mult / 1000
    let pib := pibBrut - resorbe
    { pib := pib, pibMarchand := pib - ch.emploisPublics * mult / 1000, pibBrut := pibBrut
      conso := conso, consoChomage := consoChomage, invest := invest, investCout := investCout
      exportDemande := exportDemande, exportPrix := exportPrix, importDemande := importDemande
      importPrix := importPrix, demandeImportee := demandeImportee, revenu := revenu
      emploi := emploi, chomage := chomage, salairesPrix := salairesPrix
      salairesChomage := salairesChomage, coutTravail := coutTravail, coutUnitaire := coutUnitaire
      prixVa := prixVa, prixConso := prixConso, prixExport := prixExport, resorbe := resorbe
      capital := capital }
  pas (pas (pas (pas (pas (pas (pas (pas prec)))))))

/-- Simulation d'un choc permanent (variante usuelle) : écarts des `n`
premières années. Sert aux tests (multiplicateurs par canal). -/
def simulerChoc (P : ParametresDemande) (mult tauxEmploiPm flexionPm : Int) (ch : ChocsDemande) :
    Nat → List EcartsDemande :=
  let rec boucle : Nat → EcartsDemande → EcartsDemande → ChocsDemande → List EcartsDemande
    | 0, _, _, _ => []
    | n + 1, prec, prec2, chPrec =>
      let e := resoudre P mult tauxEmploiPm flexionPm 0 1000 prec prec2 ch chPrec
      e :: boucle n e prec ch
  fun n => boucle n {} {} {}

end Modele
