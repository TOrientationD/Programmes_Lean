/-!
# Conventions d'unités

Tout le modèle est en entiers (`Int`). Conséquence voulue : chaque propriété
est décidable et vérifiée par le noyau Lean (`decide`), sans flottants ni
Mathlib, et la CI reste rapide pour les contributeurs externes.

| Grandeur                  | Unité                      | Exemple          |
|---------------------------|----------------------------|------------------|
| montant                   | M€ courants                | `30000` = 30 Md€ |
| taux                      | points de base « pb »      | `300` = 3 %      |
| coefficient sans dimension| pour mille « pm »          | `800` = 0,8      |
| âge                       | mois                       | `768` = 64 ans   |

La division entière de Lean sur `Int` est euclidienne (`-7 / 2 = -4`) :
les arrondis sont donc déterministes et identiques en CI et en local.
-/

namespace Modele

/-- `x` multiplié par un taux exprimé en pb. -/
def appliquerPb (x taux : Int) : Int := x * taux / 10000

/-- `x` multiplié par un coefficient exprimé en pour mille. -/
def appliquerPm (x coef : Int) : Int := x * coef / 1000

/-- Ratio `a / b` en pb (vaut 0 si `b = 0`). -/
def ratioPb (a b : Int) : Int := if b = 0 then 0 else a * 10000 / b

end Modele
