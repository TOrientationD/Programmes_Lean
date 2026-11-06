import Modele
import Hypotheses.Constitution

/-!
# Propriétés issues de la Constitution et des lois organiques

Traductions simplifiées des textes listés dans
`Hypotheses/Constitution.lean`. Préfixe `constitution-` : la synthèse les
regroupe dans une page « Constitution ».
-/

namespace Proprietes
open Modele Hypotheses.Constitution

abbrev ConstitutionInchangee (_H : Scenario) (_a s : Etat) : Prop := s.revisionsConstitution = []

def constitutionArt89 : Propriete :=
  .mk' "constitution-art-89" "Constitution inchangée"
    "Art. 89 : le programme ne déclare aucune mesure qui exige une révision de la Constitution (levier déclaratif `revisionConstitution` ; une révision demande les deux assemblées puis un référendum ou le Congrès aux trois cinquièmes)."
    ConstitutionInchangee

abbrev NonConfiscatoire (_H : Scenario) (_a s : Etat) : Prop := s.tauxMarginalSommetPm ≤ seuilConfiscatoirePm

def constitutionDdhc13 : Propriete :=
  .mk' "constitution-ddhc-13" "DDHC art. 13 : imposition non confiscatoire"
    "Le taux marginal maximal d'imposition d'un revenu, toutes impositions confondues, reste sous 70 % (Conseil constitutionnel : 75 % censuré en 2012, 64,5 % admis en 2013) ; 55,4 % au départ, relevé par les mesures qui le déclarent."
    NonConfiscatoire

/-- Part des 65 ans et plus l'année `rang`, pb : interpolation linéaire de la
référence à l'hypothèse démographique de l'horizon. -/
def partPlus65 (H : Scenario) (rang : Nat) : Int :=
  if H.horizon = 0 then H.reference.partPlus65Pb
  else H.reference.partPlus65Pb
    + (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * (min rang H.horizon : Int) / H.horizon

/-- Dépense de retraite en volume par personne de 65 ans et plus, en
millièmes d'euro de l'année de départ (prix : `indicePrix`, base 10 000). -/
def retraiteParAine (H : Scenario) (s : Etat) : Int :=
  let aines := s.populationMilliers * partPlus65 H s.rang / 10000
  if aines = 0 ∨ s.indicePrix = 0 then 0
  else s.depensesF.retraites * 10000 * 1000 / (s.indicePrix * aines)

abbrev RetraitesNonDegradees (H : Scenario) (_a s : Etat) : Prop :=
  (1000 - tolerancePm) * retraiteParAine H (etatDepart H) ≤ 1000 * retraiteParAine H s

def constitutionPreambule11 : Propriete :=
  .mk' "constitution-preambule-11" "Préambule 1946, al. 11 : retraites"
    "À l'horizon, la dépense de retraite en volume par personne de 65 ans et plus n'est pas inférieure de plus de 5 % à celle de l'année de départ (sécurité matérielle des personnes âgées ; simplification : la part des 65 ans et plus est interpolée)."
    RetraitesNonDegradees

/-- Dépense d'enseignement en volume par habitant, millièmes d'euro de
l'année de départ. -/
def enseignementParHabitant (s : Etat) : Int :=
  if s.populationMilliers = 0 ∨ s.indicePrix = 0 then 0
  else s.depensesF.enseignement * 10000 * 1000 / (s.indicePrix * s.populationMilliers)

abbrev EnseignementNonDegrade (H : Scenario) (_a s : Etat) : Prop :=
  (1000 - tolerancePm) * enseignementParHabitant (etatDepart H) ≤ 1000 * enseignementParHabitant s

def constitutionPreambule13 : Propriete :=
  .mk' "constitution-preambule-13" "Préambule 1946, al. 13 : enseignement"
    "À l'horizon, la dépense d'enseignement en volume par habitant n'est pas inférieure de plus de 5 % à celle de l'année de départ (devoir d'organiser l'enseignement public ; la population d'âge scolaire baisse, le critère par habitant est prudent)."
    EnseignementNonDegrade

abbrev ObjectifMoyenTerme (H : Scenario) (_a s : Etat) : Prop :=
  s.deficitStructurelPb H ≤ -objectifMoyenTermePb

def constitutionLoOmt : Propriete :=
  .mk' "constitution-lo-omt" "Loi organique 2012 : solde structurel"
    "Dix ans après le départ, le déficit structurel (déficit corrigé de l'écart de production, semi-élasticité de 0,57) est au plus de 0,4 % du PIB : objectif de moyen terme de la loi organique n° 2012-1403 et du TSCG (art. 3)."
    ObjectifMoyenTerme (annee := some 10)

def constitutionnelles : List Propriete :=
  [constitutionArt89, constitutionDdhc13, constitutionPreambule11, constitutionPreambule13, constitutionLoOmt]

end Proprietes
