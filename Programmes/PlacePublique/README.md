# Place publique — Raphaël Glucksmann (campagne 2027)

> **Transcription partielle et non officielle.** Au 26 octobre 2026,
> Raphaël Glucksmann, vainqueur de la primaire de la gauche
> sociale-démocrate (9-11 octobre 2026, 66,2 % au premier tour), n'a pas
> publié de programme présidentiel détaillé ni de chiffrage global. Toute
> erreur se signale par une issue ; le parti peut demander la propriété de
> ce dossier.

Sources : déclarations de campagne reprises par plusieurs médias (août à
octobre 2026) et le projet de Place publique
[« Notre vision pour la France — Acte 1 »](https://place-publique.eu/wp-content/uploads/2025/06/20250623_Projet_placepublique_acte1_BAT_BaDef.pdf)
(23 juin 2025), seul texte programmatique complet, sans chiffrage. Aucun
chiffrage indépendant (IPP, OFCE, Institut Montaigne, Cour des comptes)
n'a été trouvé. À revoir dès la publication du programme.

## Modélisé (`Programme.lean`)

| Mesure | Source | Levier |
|---|---|---|
| PP-01 Taxe sur les méga-héritages (au-delà de 2 M€, Pacte Dutreil réformé) | TF1, 23 août 2026 ; débats de la primaire | +15 Md€ par an de droits de succession et de donation |
| PP-02 Baisse de la CSG sur les salaires, financée par PP-01 | Public Sénat, 24 août 2026 ; LCP, 9 octobre 2026 | −15 Md€ par an de CSG |
| PP-03 Enseignants : +10 % au moins, jusqu'à +25 % en milieu de carrière | Public Sénat, 31 août 2026 ; Sud Radio, 3 septembre 2026 | +6 Md€ par an de traitement d'agents en poste |
| PP-04 Leasing social : un million de voitures électriques à 100 € par mois | AFP, 2 octobre 2026 | 200 000 voitures par an à 6 000 € d'aide (6 Md€ sur cinq ans) |
| PP-05 Abrogation de la réforme des retraites de 2023 : 62 ans | débat BFMTV, 4 octobre 2026 ; Acte 1, p. 43 | âge légal ramené à 62 ans |
| PP-06 Service civique obligatoire de dix mois | livre de mai 2026 ; LCP, 26 mai 2026 ; Public Sénat, 24 août 2026 | jusqu'à +4,5 Md€/an en cinq ans (indemnité de 505 € et tutorat de 100 € par mois, Maire-info ; calcul) |
| PP-07 Aide publique au développement à 0,7 % du RNB | Acte 1 | jusqu'à +8,6 Md€/an en cinq ans (0,42 % en 2025) |

## Ajouts du 30 octobre 2026

| Mesure | Source | Levier |
|---|---|---|
| PP-08 Chèque énergie à 500 € pour six millions de familles, aide de 200 € pour dix millions de ménages des classes moyennes, taxe sur les superprofits | L'Opinion, 17 septembre 2026 ; [BFMTV](https://fr.news.yahoo.com/faut-l%C3%A9tat-intervienne-rapha%C3%ABl-glucksmann-211154348.html), 19 septembre 2026 ; plan de sortie de crise du 22 octobre 2026 | +4 Md€ par an de transferts (fonction famille) et +2 Md€ d'impôt sur les sociétés (chiffrage du candidat ; recoupement : 5,0 Md€ moins le chèque actuel, ≈ 4,2 Md€) ; variante : 2027 seulement, mesure de crise |

Choix de transcription, à revoir avec le programme publié :

* **PP-01** : le candidat ne dit pas si les 15 Md€ sont annuels ; la presse
  économique l'écrit. Les droits de succession et de donation rapportent
  20,7 Md€ en 2025 : la mesure les relève de plus de 70 %. La suppression
  des niches Dutreil chiffrée par Place publique en septembre 2025
  (≈ 3 Md€) est supposée comprise, pour ne pas la compter deux fois.
* **PP-02** : montant déduit de PP-01 (« 15 milliards d'euros, à verser
  sur la fiche de paie »). La baisse de CSG relève le salaire net sans
  changer le coût du travail.
* **PP-03** : 6 Md€, période non précisée par toutes les sources ; retenus
  par an. Le modèle commun en retire les prélèvements qui reviennent
  aussitôt (CSG-CRDS, retenue pour pension, impôt sur le revenu).
* **PP-04** : 6 Md€ pour un million de voitures, sans période ; retenu sur
  le quinquennat. Variante évaluée par la synthèse : un million de voitures
  et 6 Md€ par an.
* **PP-05** : la position a varié (« pas un totem » en juin 2026, « ce
  sera 62 ans » en octobre) ; retenue celle d'octobre.

Le modèle applique ses propres hypothèses de comportement (fuite fiscale,
multiplicateur, incidence des prélèvements) aux montants annoncés, comme
pour tous les programmes.

## Résultats (scénario central, 2035)

| | Sans programme | Place publique |
|---|---|---|
| Déficit public (moteur de demande) | 9,38 % du PIB | 11,94 % |
| Déficit public (offre / équilibre) | 9,41 % / 9,38 % | 12,05 % / 11,98 % |
| Dette publique | 157,2 % du PIB | 171,3 % |
| Chômage | 7,91 % | 7,57 % |
| Indice de développement humain | 0,9392 | 0,9387 |

Effet de chaque mesure prise isolément (moteur de demande) :

| Mesure | Déficit 2035 | Chômage 2035 | Emplois 2035 |
|---|---|---|---|
| PP-01 Taxe sur les méga-héritages | −0,75 pt | +0,01 pt | −5 500 |
| PP-02 Baisse de la CSG sur les salaires | +0,48 pt | −0,09 pt | +30 400 |
| PP-03 Enseignants | +0,16 pt | −0,02 pt | +7 100 |
| PP-04 Leasing social | +0,04 pt | −0,01 pt | +4 400 |
| PP-05 Retraite à 62 ans | +2,01 pt | −0,15 pt | −609 600 |
| PP-06 Service civique obligatoire | +0,12 pt | −0,06 pt | +22 500 |
| PP-07 Aide au développement à 0,7 % | +0,44 pt | ≈ 0 | ≈ 0 (versements à l'étranger, sans effet sur la demande intérieure) |
| PP-08 Chèque énergie à 500 €, taxe sur les superprofits | +0,04 pt | −0,03 pt | +11 200 |

Le retour à 62 ans fait l'essentiel du coût : il réduit la population
active (d'où moins d'emplois mais un chômage plus faible) et accroît les
pensions. L'échange entre la taxe sur les héritages et la baisse de CSG
réduit le déficit à terme (−0,27 point en 2035) : les droits de succession
suivent le flux successoral, qui croît plus vite que les salaires
(hausse des décès, barème non indexé), et pèsent moins sur l'activité que
la CSG. La variante du leasing social à un million de voitures par an
ajoute 0,18 point de déficit. Depuis octobre 2026, le modèle commun compte
l'aubaine des aides à l'électrique : une aide de 6 000 € réservée aux
ménages modestes rend électriques ≈ 50 % des achats qui ne l'auraient pas
été, moins la part des ventes déjà électrique ; la dépense porte sur toutes
les voitures aidées. Le déficit ne baisse pas chaque année.

## Non modélisé (sans montant ni paramètre)

* **Fiscalité** : soutien à la taxe Zucman ou à « tout autre mécanisme »
  sur les très hauts patrimoines, impôt sur la fortune « à seuil élevé,
  sans exemption » (communiqué du 2 septembre 2025) ; prélèvement
  forfaitaire unique de 30 % à 34 % ; fin de l'effacement des plus-values
  latentes ; taxe sur le commerce
  en ligne, hausse de la taxe sur les services numériques ; taxe sur les
  boissons sucrées ; taxe progressive sur les logements vacants ;
  annulation de la hausse de l'accise sur l'électricité de 2024.
* **Travail** : SMIC à 1 600 € net « dans les deux ans » (Acte 1, p. 40,
  non repris dans la campagne de 2026, et qui recouperait la baisse de CSG
  de PP-02) ; 1 700 € net dans le plan de sortie de crise du 22 octobre
  2026, selon un site non officiel seulement (aucune source primaire ni
  article de presse trouvés) ; stages payés 1 000 € par mois ;
  régularisation de 300 000 travailleurs ; conférences salariales par branche ; point d'indice indexé
  sur l'inflation ; abrogation de la réforme de l'assurance chômage ;
  Territoires zéro chômeur généralisés.
* **Retraites** : pénibilité et espérance de vie en bonne santé ; Haut
  Conseil du pilotage des retraites à majorité de partenaires sociaux.
* **Écologie** : « 100 jours de la révolution écologique », à chiffrer
  lors de leur présentation ; MaPrimeRénov' relancée ; plan rail ;
  nouveaux EPR ; baisse de 20 centimes à la pompe par l'encadrement des
  marges.
* **École, santé, logement** : loi de programmation pour l'école (moins
  d'élèves par classe en primaire, bâti, plan « bâtisseurs » dit chiffré
  « en milliards sur dix ans » sans montant publié) ; passeport « Colo pour
  tous » (un séjour collectif par enfant pendant la scolarité, sans coût
  annoncé) ; fin de la tarification à l'acte
  à l'hôpital, santé mentale des jeunes, statut des proches aidants ; fonds
  national pour le foncier, encadrement des loyers, régulation des meublés
  touristiques.
* **Justice, égalité** : police de proximité, lutte contre le narcotrafic ;
  loi intégrale contre les violences sexuelles ; statut des parents solos.
* **Défense, Europe** : fonds européen de défense de 500 Md€ par emprunt
  commun (hors budget national) ; réserve opérationnelle accrue ; aucun objectif de dépense en % du PIB.
* **Budget** : aucune cible de déficit pour 2027 ni engagement sur les
  3 % ; la trajectoire de 120 Md€ d'économies sur cinq ans (septembre
  2025) répondait au budget 2026 et n'est pas reprise.

## Points de vigilance

* Les propositions de la campagne européenne de 2024 (fonds de défense de
  100 Md€, impôt européen sur les grandes fortunes, ticket climat) sont
  dépassées et ne sont pas transcrites.
* Le contre-budget des députés socialistes (16 septembre 2026 : CSG
  progressive, CSG sur les héritages, taxe Zucman, taxe numérique) est
  transcrit dans `Programmes/PS/`, pas ici.
