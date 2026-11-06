import Modele
import Hypotheses.Electricite
import Hypotheses.Sols

/-!
# Situation de départ

Comptes publics et données démographiques observés pour 2025, point de
départ des projections (année 0). Chaque valeur cite sa source ; les
valeurs marquées « dérivé » sont calculées à partir des évolutions publiées
par l'INSEE (niveau 2025 = hausse publiée × (1 + 1 / taux de hausse)).


## Lois en vigueur

La projection à législation constante applique les textes votés dont les
effets ne sont pas proportionnels au PIB :

* **Âge légal** (loi n° 2023-270, suspendue par l'article 45 de la LFSS
  pour 2026, loi n° 2025-1403) : 62 ans et 9 mois en 2025, gelé jusqu'en
  janvier 2028, puis +3 mois par génération ; 64 ans atteints par la
  génération 1969, en 2033. Calendrier par année : `calendrierAgeLegal`.
  La tendance des dépenses de retraite et de la population active est
  supposée intégrer la réforme de 2023 sans suspension, soit 64 ans dès
  2032 : `calendrierAgeTendanciel` (la tendance des retraites de l'axe
  économique est celle du COR de juin 2026, nette de la suspension). La
  suspension coûte donc 3 mois de départs (≈ 1,9 Md€) de 2027 à 2032,
  conformément au chiffrage du Gouvernement (1,9 Md€ en 2027 ; ≈ 1,8 Md€
  par an selon le COR).
* **Loi de programmation militaire actualisée** (loi n° 2026-791 du
  16 août 2026, art. 3, réécrivant l'art. 4 de la loi n° 2023-703) : crédits
  de la mission Défense hors pensions de 57,1, 63,3, 69,5, 72,6 et 75,7 Md€
  de 2026 à 2030 (435,7 Md€ sur 2024-2030), contre 50,5 Md€ en 2025 ; le
  projet de loi prévoyait 68,3, 72,8 et 76,3 Md€ de 2028 à 2030, profil
  modifié en commission mixte paritaire (copie du JO du 18 août 2026). Échéancier de dépense :
  écart à la reconduction tendancielle (la défense suit les prix, déflateur
  de l'axe économique central), en euros 2025 (voir `echeancesDepart`) ;
  le niveau de 2030 est ensuite reconduit.
* **ETS2** (directive 2003/87/CE modifiée par la directive 2023/959 ; début
  reporté à 2028 par la loi européenne sur le climat 2040, JO de l'UE du
  18 mars 2026) : quotas sur les carburants routiers et le chauffage. Recette
  de ≈ 6,5 Md€ en 2028 (≈ 160 Mt à ≈ 50 €/t, moins la part du Fonds social
  pour le climat), soit 5 950 M€ en euros 2025 ; la directive affecte le
  produit au climat et au social : la moitié est supposée redistribuée en
  dépense nouvelle (rénovation, chèques), l'autre moitié finançant des
  dépenses existantes. Effet sur les émissions : déjà dans la tendance.
* **Contribution exceptionnelle sur les bénéfices des grandes entreprises**
  (loi n° 2025-127 ; reconduite une année par la loi de finances
  pour 2026, loi n° 2026-103) : ≈ 8 Md€ en 2025, 7,5 Md€ en 2026 (acompte du
  15 décembre 2026), puis rien à législation constante. Le PLF 2027 (article
  15) propose une troisième année à taux réduits (5 Md€) : non retenu tant
  qu'il n'est pas voté.
* **CVAE** (loi n° 2025-127, art. 62, trajectoire confirmée par la loi de
  finances pour 2026) : taux maximal de 0,28 % en 2026 et 2027, 0,19 % en
  2028, 0,09 % en 2029, suppression en 2030. Rendement à 0,28 % ≈ 3,4 Md€
  (le passage à 0,19 % coûtait ≈ 1,1 Md€ : Sénat, amendement I-31 au PLF
  2026).
* **Contribution différentielle sur les hauts revenus** (loi n° 2025-127) :
  20 % d'imposition minimale au-delà de 250 000 € de revenu, due
  jusqu'à ce que le déficit public passe sous 3 % du PIB ; ≈ 0,4 Md€
  encaissés en 2025 (prévision initiale 1,9 Md€ ; Les Échos, La Tribune,
  début 2026). Suivie dans l'état (`cdhrMeur`) : la projection l'éteint
  l'année qui suit un déficit inférieur à 3 %.
* **Droits de succession et de donation** (CGI, art. 777 à 800) : 20,7 Md€
  en 2025 (successions 16,2, donations 4,5). Barème en ligne directe de 5 %
  à 45 % après un abattement de 100 000 € par enfant, renouvelable tous les
  15 ans (loi n° 2012-958 du 16 août 2012) ; abattements et tranches non
  indexés : la projection fait croître les droits avec le flux successoral
  (décès de l'axe démographique, patrimoine par décès) et une élasticité
  supérieure à 1 (axe économique). Lois associées, dont l'effet est dans le
  niveau de 2025 :
  - exonération du conjoint survivant et du partenaire de PACS (loi
    n° 2007-1223 du 21 août 2007, dite TEPA) ;
  - Pacte Dutreil (art. 787 B) : 75 % de la valeur des titres exonérés,
    ≈ 5,5 Md€ de moindres recettes en 2024 (Cour des comptes) ; la loi de
    finances pour 2026 en exclut les actifs non professionnels (logements,
    véhicules, objets d'art…) et porte l'engagement individuel de 4 à
    6 ans, pour les transmissions depuis le 21 février 2026 (rendement non
    publié, non chiffré) ;
  - assurance-vie (art. 990 I et 757 B) : 152 500 € d'abattement par
    bénéficiaire pour les primes versées avant 70 ans, puis 20 % et
    31,25 % ; hors barème des successions ;
  - dons familiaux de sommes d'argent (art. 790 G) : 31 865 € tous les
    15 ans ; exonération temporaire de 100 000 € pour l'achat d'un logement
    neuf ou une rénovation énergétique (art. 790 A bis), du 15 février 2025
    au 31 décembre 2026 : sa fin relèvera un peu les droits sur les
    donations à partir de 2027 (coût non publié, non chiffré).
  Non retenus tant qu'ils ne sont pas votés : le PLF 2027 (taux de 6 % sur
  les dons d'argent jusqu'à 100 000 €, don exonéré porté à 100 000 € en
  2027, 790 A bis prolongé jusqu'en 2030, votés en première lecture le
  16 octobre 2026) et les propositions de la Cour des comptes (note du
  21 septembre 2026 : barème −5 points, −2,1 Md€ ; Dutreil à 50 %,
  +1,3 Md€ ; assurance-vie au barème dès la tranche à 20 %, +1,25 Md€,
  proposition du Conseil des prélèvements obligatoires, rapport du
  1er décembre 2025, recommandation n° 6 ; Texte Orientation D, O-70).
* **Loi de programmation pour la refondation de Mayotte** (n° 2025-797 du
  11 août 2025) : 730 M€ d'autorisations d'engagement pour l'eau
  (350 M€ en 2025-2027, 380 M€ en 2028-2031), ≈ 0,1 Md€ par an, jugés
  inclus dans la tendance.
* **Fin des ventes de voitures thermiques neuves en 2035** (règlement (UE)
  2023/851) : voir l'axe énergie ; érosion des accises et de la TVA sur les
  carburants calculée dans la projection.
* **AFIR** (règlement (UE) 2023/1804) : propriété `ue-afir-2030`.
* **Allègements généraux de cotisations patronales** (LFSS pour 2025, loi
  n° 2025-199, art. 18 ; décret n° 2025-887 du 4 septembre 2025) : depuis le
  1er janvier 2026, une réduction générale dégressive unique (RGDU) remplace
  la réduction générale et les bandeaux maladie et famille ; coefficient
  0,02 + 0,3813 × [½ × (3 SMIC / salaire − 1)]^1,75 (entreprises de 50
  salariés et plus), 40,13 % au SMIC, 5,37 % à 2 SMIC, nul à 3 SMIC.
  Montant : 62,2 Md€ en 2025 pour les régimes de base (annexe 4 du PLFSS
  2026), ≈ 75 Md€ avec les parts des retraites complémentaires et de
  l'assurance chômage (75,4 Md€ en 2024, Groupe d'experts sur le SMIC,
  rapport du 25 novembre 2025). Répartition par tranche : non publiée ;
  calculée avec le barème de 2026 et la distribution des salaires (Bozio et
  Wasmer, 2024) : 86,6 % de 1 à 1,6 SMIC, 11,8 % de 1,6 à 2,5 SMIC, 1,6 %
  au-delà (`allegementsTranche`, calcul). Le gel du SMIC de référence pour
  2026 (décret n° 2026-509 du 12 juin 2026 : 2,2 Md€, Sénat, avis n° 747)
  ne vaut que pour 2026 : recette de la seule année 2026.
* **Assurance chômage, règles contracycliques** (décret n° 2023-33,
  art. 9 et 9 bis) : durée d'indemnisation de 0,75 fois la période de
  référence tant que le taux de chômage (BIT, France hors Mayotte) reste
  sous 9 % ; à 9 % ou au-delà (ou après une hausse de 0,8 point en un
  trimestre, non modélisée), un complément de fin de droits porte la durée à
  100 %. Économie de la règle : ≈ 4,5 Md€ par an en régime de croisière
  (Unédic, décembre 2025) ; surcoût du complément non chiffré, au plus du
  même ordre : 4,3 Md€ (euros 2025) dès l'année qui suit un chômage d'au
  moins 9 % (prudent : le complément ne touche que les fins de droits).
  Depuis juillet 2026, l'INSEE publie un taux y compris Mayotte (+0,06
  point) ; la loi « plein emploi » a ajouté ≈ 0,4 point au chômage mesuré
  depuis fin 2024 (inscriptions des bénéficiaires du RSA, effet
  comptable selon l'INSEE).
* **Ruptures conventionnelles** : durée d'indemnisation ramenée à 15 mois
  avant 55 ans et à 20,5 mois après (loi n° 2026-470 du 11 juin 2026, fins
  de contrat depuis le 1er septembre 2026) : économies de 0,02, 0,27, 0,76
  puis 0,94 Md€ par an (Sénat, rapport n° 488) ; contribution patronale
  sur les indemnités de rupture conventionnelle et de mise à la retraite
  portée de 30 % à 40 % (LFSS pour 2026) : ≈ 260 M€ par an.
* **Contribution au budget de l'Union** (prélèvement sur recettes) : 23,0 Md€
  en 2025, 27,9 Md€ en 2026 (loi de finances pour 2026, révisée ; Sénat,
  Banque des Territoires), soit 4,15 Md€ (euros 2025) au-dessus de la
  reconduction tendancielle, maintenus ; remboursement de l'emprunt
  NextGenerationEU à partir de 2028 (décision (UE, Euratom) 2020/2053) :
  ≈ 2,5 Md€ de plus par an pour la France (Cour des comptes, note
  d'exécution budgétaire 2025). Le cadre financier 2028-2034, en
  négociation (35 à 42 Md€ par an selon la direction du budget et le Sénat),
  et les 30,9 Md€ proposés pour 2027 (PLF 2027, art. 55) ne sont pas
  retenus.
* **Prime d'activité** (loi de finances pour 2026) : bonification maximale
  portée de 184 € à 239 € au 1er avril 2026, ≈ +50 € par mois pour
  ≈ 3 millions de foyers : ≈ 1,8 Md€ par an (calcul ; coût officiel non
  publié).
* **Aide exceptionnelle à l'apprentissage** (décret n° 2026-168 du 6 mars
  2026) : 5 000, 4 500 ou 2 000 € selon le diplôme (moins de 250 salariés),
  pour les seuls contrats conclus avant le 1er janvier 2027 ; 3,1 Md€
  d'autorisations d'engagement en 2025, 2,2 Md€ en 2026 (Sénat, PLF 2026).
  À législation constante, elle s'éteint : −1,0, −2,4 puis −3,1 Md€ par
  rapport à 2025 de 2026 à 2028 (calcul, versements étalés sur la première
  année du contrat).
* **Contribution exceptionnelle des organismes complémentaires** (LFSS pour
  2026) : ≈ 1,0 Md€, pour 2026 seulement.

**Dette et charge d'intérêts de départ.** Dette de Maastricht de
3 306,1 Md€ fin 2024 et 3 460,5 Md€ fin 2025 (INSEE, mai 2026) ; la dette
de fin d'année se déduit du déficit (152,5 Md€) et de l'ajustement
dette-déficit observé de 2025 (1,9 Md€), nul ensuite. Charge d'intérêts
2025 de 64,7 Md€, dont 5,3 Md€ d'indexation des titres indexés (provision
en droits constatés, AFT) et ≈ 4,3 Md€ sur les BTF (201 Md€ fin 2024, émis
à 2,12 % en moyenne en 2025, AFT) : taux apparent de la dette à moyen et
long terme hors indexation de 1,78 % ; taux d'émission de 2025 : OAT à
10 ans de 3,37 % (moyenne annuelle), moins le rendement réel de la part
indexée.

**Indice de développement humain** (PNUD, Rapport sur le développement
humain 2025, données 2023) : IDH 0,920, 26e rang ; espérance de vie
83,3 ans, durée attendue de scolarisation 16,1 ans, durée moyenne 11,8 ans,
RNB par habitant 55 060 $ PPA 2021. Départ 2025 : espérance de vie 83,55 ans
(+0,25 an, évolution INSEE de 2023 à 2025), durée moyenne 11,9 ans
(+0,05 an par an, hypothèse : renouvellement des générations), RNB par
habitant 55 800 $ (PIB réel par habitant +1,4 % de 2023 à 2025, calcul) ;
IDH recalculé 0,924. Écart avec les pays de tête : l'éducation (Allemagne :
durée moyenne 14,3 ans).

Lois dont les effets sont jugés inclus dans la tendance : loi de
programmation de la recherche (marches de 500 à 600 M€ par an jusqu'en
2030, exécutées pour un quart à un cinquième en 2026), LOPMI et loi de
programmation de la justice (échéance 2027 : 25,35 et 10,75 Md€). Sans
effet sur le solde consolidé : hausse des cotisations employeurs à la
CNRACL (+3 points par an jusqu'en 2028, décret n° 2025-86), prélèvements de
l'État sur l'Unédic. Sans effet net mesuré sur l'emploi : loi « plein
emploi » (Dares-IPP, juin 2026). Non chiffrées : taxe sur les holdings
patrimoniales (loi de finances pour 2026, art. 7, rendement jugé « faible
ou nul »), convention d'assurance chômage de 2024 (≈ 1,5 Md€ d'économies,
déjà dans le niveau de 2025-2026).
-/

namespace Hypotheses
open Modele

/-- Emploi BIT 2025, personnes : 31 834 000 actifs × (1 − 7,9 %) = 29 319 000,
réparti selon
la structure de l'emploi 2024 par secteur (INSEE, estimations d'emploi) :
agriculture 2,2 %, industrie 11,2 %, construction 6,4 %, tertiaire marchand
49,8 %, tertiaire non marchand 30,4 %. -/
def emploi2025 : ParSecteur where
  agriculture := 645000
  industrie := 3284000
  construction := 1876000
  tertiaireMarchand := 14601000
  tertiaireNonMarchand := 8913000

/-- Dépenses 2025 par fonction, M€ : total 1 714,1 Md€ (INSEE) ventilé selon
les parts de la nomenclature COFOG 2023 (INSEE, dépenses des APU par
fonction) ; intérêts 2025 observés. Ordres de grandeur, à préciser avec la
ventilation 2025 dès publication. -/
def depenses2025 : ParFonction where
  retraites := 410000              -- vieillesse-survie ≈ 24 % des dépenses
  sante := 247000                  -- santé ≈ 14,4 %
  famille := 293000                -- famille, chômage, exclusion, invalidité ≈ 17 %
  enseignement := 154000           -- enseignement ≈ 9 %
  affairesEconomiques := 178000    -- affaires économiques ≈ 10,4 %
  defense := 53000                 -- défense ≈ 3,1 %
  securiteJustice := 46000         -- ordre et sécurité publics ≈ 2,7 %
  logementEnvironnement := 82000   -- logement, équipements collectifs, environnement ≈ 4,8 %
  culture := 39000                 -- loisirs, culture, culte ≈ 2,3 %
  interets := 64700                -- intérêts versés 2025, +11,2 % (INSEE, IR n°78)
  fonctionnement := 147400         -- services généraux hors intérêts (solde : 1 714,1 − autres postes)
  nonVentile := 0

/-- Prélèvements 2025, M€. -/
def impots2025 : ParImpot where
  tva := 221100            -- dérivé : +1,1 Md€ soit +0,5 % (INSEE, IR n°78, 27/03/2026)
  ir := 103800             -- dérivé : +7,6 Md€ soit +7,9 % (idem)
  csgCrds := 167200        -- dérivé : +3,6 Md€ soit +2,2 % (idem)
  cotisations := 446300    -- cotisations sociales effectives (idem)
  impotSocietes := 58900   -- dérivé : +2,1 Md€ soit +3,7 % (idem)
  accisesEnergie := 30500  -- TICPE, 30,5 Md€ en 2022, dernier chiffre publié (MTE, via Journal de l'Automobile)
  taxeFonciere := 44100    -- dérivé : TFPB +1,2 Md€ soit +2,8 % (DGCL, note REI 2025)
  droitsMutation := 20700  -- successions 16,2 + donations 4,5 Md€ en 2025 (Legifiscal, 23/09/2026)
  mutationsOnereuses := 17600  -- dérivé : 16,9 Md€ en 2023 (IGF, juillet 2024), −12,9 % en 2024 (INSEE, IP n° 2054), +19,4 % en 2025 (Cour des comptes, juillet 2026)
  patrimoine := 2300       -- IFI ≈ 2,3 Md€ en 2025, 193 600 foyers (DGFiP, via Previssima)
  autres := 215800         -- solde : impôts 882,0 + cotisations 446,3 − postes ci-dessus

/-- Éléments temporaires de la situation de départ : dépenses et recettes de
2025 dont la fin est prévue par les textes ou les calendriers en vigueur.
Sans eux, la projection les reconduirait indéfiniment.

* **Grand Paris Express** (Société des grands projets, administration
  publique) : ≈ 3,6 Md€ de dépenses par an en 2020-2022, 5,4 Md€ prévus en
  2023 (Sénat, rapport sur le PLF 2024) ; coût 36,1 Md€ ; mises en service
  de 2026 à 2031 (lignes 15 Ouest et Est en 2031). Retenu : 4,0 Md€ en
  2025, décroissant avec les ouvertures, nul à partir de 2032. La dette
  (remboursée jusqu'en 2071 par des taxes affectées, ≈ 0,85 Md€ par an)
  reste dans la dette publique ; les futurs RER métropolitains (SERM, 20 à
  30 Md€) ne sont pas financés à ce jour et ne sont pas reconduits.
* **France 2030** : 54 Md€, ≈ 40 Md€ attribués et 14 Md€ décaissés au
  30 juin 2025, 6,9 Md€ de décaissements prévus en 2026 (Sénat, rapport sur
  le PLF 2026). Retenu : 6,5 Md€ en 2025, 6,7 Md€ en 2026 (euros 2025),
  puis extinction des décaissements jusqu'en 2031 (≈ 26 Md€ restant à
  verser) ; pas de programme successeur à législation constante.
* **CRDS** : 0,5 %, 9,22 Md€ en 2026 ; due jusqu'à l'extinction de la CADES,
  fin 2033 (loi organique). La fraction de CSG affectée à la CADES (0,45 %,
  7,95 Md€) revient alors à la Sécurité sociale (neutre pour les
  administrations publiques) ; la CRDS disparaît : −9 Md€ (euros 2025) à
  partir de 2034. La dette de l'ACOSS (65 Md€ fin 2026) n'étant pas reprise,
  une prolongation reste possible : elle demanderait une loi organique.

Non retenus, faute d'échéance avant 2035 : les loyers des contrats de
partenariat de l'État (9,8 Md€ d'investissements, signés surtout en
2011-2012 pour 27 ans en moyenne : Balard, tribunal de Paris, LGV
Bretagne-Pays de la Loire jusqu'en 2036, contournement Nîmes-Montpellier
jusqu'en 2037) ; les lignes à grande vitesse en service (financement
public versé pendant les travaux), alors que les projets en cours
(Bordeaux-Toulouse, Montpellier-Perpignan, Lyon-Turin) font au contraire
monter la dépense. -/
def echeancesDepart : List Echeance := [
  { fonction := .affairesEconomiques, niveau := 4000, indice := 10000,
    restants := [3600, 3000, 2400, 1800, 1200, 600, 0] },        -- Grand Paris Express
  { fonction := .affairesEconomiques, niveau := 6500, indice := 10000,
    restants := [6700, 6000, 5000, 3800, 2400, 1000, 0] },       -- France 2030
  { fonction := .defense, niveau := 0, indice := 10000,
    restants := [5867, 10943, 15899, 17903, 19839] },            -- LPM actualisée (2026-2030)
  { fonction := .logementEnvironnement, niveau := 0, indice := 10000,
    restants := [0, 0, 2975] },                                  -- ETS2 : moitié redistribuée dès 2028
  { fonction := .fonctionnement, niveau := 0, indice := 10000,
    restants := [4273, 4273, 6592] },                            -- contribution à l'UE, puis remboursement de NextGenerationEU
  { fonction := .famille, niveau := 0, indice := 10000,
    restants := [1310, 1700] },                                  -- prime d'activité revalorisée (avril 2026)
  { fonction := .famille, niveau := 0, indice := 10000,
    restants := [-970, -2400, -3100] },                          -- fin de l'aide exceptionnelle à l'apprentissage
  { fonction := .famille, niveau := 0, indice := 10000,
    restants := [-20, -260, -720, -880] } ]                      -- durée d'indemnisation des ruptures conventionnelles

def echeancesRecettesDepart : List EcheanceRecette := [
  { impot := some .csgCrds, niveau := 9000, indice := 10000,
    restants := [9000, 9000, 9000, 9000, 9000, 9000, 9000, 9000, 0] },  -- CRDS, fin de la CADES en 2033
  { impot := some .autres, niveau := 0, indice := 10000,
    restants := [0, 0, 5950] },                                          -- ETS2, enchères dès 2028
  { impot := some .impotSocietes, niveau := 8000, indice := 10000,
    restants := [7280, 0] },                                             -- contribution exceptionnelle des grandes entreprises (7,5 Md€ courants en 2026)
  { impot := some .autres, niveau := 3400, indice := 10000,
    restants := [3400, 3400, 2310, 1090, 0] },                           -- CVAE : 0,28 % → 0,19 % → 0,09 % → 0
  { impot := some .cotisations, niveau := 0, indice := 10000,
    restants := [250] },                                                 -- contribution patronale sur les ruptures conventionnelles à 40 %
  { impot := some .cotisations, niveau := 0, indice := 10000,
    restants := [2140, 0] },                                             -- gel du SMIC de référence des allègements, 2026 seulement
  { impot := some .autres, niveau := 0, indice := 10000,
    restants := [970, 0] } ]                                             -- contribution des complémentaires santé, 2026 seulement

/-- Hausses de l'âge légal, mois, de 2026 à 2033 : suspension jusqu'en
janvier 2028 (LFSS pour 2026), puis +3 mois par génération (générations
1965 à 1969). -/
def calendrierAgeLegal : List Int := [0, 0, 3, 0, 3, 3, 3, 3]

/-- Calendrier de la loi n° 2023-270 sans suspension (64 ans en 2032),
supposé intégré à la tendance des dépenses et de la population active. -/
def calendrierAgeReforme2023 : List Int := [0, 3, 3, 0, 3, 3, 3, 0]

theorem calendriers_meme_cible : calendrierAgeLegal.sum = calendrierAgeReforme2023.sum := by decide

/-- Passifs implicites (« dettes cachées ») suivis par le modèle : heures
supplémentaires non payées ni récupérées des policiers, 14,3 millions
d'heures au 31 décembre 2022 (Sénat, rapport n° 34, 2024-2025, annexe
« Sécurités » ; 23 millions fin 2018, Cour des comptes), dernier chiffre
publié, supposé stable depuis (3,9 millions d'heures payées en 2023,
≈ 30 M€ en 2024, et les 5,3 millions d'heures des Jeux de 2024 payées en
totalité). Valeur au taux d'indemnisation de 13,22 € brut de l'heure
(12,47 € relevés de 6 % en novembre 2020) : 189 M€ (calcul ; 366 M€ au
coût complet retenu par la Cour des comptes en 2020, 25,6 €/h). Flux de
nouvelles heures non payées : non publié, supposé nul. L'hôpital a son
propre stock (`passifsHopital2025`). Non comptés : le stock de la fonction
publique territoriale (6,2 millions d'heures), les congés non pris des
gendarmes mobiles, les comptes épargne-temps. -/
def passifsPolice2025 : Int := 189

/-- Heures supplémentaires non payées ni récupérées à l'hôpital public
(établissements publics de santé, administrations de sécurité sociale) :
18,5 millions d'heures, 463 M€, fin 2018, non provisionnées (Cour des
comptes, 2020) ; aucun stock national plus récent publié. Bilan social
des hôpitaux 2022 (ATIH, 421 établissements, moyennes par agent) :
20,8 heures stockées par agent non médical, coût moyen de 32 € l'heure, et
6,1 demi-journées par médecin à 241 € ; rapportés aux 855 675 postes non
médicaux et 103 623 postes médicaux (DREES, fin 2024) : 17,8 millions
d'heures, 570 M€, plus 150 M€ pour les médecins, soit 720 M€ (calcul ;
stock stable entre 2021 et 2022). Les comptes épargne-temps (≈ 2,6 Md€,
provisionnés au moins en partie) ne sont pas comptés. -/
def passifsHopital2025 : Int := 720

/-- Retard d'entretien des infrastructures de transport hors rail, M€ :
ouvrages d'art routiers ≈ 6 Md€ (ponts et murs des communes de moins de
10 000 habitants : 3,3 Md€ de remise en état dont 0,8 Md€ d'urgences,
Cerema, Programme national ponts, bilan au 31 octobre 2025, 52 799
ouvrages évalués, 28 % des ponts en bon état ; départements : ≈ 10 000
ponts en mauvais état à ≈ 120 000 €, ≈ 1,2 Md€, calcul, Sénat, rapport
n° 669, 2022 ; État : 854 ponts, retard de 89 M€ en 2022 ; fourchette 4,5 à
8 Md€), chaussées du réseau routier national non concédé ≈ 4,5 Md€ (besoin
de 1,3 Md€ par an de 2022 à 2037 pour revenir à l'état de 2017 contre ≈ 1
Md€ dépensé, audit IMDM-Nibuxs 2018, Cour des comptes 2022 ; calcul),
voies navigables 1,1 Md€ de « dette grise » (Cour des comptes, février
2025) ; total ≈ 12 Md€ ; le rail (≈ 1,5 Md€ par an de régénération non
financés, Conseil d'orientation des infrastructures 2023) et les bâtiments
publics (universités ≈ 7 Md€, écoles jusqu'à 50 Md€ avec l'énergie) ne sont
pas comptés, faute de stock établi. -/
def passifsInfrastructures2025 : Int := 12000

/-- Accroissement annuel du retard d'entretien, M€ par an : ouvrages d'art
≈ 0,4 Md€ (entretien courant communal 140 M€ et fonds de 130 M€ par an
demandés par le Sénat, départements en baisse de 9 % en 2024, Observatoire
national de la route), chaussées nationales ≈ 0,3 Md€ (1,3 Md€ nécessaires
contre ≈ 1 Md€), voies navigables ≈ 0,1 Md€ (Cour des comptes 2025) :
≈ 0,8 Md€ par an, indexés sur les prix des travaux. -/
def fluxPassifsInfrastructures : Int := 800

/-- Émissions territoriales 2025 par secteur, kt CO₂e hors puits (Citepa,
inventaire Secten publié le 16 juin 2026, estimation 2025 ; déchets : niveau
2024, non réestimé). Total 359,5 Mt ; 367,0 Mt en 2024, 546,9 Mt en 1990. -/
def emissions2025 : ParSecteurGes :=
  { transports := 122900, batiments := 54900, agriculture := 76600, industrie := 58400,
    energie := 31400, dechets := 15300 }

def reference2026 : Reference where
  id := "ref-2025"
  description := "Situation observée en 2025 (INSEE), départ des projections"
  annee := 2025
  etat := {
    pib := 2992000                 -- déficit 152,5 Md€ = 5,1 % et dette 3 460,5 Md€ = 115,6 % (INSEE)
    impots := impots2025
    autresRecettes := 233300       -- recettes totales 1 561,6 Md€ − impôts et cotisations 1 328,3 Md€
    depensesF := depenses2025      -- 1 714,1 Md€ de dépenses des APU 2025 (INSEE)
    tauxApparentPb := 178          -- dette à moyen et long terme : (64,7 − 5,3 d'indexation − 201 × 2,12 % de BTF) / (3 306,1 − 201)
    tauxEmissionPb := 321          -- OAT 10 ans 2025 (3,37 %) moins rendement réel de la part indexée (8,9 % × 1,75 %)
    chargeIndexationMeur := 5309   -- provision pour indexation en droits constatés (AFT, comptabilité générale)
    remunerationParEmploiEuros := 39469   -- salaires et traitements bruts 2025, 1 157,2 Md€ (INSEE, compte des ménages) / 29 319 000 emplois
    consommationMenages := 1545900        -- dépense de consommation des ménages 2025 (INSEE, IP n° 2105)
    croissanceBeneficePb := 100           -- bénéfice fiscal 2025 : +1,0 % (Cour des comptes, février 2026)
    croissanceBeneficeAvantPb := -190     -- bénéfice fiscal 2024 : −1,9 % (PLF 2025, Voies et moyens, tome I)
    inflationConsoPb := 90         -- IPC 2025, moyenne annuelle (INSEE)
    detteDebut := 3306100          -- dette de Maastricht fin 2024 (INSEE, mai 2026)
    ajustementDetteAnnee := 1900   -- 3 460,5 − 3 306,1 − 152,5 (calcul)
    operationsFinancieres := 0     -- écart variation de dette − déficit : +1,9 Md€/an en moyenne 2015-2025 hors 2020 (INSEE, calcul), surtout trésorerie et primes d'émission, réversibles : nul en tendance
    smicMensuel := 1802            -- SMIC brut mensuel de 2025 : 1 801,80 € (décret n° 2024-951, en vigueur du 1er novembre 2024 à fin 2025)
    emissionsKt := emissions2025   -- 359,4 Mt CO₂e hors puits (Citepa, Secten 2026, estimation 2025)
    ageLegalMois := 753            -- 62 ans et 9 mois, gelé par la LFSS pour 2026 (loi n° 2025-1403, art. 45)
    populationMilliers := 69100    -- population au 1er janvier 2026 (INSEE, bilan démographique 2025)
    actifs := 31834000             -- population active BIT 2025 (INSEE)
    emploi := emploi2025           -- chômage BIT 7,9 % fin 2025 (INSEE)
    heuresParEmploi := 1494        -- heures annuelles par personne en emploi, 2023 (OCDE)
    migrationAnnuelleMilliers := 0
    emploisAnnonces := 0
    touristesMilliers := 100000    -- 100 millions de visiteurs internationaux en 2024 (Atout France)
    depenseParTouriste := 710      -- 71 Md€ de recettes du tourisme international 2024 / 100 M (Banque de France)
    exportations := 980000         -- biens et services ≈ 33 % du PIB (INSEE, ordre de grandeur)
    importations := 985200         -- exportations − solde biens et services (−64,4 + 59,2 = −5,2 Md€, BdF, 12 mois à sept. 2025)
    revenusNets := -5300           -- revenus primaires et secondaires nets (BdF, 12 mois à sept. 2025) ; solde courant −10,5 Md€
    variationImportsAnnuelle := 0
    tauxAccidentsPdm := 190        -- 564 000 accidents avec arrêt / 29,3 M d'emplois (CNAM 2023)
    robotisationPb := 0
    decesPollutionAir := 40000     -- décès attribuables aux PM2,5 (Santé publique France, 2021)
    parcElectriqueMilliers := 1600 -- voitures 100 % électriques en circulation fin 2025 (Avere-France, ordre de grandeur)
    capacitesMw := Hypotheses.Electricite.capacites2025      -- RTE, Bilan électrique 2025, p. 23
    productionGwh := Hypotheses.Electricite.production2025   -- RTE, Bilan électrique 2025, p. 21-22
    consommationBaseGwh := Hypotheses.Electricite.consommationBase2025  -- consommation brute hors voitures électriques
    consommationGwh := Hypotheses.Electricite.consommation2025          -- consommation brute 2025, pertes incluses (BE2025 p. 12)
    surfacesHa := Hypotheses.Sols.surfaces2025               -- ENAF consommés depuis le 1er janvier 2021 (Cerema, millésime 2025)
    bornesMilliers := 175          -- points de recharge ouverts au public fin 2025 (Avere-France, ordre de grandeur)
    electrificationAnnuelleMilliers := 0
    bornesAnnuellesMilliers := 0
    participationsEtat := 209100   -- portefeuille de l'APE, valeur estimée au 30 juin 2025 (86 entités)
    passifs := { police := passifsPolice2025, hopital := passifsHopital2025,
                 infrastructures := passifsInfrastructures2025 }  -- heures supplémentaires non payées, retard d'entretien
    fluxPassifs := { infrastructures := fluxPassifsInfrastructures }
    cdhrMeur := 400                -- contribution différentielle sur les hauts revenus, encaissements 2025
    allegementsTranche := { bas := 64950, intermediaire := 8850, haut := 1200 }  -- allègements généraux ≈ 75 Md€, répartis selon la RGDU 2026 (calcul)
    esperanceVieTendanceCentiemes := 8355  -- 83,3 ans en 2023 (PNUD, RDH 2025) + 0,25 (INSEE : 82,85 → 83,1 de 2023 à 2025)
    dureeAttendueCentiemes := 1610       -- durée attendue de scolarisation, 2023 (PNUD, RDH 2025)
    dureeMoyenneCentiemes := 1190        -- 11,8 ans en 2023 (PNUD) + 2 × 0,05 (hypothèse)
    dividendesEtat := 4000         -- dividendes 2025 ≈ 6,5 Md€ (2024 et 2025) − 2,47 Md€ (2024) (APE, rapport d'activité) ; inclus dans les recettes non fiscales
    echeances := echeancesDepart
    echeancesRecettes := echeancesRecettesDepart
    calendrierAgeLegal := calendrierAgeLegal
    calendrierAgeTendanciel := calendrierAgeReforme2023 }
  populationMilliers := 69100
  partPlus65Pb := 2220             -- 22,2 % au 1er janvier 2026 (INSEE)
  partPlus65TendancePb := 2350     -- démographie des tendances de dépenses : celle de l'hypothèse centrale
  seuilChomageContracyclePb := 900 -- décret n° 2023-33, art. 9 bis
  surcoutComplementChomageMeur := 4300  -- complément de fin de droits (≈ économie de la règle, Unédic)
  rnbParHabitantPpaDollars := 55800  -- 55 060 $ PPA 2021 en 2023 (PNUD) × PIB réel par habitant 2023-2025 (+1,4 %, calcul)
  lnRnbSur100Millioniemes := 6324359 -- ln(558), calcul
  hausseDureeMoyenneCentiemes := 5   -- renouvellement des générations, hypothèse
  sources := [
    "INSEE, Informations rapides n°78, comptes des APU 2025 (27 mars 2026)",
    "APE, rapport d'activité 2025 (portefeuille 209,1 Md€, dividendes)",
    "Sénat, rapports sur les PLF 2024 (Société du Grand Paris) et 2026 (France 2030) ; CADES et CRDS (rapport 2026)",
    "INSEE, Bilan démographique 2025, Insee Première n°2087 (13 janvier 2026)",
    "INSEE, population active 2025 ; emploi salarié et non salarié par activité 2024",
    "DGCL, note sur les taux de fiscalité directe locale 2025",
    "Ministère de la Transition écologique : TICPE 2022 (via Journal de l'Automobile, mars 2024)",
    "Santé publique France, Impact de la pollution de l'air ambiant sur la mortalité en France (2021) : 40 000 décès/an attribuables aux PM2,5",
    "Avere-France, baromètres 2025 : parc électrique et points de recharge publics (ordres de grandeur, à préciser)",
    "INSEE, dépenses des administrations publiques par fonction (COFOG), 2023 : parts appliquées au total 2025",
    "OCDE, heures annuelles travaillées par personne en emploi, France 2023 : 1 494 h",
    "Atout France, bilan 2024 : 100 millions de visiteurs internationaux ; Banque de France, balance des paiements 2024 : 71 Md€ de recettes de voyages",
    "Banque de France, balance des paiements de septembre 2025 (cumul 12 mois) : biens −64,4 Md€, services +59,2 Md€, revenus −5,3 Md€, transactions courantes −10,5 Md€"]

end Hypotheses
