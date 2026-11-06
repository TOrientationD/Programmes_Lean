"""Table de correspondance entre les concepts du projet et leurs définitions
Lean, reprise en annexe des synthèses PDF et du programme complet.

Chaque ligne nomme une déclaration Lean et le fichier qui la contient.
`verifier()` relit ces fichiers à chaque génération : un nom renommé ou
déplacé est signalé (sur la sortie d'erreur et dans le PDF, « introuvable »)
au lieu de laisser la table devenir fausse sans bruit.
"""
from __future__ import annotations

import re
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent

# (concept, en clair, nom Lean complet, fichier). Un nom vide : le concept
# est un fichier entier, sans déclaration unique.
GLOSSAIRE: list[tuple[str, str, str, str]] = [
    # Programmes et mesures
    ("Programme", "Ensemble de mesures d'un auteur, avec ses engagements et ses arbitrages.",
     "Modele.Programme", "Modele/Programme.lean"),
    ("Registre des programmes", "Liste des programmes évalués ; un programme absent n'est pas calculé.",
     "Programmes.tous", "Programmes.lean"),
    ("Mesure", "Une proposition : titre, source, leviers, année d'entrée en vigueur.",
     "Modele.Mesure", "Modele/Programme.lean"),
    ("Levier", "Effet élémentaire d'une mesure : dépense, impôt, postes, durée du travail, âge légal…",
     "Modele.Levier", "Modele/Leviers.lean"),
    ("Effet d'un levier", "Ce que le levier change dans l'état de l'économie, une année donnée.",
     "Modele.Levier.appliquer", "Modele/Leviers.lean"),
    ("Variante", "Même intention, autres paramètres ; chiffrée à part, hors de l'évaluation.",
     "Modele.Variante", "Modele/Programme.lean"),
    ("Statut", "Place dans une négociation : rubicon, paramétrable, négociable.",
     "Modele.Statut", "Modele/Programme.lean"),
    ("Thématique", "Domaine de la mesure (fiscalité, santé, transports…).",
     "Modele.Domaine", "Modele/Programme.lean"),
    # Économie et hypothèses
    ("État de l'économie", "Une année : PIB, emploi, impôts, dépenses, dette, émissions, énergie, sols.",
     "Modele.Etat", "Modele/Etat.lean"),
    ("Unités", "Nombres entiers : M€, points de base (300 = 3 %), pour mille, mois.",
     "Modele.ratioPb", "Modele/Unites.lean"),
    ("Scénario", "Jeu d'hypothèses : démographie, natalité, économie, énergie, droit, sols.",
     "Modele.Scenario", "Modele/Scenario.lean"),
    ("Les scénarios", "Toutes les combinaisons d'hypothèses sous lesquelles chaque programme est calculé.",
     "Hypotheses.tous", "Hypotheses/Scenarios.lean"),
    ("Scénario central", "Hypothèses de référence des tableaux et des courbes.",
     "Hypotheses.central", "Hypotheses/Scenarios.lean"),
    ("Moteur économique", "Modèle macroéconomique : réponse de l'activité aux mesures (demande, offre, équilibre).",
     "Modele.Moteur", "Modele/Moteur.lean"),
    ("Registre des moteurs", "Moteurs du dépôt et moteurs contribués.",
     "Moteurs.tous", "Moteurs.lean"),
    ("Bloc de demande", "Le PIB par la demande : consommation, investissement, dépense publique, exportations, importations, chacune par son équation.",
     "Modele.resoudre", "Modele/Demande.lean"),
    ("Canal de demande", "Voie par laquelle une mesure agit sur la demande (dépense publique, transferts, TVA…) ; chaque canal a son multiplicateur.",
     "Modele.Canal", "Modele/Demande.lean"),
    ("Écarts de demande", "Écart au tendanciel de chaque composante de la demande, des prix, des salaires et de l'emploi, une année.",
     "Modele.EcartsDemande", "Modele/Demande.lean"),
    ("Paramètres du bloc de demande", "Coefficients des équations (Mésange, FR-BDF, e-mod.fr), avec leurs sources.",
     "Hypotheses.Eco.parametresDemande", "Hypotheses/Economie.lean"),
    ("Contentieux", "Flux d'affaires nouvelles, stock d'affaires en cours et capacité de jugement d'une juridiction.",
     "Modele.Justice.Contentieux", "Modele/Justice.lean"),
    ("Délai d'écoulement du stock", "Durée de traitement approchée : 12 × stock / affaires terminées, en mois, année par année.",
     "Modele.Justice.delais", "Modele/Justice.lean"),
    ("Équipe de justice", "Renfort type (magistrats, greffiers, autres agents) et nombre d'affaires qu'il traite par an.",
     "Modele.Justice.Equipe", "Modele/Justice.lean"),
    ("Données de la justice", "Coûts, effectifs, flux d'affaires et délais sourcés (prud'hommes, matière civile, cours criminelles).",
     "Hypotheses.Justice.prudhommes", "Hypotheses/Justice.lean"),
    # Projection
    ("Situation de départ", "L'économie l'année de départ, tirée des comptes observés.",
     "Modele.etatDepart", "Modele/Projection.lean"),
    ("Année suivante", "Le passage d'une année à la suivante : croissance, prix, impôts, dépenses, dette.",
     "Modele.anneeSuivante", "Modele/Projection.lean"),
    ("Trajectoire sans programme", "Le tendanciel : la projection quand aucune mesure n'est appliquée.",
     "Modele.tendancielA", "Modele/Projection.lean"),
    ("Trajectoire du programme", "La même projection, mesures appliquées année par année.",
     "Modele.Programme.trajectoire", "Modele/Programme.lean"),
    # Vérifications
    ("Propriété", "Critère partagé : déficit sous 3 %, dette, règles européennes, Constitution, climat.",
     "Modele.Propriete", "Modele/Propriete.lean"),
    ("Liste des propriétés", "Les propriétés évaluées pour tous les programmes.",
     "Proprietes.toutes", "Proprietes.lean"),
    ("Propriété vérifiée", "La propriété tient pour ce programme, sous ce moteur et ce scénario.",
     "Modele.Programme.Verifie", "Modele/Programme.lean"),
    ("Engagement", "Propriété qu'un programme revendique sous un scénario et un moteur.",
     "Modele.Engagement", "Modele/Programme.lean"),
    ("Engagements tenus", "Tous les engagements du programme sont vrais.",
     "Modele.Programme.EngagementsTenus", "Modele/Programme.lean"),
    ("Preuve des engagements", "Un théorème pour tous les programmes ; s'il casse, la CI échoue.",
     "Engagements.tous_tenus", "Engagements.lean"),
    ("Contrat de mesure", "Propriété du dispositif démontrée pour tous les cas (« pour toute commune… »).",
     "Modele.Contrat", "Modele/Programme.lean"),
    ("Cohérence interne", "Aucune paire de mesures contradictoires non arbitrée.",
     "Modele.Programme.coherent", "Modele/Coherence.lean"),
    ("Conflit", "Deux mesures qui fixent un réglage à deux valeurs, ou le déplacent en sens opposés.",
     "Modele.Conflit", "Modele/Coherence.lean"),
    ("Arbitrage", "Paire de mesures opposées déclarée voulue par l'auteur, avec sa raison.",
     "Modele.Arbitrage", "Modele/Programme.lean"),
    ("Rétro-test", "Le modèle rejoue les années observées et mesure son erreur.",
     "Modele.retroUnAn", "Modele/Retro.lean"),
    ("Multiplicateurs par canal", "Effet d'un choc d'un point de PIB, comparé aux variantes publiées de Mésange, FR-BDF et e-mod.fr.",
     "Tests.Demande.multiplicateurs_differencies", "Tests/Demande.lean"),
    ("Rétro-test de la demande", "Chaque équation de demande prédit l'année suivante, hors échantillon (2017-2025).",
     "Tests.RetroDemande.pib_par_la_demande", "Tests/RetroDemande.lean"),
    ("Années observées", "Comptes publics réels qui servent au rétro-test.",
     "Hypotheses.observations", "Hypotheses/Historique.lean"),
    ("Audit des axiomes", "Aucune preuve laissée en suspens (sorry, native_decide, axiome ajouté).",
     "", "Audit.lean"),
]

_DECL = r"^\s*(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*" \
        r"(?:structure|inductive|def|abbrev|theorem|class|instance)\s+(?:[\w.]*\.)?{nom}\b"


def verifier(racine: Path = RACINE) -> dict[int, str]:
    """Problèmes par ligne du glossaire : fichier absent ou déclaration introuvable."""
    problemes: dict[int, str] = {}
    for i, (_, _, nom, fichier) in enumerate(GLOSSAIRE):
        chemin = racine / fichier
        if not chemin.exists():
            problemes[i] = f"fichier {fichier} introuvable"
            continue
        if not nom:
            continue
        court = nom.rsplit(".", 1)[-1]
        if not re.search(_DECL.format(nom=re.escape(court)), chemin.read_text(encoding="utf-8"),
                         re.MULTILINE):
            problemes[i] = f"{court} introuvable dans {fichier}"
    return problemes


if __name__ == "__main__":
    import sys
    pb = verifier()
    for i, msg in pb.items():
        print(f"{GLOSSAIRE[i][0]} : {msg}", file=sys.stderr)
    print(f"{len(GLOSSAIRE)} concepts, {len(pb)} problème(s)")
    sys.exit(1 if pb else 0)
