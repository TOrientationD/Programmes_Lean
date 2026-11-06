import Proprietes.Finances
import Proprietes.Emploi
import Proprietes.Climat
import Proprietes.Europe
import Proprietes.Constitution
import Proprietes.Developpement
import Proprietes.Sols
import Proprietes.Lois

/-!
# Registre des propriétés partagées

Toute propriété listée dans `toutes` est évaluée pour chaque programme sous
chaque scénario. Ajouter une propriété : un fichier (ou un ajout dans un
fichier thématique) + une ligne ici.
-/

namespace Proprietes

def toutes : List Modele.Propriete :=
  [deficit, dette, chomage, emissions, deficit2035, equilibre2035, deficitEnBaisse, dette2035, air, bornes2035, emploisAnnonces,
   balanceCourante, accidentsTravail, snbcSecteurs2030, budgetCarbone4, parcElectrique2030, zanEnveloppe, idh,
   lpm, ppe3Capacites2030, electriciteRenouvelable2030] ++ europeennes ++ constitutionnelles

end Proprietes
