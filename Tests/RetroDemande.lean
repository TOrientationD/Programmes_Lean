import Modele
import Hypotheses

/-!
# Rétro-test élargi : équations du bloc de demande sur les années observées

Chaque équation du bloc de demande (`Modele/Demande.lean`) prédit, un an à
l'avance, la croissance d'une grandeur à partir de ses déterminants
observés, avec les coefficients du scénario central. Ces coefficients
viennent de Mésange (estimé sur 1985-2014), d'e-mod.fr et de FR-BDF, sans
calage sur les années testées : le test est **hors échantillon**. Les
années 2020 et 2021 (Covid) sont écartées des moyennes.

Données (croissances en volume ou en prix, pb) :
* exportations, importations, consommation des ménages, FBCF : Insee,
  « Évolution du PIB et de ses composantes », base 2020, 29 mai 2026
  (2020-2025) ; Insee Première n° 1802, base 2014 (2017-2019) ;
* demande mondiale adressée à la France : DG Trésor, Trésor-Éco
  « Perspectives mondiales » n° 243, 288, 349 et 370 (2017-2024) ; indice
  Insee/CEPII (2025, calcul) ;
* pouvoir d'achat du revenu disponible : Insee, « Revenu disponible brut et
  pouvoir d'achat », 2020-2025 ;
* salaire moyen par tête des branches marchandes : Insee, Notes de
  conjoncture (juin 2019, juin 2022, juillet 2024, mars 2026) ;
* prix des importations : Insee (valeur / volume, calcul) ;
* emploi total en fin d'année : Insee, « Emploi salarié et non salarié par
  activité », 14 octobre 2026 ;
* PIB, déflateur, prix à la consommation, chômage : `Hypotheses/Historique.lean`.

Résultats (erreur absolue moyenne hors Covid) : exportations ≈ 0,9 point
(2017-2019, 2022-2025), importations ≈ 1,8 point, consommation ≈ 1,5 point,
PIB par la demande ≈ 0,8 point (2022-2025), prix à la consommation ≈ 0,6
point (2021-2025), salaires ≈ 1,0 point (2017-2019, 2022-2025).
L'emploi, lui, est **sous-estimé** chaque année de 2020 à 2024 : l'équation
d'emploi suppose une productivité qui progresse à sa tendance (0,67 % par
an, FR-BDF 2026), alors qu'elle a reculé après le Covid (−3,5 % par tête en
2023 par rapport à 2019 : Conseil national de productivité, rapport 2025) ;
le bloc de demande surestime donc les pertes d'emplois d'un ralentissement
et sous-estime les créations d'une reprise riche en emplois.
-/

namespace Tests.RetroDemande
open Modele

def P : ParametresDemande := Hypotheses.Eco.parametresDemande

/-- Années et croissances observées (pb). -/
def annees : List Nat := [2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025]
def demandeMondiale : List Int := [570, 390, 110, -680, 1210, 550, -230, 60, 300]
def exportations : List Int := [440, 440, 190, -1660, 1130, 910, 250, 320, 230]
def importations : List Int := [450, 310, 250, -1220, 830, 900, -20, -60, 280]
/-- 2020-2025 seulement (base 2020). -/
def consommation : List Int := [-650, 520, 320, 80, 80, 40]
def fbcf : List Int := [-580, 970, -40, 130, -90, 50]
def pouvoirAchat : List Int := [20, 340, 40, 100, 270, -40]
def apu : List Int := [-100, 170, 70, 30, 40, 10]
def stocks : List Int := [-30, -50, 50, -40, -40, 50]
def pib2020 : List Int := [-740, 690, 270, 160, 150, 80]
/-- Prix à la consommation 2016-2025, chômage 2016-2025, salaire moyen par
tête 2017-2025, déflateur et prix des importations 2021-2025. -/
def inflation : List Int := [20, 100, 190, 110, 50, 160, 520, 490, 200, 90]
def chomage : List Int := [1010, 940, 910, 850, 810, 790, 730, 740, 740, 770]
def salaires : List Int := [170, 170, 230, -440, 630, 540, 400, 260, 180]
def deflateur2021 : List Int := [120, 300, 510, 200, 110]
def prixImport2021 : List Int := [730, 1750, -170, -100, -120]
/-- Emploi total en fin d'année 2019-2024 (milliers). -/
def emploi : List Int := [28875, 28915, 29913, 30355, 30588, 30743]

/-- Prédiction à un an d'une équation à correction d'erreur sur des indices
cumulés : à l'année t, `b Δz_t + a (Z_{t−1} − Y_{t−1}) + c`, où `Z` et `Y`
cumulent les croissances observées (pb) ; renvoie les erreurs
(prédiction − observation). -/
def erreursEcm (b a c : Int) (z y : List Int) : List Int :=
  let rec boucle : List Int → List Int → Int → Int → List Int
    | dz :: zs, dy :: ys, zc, yc =>
      (b * dz / 1000 + a * (zc - yc) / 1000 + c - dy) :: boucle zs ys (zc + dz) (yc + dy)
    | _, _, _, _ => []
  boucle z y 0 0

/-- Moyenne des valeurs absolues (pb). -/
def mae (l : List Int) : Int :=
  if l.isEmpty then 0 else (l.foldl (fun acc x => acc + (Int.natAbs x : Int)) 0) / l.length

/-- Retire les années 2020 et 2021 d'une série 2017-2025. -/
def horsCovid (l : List Int) : List Int := l.take 3 ++ l.drop 5

/-! ## Exportations : demande mondiale (élasticité 0,80, rappel 0,35) -/

def erreursExport : List Int :=
  erreursEcm P.exportDemandeCourtPm P.exportDemandeRappelPm 0 demandeMondiale exportations

theorem exportations_hors_echantillon : mae (horsCovid erreursExport) ≤ 100 := by decide +kernel

/-! ## Importations : demande pondérée par les contenus en importations

Croissance de la demande importée = moyenne des croissances de la
consommation, de la FBCF et des exportations pondérées par leurs contenus en
importations et leurs montants de 2025 (Insee Première n° 2105) ; 2020-2025. -/

def poidsC : Int := P.contenuImportConsoPm * 1545900
def poidsI : Int := P.contenuImportInvestPm * 663600
def poidsX : Int := P.contenuImportExportPm * 1009400

def demandeImportee : List Int :=
  ((consommation.zip fbcf).zip (exportations.drop 3)).map fun ((c, i), x) =>
    (poidsC * c + poidsI * i + poidsX * x) / (poidsC + poidsI + poidsX)

def erreursImport : List Int :=
  erreursEcm P.importDemandeCourtPm P.importDemandeRappelPm 0 demandeImportee (importations.drop 3)

theorem importations_hors_echantillon : mae (erreursImport.drop 2) ≤ 190 := by decide +kernel

/-! ## Consommation : pouvoir d'achat (0,46 la première année, rappel 0,72) -/

def erreursConso : List Int :=
  erreursEcm P.consoCourtPm P.consoRappelPm 0 pouvoirAchat consommation

/-- Hors Covid, la consommation est surestimée de 0,5 à 2,4 points : le taux
d'épargne est resté au-dessus de son niveau d'avant-Covid (17,9 % en 2025
contre 15 % en 2019), ce que l'équation, qui le ramène à son niveau, ne
prévoit pas. -/
theorem consommation_hors_echantillon :
    mae (erreursConso.drop 2) ≤ 160 ∧ (erreursConso.drop 2).all (· > 0) = true := by decide +kernel

/-! ## PIB par la demande, 2022-2025

Croissance du PIB = contributions de la consommation et des échanges
prédites par leurs équations, de l'investissement, de la consommation
publique et des stocks observées (parts de 2025). -/

def erreursPib : List Int :=
  let sC := P.partConsoPm
  let sX := P.partExportPm
  let sM := P.partImportPm
  let sI : Int := 663600 * 1000 / 2992000
  let lignes := ((((((consommation.zip erreursConso).zip (exportations.drop 3)).zip
    ((erreursExport.drop 3))).zip (importations.drop 3)).zip erreursImport).zip
    ((((fbcf.zip apu).zip stocks).zip pib2020)))
  lignes.map fun ((((((c, ec), x), ex), m), em), (((i, g), st), y)) =>
    sC * (c + ec) / 1000 + sI * i / 1000 + g + sX * (x + ex) / 1000 - sM * (m + em) / 1000 + st - y

theorem pib_par_la_demande : mae (erreursPib.drop 2) ≤ 90 := by decide +kernel

/-! ## Prix à la consommation : prix intérieurs (81,3 %) et importés (18,7 %) -/

def erreursPrix : List Int :=
  ((deflateur2021.zip prixImport2021).zip (inflation.drop 5)).map fun ((d, m), p) =>
    ((1000 - P.partImporteePrixConsoPm) * d + P.partImporteePrixConsoPm * m) / 1000 - p

theorem prix_consommation_hors_echantillon : mae erreursPrix ≤ 70 := by decide +kernel

/-! ## Salaires : indexation (0,59 et 0,31 retardé, rappel 0,43), chômage
(−0,61 par point), efficacité du travail 0,67 % par an (FR-BDF 2026) -/

def erreursSalaires : List Int :=
  let rec boucle : List Int → List Int → List Int → Int → Int → List Int
    | π₀ :: π₁ :: πs, u₀ :: u₁ :: us, w :: ws, pc, wc =>
      let pred := (P.salairesPrixCourtPm * π₁ + P.salairesPrixRetardPm * π₀
        + P.salairesPrixRappelPm * (pc - wc) - P.salairesChomageCourtPm * (u₁ - u₀)) / 1000 + 67
      (pred - w) :: boucle (π₁ :: πs) (u₁ :: us) ws (pc + π₁) (wc + w - 67)
    | _, _, _, _, _ => []
  boucle inflation chomage salaires 0 0

/-- Hors Covid, l'erreur moyenne est d'un point ; les salaires sont
surestimés de 2023 à 2025 (rattrapage de l'inflation plus lent que dans
Mésange). -/
theorem salaires_hors_echantillon : mae (horsCovid erreursSalaires) ≤ 110 := by decide +kernel

/-! ## Emploi : production marchande (0,26 la première année, rappel 0,365),
productivité tendancielle 0,67 % par an -/

def croissanceEmploi : List Int :=
  ((emploi.drop 1).zip emploi).map fun (a, b) => (a - b) * 10000 / b

def erreursEmploi : List Int :=
  erreursEcm P.emploiCourtPm P.emploiRappelPm 0 ((pib2020.take 5).map (· - 67)) croissanceEmploi

/-- L'emploi est sous-estimé chaque année de 2020 à 2024, de 2 à 5 points
(énigme de la productivité d'après-Covid : voir le module). -/
theorem emploi_sous_estime_apres_covid :
    erreursEmploi.all (fun e => decide (-500 ≤ e ∧ e ≤ -200)) = true := by decide +kernel

end Tests.RetroDemande
