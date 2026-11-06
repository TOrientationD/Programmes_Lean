import Modele

/-!
# Moteur contribué « ExempleEquilibre » (exemple, modèle de dossier)

Lecture intermédiaire entre les moteurs « demande » et « offre » du socle :
les économies de dépense gardent les trois quarts de leur effet de demande,
et chaque point de prélèvements obligatoires au-dessus du niveau de départ
retire 0,05 point de croissance par an ; le canal du capital (investissement
public et IS sur le PIB potentiel, `Hypotheses/Economie.lean`) joue pour
moitié. Les effets de demande des mesures s'estompent comme dans ThreeME
(Trésor-Éco n° 394, juillet 2026, tableau 1) : pour 1 point de PIB de
dépense publique, 0,90 point à 5 ans, 0,80 à 10 ans et 0,45 à long terme,
soit une part durable de moitié ; la part qui s'en va se résorbe de 3 %
par an, ce qui redonne ≈ 0,88 fois l'effet initial à 10 ans (0,80 / 0,90
dans ThreeME, calcul).

Copier ce dossier pour proposer son propre moteur ; expliquer ici les choix
et leurs sources. Les paramètres disponibles sont ceux de
`Modele.Moteur` ; en demander d'autres relève d'une issue « modèle commun ».
-/

namespace Moteurs.ExempleEquilibre

def moteur : Modele.Moteur where
  id := "ExempleEquilibre"
  nom := "Exemple équilibre"
  description := "Économies aux trois quarts du multiplicateur ; +1 point de prélèvements obligatoires retire 0,05 point de croissance par an ; canal du capital pour moitié ; effets de demande à moitié durables (ThreeME) (exemple)"
  multiplicateurEconomiesPm := 750
  multiplicateurPrelevementsPm := 1000
  elasticiteCroissancePoPm := 50
  canalCapitalPm := 500
  resorptionDemandePm := 30
  partDemandeDurablePm := 500

end Moteurs.ExempleEquilibre
