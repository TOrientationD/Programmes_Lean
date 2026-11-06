import Modele

/-!
# Hypothèses du sous-modèle automobile

Deux jeux de valeurs, qui encadrent surtout le prix du pétrole. Les valeurs
marquées « hypothèse » sont des ordres de grandeur à sourcer plus
précisément.

Données de cadrage (non utilisées dans le calcul) :
* déficit commercial automobile de la France ≈ 20 Md€ en 2025, dont
  véhicules −14,4 Md€ (Douanes, via Journal de l'Automobile, 6 mars 2026) ;
* 27 % des voitures électriques vendues en France en 2025 y étaient
  fabriquées, 11 % des thermiques (baromètre de l'Institut des Mobilités en
  Transition, via Automobile Propre, 7 juin 2026).
-/

namespace Hypotheses.Automobile
open Modele

/-- Véhicule thermique ancien retiré : 7 L/100 km sur 11 000 km/an. -/
def litresVoitureAncienne : Int := 770

/-- Citadine électrique : 17 kWh/100 km sur 11 000 km/an. RTE (Enjeux du
développement de l'électromobilité, 2019) : 16,6 à 17,0 kWh/100 km
(calcul sur ses hypothèses de batteries et d'autonomie) ; base Car Labelling
de l'ADEME : 14,5 (petite) à 21,2 kWh/100 km (SUV) ; pertes de recharge de
10 à 25 % selon l'ADAC (non comptées). -/
def kwhCitadineElectrique : Int := 1870

def petroleModere : HypAuto where
  id := "auto-petrole-modere"
  description := "Carburant importé à 0,56 €/L, électricité exportée à 59 €/MWh (2025)"
  litresEvitesParAn := litresVoitureAncienne
  valeurImportCarburantCts := 56
  kwhParAn := kwhCitadineElectrique
  valeurExportElecEurMWh := 59
  sources := [
    "Kilométrage et consommation : CCFA, L'industrie automobile française 2025, p. 53-54 (parc 2024 : 11 622 km/an ; gazole 5,93 L/100, essence 6,72 L/100) ; véhicule ancien à 7 L/100 et 11 000 km : hypothèse",
    "Valeur à l'import : cotation Rotterdam ≈ 35 % du prix du gazole (Connaissance des énergies, mars 2026) × 1,60 €/L (hypothèse de prix à la pompe)",
    "Électricité : 17 kWh/100 km (RTE 2019, ADEME Car Labelling) ; 59 €/MWh, valeur des exportations nettes de 2025 au prix français (RTE, Bilan électrique 2025, p. 14 : 92,3 TWh pour 5,4 Md€)"]

def petroleCher : HypAuto where
  id := "auto-petrole-cher"
  description := "Carburant importé à 0,78 €/L (prix d'août 2026), électricité exportée à 80 €/MWh"
  litresEvitesParAn := litresVoitureAncienne
  valeurImportCarburantCts := 78
  kwhParAn := kwhCitadineElectrique
  valeurExportElecEurMWh := 80
  sources := [
    "Valeur à l'import : 35 % × 2,231 €/L, prix du gazole semaine du 24 août 2026 (Weekly Oil Bulletin, via Connaissance des énergies)",
    "Électricité à 80 €/MWh à l'export : hypothèse"]

def toutes : List HypAuto := [petroleModere, petroleCher]

theorem toutes_valides : ∀ h ∈ toutes, h.Valide := by decide +kernel

end Hypotheses.Automobile
