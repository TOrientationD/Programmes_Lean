import Modele

/-!
# Bénéficiaires des intérêts de la dette publique

La charge d'intérêts des administrations publiques (`Etat.chargeInterets`,
périmètre APU : 64,7 Md€ en 2025, Insee Première n° 2106, 29 mai 2026) est
répartie entre ceux qui la reçoivent. La répartition sert à l'affichage
(synthèse) : elle ne modifie aucune trajectoire.

**Banque de France (Eurosystème).** Titres publics français des programmes
d'achats APP et PEPP au bilan de la Banque de France, au coût amorti :
546 Md€ au 31 décembre 2025 et 488 Md€ au 30 juin 2026 (communiqué de la
Banque de France du 12 septembre 2026, « Précisions sur le programme de
détention de la dette publique ») ; ≈ 663 Md€ fin 2024 (546 Md€ plus les
≈ 117 Md€ arrivés à échéance en 2025, « Comprendre les comptes 2025 » de la
Banque de France, chiffre qui peut comprendre des titres non publics). Les
titres arrivés à échéance ne sont plus réinvestis (APP depuis juillet 2023,
PEPP depuis janvier 2025) : le portefeuille français suit le rythme des
médianes de l'enquête de la BCE auprès des analystes monétaires (Survey of
Monetary Analysts, juin 2026 : APP + PEPP de l'Eurosystème, 3 743 Md€ au
deuxième trimestre 2026, 3 089 fin 2027, 2 633 fin 2028, 1 895 fin 2030,
1 314 fin 2032, 867 fin 2034), rapporté au portefeuille de juin 2026
(calcul ; les niveaux de l'enquête dépassent ceux du bilan publié de
l'Eurosystème, seuls les rythmes sont repris) ; années intermédiaires
interpolées, 2035 au rapport de 2033 à 2034 (hypothèses). Rendement :
0,68 %, taux fixe moyen des titres de politique monétaire de la Banque de
France en 2025 (« Comprendre les comptes 2025 »), maintenu (hypothèse :
les titres restants ont été achetés de 2015 à 2022, à taux bas). Intérêts
de l'année : stock moyen de l'année × rendement. Ces intérêts ne restent
pas à la Banque de France : elle rémunère les réserves des banques à 2,26 %
en moyenne en 2025 (marge nette des portefeuilles APP et PEPP : −12,6 Md€),
et l'État ne touche d'elle qu'un impôt sur les sociétés les années
bénéficiaires (1,5 Md€ en 2025, aucun dividende depuis l'exercice 2021).

**Autres détenteurs.** Le reste des intérêts est réparti selon la
structure de détention de la dette publique hors banque centrale, fixe
(hypothèse) : ensemble de la dette des APU, prêts compris, fin 2025 (base
de données du FMI reprise par le Rapport sur la dette des administrations
publiques annexé au PLF 2027, p. 35) : non-résidents 52,7 %, Banque de
France 15,6 %, banques résidentes 16,7 % (dont les prêts aux collectivités
locales), autres résidents 15,0 %. Les autres résidents sont partagés
comme sur la dette négociable de l'État au premier trimestre 2026 (Agence
France Trésor, bulletin mensuel n° 434, juillet 2026) : assurances 9,6 %,
OPC 1,8 %, autres résidents hors Banque de France 5,6 % (20,6 % d'« autres
français » moins ≈ 15 % pour la Banque de France, calcul). Les non-résidents
comprennent les titres détenus en propre par la BCE (≈ 1 à 2 points, non
sourcé). Limites : la répartition se fait au prorata des encours, pas des
coupons (les BTF, à taux court, sont détenus à 84 % par des non-résidents ;
les titres indexés, surtout par des résidents) ; l'essentiel des intérêts
reçus par les assureurs revient aux assurés (fonds en euros de
l'assurance-vie).
-/

namespace Hypotheses.Detention

open Modele

/-- Titres publics français de la Banque de France (APP + PEPP), M€. -/
def bdfFin2025 : Int := 546000
def bdfJuin2026 : Int := 488000
def bdfFin2024 : Int := bdfFin2025 + 117000

/-- Médianes de l'enquête de la BCE (SMA, juin 2026), APP + PEPP de
l'Eurosystème, Md€. -/
def smaJuin2026 : Int := 2348 + 1395
def sma2027 : Int := 1923 + 1166
def sma2028 : Int := 1630 + 1003
def sma2030 : Int := 1195 + 700
def sma2032 : Int := 886 + 428
def sma2034 : Int := 661 + 206

/-- Portefeuille français au rythme de l'Eurosystème. -/
def selonSma (sma : Int) : Int := bdfJuin2026 * sma / smaJuin2026

/-- Portefeuille de la Banque de France en fin d'année, de fin 2024 à fin
2035, M€ : fin 2026 au tiers du chemin de juin 2026 à fin 2027 (6 mois sur
18), années impaires interpolées, 2035 au rapport de 2033 à 2034. -/
def portefeuilleFin : List Int :=
  let s27 := selonSma sma2027
  let s28 := selonSma sma2028
  let s30 := selonSma sma2030
  let s32 := selonSma sma2032
  let s34 := selonSma sma2034
  let s33 := (s32 + s34) / 2
  [bdfFin2024, bdfFin2025, bdfJuin2026 - (bdfJuin2026 - s27) / 3, s27, s28,
   (s28 + s30) / 2, s30, (s30 + s32) / 2, s32, s33, s34, s34 * s34 / s33]

/-- Stock moyen de l'année `2025 + k`, M€ (le dernier niveau est reconduit
au-delà de 2035). -/
def portefeuilleMoyen (k : Nat) : Int :=
  let d := portefeuilleFin.getD k (portefeuilleFin.getLastD 0)
  let f := portefeuilleFin.getD (k + 1) (portefeuilleFin.getLastD 0)
  (d + f) / 2

/-- Rendement du portefeuille de la Banque de France, en points de base
(0,68 %). -/
def rendementBdfPb : Int := 68

/-- Structure de détention de la dette des APU fin 2025 (FMI), en dix
millièmes : non-résidents, Banque de France, banques, autres résidents. -/
def partNonResidents : Int := 5270
def partBdf : Int := 1560
def partBanques : Int := 1670
def partAutresResidents : Int := 1500

/-- Partage des autres résidents (AFT, premier trimestre 2026), en dixièmes
de point : assurances, OPC, autres. -/
def partAssurances : Int := 96
def partOpc : Int := 18
def partAutresHorsBdf : Int := 206 - 150

/-- Bénéficiaires, dans l'ordre d'affichage. -/
structure Beneficiaire where
  id : String
  nom : String
  deriving Repr

def beneficiaires : List Beneficiaire := [
  { id := "nonResidents", nom := "Non-résidents (BCE comprise)" },
  { id := "banqueDeFrance", nom := "Banque de France (Eurosystème)" },
  { id := "banques", nom := "Banques résidentes" },
  { id := "assurances", nom := "Assurances (assurance-vie)" },
  { id := "opc", nom := "Fonds (OPC)" },
  { id := "autres", nom := "Autres résidents" }
]

/-- Répartition d'une charge d'intérêts `total` (M€) dont `bdf` à la
Banque de France : le reste au prorata de la structure hors banque
centrale ; les arrondis vont aux autres résidents. -/
structure Repartition where
  nonResidents : Int
  banqueDeFrance : Int
  banques : Int
  assurances : Int
  opc : Int
  autres : Int
  deriving Repr

def repartir (total bdf : Int) : Repartition :=
  let b := max 0 (min total bdf)
  let reste := total - b
  let marche := partNonResidents + partBanques + partAutresResidents
  let nr := reste * partNonResidents / marche
  let bq := reste * partBanques / marche
  let horsBanques := reste - nr - bq
  let ass := horsBanques * partAssurances / (partAssurances + partOpc + partAutresHorsBdf)
  let opc := horsBanques * partOpc / (partAssurances + partOpc + partAutresHorsBdf)
  { nonResidents := nr, banqueDeFrance := b, banques := bq, assurances := ass, opc := opc,
    autres := horsBanques - ass - opc }

def Repartition.total (r : Repartition) : Int :=
  r.nonResidents + r.banqueDeFrance + r.banques + r.assurances + r.opc + r.autres

/-- La répartition ne crée ni ne perd d'intérêts. -/
theorem repartir_total (total bdf : Int) : (repartir total bdf).total = total := by
  simp only [repartir, Repartition.total]
  omega

/-- Intérêts de l'année `2025 + k` à la Banque de France, M€. -/
def interetsBdf (k : Nat) : Int := portefeuilleMoyen k * rendementBdfPb / 10000

theorem parts_valeurs :
    partNonResidents + partBdf + partBanques + partAutresResidents = 10000 ∧
    partAssurances + partOpc + partAutresHorsBdf = 170 ∧
    portefeuilleFin = [663000, 546000, 459578, 402733, 343281, 295172, 247063, 209188,
      171314, 142175, 113036, 89869] ∧
    (List.range 11).map interetsBdf = [4110, 3418, 2931, 2536, 2170, 1843, 1551, 1293, 1065, 867, 689] := by
  decide

/-- Répartition de la charge d'intérêts de l'état `s`, année `2025 + k`. -/
def repartition (k : Nat) (s : Etat) : Repartition :=
  repartir s.chargeInterets (interetsBdf k)

def Repartition.champs (r : Repartition) : List (String × Int) :=
  [("nonResidents", r.nonResidents), ("banqueDeFrance", r.banqueDeFrance), ("banques", r.banques),
   ("assurances", r.assurances), ("opc", r.opc), ("autres", r.autres)]

end Hypotheses.Detention
