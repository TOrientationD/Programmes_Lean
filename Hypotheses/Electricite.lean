import Modele

/-!
# Hypothèses du sous-modèle électrique

Situation 2025 et trajectoire à législation constante (programmation
pluriannuelle de l'énergie, PPE3). Toutes les valeurs viennent des sources
listées dans `sources` ; les valeurs marquées « calcul » en sont dérivées
par une opération indiquée.

* **Situation 2025** : RTE, Bilan électrique 2025 (rapport complet, publié
  le 25 février 2026) : production 547,5 TWh, consommation brute 446,1 TWh
  (pertes incluses), solde exportateur 92,3 TWh, pompage 8,1 TWh, écart
  entre flux physiques et commerciaux 1,0 TWh (p. 12) ; capacités de fin
  d'année p. 23. La filière « autre » (0,1 GW, 0,1 TWh) est omise.
* **Facteurs de charge** (production / capacité moyenne de l'année /
  8 760 h) :
  - nucléaire : production de référence du Bilan prévisionnel 2025 de RTE,
    365 TWh/an (fourchette 320 à 380 ; aucun nouveau réacteur avant 2035,
    p. 30), sur 63,0 GW : 661 pm (calcul) ;
  - hydraulique : moyenne 2015-2024 de 61,4 TWh (BE2025 p. 33) sur
    25,7 GW : 273 pm (calcul) ;
  - éolien terrestre : moyenne des facteurs publiés pour 2023, 2024 et 2025
    (26,2 %, 21,8 %, 21,4 % : BE2023 p. 34, BE2024 p. 26, BE2025 p. 35) :
    231 pm (calcul) ;
  - éolien en mer : 38,8 % en 2025, parcs mis en service avant 2025 (d'après
    le BE2025) ;
  - solaire : 32,9 TWh en 2025 sur la capacité moyenne de l'année
    ((24,5 + 30,4) / 2 GW) : 137 pm (calcul ; 13 % publié pour 2024,
    BE2024 p. 34) ;
  - thermique fossile : gaz, charbon et fioul, 18,7 TWh sur 17,25 GW en
    moyenne en 2025 : 124 pm (calcul) ;
  - bioénergies : 10,9 TWh sur 2,3 GW : 541 pm (calcul).
* **Installations tendancielles** : objectifs du décret PPE3 du 12 février
  2026 (JO du 13 février 2026, tableau de synthèse p. 9), atteints
  linéairement depuis les capacités de fin 2025 : solaire 48 GW en 2030
  et 67,5 GW en 2035 (milieu de la fourchette 55 à 80), éolien terrestre
  31 puis 37,5 GW (fourchette 35 à 40), éolien en mer 3,6 puis 15 GW,
  hydraulique (STEP comprises) 26,3 puis 28,7 GW. Nucléaire : aucun ajout
  (premier EPR2 à Penly visé en 2038, EDF, 18 décembre 2025) ; thermique
  et bioénergies : aucun changement (pas de date de fin du charbon trouvée
  dans la PPE3).
* **Consommation** : hors voitures électriques, elle suit la trajectoire
  « décarbonation lente » du Bilan prévisionnel 2025 de RTE (470 TWh en
  2030 avec environ 6 millions de voitures électriques, p. 22-25) : base
  2030 = 470 000 − 6 000 × 1 856 / 1 000 = 458 864 GWh, contre 443 131 en
  2025, soit 0,70 % par an (calcul). La trajectoire « décarbonation
  rapide » (510 TWh en 2030) donnerait 2,24 % par an.
* **Voiture électrique** : 16 kWh/100 km (voiture moyenne, ADEME Car
  Labelling corrigé de 20 % pour l'usage réel, via Nos Gestes Climat) sur
  11 600 km/an (SDES, kilométrage moyen 2024) : 1 856 kWh/an (calcul).
* **Solde exportateur** : plafonné vers 100 TWh après 2027 par les
  interconnexions (RTE, Bilan prévisionnel 2025, p. 14), plus le pompage et
  l'écart physique/commercial de 2025 (9,1 TWh) : 109 100 GWh.
* **Emprises** : solaire au sol 1 à 2 ha/MWc, dont 25 à 40 % couverts de
  panneaux (ADEME, via le rapport du 120e Congrès des notaires, 2024) :
  1,5 ha/MW (milieu) ; part du sol : appels d'offres de la PPE3, 2 GW/an au
  sol sur 3,52 GW/an de trajectoire (calcul : 568 pm) ; éolien terrestre :
  0,38 ha par éolienne (même source) pour 2,9 MW par turbine neuve
  (Connaissance des énergies, moyenne 2023) : 0,13 ha/MW (calcul).
-/

namespace Hypotheses.Electricite
open Modele

/-- Capacités installées fin 2025, MW (RTE, BE2025 p. 23 ; thermique =
gaz 12,4 + fioul 3,0 + charbon 1,8 GW). -/
def capacites2025 : ParFiliere :=
  { nucleaire := 63000, hydraulique := 25700, eolienTerrestre := 23900, eolienMer := 1900,
    solaire := 30400, thermique := 17200, bioenergies := 2300 }

/-- Production 2025, GWh (RTE, BE2025 p. 21-22, 33-34 ; thermique = gaz
16,4 + charbon 0,7 + fioul 1,6 TWh). -/
def production2025 : ParFiliere :=
  { nucleaire := 373000, hydraulique := 62400, eolienTerrestre := 43900, eolienMer := 5700,
    solaire := 32900, thermique := 18700, bioenergies := 10900 }

/-- Consommation brute 2025, pertes incluses, GWh (BE2025 p. 12). -/
def consommation2025 : Int := 446100

/-- Consommation d'une voiture électrique, kWh/an : 16 kWh/100 km ×
11 600 km. -/
def kwhVoitureElectrique : Int := 16 * 116

/-- Consommation 2025 hors voitures électriques (1,6 million en
circulation, voir `Hypotheses/Reference.lean`), GWh. -/
def consommationBase2025 : Int := consommation2025 - 1600 * kwhVoitureElectrique / 1000

/-- Installations annuelles 2026-2030 vers les objectifs 2030 de la PPE3,
MW/an. -/
def ajouts2030 : ParFiliere :=
  { solaire := (48000 - capacites2025.solaire) / 5
    eolienTerrestre := (31000 - capacites2025.eolienTerrestre) / 5
    eolienMer := (3600 - capacites2025.eolienMer) / 5
    hydraulique := (26300 - capacites2025.hydraulique) / 5 }

/-- Installations annuelles 2031-2035 vers les objectifs 2035 de la PPE3
(milieu des fourchettes), MW/an. -/
def ajouts2035 : ParFiliere :=
  { solaire := (67500 - 48000) / 5, eolienTerrestre := (37500 - 31000) / 5
    eolienMer := (15000 - 3600) / 5, hydraulique := (28700 - 26300) / 5 }

def sources : List String := [
  "RTE, Bilan électrique 2025, rapport complet (25 février 2026) : production, consommation brute, solde exportateur, capacités, facteurs de charge",
  "RTE, Bilan électrique 2024 et 2023 : facteurs de charge de l'éolien et du solaire",
  "RTE, Bilan prévisionnel 2025, principaux résultats (16 décembre 2025) : nucléaire de référence 365 TWh/an, trajectoires de consommation, solde exportateur plafonné vers 100 TWh",
  "Décret du 12 février 2026 relatif à la programmation pluriannuelle de l'énergie (JO du 13 février 2026), tableau de synthèse p. 9",
  "EDF, devis prévisionnel du programme EPR2 (18 décembre 2025) : premier réacteur à Penly visé en 2038",
  "Maire-info et TaiyangNews (février 2026) : volumes d'appels d'offres de la PPE3 (solaire au sol 2 × 1 GW, toitures 3 × 300 MW, éolien terrestre 2 × 800 MW par an)",
  "ADEME Car Labelling via Nos Gestes Climat ; SDES, parc automobile au 1er janvier 2025 (11 600 km/an)",
  "Rapport du 120e Congrès des notaires (2024) : emprise du solaire au sol (1 à 2 ha/MWc) et des éoliennes (0,38 ha)",
  "Connaissance des énergies, parc éolien français : 2,9 MW par turbine neuve en 2023"
]

/-- Coûts complets par filière, €/MWh (champ `coutFiliereEurosMWh`) :
éolien terrestre 86,62 et solaire ≈ 80 (au sol 74,13, sur toiture 96,48 ;
derniers appels d'offres instruits, CRE, communiqué du 18 février 2026),
éolien en mer 100 (entre les 44 €/MWh de Dunkerque et les 130 à 150 des
premiers parcs ; hypothèse), hydraulique 30 (parc amorti, concessions ;
hypothèse), bioénergies 120 (tarifs biomasse et biogaz ; hypothèse). Le
nucléaire existant est à coût annuel fixe : 61 €/MWh pour 365 TWh (coût
complet 2026-2028 de 60,3 €2026/MWh, CRE, 30 septembre 2025 ; RTE retient
61 €2024/MWh). Cycle à gaz : gaz à 35 €/MWh pour un Brent à 63 $ (TTF
34,65 €/MWh en 2024, 36,33 en 2025, indexé sur le Brent, hypothèse :
indexation entière, borne haute), rendement 55 %, 0,37 t de CO₂ par MWh,
CO₂ à 75 €/t en 2025 (quotas à 71 € en 2024, 77 en 2025) et 120 €/t à
l'horizon (RTE : 80 à 120 €/t en 2030 ; hypothèse haute), 10 €/MWh de
coûts fixes. Marge de fourniture 15 €/MWh (commercialisation, capacité,
certificats d'économies d'énergie ; hypothèse), réseau 31 €/MWh et taxes
13 €/MWh (prix moyen des entreprises en 2024 : 164,6 €/MWh hors TVA, dont
fourniture 121, réseau 31, taxes 13, SDES, « Prix de l'électricité en France
et dans l'Union européenne en 2024 »). Le coût complet du mix est inférieur
au prix moyen payé en 2024-2025, qui portait encore les contrats de la
crise de 2022 (fourniture 105 €/MWh en 2025) : l'indicateur est un coût
d'équilibre, pas un prix de marché ; RTE attend un coût complet moyen de
≈ 80 €2024/MWh consommé en 2030-2035 (bilan prévisionnel, analyse
économique, juillet 2026). -/
def coutsFilieres : ParFiliere :=
  { nucleaire := 61, hydraulique := 30, eolienTerrestre := 87, eolienMer := 100,
    solaire := 80, thermique := 0, bioenergies := 120 }

/-- Prix de l'électricité et du gaz des entreprises en 2024, €/MWh hors TVA
(champ `prixComparaison`, pour le graphique de la synthèse ; 0 = non
disponible). Électricité : France 165 et UE-27 178 (SDES 2024, toutes
tranches) ; Allemagne 236, Italie 207, Espagne 138, Pologne 210, Pays-Bas
210, Belgique 179, Suède 90 (Eurostat nrg_pc_205, bande 500 à 2 000 MWh,
moyennes 2024 toutes taxes et TVA comprises reprises par Apiar Data,
ramenées hors TVA au taux national : calcul, approximatif) ; Royaume-Uni
265 (très gros consommateurs, second semestre 2024, taxes comprises, DESNZ,
22,32 p/kWh : calcul) ; États-Unis 75 (8,13 c$/kWh, EIA, à 1,08 $/€ :
calcul) ; Corée ≈ 120 (173 won/kWh, KEPCO, décembre 2024 : calcul). Gaz :
France 64,7 et UE-27 59,4 (SDES 2024, non-ménages) ; Allemagne 71,3 et
Belgique 48,1, Suède 106,5 (Eurostat, second semestre 2025) ; États-Unis
≈ 13 (Henry Hub 2,21 $/MMBtu en 2024, ≈ 7 €/MWh, plus livraison ;
incertain). -/
def prixComparaison2024 : List (String × Int × Int) :=
  [("France", 165, 65), ("UE-27", 178, 59), ("Allemagne", 236, 71), ("Italie", 207, 0),
   ("Espagne", 138, 0), ("Pologne", 210, 0), ("Pays-Bas", 210, 0), ("Belgique", 179, 48),
   ("Suède", 90, 106), ("Royaume-Uni", 265, 0), ("États-Unis", 75, 13), ("Corée", 120, 0)]

/-- Facteur d'implantation : élasticité de l'emploi manufacturier au prix
de l'électricité de −0,10 (fourchette −0,05 à −0,20 : Marin et Vona, 2021,
établissements français 1997-2015, −0,08 ; Fontagné, Martin et Orefice,
CEPR 2023, −0,15 ; Dechezleprêtre et al., OCDE 2020, −0,07 ; Bijnens et
al., BCE 2021, −0,1 à −0,2 ; Eurochambres 2025, −0,10 à −0,15 à deux ans),
atteinte au tiers chaque année (horizon de deux à trois ans). Les
concurrents sont supposés à prix réel constant : seule l'évolution
française compte. -/
def elasticiteEmploiIndustrielPrixElec : Int := -100
def ajustementImplantations : Int := 333

def electriciteFrance : Electricite where
  facteurChargePm :=
    { nucleaire := 661, hydraulique := 273, eolienTerrestre := 231, eolienMer := 388,
      solaire := 137, thermique := 124, bioenergies := 541 }
  ajoutsTendanceMw := List.replicate 5 ajouts2030
  ajoutsLongTermeMw := ajouts2035
  croissanceConsommationBasePb := 70
  consommationVoitureKwh := kwhVoitureElectrique
  ecartProductionMaxGwh := 100000 + 8100 + 1000
  partSolaireSolPm := 2000 * 1000 / ajouts2030.solaire
  haParMwSolaireCentiemes := 150
  haParMwEolienCentiemes := 38 * 100 / 290
  coutFiliereEurosMWh := coutsFilieres
  prixComparaison := prixComparaison2024
  elasticiteEmploiIndustrielPrixElecPm := elasticiteEmploiIndustrielPrixElec
  ajustementImplantationsPm := ajustementImplantations
  sources := sources

/-- Contrôles des calculs annoncés dans le docstring. -/
theorem consommationBase2025_eq : consommationBase2025 = 443131 := by decide
theorem ajouts2030_solaire : ajouts2030.solaire = 3520 := by decide
theorem partSolaireSol_eq : electriciteFrance.partSolaireSolPm = 568 := by decide
theorem haEolien_eq : electriciteFrance.haParMwEolienCentiemes = 13 := by decide
theorem production2025_total : production2025.total = 547500 := by decide

end Hypotheses.Electricite
