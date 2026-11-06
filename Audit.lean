import Engagements
import Lean

/-!
# Audit des axiomes

`lake env lean Audit.lean` — lancé en CI.

Parcourt toutes les déclarations des bibliothèques du dépôt et échoue si
l'une d'elles dépend d'un axiome hors de la base standard de Lean. Cela
attrape notamment :
* `sorryAx` — une preuve ou une définition laissée en `sorry` ;
* `Lean.ofReduceBool` — `native_decide`, qui fait confiance au compilateur
  plutôt qu'au noyau ;
* tout `axiom` ajouté dans le dépôt (une hypothèse doit être une donnée,
  jamais un axiome).

Complément indispensable : `leanchecker`, lancé sur tous les modules
compilés du dépôt (voir `scripts/ci_locale.sh`), qui rejoue chaque
déclaration dans le noyau. Une preuve fausse ajoutée en
contournant le noyau ne dépend d'aucun axiome interdit : seul le rejeu la
détecte.
-/

open Lean Elab Command

namespace Audit

def axiomesAutorises : List Name := [``propext, ``Classical.choice, ``Quot.sound]

def bibliotheques : List Name := [`Modele, `Hypotheses, `Proprietes, `Programmes, `Engagements]

elab "#auditer_axiomes" : command => do
  let env ← getEnv
  let mut nb : Nat := 0
  let mut fautes : Array String := #[]
  for (n, _) in env.constants.map₁.toList do
    let some idx := env.getModuleIdxFor? n | continue
    let some mod := env.header.moduleNames[idx.toNat]? | continue
    unless bibliotheques.any (·.isPrefixOf mod) do continue
    nb := nb + 1
    let axs ← collectAxioms n
    let interdits := axs.filter (!axiomesAutorises.contains ·)
    unless interdits.isEmpty do
      fautes := fautes.push s!"{n} ({mod}) : {interdits.toList}"
  if nb == 0 then
    logError "Audit : aucune déclaration trouvée, la liste des bibliothèques est-elle à jour ?"
  else if fautes.isEmpty then
    logInfo m!"Audit OK : {nb} déclarations, axiomes standard uniquement."
  else
    logError m!"Axiomes interdits :\n{"\n".intercalate fautes.toList}"

end Audit

#auditer_axiomes
