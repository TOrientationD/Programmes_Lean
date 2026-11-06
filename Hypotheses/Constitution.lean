import Modele

/-!
# Constitution et lois organiques : textes de référence

Normes de rang constitutionnel ou organique que les propriétés
`constitution-*` (`Proprietes/Constitution.lean`) traduisent en critères
vérifiables sur les trajectoires. Le modèle ne connaît ni les barèmes ni
les procédures : les critères sont des garde-fous chiffrés, écrits avec
leur simplification, et deux d'entre eux reposent sur des déclarations du
programme (taux marginal maximal, révisions de la Constitution). Une
propriété perdue ne vaut pas inconstitutionnalité : elle signale ce que le
Conseil constitutionnel ou le Haut Conseil des finances publiques
examineraient.

Autres normes constitutionnelles déjà couvertes par des propriétés :
alinéa 5 du Préambule de 1946 (droit d'obtenir un emploi : « chômage non
dégradé »), Charte de l'environnement, art. 1 à 6, et loi européenne sur le
climat (propriétés climat), art. 88-1 (textes européens, propriétés
`ue-*`). Non retenues faute de grandeur dans le modèle : art. 72-2
(autonomie financière des collectivités : la loi organique n° 2004-758 fixe
un plancher de ressources propres par catégorie), art. 47-2 (sincérité des
comptes), art. 1er et 6 de la DDHC (égalité devant la loi et l'impôt, hors
caractère confiscatoire).
-/

namespace Hypotheses.Constitution

structure TexteConstitutionnel where
  id : String
  titre : String
  reference : String
  critere : String
  deriving Repr

/-- Seuil au-delà duquel un taux marginal d'imposition est tenu pour
confiscatoire, pm : le Conseil constitutionnel a censuré un taux marginal
maximal de 75 % (contribution exceptionnelle de solidarité, décision
n° 2012-662 DC du 29 décembre 2012, cons. 73) et des taux de 68,34 % à
82 % sur certains revenus (même décision, cons. 51 à 53, 81), et admis
64,5 % (décision n° 2013-685 DC du 29 décembre 2013, cons. 23 : « n'excède
pas un taux de 64,5 % ») ; la doctrine situe le seuil implicite entre 66 et
70 % ; 70 % retenu (hypothèse). -/
def seuilConfiscatoirePm : Int := 700

/-- Objectif à moyen terme de solde structurel, pb du PIB : −0,4 % (loi de
programmation des finances publiques 2023-2027, loi n° 2023-1195, art. 2 ;
TSCG, art. 3 : au plus −0,5 % ; loi organique n° 2012-1403, art. 1er). -/
def objectifMoyenTermePb : Int := -40

/-- Tolérance sur les dépenses par tête en volume (retraites par personne de
65 ans et plus, enseignement par habitant) avant de tenir la garantie
constitutionnelle pour dégradée, pm : 5 % (hypothèse : arrondis,
indexation des pensions sur les prix à la consommation quand le modèle
déflate par le déflateur du PIB). -/
def tolerancePm : Int := 50

def textes : List TexteConstitutionnel := [
  { id := "constitution-art-89"
    titre := "Constitution inchangée"
    reference := "Constitution, art. 89 (révision : vote des deux assemblées en termes identiques, puis référendum ou Congrès à la majorité des trois cinquièmes) ; art. 11 (référendum législatif, qui ne peut réviser la Constitution : décision n° 62-20 DC, pratique de 1962 contestée)"
    critere := "Le programme ne déclare aucune mesure exigeant une révision de la Constitution (levier `revisionConstitution`, déclaratif)" },
  { id := "constitution-ddhc-13"
    titre := "Imposition non confiscatoire"
    reference := "Déclaration de 1789, art. 13 (contribution « également répartie entre tous les citoyens, en raison de leurs facultés ») ; décisions n° 2012-662 DC (75 % censuré) et n° 2013-685 DC (64,5 % admis)"
    critere := "Le taux marginal maximal d'imposition d'un revenu, toutes impositions confondues, reste sous 70 % (55,4 % au départ pour un salaire ; relevé par les mesures qui le déclarent, levier `tauxMarginalSommet`)" },
  { id := "constitution-preambule-11"
    titre := "Sécurité matérielle des personnes âgées"
    reference := "Préambule de 1946, alinéa 11 (« moyens convenables d'existence » pour qui ne peut plus travailler ; exigence constitutionnelle de protection, décision n° 2010-617 DC)"
    critere := "À l'horizon, la dépense de retraite en volume par personne de 65 ans et plus n'est pas inférieure de plus de 5 % à celle de l'année de départ (part des 65 ans et plus interpolée de la référence à l'hypothèse démographique)" },
  { id := "constitution-preambule-13"
    titre := "Égal accès à l'instruction"
    reference := "Préambule de 1946, alinéa 13 (« l'organisation de l'enseignement public gratuit et laïque à tous les degrés est un devoir de l'État »)"
    critere := "À l'horizon, la dépense d'enseignement en volume par habitant n'est pas inférieure de plus de 5 % à celle de l'année de départ (la population d'âge scolaire baisse : critère prudent)" },
  { id := "constitution-lo-omt"
    titre := "Objectif de moyen terme de solde structurel"
    reference := "Loi organique n° 2012-1403 du 17 décembre 2012, art. 1er (prise par l'art. 34 de la Constitution) ; TSCG, art. 3 ; objectif de −0,4 % du PIB (loi n° 2023-1195, art. 2)"
    critere := "Dix ans après le départ, le déficit structurel (déficit corrigé de l'écart de production à la semi-élasticité de 0,57) est au plus de 0,4 % du PIB" }
]

end Hypotheses.Constitution
