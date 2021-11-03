
# IF-4-ALIA-OTHELLO

## Liste des heuristiques possibles

1.  Mobilité immédiate (nombre de mouvements possibles)
2.	Domination des coins (Les coins sont stables / ils ne peuvent pas être tournés et ont donc une importance spéciale)
3.	Stabilité (le nombre de disque ne pouvant être tournés)
4.	La parité des coins
5.	Les disques X. Placer des disques sur les cases B2, B7, G2 et G7, donne le possibilité à l'adversaire d'obtenir les coins. Doit avoir un poid négatif.
6.	Les disques C. A2, A7, B1, G1, H2, H7, B8, et G8. Ces emplacements ouvrent les coins à l'adversaire.

On Pourra créer une combinaison linéaire de ces facteurs afin d'obtenir une bonne heuristique.


## Faire fonctionner les tests python
1. Créer environnement virtuel environnemebt
    `python3 -m venv /path/to/new/virtual/environment`
2. Activer virtual virtuel environnemebt
   `source /path/to/new/virtual/environment/bin/activate`
3. Installer dépendance
   `pip install -r requirements.txt`
4. Remplir correctement le fichier parameters.json
5. Lancer le python
   `python3 Main_Test.py`
6. Les résultats sont afffiché dans un fichier result.json
