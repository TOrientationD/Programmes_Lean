import Modele

namespace Proprietes
open Modele

/-- La consommation d'espaces naturels, agricoles et forestiers de 2021 à
2030, hors surfaces qu'une exemption légale sort du décompte, tient dans
l'enveloppe de la première tranche du ZAN (la moitié de la consommation
2011-2021). -/
abbrev ZanEnveloppe20212031 (H : Scenario) (_tendanciel s : Etat) : Prop :=
  s.surfacesHa.totalEnaf - s.surfacesHorsZanHa ≤ H.sols.enveloppeHa

def zanEnveloppe : Propriete :=
  .mk' "zan-enveloppe-2031" "ZAN : enveloppe 2021-2031 respectée"
    "Les espaces naturels, agricoles et forestiers consommés du 1er janvier 2021 au 1er janvier 2031 ne dépassent pas la moitié de la consommation 2011-2021 (loi Climat et résilience, art. 191 et 194)."
    ZanEnveloppe20212031 (annee := some 5)

end Proprietes
