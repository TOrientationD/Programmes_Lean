import Programmes.ExempleRelance.Programme
import Programmes.ExempleConsolidation.Programme
import Programmes.TexteOrientationD.Programme
import Programmes.LFI.Programme
import Programmes.PS.Programme
import Programmes.PCF.Programme
import Programmes.RN.Programme
import Programmes.LR.Programme
import Programmes.Horizons.Programme
import Programmes.Renaissance.Programme
import Programmes.Ecologistes.Programme
import Programmes.PlacePublique.Programme
import Programmes.RevolutionPermanente.Programme
import Programmes.Reconquete.Programme
import Programmes.NouvelleEnergie.Programme

/-!
# Registre des programmes

Ajouter un programme :
1. copier un dossier d'exemple dans `Programmes/<NomDuProgramme>/` et y
   lister son compte GitHub dans `PROPRIETAIRES` ;
2. ajouter son `import` ci-dessus ;
3. l'ajouter à `tous` ci-dessous.

Ses engagements sont alors vérifiés automatiquement par `Engagements.lean`.

`scripts/verifier_registre.py` (lancé en CI) échoue si un dossier de
`Programmes/` n'est pas enregistré ici.
-/

namespace Programmes

def tous : List Modele.Programme := [
  ExempleRelance.programme,
  ExempleConsolidation.programme,
  TexteOrientationD.programme,
  LFI.programme,
  PS.programme,
  PCF.programme,
  RN.programme,
  LR.programme,
  Horizons.programme,
  Renaissance.programme,
  Ecologistes.programme,
  PlacePublique.programme,
  RevolutionPermanente.programme,
  Reconquete.programme,
  NouvelleEnergie.programme
]

end Programmes
