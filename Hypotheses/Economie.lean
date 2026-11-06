import Modele

/-!
# Axe économique

`actifsParMoisAgeLegal` = 30 000 personnes : la réforme de 2023 (+2 ans)
ajoute 737 000 actifs en 2030 selon l'INSEE (actualisation des projections
de population active, 2023), soit ≈ 30 000 par mois.
`economieParMoisRetraite` = 650 M€ : 13,6 à 17,7 Md€ d'économies en 2030
pour 24 mois selon les chiffres gouvernementaux de la réforme de 2023 (via
IFRAP), soit 570 à 740 M€ par mois ; valeur centrale retenue (auparavant
1 500 M€, valeur provisoire surestimée).
`elasticitePibHeuresPm` = 650 : part du travail dans la valeur ajoutée
(INSEE, comptes nationaux, ≈ 65 %), prise comme élasticité du PIB au
volume d'heures travaillées à capital donné. `tauxISPb` = 2 500 : taux
normal de l'IS de 25 % depuis 2022.
`coutParPbPlus65` = 185 M€ : 410 Md€ de retraites pour 22,2 % de plus de
65 ans, soit 185 M€ par point de base de part ; `coutSanteParPbPlus65`
= 20 M€ : les plus de 65 ans consomment environ deux fois la dépense de
santé moyenne (DREES, comptes de la santé), soit 247 Md€ × (2 − 1) /
(1 + 0,222) × 10⁻⁴ ≈ 20 M€ par point de base. Ils ne s'appliquent qu'à
l'écart entre l'hypothèse démographique et la démographie des tendances de
dépenses (`Reference.partPlus65TendancePb`), déjà vieillissante : nul dans
le scénario central.
`contenuImportDemandePm` = 300 : contenu en importations de la demande
intérieure ≈ 30 % (INSEE, tableaux entrées-sorties).
Accidents du travail : 564 000 accidents avec arrêt et 759 décès en 2023
(Assurance maladie — Risques professionnels, rapport annuel 2023), soit
190 pour 10 000 personnes en emploi et 13 décès pour 10 000 accidents ;
coût de la branche AT-MP ≈ 13,5 Md€ → 24 000 € par accident (maladies
professionnelles comprises, approximation) ; ≈ 40 millions de journées
indemnisées → 70 jours par accident. Moyenne de l'Union : incidence
française ≈ 1,75 fois la moyenne UE-27 (Eurostat, accidents non mortels
> 3 jours, 2022), d'où une cible de 110 pour 10 000.
`robotisationTendanciellePb` = 0 : les tendances de dépenses ci-dessous
intègrent déjà les gains de productivité ; la robotisation reste un levier
des programmes.

**Trajectoire macroéconomique.** Les premières années suivent les
prévisions publiées (`trajectoireVolume`, `trajectoirePotentiel`,
`trajectoireDeflateur`, `trajectoireConso`, `trajectoireTaux`,
`trajectoireTauxCourt`, sources en docstring) : croissance de 0,4 %,
0,9 % et 1,2 % de 2026 à 2028 (Banque de France, septembre 2026), puis
rattrapage de 0,2 point par an au-dessus du potentiel en 2029-2030 (mission
d'experts sur la transparence des finances publiques, juillet 2026) ;
croissance potentielle de 1,2 % jusqu'en 2028 (PSMT d'octobre 2024, PLF
2027), puis 1 % (mission d'experts, PSMT) dans le scénario central ;
déflateur de 1,3 % en 2026 puis 1,7, 1,6, 1,4 et 1,4 % (mission) ;
inflation de 2,3 %, 1,8 % et 1,6 % de 2026 à 2028 (INSEE, PLF 2027,
Banque de France) ; OAT à 10 ans à 3,8 % en 2026 et 4,3 % en 2027
(hypothèses des PLF 2026 et 2027), puis 4,4 % (taux à terme fin 2029 cité
par la mission). Au-delà : valeurs de long terme de la variante. La loi
d'Okun et les élasticités des prélèvements s'appliquent à l'écart entre la
croissance en volume et la croissance potentielle.

**Élasticités des prélèvements au cycle** (`elasticitesCycliques`) : impôt
sur le revenu et CSG-CRDS 1,86, impôt sur les sociétés 2,76, cotisations
sociales 0,63, impôts indirects et autres 1,00 : celles de la loi de
programmation 2023-2027 (DG Trésor, document de travail 2025/2, tableau 1,
calibrage 2008-2017), qui coïncident avec celles de la Commission
européenne (Mourre, Poissonnier et Lausegger, 2019) et de l'OCDE (Price,
Dang et Botev, 2015). Les recettes non fiscales sont acycliques. Avec
l'élasticité des dépenses de chômage (−3,23), la semi-élasticité du solde
vaut ≈ 0,57 (LPFP ; 0,63 pour la Commission) : test
`Tests.Mecanismes.semi_elasticite_solde`.

**Prélèvements sur leur assiette naturelle** (`assiettesFrance`,
`Modele/Projection.lean`, `Assiettes.taux`). Les élasticités au cycle
ci-dessus ne servent plus qu'aux chocs de demande des mesures et aux autres
impôts ; chaque grand prélèvement suit chaque année son assiette :

* *Masse salariale* (salaires et traitements bruts, 1 157,2 Md€ en 2025,
  INSEE) : emploi × rémunération par emploi. Celle-ci croît de la
  productivité tendancielle (croissance potentielle moins croissance
  tendancielle de l'emploi) et des prix : 64 % de l'inflation de l'année,
  36 % de celle de l'année précédente (`retardSalairesPm` = 360 : maquette
  Opale de la DG Trésor, +10 % de prix donnent +6,4 % de salaire moyen par
  tête la première année, +10 % à long terme ; billet du 23 décembre 2022).
  Élasticité de la masse salariale au cycle : 0,66 (Commission européenne,
  Economic Paper 536, 2014, tableau 3.4) ; l'emploi y répond par la loi
  d'Okun, la rémunération par emploi (heures, primes) pour le reste.
* *Cotisations* : masse salariale ; élasticité 0,95 sur sa part cyclique
  (même source ; plafond de la sécurité sociale, allègements). *CSG-CRDS* : revenus d'activité 70 %,
  de remplacement 18,2 %, du capital et jeux le reste (Fipeco d'après la
  Commission des comptes de la sécurité sociale, 2024), à taux
  proportionnels.
* *Impôt sur le revenu* : revenus déclarés de 2022 (DGFiP) : salaires
  61,7 %, pensions 25,7 %, indépendants (BIC, BNC, BA) 4,8 %, capital et
  plus-values 7,8 % ; élasticité à l'assiette 1,68 (Commission ; OCDE,
  Price, Dang et Botev, 2015) appliquée à la seule hausse au-delà de la
  revalorisation du barème (inflation de l'année précédente : l'INSEE,
  Lafféter et Pak 2015, trouve ≈ 1,7 au volume et ≈ 1,0 aux prix). Revenus
  des indépendants et du capital : PIB nominal et cycle, élasticités 1,33 et
  3,52 (OCDE, tableau 5).
* *TVA* : consommation des ménages (1 545,9 Md€ en 2025), volume de
  l'activité et prix à la consommation.
* *IS* : excédent des entreprises = valeur ajoutée des sociétés non
  financières (51,6 % du PIB en 2025 : 1 543,8 Md€) moins leurs
  rémunérations (87,1 % des salaires bruts : 1 007,9 Md€, INSEE IP n° 1997,
  2053, 2105) ; le bénéfice fiscal amplifie 2,03 fois (Commission) les
  écarts de l'excédent à sa tendance (PIB en valeur à la croissance
  potentielle) et suit cette tendance à long terme. L'IS
  encaissé suit les règles de paiement (art. 1668 du CGI) : les entreprises
  au dernier acompte (chiffre d'affaires > 250 M€, 95 à 98 % de l'IS de
  l'exercice dans l'année depuis 2019) en paient l'IS de l'année ; les
  autres versent des acomptes sur l'exercice précédent, réduits si leur
  bénéfice baisse, et le solde l'année suivante. `partIsAnneeCourantePm` =
  450 : les entreprises de plus de 250 M€ de chiffre d'affaires (≈ 1 000
  sociétés) sont toutes les grandes entreprises, qui paient 30 à 38 % de
  l'IS brut, et le haut des ETI (grandes entreprises et ETI : 53 à 60 %,
  INSEE, « Les entreprises en France », 2018-2023) : milieu de la fourchette.
* *Accises sur l'énergie* : tarifs en euros par unité, non indexés ;
  volume de carburants hors électrification stable (`elasticiteCarburants`
  = 0 : 50,3 Mm³ en 2019, 47,8 en 2024, CCFA, dont l'électrification déjà
  retirée par le modèle).
* *Taxe foncière* : revalorisation forfaitaire légale des valeurs locatives
  (glissement de l'IPCH de novembre à novembre, art. 1518 bis du CGI ;
  +0,8 % en 2026, puis l'inflation de l'année précédente) et croissance
  physique des bases de 0,8 % par an (produit moins revalorisation et effet
  taux : ≈ 1,0 point en 2020, 0,7 en 2022, 0,6 en 2024, DGCL, Fipeco).
* *Droits de mutation à titre onéreux* : valeur des transactions
  immobilières (au-delà des années observées : PIB nominal).

Les élasticités au cycle qui en résultent (tests `Tests.Assiettes`) :
cotisations 0,59, TVA 0,97, IS 1,45 la première année et 3,2 en régime
établi ; semi-élasticité du solde 0,45 la première année, 0,56 ensuite
(LPFP : 0,57).

**Structure de la dette.** `partDetteCourtTerme` = 57 ‰ : BTF (196 Md€ fin
2025, Agence France Trésor) rapportés à la dette de Maastricht ; renouvelés
chaque année au taux court (`trajectoireTauxCourt` : 2,5 % en 2026, puis
3,0 %, hypothèses du PLF 2027). La dette à moyen et long terme existante fin
2025 arrive à échéance selon l'échéancier de l'Agence France Trésor, au
coupon des titres échus (`echeancesDette`, `tauxEcheances` : voir plus bas) ;
la dette émise ensuite est refinancée à raison de `renouvellementDette` =
109 ‰ par an : durée de vie moyenne de la dette négociable de l'État de
8,5 ans (AFT, 2025), soit 9,2 ans hors BTF. Sur dix ans, l'échéancier
renouvelle 67,7 % du stock de départ, autant que 10,9 % par an (68,4 %),
mais plus tôt (8,4 à 9,3 % par an de 2027 à 2029, 4,1 à 5,1 % de 2033 à
2035) et d'abord des titres à coupon faible (1,2 % en 2028). Les
amortissements exécutés de la dette de l'État ne font que 6,4 à 7,8 % de son
encours de début d'année de 2018 à 2025 (lois de règlement, calcul), 8,9 à
9,1 % en 2024-2025 avec les rachats ; au rétro-test, ces taux améliorent
l'erreur à un an (1,9 Md€ au lieu de 2,2) mais la dégradent depuis 2021
(4,2 Md€ au lieu de 2,6), quand les réémissions sous le pair de titres à
coupon faible, comptées au taux de marché, accélèrent le renouvellement en
comptabilité nationale : 10,9 % est gardé pour la dette émise après 2025.
Convention de mi-année (`emissionsMiAnnee`) : non retenue, elle dégrade le
rétro-test (2,6 Md€ au lieu de 2,4 depuis 2018, 3,0 au lieu de 2,6 depuis
2021). `partDetteIndexee` = 89 ‰ :
307 Md€ d'OATi et d'OAT€i fin 2025 (AFT) ; leur capital suit l'inflation
(charge d'intérêts en comptabilité nationale) et ils sont émis au taux
réel (taux marginal moins inflation de long terme). `primeDeficitPb` = 25 :
une hausse d'un point du déficit/PIB anticipé relève les taux longs
d'environ 25 pb, une hausse d'un point de dette/PIB de 3 à 4 pb (Laubach,
« New Evidence on the Interest Rate Effects of Budget Deficits and Debt »,
JEEA, 2009). Appliquée à l'écart entre le déficit de l'année précédente et
celui de départ (5,1 %), calculé exactement (non arrondi au pb), les taux
étant portés en ppm dans la projection : un déficit ramené à 3 % abaisse le taux marginal
de ≈ 50 pb, un déficit de 8 % le relève de ≈ 75 pb. La baisse est bornée :
le taux français ne peut descendre sous celui du Bund (`tauxBund` = 3,22 %,
niveau du 6 novembre 2026, supposé constant) plus un écart plancher
(`ecartBundPlancher` = 43 pb, moyenne 2015-2023), soit 3,65 %. Pas de borne
à la hausse : les estimations
trouvent une prime qui s'accentue quand la dette est élevée (Pamies et al.,
ci-dessous ; Ardagna, Caselli et Lane, 2007), et l'instrument de protection
de la transmission de la BCE est réservé aux pays qui respectent les règles
budgétaires européennes. `primeDettePb` =
`primeDette` = 2 : prime de stock, par point de dette/PIB au-dessus de la
dette de départ, en plus de la prime de déficit. Les estimations vont de 2
à 5 pb par point (CBO 2019 et 2024 : 2 ; Poghosyan, FMI 2012 : 2 ; Pamies,
Carnot et Pătărău, Commission européenne 2021, spreads de la zone euro :
3, avec une pente de 5,7 au-delà de 90 % du PIB ; Laubach 2009 : 3 à 4) ;
la borne basse est retenue parce que la prime de déficit, estimée seule par
Laubach sur le déficit anticipé, capture déjà une part de l'effet de la
dette future (les deux ne s'additionnent pas strictement). Nulle dans le
rétro-test. Rétro-test 2019-2025
de la charge d'intérêts : erreur moyenne de 2,2 Md€ (voir
`Modele/Retro.lean`), contre 4,6 Md€ avec la convergence à 20 pb par an de
la version précédente.

**Tendances des dépenses à législation constante** (`volumeDepenses`,
`indexationDecalee`) : prix plus volume propre à chaque fonction, d'après
les hypothèses « à politique inchangée » de la mission d'experts (rapport du
15 juillet 2026, p. 6-8 et tableau 4) et du COR (rapport de juin 2026,
tableau 2.1) :
* retraites : revalorisation sur l'inflation de l'année précédente (code de
  la sécurité sociale, art. L. 161-25), volume +0,85 % par an (COR :
  +0,9 % par an de 2025 à 2045, effectifs +0,5 %, pension moyenne réelle
  +0,5 % ; moins ≈ 0,05 point pour la suspension de la réforme de 2023, que
  le modèle compte à part par le calendrier de l'âge légal) ;
* santé : +1,95 % en volume (ONDAM tendanciel +3,5 % par an en valeur selon
  la mission, +3,4 % « pur » selon le PLFSS 2027, moins le déflateur de la
  mission, ≈ 1,55 %) ;
* famille, chômage, solidarité : revalorisation sur l'inflation de l'année
  précédente, volume nul (prestations familiales +1,7 % par an, chômage
  +0,6 %, prestations de l'État au rythme du potentiel nominal : ≈ prix) ;
* fonctions surtout portées par l'État (enseignement, sécurité et justice) :
  +0,95 % en volume (crédits des ministères +2,5 % par an en valeur, point
  d'indice gelé, effectifs stables, glissement vieillesse-technicité
  +0,6 %) ;
* fonctions surtout portées par les collectivités (logement et
  environnement, culture) : +1,1 % en volume (fonctionnement au rythme de
  la croissance potentielle) ; fonctions mixtes (affaires économiques,
  services généraux) : +1 % ;
* défense : prix seulement, la loi de programmation militaire passant par
  son échéancier (`echeancesDepart`).
Dépense hors intérêts obtenue : ≈ +2,8 % par an en valeur de 2026 à
2030 (mission : +3,1 %, avec une contribution à l'Union qui suit la
proposition de cadre financier 2028-2034, non retenue ici). Test
`Tests.Tendanciel` : dérive du déficit tendanciel 2026-2030 à moins d'un
demi-point de celle de la mission. Sur le passé (rétro-test, à titre
d'information), la règle s'écarte des dépenses observées de +0,4 point de
PIB en 2019 (maîtrise de la dépense), −1,7 point en 2020 et 2021 (crise
sanitaire), ≈ 0 en 2022, +1,1 point en 2023 (dépense en retard sur
l'inflation), +0,2 et +0,1 point en 2024 et 2025.
Prélèvement forfaitaire unique (PFU) : 31,4 % depuis le 1er janvier 2026
(loi n° 2025-1403 du 30 décembre 2025 de financement de la Sécurité sociale
pour 2026, art. L. 136-6 et L. 136-7 CSS), soit 12,8 % d'impôt sur le revenu
(`tauxPfuIrPm` = 128), 10,6 % de CSG et 0,5 % de CRDS (`tauxPfuCsgCrdsPm` =
111) et 7,5 % de prélèvement de solidarité (`tauxPfuSolidaritePm` = 75).
Législation en vigueur, identique dans les trois variantes.

Droits de succession et de donation : 20,7 Md€ en 2025, dont 16,2 sur les
successions et 4,5 sur les donations (Legifiscal, 23 septembre 2026).
Leur assiette, le flux successoral (464 Md€ en 2025, 16,1 % du PIB),
monterait à 20,2 % du PIB en 2040 (Fondation Jean-Jaurès, novembre 2024) :
+1,5 % par an au-delà du PIB, dont ≈ 1,1 point de hausse des décès (INSEE,
projections 2026) ; `excesPatrimoineParDecesPb` = 40 pour le reste
(patrimoine transmis par décès). Les abattements (100 000 € par enfant
depuis 2012) et le barème (5 % à 45 %) ne sont pas indexés : la part
taxable et le taux moyen montent avec les montants nominaux.
`elasticiteDroitsSuccessionPm` = 1 200 : ≈ 0,1 au titre de l'abattement en
ligne directe (relever celui-ci de 50 000 € coûterait ≈ 1 Md€, Institut
Montaigne 2022, d'après l'étude d'impact de 2012 : ≈ 22 M€ par point
d'érosion de 2025, soit 0,11 % des droits) et ≈ 0,1 pour les abattements
en ligne indirecte et les tranches (hypothèse). Les droits ont progressé de
4 % par an de 2014 à 2022 (Institut Montaigne), contre ≈ 2,6 % pour le PIB
nominal.

Impôt sur les sociétés. Le levier `impotSocietes` applique le plancher du
pilier 2 (directive (UE) 2022/2523 ; impôt complémentaire national de la loi
de finances pour 2024) : `tauxMinimumPilier2Pb` = 1 500 pour la part
`partISPilier2Pm` = 400 de l'IS acquittée par les groupes de plus de
750 M€ de chiffre d'affaires. Aucune part publiée pour ce seuil : les
grandes entreprises acquittent 33 % de l'IS brut (23,5 Md€ sur 71,2 Md€ en
2021, INSEE, Les entreprises en France, édition 2023, fiche 3.6) et une
partie des ETI appartient à des groupes de cette taille ; 40 % retenus
(fourchette 35 à 50 %). Le pilier 2 rapporte ≈ 0,5 Md€ en 2026 (Voies et
moyens, PLF 2026 ; audition du directeur de la législation fiscale,
commission des finances de l'Assemblée, 1er avril 2026).
`semiElasticiteAssietteISPm` = 10 : un point de taux effectif en moins
accroît les bénéfices déclarés en France de 1 % (transfert de bénéfices :
valeur de consensus 0,98, Beer, de Mooij et Liu, Journal of Economic
Surveys, 2020 ; 0,8 pour Heckemeyer et Overesch, 2017 ; 1,5 en fin de
période chez Beer et al.). Les effets réels (investissement, localisation)
porteraient la semi-élasticité totale vers 3 (de Mooij et Ederveen, 2008,
cité de seconde main) ; ils ne sont pas retenus ici, le moteur d'offre
traitant à part l'effet des prélèvements sur la croissance.

Outre-mer : `contenuImportOutreMerPm` = 500 (hypothèse). Aucune étude du
contenu importé de l'investissement dans les outre-mer n'a été trouvée ;
les importations y valent 31,5 % du PIB à La Réunion, 34,6 % en
Martinique, 38,9 % en Guadeloupe (INSEE, comptes 2025, calcul), mais les
investissements de réseaux (canalisations, pompes, membranes de
dessalement, panneaux solaires, batteries) sont presque entièrement
importés et les matériaux de construction y coûtent 35 à 39 % de plus
qu'en métropole (Autorité de la concurrence, avis 18-A-09). Contre 30 %
pour la demande nationale (`contenuImportDemandePm`).

Émissions : `baisseEmissionsSecteurPm`, baisse annuelle par secteur à
politiques constantes, calée sur le scénario « avec mesures existantes » du
ministère (326 Mt en 2030, scénario AME 2024 publié par le ministère de la
Transition écologique, mesures adoptées jusqu'au 31 décembre 2023) en partant des émissions de 2025 (Citepa, Secten
2026) et des baisses récentes par secteur (2024-2025 : transports −1,9 %,
bâtiments −2,1 %, agriculture −1,3 %, industrie −5,2 % et −3,6 % en
2023-2024, déchets −2,2 % ; énergie très variable). Identique dans les trois
variantes ; la baisse est supposée calée sur la croissance du scénario
central (`croissanceCalageEmissions`, hypothèse : l'AME 2024 ne publie pas
de variante de croissance) et sur le prix de référence du pétrole du modèle
(63 $ le baril, hypothèse : le prix retenu par l'AME n'a pas été retrouvé) ;
les baisses de 2023-2025 contiennent aussi la réponse retardée au choc
d'énergie de 2022 et la faiblesse de l'activité.

Émissions selon l'activité (`elasticitesEmissionsActivitePm`, loi
économique d'octobre 2026) : chaque année, les émissions d'un secteur
s'écartent de leur baisse tendancielle de `élasticité × écart de croissance
du PIB en volume du scénario au scénario central` (hors effets des mesures
et du moteur) ; l'écart se cumule, comme celui du PIB. Entre les variantes,
cet écart est surtout un écart de croissance potentielle, alors que les
sources mesurent surtout des élasticités de court terme (et, pour
l'industrie, à la production de la branche plutôt qu'au PIB) : les
valeurs retenues sont des hypothèses, probablement hautes, l'élasticité de
tendance de la France étant proche de zéro. Élasticités (pm) :
* industrie 800 : 0,79 dans l'année pour l'industrie manufacturière (Burke,
  Shahiduzzaman et Stern, Global Environmental Change, 2015) ; 0,46 à 1,47
  selon les branches par rapport à leur production (DG Trésor, Trésor-Éco
  n° 390, juin 2026) ; en 2009, −18 % de CO₂ industriel pour ≈ −16 % de
  production manufacturière (Citepa, Secten 2022 ; INSEE ; calcul) ;
* transports 600 : 0,72 des émissions routières au trafic (Trésor-Éco
  n° 390) ; trafic automobile au revenu 0,30 à court terme, 0,73 à long
  terme (Graham et Glaister, Transport Reviews, 2004) ; fret 0,8 à 1
  (hypothèse) ; valeur composite, hypothèse dans la fourchette de 0,2 à 0,9 ;
* bâtiments 230 : résidentiel 0,1 (hypothèse, le chauffage dépend du climat
  et du parc plus que de l'activité), tertiaire 0,5 (services : Burke et
  al., 2015), pondérés deux tiers - un tiers (hypothèse ; calcul) ;
* agriculture 200 : 0,24, non significatif (Burke et al., 2015) ; 0,19 à la
  production agricole (Trésor-Éco n° 390) ;
* production d'énergie 500 : hypothèse (0 à 1,5 ; dominée par le nucléaire
  et le prix du gaz) ;
* déchets 100 : hypothèse (0 à 0,2).
Contrôle : moyenne pondérée par les émissions de 2030 ≈ 0,46, sous les
élasticités cycliques agrégées de 0,5 à 0,8 (FMI, document de travail
18/56, 2018 : 0,6 pour les pays avancés ; Cohen, Jalles, Loungani et
Pizzuto, Journal of Macroeconomics, 2022 : 0,78 pour la France sur
1990-2018) : choix prudent, l'élasticité de tendance de la France étant
proche de zéro (même source). Relation symétrique (pas d'asymétrie
robuste entre récessions et expansions). Le prix du pétrole agit à part
(`Hypotheses.Energie`).

Emplois par secteur : `intensiteEmploiSecteurPm` = valeur ajoutée par
personne en emploi de l'ensemble (87,0 k€) / celle du secteur, 2025 (INSEE,
comptes nationaux base 2020 : valeur ajoutée publiée le 29 mai 2026, emploi
intérieur par branche, tableaux 6.208 et 6.209) : agriculture
87,0 / 59,8 = 1,46 ; industrie 87,0 / 115,4 = 0,75 ; construction
87,0 / 74,1 = 1,17 ; tertiaire marchand 87,0 / 96,8 = 0,90 ; tertiaire non
marchand 87,0 / 64,7 = 1,34. Une demande adressée à un secteur y crée autant
d'emplois de plus (ou de moins) que la loi d'Okun en donne pour une demande
moyenne, multipliés par cette intensité. Ordre de grandeur obtenu pour la
construction : ≈ 5 emplois par M€ de dépense (Okun, à court terme), contre
6,5 à 7 emplois directs et ≈ 16 emplois directs et indirects par M€ de
travaux dans les études de contenu en emplois (FNTP 2025 ; ADEME, marché
2019 ; CERC Nouvelle-Aquitaine 2018), qui comptent les emplois mobilisés
sans tenir compte de ceux qu'ils prennent ailleurs.

Stabilisateur automatique : `coutParChomeurEuros` = 10 000 € par chômeur
BIT supplémentaire. Les dépenses de chômage (allocations et aides de
l'Unédic, 37,2 Md€ en 2025, et allocation de solidarité) ont une élasticité de
−3,23 à l'écart de production (DG Trésor, document de travail 2025/2, août
2025, paramètres de la LPFP 2023-2027) : 1 % de PIB, soit 0,4 point de
chômage avec la loi d'Okun du modèle (127 000 chômeurs), fait varier ces
dépenses de 1,27 Md€, ≈ 10 000 € par chômeur (contre 14 200 € par
indemnisé en moyenne : 37,2 Md€ pour 2,624 millions d'allocataires en 2025,
Unédic, juin 2026 ; les indemnisés ne sont qu'une partie des chômeurs). Côté recettes, l'élasticité unitaire au PIB
du modèle donne une semi-élasticité de ≈ 0,52 ; avec le chômage, le solde
réagit de ≈ 0,57 point par point de PIB, la valeur retenue par la LPFP (0,63
pour la Commission européenne, Mourre et al., 2019).

Rémunérations publiques (levier `remunerationPublique`). Pour des agents
déjà en poste, une hausse de rémunération ne crée ni production ni emploi
public : elle coûte le brut (les cotisations employeur versées à des
administrations publiques, comme le CAS Pensions à 78,28 % du traitement,
se compensent dans le compte consolidé) ; une part revient aussitôt en
prélèvements, et le net soutient la consommation comme un transfert aux
ménages. Taux (2026) :
* CSG 9,2 % et CRDS 0,5 % sur 98,25 % du brut : `tauxCsgCrdsRemunerationPm`
  = 95 ;
* retenue pour pension de 11,10 % du traitement indiciaire :
  `tauxCotisationsTraitementPm` = 111 ;
* RAFP (5 % agent) plafonnée à 20 % du traitement : les enseignants
  (primes ≈ 20,8 % du traitement) et les policiers (≈ 39 %) y sont déjà ;
  `tauxCotisationsPrimesPm` = 0 ;
* heures supplémentaires : RAFP compensée par la réduction de cotisations
  (décret n° 2019-133), exonérées d'impôt sur le revenu jusqu'à 7 500 € par
  an (CGI, art. 81 quater) : `tauxCotisationsHeuresSupPm` = 0, impôt nul ;
* impôt sur le revenu : taux marginal de 11 % (couple d'enseignants avec
  deux enfants) à 30 % (célibataire), sur ≈ 77 % du brut après abattement
  de 10 % : `tauxIrRemunerationPm` = 150 (calcul, barème 2026).
Sources : taux de cotisations 2026 (CDG 33) ; fiche RAFP (COR, 2024) ;
contribution employeur au CAS Pensions (Service des retraites de l'État,
2025) ; barème de l'IR 2026.

Marché du travail. L'emploi ne suit plus mécaniquement la population
active : la tendance démographique est absorbée au taux d'emploi courant
(chômage tendanciel inchangé), mais les chocs d'offre de travail des
mesures entrent au taux d'emploi propre aux personnes concernées, puis
l'écart à l'emploi d'équilibre se résorbe progressivement. À long terme,
le taux de chômage ne dépend donc pas de la taille de la population active
(résultat empirique usuel) ; à court terme, il réagit à sa composition.
* `flexionPm` = 150 : une hausse de 10 000 chômeurs réduit la population
  active d'environ 1 500 personnes (INSEE, Note de conjoncture, juin 2017,
  éclairage « chômage ») ; d'où 1,15 emploi par chômeur en moins, et 13 %
  des emplois créés ou détruits qui passent par l'inactivité plutôt que
  par le chômage. La loi d'Okun et l'élasticité au SMIC restent exprimées
  en chômage ; les emplois s'en déduisent.
* `tauxEmploiSeniorsMaintenusPm` = 720 : report de 60 à 61 ans (réforme de
  2010), à 60 ans : +24 points d'activité et +17 points d'emploi pour les
  hommes, +22 et +16 pour les femmes (INSEE Analyses n° 30, 2017), soit
  ≈ 72 % des actifs supplémentaires en emploi.
* `tauxEmploiMigrantsPm` = 876 : taux de chômage des immigrés de 12,4 % en
  2025, contre 7,7 % pour l'ensemble (INSEE, enquête Emploi).
* `absorptionChomagePm` = 200 : 20 % de l'écart résorbé par an (demi-vie
  ≈ 3 ans). Simulation par l'OFCE d'une hausse durable de 2 % de la
  population active (modèle e-mod.fr, pour le HCFiPS ; COR, séance du
  27 janvier 2022, document 13, tableau 9) : écart de chômage de +1,7 point
  la première année, +0,7 la cinquième, nul la dixième, soit ≈ 20 % par an
  sur les cinq premières années (calcul). Fourchette : 11 % par an pour les
  chocs nationaux en Europe (Beyer et Smets, BCE, document de travail 1767,
  tableau 3 ; calcul) à une absorption presque immédiate dans la littérature
  sur l'immigration (Card, 1990 ; Hunt, 1992, pour les rapatriés d'Algérie)
  et dans le modèle comptable de la DG Trésor (COR, 26 mars 2026).

Incidence des prélèvements (`incidencePrelevementPm`). Chaque prélèvement
entre dans le canal du bloc de demande que lui donne `Impot.canal`
(ménages, taxes sur la consommation, impôt sur les sociétés), pondéré par
son incidence rapportée à celle de l'impôt de référence du canal (IR, TVA,
IS) : la réponse du canal elle-même vient des équations du bloc. Le moteur
applique en plus son intensité (`multiplicateurPrelevementsPm`, entière dans
les deux moteurs). Repères,
multiplicateurs à 2 à 5 ans pour un point de PIB : dépense publique
générique 1,0 puis 0,9 ; IR et CSG ≈ 0,8 ; TVA 0,66 puis 0,8 ; cotisations
salariés 0,75 (Mésange : DG Trésor pour le COR, 26 mars 2026, tableaux 1 à
3 ; Institut Avant-garde, 2025, tableau 7) ; IS 0,3 à 0,4 (OFCE, Policy
Brief 25, 2017) ; impôts sur le patrimoine et le foncier 0 à 0,2, très hauts
revenus 0,1 à 0,6 (Commission européenne, QUEST, in 't Veld 2012 ; CBO
2014). Propension à consommer le patrimoine financier : 0,115 pour la
moitié la moins dotée des ménages, 0,001 entre les 90e et 99e centiles
(Arrondel, Lamarche et Savignac, Économie et Statistique 472-473, 2014) ;
taux d'épargne de 27 % pour le quintile le plus aisé (INSEE Focus 338,
2024). D'où, relativement à l'effet moyen : TVA, IR, CSG 1,10 ;
cotisations 1,05 (prélèvement sans tranche : surtout des cotisations
salariales, les allègements patronaux passant par le coût du travail) ;
accises 1,00 (Mésange vert : un peu moins que la TVA) ; autres impôts 0,80
(impôts de production, taxes diverses) ; IS et taxe foncière 0,55 ;
successions et patrimoine 0,20. Les profils dans le temps (TVA et
cotisations montent avec les années, IR et CSG plus tôt) ne sont pas
modélisés ; la Banque de France (FR-BDF, 2020) trouve des effets de court
terme environ deux fois plus faibles.

Incidence des dépenses (`incidenceDepensePm`). Elle pondère l'impulsion
d'une dépense dans son canal du bloc de demande, rapportée à celle de la
fonction de référence du canal (`Canal.fonctionReference`) : le canal des
transferts étant calé sur les variantes de pensions, les retraites y entrent
à poids plein et la famille à 0,90 / 0,85 ; dans la consommation publique,
l'incidence s'applique telle quelle. L'investissement passe à poids plein par
son propre canal. Multiplicateurs à 2 à
5 ans pour un point de PIB : dépense générique 1,01 puis 0,88, baisse des
pensions 0,80 puis 0,80, investissement public 1,29 puis 0,8 à 1,1 (Mésange :
DG Trésor pour le COR, mars 2026 ; Bourgeois et Favetto, document de travail
de l'INSEE 2024-07) ; transferts généraux 0,2 à 0,5 et transferts ciblés sur
les ménages contraints 0,7 à 0,9 contre 0,8 à 1,0 pour les achats publics la
première année (Commission européenne, QUEST, in 't Veld 2012) ;
prestations bien en dessous de la consommation publique à court terme
(Banque de France, FR-BDF, 2020). D'où : retraites 0,85 ; famille,
chômage, solidarité 0,90 (transferts plus ciblés) ; affaires économiques
0,85 (subventions aux entreprises) ; défense 0,85 (contenu importé des
équipements, hypothèse) ; autres fonctions 1,00. La moyenne pondérée par
les dépenses de 2025 vaut ≈ 0,92.

Coût du travail par tranche de salaire (levier `allegementsCotisations`).
Emploi salarié privé ≈ 20 millions, dont ≈ 2/3 sous 1,6 SMIC, 89 % sous
2,5 SMIC, 98 % sous 3,5 SMIC (Bozio et Wasmer, rapport d'étape, mai 2024,
p. 27) : `emploiPriveTranche2025` = 13 340, 4 460 et 2 200 milliers. Coût du
travail (salaires bruts et cotisations patronales après allègements) :
salaire moyen de 1,3, 2,0 et 4,5 SMIC ; ≈ 367, 219 et 484 Md€ (calcul,
total ≈ 1 070 Md€, rémunérations du secteur privé des comptes nationaux).
Élasticités (valeur absolue) : 0,4 de 1 à 1,6 SMIC (−1 à −1,5 de 1 à
1,3 SMIC, ≈ −0,5 de 1,3 à 1,6 SMIC : Crépon et Desplatz 2001, Bunel et
L'Horty 2012, note CAE n° 49, 2019 ; Bozio et Wasmer, 2024, révisent ces
valeurs à la baisse), soit ≈ 14 500 emplois par Md€ (CAE : 23 000 à 57 000
pour 4 points de baisse au SMIC ; Groupe d'experts SMIC, 2025 : 17 000 à
25 000 en moyenne de tous les allègements ; Bozio et Wasmer : 7 500 à
10 800 dans leurs scénarios de hausse) ; 0,25 de 1,6 à 2,5 SMIC, soit
≈ 5 100 emplois par Md€ (bandeaux maladie et famille : 61 000 ETP pour
12,1 Md€, Bozio et Wasmer ; CICE : 5 500 à 9 000, France Stratégie 2020) ;
0,05 au-delà (effets « très faibles et peu significatifs », CAE). Pour une
hausse uniforme des cotisations patronales, on obtient ≈ 8 600 emplois par
Md€, contre 12 000 à 14 000 pour Mésange (calcul). Ajustement :
`ajustementCoutTravailPm` = 350, soit 35 % de l'effet à un an, 58 % à deux
ans, 88 % à cinq ans (Mésange 2026 : 23 %, 57 %, 87 %). Le PIB suit les
emplois pondérés par le coût du travail par emploi de la tranche (un emploi
au voisinage du SMIC coûte ≈ 0,5 fois la moyenne).

Accompagnement des demandeurs d'emploi (`chomeursEvitesParConseiller` = 5,
hypothèse prudente). Autriche, expérience aléatoire de 2015 : portefeuille
ramené de 250 à 100 demandeurs par conseiller, chômage plus court de
62 jours (−14 %), sorties vers l'emploi +4,8 points et vers l'inactivité
+3,0, gain net pour les finances publiques de 1 075 € par bénéficiaire hors
éviction (Böheim, Eppel et Mahringer, WIFO, 2022) : ≈ 26 années de chômage
évitées par conseiller et par an (calcul : 390 € par bénéficiaire, soit
≈ 150 bénéficiaires pour un conseiller). France, expérience de 2007 :
+9 à +10 points de sortie vers l'emploi à six mois avec 40 demandeurs par
conseiller contre 120 (Behaghel, Crépon et Gurgand, 2014). Allemagne :
490 conseillers de plus dans 14 agences, taux de chômage local −0,5 point
(Hainmueller, Hofmann, Krug et Wolf, 2016). Les effets d'éviction peuvent
annuler l'effet net (Crépon et al., QJE 2013 ; Dares-IPP, juin 2026, pour
l'accompagnement des bénéficiaires du RSA) : 26 réduit de 40 % (sorties
vers l'inactivité) et de moitié (éviction), d'où ≈ 5 à 8 ; 5 retenus.

IDH (`Modele/Idh.lean`). `inflationPb` = 175, 125 et 200 (hypothèses : la
croissance réelle vaut alors 1,25 %, 0,75 % et 2 %) : déflate le PIB pour le
RNB par habitant en volume. Santé publique : élasticité-prix du tabac 0,4
(Santé publique France) ; accises sur le tabac 13,2 Md€ (2024) ; prix
minimum de l'alcool de 0,50 € par verre : −22 % de décès par cancers liés à
l'alcool (Etilé et al., INCa-MILDECA, 2022), soit ≈ 3 500 décès, 8,5 % des
41 000 décès attribuables, 17 ‰ par tranche de 10 centimes (estimation
basse : les autres causes ne sont pas comptées ; en Écosse, −13,4 % des
décès entièrement dus à l'alcool, Lancet 2023) ; dépistage du cancer
colorectal : participation de 30,7 % (2024-2025), et de 34 % à 65 % de
participation −22 % de mortalité (Barré et al., 2020), soit 0,7 ‰ des décès
par point ; 21,5 millions de personnes de 50 à 74 ans invitées tous les deux
ans (≈ 10,75 millions par an) ; 70 € par dépistage supplémentaire
(hypothèse : test et analyse, coloscopie pour les tests positifs).
Scolarisation : ≈ 800 000 jeunes par génération (hypothèse) ; 13 300 € par
étudiant (DEPP, 2024) ; +1 point de scolarisation à chaque âge de 18 à
24 ans = +0,07 an de durée attendue de scolarisation (taux INSEE, rentrée
2023 ; la durée attendue est la somme des taux de scolarisation par âge).

C'est l'axe le plus disputé : multiplicateur, élasticités et fuite fiscale
déterminent l'essentiel des écarts entre programmes. D'où trois variantes
dès le départ, plutôt qu'une valeur « officielle ».
-/

namespace Hypotheses.Eco
open Modele

/-- Baisse tendancielle des émissions par secteur, pm par an (voir le
docstring du module). -/
def primeDette : Int := 2
def baisseEmissionsAME : ParSecteurGes :=
  { transports := 19, batiments := 21, agriculture := 10, industrie := 30, energie := 20, dechets := 22 }

/-- Élasticités des émissions à l'activité, pm (voir le docstring du
module). -/
def elasticitesEmissionsActivite : ParSecteurGes :=
  { transports := 600, batiments := 230, agriculture := 200, industrie := 800, energie := 500, dechets := 100 }

/-- Croissance potentielle du scénario central, pb, sur laquelle est calée
la baisse tendancielle des émissions (hypothèse). -/
def croissanceCalageEmissions : Int := 100

/-- Élasticités des prélèvements à l'écart de production, pm (voir le
docstring du module). -/
def elasticitesCycliques : ParImpot :=
  { tva := 1000, ir := 1860, csgCrds := 1860, cotisations := 630, impotSocietes := 2760,
    accisesEnergie := 1000, taxeFonciere := 1000, droitsMutation := 1000, mutationsOnereuses := 1000,
    patrimoine := 1000,
    autres := 1000 }

/-- Assiettes naturelles des prélèvements (voir le docstring du module). -/
def assiettesFrance : Assiettes :=
  { retardSalairesPm := 360, elasticiteMasseSalarialeCyclePm := 660,
    elasticiteIndependantsCyclePm := 1330, elasticiteCapitalCyclePm := 3520,
    csgActivitePm := 700, csgRemplacementPm := 182,
    irSalairesPm := 617, irPensionsPm := 257, irIndependantsPm := 48, progressiviteIrPm := 1680,
    elasticiteCotisationsPm := 950, elasticiteIsPm := 2030, partIsAnneeCourantePm := 450,
    partValeurAjouteePm := 516, partSalairesPm := 871,
    -- services marchands : 79,6 % de valeur ajoutée nationale (Insee Analyses n° 89, 2023, données 2019)
    partValeurAjouteeServicesPm := 796,
    croissancePhysiqueFoncierPb := 80, elasticiteCarburantsPm := 0 }

/-- Évolution tendancielle des dépenses à législation constante, en volume,
par fonction, pb par an (voir le docstring du module). -/
def volumeDepenses : ParFonction :=
  { retraites := 85, sante := 195, famille := 0, enseignement := 95,
    affairesEconomiques := 100, defense := 0, securiteJustice := 95,
    logementEnvironnement := 110, culture := 110, interets := 0, fonctionnement := 100,
    nonVentile := 0 }

/-- Part de chaque fonction revalorisée sur l'inflation de l'année
précédente, pm : pensions et prestations (voir le docstring du module). -/
def indexationDecalee : ParFonction :=
  ParFonction.depuis fun f => match f with
    | .retraites | .famille => 1000
    | _ => 0

/-- Croissance du PIB en volume, 2026-2030 : Banque de France (projections
de septembre 2026) pour 2026-2028, puis rattrapage de 0,2 point par an
au-dessus de la croissance potentielle en 2029 et 2030 (mission d'experts
sur la transparence des finances publiques, juillet 2026 : 1,2 % pour un
potentiel de 1 %). -/
def trajectoireVolume (potentiel : Int) : List Int := [40, 90, 120, potentiel + 20, potentiel + 20]

/-- Croissance potentielle, 2026-2030 : 1,2 % jusqu'en 2028 (plan
budgétaire et structurel de moyen terme d'octobre 2024, PLF 2027, mission
d'experts), puis la valeur de long terme de la variante. -/
def trajectoirePotentiel (potentiel : Int) : List Int := [120, 120, 120, potentiel, potentiel]

/-- Déflateur du PIB, 2026-2030 : ≈ 1,3 % en 2026 (Gouvernement, juillet
2026), puis croissance nominale moins croissance réelle de la mission
d'experts (2,7 %, 2,8 %, 2,6 %, 2,6 % ; 1,0 %, 1,2 %, 1,2 %, 1,2 %). -/
def trajectoireDeflateur : List Int := [130, 170, 160, 140, 140]

/-- Inflation des prix à la consommation, 2026-2028 : 2,3 % (INSEE, note de
conjoncture de septembre 2026), 1,8 % (PLF 2027), 1,6 % (Banque de France,
septembre 2026). -/
def trajectoireConso : List Int := [230, 180, 160]

/-- Taux de l'OAT à 10 ans, 2026-2027 : 3,8 % (hypothèse du PLF 2026 ; 3,7 %
mi-2026 selon la mission d'experts, 4,84 % le 7 octobre 2026), 4,3 %
(hypothèse du PLF 2027). Au-delà : valeur de long terme de la variante
(centrale : 4,4 %, taux à terme fin 2029 cité par la mission d'experts). -/
def trajectoireTaux : List Int := [380, 430]

/-- Revalorisation forfaitaire des valeurs locatives en 2026 : +0,8 %
(glissement de l'IPCH de novembre 2024 à novembre 2025, Banque des
Territoires, 28 novembre 2025). Au-delà : inflation de l'année précédente. -/
def revalorisationFonciere : List Int := [80]

/-- Taux des BTF à trois mois : ≈ 2,5 % à l'été 2026, 3,0 % fin 2026 et
au-delà (hypothèses du PLF 2027, PAP « Engagements financiers de l'État »,
octobre 2026 ; facilité de dépôt de la BCE relevée à 2,50 % en septembre
2026, BTF à trois mois à 2,79 % à l'adjudication du 2 novembre 2026). Au-delà
de 2026 : `tauxCourtPb` = 300. -/
def trajectoireTauxCourt : List Int := [250]
/-- Taux court de long terme, pb (PLF 2027 : 3,0 %, stable après 2027). -/
def tauxCourtLongTerme : Int := 300

/-- Plancher de la prime de risque, pb. Le Bund à dix ans est supposé rester
à 3,22 %, son niveau du 6 novembre 2026 (l'OAT était à 4,76 %, écart de
154 pb). Plancher de l'écart : 43 pb, moyenne arrondie de 2015 à 2023 (35 à
56 pb ; 49, 39 et 38 pb en 2017-2019, quand le déficit était sous 3 % ;
moyennes annuelles de l'OCDE ; 76 pb en 2025). Le taux marginal ne descend
donc pas sous 3,65 %. La trajectoire de taux contient un écart de 108 pb
en 2027 et de 118 pb ensuite au scénario central (78 et 158 pb dans les
variantes à 4,0 et 4,8 %) : la baisse due aux primes est au plus de 65 à
75 pb (35 et 115 pb), calcul. -/
def tauxBund : Int := 322
def ecartBundPlancher : Int := ((35 + 38 + 49 + 39 + 38 + 37 + 38 + 56 + 56) * 10 / 9 + 5) / 10

/-- Part du stock de dette refinancée chaque année, pm (voir le docstring du
module). -/
def renouvellementDette : Int := 109

/-! ### Échéancier de la dette existante fin 2025

Dette négociable de l'État à moyen et long terme fin 2025 : 2 542 Md€
(valeur indexée ; Agence France Trésor, bulletin mensuel n° 432). Ce qui en
arrive à échéance chaque année :

* 2026 : 167,5 Md€ de nominal et 2,3 Md€ de supplément d'indexation (PAP
  2027 « Engagements financiers de l'État », tableau de financement 2026
  révisé) ; recoupement : 211,0 Md€ de titres 2026 fin 2024 (bulletin
  n° 416) moins 43,5 Md€ rachetés en 2025 (programme de financement 2026).
  Coupon moyen : celui des six lignes 2026 fin 2024 (bulletin n° 416),
  1,25 % (calcul) ;
* 2027 à 2035 : échéancier agrégé de fin mai 2026 (bulletin n° 433). Les
  titres 2027, qui ne sont plus émis, sont repris tels quels ; ceux de 2028
  à 2035 sont ramenés au stock de fin 2025 en retirant à proportion les
  émissions de janvier à mai 2026 (hypothèse : réparties comme le stock),
  par le rapport (2 542 − 169,8 − 220,4) / (2 613 − 60,7 − 220,4)
  (calcul). Coupons moyens pondérés des lignes de chaque année au
  31 juillet 2026 (bulletin n° 435 ; coupon réel pour les titres indexés,
  dont l'indexation est comptée à part), sans les deux lignes créées en 2026
  (OAT 2,40 % 2029, 26,8 Md€ ; OAT 3,25 % février 2032, 18,4 Md€).

Le reste de la dette de Maastricht à moyen et long terme (administrations
de sécurité sociale, collectivités locales, autres dettes de l'État) s'amortit
de 8,1 % par an : 18,5 Md€ d'amortissements des collectivités et 27,6 Md€ des
administrations de sécurité sociale en 2025 (Fipeco-iFRAP, 15 octobre 2026)
pour 275,7 et 293,1 Md€ de dette (Insee, Insee Première n° 2106), calcul ;
à 1,86 %, coût d'emprunt de la CADES fin 2025 (Sénat, avis n° 747,
juin 2026 ; hypothèse : représentatif de ce reste).

Non vérifié par le rétro-test, faute d'échéanciers historiques : le
rétro-test garde le renouvellement uniforme. La dette à court terme de
l'Acoss (59,4 Md€ fin 2025, Sénat, avis n° 747) reste dans ce reste, amortie
à 8,1 % au lieu d'être renouvelée dans l'année au taux court (≈ 0,3 à
0,6 Md€ par an de charge en moins au début, ordre de grandeur), et les
27,6 Md€ des administrations de sécurité sociale comprennent l'amortissement
de la CADES, qui n'est pas une tombée brute.

Le coupon d'un titre sous-estime son taux en comptabilité nationale quand il
a été réémis sous le pair (la décote est comptée en intérêts) : les titres à
coupon faible réabondés en 2022-2024 portent un peu plus que leur coupon. Le
taux moyen du stock en comptabilité nationale (1,84 % début 2026 dans le
modèle) reste proche du coupon moyen de la dette de l'État (1,92 %, intérêts
des douze mois à venir sur le stock au 30 avril 2026, bulletin n° 432,
calcul). -/

/-- Dette de Maastricht à moyen et long terme fin 2025, M€ : 3 460 500 M€
(Insee) moins la part à court terme (`partDetteCourtTerme`). -/
def detteLongueDepart : Int := 3460500 - 3460500 * 57 / 1000
/-- Dette négociable de l'État à moyen et long terme fin 2025, M€ (AFT). -/
def detteEtatLongueDepart : Int := 2542000
/-- Échéances de la dette de l'État, M€, 2026 à 2035 (voir ci-dessus). -/
def echeancesEtatMeur : List Int :=
  let r := (2542000 - 169800 - 220400) * 1000000 / (2613000 - 60700 - 220400)
  [169800, 220400] ++ ([250300, 281200, 215500, 201200, 187400, 111100, 126600, 151500] : List Int).map
    fun m => m * r / 1000000
/-- Coupons moyens des titres de l'État arrivant à échéance, ppm (2026 :
lignes de fin 2024 ; 2029 et 2032 : sans les lignes créées en 2026). -/
def couponsEtatPpm : List Int :=
  let c2026 := (0 * 38918 + 1000 * 15320 + 35000 * 40247 + 5000 * 42089 + 25000 * 37677 + 2500 * 39347)
    / (38918 + 15320 + 40247 + 42089 + 37677 + 39347)
  let c2029 := (19700 * 289800 - 24000 * 26835) / (289800 - 26835)
  let c2032 := (23000 * 202700 - 32500 * 18430) / (202700 - 18430)
  [c2026, 17200, 10100, c2029, 17000, 12700, c2032, 32800, 18500, 37000]
/-- Amortissement annuel du reste de la dette, pm, et son taux, ppm. -/
def amortissementHorsEtat : Int := (18500 + 27600) * 1000 / (275700 + 293100)
def tauxHorsEtatPpm : Int := 18600
/-- Échéances du reste de la dette existante, M€ : amortissement constant
de son encours restant. -/
def echeancesHorsEtatMeur : List Int :=
  let h := detteLongueDepart - detteEtatLongueDepart
  (List.range 10).map fun k => h * amortissementHorsEtat * (1000 - amortissementHorsEtat) ^ k / 1000 ^ (k + 1)
/-- Échéancier de la dette existante fin 2025, ppm du stock (`echeancesDettePpm`). -/
def echeancesDette : List Int :=
  (echeancesEtatMeur.zip echeancesHorsEtatMeur).map fun (a, b) => (a + b) * 1000000 / detteLongueDepart
/-- Taux moyen de la dette existante qui arrive à échéance, ppm (`tauxEcheancesPpm`). -/
def tauxEcheances : List Int :=
  ((echeancesEtatMeur.zip echeancesHorsEtatMeur).zip couponsEtatPpm).map fun ((a, b), c) =>
    if a + b = 0 then 0 else (a * c + b * tauxHorsEtatPpm) / (a + b)

theorem echeancier_valeurs :
    detteLongueDepart = 3263252 ∧ amortissementHorsEtat = 81 ∧
    echeancesEtatMeur = [169800, 220400, 230968, 259481, 198856, 185660, 172926, 102519, 116822, 139799] ∧
    couponsEtatPpm = [12522, 17200, 10100, 19261, 17000, 12700, 22049, 32800, 18500, 37000] ∧
    echeancesDette = [69936, 83992, 85898, 93411, 73707, 68629, 63776, 41327, 44907, 51210] ∧
    tauxEcheances = [14077, 17474, 11596, 19162, 17277, 13708, 21465, 29394, 18520, 33992] ∧
    ecartBundPlancher = 43 := by
  decide

/-- Part de la dette à court terme (BTF), pm (voir le docstring du module). -/
def partDetteCourtTerme : Int := 57

/-- Part de la dette indexée sur l'inflation, pm (voir le docstring du
module). -/
def partDetteIndexee : Int := 89

/-- Fuite fiscale relative de chaque impôt, pm de la fuite moyenne du
scénario (`fuiteFiscalePm` : 20 % au centre, 35 % et 10 % dans les
variantes). Les recettes de ces impôts restent statiques ailleurs dans le
modèle ; la fuite ne s'applique qu'aux prélèvements nouveaux.

* Stock de patrimoine (1 500 : 30 % au centre, 52,5 % et 15 % dans les
  variantes). Un impôt annuel de 2 % perd 13 à 29 % de sa recette statique
  avec les élasticités au taux net de 7 à 17 retenues par Advani et Tarrant
  (Fiscal Studies 42, 2021) ; 16 à 20 % à huit ans et 45 à 60 % à trente
  ans au Danemark (Jakobsen, Jakobsen, Kleven, Zucman, QJE 2020, converti
  par Advani et Tarrant) ; 15 % d'évitement selon Saez et Zucman (2021) ;
  20 à 40 % de patrimoine non capté dans les scénarios de l'Assemblée
  nationale pour la taxe Zucman (rapport n° 930, février 2025) (calcul :
  1 − 0,98^ε).
* Transmissions (750 : 15 % au centre, 26 % et 7,5 %). Élasticité des
  transmissions au taux net de 0,1 à 0,25 en France et en Allemagne
  (Goupille-Lebret et Infante, JPubE 2018 et RFE 2016 ; Glogowsky, JPubE
  2021) : 4 à 15 % de la recette d'une hausse perdue (calcul) ; 31 % en
  Suède tant qu'un canal exonéré reste ouvert (Escobar, Ohlsson, Selin,
  IFAU 2019).
* Autres impôts : la fuite moyenne. -/
def fuiteRelative : ParImpot :=
  { ParImpot.uniforme 1000 with patrimoine := 1500, droitsMutation := 750 }

/-- Effet sur la demande de chaque prélèvement, relativement à l'effet moyen
d'un prélèvement fixé par le moteur, pm (voir le docstring du module). -/
def incidencePrelevements : ParImpot :=
  { tva := 1100, ir := 1100, csgCrds := 1100, cotisations := 1050, impotSocietes := 550,
    accisesEnergie := 1000, taxeFonciere := 550, droitsMutation := 200, mutationsOnereuses := 800,
    patrimoine := 200, autres := 800 }

-- moyenne pondérée par les prélèvements de 2025 : 970 ‰ (le moteur garde à
-- peu près son niveau moyen) ; les droits de mutation à titre onéreux,
-- comptés jusqu'ici dans les autres impôts, en gardent l'incidence
example : (221100 * 1100 + 103800 * 1100 + 167200 * 1100 + 446300 * 1050 + 58900 * 550
    + 30500 * 1000 + 44100 * 550 + 20700 * 200 + 17600 * 800 + 2300 * 200 + 215800 * 800)
    / (221100 + 103800 + 167200 + 446300 + 58900 + 30500 + 44100 + 20700 + 17600 + 2300 + 215800) = 969 := by decide

/-- Effet sur la demande d'une dépense selon sa fonction, relativement à la
consommation publique, pm (voir le docstring du module). -/
def incidenceDepenses : ParFonction :=
  { retraites := 850, sante := 1000, famille := 900, enseignement := 1000,
    affairesEconomiques := 850, defense := 850, securiteJustice := 1000,
    logementEnvironnement := 1000, culture := 1000, interets := 0, fonctionnement := 1000,
    nonVentile := 1000 }

/-- Éviction de l'investissement privé de transition, pm (champ
`evictionInvestissementPrivePm`) : part financée l'année même en renonçant à
d'autres dépenses privées. Bornes publiées : aucune éviction dans ThreeME
(taux d'intérêt réel fixe : évaluation macroéconomique de la SNBC 2, ADEME
et CGDD, février 2022) ni dans les scénarios courts de la Banque de France
(investissement privé financé par l'impôt, « pas d'éviction notable »,
billet n° 332, décembre 2023) ; à l'opposé, la DG Trésor retire 0,6 point de
PIB en 2030 pour le financement par baisse d'autres dépenses et le surcoût
technologique, contre +1,0 point pour l'effet des investissements (« Les
enjeux économiques de la transition vers la neutralité carbone », rapport
final, janvier 2025, p. 15). Valeurs (hypothèses dans ces bornes) : 200 pour
l'axe de croissance haute (multiplicateur fort, capacités disponibles), 400
pour l'axe central, 600 pour l'axe bas (borne de la DG Trésor). Effet sur la
productivité (−0,25 à −0,3 point par an vers 2030 si l'investissement de
décarbonation évince l'investissement de productivité ; Pisani-Ferry et
Mahfouz, France Stratégie, 2023, chap. 8) : non modélisé. -/
def evictionInvestissementPriveHaute : Int := 200
def evictionInvestissementPriveCentrale : Int := 400
def evictionInvestissementPriveBasse : Int := 600

/-- Écart de production et courbe de Phillips (champs
`ecartProductionDepartPb`, `pentePhillipsPm`, `semiElasticiteSoldePm`).
Écart de production de 2025 : ≈ −0,5 point de PIB potentiel (ordre de
grandeur des estimations du Gouvernement, rapport économique, social et
financier annexé au PLF 2026, et de la Commission européenne, prévisions
d'automne 2025 ; hypothèse). Pente de la courbe de Phillips : 0,1 point
d'inflation par point d'écart de production de l'année précédente, bas de
la fourchette des estimations pour la zone euro (0,1 à 0,3 : BCE,
Occasional Paper n° 181, « Low inflation in the euro area », 2017 ;
hypothèse, la France n'étant qu'une partie de la zone dont la BCE fixe le
taux). Semi-élasticité du solde public : 0,57 (loi de programmation des
finances publiques 2023-2027, rapport annexé ; Commission européenne, 0,6).
Le rétro-test garde l'inflation observée (pente nulle par défaut). -/
def ecartProductionDepart2025Pb : Int := -50
def pentePhillips : Int := 100
def semiElasticiteSolde : Int := 570

/-- Élasticité de l'emploi au coût du travail par tranche, pm (voir le
docstring du module). -/
def elasticitesCoutTravail : ParTranche := { bas := 400, intermediaire := 250, haut := 50 }

/-- Emploi salarié privé par tranche de salaire, milliers (voir le docstring
du module). -/
def emploiPriveTranche2025 : ParTranche := { bas := 13340, intermediaire := 4460, haut := 2200 }

/-- Coût du travail par tranche, M€ (voir le docstring du module). -/
def coutTravailTranche2025 : ParTranche := { bas := 367000, intermediaire := 219000, haut := 484000 }

/-- Intensité en emplois relative par secteur, 2025 (INSEE), pm. -/
def intensiteEmploi2025 : ParSecteur :=
  { agriculture := 1455, industrie := 754, construction := 1174,
    tertiaireMarchand := 899, tertiaireNonMarchand := 1345 }

/-- Revalorisation du SMIC, par point de hausse (référence des allègements
généraux indexée sur le SMIC ; le décret n° 2026-509 l'a gelée à 12,02 €/h
en juin 2026 : une hausse non suivie par la référence renchérirait bien
davantage le travail au SMIC et réduirait les allègements).
* Emplois, effet brut du coût du travail : −26 000 à terme (OFCE, Heyer et
  Plane, Revue de l'OFCE, hors-série 2012, tableau 2, diffusion comprise).
  Le modèle y ajoute les emplois que sauvent les allègements en plus
  (élasticité de la première tranche : ≈ +21 600 pour 1 490 M€) et l'effet de
  demande (≈ +1 600), soit ≈ −2 800 par point, proche du solde de l'OFCE
  (−2 300, avec +12 200 par les allègements et +11 500 par la demande).
  Variantes : −29 000 (Laroque et Salanié, Économie et Statistique n° 331,
  2000 : −290 000 à long terme pour +10 %) et −19 800 (élasticité de 0,9 au
  SMIC de la maquette MATIS de la DG Trésor, 2015, pour les 2,2 millions de
  salariés concernés au 1er novembre 2024, DARES, sans diffusion : calcul).
  La méta-analyse de la note du CAE n° 91 (2026) trouve une élasticité
  médiane de 0,13 au salaire minimum, sans allègements automatiques.
* Allègements : +1 490 M€ (Institut Montaigne, 2024 : 21,5 Md€ pour un SMIC à
  1 600 € nets, soit +14,4 %, tassement des salaires compris, avec la
  réduction générale actuelle ; calcul) ; 700 M€ pour l'OFCE en 2012 et
  400 M€ pour le Groupe d'experts sur le SMIC en 2017, avant la bascule du
  CICE en allègements.
* Décomposition du Groupe d'experts sur le SMIC (rapport 2017, citée par
  l'Institut Montaigne et la Fondation Jean-Jaurès), portée aux salaires de
  2025 (SMIC de 1 480,27 € en 2017 et 1 801,80 € en 2025, × 1,217 : calcul) :
  agents publics payés près du SMIC +260 M€ → 316 M€ (leurs retenues sont
  calculées par le levier) ; cotisations salariales, CSG comprise, +240 M€,
  et impôt sur le revenu +70 M€, pour l'ensemble des salariés, ramenés à la
  part du privé (640 M€ du revenu disponible sur 840 : calcul) et répartis
  entre cotisations (11,31 %) et CSG-CRDS (9,53 %) : cotisations +120 M€,
  CSG +102 M€, impôt sur le revenu +64 M€ ; prestations sociales (dont prime
  d'activité) −133 M€ ; revenu disponible des ménages du privé +640 M€. -/
def facteurSalaires2017 : Int := 180180 * 1000 / 148027
def prive (x : Int) : Int := x * facteurSalaires2017 / 1000 * 640 / 840
def smicParPoint : SmicParPoint :=
  { allegementsMeur := 1490, remunerationPubliqueMeur := 260 * facteurSalaires2017 / 1000,
    cotisationsMeur := prive 240 * 1131 / 2084, csgMeur := prive 240 - prive 240 * 1131 / 2084,
    impotRevenuMeur := prive 70, prestationsMeur := 110 * facteurSalaires2017 / 1000,
    revenuDisponiblePriveMeur := 640 }
def emploisParPointSmicCentral : Int := 26000
def emploisParPointSmicLaroqueSalanie : Int := 290000 / 10
def emploisParPointSmicMatis : Int := 2200000 * 900 / 1000 / 100

theorem smic_valeurs : facteurSalaires2017 = 1217 ∧ smicParPoint.remunerationPubliqueMeur = 316 ∧
    smicParPoint.cotisationsMeur = 120 ∧ smicParPoint.csgMeur = 102 ∧ smicParPoint.impotRevenuMeur = 64 ∧
    smicParPoint.prestationsMeur = 133 ∧ emploisParPointSmicLaroqueSalanie = 29000 ∧
    emploisParPointSmicMatis = 19800 := by decide

/-- Canal du capital public (moteurs qui l'activent : `Moteur.canalCapitalPm`).
Élasticité de la production au capital public : 0,12 à long terme pour le
capital installé par l'État, 0,083 à court terme (Bom et Ligthart, Journal of
Economic Surveys 28(5), 2014, méta-analyse de 578 estimations) ; 0,12 dans
QUEST (Commission européenne, Motyovszki, Pfeiffer et in 't Veld, Discussion
Paper 204, 2024, tableau 2.1) ; 0,17 pour les infrastructures de base dans les
simulations du FMI (WEO, octobre 2014, chap. 3). Retenu : 0,12. -/
def elasticitePibCapitalPublic : Int := 120

/-- Actifs fixes nets des administrations publiques fin 2024 : actifs non
financiers (2 821 Md€) moins terrains (903), autres actifs non produits (154)
et stocks (32), soit 1 732 Md€ (Insee Première n° 2081, novembre 2025), pour
un PIB 2024 de ≈ 2 935 Md€ (2 991,1 Md€ en 2025, +1,9 % en valeur : Insee
Première n° 2105, 2026) : 59 % du PIB (calcul). -/
def actifsFixesApu2024 : Int := 2821000 - 903000 - 154000 - 32000
def pib2024 : Int := 2935000
def stockCapitalPublicPib : Int := actifsFixesApu2024 * 1000 / pib2024

theorem stockCapitalPublic_eq : actifsFixesApu2024 = 1732000 ∧ stockCapitalPublicPib = 590 := by decide

/-- Dépréciation du capital public : 5 % par an (QUEST, ibid. ; OCDE, document
de travail n° 1351, 2016 : 4,2 à 5 %) ; 4,55 % pour les pays à haut revenu dans
la base du FMI (Investment and Capital Stock Dataset, manuel 2021) ; 6,5 %
implicites dans les comptes français, qui incluent les logiciels et la R&D
(consommation de capital fixe des APU de 113,1 Md€ en 2025, INSEE, tableau
1.112 ; calcul). À +1 point de PIB d'investissement public durable, le PIB
potentiel gagne ≈ 1,5 % en dix ans et ≈ 3,4 % à long terme pour une
croissance réelle de 1 % (calcul) ; le FMI
trouve +1,5 % après quatre ans (estimation empirique, demande comprise) et
≈ +2,5 % à long terme (modèle GIMF, avec éviction). Les modèles français
Mésange et FR-BDF n'ont pas de canal d'offre du capital public (INSEE,
document de travail 2024-07 ; Banque de France, document de travail 750). -/
def depreciationCapitalPublic : Int := 50

/-- Canal du capital des entreprises : coût d'usage du capital de
Hall-Jorgenson, facteur fiscal `(1 − τz)/(1 − τ)`, avec un taux d'IS combiné
de 25,83 % (statistiques de l'OCDE, 2023) et une valeur actualisée des
amortissements fiscaux de 74,2 % par euro investi (moyenne pondérée de la
France, Tax Foundation, 2025) : un point de taux en moins abaisse le coût
d'usage de 0,42 % (calcul ; OFCE, Revue n° 152, 2017 : −1,1 % pour la baisse
de 2019). Élasticité de long terme du capital au coût d'usage : 0,44 (Mésange,
DG Trésor et INSEE, 2017 ; 0,34 dans le modèle de l'OFCE ; 0,31 à 0,38 sur
données d'entreprises françaises : Chatelain et Tiomo, Banque de France,
2002 ; Chatelain et al., BCE, 2001). Part du capital 0,35 (complément de
`elasticitePibHeuresPm`) : à emploi donné, `dY/Y = −α σ/(1 − α) dc/c`, soit
+0,10 % de PIB à long terme par point de taux en moins (calcul ;
fourchette de 0 à 0,25 % selon l'élasticité retenue ; une méta-analyse,
Gechert et Heimberger, European Economic Review, 2022, ne rejette pas un
effet nul une fois corrigé le biais de publication ; repère : +0,17 % de PIB
à long terme pour 0,4 point de PIB d'IS en moins financé par la TVA, QUEST,
Commission européenne, Discussion Paper 077, 2018). -/
def tauxISCombinePb : Int := 2583
def amortissementsActualisesPm : Int := 742
def facteurFiscalPpm (tauxPb : Int) : Int :=
  (10000 * 1000 - tauxPb * amortissementsActualisesPm) * 1000000 / ((10000 - tauxPb) * 1000)
def baisseCoutUsagePointISPpm : Int :=
  (facteurFiscalPpm tauxISCombinePb - facteurFiscalPpm (tauxISCombinePb - 100)) * 1000000
    / facteurFiscalPpm tauxISCombinePb
def elasticiteCapitalCoutUsagePm : Int := 440
def partCapitalPm : Int := 350
def effetPibLongTermePointIS : Int :=
  partCapitalPm * elasticiteCapitalCoutUsagePm * baisseCoutUsagePointISPpm / ((1000 - partCapitalPm) * 1000)

theorem capitalPrive_eq : baisseCoutUsagePointISPpm = 4245 ∧ effetPibLongTermePointIS = 1005 := by decide

/-- Accumulation du capital des entreprises : 9 % de l'écart comblé chaque
année (demi-vie ≈ 7 ans, calcul), soit 38 % de l'effet à cinq ans et 61 % à
dix ans ; Mésange, baisse de cotisations employeurs d'un point de PIB : 41 %
de l'effet de long terme à cinq ans et 60 % à dix ans (DG Trésor et INSEE,
2017, diapositive 41 ; calcul) ; Barro et Furman (Brookings Papers, 2018) :
5 % par an. -/
def ajustementCapitalPrive : Int := 90

/-! ### Bloc de demande (`Modele/Demande.lean`)

Sources : [M17] Bardaji et al., « Le modèle macroéconométrique Mésange :
réestimation et nouveautés », Cahiers de la DG Trésor n° 2017-04 (= Insee
G2017/04), mai 2017, lu dans le dépôt public InseeFr/Mesange ;
[IP2105] Insee Première n° 2105, « Les comptes de la Nation en 2025 », mai
2026 ; [IP1756] Insee Première n° 1756, juin 2019 (contenus en
importations, 2015) ; [EMOD] Chauvin et al., « Le modèle France de l'OFCE –
e-mod.fr », Revue de l'OFCE n° 81, 2002 ; [FRBDF26] Dubois et al.,
FR-BDF réestimé, Banque de France WP 1044, mai 2026 ; [FRBDF20] Aldama et
Ouvrard, WP 750, 2020 (variantes) ; [BDF18] Sicsic, Bloc-notes Éco n° 64,
Banque de France, 2018 ; [MV24] Bourgeois et Favetto, DT Insee 2024-07
(variantes Mésange).

Parts dans le PIB 2025 (2 992 Md€) [IP2105] : consommation des ménages
1 545,9 Md€ → 516 ‰ ; revenu disponible brut = consommation / (1 − taux
d'épargne de 17,9 %) → 629 ‰ (calcul) ; FBCF des entreprises non
financières 364,8 Md€ → 121 ‰ ; exportations 1 009,4 → 337 ‰ ; importations
1 023,8 → 342 ‰ ; excédent brut d'exploitation des sociétés non financières
497,5 Md€ → 166 ‰. Salaires nets : salaires et traitements bruts 1 157,2 Md€
(compte des ménages 2025, voir `Reference`) moins la CSG-CRDS (9,5 %) et une
retenue salariale de 11,1 % (taux de la retenue pour pension, pris pour
l'ensemble des salariés : hypothèse) → 307 ‰ (calcul). Prestations indexées :
retraites et famille-chômage-solidarité de la référence (410 + 293 Md€) →
234 ‰ (calcul). Coût du travail des employeurs privés : 1 070 Md€
(`coutTravailTranche2025`) → 357 ‰ (calcul).

Équations : forme à correction d'erreur annuelle (voir le module), dont les
coefficients reproduisent les profils d'élasticités publiés (réponse à 1, 2
et 5 ans d'un choc permanent ; calcul des forces de rappel annuelles) :
* consommation : élasticité au revenu disponible réel 0,46 / 0,85 / 0,98 / 1
  [M17 p. 33] → 460 ‰ et rappel 720 ‰ ; chômage : +1 point → −0,38 % puis
  −0,18 % puis ≈ 0 [M17 p. 31-33] → 380 ‰, persistance 470 ‰ ;
* investissement des entreprises : élasticité à la valeur ajoutée 1,79 /
  2,00 / 1,36 (5 ans) / 1 [M17 p. 44] → 1 790 ‰, 438 ‰ sur la variation
  retardée, rappel 289 ‰ ; coût d'usage du capital −0,04 / −0,15 / −0,34 /
  −0,44 [M17 p. 43-44] → 40 ‰, rappel 275 ‰, long terme 440 ‰ ; le coût
  d'usage varie de la variation de l'impôt rapportée à l'excédent brut des
  SNF (rémunération du capital : calcul) ;
* exportations : demande mondiale 0,80 / 0,87 / 0,96 / 1 [M17 p. 78] → 800 ‰,
  rappel 350 ‰ ; compétitivité-prix 0,27 la première année et force de
  rappel du profil Mésange (0,27 / 0,47) [M17 p. 78], élasticité de long
  terme 0,6 [EMOD p. 282-283] → 270 ‰, 435 ‰, 600 ‰ ; prix d'exportation :
  prix de valeur ajoutée pour la part non importée (contenu en importations
  des exportations 34 % [IP1756]) ;
* importations : demande pondérée par les contenus en importations 1,25 /
  1,18 / 1,04 / 1 [M17 p. 84] → 1 250 ‰, rappel 280 ‰ ; prix relatifs −0,06 /
  −0,20 / −0,32 / −0,35 [M17 p. 84] → 60 ‰, 480 ‰, 350 ‰ ; contenus en
  importations [IP1756] : consommation des ménages 18,7 %, investissement
  32 %, exportations 34 %, consommation publique 9,4 % (celui des services
  consommés par les ménages : la consommation publique est surtout faite de
  services ; hypothèse) ;
* emploi : réponse à la production marchande calée sur les variantes
  (Mésange, investissement public : +0,34 % puis +0,71 % d'emploi salarié
  pour +1,28 % et +1,29 % de PIB [MV24, tableau 2] ; FR-BDF, consommation
  publique : +0,25 % puis +0,52 % pour +0,97 % et +1,02 % [FRBDF20,
  tableau 8]) → 260 ‰ la première année, rappel 365 ‰ (calcul) ; élasticité
  de long terme 1 [M17 p. 40] ;
* salaires : indexation sur les prix à la consommation 0,59 / 1,08 / 1,05 / 1
  [M17 p. 64] → 590 ‰, 310 ‰ sur l'inflation retardée, rappel 430 ‰ vers la
  part intérieure des prix à la consommation, soit 81,3 % de l'écart du prix
  de valeur ajoutée : les prix des importations suivent les prix mondiaux,
  exogènes dans le bloc. Mésange indexe la cible de long terme sur le prix
  de valeur ajoutée [M17 p. 57] ; la cible retenue (hypothèse) laisse la
  part salariale baisser de 18,7 % de la hausse des prix intérieurs, ce qui
  modère la boucle prix-salaires (avec la cible de Mésange, les prix montent
  davantage et l'effet d'une dépense sur le PIB disparaît avant dix ans) ;
  chômage : +1 point → −0,61 % la première
  année, −1,98 % à long terme [M17 p. 62-64], force de rappel de −0,05 à
  −0,08 par trimestre [M17 p. 62], soit ≈ 250 ‰ par an (calcul) ;
* prix de valeur ajoutée : coût salarial unitaire, transmission rapide
  [EMOD p. 269 : 0,28 au trimestre, délai moyen 0,22 an] à lente
  [FRBDF26 : persistance 0,20], retenue à 600 ‰ la première année et
  400 ‰ de rappel, qui reproduisent les prix de la variante de
  consommation publique de FR-BDF (+0,19 / +0,60 / +0,94 / +1,21 %
  [FRBDF20, tableau 8]) ; tension 0,09 par point d'écart de production
  [FRBDF26] ; part importée des prix à la consommation 18,7 % [IP1756] ;
* coût du travail : les marges absorbent d'abord une baisse ; transmission
  aux prix calée sur la variante Mésange de baisse des cotisations
  employeurs (−0,45 / −0,83 / −1,03 / −1,38 % [séminaire Fourgeaud, 15 mars
  2017, diapositive 41]) → 200 ‰ la première année, rappel 50 ‰ ; les
  emplois créés par la substitution du travail au capital sont ceux du
  levier (élasticités par tranche) ; le bloc y ajoute ceux de la demande
  (baisse des prix, compétitivité) ;
* taxes sur la consommation : transmission aux prix calée pour qu'une
  hausse de TVA d'un point de PIB relève les prix à la consommation de
  1,48 % la première année [M17 p. 112-113] → 564 ‰ (calcul) ;
* capital des entreprises : dépréciation 9,3 % par an [BDF18] ; capital /
  valeur ajoutée des SNF 1,9 [BDF18] et valeur ajoutée des SNF = EBE /
  taux de marge (497,5 / 32,2 % [IP2105]) → capital / PIB 981 ‰ (calcul) ;
  élasticité du PIB potentiel au capital des entreprises = rémunération du
  capital / PIB = EBE des SNF / PIB → 166 ‰ (fonction de production à
  rendements constants : calcul).

Chômage d'équilibre : celui de la trajectoire de référence du scénario (le
bloc calcule des écarts à cette trajectoire, comme les variantes des
modèles publics). La Banque de France estime que le chômage structurel a
baissé d'environ 1,3 point de 2015 à 2025 (Bulletin n° 264/1, mai-juin
2026) sans publier de niveau ; aucune estimation récente du NAWRU n'a pu
être sourcée.

Les multiplicateurs qui résultent de ces équations (par canal, à 1, 2, 3, 5
et 10 ans) sont comparés aux variantes publiées dans `Tests/Demande.lean`. -/
def parametresDemande : ParametresDemande where
  partConsoPm := 1545900 * 1000 / 2992000
  partRevenuPm := 1545900 * 1000000 / (821 * 2992000)
  partInvestPm := 364800 * 1000 / 2992000
  partExportPm := 1009400 * 1000 / 2992000
  partImportPm := 1023800 * 1000 / 2992000
  partSalairesNetsPm := 1157200 * (1000 - 95 - 111) / 2992000
  partPrestationsPm := (410000 + 293000) * 1000 / 2992000
  partRemunerationsPm := coutTravailTranche2025.total * 1000 / 2992000
  partEbePm := 497500 * 1000 / 2992000
  consoCourtPm := 460
  consoRappelPm := 720
  consoChomagePm := 380
  consoChomagePersistancePm := 470
  investCourtPm := 1790
  investRetardPm := 438
  investRappelPm := 289
  coutCapitalCourtPm := 40
  coutCapitalRappelPm := 275
  coutCapitalLongPm := 440
  exportDemandeCourtPm := 800
  exportDemandeRappelPm := 350
  exportPrixCourtPm := 270
  exportPrixRappelPm := 435
  exportPrixLongPm := 600
  importDemandeCourtPm := 1250
  importDemandeRappelPm := 280
  importPrixCourtPm := 60
  importPrixRappelPm := 480
  importPrixLongPm := 350
  contenuImportConsoPm := 187
  contenuImportInvestPm := 320
  contenuImportExportPm := 340
  contenuImportConsoPubliquePm := 94
  emploiCourtPm := 260
  emploiRappelPm := 365
  salairesPrixCourtPm := 590
  salairesPrixRetardPm := 310
  salairesPrixRappelPm := 430
  salairesChomageCourtPm := 610
  salairesChomageRappelPm := 250
  salairesChomageLongPm := 1980
  prixCoutCourtPm := 600
  prixCoutRappelPm := 400
  prixTensionPm := 90
  partImporteePrixConsoPm := 187
  partImporteePrixExportPm := 340
  coutTravailCourtPm := 200
  coutTravailRappelPm := 50
  transmissionTaxesPm := 564
  depreciationCapitalPm := 93
  capitalPibPm := 19 * 497500 * 100000 / (322 * 2992000)
  elasticitePibCapitalPm := 497500 * 1000 / 2992000
  multiplicateurReferencePm := 800

theorem parametresDemande_parts :
    parametresDemande.partConsoPm = 516 ∧ parametresDemande.partRevenuPm = 629 ∧
    parametresDemande.partInvestPm = 121 ∧ parametresDemande.partExportPm = 337 ∧
    parametresDemande.partImportPm = 342 ∧ parametresDemande.partSalairesNetsPm = 307 ∧
    parametresDemande.partPrestationsPm = 234 ∧ parametresDemande.partRemunerationsPm = 357 ∧
    parametresDemande.partEbePm = 166 ∧ parametresDemande.capitalPibPm = 981 := by decide

def centrale : Economie where
  id := "eco-centrale"
  description := "Prévisions publiées jusqu'en 2030, puis croissance potentielle de 1 %, inflation de 1,75 %, OAT à 4,4 %"
  croissancePotentiellePb := 100
  croissanceVolumeAnneesPb := trajectoireVolume 100
  croissancePotentielleAnneesPb := trajectoirePotentiel 100
  inflationAnneesPb := trajectoireDeflateur
  inflationConsoAnneesPb := trajectoireConso
  tauxMarginalAnneesPb := trajectoireTaux
  tauxCourtAnneesPb := trajectoireTauxCourt
  revalorisationFoncierAnneesPb := revalorisationFonciere
  elasticiteCycliquePm := elasticitesCycliques
  assiettes := assiettesFrance
  croissanceDepensesVolumePb := volumeDepenses
  indexationDecaleePm := indexationDecalee
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 800
  fuiteFiscalePm := 200
  fuiteFiscaleRelativePm := fuiteRelative
  incidencePrelevementPm := incidencePrelevements
  incidenceDepensePm := incidenceDepenses
  demande := parametresDemande
  evictionInvestissementPrivePm := evictionInvestissementPriveCentrale
  pentePhillipsPm := pentePhillips
  ecartProductionDepartPb := ecartProductionDepart2025Pb
  semiElasticiteSoldePm := semiElasticiteSolde
  inflationPb := 175
  elasticitePrixTabacPm := 400
  accisesTabacMeur := 13200
  baisseDecesAlcoolPar10CentimesPm := 17
  participationDepistagePm := 307
  baisseDecesColorectalParPointPm := 7
  populationDepistageMilliers := 10750
  coutParDepistageEuros := 70
  jeunesParGenerationMilliers := 800
  depenseParEtudiantEuros := 13300
  emploisParPointSmic := emploisParPointSmicCentral
  smicParPoint := smicParPoint
  economieParMoisRetraite := 650
  tauxMarginalPb := 440
  partDetteCourtTermePm := partDetteCourtTerme
  tauxCourtPb := tauxCourtLongTerme
  renouvellementDettePm := renouvellementDette
  partDetteIndexeePm := partDetteIndexee
  primeDeficitPb := 25
  primeDettePb := primeDette
  tauxBundPb := tauxBund
  ecartBundPlancherPb := ecartBundPlancher
  echeancesDettePpm := echeancesDette
  tauxEcheancesPpm := tauxEcheances
  excesPatrimoineParDecesPb := 40
  elasticiteDroitsSuccessionPm := 1200
  partISPilier2Pm := 400
  tauxMinimumPilier2Pb := 1500
  semiElasticiteAssietteISPm := 10
  contenuImportOutreMerPm := 500
  intensiteEmploiSecteurPm := intensiteEmploi2025
  coutParChomeurEuros := 10000
  tauxCsgCrdsRemunerationPm := 95
  tauxCotisationsTraitementPm := 111
  tauxCotisationsPrimesPm := 0
  tauxCotisationsHeuresSupPm := 0
  tauxIrRemunerationPm := 150
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 0
  coutParAccidentEuros := 24000
  joursPerdusParAccident := 70
  letaliteAccidentsPdm := 13
  tauxAccidentsUEPdm := 110
  baisseEmissionsSecteurPm := baisseEmissionsAME
  elasticitesEmissionsActivitePm := elasticitesEmissionsActivite
  croissanceCalageEmissionsAnneesPb := trajectoireVolume croissanceCalageEmissions
  croissanceCalageEmissionsPb := croissanceCalageEmissions
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  elasticiteEmploiCoutTravailPm := elasticitesCoutTravail
  emploiPriveTrancheMilliers := emploiPriveTranche2025
  coutTravailTrancheMeur := coutTravailTranche2025
  ajustementCoutTravailPm := 350
  elasticitePibCapitalPublicPm := elasticitePibCapitalPublic
  stockCapitalPublicPibPm := stockCapitalPublicPib
  depreciationCapitalPublicPm := depreciationCapitalPublic
  effetPibLongTermePointISPpm := effetPibLongTermePointIS
  ajustementCapitalPrivePm := ajustementCapitalPrive
  chomeursEvitesParConseiller := 5
  sources := [
    "Banque de France, projections macroéconomiques de septembre 2026",
    "Mission d'experts indépendants sur la transparence des finances publiques, rapport du 15 juillet 2026 (tableaux 3 à 6, p. 6-8)",
    "PLF 2026 et PLF 2027 (hypothèses de taux, d'inflation et de croissance potentielle) ; avis du HCFP du 1er octobre 2026",
    "INSEE, note de conjoncture de septembre 2026 (inflation 2026)",
    "COR, rapport annuel de juin 2026, tableau 2.1 (masse des pensions en volume)",
    "DG Trésor, document de travail 2025/2 (élasticités des prélèvements et des dépenses de chômage au cycle)",
    "Agence France Trésor, bulletin mensuel n° 435 et rapport annuel 2025 (structure de la dette)"]

def croissanceBasse : Economie where
  id := "eco-basse"
  description := "Prévisions publiées jusqu'en 2030, puis croissance potentielle de 0,6 %, inflation de 1,25 %, OAT à 4,8 % ; multiplicateur faible, fuite fiscale forte"
  croissancePotentiellePb := 60
  croissanceVolumeAnneesPb := trajectoireVolume 60
  croissancePotentielleAnneesPb := trajectoirePotentiel 60
  inflationAnneesPb := trajectoireDeflateur
  inflationConsoAnneesPb := trajectoireConso
  tauxMarginalAnneesPb := trajectoireTaux
  tauxCourtAnneesPb := trajectoireTauxCourt
  revalorisationFoncierAnneesPb := revalorisationFonciere
  elasticiteCycliquePm := elasticitesCycliques
  assiettes := assiettesFrance
  croissanceDepensesVolumePb := volumeDepenses
  indexationDecaleePm := indexationDecalee
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 500
  fuiteFiscalePm := 350
  fuiteFiscaleRelativePm := fuiteRelative
  incidencePrelevementPm := incidencePrelevements
  incidenceDepensePm := incidenceDepenses
  demande := parametresDemande
  evictionInvestissementPrivePm := evictionInvestissementPriveBasse
  pentePhillipsPm := pentePhillips
  ecartProductionDepartPb := ecartProductionDepart2025Pb
  semiElasticiteSoldePm := semiElasticiteSolde
  inflationPb := 125
  elasticitePrixTabacPm := 400
  accisesTabacMeur := 13200
  baisseDecesAlcoolPar10CentimesPm := 17
  participationDepistagePm := 307
  baisseDecesColorectalParPointPm := 7
  populationDepistageMilliers := 10750
  coutParDepistageEuros := 70
  jeunesParGenerationMilliers := 800
  depenseParEtudiantEuros := 13300
  emploisParPointSmic := emploisParPointSmicLaroqueSalanie
  smicParPoint := smicParPoint
  economieParMoisRetraite := 650
  tauxMarginalPb := 480
  partDetteCourtTermePm := partDetteCourtTerme
  tauxCourtPb := tauxCourtLongTerme
  renouvellementDettePm := renouvellementDette
  partDetteIndexeePm := partDetteIndexee
  primeDeficitPb := 25
  primeDettePb := primeDette
  tauxBundPb := tauxBund
  ecartBundPlancherPb := ecartBundPlancher
  echeancesDettePpm := echeancesDette
  tauxEcheancesPpm := tauxEcheances
  excesPatrimoineParDecesPb := 40
  elasticiteDroitsSuccessionPm := 1200
  partISPilier2Pm := 400
  tauxMinimumPilier2Pb := 1500
  semiElasticiteAssietteISPm := 10
  contenuImportOutreMerPm := 500
  intensiteEmploiSecteurPm := intensiteEmploi2025
  coutParChomeurEuros := 10000
  tauxCsgCrdsRemunerationPm := 95
  tauxCotisationsTraitementPm := 111
  tauxCotisationsPrimesPm := 0
  tauxCotisationsHeuresSupPm := 0
  tauxIrRemunerationPm := 150
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 0
  coutParAccidentEuros := 24000
  joursPerdusParAccident := 70
  letaliteAccidentsPdm := 13
  tauxAccidentsUEPdm := 110
  baisseEmissionsSecteurPm := baisseEmissionsAME
  elasticitesEmissionsActivitePm := elasticitesEmissionsActivite
  croissanceCalageEmissionsAnneesPb := trajectoireVolume croissanceCalageEmissions
  croissanceCalageEmissionsPb := croissanceCalageEmissions
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  elasticiteEmploiCoutTravailPm := elasticitesCoutTravail
  emploiPriveTrancheMilliers := emploiPriveTranche2025
  coutTravailTrancheMeur := coutTravailTranche2025
  ajustementCoutTravailPm := 350
  elasticitePibCapitalPublicPm := elasticitePibCapitalPublic
  stockCapitalPublicPibPm := stockCapitalPublicPib
  depreciationCapitalPublicPm := depreciationCapitalPublic
  effetPibLongTermePointISPpm := effetPibLongTermePointIS
  ajustementCapitalPrivePm := ajustementCapitalPrive
  chomeursEvitesParConseiller := 5
  sources := [
    "Banque de France, projections macroéconomiques de septembre 2026",
    "Mission d'experts indépendants sur la transparence des finances publiques, rapport du 15 juillet 2026 (tableaux 3 à 6, p. 6-8)",
    "PLF 2026 et PLF 2027 (hypothèses de taux, d'inflation et de croissance potentielle) ; avis du HCFP du 1er octobre 2026",
    "INSEE, note de conjoncture de septembre 2026 (inflation 2026)",
    "COR, rapport annuel de juin 2026, tableau 2.1 (masse des pensions en volume)",
    "DG Trésor, document de travail 2025/2 (élasticités des prélèvements et des dépenses de chômage au cycle)",
    "Agence France Trésor, bulletin mensuel n° 435 et rapport annuel 2025 (structure de la dette)"]

def croissanceHaute : Economie where
  id := "eco-haute"
  description := "Prévisions publiées jusqu'en 2030, puis croissance potentielle de 1,5 %, inflation de 2 %, OAT à 4 % ; multiplicateur élevé, fuite fiscale faible"
  croissancePotentiellePb := 150
  croissanceVolumeAnneesPb := trajectoireVolume 150
  croissancePotentielleAnneesPb := trajectoirePotentiel 150
  inflationAnneesPb := trajectoireDeflateur
  inflationConsoAnneesPb := trajectoireConso
  tauxMarginalAnneesPb := trajectoireTaux
  tauxCourtAnneesPb := trajectoireTauxCourt
  revalorisationFoncierAnneesPb := revalorisationFonciere
  elasticiteCycliquePm := elasticitesCycliques
  assiettes := assiettesFrance
  croissanceDepensesVolumePb := volumeDepenses
  indexationDecaleePm := indexationDecalee
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 1100
  fuiteFiscalePm := 100
  fuiteFiscaleRelativePm := fuiteRelative
  incidencePrelevementPm := incidencePrelevements
  incidenceDepensePm := incidenceDepenses
  demande := parametresDemande
  evictionInvestissementPrivePm := evictionInvestissementPriveHaute
  pentePhillipsPm := pentePhillips
  ecartProductionDepartPb := ecartProductionDepart2025Pb
  semiElasticiteSoldePm := semiElasticiteSolde
  inflationPb := 200
  elasticitePrixTabacPm := 400
  accisesTabacMeur := 13200
  baisseDecesAlcoolPar10CentimesPm := 17
  participationDepistagePm := 307
  baisseDecesColorectalParPointPm := 7
  populationDepistageMilliers := 10750
  coutParDepistageEuros := 70
  jeunesParGenerationMilliers := 800
  depenseParEtudiantEuros := 13300
  emploisParPointSmic := emploisParPointSmicMatis
  smicParPoint := smicParPoint
  economieParMoisRetraite := 650
  tauxMarginalPb := 400
  partDetteCourtTermePm := partDetteCourtTerme
  tauxCourtPb := tauxCourtLongTerme
  renouvellementDettePm := renouvellementDette
  partDetteIndexeePm := partDetteIndexee
  primeDeficitPb := 25
  primeDettePb := primeDette
  tauxBundPb := tauxBund
  ecartBundPlancherPb := ecartBundPlancher
  echeancesDettePpm := echeancesDette
  tauxEcheancesPpm := tauxEcheances
  excesPatrimoineParDecesPb := 40
  elasticiteDroitsSuccessionPm := 1200
  partISPilier2Pm := 400
  tauxMinimumPilier2Pb := 1500
  semiElasticiteAssietteISPm := 10
  contenuImportOutreMerPm := 500
  intensiteEmploiSecteurPm := intensiteEmploi2025
  coutParChomeurEuros := 10000
  tauxCsgCrdsRemunerationPm := 95
  tauxCotisationsTraitementPm := 111
  tauxCotisationsPrimesPm := 0
  tauxCotisationsHeuresSupPm := 0
  tauxIrRemunerationPm := 150
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 0
  coutParAccidentEuros := 24000
  joursPerdusParAccident := 70
  letaliteAccidentsPdm := 13
  tauxAccidentsUEPdm := 110
  baisseEmissionsSecteurPm := baisseEmissionsAME
  elasticitesEmissionsActivitePm := elasticitesEmissionsActivite
  croissanceCalageEmissionsAnneesPb := trajectoireVolume croissanceCalageEmissions
  croissanceCalageEmissionsPb := croissanceCalageEmissions
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  elasticiteEmploiCoutTravailPm := elasticitesCoutTravail
  emploiPriveTrancheMilliers := emploiPriveTranche2025
  coutTravailTrancheMeur := coutTravailTranche2025
  ajustementCoutTravailPm := 350
  elasticitePibCapitalPublicPm := elasticitePibCapitalPublic
  stockCapitalPublicPibPm := stockCapitalPublicPib
  depreciationCapitalPublicPm := depreciationCapitalPublic
  effetPibLongTermePointISPpm := effetPibLongTermePointIS
  ajustementCapitalPrivePm := ajustementCapitalPrive
  chomeursEvitesParConseiller := 5
  sources := [
    "Banque de France, projections macroéconomiques de septembre 2026",
    "Mission d'experts indépendants sur la transparence des finances publiques, rapport du 15 juillet 2026 (tableaux 3 à 6, p. 6-8)",
    "PLF 2026 et PLF 2027 (hypothèses de taux, d'inflation et de croissance potentielle) ; avis du HCFP du 1er octobre 2026",
    "INSEE, note de conjoncture de septembre 2026 (inflation 2026)",
    "COR, rapport annuel de juin 2026, tableau 2.1 (masse des pensions en volume)",
    "DG Trésor, document de travail 2025/2 (élasticités des prélèvements et des dépenses de chômage au cycle)",
    "Agence France Trésor, bulletin mensuel n° 435 et rapport annuel 2025 (structure de la dette)"]

def toutes : List Economie := [centrale, croissanceBasse, croissanceHaute]

end Hypotheses.Eco
