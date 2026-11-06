import Modele
import Hypotheses

/-!
# Tests du modèle commun : mécanismes

Chaque test isole un mécanisme en faisant varier une seule hypothèse ou une
seule mesure, et compare la réponse du modèle à son paramètre ou à une
estimation publiée (fourchettes larges : ce sont des garde-fous contre une
erreur de mécanisme, pas des calages).
-/

namespace Tests.Mecanismes
open Modele

def D : Moteur := Hypotheses.Moteurs.demande

/-- Scénario central dont la situation de départ est débarrassée des
échéanciers (dépenses et recettes temporaires, lois de programmation) et
des calendriers d'âge légal : les mécanismes y sont isolés. -/
def H : Scenario :=
  let C := Hypotheses.central
  { C with reference := { C.reference with etat := { C.reference.etat with
      echeances := [], echeancesRecettes := [], calendrierAgeLegal := [],
      calendrierAgeTendanciel := [] } } }

/-- Ce scénario avec une autre trajectoire de première année. -/
def avecPremiereAnnee (volume prix conso taux : Int) : Scenario :=
  { H with eco := { H.eco with
      croissancePotentielleAnneesPb := [H.eco.croissancePotentiellePb],
      croissanceVolumeAnneesPb := [volume], inflationAnneesPb := [prix],
      inflationConsoAnneesPb := [conso], tauxMarginalAnneesPb := [taux] } }

/-- Même scénario, à l'écart de production de départ nul (la courbe de
Phillips n'y ajoute rien la première année) et sans facteur d'implantation
(le coût de l'électricité ne déplace pas d'emplois industriels). -/
def base : Scenario :=
  let S := avecPremiereAnnee H.eco.croissancePotentiellePb H.eco.inflationPb H.eco.inflationPb H.eco.tauxMarginalPb
  { S with eco := { S.eco with ecartProductionDepartPb := 0 }
           energie := { S.energie with electricite := { S.energie.electricite with
             elasticiteEmploiIndustrielPrixElecPm := 0 } } }

/-- Première année projetée. -/
def an1 (S : Scenario) : Etat := anneeSuivante D S (etatDepart S)

/-! ## Croissance et PIB -/

/-- Le PIB de la première année croît de la croissance nominale de la
trajectoire (volume et prix), à l'arrondi près. -/
theorem pib_suit_la_trajectoire :
    let s0 := etatDepart base
    let s1 := an1 base
    (s1.pib - s0.pib) * 10000 / s0.pib = base.eco.croissanceNominaleA 0 := by decide +kernel

/-- Loi d'Okun : un point de croissance en volume de plus la première année
abaisse le taux de chômage d'environ `okunPm` × 1 point (0,4 point ; la
flexion de la population active en retient un peu). -/
theorem okun_un_point :
    let haut := an1 (avecPremiereAnnee (H.eco.croissancePotentiellePb + 100) H.eco.inflationPb H.eco.inflationPb H.eco.tauxMarginalPb)
    let d := (an1 base).chomagePb - haut.chomagePb
    35 ≤ d ∧ d ≤ 45 := by decide +kernel

/-- Semi-élasticité du solde public au cycle : un point de croissance en
volume de plus réduit le déficit d'environ 0,5 à 0,65 point de PIB une
fois l'IS encaissé (LPFP 2023-2027 : 0,57 ; Commission européenne : 0,6
environ), un peu moins la première année : l'IS des entreprises hors
cinquième acompte suit le bénéfice avec un an de retard (acomptes et
solde), ce que les élasticités de la LPFP, contemporaines, ne
représentent pas. -/
theorem semi_elasticite_solde :
    let haut := avecPremiereAnnee (H.eco.croissancePotentiellePb + 100) H.eco.inflationPb H.eco.inflationPb H.eco.tauxMarginalPb
    let d1 := (an1 base).deficitPb - (an1 haut).deficitPb
    let d2 := (projeterN D base 2 (etatDepart base)).deficitPb - (projeterN D haut 2 (etatDepart haut)).deficitPb
    40 ≤ d1 ∧ d1 ≤ 55 ∧ 50 ≤ d2 ∧ d2 ≤ 65 := by decide +kernel

/-! ## Charge d'intérêts -/

/-- Indexation : un point d'inflation de plus sur les prix à la
consommation accroît la charge d'intérêts de la part indexée de la dette
(× 1 %), au million près. -/
theorem indexation_un_point :
    let s0 := etatDepart base
    let haut := an1 (avecPremiereAnnee H.eco.croissancePotentiellePb H.eco.inflationPb (H.eco.inflationPb + 100) H.eco.tauxMarginalPb)
    let d := haut.chargeInterets - (an1 base).chargeInterets
    let attendu := s0.dette * H.eco.partDetteIndexeePm / 1000 / 100
    attendu - 1 ≤ d ∧ d ≤ attendu + 1 := by decide +kernel

/-- Refinancement : un point de taux marginal de plus ne relève le taux
apparent que de la part émise dans l'année : la part du stock qui arrive à
échéance la première année (échéancier `echeancesDettePpm`, ou à défaut
`renouvellementDettePm`), × 1 point, à l'arrondi près. -/
theorem refinancement_un_point :
    let haut := an1 (avecPremiereAnnee H.eco.croissancePotentiellePb H.eco.inflationPb H.eco.inflationPb (H.eco.tauxMarginalPb + 100))
    let d := haut.tauxApparentPb - (an1 base).tauxApparentPb
    let part := (H.eco.echeancesDettePpm[0]?).getD (H.eco.renouvellementDettePm * 1000)
    let attendu := 100 * part / 1000000
    attendu - 1 ≤ d ∧ d ≤ attendu + 1 := by decide +kernel

/-- Échéancier uniforme : `r × (1 − r)^k` du stock de départ, au taux du
stock existant. Il doit redonner le renouvellement uniforme. -/
def echeancierUniforme : List Int :=
  let r := H.eco.renouvellementDettePm
  (List.range 12).map fun k => r * 1000 * (1000 - r) ^ k / 1000 ^ k

def sansEcheancier : Scenario :=
  { H with eco := { H.eco with echeancesDettePpm := [], tauxEcheancesPpm := [] } }
def avecUniforme : Scenario :=
  { H with eco := { H.eco with echeancesDettePpm := echeancierUniforme, tauxEcheancesPpm := [] } }

/-- Avec un échéancier uniforme, le suivi par blocs (stock de départ,
dette émise ensuite) redonne la charge d'intérêts du renouvellement
uniforme à 50 M€ près chaque année, sur dix ans (arrondis). -/
theorem echeancier_uniforme_equivalent :
    ((trajectoire D sansEcheancier 10 (etatDepart sansEcheancier)).zip
      (trajectoire D avecUniforme 10 (etatDepart avecUniforme))).all
      (fun (a, b) => decide ((b.chargeInterets - a.chargeInterets).natAbs ≤ 50)) = true := by
  decide +kernel

/-- Le taux apparent reste entre le taux du stock et le taux d'émission, et
s'approche du second chaque année (taux marginal constant, sans programme). -/
def convergeVers : List Etat → Bool
  | a :: b :: r =>
    let ecartA := a.tauxEmissionPb - a.tauxApparentPb
    let ecartB := b.tauxEmissionPb - b.tauxApparentPb
    decide (0 ≤ ecartB ∧ ecartB ≤ ecartA) && convergeVers (b :: r)
  | _ => true

/-- À taux marginal constant (sans prime de risque ni trajectoire de
taux), le taux apparent se rapproche du taux d'émission chaque année sans
le dépasser. -/
def sansPrime : Scenario := { H with eco := { H.eco with primeDeficitPb := 0, tauxMarginalAnneesPb := [] } }

theorem taux_apparent_converge :
    convergeVers ((trajectoire D sansPrime 10 (etatDepart sansPrime)).drop 1) = true := by
  decide +kernel

/-! ## Mesures -/

def mesure (l : Levier) : Programme :=
  { id := "M", nom := "M", description := "", mainteneurs := [], source := "",
    mesures := [{ id := "M-1", titre := "", source := "", leviers := [l] }] }

def depart (p : Programme) : Etat := p.etatInitial D H

/-- Multiplicateur : une dépense de consommation publique d'un point de PIB
relève le PIB de l'année d'environ un point (bloc de demande : 1,04 point la
première année), entre FR-BDF (0,97) et e-mod.fr (1,2) ; voir
`Tests/Demande.lean` pour les autres canaux et les années suivantes. -/
theorem multiplicateur_depense :
    let s0 := etatDepart H
    let un := s0.pib / 100
    let p := depart (mesure (.depenseSur .enseignement un))
    let d := (p.pib - s0.pib) * 10000 / s0.pib
    97 ≤ d ∧ d ≤ 110 := by decide +kernel

/-- Une dépense creuse le déficit, mais moins que son montant (recettes
induites par l'activité) ; une économie du même montant, au moteur de
demande, a l'effet opposé (aux arrondis près : un million par prélèvement
et par étape). -/
theorem depense_economie_symetriques :
    let s0 := etatDepart H
    let dep := depart (mesure (.depenseSur .enseignement 10000))
    let eco := depart (mesure (.economieSur .enseignement 10000))
    0 < dep.deficit - s0.deficit ∧ dep.deficit - s0.deficit < 10000 ∧
      dep.deficit - s0.deficit + (eco.deficit - s0.deficit) ≤ 25 ∧
      -25 ≤ dep.deficit - s0.deficit + (eco.deficit - s0.deficit) := by decide +kernel

/-- Un prélèvement réduit le déficit de moins que son rendement statique :
fuite fiscale et activité perdue. -/
theorem prelevement_rendement :
    let s0 := etatDepart H
    let p := depart (mesure (.prelevementSur .tva 10000))
    0 < s0.deficit - p.deficit ∧ s0.deficit - p.deficit < 10000 - 10000 * H.eco.fuiteFiscalePm / 1000 + 1 := by
  decide +kernel

/-- Postes publics : 10 000 postes créés à 50 000 € (500 M€) ajoutent
10 000 emplois publics, l'emploi marchand ne répondant que peu la première
année (bloc de demande : la production marchande ne bouge que par la
dépense des salaires versés) ; la même dépense sans postes (`depenseSur`)
crée beaucoup moins d'emplois ; une création et une suppression du même
nombre de postes se compensent presque, au moteur de demande. -/
theorem postes_publics_un_pour_un :
    let s0 := etatDepart H
    let cr := depart (mesure (.creationPostes .enseignement [10000] 50000))
    let dep := depart (mesure (.depenseSur .enseignement 500))
    let sup := depart (mesure (.suppressionPostes .enseignement 10000 50000))
    let dCr := cr.emploiTotal - s0.emploiTotal
    let dSup := sup.emploiTotal - s0.emploiTotal
    9000 ≤ dCr ∧ dCr ≤ 10200 ∧ dep.emploiTotal - s0.emploiTotal < dCr / 2 ∧
      cr.depensesF.enseignement - s0.depensesF.enseignement = 500 ∧
      -300 ≤ dCr + dSup ∧ dCr + dSup ≤ 300 := by decide +kernel

/-- Échéancier de postes : 2 000 puis 4 000 postes cumulés ; la deuxième
année ajoute 2 000 emplois publics de plus (à l'arrondi près), au coût du
poste indexé comme la fonction. -/
theorem postes_publics_echeancier :
    let p := mesure (.creationPostes .enseignement [2000, 4000] 50000)
    let t := Modele.Programme.trajectoire p D H 2 0 (etatDepart H)
    let a := Modele.trajectoire D H 2 (etatDepart H)
    let e1 := (t.getD 1 (etatDepart H)).emploi.tertiaireNonMarchand - (a.getD 1 (etatDepart H)).emploi.tertiaireNonMarchand
    let e0 := (t.getD 0 (etatDepart H)).emploi.tertiaireNonMarchand - (a.getD 0 (etatDepart H)).emploi.tertiaireNonMarchand
    1900 ≤ e0 ∧ e0 ≤ 2100 ∧ 3800 ≤ e1 ∧ e1 ≤ 4200 := by decide +kernel

def O : Moteur := Hypotheses.Moteurs.offre

/-- Le moteur d'offre sans canal du capital. -/
def O0 : Moteur := { O with canalCapitalPm := 0 }

/-- Canal du capital public : un investissement public durable d'un point
de PIB relève le PIB de 2035, au moteur d'offre, de 1,2 à 1,7 % de plus que
sans le canal (calcul : ≈ 1,5 % avec une élasticité de 0,12, un stock de
59 % du PIB et 5 % de dépréciation ; FMI, WEO 2014 : +1,5 % après quatre
ans, demande comprise) ; le moteur de demande n'a pas ce canal. -/
theorem capital_public_offre :
    let p := mesure (.investissement .affairesEconomiques ((etatDepart H).pib / 100))
    let a := p.resultatA O H 10
    let b := p.resultatA O0 H 10
    let dPm := (a.pib - b.pib) * 10000 / b.pib
    120 ≤ dPm ∧ dPm ≤ 170 ∧ D.canalCapitalPm = 0 := by
  decide +kernel

/-- Canal du capital des entreprises : l'IS ramené de 25 à 20 % fixe un effet
de long terme de +0,5 % de PIB (0,10 % par point) ; dix ans après, 61 % en est
atteint (accumulation à 9 % par an) ; au moteur d'offre, le PIB de 2035
dépasse celui de l'IS inchangé d'au moins cet effet. -/
theorem capital_entreprises_is :
    let p := mesure (.impotSocietes 2000)
    let a := p.resultatA O H 10
    let b := (mesure (.depenseSur .affairesEconomiques 0)).resultatA O H 10
    a.ecartTauxISPb = -500 ∧ 2900 ≤ a.effetCapitalPrivePpm ∧ a.effetCapitalPrivePpm ≤ 3200 ∧
      (a.pib - b.pib) * 1000000 / b.pib ≥ 2900 := by
  decide +kernel

/-- SMIC : un point de hausse augmente les allègements de 1 490 M€ (Institut
Montaigne, 2024) ; l'effet brut du coût du travail (−26 000 emplois, OFCE,
2012), moins les ≈ 21 700 emplois que sauvent ces allègements (élasticité de
la première tranche), rejoint progressivement l'emploi ; les prélèvements
dus au SMIC sont suivis à part ; une cible en euros est atteinte exactement
sur le SMIC de l'année (1 802 € au départ). -/
theorem smic_un_point :
    let s0 := etatDepart H
    let a := depart (mesure (.revalorisationSmic 100))
    let c := depart (mesure (.smicCibleBrut 1820))
    a.allegementsTranche.bas - s0.allegementsTranche.bas = 1490 ∧
      -4500 ≤ a.emploisCoutTravailRestants - s0.emploisCoutTravailRestants ∧
      a.emploisCoutTravailRestants - s0.emploisCoutTravailRestants ≤ -4200 ∧
      a.smicPrelevementsMeur < -1000 ∧ a.smicMensuel = 1820 ∧ c.smicMensuel = 1820 := by
  decide +kernel

/-! ## Émissions selon le scénario, aubaine, loi de programmation militaire (octobre 2026) -/

/-- Tendanciel à `n` ans sous un moteur et un scénario. -/
def tendancielAn (M : Moteur) (S : Scenario) (n : Nat) : Etat :=
  (trajectoire M S n (etatDepart S)).getD n (etatDepart S)

/-- Émissions selon l'activité : la croissance basse (0,6 % de long terme,
−0,4 point en 2029 et en 2030) fait baisser les émissions de l'industrie de
≈ 0,64 % en 2030 par rapport au central (élasticité 0,8) ; la croissance
haute (+0,5 point) les fait monter de ≈ 0,8 %. -/
theorem emissions_activite :
    let c := (tendancielAn D H 5).emissionsKt.industrie
    let b := (tendancielAn D { H with eco := Hypotheses.Eco.croissanceBasse } 5).emissionsKt.industrie
    let h := (tendancielAn D { H with eco := Hypotheses.Eco.croissanceHaute } 5).emissionsKt.industrie
    b < c ∧ c < h ∧ 50 ≤ (c - b) * 10000 / c ∧ (c - b) * 10000 / c ≤ 80 := by
  decide +kernel

/-- Au scénario central, les émissions ne dépendent pas du moteur (l'écart
d'activité porte sur la croissance du scénario, pas sur les effets des
prélèvements que le moteur d'offre ajoute). -/
theorem emissions_independantes_du_moteur :
    (tendancielAn D H 5).emissionsKt = (tendancielAn O H 5).emissionsKt := by
  decide +kernel

/-- Prix du pétrole : au Brent de 100 $ (référence 63 $), l'effet de long
terme sur les émissions des transports vaut ≈ −8 % (élasticité-prix 0,6,
prix TTC au Brent 0,33, voitures et utilitaires 68,6 % des émissions) ; cinq
ans après, 92 % en est atteint (40 % de l'écart comblé chaque année). Les
émissions des bâtiments baissent aussi (fioul). -/
theorem emissions_petrole :
    let c := tendancielAn D H 5
    let h := tendancielAn D { H with energie := Hypotheses.Energie.haut } 5
    let dPb := (c.emissionsKt.transports - h.emissionsKt.transports) * 10000 / c.emissionsKt.transports
    680 ≤ dPb ∧ dPb ≤ 780 ∧ h.emissionsKt.batiments < c.emissionsKt.batiments := by
  decide +kernel

/-- Aubaine : 300 000 primes de 4 000 € par an ajoutent ≈ 163 000 voitures
électriques au parc en cinq ans (19,7 % des achats non électriques, moins
la part des ventes déjà électrique, de 28 à 60 %), contre 1 500 000 pour
une obligation portant sur le même nombre de voitures. -/
theorem aubaine_aide_electrique :
    let t := (tendancielAn D H 5).parcElectriqueMilliers
    let a := ((mesure (.aideAchatElectrique 300000 4000)).resultatA D H 5).parcElectriqueMilliers
    let o := ((mesure (.aideAchatElectrique 300000 0 .obligation)).resultatA D H 5).parcElectriqueMilliers
    150 ≤ a - t ∧ a - t ≤ 180 ∧ o - t = 1500 := by
  decide +kernel

/-- Loi de programmation militaire : au scénario central (échéanciers
compris), la dépense de défense du tendanciel dépasse les crédits de la
mission Défense hors pensions de la loi n° 2026-791 (57,1, 63,3, 69,5, 72,6
et 75,7 Md€ de 2026 à 2030) de l'écart de périmètre de 2025 (53,0 Md€
contre 50,5), indexé : entre 2,45 et 2,75 Md€ de 2026 à 2028. L'écart
monte ensuite à 2,9 et 3,2 Md€ en 2029 et 2030 : la dépense de la fonction
suit aussi les prix du bloc de demande, qui montent au tendanciel (+0,9 %
en 2030, sous l'effet des dépenses prévues par les échéanciers) ; le test
borne l'écart à 3,2 Md€. -/
theorem lpm_tendanciel :
    let C := Hypotheses.central
    let lpm : List Int := [57100, 63300, 69500, 72600, 75700]
    (List.range 5).all (fun i =>
      let d := (tendancielAn D C (i + 1)).depensesF.defense - lpm.getD i 0
      decide (2450 ≤ d ∧ d ≤ (if i < 3 then 2750 else 3200))) = true := by
  decide +kernel

/-- Rétrofit : 100 000 conversions par an pendant cinq ans ajoutent
exactement 500 000 voitures électriques au parc (pas d'aubaine ni de limite
des ventes neuves), et évitent 1,7 t de CO₂ par voiture et par an, soit au
moins 0,8 Mt par an la cinquième année. -/
def retrofit : Programme :=
  { id := "R", nom := "R", description := "", mainteneurs := [], source := "",
    mesures := [{ id := "R-1", titre := "", source := ""
                  leviers := [.retrofitElectrique 100000 5000 400 0]
                  repetitions := 5 }] }

theorem retrofit_parc :
    let t := tendancielAn D H 5
    let r := retrofit.resultatA D H 5
    r.parcElectriqueMilliers - t.parcElectriqueMilliers = 500 ∧
    800 ≤ t.emissionsKt.transports - r.emissionsKt.transports := by
  decide +kernel

/-- Frein automatique au déficit : un seuil jamais atteint (100 % du PIB)
laisse la trajectoire inchangée ; un seuil nul (déficit toujours au-dessus)
durcit la norme chaque année et réduit la dépense de l'année 5 de plus de
1 % (100 pb de norme sur les fonctions pilotables, environ la moitié de la
dépense, pendant cinq ans). -/
theorem frein_deficit :
    let t := tendancielAn D H 5
    let jamais := (mesure (.freinDeficit 10000 100)).resultatA D H 5
    let toujours := (mesure (.freinDeficit 0 100)).resultatA D H 5
    jamais.depensesF.total = t.depensesF.total ∧
    100 * (t.depensesF.total - toujours.depensesF.total) ≥ t.depensesF.total := by
  decide +kernel

/-- Stockage : 1 000 MW pendant 8 heures, 300 cycles par an, rendement de
75 % : 2 400 GWh de charge, 1 800 GWh restitués à la place du thermique
fossile (production thermique de l'année 5 plus basse de 1 800 GWh), la
charge étant prise au nucléaire (+2 400 GWh) ; à 400 g par kWh, 720 kt de
CO₂ évitées dans l'énergie la première année, ≈ 650 kt l'année 5 avec la
baisse tendancielle du secteur. -/
theorem stockage_electrique :
    let t := tendancielAn D H 5
    let r := (mesure (.stockageElectrique 1000 8 300 750 400)).resultatA D H 5
    t.productionGwh.thermique - r.productionGwh.thermique = 1800 ∧
    r.productionGwh.nucleaire - t.productionGwh.nucleaire = 2400 ∧
    600 ≤ t.emissionsKt.energie - r.emissionsKt.energie ∧
    t.emissionsKt.energie - r.emissionsKt.energie ≤ 720 := by
  decide +kernel

/-! ## Transition écologique décrite finement -/

/-- Carburant routier évité (1 Mt de CO₂, ≈ 380 millions de litres) : les
importations de produits pétroliers baissent, les accises baissent de
≈ 0,2 Md€ (≈ 0,55 € par litre), le PIB monte (la dépense de carburant,
importée et taxée, se reporte sur le reste de la consommation) et le
déficit se creuse de moins que les taxes perdues. -/
theorem transition_carburant :
    let s0 := etatDepart H
    let p := depart (mesure (.transitionEcologique
      { secteurGes := .transports, reductionKt := 1000, energie := .carburant }))
    p.importations < s0.importations ∧
      180 ≤ s0.impots.accisesEnergie - p.impots.accisesEnergie ∧
      s0.impots.accisesEnergie - p.impots.accisesEnergie ≤ 240 ∧
      0 < p.pib - s0.pib ∧ 0 < p.deficit - s0.deficit ∧
      p.deficit - s0.deficit < (s0.impots.accisesEnergie - p.impots.accisesEnergie) + (s0.impots.tva - p.impots.tva) ∧
      s0.emissionsKt.transports - p.emissionsKt.transports = 1000 := by
  decide +kernel

/-- Biocarburant à taxes inchangées : ni accise ni TVA perdue (aux recettes
induites près), seule la part non importée du substitut réduit les
importations ; l'effet sur le PIB est bien plus faible qu'une baisse de
consommation de carburant. -/
theorem transition_biocarburant :
    let s0 := etatDepart H
    let sobriete := depart (mesure (.transitionEcologique
      { secteurGes := .transports, reductionKt := 1000, energie := .carburant }))
    let bio := depart (mesure (.transitionEcologique
      { secteurGes := .transports, reductionKt := 1000, energie := .carburant,
        substitutImportePm := 550, taxesMaintenues := true }))
    bio.impots.accisesEnergie - s0.impots.accisesEnergie ≥ -5 ∧
      bio.impots.accisesEnergie - s0.impots.accisesEnergie ≤ 5 ∧
      bio.importations < s0.importations ∧
      0 < bio.pib - s0.pib ∧ 3 * (bio.pib - s0.pib) < sobriete.pib - s0.pib := by
  decide +kernel

/-- Électrification : 2 TWh consommés à la place du gaz rapportent l'accise
sur l'électricité (30,62 €/MWh : 61 M€, aux recettes induites près) et
s'ajoutent à la consommation. -/
theorem transition_electricite :
    let s0 := etatDepart H
    let p := depart (mesure (.transitionEcologique
      { secteurGes := .batiments, reductionKt := 1000, energie := .gaz, electriciteGwh := 2000 }))
    55 ≤ p.impots.accisesEnergie - s0.impots.accisesEnergie ∧
      p.impots.accisesEnergie - s0.impots.accisesEnergie ≤ 65 ∧
      p.consommationGwh - s0.consommationGwh = 2000 := by
  decide +kernel

/-- Activité perdue : 1 Md€ de valeur ajoutée agricole qui disparaît retire
≈ 1 Md€ de PIB (le stabilisateur en rend un peu), supprime des emplois
agricoles et, remplacée aux deux tiers par des importations, relève les
importations (moins le contenu importé de l'activité perdue). -/
theorem transition_activite_perdue :
    let s0 := etatDepart H
    let p := depart (mesure (.transitionEcologique
      { secteurGes := .agriculture, reductionKt := 0, activitePerdueMeur := 1000,
        secteurActivite := .agriculture, activiteImporteePm := 650 }))
    p.pib - s0.pib ≥ -1000 ∧ p.pib - s0.pib ≤ -900 ∧
      p.emploi.agriculture < s0.emploi.agriculture ∧
      300 ≤ p.importations - s0.importations ∧ p.importations - s0.importations ≤ 400 := by
  decide +kernel

/-- Investissement de transition : à dépense égale (1 Md€), l'effet sur le
PIB suit la part intérieure de la technologie : véhicules électriques
(75 % importés) < pompes à chaleur (45 %) < investissement public moyen ;
les importations suivent l'ordre inverse. -/
theorem investissement_transition_part_importee :
    let s0 := etatDepart H
    let ve := depart (mesure (.investissementTransition .vehiculeElectrique [1000]))
    let pac := depart (mesure (.investissementTransition .pompeAChaleur [1000]))
    let moyen := depart (mesure (.investissementEcheancier .logementEnvironnement [1000]))
    ve.pib < pac.pib ∧ pac.pib < moyen.pib ∧
      ve.importations > pac.importations ∧ pac.importations > moyen.importations ∧
      900 ≤ ve.depensesF.total - s0.depensesF.total ∧ 900 ≤ pac.depensesF.total - s0.depensesF.total := by
  decide +kernel

/-- Investissement privé déclenché (1 Md€ de centrales solaires) : PIB et
emploi en hausse, aucune dépense publique (la dépense baisse même, par
l'indemnisation du chômage), déficit en baisse (malgré l'éviction de 40 %
de l'axe central). -/
theorem investissement_prive_transition :
    let s0 := etatDepart H
    let p := depart (mesure (.investissementPriveTransition .solaire [1000]))
    0 < p.pib - s0.pib ∧ 0 < p.emploiTotal - s0.emploiTotal ∧
      p.depensesF.total ≤ s0.depensesF.total ∧ p.deficit < s0.deficit := by
  decide +kernel

/-- Éviction et équipement fossile remplacé : le même milliard de solaire
soutient moins l'activité financé par le privé (40 % évincés à l'axe
central) que payé par l'État ; une pompe à chaleur offerte soutient moins
l'activité quand elle remplace une chaudière qui aurait été achetée (13 %)
que sans cette substitution. -/
theorem eviction_substitution :
    let pub := depart (mesure (.investissementTransition .solaire [1000]))
    let priv := depart (mesure (.investissementPriveTransition .solaire [1000]))
    let H0 : Scenario := { H with energie := { H.energie with substitutionBruneTransitionPm :=
      { H.energie.substitutionBruneTransitionPm with pompeAChaleur := 0 } } }
    let pac := depart (mesure (.investissementTransition .pompeAChaleur [1000]))
    let pac0 := (mesure (.investissementTransition .pompeAChaleur [1000])).etatInitial D H0
    priv.pib < pub.pib ∧ pac.pib < pac0.pib := by
  decide +kernel

/-- Résorption des effets de demande : sous un moteur identique au moteur de
demande mais où il ne reste à long terme que 20 % de l'effet de demande, la
part qui s'en va se résorbant de 5 % par an, une dépense d'un point de PIB
relève encore le PIB au bout de cinq ans, mais moins qu'avec des effets
permanents ; ≈ 0,2 + 0,8 × 0,95⁵ ≈ 82 % de l'écart initial (fourchette
large : l'emploi et les recettes suivent). -/
theorem resorption_demande :
    let R : Moteur := { D with resorptionDemandePm := 50, partDemandeDurablePm := 200 }
    let un := (etatDepart H).pib / 100
    let p := mesure (.depenseSur .enseignement un)
    let ecart (M : Moteur) : Int := (p.resultatA M H 5).pib - (tendancielAn M H 5).pib
    0 < ecart R ∧ ecart R < ecart D ∧ 70 * ecart D ≤ 100 * ecart R ∧ 100 * ecart R ≤ 90 * ecart D := by
  decide +kernel

/-! ## Écart de production, courbe de Phillips, solde structurel -/

/-- Courbe de Phillips : avec un écart de production de départ de −1 point
et une pente de 0,1, l'inflation de la première année (prix à la
consommation, et déflateur donc PIB nominal) est plus basse de 10 pb que la
trajectoire ; à pente nulle, elle la suit. -/
theorem phillips :
    let creux : Scenario := { base with eco := { base.eco with ecartProductionDepartPb := -100 } }
    let plat : Scenario := { creux with eco := { creux.eco with pentePhillipsPm := 0 } }
    (an1 creux).inflationConsoPb + 10 = (an1 plat).inflationConsoPb ∧
      (an1 creux).pib < (an1 plat).pib ∧ (an1 plat).inflationConsoPb = plat.eco.inflationConsoA 0 := by
  decide +kernel

/-- Solde structurel : une dépense d'un point de PIB relève l'écart de
production de son effet de demande ; les recettes qu'elle induit sont
conjoncturelles, si bien que le déficit structurel se creuse de plus que le
déficit effectif (≈ de la dépense entière) ; une mesure d'offre (heures) ne
touche pas l'écart. -/
theorem solde_structurel :
    let s0 := etatDepart H
    let un := s0.pib / 100
    let p := depart (mesure (.depenseSur .enseignement un))
    let h := depart (mesure (.dureeTravail 10))
    p.ecartProductionPb H > s0.ecartProductionPb H ∧
      p.deficitStructurelPb H - s0.deficitStructurelPb H > p.deficitPb - s0.deficitPb ∧
      90 ≤ p.deficitStructurelPb H - s0.deficitStructurelPb H ∧ p.deficitStructurelPb H - s0.deficitStructurelPb H ≤ 105 ∧
      h.ecartProductionPb H = s0.ecartProductionPb H := by
  decide +kernel

/-- Déclarations constitutionnelles : le taux marginal maximal garde le plus
haut des taux déclarés ; une révision déclarée est conservée. -/
theorem declarations_constitution :
    let s0 := etatDepart H
    let p := depart (mesure (.tauxMarginalSommet 662))
    let q := (mesure (.tauxMarginalSommet 300)).etatInitial D H
    let r := depart (mesure (.revisionConstitution "art. 3" "essai"))
    p.tauxMarginalSommetPm = 662 ∧ q.tauxMarginalSommetPm = s0.tauxMarginalSommetPm ∧
      r.revisionsConstitution.length = 1 ∧ s0.revisionsConstitution = [] := by
  decide +kernel

/-- Offre de travail : 100 000 actifs de plus dont 90 % en emploi ajoutent
≈ 90 000 emplois l'année même (PIB par les heures, ≈ +0,2 %) et 100 000
actifs, et laissent l'écart à l'emploi d'équilibre (≈ 7 % de chômage sur
les 10 000 restants) en chômeurs excédentaires à réabsorber ; le taux de
chômage ne bouge pas. -/
theorem offre_travail :
    let s0 := etatDepart H
    let p := depart (mesure (.offreTravail 100000 900))
    100000 ≤ p.actifs - s0.actifs ∧ p.actifs - s0.actifs ≤ 100500 ∧
      90000 ≤ p.emploiTotal - s0.emploiTotal ∧ p.emploiTotal - s0.emploiTotal ≤ 90500 ∧
      5000 ≤ p.pib - s0.pib ∧ p.pib - s0.pib ≤ 7000 ∧
      1500 ≤ p.chomeursExcedentaires - s0.chomeursExcedentaires ∧
      p.chomeursExcedentaires - s0.chomeursExcedentaires ≤ 3000 ∧
      p.chomagePb = s0.chomagePb := by
  decide +kernel

/-- Retard d'entretien : 1 Md€ de travaux retire 1 Md€ du passif
d'infrastructures et crée des emplois dans la construction l'année même ;
le passif ne descend pas sous zéro ; sans mesure, le stock grossit du flux
annuel (0,8 Md€, indexé). -/
theorem entretien_passifs :
    let s0 := etatDepart H
    let p := depart (mesure (.entretienPassifs .entretienInfrastructures .affairesEconomiques 1000))
    let q := depart (mesure (.entretienPassifs .entretienInfrastructures .affairesEconomiques 100000))
    let t := tendancielAn D H 1
    s0.passifs.infrastructures - p.passifs.infrastructures = 1000 ∧
      0 < p.emploi.construction - s0.emploi.construction ∧
      q.passifs.infrastructures = 0 ∧
      800 ≤ t.passifs.infrastructures - s0.passifs.infrastructures ∧
      t.passifs.infrastructures - s0.passifs.infrastructures ≤ 850 := by
  decide +kernel

/-! ## Coût de l'électricité des entreprises et facteur d'implantation -/

/-- Coût d'équilibre de l'électricité des entreprises : au départ, entre
110 et 140 €/MWh (121 calculés : 62 de fourniture au coût complet du mix,
15 de marge, 31 de réseau, 13 de taxes ; prix observé 2024 : 165, 2025 :
149, portés par les contrats de la crise). Un cycle à gaz coûte 100 €/MWh
au Brent de référence (gaz 35 / 0,55 + 0,37 × 75 + 10). Une capacité solaire
massive, qui force la modulation du nucléaire à coût fixe, relève le coût
et, par le facteur d'implantation, retire des emplois industriels par rapport
au tendanciel. -/
theorem cout_electricite_implantations :
    let El := H.energie.electricite
    let p0 := El.prixEntreprisesEurosMWh H.horizon 0 H.energie.prixReferenceDollars
      H.energie.prixReferenceDollars H.reference.etat.productionGwh
    let p := mesure (.capaciteElectrique .solaire 60000)
    let t := Modele.Programme.trajectoire p D H 3 0 (etatDepart H)
    let a := Modele.trajectoire D H 3 (etatDepart H)
    let s3 := t.getD 3 (etatDepart H)
    let a3 := a.getD 3 (etatDepart H)
    110 ≤ p0 ∧ p0 ≤ 140 ∧
      El.coutThermiqueEurosMWh H.horizon 0 H.energie.prixReferenceDollars H.energie.prixReferenceDollars = 100 ∧
      a3.prixElectriciteEntreprisesEurosMWh < s3.prixElectriciteEntreprisesEurosMWh ∧
      s3.emploisImplantationsEnergie < a3.emploisImplantationsEnergie ∧
      s3.emploi.industrie - a3.emploi.industrie < s3.emploisImplantationsEnergie - a3.emploisImplantationsEnergie + 1000 := by
  decide +kernel

/-- Priorité au nucléaire : avec une capacité solaire massive, le surplus
est écrêté sur le solaire, le nucléaire n'est plus modulé, et le coût de
l'électricité est plus bas qu'avec la modulation (le coût fixe du
nucléaire se répartit sur toute sa production) ; la production solaire
retenue est moindre. -/
theorem priorite_nucleaire :
    let p := mesure (.capaciteElectrique .solaire 60000)
    let q := { p with mesures := p.mesures ++ [{ id := "M-2", titre := "", source := "", leviers := [.prioriteNucleaire] }] }
    let s3 := (Modele.Programme.trajectoire p D H 3 0 (etatDepart H)).getD 3 (etatDepart H)
    let t3 := (Modele.Programme.trajectoire q D H 3 0 (etatDepart H)).getD 3 (etatDepart H)
    0 < s3.modulationGwh ∧ s3.ecretementGwh = 0 ∧
      t3.modulationGwh = 0 ∧ t3.ecretementGwh = s3.modulationGwh ∧
      t3.productionGwh.solaire < s3.productionGwh.solaire ∧
      t3.prixElectriciteEntreprisesEurosMWh < s3.prixElectriciteEntreprisesEurosMWh := by
  decide +kernel

/-- Pollution de l'air : `pollutionAir d` ajoute `d` décès attribuables et
retire les années de vie correspondantes (11 par décès) ; l'investissement
de transition en ascenseurs crée des emplois dans la construction et
envoie un quart de la dépense aux importations, plus le contenu importé de
la demande intérieure induite. -/
theorem pollution_air_ascenseurs :
    let s0 := etatDepart H
    let z := depart (mesure (.pollutionAir 150))
    let a := depart (mesure (.investissementTransition .ascenseur [1000]))
    z.decesPollutionAir - s0.decesPollutionAir = 150 ∧
      s0.anneesVieGagneesParAn - z.anneesVieGagneesParAn = 150 * 11 ∧
      0 < a.emploi.construction - s0.emploi.construction ∧
      250 ≤ a.importations - s0.importations ∧ a.importations - s0.importations < 350 := by
  decide +kernel

/-- État de départ avec un excédent de 10 Md€ l'année écoulée. -/
def excedentDix : Etat :=
  { etatDepart H with autresRecettes := (etatDepart H).autresRecettes + (etatDepart H).deficit + 10000 }

/-- Placement de l'excédent : avec un excédent de 10 Md€ l'année précédente,
la moitié est placée en or (plafonné ici à 3 Md€, le reste va aux
participations : 7 Md€) ; la dette de fin d'année est plus haute d'autant,
moins les dividendes des participations, qui réduisent le déficit. -/
theorem placement_excedent :
    let p := anneeSuivante D H { excedentDix with placementExcedentPm := 1000, partOrPlacementPm := 500,
                                                   plafondOrRacheteMeur := 3000 }
    let q := anneeSuivante D H excedentDix
    p.orRacheteMeur = 3000 ∧ p.placementParticipationsAnnee = 7000 ∧
      9000 < p.dette - q.dette ∧ p.dette - q.dette ≤ 10000 ∧ p.deficit < q.deficit := by
  decide +kernel

/-- Liens ajoutés en novembre 2026. Prime de dette : à déficit égal, une
dette de départ plus haute de dix points de PIB relève le taux d'émission
de 20 pb (2 pb par point). Santé → espérance de vie : une norme de 200 pb
qui s'applique à la santé réduit l'espérance de vie après trois ans ; le
plafond de 50 pb en garde l'essentiel. -/
theorem liens_dette_sante :
    let s0 := etatDepart H
    let haut : Etat := { s0 with detteDebut := s0.detteDebut + s0.pib / 10 }
    let p := anneeSuivante D H s0
    let q := anneeSuivante D H haut
    let norme := (Modele.Programme.trajectoire (mesure (.normeDepense 200)) D H 3 0 s0).getD 3 s0
    let plaf := (Modele.Programme.trajectoire
      { (mesure (.normeDepense 200)) with mesures := (mesure (.normeDepense 200)).mesures ++
          [{ id := "M-2", titre := "", source := "", leviers := [.plafondNormeSante 50] }] } D H 3 0 s0).getD 3 s0
    let a := (Modele.trajectoire D H 3 s0).getD 3 s0
    q.tauxMarginalCourantPb - p.tauxMarginalCourantPb = 20 ∧
      Modele.esperanceVieCentiemes H norme < Modele.esperanceVieCentiemes H a ∧
      Modele.esperanceVieCentiemes H norme < Modele.esperanceVieCentiemes H plaf ∧
      Modele.esperanceVieCentiemes H plaf ≤ Modele.esperanceVieCentiemes H a := by
  decide +kernel

end Tests.Mecanismes
