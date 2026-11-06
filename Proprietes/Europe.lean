import Modele

/-!
# Propriétés issues des textes européens

Traductions simplifiées des règles listées dans `Hypotheses/Europe.lean`
(références juridiques et critères). Préfixe `ue-` : la synthèse les
regroupe dans une page « Textes européens ».
-/

namespace Proprietes
open Modele

abbrev UeDeficit3 (_H : Scenario) (_a s : Etat) : Prop := 100 * s.deficit ≤ 3 * s.pib

def ueDeficit : Propriete :=
  .mk' "ue-deficit-3pct" "UE : déficit sous 3 %"
    "TFUE art. 126 : déficit ≤ 3 % du PIB à l'horizon du scénario, indépendamment du cadre juridique national."
    UeDeficit3

/-- Volet correctif : −0,5 point par an pendant cinq ans, ou retour sous 3 %. -/
abbrev UeAjustement (H : Scenario) (_a s : Etat) : Prop :=
  100 * s.deficit ≤ 3 * s.pib ∨ s.deficitPb + 250 ≤ H.reference.etat.deficitPb

def ueAjustement : Propriete :=
  .mk' "ue-ajustement-0-5" "UE : ajustement 0,5 pt/an"
    "Règlements 2024/1263 et 1467/97 : cinq ans après le départ, déficit réduit d'au moins 2,5 points de PIB ou passé sous 3 %."
    UeAjustement (annee := some 5)

/-- Sauvegarde de la dette : −1 point par an au-dessus de 90 %, sur dix ans. -/
abbrev UeDette (H : Scenario) (_a s : Etat) : Prop :=
  s.dettePb + 1000 ≤ H.reference.etat.dettePb

def ueDette : Propriete :=
  .mk' "ue-dette-1pt" "UE : dette −1 pt/an"
    "Règlement 2024/1263 art. 8 : dix ans après le départ, ratio dette/PIB réduit d'au moins 10 points."
    UeDette (annee := some 10)

abbrev UeClimat2030 (_H : Scenario) (_a s : Etat) : Prop := s.emissionsKt.total ≤ 276000

def ueClimat : Propriete :=
  .mk' "ue-climat-2030" "UE : climat 2030"
    "Loi européenne sur le climat, traduite par la SNBC-3 (décret n° 2026-636) : émissions territoriales brutes ≤ 276 Mt CO₂e en 2030."
    UeClimat2030 (annee := some 5)

/-- Émissions couvertes par le règlement sur la répartition de l'effort
(transport intérieur, bâtiments, agriculture, déchets, petite industrie),
kt : les quatre premiers secteurs, plus 23 % de l'industrie et de l'énergie
(part hors marché carbone, calée pour retrouver la part ESR de la SNBC-3 :
278 Mt sur 342 dans le budget 2024-2028, ≈ 81 %). -/
def emissionsEsrKt (s : Etat) : Int :=
  s.emissionsKt.transports + s.emissionsKt.batiments + s.emissionsKt.agriculture
    + s.emissionsKt.dechets + (s.emissionsKt.industrie + s.emissionsKt.energie) * 230 / 1000

/-- Objectif ESR de la France : −47,5 % par rapport à 2005 (≈ 401 Mt,
d'après les allocations annuelles de la décision d'exécution 2023/1319),
soit ≈ 210,5 Mt en 2030. -/
abbrev UeEsr2030 (_H : Scenario) (_a s : Etat) : Prop := emissionsEsrKt s ≤ 210500

def ueEsr : Propriete :=
  .mk' "ue-esr-2030" "UE : répartition de l'effort 2030"
    "Règlement (UE) 2023/857 : émissions hors marché carbone européen réduites de 47,5 % par rapport à 2005 en 2030 (≈ 210 Mt)."
    UeEsr2030 (annee := some 5)

/-- AFIR, art. 3 : puissance publique d'au moins 1,3 kW par voiture électrique
à batterie immatriculée (exigence annuelle, vérifiée en 2030). La puissance
installée est le nombre de points × la puissance moyenne d'un point
(hypothèse du scénario, calée sur 140 % de l'objectif fin mars 2026). -/
abbrev UeAfir2030 (H : Scenario) (_a s : Etat) : Prop :=
  s.parcElectriqueMilliers * H.energie.puissanceAfirParVehiculeW ≤ s.bornesMilliers * H.energie.puissanceParBorneW

def ueAfir : Propriete :=
  .mk' "ue-afir-2030" "UE : recharge (AFIR) 2030"
    "Règlement 2023/1804, art. 3 : en 2030, au moins 1,3 kW de puissance de recharge publique par voiture électrique à batterie."
    UeAfir2030 (annee := some 5)

abbrev UeBalanceCourante (_H : Scenario) (_a s : Etat) : Prop := -400 ≤ s.balanceCourantePb

def ueBalance : Propriete :=
  .mk' "ue-balance-courante" "UE : solde courant > −4 %"
    "Règlement 1176/2011 (déséquilibres macroéconomiques) : solde des transactions courantes ≥ −4 % du PIB à l'horizon."
    UeBalanceCourante

def europeennes : List Propriete := [ueDeficit, ueAjustement, ueDette, ueClimat, ueEsr, ueAfir, ueBalance]

end Proprietes
