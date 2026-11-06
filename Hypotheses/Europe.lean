import Modele

/-!
# Textes européens de référence

Règles de l'Union que les propriétés `ue-*` (`Proprietes/Europe.lean`)
traduisent en critères vérifiables sur les trajectoires. Chaque texte est
cité avec sa référence juridique ; la traduction en critère est une
simplification assumée, écrite dans la propriété.
-/

namespace Hypotheses.Europe

structure TexteEuropeen where
  id : String
  titre : String
  reference : String
  critere : String
  deriving Repr

def textes : List TexteEuropeen := [
  { id := "ue-deficit-3pct"
    titre := "Déficit public sous 3 % du PIB"
    reference := "TFUE art. 126 et protocole n°12 sur la procédure concernant les déficits excessifs"
    critere := "Déficit des administrations publiques ≤ 3 % du PIB à l'horizon du scénario, quel que soit le cadre juridique national" },
  { id := "ue-ajustement-0-5"
    titre := "Ajustement d'au moins 0,5 point de PIB par an sous procédure de déficit excessif"
    reference := "Règlement (UE) 2024/1263 (volet préventif) et règlement (CE) 1467/97 modifié par 2024/1264 (volet correctif), avril 2024"
    critere := "Cinq ans après le départ, le déficit a baissé d'au moins 2,5 points de PIB, ou est passé sous 3 %" },
  { id := "ue-dette-1pt"
    titre := "Réduction de la dette d'au moins 1 point de PIB par an au-dessus de 90 %"
    reference := "Règlement (UE) 2024/1263, art. 8 (sauvegarde de soutenabilité de la dette)"
    critere := "Dix ans après le départ, le ratio dette/PIB a baissé d'au moins 10 points" },
  { id := "ue-climat-2030"
    titre := "Objectif climat 2030 (« Ajustement à l'objectif 55 »)"
    reference := "Règlement (UE) 2021/1119 (loi européenne sur le climat), modifié par le règlement (UE) 2026/667 (−90 % net en 2040) ; traduction nationale : SNBC-3, décret n° 2026-636 du 16 juillet 2026"
    critere := "Émissions territoriales brutes ≤ 276 Mt CO₂e en 2030 (objectif de la SNBC-3)" },
  { id := "ue-esr-2030"
    titre := "Répartition de l'effort (secteurs hors marché carbone)"
    reference := "Règlement (UE) 2023/857 : −47,5 % pour la France par rapport à 2005 ; allocations annuelles : décision d'exécution (UE) 2023/1319"
    critere := "Émissions des transports, des bâtiments, de l'agriculture, des déchets et de la part hors marché carbone de l'industrie et de l'énergie (23 %) ≤ 210,5 Mt CO₂e en 2030" },
  { id := "ue-afir-2030"
    titre := "Infrastructure de recharge (AFIR)"
    reference := "Règlement (UE) 2023/1804 sur le déploiement d'une infrastructure pour carburants alternatifs"
    critere := "En 2030, au moins 1,3 kW de puissance de recharge publique par voiture électrique à batterie (art. 3 ; puissance moyenne d'un point : hypothèse du scénario)" },
  { id := "ue-balance-courante"
    titre := "Procédure concernant les déséquilibres macroéconomiques : solde courant"
    reference := "Règlement (UE) 1176/2011, tableau de bord : solde courant moyen entre −4 % et +6 % du PIB"
    critere := "Solde des transactions courantes ≥ −4 % du PIB à l'horizon" }
]

end Hypotheses.Europe
