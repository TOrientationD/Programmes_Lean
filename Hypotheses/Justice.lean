import Modele.Justice

/-!
# Justice judiciaire : coûts, effectifs, flux d'affaires et délais

Données sourcées du modèle de la justice (`Modele.Justice`).

**Coût d'un poste.** Le titre 2 du programme 166 « Justice judiciaire » est
de 3 049 065 712 € consommés en 2025 pour 37 657 ETPT exécutés (rapport
annuel de performances 2025, mission Justice) : 80 969 € par ETPT, CAS
pensions compris (calcul). Le coût moyen par catégorie d'emplois du projet
annuel de performances n'a pas pu être consulté : la moyenne de toutes les
catégories est retenue, majorante pour un greffier, minorante pour un
magistrat.

**Équipe-type.** Au 31 décembre 2024, le programme 166 compte 9 989 ETP de
magistrats, 16 382 de greffiers et 10 937 d'autres agents de catégories B et
C (Références statistiques Justice 2025, fiche 1.1) : 1,640 greffier et
1,094 autre agent par magistrat (calcul). Un renfort « magistrat » vient avec
cette équipe, au coût moyen ci-dessus : le coût de l'équipe est celui de la
même composition que le programme.

**Locaux.** Un poste nouveau demande des locaux : 147 812 € par poste de
travail, coût de la réhabilitation-extension du palais de justice de Meaux
(47,3 M€ HT estimés pour 320 postes, Actu-Juridique, 6 septembre 2022 ;
calcul), investis l'année de la création du poste (hypothèse : aucun poste
nouveau dans les locaux actuels, prudent). Fonctionnement immobilier :
260 M€ de crédits de paiement « immobilier occupant » du programme 166 en
2026 (Assemblée nationale, rapport n° 1996, annexe 29) pour 37 657 ETPT :
6 904 € par ETPT et par an (calcul).

**Conseils de prud'hommes (affaires au fond, 2025).** 113 103 affaires
nouvelles, 90 628 terminées, 162 229 en stock au 31 décembre ; durée moyenne
de traitement 15,4 mois ; 7 107 affaires jugées en départage, 13,6 %, en
31,7 mois en moyenne (Références statistiques Justice 2026, fiches 4.4 et
8.1). Délai théorique d'écoulement du stock : 12 × 162 229 / 90 628 =
21,5 mois (calcul ; 20,5 mois dans le projet annuel de performances 2027,
cible 12 mois). Greffes : 984 agents, dernier recensement national (Cour des
comptes, Les conseils de prud'hommes, juin 2023, données 2019) : 92 affaires
au fond terminées par agent et par an (calcul, 2025 sur effectifs 2019).
Départage : 10 000 affaires occupent 48 juges du tribunal judiciaire à
temps plein (référentiel de la conférence des présidents, Cour des comptes,
même rapport) : 208 affaires par juge et par an (calcul). Une équipe de
renfort = un agent de greffe et 0,060 juge départiteur (13,6 % de
92 affaires à 208 par juge, calcul). Facteur de traitement : +5,4 % (cible
2027 du projet annuel de performances pour le greffe civil des tribunaux
judiciaires, 223 → 235 affaires par agent, appliquée aux prud'hommes,
hypothèse).

**Tribunaux judiciaires, matière civile (2025).** 1 496 513 affaires
nouvelles, 1 413 173 terminées, 1 163 485 en stock ; durée moyenne 8,1 mois
(Références statistiques Justice 2026, fiche 4.1 ; hors ruptures d'union et
procédures spéciales). Délai d'écoulement : 9,9 mois (calcul). Un magistrat
du siège traite 754 affaires civiles par an (projet annuel de performances
2027, indicateur d'efficience, 2025 ; cible 2027 : 810, soit +7,4 %).

**Cours criminelles départementales.** Elles jugent plus de 85 % des viols.
En 2025 : 1 402 arrêts (Chiffres clés de la Justice 2026), 2 887 affaires en
attente au 31 décembre, délai d'écoulement 25 mois (Assemblée nationale,
rapport n° 2904, juin 2026) ; 1 897 au 31 décembre 2024 (rapport n° 1687,
juillet 2025) : 2 392 affaires nouvelles en 2025 (calcul : 1 402 + 2 887 −
1 897). Une formation de jugement compte cinq magistrats ; une affaire
occupe 2,7 jours d'audience (2024, données provisoires, rapport n° 1687).
Une formation de renfort tient 120 jours d'audience par an (hypothèse :
trois jours par semaine, quarante semaines) : 44 arrêts par an (calcul).
-/

namespace Hypotheses.Justice
open Modele.Justice

/-- Coût moyen d'un ETPT du programme 166, CAS compris, euros (calcul, RAP 2025). -/
def coutEtptEuros : Int := 3049065712 / 37657
/-- Locaux d'un poste nouveau, euros (Meaux, calcul). -/
def coutLocauxPosteEuros : Int := 47300000 / 320
/-- Fonctionnement immobilier par ETPT et par an, euros (calcul). -/
def coutImmobilierEtptEuros : Int := 260000000 / 37657

/-- Greffiers et autres agents par magistrat, ‰ (RSJ 2025, calcul). -/
def greffiersParMagistratPm : Int := 16382 * 1000 / 9989
def autresAgentsParMagistratPm : Int := 10937 * 1000 / 9989

/-- Prud'hommes, affaires au fond, 2025. -/
def prudhommes : Contentieux := { nouvellesParAn := 113103, stockDebut := 162229, termineesParAn := 90628 }
/-- Durée moyenne de traitement au fond, 2025, dixièmes de mois. -/
def dureePrudhommesDixiemes : Int := 154
def affairesParAgentGreffeCph : Int := 90628 / 984
def departagesParJuge : Int := 10000 / 48
def tauxDepartagePm : Int := 136
/-- Équipe de renfort des prud'hommes : un agent de greffe et sa part de juge départiteur. -/
def equipePrudhommes : Equipe :=
  { magistratsPm := affairesParAgentGreffeCph * tauxDepartagePm / departagesParJuge
    greffiersPm := 1000, autresAgentsPm := 0, affairesParAn := affairesParAgentGreffeCph }
/-- Facteur de traitement des greffes, cible 2027 du PAP (235 / 223), ‰. -/
def facteurGreffePm : Int := 235 * 1000 / 223

/-- Tribunaux judiciaires, matière civile, 2025. -/
def tribunauxCivil : Contentieux := { nouvellesParAn := 1496513, stockDebut := 1163485, termineesParAn := 1413173 }
def dureeTribunauxCivilDixiemes : Int := 81
/-- Équipe-type : un magistrat du siège civil et son équipe de greffe. -/
def equipeTribunal : Equipe :=
  { magistratsPm := 1000, greffiersPm := greffiersParMagistratPm,
    autresAgentsPm := autresAgentsParMagistratPm, affairesParAn := 754 }
/-- Facteur de traitement des magistrats du siège civil, cible 2027 du PAP (810 / 754), ‰. -/
def facteurSiegeCivilPm : Int := 810 * 1000 / 754

/-- Cours criminelles départementales, 2025 (viols pour l'essentiel). -/
def coursCriminelles : Contentieux :=
  { nouvellesParAn := 1402 + 2887 - 1897, stockDebut := 2887, termineesParAn := 1402 }
def joursAudienceParFormation : Int := 120
def joursParAffaireDixiemes : Int := 27
/-- Formation de jugement de renfort : cinq magistrats et leur équipe de greffe. -/
def formationCriminelle : Equipe :=
  { magistratsPm := 5000, greffiersPm := 5 * greffiersParMagistratPm,
    autresAgentsPm := 5 * autresAgentsParMagistratPm,
    affairesParAn := joursAudienceParFormation * 10 / joursParAffaireDixiemes }

theorem justice_valeurs :
    coutEtptEuros = 80969 ∧ coutLocauxPosteEuros = 147812 ∧ coutImmobilierEtptEuros = 6904 ∧
    greffiersParMagistratPm = 1640 ∧ autresAgentsParMagistratPm = 1094 ∧
    affairesParAgentGreffeCph = 92 ∧ departagesParJuge = 208 ∧ equipePrudhommes.magistratsPm = 60 ∧
    facteurGreffePm = 1053 ∧ facteurSiegeCivilPm = 1074 ∧
    coursCriminelles.nouvellesParAn = 2392 ∧ formationCriminelle.affairesParAn = 44 ∧
    prudhommes.delaiDepart = 214 ∧ tribunauxCivil.delaiDepart = 98 ∧ coursCriminelles.delaiDepart = 247 := by
  decide

end Hypotheses.Justice
