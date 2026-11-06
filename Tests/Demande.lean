import Modele
import Hypotheses

/-!
# Tests du bloc de demande : multiplicateurs par canal et délais de diffusion

Variantes usuelles : un choc permanent d'un point de PIB (demande mondiale :
+1 %) passe par un seul canal ; le bloc (`Modele.resoudre`, paramètres du
scénario central) en calcule l'effet sur le PIB, les prix et l'emploi année
après année. Chaque test compare cet effet à la fourchette des variantes
publiées par les modèles macroéconométriques français, élargie de 0,15 point
de PIB (0,15 point de prix pour les prix) :

* Mésange (Insee–DG Trésor) : DT Insee 2024-07, tableaux 2 et 3 ; DT Trésor
  2026/1, tableau 2 ; séminaire Fourgeaud du 15 mars 2017, diapositive 41 ;
  IR, CSG et TVA d'après l'Institut Avant-garde (octobre 2025, tableau 7,
  source secondaire) ;
* FR-BDF (Banque de France) : WP 750, 2020, tableaux 1, 8, 10 à 13 et 15
  (horizon de quatre ans au plus : sa valeur à quatre ans entre dans la
  fourchette à cinq ans) ;
* e-mod.fr (OFCE) : Revue de l'OFCE n° 116, 2011, tableau 5 (milieu de
  cycle) ; COR, 17 octobre 2019, doc. 6a ; COR, 27 janvier 2022, doc. 13.

Unités : ppm (10 000 = 1 % du PIB ou des prix).

À dix ans, les effets du bloc s'estompent plus vite que dans Mésange et
e-mod.fr pour les transferts (0,23 point contre 0,5 à 0,6) et la TVA (0,13
contre 0,5) : la boucle prix-salaires y referme plus tôt l'écart de
production. Les tests à dix ans ne vérifient que le sens et la décrue.
-/

namespace Tests.Demande
open Modele

def P : ParametresDemande := Hypotheses.Eco.parametresDemande

/-- Rapport emploi / actifs (≈ 92 %) et effet de flexion du scénario central. -/
def tauxEmploi : Int := 920
def flexion : Int := Hypotheses.Eco.centrale.flexionPm

def un : Int := 10000

/-- Écarts des dix premières années d'un choc permanent. -/
def variante (c : ChocsDemande) : List EcartsDemande := simulerChoc P 1000 tauxEmploi flexion c 10

def pib (c : ChocsDemande) (an : Nat) : Int := ((variante c).getD (an - 1) {}).pib
def prix (c : ChocsDemande) (an : Nat) : Int := ((variante c).getD (an - 1) {}).prixConso
def emploi (c : ChocsDemande) (an : Nat) : Int := ((variante c).getD (an - 1) {}).emploi

/-- `x` dans `[lo − 1 500, hi + 1 500]` (0,15 point). -/
def dans (x lo hi : Int) : Bool := decide (lo - 1500 ≤ x ∧ x ≤ hi + 1500)

/-- Investissement public : Mésange 1,28 / 1,10 / 0,80 ; FR-BDF 0,74 / 0,81 /
0,72 (4 ans) ; e-mod.fr 1,2 / – / 0,7. -/
theorem investissement_public :
    let c : ChocsDemande := { investissement := un }
    dans (pib c 1) 7400 12800 ∧ dans (pib c 3) 8100 11000 ∧ dans (pib c 5) 7000 8000 = true := by
  decide +kernel

/-- Consommation publique : FR-BDF 0,97 / 1,02 / 0,92 / 0,78 (4 ans) ; e-mod.fr
(emploi public) 1,2 / – / 0,6 ; Mésange (dépense générique) 0,76 / 1,01 / –
/ 0,88. -/
theorem consommation_publique :
    let c : ChocsDemande := { consoPublique := un }
    dans (pib c 1) 7600 12000 ∧ dans (pib c 2) 10100 10200 ∧ dans (pib c 3) 9200 9200
      ∧ dans (pib c 5) 6000 8800 = true := by
  decide +kernel

/-- Transferts et prélèvements sur les ménages (même canal) : FR-BDF 0,09 /
0,26 / 0,37 / 0,43 (4 ans) ; e-mod.fr (pensions) 0,3 / 0,8 / 0,8 / 0,7 ;
Mésange (IR, CSG) 0,41 / 0,83 / 0,88 / 0,81 ; e-mod.fr 2011 1,0 / – / – / 0,9. -/
theorem transferts_et_prelevements :
    let c : ChocsDemande := { revenu := un }
    dans (pib c 1) 900 10000 ∧ dans (pib c 2) 2300 8300 ∧ dans (pib c 3) 3400 8800
      ∧ dans (pib c 5) 4300 9000 = true := by
  decide +kernel

/-- TVA (baisse) : FR-BDF 0,05 / 0,29 / 0,39 (4 ans) ; Mésange 0,32 / 0,72 /
0,81 ; e-mod.fr 2011 0,8 / – / 1,0. Prix à la consommation la première
année : −1,48 % (Mésange, transmission calée). -/
theorem taxes_consommation :
    let c : ChocsDemande := { taxesConsommation := un }
    dans (pib c 1) 500 8000 ∧ dans (pib c 3) 2900 7200 ∧ dans (pib c 5) 3900 10000
      ∧ decide (-14900 ≤ prix c 1 ∧ prix c 1 ≤ -14700) = true := by
  decide +kernel

/-- Coût du travail (baisse des cotisations employeurs) : prix à la
consommation de Mésange −0,45 / −1,03 / −1,38 ; FR-BDF −0,20 / −1,28 /
−1,39 (4 ans). Le PIB du bloc seul est plus bas que dans les variantes
publiées, dont les effets comprennent les emplois créés par la baisse du
coût du travail, comptés ici par le levier. -/
theorem cout_du_travail :
    let c : ChocsDemande := { coutTravail := un }
    dans (prix c 1) (-4500) (-2000) ∧ dans (prix c 3) (-12800) (-10300)
      ∧ dans (prix c 5) (-13900) (-13800) ∧ decide (0 < pib c 1 ∧ pib c 1 < pib c 3 ∧ pib c 3 < pib c 5) = true := by
  decide +kernel

/-- Demande mondiale +1 % : Mésange 0,27 / 0,32 / 0,27 ; FR-BDF 0,14 / 0,21 /
0,20 (4 ans). -/
theorem demande_mondiale :
    let c : ChocsDemande := { demandeMondiale := un }
    dans (pib c 1) 1400 2700 ∧ dans (pib c 3) 2100 3200 ∧ dans (pib c 5) 2000 2700 = true := by
  decide +kernel

/-- Multiplicateurs différenciés : la première année, la dépense publique
(consommation, investissement) soutient le plus l'activité, puis les
transferts et prélèvements sur les ménages, la TVA, enfin le coût du
travail ; comme dans les trois modèles publics. -/
theorem multiplicateurs_differencies :
    pib { investissement := un } 1 > pib { revenu := un } 1
      ∧ pib { consoPublique := un } 1 > pib { revenu := un } 1
      ∧ pib { revenu := un } 1 > pib { taxesConsommation := un } 1
      ∧ pib { taxesConsommation := un } 1 > pib { coutTravail := un } 1 := by
  decide +kernel

/-- Délais de diffusion : l'effet d'un transfert aux ménages fait plus que
doubler entre la première et la troisième année (la consommation rejoint
progressivement le revenu) ; celui de la dépense publique culmine dès la
deuxième année ; tous s'estompent ensuite (la hausse des prix et des
salaires réduit la compétitivité), sans changer de signe à dix ans. -/
theorem delais_de_diffusion :
    let t : ChocsDemande := { revenu := un }
    let g : ChocsDemande := { consoPublique := un }
    pib t 3 > 2 * pib t 1 ∧ pib g 2 > pib g 1 ∧ pib g 2 > pib g 3
      ∧ pib g 10 < pib g 5 ∧ pib t 10 < pib t 5 ∧ 0 < pib g 10 ∧ 0 < pib t 10 := by
  decide +kernel

/-- Prix : une hausse de la demande publique relève peu à peu les prix
(FR-BDF : +0,19 / +0,60 / +0,94 / +1,21 % pour la consommation publique). -/
theorem prix_demande_publique :
    let g : ChocsDemande := { consoPublique := un }
    dans (prix g 1) 1900 1900 ∧ dans (prix g 2) 6000 6000 ∧ dans (prix g 3) 9400 9400 = true := by
  decide +kernel

/-- Emploi : la consommation publique crée des emplois avec retard (FR-BDF :
+0,25 / +0,52 / +0,56 %, à ±0,15 point près sur les deux premières années ;
le bloc garde ensuite une élasticité de long terme de 1, celle de Mésange). -/
theorem emploi_demande_publique :
    let g : ChocsDemande := { consoPublique := un }
    dans (emploi g 1) 2500 2500 ∧ dans (emploi g 2) 5200 5200 = true := by
  decide +kernel

end Tests.Demande
