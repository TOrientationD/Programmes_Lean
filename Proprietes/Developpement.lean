import Modele

/-!
# Développement humain

L'indice de développement humain (IDH, formule du PNUD : espérance de vie,
scolarisation, RNB par habitant en volume) est calculé chaque année par le
modèle commun (`Modele/Idh.lean`).
-/

namespace Proprietes
open Modele

/-- L'IDH à l'horizon n'est pas inférieur à celui du tendanciel. -/
abbrev IdhNonDegrade (_H : Scenario) (a s : Etat) : Prop :=
  a.idhMillioniemes ≤ s.idhMillioniemes

def idh : Propriete :=
  .mk' "idh-non-degrade" "IDH non dégradé"
    "L'indice de développement humain à l'horizon (espérance de vie, scolarisation, RNB par habitant en volume) est au moins celui du tendanciel."
    IdhNonDegrade

end Proprietes
