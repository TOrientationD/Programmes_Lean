import Modele

/-!
# Axe juridique

Les contraintes de droit sont traitées comme des hypothèses : un programme
peut être cohérent dans un cadre et pas dans un autre (renégociation d'une
règle, activation d'une clause dérogatoire, nouvelle loi climat…).
-/

namespace Hypotheses.Droit
open Modele

/-- Cadre actuel. Déficit : valeur de référence de 3 % du PIB (TFUE,
art. 126, et protocole n° 12, art. 1), que la France doit retrouver d'ici
2029 (recommandation du Conseil dans la procédure de déficit excessif
ouverte par la décision (UE) 2024/2122 ; ajustement structurel de 0,5 point
par an comme repère, règlement 1467/97 modifié par le règlement (UE)
2024/1264). Émissions : 300 Mt CO₂e, budget carbone annuel moyen de
2029-2033 de la deuxième stratégie nationale bas-carbone (décret
n° 2020-457, art. 2, hors UTCATF ; 310 Mt pour la seule année 2030). La
SNBC-3 (décret n° 2026-636) l'a remplacé par 262 Mt (276 Mt indicatifs en
2030) : ces deux valeurs sont vérifiées par les propriétés « SNBC-3 :
budget carbone 2029-2033 » et « UE : climat 2030 » ; le plafond de 300 Mt
reste un repère intermédiaire. -/
def cadreActuel : CadreJuridique where
  id := "droit-actuel"
  description := "Règles budgétaires en vigueur (3 % du PIB) ; ancien budget carbone 2029-2033 de la SNBC-2 (300 Mt)"
  plafondDeficitPb := 300
  plafondEmissionsMt := 300
  sources := ["TFUE, art. 126, et protocole n° 12 (3 % du PIB)",
    "Décision (UE) 2024/2122 et recommandation du Conseil de janvier 2025 : correction du déficit excessif d'ici 2029",
    "Décret n° 2020-457 (SNBC-2), art. 2 : budget carbone 2029-2033 de 300 Mt CO₂e par an hors UTCATF ; remplacé par le décret n° 2026-636 (SNBC-3 : 262 Mt)"]

/-- Clause dérogatoire activée : ni la clause générale ni les clauses
nationales du règlement (UE) 2024/1263 (art. 25 et 26) ne fixent de plafond
chiffré. 5 % du PIB (hypothèse) : déficit de la zone euro en 2021, sous la
clause générale de 2020-2023 (5,1 %, Eurostat, avril 2022) ; la clause
nationale pour la défense de 2025, à laquelle la France n'a pas demandé à
recourir, autorise jusqu'à 1,5 point de PIB d'écart (communication
C(2025) 2000), soit 4,5 % (calcul). -/
def clauseDerogatoire : CadreJuridique where
  id := "droit-derogation"
  description := "Clause dérogatoire budgétaire activée (déficit jusqu'à 5 % du PIB), objectifs climatiques inchangés"
  plafondDeficitPb := 500
  plafondEmissionsMt := 300
  sources := ["Règlement (UE) 2024/1263, art. 25 et 26 : clauses dérogatoires, sans plafond chiffré",
    "Eurostat, notification d'avril 2022 : déficit de la zone euro de 5,1 % du PIB en 2021, sous la clause générale",
    "Communication C(2025) 2000 : clause nationale pour la défense, jusqu'à 1,5 point de PIB"]

def toutes : List CadreJuridique := [cadreActuel, clauseDerogatoire]

end Hypotheses.Droit
