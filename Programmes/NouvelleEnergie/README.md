# Nouvelle Énergie — David Lisnard (octobre 2026)

> **Transcription partielle et non officielle** des propositions de David
> Lisnard, maire de Cannes, candidat à l'élection présidentielle de 2027
> (Nouvelle Énergie), consultées le 30 octobre 2026 : site du parti
> ([unenouvelleenergie.fr](https://www.unenouvelleenergie.fr/notre-programme/),
> pages « Questions » mises à jour le 16 octobre 2026), [discours de
> Saint-Raphaël](https://www.unenouvelleenergie.fr/app/uploads/2026/07/Discours-de-David-Lisnard-a-Saint-Raphael.pdf)
> (3 juillet 2026), discours de La Gagne (29 août 2026), « Objectif Élysée
> 2027 » ([CNEWS et Europe 1, 27 octobre 2026](https://www.unenouvelleenergie.fr/david-lisnard-sur-cnews-et-europe-1-je-ne-suis-pas-candidat-pour-un-poste-je-viens-pour-redresser-le-pays/)).
> Toute erreur se signale par une issue. Le parti peut demander la
> propriété de ce dossier.

Le parti chiffre une **enveloppe** : 80 Md€ d'économies dès la première
année, 200 Md€ « à l'horizon 2032 », répartis à 60 % en salaire net
(120 Md€), 20 % en impôts de production (40 Md€) et 20 % en désendettement
([« Que ferait David Lisnard des 200 milliards d'économies ? »](https://www.unenouvelleenergie.fr/questions/que-ferait-david-lisnard-des-200-milliards-d-economies/)).
Il ne ventile pas les économies par poste ; aucun document de chiffrage
n'est publié et aucune expertise indépendante n'a validé ces montants
(L'Essentiel de l'éco, 21 octobre 2026). Un plan détaillé de la fonction
publique est annoncé pour décembre 2026.

## Modélisé (`Programme.lean`)

Le modèle retient le chiffrage du parti : montée linéaire de 80 Md€ en
2027 à 200 Md€ courants en 2032 (hypothèse : aucune trajectoire
intermédiaire publiée), même clé de répartition chaque année. Les
échéanciers du modèle étant en euros 2027 puis indexés, chaque niveau est
ramené en euros 2027 à 3 % de croissance nominale par an (convention
d'O-59) : 172,5 Md€ d'euros 2027 en 2032. Les économies identifiées sont
des leviers propres ; le reste de l'enveloppe est une économie non
ventilée. Montants ci-dessous en euros 2027.

| Mesure | Levier |
|---|---|
| NE-01 Économies non ventilées (opérateurs et agences, dépense sociale, chômage, budgets en base zéro, ministères) | de −71,8 Md€ en 2027 à −138,8 Md€ en 2032 : l'enveloppe moins NE-02 à NE-04 ; variante : 20 % des économies à la « modernisation de l'État » au lieu de la dette |
| NE-02 Plus de 400 000 postes publics supprimés, 200 000 à 300 000 redéployés | 80 000 postes par an pendant cinq ans (hypothèse), 62 500 € par poste (ratio de LR-01 et H-02), soit −25 Md€/an en 2031 ; redéploiements neutres |
| NE-03 Prestations non contributives après cinq ans de résidence | de −2,5 Md€ en 2027 (« 2 à 3 milliards ») à −8 Md€ (chiffrage du parti) |
| NE-04 AME remplacée par une aide médicale d'urgence | −0,7 Md€ (chiffrage du parti) |
| NE-05 Salaire net : baisse des prélèvements salariaux, dont CSG d'activité de 9,2 % à 6,6 % | de −48 Md€ en 2027 à −103,5 Md€ en 2032 de cotisations, soit ≈ 120 Md€ courants (60 % de l'enveloppe, « sans augmenter le coût du travail ») |
| NE-06 Impôts de production, à commencer par la C3S | de −16 Md€ à −34,5 Md€ d'autres impôts, soit ≈ 40 Md€ courants (20 % de l'enveloppe ; C3S ≈ 5,4 Md€ ; la CVAE est déjà supprimée par la loi en 2030) |
| NE-07 20 000 places de prison | 5,4 Md€ de construction de 2028 à 2032 (270 k€ par place, paramètre d'O-75), puis 45 k€ par place ouverte et par an ; variante : 236 k€ par place (Institut Montaigne) |
| NE-08 Enseignants : +20 % en cinq ans | jusqu'à +11,8 Md€/an de traitement (paramètre de H-09) |
| NE-09 80 000 entrées légales par an (pour 500 000 selon le candidat ; « diviser par huit » sur la page du parti) | solde migratoire −147 000 par an (176 000 × 420/500, hypothèse et majorant) |
| NE-10 Droits de succession supprimés (« totalement libérer l'héritage ») | −16,2 Md€ (montant de RQ-12) |
| NE-11 Quotient familial déplafonné | −2,1 Md€ d'IR (relèvement du plafond à 2 500 €, CPO ; minorant) |
| NE-12 Âge légal à 65 ans | pour mémoire (texte non daté, non redit en 2026) ; variante : +3 mois par an jusqu'à 65 ans |

Les 20 % affectés au désendettement n'ont pas de levier : c'est la part
des économies qui n'est pas redistribuée.

Points de vigilance :

* **NE-01** porte l'essentiel des économies (≈ 161 Md€ courants en 2032)
  sans ventilation : c'est l'affirmation du parti, que le modèle ne peut pas
  vérifier. Son effet sur l'activité est celui d'une économie non ventilée
  (pondérée par le moteur).
* **NE-05** : la part salariale ou patronale des 120 Md€ n'est jamais
  précisée ; le mécanisme affiché (salaire net en hausse sans hausse du
  coût du travail) correspond à des prélèvements côté ménages. La part de
  la CSG sur les revenus d'activité n'est pas sourcée : tout est imputé aux
  cotisations.
* **Calendrier** : « 200 milliards à l'horizon 2032 » (27 octobre 2026) ;
  le texte de Saint-Raphaël dit « à la fin du quinquennat », soit 2031.
  L'horizon 2031 ferait monter l'enveloppe plus vite (80, 110, 140, 170,
  200 Md€).
* **NE-12** : les économies d'un recul de l'âge recouvriraient en partie
  l'enveloppe NE-01 ; la variante les ajoute.

## Résultats (scénario central, 2035)

| | Sans programme | Nouvelle Énergie |
|---|---|---|
| Déficit public (demande / offre / équilibre) | 9,38 / 9,41 / 9,38 % du PIB | 13,45 / 8,93 / 11,01 % |
| Dette publique (moteur de demande) | 157,2 % du PIB | 180,8 % |
| Chômage (moteur de demande) | 7,91 % | 9,58 % |
| Propriétés tenues dans au moins 18 scénarios sur 36 | | 8 sur 28 |

Effet de chaque mesure prise isolément sur le déficit 2035 (demande /
offre) : NE-01 −3,30 / −5,05 pt ; NE-02 −0,53 / −0,84 ; NE-03 −0,21 /
−0,31 ; NE-05 +4,25 / +2,76 ; NE-06 +1,50 / +1,03 ; NE-09 +1,14 / +1,14 ;
NE-10 +0,83 / +0,58 ; NE-08 +0,29 / +0,34 ; les autres moins de 0,1 pt.

Le verdict dépend du moteur. Au moteur de demande, les économies
réduisent l'activité, donc les recettes, plus que les baisses de
prélèvements ne la soutiennent : les 160 Md€ de baisses coûtent davantage
que les 200 Md€ d'économies ne rapportent. Au moteur d'offre, les baisses
de cotisations et d'impôts de production soutiennent l'emploi et le
déficit finit un demi-point sous le tendanciel, loin des 40 Md€ de
désendettement annoncés. La baisse du solde migratoire (NE-09) réduit la
population active et pèse sur le déficit dans les deux moteurs ; la
suppression des droits de succession (NE-10) n'est pas financée par
l'enveloppe.

## Non modélisé

* **Capitalisation** : deux tiers en répartition, un tiers en
  capitalisation collective obligatoire, environ huit tranches de 116 Md€
  au total, Agence centrale publique de retraite ; le modèle n'a pas de
  fonds de pension (comme H-06).
* **Désindexation** des pensions au-delà de 2 000 puis 2 200 € (« à titre
  d'exemple ») : seuil et durée non stabilisés, aucun chiffrage ; comprise
  dans NE-01. L'article 35 du PLFSS 2027 prévoit une désindexation au-delà
  de 1 260 € : s'il est voté, il recouvre en partie la mesure.
* **Allocation sociale unique** plafonnée à un pourcentage du SMIC (taux
  non publié), écart d'au moins 500 € entre travail et assistance ;
  assurance chômage ; agences (1 153 organismes, ARS, DREAL, DDTM) ;
  budgets en base zéro ; ministères supprimés : sans montant, compris dans
  NE-01.
* **Minimum vieillesse à 1 000 €** : sous l'ASPA de 2026 (1 043,59 €),
  sans effet.
* **Justice et sécurité** : procureurs doublés (≈ 2 000 postes), effectifs
  correctionnels doublés, financés par redéploiement ; plan police sur dix
  ans sans montant ; défense : aucun chiffre.
* **Santé** : étudiants en médecine doublés d'ici 2030, CFE et
  prélèvements allégés pour les médecins en zone sous-dense, maisons de
  santé ; **agriculture** : aucun montant.
* **Fiscalité et emploi** : impôt résidentiel universel, taxe foncière à
  la valeur vénale, charges supprimées pour l'emploi à domicile au SMIC,
  charges négatives pour l'embauche d'allocataires du RSA, TVA
  « compétitivité » non tranchée, certificats d'économies d'énergie
  suspendus.
* **Sans paramètre budgétaire** : contrat de travail unique, « 37 heures
  payées 37 », carte scolaire abrogée, chèque-éducation, article 55 de la
  loi SRU supprimé, nucléaire prolongé à 60 ans, majorité pénale à
  16 ans, peines planchers, rétention à 24 mois, droit du sol,
  référendums.
* **300 Md€ « à terme »** : 100 Md€ sont encore « en travail » selon le
  parti.

Livrets non lus (hébergement bloqué) : Santé (mai 2026), Agriculture
(juin 2026), discours de Bayeux (17 juin 2026). Dès qu'un chiffrage est
publié, ces propositions pourront être ajoutées par PR.
