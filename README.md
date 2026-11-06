# Programmes vérifiés

[![CI](https://github.com/TOrientationD/Programmes_Lean/actions/workflows/ci.yml/badge.svg)](https://github.com/TOrientationD/Programmes_Lean/actions/workflows/ci.yml)

Des programmes politiques formalisés en Lean 4, évalués sous un jeu
d'hypothèses partagées, avec une CI qui vérifie à chaque PR :

* que chaque programme tient les **engagements** qu'il revendique (preuves
  vérifiées par le noyau Lean) ;
* ce que devient **chaque propriété partagée**, pour **chaque programme**,
  sous **chaque scénario** (matrice d'évaluation, diff commenté sur la PR).

> ⚠️ **État actuel.** Le modèle économique est un modèle agrégé, en
> entiers : chaque paramètre cite sa source ou est marqué « hypothèse », et
> le rétro-test le confronte aux comptes de 2018 à 2025. Quinze programmes y
> sont transcrits, dont deux exemples fictifs. Ce n'est pas une
> microsimulation : les barèmes et les ménages types n'y figurent pas.

## Principe

```
                 Hypotheses/                     Proprietes/
   démographie × économie × pétrole × droit   déficit, dette, chômage, émissions…
           │  (produit cartésien)                     │
           ▼                                          ▼
   ┌───────────────┐    Modele/ (commun)    ┌───────────────────┐
   │  scénarios    │──► projection ◄── leviers ◄── Programmes/X │
   └───────────────┘         │                └───────────────────┘
                             ▼
     matrice  programme × moteur × scénario × propriété   (lake exe rapport)
     engagements prouvés                          (Engagements.lean)
```

Trois choix structurants :

1. **Les programmes sont de la donnée.** Une mesure est une liste de
   `Levier` (dépense, prélèvement, revalorisation du SMIC, âge légal…) avec
   des montants. Leur effet est calculé par le modèle commun, sous les
   hypothèses du scénario. Un programme ne peut donc pas apporter ses propres
   élasticités : tous sont évalués avec les mêmes règles.
2. **Les hypothèses sont des axes croisés.** Ajouter une valeur sur un axe
   (une nouvelle projection démographique, un nouveau cadre juridique) ajoute
   automatiquement les scénarios correspondants pour tous les programmes.
3. **Tout est entier et décidable.** Montants en M€, taux en points de base,
   coefficients en pour mille (`Modele/Unites.lean`). Chaque propriété se
   décide par `decide +kernel` : pas de Mathlib, pas de flottants. La CI
   complète, rejeu des preuves et tests compris, tient en un quart d'heure environ.

Le **PIB se calcule par la demande** (`Modele/Demande.lean`) : chaque
mesure passe par un canal (consommation publique, emplois publics,
investissement, transferts et prélèvements sur les ménages, TVA et accises,
coût du travail, impôt sur les sociétés, échanges extérieurs), et le bloc
de demande calcule chaque année l'écart au tendanciel de la consommation
(revenu disponible réel, chômage), de l'investissement des entreprises
(accélérateur, coût du capital), des exportations (demande mondiale,
compétitivité-prix) et des importations (contenus en importations, prix
relatifs) ; PIB = consommation + investissement + dépense publique +
exportations − importations. L'emploi suit la production marchande avec
retard ; les salaires suivent les prix et baissent quand le chômage monte ;
les prix de valeur ajoutée suivent le coût salarial unitaire, les marges
absorbant d'abord une baisse du coût du travail. Le multiplicateur n'est
donc plus un paramètre : il diffère selon le canal et l'horizon (délais de
diffusion) et s'estompe quand les prix montent. Les coefficients
reprennent les profils d'élasticités de Mésange (DG Trésor 2017/04), avec
e-mod.fr, FR-BDF et l'Insee ; `Tests/Demande.lean` vérifie que les
multiplicateurs qui en résultent, à 1, 2, 3 et 5 ans, restent dans la
fourchette des variantes publiées par Mésange, FR-BDF et e-mod.fr, et
`Tests/RetroDemande.lean` confronte chaque équation aux années 2017-2025
(hors échantillon). Le chômage d'équilibre est celui de la trajectoire de
référence du scénario ; le capital qu'accumule l'investissement des
entreprises relève le PIB potentiel selon une fonction de production
(élasticité égale à la part de l'excédent des sociétés dans le PIB), ce qui
réduit l'écart de production qui tire les prix. Les prix du bloc entrent
l'année suivante dans le PIB nominal, les assiettes des prélèvements, les
dépenses (indexées ou non) et l'indice des prix de l'IDH ; les échéanciers
votés restent en euros courants. Les économies d'énergie des mesures (voitures
électriques, pompes à chaleur, rénovations, sobriété) sont dépensées
ailleurs par les ménages et les entreprises (importations et taxes en
moins) ; celles des bâtiments publics (hôpitaux, écoles, collèges, lycées,
universités, administrations : ≈ 42 % du gaz et du fioul du tertiaire,
`Hypotheses.Energie.chauffagePublic`) réduisent la dépense publique. Limites connues : les emplois publics
créés n'entrent ni dans le revenu des ménages ni dans le chômage du bloc,
et les dépenses prévues par la référence nourrissent aussi le bloc au
tendanciel (voir `Modele/Demande.lean`).

Un **moteur** (`Hypotheses/Moteurs.lean`) est un jeu de règles
d'interprétation des leviers : « demande » (économies et dépenses
symétriques, pas d'effet d'offre) et « offre » (économies à
demi-multiplicateur, effet des prélèvements obligatoires sur la croissance,
canal du capital, résorption supplémentaire des effets de demande). Le
canal du capital relie le PIB potentiel à l'investissement public des
mesures (stock de capital public déprécié de 5 % par an, élasticité de la
production de 0,12 : un point de PIB d'investissement durable ajoute ≈ 1,5 %
de PIB en dix ans), au taux d'IS (coût du capital des entreprises : +0,10 %
de PIB à long terme par point de taux en moins, atteint à 61 % en dix ans)
et au capital accumulé par l'investissement des entreprises du bloc de
demande ; il joue entièrement au moteur d'offre, pour moitié au moteur
« Exemple équilibre », pas au moteur de demande. Sous les moteurs d'offre
et d'équilibre, les effets de demande s'estompent en outre vers une part
durable : le moteur d'offre en garde 20 % à long terme et résorbe le reste
de 5 % par an ; le moteur d'équilibre en garde la moitié et résorbe l'autre
de 3 % par an (repères : Mésange, ThreeME, DG Trésor, Trésor-Éco n° 394,
juillet 2026). L'impulsion d'un prélèvement est pondérée par son incidence
relativement à l'impôt de référence de son canal (IR, CSG, cotisations au
niveau de l'impôt sur le revenu ; successions et patrimoine bien en
dessous). Les allègements de cotisations patronales passent par le coût
du travail, tranche de salaire par tranche de salaire. Le SMIC est indexé
sur les prix ; une hausse au-delà renchérit le travail à son voisinage
(13 800 emplois de moins à terme par point, OFCE), accroît les allègements
(≈ 1,5 Md€ par point avec la réduction générale actuelle), la rémunération
des agents publics et les prélèvements sur les salaires du privé, et
soutient la consommation. L'effet d'une
dépense dépend de sa nature (canal et incidence de sa fonction). Les postes publics créés ou supprimés, quand un
programme les chiffre en postes (leviers `creationPostes` et
`suppressionPostes`), comptent un pour un dans l'emploi ; l'emploi privé ne
répond qu'à l'écart entre la variation du PIB et la production publique
ajoutée ou retirée. Le modèle calcule chaque année l'indice de
développement humain (formule du PNUD).

Le déficit se calcule année par année : la croissance suit les prévisions
publiées puis la croissance potentielle ; chaque prélèvement suit son
assiette naturelle (masse salariale pour les cotisations, la CSG et l'IR,
dont le barème est revalorisé de l'inflation passée ; consommation des
ménages pour la TVA ; bénéfice fiscal et règles d'acomptes pour l'IS ;
volume de carburants pour les accises, fixées en euros par litre ; valeurs
locatives revalorisées par la loi pour la taxe foncière ; valeur des
transactions immobilières pour les droits de mutation) ; les dépenses primaires
suivent les prix (pensions et prestations revalorisées sur l'inflation de
l'année écoulée) et une tendance en volume par fonction (COR, mission
d'experts de juillet 2026) ; l'indemnisation du chômage suit, dans
l'année, les chômeurs ; la charge d'intérêts suit la structure de la dette
(titres à court terme renouvelés au taux court ; dette à moyen et long
terme de fin 2025 remboursée selon l'échéancier réel de l'Agence France
Trésor, chaque tombée cessant de porter son coupon pour être réémise au taux
de l'OAT ; dette émise ensuite refinancée à 10,9 % par an ; indexation des
titres indexés sur l'inflation ; le taux d'émission porte une prime de
risque de 25 pb par point de déficit au-dessus du déficit de départ et de
2 pb par point de dette/PIB au-dessus de la dette de départ : Laubach
2009, CBO, FMI, Commission européenne 2021 ; la baisse qu'elle autorise est
bornée : le taux ne descend pas sous celui du Bund, 3,22 %, plus 43 pb,
moyenne de l'écart de 2015 à 2023), et la synthèse la répartit entre ses
bénéficiaires (Banque de France, non-résidents, banques, assurances, fonds,
autres résidents : `Hypotheses/DetentionDette.lean`, affichage seulement) ;
la dette de fin d'année est celle de
début d'année plus le déficit de l'année, mesures comprises. Tous les programmes sont
évalués sous tous les moteurs ; un engagement précise le sien. Toute
personne autorisée peut **ajouter son moteur** dans `Moteurs/<Nom>/`
(même contrôle d'accès que les programmes : fichier `PROPRIETAIRES`),
l'enregistrer dans `Moteurs.lean`, et obtenir une **synthèse
personnalisée** centrée dessus (`scripts/synthese_pdf.py --moteur <Nom>
[--programmes A,B]`, ou le workflow « Synthèse PDF » avec ses paramètres ;
une PR qui touche `Moteurs/` produit l'artefact automatiquement). Une
propriété peut viser une année précise (« déficit sous 3 % en 2035 ») ou
l'horizon du scénario.

**Électricité et sols.** Les capacités de chaque filière croissent des
installations de la programmation pluriannuelle de l'énergie (PPE3, décret
du 12 février 2026) et de celles des mesures ; la production en découle aux
facteurs de charge observés par RTE, sur la capacité moyenne de l'année ;
la consommation suit la trajectoire « décarbonation lente » du bilan
prévisionnel 2025 de RTE, plus les voitures électriques du parc. La
production que ni la consommation ni le solde exportateur maximal
(≈ 100 TWh, RTE) n'absorbent est retirée au nucléaire (modulation) ou,
si une mesure donne la priorité au nucléaire (`prioriteNucleaire`),
écrêtée sur le solaire puis l'éolien (électricité non produite, donc non
payée : hypothèse, les contrats de soutien récents ne rémunérant pas les
heures de prix négatifs ; la part renouvelable baisse d'autant). Le
modèle en déduit chaque année un coût d'équilibre de l'électricité des
entreprises : coût complet du mix (nucléaire existant à coût annuel fixe,
61 €/MWh pour 365 TWh, CRE ; renouvelables et cycles à gaz à leurs coûts
complets, le gaz indexé sur le Brent du scénario, le CO₂ de 75 à 120 €/t),
plus marge de fourniture, réseau et taxes (≈ 121 €/MWh au départ, contre
165 observés en 2024 et 149 en 2025, encore portés par les contrats de la
crise : c'est un coût d'équilibre, pas un prix de marché). La synthèse le
compare aux prix observés en 2024 dans les autres pays (UE-27, Allemagne,
États-Unis…). Facteur d'implantation : l'emploi manufacturier répond à
l'écart entre ce coût et celui du mix de départ aux mêmes prix du gaz et
du CO₂ (élasticité −0,10, atteinte au tiers par an ; la production gagnée
est exportée) — plus de renouvelables qui forcent la modulation du
nucléaire à coût fixe renchérissent le mix et font partir des usines, et
inversement. La
consommation d'espaces naturels, agricoles et forestiers (ENAF) suit
l'enveloppe du zéro artificialisation nette (ZAN : la moitié de 2011-2021
sur 2021-2031, données du Cerema) : ce qu'il en reste fin 2025 permet
5 117 ha par an, contre 15 119 ha consommés en 2024 ; un programme qui
abroge le ZAN revient au rythme de 2011-2021 (22 672 ha par an). Sous le
ZAN, les surfaces des mesures (lignes nouvelles, prisons) s'imputent sur
l'enveloppe et évincent les autres usages ; sans ZAN, elles s'ajoutent.
Une mesure peut aussi exempter des surfaces de l'enveloppe (zones
industrielles) : elles s'ajoutent alors sans éviction et sortent du
décompte. L'emprise des installations nouvelles de solaire au sol et
d'éolien terrestre est comptée à part (`Hypotheses/Electricite.lean`,
`Hypotheses/Sols.lean`). Les pompes à chaleur des mesures remplacent des
chaudières au fioul ou au gaz (chaleur, rendement et coefficient de
performance mesuré par l'ADEME) : fioul et gaz économisés, électricité
consommée, coûts de réseau de gaz évités (`Hypotheses/Energie.lean`).

**Émissions et aides à l'électrique.** Les émissions de chaque secteur
baissent à leur rythme tendanciel (scénario « avec mesures existantes » du
ministère), corrigé de deux lois économiques : l'activité (élasticité au
PIB en volume de 0,8 pour l'industrie, 0,6 pour les transports, 0,1 à 0,5
ailleurs, appliquée à l'écart de croissance au scénario central) et le prix
du pétrole (un Brent cher fait baisser les émissions des voitures et du
fioul selon les élasticités-prix de long terme, atteintes à 40 % par an).
Les propriétés climatiques peuvent donc tenir dans une partie seulement des
36 scénarios. Une aide à l'achat d'une voiture électrique de `A` k€ ne rend
électriques que `1 − e^(−β A)` des achats qui ne l'auraient pas été, moins
la part des ventes déjà électrique (aubaine) : β = 0,055 par k€ pour une
aide générale (≈ 13 % des voitures aidées par une prime de 4 000 € en 2027),
0,115 pour les ménages modestes (leasing social) ; une obligation compte
chaque voiture (`Hypotheses/Energie.lean`, `Hypotheses/Economie.lean`).

**Transition écologique : PIB et emploi.** Une tonne de CO₂ évitée n'est
pas neutre pour l'activité. Le levier `transitionEcologique` compte
l'énergie fossile qui n'est plus achetée : importations évitées (la
dépense se reporte sur des biens produits en France), accises et TVA
perdues (rendues aux ménages et aux entreprises, pondérées comme une baisse
de prélèvement), accise et TVA de l'électricité consommée à la place ; un
biocarburant à prix et taxes inchangés ne retire que la part non importée
du substitut. La production qui disparaît (raffinerie, cheptel) retire
autant de PIB et d'emplois dans son secteur, la part reprise par des
importations s'ajoutant aux importations. Les investissements sont décrits
par technologie, publics (`investissementTransition`) ou privés
déclenchés par une mesure (`investissementPriveTransition`), avec la part
importée propre à chacune (véhicules électriques 75 %, HVO 80 %, éolien
60 %, biogazole 55 %, pompes à chaleur 45 %, biogaz 35 %, solaire 34 %,
rénovation et réseaux de chaleur 20 %, bioéthanol 10 % ; ADEME, IEA-PVPS,
IRENA, FranceAgriMer, Insee) et son secteur d'emploi (construction,
industrie, agriculture). Deux pertes d'effet sont déduites : l'équipement
fossile qui n'est plus acheté (une pompe à chaleur offerte remplace parfois
une chaudière en fin de vie : 13 % de la dépense) et l'éviction de
l'investissement privé par son financement (20, 40 ou 60 % selon l'axe
économique, entre l'absence d'éviction de ThreeME et de la Banque de France
et la borne de la DG Trésor). Repères publiés : pour la DG Trésor, les
investissements de la transition ajoutent +1,0 point de PIB en 2030, leur
financement et leur surcoût en retirent 0,6 (rapport final sur les enjeux
économiques de la neutralité carbone, janvier 2025) ; le ministère attend
+200 000 à +550 000 emplois nets en 2030 pour l'ensemble de la stratégie
nationale bas-carbone (SGPE). Non modélisé : l'effet sur la productivité
(−0,25 à −0,3 point par an vers 2030 si l'investissement de décarbonation
évince l'investissement productif ; Pisani-Ferry et Mahfouz, 2023).

**Lois à respecter.** Outre les règles budgétaires françaises et
européennes et les objectifs climatiques, chaque programme est vérifié
contre la loi de programmation militaire actualisée (loi n° 2026-791 : la
dépense de défense ne passe pas sous sa trajectoire), les capacités 2030
de la programmation pluriannuelle de l'énergie (décret n° 2026-76) et
l'objectif de 40 % d'électricité renouvelable en 2030 (code de l'énergie,
art. L.100-4) (`Proprietes/Lois.lean`). Un programme peut proposer de
modifier une loi : la propriété signale alors l'écart.

**Constitution et lois organiques.** Cinq garde-fous traduisent des normes
de rang constitutionnel ou organique (`Hypotheses/Constitution.lean`,
`Proprietes/Constitution.lean`, préfixe `constitution-`, page à part de la
synthèse) : la Constitution n'a pas à être révisée (art. 89 ; une mesure qui
l'exige le déclare par le levier `revisionConstitution`) ; le taux marginal
maximal d'imposition d'un revenu reste sous 70 % (DDHC, art. 13 ; Conseil
constitutionnel : 75 % censuré en 2012, 64,5 % admis en 2013 ; 55,4 % au
départ pour un salaire, relevé par les mesures qui le déclarent, levier
`tauxMarginalSommet`) ; la dépense de retraite en volume par personne de
65 ans et plus et la dépense d'enseignement par habitant ne baissent pas
de plus de 5 % (Préambule de 1946, al. 11 et 13) ; le déficit structurel
est au plus de 0,4 % du PIB dix ans après le départ (objectif de moyen
terme : loi organique n° 2012-1403, TSCG art. 3). Le déficit structurel
corrige le déficit de l'écart de production, que le modèle suit désormais :
écart de départ (≈ −0,5 point en 2025), trajectoire du scénario (croissance
en volume moins potentielle) et effets de demande des mesures encore
présents ; les chocs d'offre (heures, productivité, capital) déplacent le
potentiel, pas l'écart. L'écart de production nourrit l'inflation par une
courbe de Phillips (0,1 point d'inflation par point d'écart de l'année
précédente, bas des estimations pour la zone euro ; nulle dans le
rétro-test, où l'inflation est observée) : une consolidation qui creuse
l'activité fait baisser les prix, donc le PIB nominal, et renchérit la dette
en termes réels. L'espérance de vie de l'IDH répond à la dépense de santé
réelle par habitant (élasticité 0,04 à l'écart à sa trajectoire
tendancielle : Gallet et Doucouliagos 2017, OCDE 2017), si bien qu'une
norme de dépense qui freine la santé coûte des années de vie — un
programme peut en exempter la santé en partie (`plafondNormeSante`) ; les
années de vie perdues par décès de chaque cause suivie (tabac, alcool,
cancer colorectal, arrêt cardiaque) sont l'espérance de vie résiduelle de
la table de mortalité de l'Insee à l'âge médian au décès de la cause
(`Hypotheses/Demographie.lean`). Une propriété constitutionnelle perdue ne vaut pas
inconstitutionnalité : elle signale ce que le Conseil constitutionnel ou le
Haut Conseil des finances publiques examineraient. Non retenus faute de
grandeur dans le modèle : l'autonomie financière des collectivités
(art. 72-2), la sincérité des comptes (art. 47-2), l'égalité devant
l'impôt hors caractère confiscatoire.

## Engagements, contrats et évaluation

| | Engagements | Contrats de mesure | Évaluation |
|---|---|---|---|
| Qui les définit | chaque programme (`engagements := …`) | chaque mesure (`contrats := …`) | le dépôt (`Proprietes.toutes` × `Hypotheses.tous`) |
| Nature | « sous tel scénario, telle propriété macro tient » | énoncé universel sur le dispositif : « pour toute commune… » | constat, sur toute la matrice |
| Vérification | calcul dans le noyau (`decide +kernel`) | preuve Lean, fournie avec le contrat | `lake exe rapport` |
| Si c'est faux | **la CI échoue** | **la CI échoue**, Lean désigne le contrat | la cellule passe à ❌ dans le rapport |

Exemple de contrats : la mesure R-07 d'`ExempleRelance` (amende SRU
automatique selon la part de logements sociaux manquants) prouve, pour
toute commune, que l'amende est nulle si l'objectif est atteint, plafonnée,
jamais augmentée par la construction d'un logement social, jamais
inférieure au prélèvement actuel et jamais supérieure au maximum qu'un
préfet peut infliger aujourd'hui. Le sous-modèle communal est dans
`Modele/Logement.lean`, le panel de communes (fictives) dans
`Hypotheses/Communes.lean`.

Un prélèvement nouveau perd une part de son rendement statique par les
comportements (fuite fiscale : 20 % au scénario central, 35 % et 10 % dans
les variantes). Cette fuite dépend de l'impôt (`fuiteFiscaleRelativePm`,
`Hypotheses/Economie.lean`) : une fois et demie la fuite moyenne pour les
impôts sur le stock de patrimoine (exil, sous-déclaration : 30 % au
centre), trois quarts pour les transmissions (15 %), d'après les études
danoises, suédoises, suisses, colombiennes et françaises citées dans le
code.

Les mesures de justice ont leur propre sous-modèle (`Modele/Justice.lean`,
données sourcées dans `Hypotheses/Justice.lean`) : un contentieux a un flux
d'affaires nouvelles, un stock et une capacité de jugement ; les renforts
(équipes de magistrats et de greffiers) et le facteur de traitement
(affaires par agent) relèvent la capacité ; le délai d'écoulement du stock
(12 × stock / affaires terminées) suit année par année. Le coût suit le
personnel (coût moyen d'un ETPT) et les locaux (investissement par poste,
fonctionnement immobilier). Un programme peut prouver que ses délais
baissent : voir `justice_delais_en_baisse` dans le programme Orientation D.

Un engagement peut porter sur **tous** les scénarios
(`tous.map fun H => ⟨H, propriété⟩`) : il est alors vérifié contre toute
hypothèse ajoutée plus tard par n'importe qui.

### Cohérence interne

`Modele/Coherence.lean` repère, dans chaque programme, les paires de
mesures qui se contredisent, à partir de leurs leviers seuls (ni
projection ni hypothèse) :

* **valeurs** : deux mesures fixent un même réglage à deux valeurs
  différentes (taux de l'IS, SMIC visé, âge légal visé, régime ZAN, prix
  minimum de l'alcool, frein au déficit…) ;
* **sens** : deux mesures déplacent un même réglage dans des sens opposés
  (durée du travail, âge légal, durée de cotisation, SMIC, solde
  migratoire, prix du tabac) — une mesure qui passe aux 39 heures et une
  autre qui revient aux 35 heures.

Les étapes d'une même mesure (`O-117`, `O-117b`) ne sont pas comparées
entre elles. `Programme.coherent` vaut `false` tant qu'un conflit n'est pas
arbitré : l'auteur peut déclarer une paire voulue, avec sa raison
(`arbitrages := [⟨"O-44", "O-209", "…"⟩]`) ; elle reste affichée dans le
rapport et les PDF. Le verdict est informatif, comme la matrice : il ne
bloque pas la CI. Deux mesures contradictoires modélisées par des leviers
différents échappent à la vérification. Les tests sont dans
`Tests/Coherence.lean`.

## Arborescence

| Chemin | Rôle |
|---|---|
| `Modele/` | état, unités, axes d'hypothèses, moteurs, leviers, projection, propriétés, programmes (types), sous-modèles SRU, automobile, attribution, rétro-test |
| `Hypotheses/` | valeurs des axes et produit cartésien `Hypotheses.tous`, panel de communes, comptes publics observés 2017-2025, détenteurs de la dette publique |
| `Tests/` | tests du modèle commun : comptabilité, mécanismes, assiettes des prélèvements, rétro-test, tendanciel |
| `Proprietes/` | propriétés partagées, registre `Proprietes.toutes` |
| `Programmes/<Nom>/` | un dossier par programme : `Programme.lean` + `README.md` + `PROPRIETAIRES` |
| `Moteurs/<Nom>/`, `Moteurs.lean` | moteurs contribués (`Moteur.lean` + `PROPRIETAIRES`) et leur registre |
| `Programmes.lean` | registre `Programmes.tous` |
| `Engagements.lean` | preuve que tous les engagements sont tenus (par blocs pour les programmes aux engagements nombreux, afin de tenir dans la mémoire du noyau) |
| `Rapport.lean` | exécutable `rapport` : JSON + Markdown, export `--synthese` |
| `Audit.lean` | refuse `sorry`, `native_decide` et tout `axiom` |
| `scripts/` | garde-fou syntaxique, diff de rapports, contrôle du registre, synthèse PDF, programme complet en PDF |
| `.github/` | CI, commentaire de PR, CODEOWNERS, modèles d'issue et de PR |

## En local

```sh
# elan installe automatiquement la version de Lean fixée dans lean-toolchain
curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh

scripts/ci_locale.sh                     # toutes les étapes ci-dessous, dans l'ordre de la CI

python3 -I scripts/garde_fou.py          # avant de compiler du code non relu
python3 -I scripts/verifier_registre.py
lake build                               # tout compiler, engagements compris
lake env lean Audit.lean                 # audit des axiomes
lake build rapport && .lake/build/bin/rapport   # écrit rapport.json et rapport.md (interprété : lake env lean --run Rapport.lean, 5 fois plus lent)
                                         # (ou `lake exe rapport`, compilé, même sortie)
```

## Synthèse PDF

`scripts/synthese_pdf.py` met en page, sur dix ans et pour chaque
programme, les trajectoires calculées par le modèle commun : PIB, déficit
et dette publics, chômage, population active, emploi par secteur, impôts
et taxes majeurs (TVA, IR, CSG-CRDS, cotisations, IS, accise sur les
énergies, taxe foncière, autres), taux de prélèvements obligatoires,
sensibilité au prix du pétrole (50, 63, 100 $) et à la natalité (1,40,
1,56, 1,80 enfant par femme), électricité produite et consommée (GW
moyens, capacités par filière), surfaces consommées (ENAF depuis 2021 face
à l'enveloppe du ZAN, par destination, emprise énergétique), propriétés et
engagements (avec le score global et le classement des programmes),
hypothèses et sources. Dans les tableaux de propriétés, le
fond de chaque case suit un dégradé continu selon la part des scénarios où
la propriété tient : rouge pour aucun, orange pour la moitié, vert pour
tous (le nombre reste écrit dans la case).

La synthèse et le programme complet se terminent par une **table de
correspondance** entre les concepts du projet (programme, mesure, levier,
scénario, moteur, propriété, engagement, contrat, cohérence interne,
rétro-test…), leur définition en clair et la déclaration Lean qui les
porte, avec son fichier. La table est dans `scripts/glossaire_lean.py` ;
chaque nom y est relu dans les sources à chaque génération, et un nom
renommé ou déplacé est signalé « introuvable » dans le PDF
(`python3 scripts/glossaire_lean.py` fait la même vérification seule).

```sh
lake build rapport && .lake/build/bin/rapport --synthese out/synthese.json
pip install matplotlib reportlab
python3 scripts/synthese_pdf.py out/synthese.json out/synthese.pdf
```

`scripts/programme_pdf.py` produit le **programme complet** d'un seul
programme : chiffres clés et courbes (déficit, dette, chômage, IDH),
déficit sous chaque moteur, propriétés vérifiées, sections « Points à
arbitrer » et « Pistes pour compléter » du README s'il en a, chaque mesure
avec sa source, son chiffrage, ses variantes et son effet isolé (déficit,
chômage, emplois, IDH), puis le reste du README. Si le programme classe
ses mesures (champs `statut` et `domaine` des mesures : rubicons,
paramétrables, négociables, puis domaine), le PDF commence par le tableau
des effectifs et la liste des mesures paramétrables et négociables, et
regroupe les mesures par statut puis par domaine ; la synthèse d'un
programme seul reprend le tableau et les négociables après le préambule.

```sh
python3 scripts/programme_pdf.py out/synthese.json TexteOrientationD out/programme-TexteOrientationD.pdf
```

`scripts/livret_pdf.py` produit le **livret de campagne** d'un programme qui
classe ses mesures : couverture, sommaire, préambule (section « Grands
principes » du README), puis une partie par thématique où les mesures sont
séparées en rubicons, paramétrables et négociables, chacune avec son texte
de campagne (fichier `LIVRET.md` du programme, un bloc « ### O-xx » par
mesure), sa note de réglage ou de discussion, ses variantes, son année
d'entrée en vigueur et son effet isolé ; enfin le bilan (chiffres clés,
bilan par thématique, propriétés tenues).

```sh
python3 scripts/livret_pdf.py out/synthese.json TexteOrientationD out/livret-orientation-d.pdf
```

Le workflow `synthese.yml` régénère la synthèse et les programmes complets
à chaque fusion dans `main` (et à la demande, onglet Actions) et les publie
en artefact `synthese` ; après chaque fusion, il dépose aussi la synthèse
générale, celle du Texte Orientation D et son livret de campagne dans le
dossier `pdf/` de la branche
[`pdf`](https://github.com/TOrientationD/Programmes_Lean/tree/pdf/pdf)
(commit automatique de `TOrientationD`, sans exécuter de code du dépôt).
`main` étant protégée (tout y passe par une PR), les PDF vont sur cette
branche à part, qui n'a qu'un commit remplacé à chaque fusion pour ne pas
alourdir le dépôt ; les autres PDF restent en artefact. Les scripts ne
calculent rien : tous les chiffres sortent de `Rapport.lean`, donc du même
code que la matrice d'évaluation.

## Tests du modèle et rétro-test

`Tests/` rassemble une batterie de tests du modèle commun, décidés par le
noyau Lean comme les engagements (`lake build Tests`, étape bloquante de la
CI) :

* **comptabilité** (`Tests/Comptabilite.lean`) : la dette de fin d'année
  devient la dette de début de l'année suivante, avec et sans programme,
  sous chaque moteur ; les mesures d'une année entrent dans la dette de
  cette année ; un programme sans mesure redonne exactement le tendanciel ;
* **bloc de demande** (`Tests/Demande.lean`) : pour un choc permanent d'un
  point de PIB par canal, l'effet sur le PIB à 1, 2, 3 et 5 ans reste dans la
  fourchette des variantes publiées par Mésange, FR-BDF et e-mod.fr (± 0,15
  point) ; les prix montent avec la demande publique comme dans FR-BDF ; une
  hausse de TVA d'un point de PIB relève les prix à la consommation de
  1,48 % la première année (Mésange) ; les multiplicateurs se classent comme
  dans les trois modèles (dépense publique > transferts > TVA > coût du
  travail la première année) ; l'effet des transferts monte sur trois ans et
  celui de la dépense publique culmine la deuxième année, puis tous
  s'estompent ;
* **rétro-test des équations de demande** (`Tests/RetroDemande.lean`), hors
  échantillon d'estimation, un an à l'avance : erreur moyenne de 0,9 point
  sur les exportations, 1,8 sur les importations, 1,5 sur la consommation,
  0,8 sur le PIB reconstitué par la demande, 0,6 sur les prix à la
  consommation, 1,0 sur les salaires ; l'emploi est sous-estimé de 2 à 5
  points chaque année de 2020 à 2024 (recul de la productivité après le
  Covid, que l'équation d'emploi ne connaît pas) ;
* **cohérence interne** (`Tests/Coherence.lean`) : un programme fictif qui
  passe aux 39 heures (O1) puis revient aux 35 heures (O4) est incohérent,
  le conflit désigne O1 et O4 ; deux taux d'IS différents se contredisent,
  le même taux deux fois non ; un arbitrage lève l'alerte et reste visible ;
  les étapes d'une même mesure ne sont pas comparées ;
* **mécanismes** (`Tests/Mecanismes.lean`) : le PIB suit la trajectoire ;
  loi d'Okun ; semi-élasticité du solde au cycle entre 0,5 et 0,65 une fois
  l'IS encaissé (LPFP : 0,57 ; Commission : 0,6), un peu moins la première
  année (acomptes de l'IS) ; un point d'inflation coûte la part indexée de
  la dette ; un point de taux ne relève le taux apparent que de la part
  refinancée ; convergence du taux apparent ; multiplicateur ; symétrie
  dépense-économie ; rendement d'un prélèvement ; transition écologique
  (carburant évité : importations et accises en baisse, PIB en hausse ;
  biocarburant à taxes inchangées ; accise de l'électricité ; activité
  perdue ; part importée des investissements par technologie ;
  investissement privé sans dépense publique ; éviction et chaudières
  remplacées) ;
* **assiettes** (`Tests/Assiettes.lean`) : barème indexé (l'inflation seule
  ne relève pas l'IR plus que les revenus), progressivité sur la hausse
  réelle, accises insensibles aux prix, revalorisation légale des valeurs
  locatives, droits de mutation sur les transactions, accélérateur et
  modulation des acomptes de l'IS ; élasticités au cycle qui émergent des
  assiettes (cotisations 0,59, TVA 0,97, IS 1,45 la première année et 3,2 en
  régime établi ; LPFP : 0,63, 1,00, 2,76) ;
* **rétro-test** (`Tests/Retro.lean`, `Modele/Retro.lean`,
  `Hypotheses/Historique.lean`) : le modèle part des comptes publics
  observés de l'année précédente et simule l'année, avec la même fonction
  que les projections. Il reçoit ce qui n'est pas de son ressort
  (croissance, inflation, taux observés, marché immobilier, revalorisation
  des valeurs locatives ; mesures nouvelles de prélèvements, dépenses
  primaires et recettes hors prélèvements constatées) et calcule ce qui
  relève de ses mécanismes (assiettes, évolution spontanée de chaque
  prélèvement, charge d'intérêts, chômage, dette). Les seuils bornent biais
  et erreur moyenne du déficit, des prélèvements, des intérêts, de la masse
  salariale et de la consommation ;
* **électricité et sols** (`Tests/ElectriciteSols.lean`) : départ conforme
  au bilan électrique 2025 de RTE ; production de la première année à
  moins de 3 % de 2025 ; objectifs 2030 et 2035 de la PPE3 atteints ;
  consommation 2030 entre les trajectoires « stagnation » et
  « décarbonation rapide » de RTE ; solde exportateur borné ; un levier de
  capacité ne démantèle rien ; enveloppe 2021-2031 du ZAN tenue par le
  tendanciel ; abrogation ramenant au rythme 2011-2021 ; imputation des
  surfaces des mesures sur l'enveloppe ; surfaces exemptées hors du
  décompte ; emprise énergétique ; pompes à chaleur (électricité
  consommée, fioul et gaz économisés, coût net) ; emplois aidés et
  implantations ;
* **tendanciel** (`Tests/Tendanciel.lean`) : la dérive du déficit
  tendanciel 2026-2030 reste à moins d'un demi-point de celle de la
  projection « à politique inchangée » de la mission d'experts sur la
  transparence des finances publiques (juillet 2026).

Rétro-test à un an (déficit en % du PIB ; prélèvements et intérêts en
Md€ ; masse salariale : écart au montant observé) :

| Année | Déficit observé | Déficit du modèle | Écart | Prélèvements : écart | Intérêts : modèle / observé | Masse salariale |
|---|---|---|---|---|---|---|
| 2019 | 2,39 | 2,35 | −0,04 | +1,0 | 38,7 / 38,8 | −0,2 % |
| 2020 | 8,93 | 8,88 | −0,05 | +0,1 | 32,1 / 33,2 | +0,1 % |
| 2021 | 6,58 | 7,36 | +0,78 | −24,4 | 32,9 / 37,6 | −1,7 % |
| 2022 | 4,73 | 4,88 | +0,15 | −6,8 | 49,9 / 52,7 | −1,7 % |
| 2023 | 5,36 | 4,43 | −0,93 | +30,4 | 55,2 / 51,0 | +0,9 % |
| 2024 | 5,76 | 5,10 | −0,66 | +18,6 | 57,4 / 58,1 | +1,3 % |
| 2025 | 5,09 | 5,18 | +0,09 | −0,4 | 67,0 / 64,7 | +0,5 % |

Erreur moyenne sur le déficit : 0,39 point (biais −0,09), contre 0,53 quand
chaque prélèvement suivait le PIB ; erreur maximale : 0,93 point (1,44
auparavant) ; sur la charge d'intérêts : 2,2 Md€. L'élasticité des
prélèvements au PIB a été de 1,4 en 2022 et de 0,4 en 2023 (Cour des
comptes, base 2020) : le bénéfice fiscal de 2021 (+41 %) et les règles
d'acomptes de l'IS, la chute des transactions immobilières (−22 % en 2023)
et la revalorisation des valeurs locatives (+7,1 % en 2023) en expliquent
l'essentiel. Restent la déformation de la consommation vers les taux
réduits de TVA (2023-2024, IGF), le calendrier du prélèvement à la source
de l'impôt sur le revenu (la régularisation de l'année précédente) et, en
2020-2021, l'activité partielle, qui a découplé l'emploi du PIB (loi
d'Okun en défaut). Simulé depuis 2018 sans repartir des comptes observés,
le déficit 2025 est de 4,84 % (5,09 % observé) et la dette de 114,1 % du
PIB (115,7 %) : l'écart de dette vient des ajustements dette-déficit, que
le modèle ne projette pas (trésorerie de 2020).

## CI

`ci.yml`, sur chaque push et chaque PR (forks compris, jeton en lecture
seule) :

1. **garde-fou syntaxique**, bloquant, avant toute compilation ;
2. contrôle du registre (dossiers, imports, CODEOWNERS) ;
3. matrice d'évaluation sur la branche de base, **puis** sur la PR, et diff ;
4. tests du modèle commun (`Tests/`) ;
5. preuve des engagements ;
6. rejeu indépendant des preuves par `leanchecker` ;
7. audit des axiomes ;
8. résumé dans le job, artefact `rapport-pr`. Le résumé montre d'emblée
   le score global de chaque programme (somme, sur toutes les propriétés,
   du nombre de scénarios où chacune tient, par moteur, avec un
   classement) puis, pour chaque moteur, le nombre de scénarios où chaque
   propriété tient par programme, avec une pastille de couleur : 🟥 moins d'un quart,
   🟧 d'un quart à trois quarts, 🟨 trois quarts ou plus, 🟩 tous (les
   tableaux Markdown de GitHub n'acceptent pas de couleur de fond) ; le
   rapport complet est replié.

`commentaire-pr.yml` (déclenché par `workflow_run`) publie ce résumé en
commentaire de la PR. Il dispose des droits d'écriture, donc il n'exécute
jamais le code de la PR et revérifie que le numéro de PR lu dans l'artefact
correspond bien au commit du run.

## Modèle de confiance

Une PR externe fait exécuter son code par la CI : `lake build` élabore les
fichiers Lean de la PR, et l'élaboration peut exécuter du code (`#eval`,
`run_cmd`, `elab`…). Sans précaution, une PR pourrait remplacer le binaire
`lean`, désactiver le noyau (`set_option debug.skipKernelTC true`) ou
réécrire le rapport, et afficher des engagements verts alors qu'ils sont
faux. Les défenses, dans l'ordre :

| Défense | Contre |
|---|---|
| `scripts/garde_fou.py` **de la branche de base**, avant toute compilation | `#eval`, `run_cmd`, `elab`, `macro`, `initialize`, `set_option`, `import Lean`, `unsafe`, `implemented_by`, `native_decide`, `sorry`, `axiom` ; `lakefile.lean`, options Lean et dépendances dans la configuration, toolchain non officielle |
| Scripts Python pris sur la base | une PR qui modifie l'outil qui la juge |
| Base évaluée avant la PR | une PR qui altère le rapport de référence |
| `leanchecker` sur tous les modules compilés du dépôt | une preuve acceptée par l'élaborateur mais pas par le noyau (testé : une « preuve » de `1 = 2` injectée en contournant le noyau passe `lake build` et l'audit des axiomes, `leanchecker` la rejette). La bibliothèque standard n'est pas rejouée (`--fresh`, ~80 s de plus) : elle vient de la toolchain officielle imposée par le garde-fou, et une toolchain compromise compromettrait `leanchecker` lui-même |
| `Audit.lean` | `sorryAx`, `Lean.ofReduceBool`, tout axiome hors `propext`, `Classical.choice`, `Quot.sound` |
| En-tête du commentaire calculé via l'API | un artefact falsifié qui afficherait « ✅ » |
| Contrôle d'accès en `pull_request_target` | la modification d'un programme par un autre que ses propriétaires (voir « Propriété des programmes ») |

**Limite irréductible.** Sur l'événement `pull_request`, GitHub exécute le
workflow *de la PR*. Une PR qui modifie l'outillage (`.github/`,
`scripts/`, `Rapport.lean`, `Audit.lean`, configuration de build) peut donc
neutraliser toute vérification. Le commentaire de PR le signale en tête
(calcul fait côté privilégié, à partir de la liste des fichiers donnée par
l'API) : le verdict d'une telle PR ne vaut qu'après relecture. Les PR qui ne
touchent que `Programmes/`, `Hypotheses/` ou `Proprietes/`, le cas normal
d'une contribution externe, ont un verdict fiable sans relecture du code.

## Gouvernance des contributions externes

Publication : créer un dépôt **vide** sur GitHub, puis
`scripts/publier.sh COMPTE [DEPOT]` remplace les comptes d'exemple de
CODEOWNERS par le vôtre et pousse toutes les branches. Ensuite, dans les
réglages du dépôt :

* **Rules → Rulesets → New ruleset → Import a ruleset** :
  [`.github/rulesets/main.json`](.github/rulesets/main.json). Sur la
  branche par défaut : suppression et force-push interdits, PR obligatoire
  (0 approbation), branche à jour avant fusion, statuts « Vérifier et
  évaluer » et « Contrôle d'accès aux programmes » obligatoires et
  épinglés sur l'app GitHub Actions (id 15368), si bien qu'aucun autre
  émetteur de statut ne peut les satisfaire. Aucun contournement déclaré.
* **Actions → General** : *Allow TOrientationD, and select non-TOrientationD,
  actions* avec seulement *Allow actions created by GitHub* (le dépôt
  n'utilise que des actions `actions/*`) ; *Workflow permissions* : *Read
  repository contents and packages permissions*, et *Allow GitHub Actions
  to create and approve pull requests* décoché ; *Approval for running fork
  pull request workflows* : au minimum *Require approval for first-time
  contributors*.
* **Security** : activer *Private vulnerability reporting*
  ([SECURITY.md](SECURITY.md)).
* **Équipes** : sur un compte personnel, CODEOWNERS ne vise que des
  comptes. Pour une équipe `socle`, créer une organisation et y transférer
  le dépôt.

### Propriété des programmes

Chaque dossier `Programmes/<X>/` appartient aux comptes listés dans
`Programmes/<X>/PROPRIETAIRES`. Le workflow « Accès aux programmes »
refuse toute PR qui ajoute, modifie, renomme ou supprime un fichier d'un
programme sans que son auteur en soit propriétaire :

* programme existant : propriétaires lus sur la branche de base, donc
  personne ne peut s'ajouter soi-même ;
* nouveau programme : son `PROPRIETAIRES` doit nommer l'auteur de la PR.

Les propriétaires n'ont pas besoin d'être collaborateurs du dépôt : ils
contribuent depuis un fork. Le workflow tourne en `pull_request_target`
(version de la branche de base, impossible à modifier par la PR) et ne lit
que des données de la PR via l'API, sans jamais exécuter son code.

Limite : un administrateur du dépôt peut toujours contourner un ruleset.
La garantie pour les autres est la transparence : le contrôle reste rouge
sur la PR et l'historique public le montre.

Le socle commun (`Modele/`, `Hypotheses/`, `Proprietes/`) et l'outillage
sont relus par les mainteneurs du socle ; chaque dossier de programme par
ses propres mainteneurs. Voir [CONTRIBUTING.md](CONTRIBUTING.md) et les
[règles de conduite](CODE_OF_CONDUCT.md).

## Limites

* Une preuve ne dit jamais qu'un programme est bon, seulement qu'il est
  cohérent **sous des hypothèses explicites**. L'intérêt est de déplacer le
  débat vers ces hypothèses, versionnées et contestables par PR.
* Le sous-modèle électrique raisonne en énergie annuelle : pointes,
  stockage, prix et effacements n'y figurent pas, et le thermique fossile
  garde son facteur de charge de 2025. Celui des sols ne connaît que les
  rythmes nationaux (pas de territorialisation des enveloppes).
* Le modèle agrégé ne connaît ni barèmes ni ménages types. Piste
  naturelle : une microsimulation (OpenFisca) lancée en CI qui émet des
  agrégats, que Lean vérifie contre les propriétés ; et Catala pour la
  sémantique juridique fine.

## Licence

[CC0 1.0 Universel](LICENSE) : le dépôt est versé au domaine public. Code,
modèle, hypothèses et documentation peuvent être réutilisés, modifiés et
redistribués sans condition, y compris commercialement, sans obligation de
citer. En droit français, le droit moral de l'auteur est inaliénable : CC0
y renonce dans la mesure permise et prévoit une licence de repli tout aussi
large. Les sources citées dans les hypothèses (INSEE, COR…) gardent leur
propre licence.
