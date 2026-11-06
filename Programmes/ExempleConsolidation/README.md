# Exemple consolidation (fictif)

> Programme **fictif** fourni comme modèle de dossier. Il ne représente aucun
> parti ; les montants sont arbitraires.

`Programme.lean` contient les mesures (leviers, montants, source) et les
engagements revendiqués. Ces engagements sont vérifiés par le noyau Lean à
chaque build (`Engagements.lean` à la racine).

Particularité : l'engagement sur la dette porte sur **tous** les scénarios du
dépôt (`tous.map …`). Toute nouvelle hypothèse ajoutée par quelqu'un d'autre
est donc automatiquement vérifiée contre cet engagement.

Mainteneurs : voir `CODEOWNERS`.
