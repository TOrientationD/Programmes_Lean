import Modele
import Hypotheses

/-!
# Tests du modèle commun : électricité et sols

Garde-fous sur le sous-modèle électrique (capacités, production,
consommation, modulation) et sur celui des sols (enveloppe du ZAN,
abrogation, imputation des surfaces des mesures). Les fourchettes viennent
des sources des hypothèses (RTE, PPE3, Cerema), pas d'un calage.
-/

namespace Tests.ElectriciteSols
open Modele

def D : Moteur := Hypotheses.Moteurs.demande
def H : Scenario := Hypotheses.central
def E : Electricite := H.energie.electricite

/-- Tendanciel, de 2025 (rang 0) à 2035 (rang 10). -/
def tend : List Etat := trajectoire D H 10 (etatDepart H)
def en (k : Nat) : Etat := tend.getD k default

def mesure (ls : List Levier) : Programme :=
  { id := "M", nom := "M", description := "", mainteneurs := [], source := "",
    mesures := [{ id := "M-1", titre := "", source := "", leviers := ls }] }

/-- Première année projetée avec les leviers `ls` appliqués au départ. -/
def an1 (ls : List Levier) : Etat := anneeSuivante D H ((mesure ls).etatInitial D H)

/-! ## Électricité -/

/-- La situation de départ reprend le bilan électrique 2025 de RTE. -/
theorem depart_rte :
    (en 0).productionGwh.total = 547500 ∧ (en 0).consommationGwh = 446100 := by decide +kernel

/-- Aux facteurs de charge de référence, la production de la première
année reste à moins de 3 % de celle de 2025 (les facteurs de charge sont
des moyennes observées, pas une année particulière). -/
theorem production_premiere_annee :
    let p := (en 1).productionGwh.total
    547500 * 97 / 100 ≤ p ∧ p ≤ 547500 * 103 / 100 := by decide +kernel

/-- Les installations tendancielles atteignent les objectifs 2030 de la
PPE3 (solaire 48 GW, éolien terrestre 31 GW, en mer 3,6 GW) et le milieu
des fourchettes 2035. -/
theorem capacites_ppe3 :
    (en 5).capacitesMw.solaire = 48000 ∧ (en 5).capacitesMw.eolienTerrestre = 31000 ∧
    (en 5).capacitesMw.eolienMer = 3600 ∧
    (en 10).capacitesMw.solaire = 67500 ∧ (en 10).capacitesMw.eolienTerrestre = 37500 ∧
    (en 10).capacitesMw.eolienMer = 15000 := by decide +kernel

/-- La consommation tendancielle de 2030 se situe entre les trajectoires
« stagnation » (445 TWh) et « décarbonation rapide » (510 TWh) du bilan
prévisionnel 2025 de RTE. -/
theorem consommation_2030_rte :
    445000 ≤ (en 5).consommationGwh ∧ (en 5).consommationGwh ≤ 510000 := by decide +kernel

/-- Consommation = base + voitures électriques du parc (aucune mesure). -/
theorem consommation_decomposee :
    (en 1).consommationGwh = (en 1).consommationBaseGwh
      + (en 1).parcElectriqueMilliers * E.consommationVoitureKwh / 1000 := by decide +kernel

/-- Chaque année, l'écart entre production et consommation ne dépasse pas
le solde exportateur maximal (la modulation du nucléaire y pourvoit). -/
theorem solde_borne :
    (tend.drop 1).all (fun s => decide (s.productionGwh.total - s.consommationGwh ≤ E.ecartProductionMaxGwh)) = true := by
  decide +kernel

/-- Retirer les volumes aidés du solaire (2,9 GW/an) laisse 620 MW
installés la première année ; un levier plus fort que la tendance n'en
démantèle aucun. -/
theorem levier_capacite :
    let s0 := etatDepart H
    (an1 [.capaciteElectrique .solaire (-2900)]).capacitesMw.solaire - s0.capacitesMw.solaire = 620 ∧
    (an1 [.capaciteElectrique .solaire (-10000)]).capacitesMw.solaire = s0.capacitesMw.solaire := by
  decide +kernel

/-- Solaire sur toitures : 1 000 MW de plus la première année, la même
production qu'au sol, mais sans emprise : l'espace consommé par l'énergie
ne change pas ; le même ajout au sol en consomme. -/
theorem solaire_toiture :
    let base := an1 []
    let toit := an1 [.solaireToiture 1000]
    let sol := an1 [.capaciteElectrique .solaire 1000]
    toit.capacitesMw.solaire = base.capacitesMw.solaire + 1000 ∧
    toit.capacitesMw.solaire = sol.capacitesMw.solaire ∧
    toit.surfacesAnneeHa.energie = base.surfacesAnneeHa.energie ∧
    base.surfacesAnneeHa.energie < sol.surfacesAnneeHa.energie := by
  decide +kernel

/-- `transitionKt` retire des kt d'émissions là où `transition` retire des
Mt : 1 000 kt valent 1 Mt. -/
theorem transition_kt :
    (an1 [.transitionKt .transports 1000 0]).emissionsKt = (an1 [.transition .transports 1 0]).emissionsKt := by
  decide +kernel

/-! ## Sols -/

/-- Sous le ZAN, la consommation d'ENAF de 2021 à 2030 tient dans
l'enveloppe de la première tranche, à 20 ha près (arrondis de
la répartition par destination). -/
theorem zan_enveloppe :
    let c := (en 5).surfacesHa.totalEnaf
    H.sols.enveloppeHa - 20 ≤ c ∧ c ≤ H.sols.enveloppeHa := by decide +kernel

/-- Abrogé, le ZAN laisse la consommation revenir au rythme 2011-2021. -/
theorem zan_abroge :
    (an1 [.regimeZan 1000]).surfacesAnneeHa.totalEnaf = H.sols.consommationSansZanHa.total := by
  decide +kernel

/-- Sous le ZAN, 1 000 ha d'infrastructures d'une mesure s'imputent sur
l'enveloppe : le total de l'année ne change pas (à l'arrondi près), les
infrastructures gagnent 1 000 ha moins leur part de l'éviction. Sans ZAN,
ils s'ajoutent. -/
theorem zan_imputation :
    let base := (an1 []).surfacesAnneeHa
    let avec := (an1 [.artificialisation .infrastructures [1000]]).surfacesAnneeHa
    let sans := (an1 [.regimeZan 1000, .artificialisation .infrastructures [1000]]).surfacesAnneeHa
    avec.totalEnaf - base.totalEnaf ≤ 5 ∧ base.totalEnaf - avec.totalEnaf ≤ 5 ∧
    940 ≤ avec.infrastructures - base.infrastructures ∧ avec.infrastructures - base.infrastructures ≤ 960 ∧
    sans.totalEnaf = H.sols.consommationSansZanHa.total + 1000 := by
  decide +kernel

/-- L'échéancier d'une mesure s'épuise : la deuxième année ne porte plus
les surfaces d'une mesure d'un an. -/
theorem echeancier_surfaces :
    let p := mesure [.regimeZan 1000, .artificialisation .infrastructures [1000]]
    let s2 := anneeSuivante D H (anneeSuivante D H (p.etatInitial D H))
    s2.surfacesAnneeHa.totalEnaf = H.sols.consommationSansZanHa.total := by
  decide +kernel

/-- L'emprise énergétique de la première année est celle des installations
nouvelles de solaire au sol et d'éolien terrestre. -/
theorem emprise_energie :
    let s0 := etatDepart H
    let s1 := en 1
    s1.surfacesAnneeHa.energie =
      (s1.capacitesMw.solaire - s0.capacitesMw.solaire) * E.partSolaireSolPm * E.haParMwSolaireCentiemes / 100000
      + (s1.capacitesMw.eolienTerrestre - s0.capacitesMw.eolienTerrestre) * E.haParMwEolienCentiemes / 100 := by
  decide +kernel

/-- Hors ZAN, 1 000 ha d'activités s'ajoutent à l'enveloppe sans évincer
d'autres usages et sortent du décompte du ZAN. -/
theorem hors_zan :
    let base := an1 []
    let avec := an1 [.artificialisationHorsZan .activites [1000]]
    avec.surfacesAnneeHa.totalEnaf = base.surfacesAnneeHa.totalEnaf + 1000 ∧
    avec.surfacesAnneeHa.logement = base.surfacesAnneeHa.logement ∧
    avec.surfacesHorsZanHa = 1000 ∧
    avec.surfacesHa.totalEnaf - avec.surfacesHorsZanHa = base.surfacesHa.totalEnaf := by
  decide +kernel

/-! ## Pompes à chaleur, emplois -/

def P : PompesAChaleur := H.energie.pac

/-- 10 000 pompes à chaleur par an : l'électricité consommée croît chaque
année de celle des PAC nettes de l'aubaine (chaleur / coefficient de
performance), le fioul et le gaz économisés de la chaleur / rendement. -/
theorem pac_energie :
    let p := mesure [.pompesAChaleur .rural 10000 12000]
    let s1 := anneeSuivante D H (p.etatInitial D H)
    let s2 := anneeSuivante D H s1
    let nets := 10000 * (1000 - P.aubainePm) / 1000
    let elec := nets * P.besoinChaleurKWh * 100 / (P.scopCentiemes * 1000000)
    s1.consommationMesuresGwh = elec ∧ s2.consommationMesuresGwh = 2 * elec ∧
    s1.economiesFioulMWhAnnuelles + s1.economiesGazMWhAnnuelles + 1 ≥ nets * P.besoinChaleurKWh / P.rendementChaudierePm ∧
    0 < elec := by
  decide +kernel

/-- Les PAC coûtent leur prix chaque année, moins ce que rapportent les taxes
sur l'électricité et les coûts de réseau de gaz évités, plus les taxes
perdues sur le fioul et le gaz : le déficit de la deuxième année augmente
de moins que leur coût. -/
theorem pac_cout :
    let p := mesure [.pompesAChaleur .rural 10000 12000]
    let s2 := anneeSuivante D H (anneeSuivante D H (p.etatInitial D H))
    let b2 := en 2
    0 < s2.deficit - b2.deficit ∧ s2.deficit - b2.deficit < 120 * 105 / 100 := by
  decide +kernel

/-- 10 000 emplois aidés dans l'industrie sans effet d'aubaine : la dépense
de l'aide, presque autant d'emplois de plus dans l'industrie, un peu moins
au total (l'indemnisation des chômeurs qui retrouvent un emploi baisse,
avec l'effet de demande d'un transfert). -/
theorem emplois_aides :
    let s0 := etatDepart H
    let s := (mesure [.emploisAides .industrie 10000 8000 0]).etatInitial D H
    9500 ≤ s.emploiTotal - s0.emploiTotal ∧ s.emploiTotal - s0.emploiTotal ≤ 10000 ∧
    9900 ≤ s.emploi.industrie - s0.emploi.industrie ∧ s.emploi.industrie - s0.emploi.industrie ≤ 10000 ∧
    s.depensesF.affairesEconomiques - s0.depensesF.affairesEconomiques = 80 := by
  decide +kernel

/-- Rénovations d'ampleur : 10 000 logements par an à 40 000 € d'aide et
12 570 kWh d'économie chacun : 400 M€ de dépense, et des économies de fioul
et de gaz aux parts nationales du sous-modèle rénovation, qui s'ajoutent
chaque année. -/
theorem renovations_ampleur :
    let R := H.energie.renovation
    let s0 := etatDepart H
    let s := (mesure [.renovationsAmpleur .national 10000 40000 12570]).etatInitial D H
    s.depensesF.logementEnvironnement - s0.depensesF.logementEnvironnement = 400 ∧
    s.economiesFioulMWhAnnuelles = 125700 * R.partFioulNationalPm / 1000 ∧
    s.economiesGazMWhAnnuelles = 125700 * R.partGazNationalPm / 1000 ∧
    0 < s.emploi.construction - s0.emploi.construction := by
  decide +kernel

/-- Implantations : 10 000 emplois industriels qui produisent ; la
production nouvelle est exportée (ou remplace des importations). -/
theorem implantations_exportees :
    let s0 := etatDepart H
    let s := (mesure [.implantations .industrie 10000]).etatInitial D H
    9500 ≤ s.emploi.industrie - s0.emploi.industrie ∧
    0 < s.pib - s0.pib ∧ 0 < s.exportations - s0.exportations := by
  decide +kernel

end Tests.ElectriciteSols
