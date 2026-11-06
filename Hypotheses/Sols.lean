import Modele

/-!
# Hypothèses du sous-modèle des sols

Consommation d'espaces naturels, agricoles et forestiers (ENAF), au sens de
la loi n° 2021-1104 du 22 août 2021 (Climat et résilience, art. 191 et 194)
et de la loi n° 2023-630 du 20 juillet 2023.

* **Données** : millésime 2025 des fichiers fonciers du Cerema (période du
  1er janvier 2011 au 1er janvier 2025, publié en juin 2026), qui remplace
  intégralement les millésimes précédents ; on n'en mélange pas les
  valeurs avec les anciens :
  - 2011-2021 : 226 733 ha (24 438 en zone de montagne + 202 295 hors
    montagne, *Déterminants de la consommation d'ENAF 2011-2025*, p. 39) ;
  - 2021-2025 (quatre années) : 72 658 ha (7 864 + 64 794, même page) ;
  - 2024 : 15 119 ha, dont habitat 9 682 et activité 3 906 (p. 4 et 10),
    valeur provisoire ; 2025, non publiée, est supposée égale à 2024.
* **Enveloppe 2021-2031** : la moitié de la consommation 2011-2021, soit
  113 366 ha ; le forfait national de 12 500 ha des projets d'envergure
  nationale ou européenne (loi de 2023, arrêté du 31 mai 2024) en fait
  partie (les régions réduisent leur consommation d'au moins 54,5 % pour le
  financer). Reste à la fin de 2025 : 25 589 ha, soit 5 117 ha/an de 2026
  à 2030 (calcul). La loi ne chiffre pas la tranche 2031-2041 ; le rythme
  est prolongé, l'objectif d'absence d'artificialisation nette en 2050
  excluant qu'il remonte.
* **Répartition sous ZAN** : celle de 2024 (habitat 640 pm, activité
  258 pm, calculs sur les valeurs ci-dessus) ; infrastructures routières et
  ferroviaires 5 % sur 2021-2025 (p. 9) ; le reste (mixte, environ 2 %, et
  destination inconnue) en « autres ».
* **Sans ZAN** : rythme de la décennie de référence, 22 673 ha/an, réparti
  comme sur 2011-2021 (habitat 65 %, activité 22 %, infrastructures 7 %,
  inconnu 4 % et mixte environ 2 %, p. 9).
* **État du droit au 26 octobre 2026** : régime des lois de 2021 et 2023 ;
  la proposition de loi TRACE (adoptée par le Sénat le 18 mars 2025) n'a
  pas été examinée par l'Assemblée, et les assouplissements de la loi de
  simplification de la vie économique ont été censurés (décision
  n° 2026-903 DC du 21 mai 2026).
-/

namespace Hypotheses.Sols
open Modele

def reference20112021Ha : Int := 24438 + 202295
def consomme20212024Ha : Int := 7864 + 64794
def consommation2024Ha : Int := 15119

/-- Répartition de 2024, pm. -/
def structure2024Pm : ParDestination :=
  let logement := 9682 * 1000 / consommation2024Ha
  let activites := 3906 * 1000 / consommation2024Ha
  let infrastructures := 50
  { logement, activites, infrastructures, autres := 1000 - logement - activites - infrastructures }

/-- Rythme 2011-2021, ha/an, réparti selon les parts de la décennie. -/
def sansZanHa : ParDestination :=
  let r := reference20112021Ha / 10
  { logement := r * 65 / 100, activites := r * 22 / 100, infrastructures := r * 7 / 100
    autres := r * 6 / 100 }

def sources : List String := [
  "Cerema, Déterminants de la consommation d'espaces NAF 2011-2025 (juin 2026), p. 4, 9, 10 et 39",
  "Loi n° 2021-1104 du 22 août 2021 (Climat et résilience), art. 191 et 194 ; loi n° 2023-630 du 20 juillet 2023",
  "Arrêté du 31 mai 2024 relatif à la mutualisation nationale de la consommation d'ENAF (projets d'envergure nationale ou européenne)",
  "Conseil constitutionnel, décision n° 2026-903 DC du 21 mai 2026 ; Sénat, proposition de loi TRACE n° 124 (2024-2025)"
]

def central : Sols where
  id := "zan-lois-2021-2023"
  description := "ZAN des lois de 2021 et 2023 : enveloppe 2021-2031 de la moitié de 2011-2021 (Cerema, millésime 2025)"
  reference20112021Ha := reference20112021Ha
  partEnveloppePm := 500
  consommeDepuis2021Ha := consomme20212024Ha + consommation2024Ha
  anneesRestantes := 5
  structureZanPm := structure2024Pm
  consommationSansZanHa := sansZanHa
  sources := sources

/-- Surfaces consommées depuis le 1er janvier 2021, à la fin de 2025,
réparties comme en 2024. -/
def surfaces2025 : ParDestination := structure2024Pm.echelle central.consommeDepuis2021Ha

/-- Contrôles des calculs annoncés dans le docstring. -/
theorem reference_eq : reference20112021Ha = 226733 := by decide
theorem enveloppe_eq : central.enveloppeHa = 113366 := by decide
theorem rythme_eq : central.rythmeZanHa = 5117 := by decide
theorem structure_eq : structure2024Pm = { logement := 640, activites := 258, infrastructures := 50, autres := 52 } := by decide
theorem sansZan_total : sansZanHa.total = 22672 := by decide

end Hypotheses.Sols
