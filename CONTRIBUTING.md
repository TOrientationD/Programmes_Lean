# Contribuer

Toute contribution passe par une PR, depuis un fork ou une branche. Une PR
= un seul type de changement : cela rend le commentaire d'impact lisible et
la revue attribuable aux bonnes personnes.

## Quatre types de contribution

### 1. Créer ou modifier son programme

Périmètre : `Programmes/<Nom>/` (+ deux lignes dans `Programmes.lean` pour
un nouveau programme).

**Un programme n'est modifiable que par ses propriétaires**, listés dans
`Programmes/<Nom>/PROPRIETAIRES`. La CI refuse toute autre PR qui touche
le dossier (voir README, « Propriété des programmes »).

1. Copier `Programmes/ExempleRelance/` vers `Programmes/<Nom>/`. `<Nom>` est
   un identifiant Lean ASCII : lettres, chiffres et `_`, commençant par une
   lettre (ex. `TexteOrientationD`).
2. Mettre son compte GitHub dans `Programmes/<Nom>/PROPRIETAIRES`, un compte
   par ligne. La PR doit être ouverte depuis l'un de ces comptes.
3. Dans `Programme.lean` : remplacer le namespace et `id := "<Nom>"`,
   renseigner les mesures. Chaque mesure cite sa source (`source := "p. 12"`).
4. Déclarer les engagements que le programme revendique, s'il en revendique,
   et les **contrats** de chaque mesure : propriétés du dispositif prouvées
   pour tous les cas (voir la mesure R-07 d'`ExempleRelance`). Un contrat
   porte sa preuve ; les théorèmes génériques du modèle commun
   (`Modele/Logement.lean` pour le SRU) font l'essentiel du travail.
5. Enregistrer le programme dans `Programmes.lean` (import + `tous`).

Ajouter un co-propriétaire : un propriétaire actuel ajoute son compte dans
`PROPRIETAIRES`. Proposer une modification au programme de quelqu'un
d'autre : ouvrir une issue, ou soumettre la modification à l'un de ses
propriétaires, qui la reprend dans sa propre PR.

Une mesure ne s'exprime qu'avec les leviers de `Modele/Leviers.lean`. Si
aucun ne convient, ouvrir une issue « Faire évoluer le modèle commun »
plutôt que de forcer un levier inadapté.

Quand la source précise l'impôt visé ou le secteur aidé, préférer
`prelevementSur` (par exemple `.prelevementSur .impotSocietes 15000`, ou
`.prelevementSur .droitsMutation` pour une mesure sur les successions et
donations, dont l'assiette suit le flux successoral) à `prelevement`, et `depenseSecteur` (par exemple
`.depenseSecteur .industrie 500`) à `depense` : la synthèse PDF attribue
alors recettes et emplois au bon poste au lieu de « autres impôts » ou
d'une répartition au prorata. Un financement par prêt ou prise de
participation de l'État (EDF, nationalisation) est un `pretEtat` : il
pèse sur la dette, pas sur le déficit. Une mesure qui n'entre en vigueur
qu'après l'année de départ porte `debut := n` (années) : montée en charge
ou décaissements différés. Les mesures automobiles ont leurs leviers :
`aideAchatElectrique véhiculesParAn primeEuros public` (parc électrique,
décès évités, carburant importé évité, accises et TVA perdues ; `public` :
`.general` par défaut, `.modestes` pour une aide réservée aux ménages
modestes comme le leasing social, `.obligation` pour une interdiction ou un
quota, sans prime ; une aide ne rend électrique qu'une part des voitures
aidées, l'aubaine étant calculée par le modèle ; au-delà des ventes neuves,
que le règlement (UE) 2023/851 électrifie entièrement en 2035, la prime
n'achète plus rien), `retrofitElectrique véhiculesParAn aideEuros
partImportéePm vignetteCritAir` (conversion de voitures thermiques du parc,
hors limite des ventes neuves et sans aubaine) et `deploiementBornes
bornesParAn coûtParBorne`.

Transition écologique décrite finement (de préférence à `transitionKt`,
qui ne fait que baisser les émissions) : `transitionEcologique { secteurGes,
reductionKt, energie, substitutImportePm, taxesMaintenues, electriciteGwh,
activitePerdueMeur, secteurActivite, activiteImporteePm }` compte, pour les
tonnes évitées, l'énergie fossile qui n'est plus achetée (`.carburant`,
`.fioul`, `.gaz` ou `.aucune` : importations évitées, accises et TVA
perdues, aux paramètres de l'axe énergie), le substitut importé et les
taxes maintenues d'un biocarburant, l'électricité consommée à la place
(accise et TVA gagnées) et la production intérieure qui disparaît
(fermeture d'usine, réduction de cheptel : PIB et emplois du secteur, part
reprise par des importations). Les dépenses vont par technologie :
`investissementTransition techno niveaux` (public) et
`investissementPriveTransition techno niveaux` (investissement privé
déclenché, sans dépense publique), avec la part importée de chaque
technologie (`Energie.partImporteeTransitionPm` : pompes à chaleur,
véhicules électriques et utilitaires, solaire, éolien, rénovation, réseaux
de chaleur, HVO, biogazole, bioéthanol, biogaz) et son secteur d'emploi.
Saisir le coût complet pour le chauffage, la rénovation et les réseaux de
chaleur, le surcoût pour les véhicules et les biocarburants : la part qui
remplace un équipement fossile (`Energie.substitutionBruneTransitionPm`) et
l'éviction de l'investissement privé (`Economie.evictionInvestissementPrivePm`)
sont retirées de l'effet de demande. Restent hors du modèle : les marges perdues par la distribution de
carburant et l'entretien automobile (réallocations entre secteurs
intérieurs), les effets de prix de l'électricité et la productivité.

Stockage d'électricité : `stockageElectrique mw heures cyclesParAn
rendementPm gCo2ParKwh` (la restitution remplace le thermique fossile de
pointe, la charge est prise au nucléaire, les pertes s'ajoutent à la
consommation).

Bloc de demande : un levier agit sur la demande par `effetDemande H canal
cible ppm`, qui enregistre l'impulsion dans un canal du bloc
(`Modele/Demande.lean` : consommation publique, emplois publics,
investissement, transferts et prélèvements sur les ménages, TVA et accises,
coût du travail, IS, échanges extérieurs). En fin d'année, le bloc calcule
le PIB par la demande, l'emploi, le chômage, les prix et les salaires ; ses
prix entrent l'année suivante dans le PIB nominal, les assiettes, les
dépenses et l'indice des prix. Une dépense prend le canal de sa fonction
(`Fonction.canal`), un prélèvement celui de son impôt (`Impot.canal`).
Moteurs : outre l'intensité des effets de demande (`multiplicateurPm`,
rapporté au multiplicateur de référence du bloc) et des prélèvements,
l'effet des prélèvements sur la croissance et le canal du capital, un
moteur peut résorber en plus les effets de demande du bloc
(`resorptionDemandePm`, part de l'écart résorbée chaque année au-delà de
la part durable `partDemandeDurablePm`) ; les chocs d'offre (heures,
productivité, activité perdue, canal du capital) ne passent pas par le
bloc.

Règle budgétaire : `freinDeficit seuilPb moderationPb` durcit la norme de
dépense des fonctions pilotables l'année qui suit un déficit au-dessus du
seuil (frein automatique, qui ne joue que dans les scénarios concernés).

Préférer `depenseSur fonction montant` et `economieSur fonction montant`
(nomenclature COFOG agrégée : retraites, santé, famille, enseignement,
affaires économiques, défense, sécurité-justice, logement-environnement,
culture, fonctionnement) à `depense` / `economie`, qui vont dans « non
ventilé » : la synthèse décompose le déficit par fonction. `investissement fonction montant` : dépense d'équipement imputée à une
fonction, emplois dans la construction. Durée du
travail : `dureeTravail variationPm` (le PIB suit le volume d'heures).
Taux de l'IS : `impotSocietes tauxPb` (taux normal) ; le modèle applique le
plancher du pilier 2 aux grands groupes et la réponse de l'assiette au taux
effectif (semi-élasticité de l'axe économique) : un programme ne fixe plus
son propre retour d'assiette.

Rénovation énergétique : `bonusRenovation territoire bonusEuros` (`.rural`
ou `.national`) relève l'aide par rénovation ; le sous-modèle de l'axe
énergie en déduit le coût, les rénovations suscitées (effet d'aubaine) et
chaque année les économies de fioul et de gaz (importations, accises, TVA,
CO₂). Outre-mer : `investissementOutreMer fonction niveaux` (échéancier,
emplois dans la construction, contenu importé propre aux outre-mer) et
`raccordementZni foyers` (surcoût de péréquation de l'électricité des zones
non interconnectées). Achats ponctuels (`depensePonctuelle`,
`remplacementVehicules`) : inscrits dans les dépenses de l'année, retirés
l'année suivante. Les voitures retirées par `remplacementVehicules` portent
leur vignette Crit'Air (`vignetteCritAir`), dont dépendent les particules
évitées ; chaque voiture électrique ajoutée par une mesure évite du CO₂
(réductions sous le million de tonnes cumulées dans `emissionsResiduKt`).

Accidents du travail : `preventionAccidents fondsMeur baissePm` (fonds
publics et baisse du taux d'accidents ; le sous-modèle calcule coûts
évités, journées rendues et décès). Constitution : deux leviers
déclaratifs, `tauxMarginalSommet pm` (taux marginal maximal d'imposition
d'un revenu créé par la mesure, toutes impositions confondues ; l'état
garde le plus haut) et `revisionConstitution article objet` (la mesure
exige une révision) ; les propriétés `constitution-*`
(`Proprietes/Constitution.lean`) les comparent à la jurisprudence et aux
textes listés dans `Hypotheses/Constitution.lean`, avec le solde structurel
(`Etat.deficitStructurelPb`, écart de production `Etat.ecartProductionPb`)
et les dépenses par tête. Textes européens : les propriétés
`ue-*` (`Proprietes/Europe.lean`) traduisent les règles listées dans
`Hypotheses/Europe.lean` ; en ajouter une = un texte cité + un critère.

Offre de travail : `offreTravail actifs tauxEmploiPm` (seniors, parents,
inactifs ramenés vers l'emploi : actifs en plus, dont une part en emploi
l'année même, le reste réabsorbé au rythme du scénario) ; n'inscrire que
les actifs supplémentaires, nets de l'aubaine. Marché du travail : la loi d'Okun est exprimée en chômage ; les emplois
s'en déduisent avec l'effet de flexion (`emploisPourChomeurs`,
`chocDemandeTravail`). Les chocs d'offre de
travail des mesures (âge de départ, migrations, réallocations par
`automatisation gainPibPb emplois sortiesActivite`) entrent au taux
d'emploi propre aux personnes concernées et l'écart à l'emploi d'équilibre
(`chomeursExcedentaires`) se résorbe au rythme du scénario. Une demande
adressée à un secteur y crée des emplois selon son intensité en
main-d'œuvre (`intensiteEmploiSecteurPm`, valeur ajoutée par emploi de
l'INSEE : construction et non-marchand au-dessus de la moyenne, industrie
en dessous) ; une dépense qui s'arrête détruit les emplois du même secteur.
Les dépenses d'indemnisation suivent chaque année le nombre de chômeurs
(`coutParChomeurEuros`, stabilisateur automatique) : un programme qui
relève le chômage voit son déficit monter d'autant.

Rémunérations publiques : `remunerationPublique nature fonction niveaux`
(nature `.traitement`, `.primes` ou `.heuresSup`) pour des agents déjà en
poste : le modèle retire les prélèvements qui reviennent (CSG-CRDS,
cotisations, impôt sur le revenu selon la nature) et traite le net comme un
transfert aux ménages, sans emplois publics en plus ; recruter reste un
`depenseSur` (production et emplois). Passifs implicites (« dettes
cachées »), suivis par type (`TypePassif` : `.heuresSupPolice`,
`.heuresSupHopital`) : `apurementPassifs type fonction partPm` paie une
part du stock l'année même, `paiementFluxPassifs type fonction partPm`
paie le flux au fil de l'eau ; `entretienPassifs type fonction montant`
résorbe un retard d'entretien (`.entretienInfrastructures` : ouvrages
d'art, chaussées, voies navigables, ≈ 12 Md€ fin 2025 et +0,8 Md€ par an)
par des travaux d'une année (emplois dans la construction, capital
public), à répéter ; le rapport donne chaque stock et la dette
étendue. Investissement échelonné (bâtiments, équipements) :
`investissementEcheancier fonction niveaux` (emplois dans la construction,
dernier niveau reconduit, 0 pour arrêter) ; le fonctionnement des
équipements livrés est un `depenseEcheancier` à part.
Coût de l'électricité des entreprises (`Electricite.prixEntreprisesEurosMWh`,
`Hypotheses/Electricite.lean` : coûts par filière, prix du gaz et du CO₂,
marge, réseau, taxes, prix 2024 des autres pays pour la synthèse) et
facteur d'implantation (`elasticiteEmploiIndustrielPrixElecPm`,
`ajustementImplantationsPm`, état `emploisImplantationsEnergie`) : l'écart
de coût au mix de départ, aux mêmes prix du gaz et du CO₂, déplace des
emplois industriels par `chocEmploi` ; mettre l'élasticité à 0 pour
isoler un mécanisme (scénario `base` des tests, rétro-test). Levier
`prioriteNucleaire` (sans paramètre) : le surplus est écrêté sur le
solaire, l'éolien terrestre puis l'éolien en mer avant toute modulation
du nucléaire (état `prioriteNucleaire`, `ecretementGwh`). `pollutionAir
decesParAn` : décès attribuables à la pollution de l'air ajoutés (règle
supprimée) ou retirés, en niveau, années de vie suivies. Technologie de
transition `ascenseur` (pose dans la construction, un quart importé, aide
aux propriétaires sans capital public). `placementExcedent partPm partOrPm
plafondOrMeur` : dès qu'une année finit en excédent, une part en est placée
l'année suivante en rachat d'or (plafonné, état `orRacheteMeur`) et en
prises de participation (dividendes au rendement de départ) ; opérations
financières, dans la dette, hors déficit. `plafondNormeSante pb` : les
normes de dépense ne retirent à la santé qu'au plus `pb` par an (le lien
dépense de santé → espérance de vie, `elasticiteEsperanceSantePm`, en
dépend ; l'état `depenseSanteTendanceMeur` porte la référence
tendancielle). Prime de stock de dette : `primeDettePb` (0 en rétro-test).
Incidence des prélèvements : un prélèvement entre dans le canal de son
impôt, pondéré par son incidence (`incidencePrelevementPm`, axe économique)
rapportée à celle de l'impôt de référence du canal (IR, TVA, IS) et par
l'intensité du moteur (`multiplicateurPrelevementsPm`) : les droits de
succession et les impôts sur le patrimoine (ligne `.patrimoine` : IFI,
taxes sur la fortune ou les holdings) pèsent beaucoup moins que l'IR ou la
CSG. Choisir l'impôt d'une mesure change donc son effet sur l'activité. Coût du travail :
`allegementsCotisations tranche montant` (tranches `.bas` 1 à 1,6 SMIC,
`.intermediaire` 1,6 à 2,5, `.haut` au-delà) fait varier les allègements
généraux de cotisations patronales ; l'emploi de la tranche répond au coût
du travail selon l'élasticité de l'axe économique, progressivement ; une
baisse ne peut dépasser les allègements en vigueur sur la tranche
(`allegementsTranche`, dans l'état). `reductionAllegements montant` réduit
les allègements au prorata des tranches (réduction sans ciblage, donc
surtout au voisinage du SMIC) ; `recentrageAllegements partIntermediairePm
partHautPm` reverse au voisinage du SMIC, à coût constant, une part des
allègements des tranches supérieures. Un `prelevementSur .cotisations`
reste une hausse de cotisations sans tranche (incidence moyenne).
Accompagnement des demandeurs d'emploi : `accompagnementDemandeurs
conseillers coutParConseillerEuros` (dépense, et baisse du chômage
d'équilibre par conseiller, axe économique). Assurance chômage : la
référence porte le seuil des règles contracycliques et le surcoût du
complément de fin de droits, que la projection déclenche quand le chômage
de l'année passée atteint le seuil.
Incidence des dépenses : une dépense entre dans le canal de sa fonction,
pondérée par son incidence (`incidenceDepensePm`) rapportée à celle de la
fonction de référence du canal (`Canal.fonctionReference`) : dans la
consommation publique, les affaires économiques et la défense comptent
pour 0,85 ; dans les transferts aux ménages, calés sur les pensions, la
famille et le chômage comptent pour 1,06 fois les retraites ;
l'investissement public (`investissement`, `investissementEcheancier`…)
passe par son propre canal.
IDH : calculé chaque année (`Modele/Idh.lean`, formule du PNUD) ;
l'espérance de vie gagne les années de vie des décès évités par les mesures
(pollution de l'air, accidents du travail, et causes de `CauseDeces` :
`prixTabac hausseprixPm`, `prixMinimumAlcool centimesParVerre`,
`depistageColorectal participationCiblePm`, dont l'effet sur la mortalité
monte au rythme du délai de chaque cause) ; la durée attendue de
scolarisation suit `scolarisationJeunes hausseTauxPm` ; le RNB par habitant,
le PIB en volume et la population. Propriété `idh-non-degrade`.
Taxes environnementales : `taxeEnvironnementale activite impot
emissionsViseesKt hausseCoutPm rendementStatique` (activités : vols
intérieurs, poids lourds, carburants routiers, chauffage fossile) ; le
modèle applique l'élasticité-prix de l'activité (axe énergie).

Émissions : l'état les suit par secteur de l'inventaire (`emissionsKt` :
transports, bâtiments, agriculture, industrie, énergie, déchets), chacun à
sa tendance (`baisseEmissionsSecteurPm`). `transition secteur reductionMt
coutAnnuel` impute la réduction à un secteur ; les voitures électriques
ajoutées par les mesures réduisent les transports, la rénovation les
bâtiments. Objectifs vérifiés : SNBC-3 par secteur en 2030 et budget
carbone 2029-2033, total de 276 Mt en 2030, répartition de l'effort
européenne, 15 % de voitures électriques en 2030.
`suppressionPostes fonction postes coutParPosteEuros` supprime des emplois
publics. `depenseEcheancier fonction niveaux` fixe une dépense année par
année (indemnités jusqu'à la retraite, revalorisations cumulées) ; une
mesure peut aussi être répétée (`repetitions := 5`). Un niveau négatif est
une économie, pondérée par le moteur comme `economieSur`.
`normeDepense moderationPb` ralentit la croissance des fonctions
pilotables (santé, affaires économiques, sécurité-justice, logement-
environnement, culture, services généraux ; lemme `tauxCroissance_norme`).
`recetteEcheancier impot niveaux` fixe une recette année par année (impôt
avec effet de demande, ou recette non fiscale sans effet si `none`).
`prisesDeParticipation montant` : participations de l'État, dette sans
déficit, dividendes au rendement du portefeuille de l'APE.
`importationsNiveau deltaMeur` déplace le niveau des importations
(substitution d'énergie importée), sans effet sur le PIB, comme le
sous-modèle automobile.

Une mesure peut aussi porter un **classement de présentation**, sans effet
sur les chiffres : `statut` (`.rubicon` non négociable, `.parametrable`
principe acquis et paramètres réglables, `.negociable` cessible dans une
négociation ; `.nonClasse` par défaut), `domaine` (`Domaine` : économie,
fiscalité, défense…) et `noteStatut` (ce qui se règle, ou ce qui rend la
mesure discutée). Le rapport les exporte ; le programme complet en PDF et
la synthèse d'un programme seul regroupent alors les mesures par statut
puis par domaine. Le Texte Orientation D les pose par des tables
(`negociables`, `parametrables`, `domainesMesures`) appliquées à sa liste.

Calendrier : `entreeEnVigueur` (Programme) fixe l'année où le programme
commence (2 = 2027 pour les programmes de 2027) ; aucune mesure ne
s'applique avant, et `debut` est compté depuis cette année.
Propriétés de trajectoire : `Propriete.surTrajectoire` évalue un critère
sur la liste des états de 0 à l'horizon (exemple : « Déficit en baisse
chaque année »). Retraites : `dureeCotisation moisRequis partDepartsDureePm`
(au millième de mois près ; `ageLegal` en mois entiers, par rapport au
calendrier légal qui continue de s'appliquer). Pour fixer l'âge légal
lui-même, utiliser `ageLegalCible cibleMois rythmeMois` : sous l'âge
courant, baisse immédiate et fin du calendrier ; au-dessus, le calendrier
en vigueur est suivi (`rythmeMois` = 0) ou remplacé par des hausses de
`rythmeMois` mois par an jusqu'à la cible.

Lois en vigueur : la référence (`Hypotheses/Reference.lean`, section « Lois
en vigueur ») applique les textes votés dont les effets ne suivent pas le
PIB : calendrier de l'âge légal suspendu par la LFSS pour 2026 (seul
l'écart au calendrier de la réforme de 2023, supposé dans la tendance, a
des effets), LPM actualisée, ETS2 à partir de 2028, fin de la
contribution exceptionnelle des grandes entreprises (2026) et de la CVAE
(2030), droits de succession et de donation portés par la hausse des
décès et le gel des abattements, contribution différentielle sur les hauts revenus éteinte l'année
qui suit un déficit sous 3 %, électrification réglementaire du parc avec
érosion des accises et de la TVA sur les carburants. Une mesure qui
revient sur l'une d'elles s'exprime par écart à la référence (exemple :
`recetteEcheancier` pour maintenir la CVAE).

Taux d'intérêt : le taux marginal du scénario est corrigé d'une prime de
risque (`primeDeficitPb` par point de déficit au-dessus de celui de départ,
Laubach 2009) ; le taux apparent s'en rapproche d'au plus `deriveTauxPb`
par an, à la hausse comme à la baisse.

Financement de la dette : `detteNumerique ciblePm rythmePm
capitalisationPm partResidentsPm partImposeeAvantPm` (tranche de dette
tokenisée, décote de taux = capitalisation × taux du PFU, perte de PFU
sur la part défiscalisée des intérêts ; calcul annuel dans la
projection, taux du PFU dans l'axe économique).

Objectifs d'emplois et immigration : `annonceEmplois n` enregistre un
objectif déclaré (sans effet sur le modèle ; la propriété « emplois
annoncés réalisables » vérifie qu'il tient dans la population active),
`migration deltaMilliersParAn` modifie le solde migratoire.

Tous les programmes sont évalués sous tous les **moteurs**
(`Hypotheses/Moteurs.lean` : « demande » et « offre ») ; un engagement
précise son moteur (`Engagement.sous Moteurs.standard H q`). Une propriété
peut viser une année précise (`annee := some 10` : 2035) plutôt que
l'horizon du scénario.

### 2. Proposer une hypothèse

Périmètre : `Hypotheses/`. Ajouter une valeur sur un axe et l'ajouter à la
liste `toutes` de l'axe. Toute valeur numérique est sourcée dans `sources`.

La PR fait apparaître de nouveaux scénarios pour **tous** les programmes.
Si elle casse un engagement « pour tout scénario » d'un programme, la CI
échoue : c'est voulu. La discussion porte alors sur l'hypothèse (est-elle
plausible ?) ou sur l'engagement (était-il trop large ?).

### 3. Proposer une propriété

Périmètre : `Proprietes/`. Une propriété est un `Prop` décidable sur
`(scénario, tendanciel, état avec programme)`. Elle doit être neutre :
formulée sans référence à un programme particulier.

### 4. Faire évoluer le modèle commun

Périmètre : `Modele/`. **Issue préalable obligatoire.** Le modèle s'applique
à tous les programmes ; ses évolutions sont relues par l'équipe `socle`.

## Ce que la CI vérifie

`scripts/ci_locale.sh` rejoue les mêmes étapes en local, dans le même ordre.

| Vérification | Échoue si… |
|---|---|
| Garde-fou (avant compilation) | construction interdite dans un fichier Lean (voir ci-dessous), configuration de build modifiée hors des clés autorisées |
| Registre | un dossier de programme n'est pas enregistré ou n'a pas de mainteneur |
| Compilation | le code Lean ne compile pas |
| Matrice | identifiant dupliqué ou scénario hors bornes de plausibilité |
| Engagements | un engagement revendiqué est faux |
| Rejeu (leanchecker) | une preuve est acceptée par l'élaborateur mais rejetée par le noyau |
| Audit | `sorry`, `native_decide` ou `axiom` dans le dépôt |

Le bot commente la PR avec l'impact : engagements cassés, résultats sous
les nouveaux scénarios, cellules de la matrice qui changent, indicateurs
modifiés. Si la PR touche l'outillage (`.github/`, `scripts/`,
`Rapport.lean`, `Audit.lean`, configuration de build), le commentaire
l'indique en tête : son verdict ne vaut qu'après relecture.

## Règles

* Hors outillage (`Rapport.lean`, `Audit.lean`), le Lean du dépôt est du
  Lean « pur » : pas de commande `#…`, `run_cmd`, `elab`, `macro`,
  `syntax`, `initialize`, `set_option`, `attribute`, `unsafe`,
  `implemented_by`, `opaque`, `native_decide`, `sorry`, `axiom`, et seuls
  les modules du dépôt s'importent. Un programme n'en a jamais besoin ;
  c'est ce qui rend le verdict de la CI fiable sur une PR externe.
  `python3 -I scripts/garde_fou.py` le vérifie en local.
* Les hypothèses sont des **données** (`def`), jamais des `axiom`.
* Pas de valeur numérique sans source.
* Un engagement cassé ne se supprime pas en silence : la PR qui le retire
  explique pourquoi.
* Les exemples fournis sont fictifs ; un programme réel reproduit fidèlement
  son document source, sans interprétation favorable ni défavorable.

## Licence des contributions

Le dépôt est sous [CC0 1.0](LICENSE). En ouvrant une PR, vous acceptez que
votre contribution soit publiée sous la même licence (règle « inbound =
outbound » des conditions d'utilisation de GitHub). Ne proposez que du
contenu que vous avez le droit de verser au domaine public. CC0 n'oblige pas
à citer ses sources ; ce dépôt l'exige quand même pour toute valeur
numérique.

Débats, revues et issues suivent les [règles de conduite](CODE_OF_CONDUCT.md).
