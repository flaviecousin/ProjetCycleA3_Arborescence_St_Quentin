# 🌲Arborescence de St Quentin
Arborescence de St Quentin est une application interactive développée dans le cadre du projet de fin d'année (A3). Elle permet de recenser, visualiser et analyser la végétation de la ville de St Quentin, tout en intégrant des outils de prédiction basés sur l'inteeligence artificielle. 

![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white)

![RStudio](https://img.shields.io/badge/RStudio-%234285F4.svg?style=for-the-badge&logo=rstudioide&logoColor=white)
![Google Colab](https://img.shields.io/badge/Google%20Colab-%23F9A825.svg?style=for-the-badge&logo=googlecolab&logoColor=black)
![Jupyter Notebook](https://img.shields.io/badge/jupyter-%23FA0F00.svg?style=for-the-badge&logo=jupyter&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)

![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)
![Python](https://img.shields.io/badge/python-%233670A0.svg?style=for-the-badge&logo=python&logoColor=ffdd54)
![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white)
![CSS](https://img.shields.io/badge/css-%23663399.svg?style=for-the-badge&logo=css&logoColor=white)
![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E)
![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)

# 🚀 Fonctionnalités
### - Carte interactive
Visualisation géographique des arbres via Mapbox et Plotly. Chaque point affiche des informations détaillées (espèce, hauteur, état).
### - Gestion de base de données
Consultation en temps réel de la liste des arbres et ajout de nouveaux spécimes via un formulaire dédié
### - Intelligence artificielle
#### => Prédiction de l'âge :
Estimation de l'âge d'un arbre sélectionné via un modèle Machine Learning exécuté en Python
#### => Analyse par clusters :
Visualisation des regroupements d'arbres sur le territoire
### - Interface responsive :
Design épuré avec une navigation fluide entre l'accueil, la carte et les outils de prédiction

# 🛠️ Stack technique
## Frontend
### - HTML/CSS :
Mise en page structurée et design personnalisé
### - JavaScript :
Gestion des requêtes asynchrones (AJAX) et manipulation dynamique du DOM
### - Plotly.js & Mapbox :
Rendu de la cartographie haute précision

## Backend
### - PHP ;
Moteur de l'application et gestion de la logique serveur
### - PDO (MySQL) :
Interface sécurisée pour la base de données (requêtes préparées)
### - Python 3 :
Scripts d'analyse de données et modèles de prédiction (Scikit-learn)

# ⚙️ Installation & Configuration
## 1. Prérequis
- Un serveur local (WAMP, MAMP ou XAMPP)
- Une base de donnée MySQL
- Python installé avec les dépendances nécessaires (scikit-learn, pandas)

## 2. Configuration de la base de données
Importez votre schéma SQL et configurez les accès dans le fichier database.php :
```Bash
define ('DB_USER', "votre_utilisateur");
define ('DB_PASSWORD', "votre_mdp");
define ('DB_NAME', "votre_base");
define ('DB_SERVER', "127.0.0.1");
```

## 3. Clé API Mapbox
Pour que la carte s'affiche, assurez-vous que votre jeton d'accès est valide dans map_info.js :
```Bash
mapboxAccessToken: "votre_cle_mapbox"
```

# 🗂️ Structure du projet
- database.php : fonctions de connexion et requêtes SQL
- map_info.php : API interne retournant les données des arbres au format JSON
- predictions.php : pont entre l'interface web et le script python
- age.py : modèle de prédiction
- js/ : scripts pour l'interactivité et les appels AJAX
- css/ : feuilles de style pour chaque page

# 🧩 Features
## 📍 1. Cartographie interactive (Mapbox & Plotly)
Coeur visuel du projet, au lieu d'une simple liste, les arbres sont projetés sur une carte réelle de Saint Quentin.
#### - Fonctionnement :
Le script map_info.js récupère les coordonnées GPS (latitude/longitude) via une requête AJAX.
#### - Interactivité :
Au survol d'un point, une infobulle (tooltip) affiche la fiche d'identité de l'arbre : son espèce, sa hauteur totale, son diamètre et son stade de développement.
#### - Techique :
Utilisation de la bibliothèque Plotly combinée à un fond de carte Mapbox pour un rendu professionnel et fluide.

## 📋 2. Visualisation dynamique des données (Tableau AJAX)
Sous la carte, un tableau répertorie l'ensemble des données brutes de la base de données. 
#### - Fonctionnement :
Le tableau est généré dynamiquement. Cela signifie que si vous ajoutez un arbre dans la base de données, il apparaît instantanément dans le tableau sans avoir besoin de recharger toute la page.
#### - Sélection :
Chaque ligne possède un bouton Radio qui permet à l'utilisateur de sélectionner un arbre spécifique pour effectuer des analyses plus poussées (comme la prédiction d'âge).

## ➕ 3. Système d'Ajout d'Arbre
Le site web permet d'enrichir la base de données via une interface dédiée (add_tree.html).
#### - Fonctionnement :
Un formulaire complet permet de saisir toutes les caractéristiques : emplacement, mesures (tronc, hauteur), type de feuillage et état de santé.
#### - Sécurité :
Les données sont envoyées au script database.php qui utilise des requêtes préparées (PDO). Cela protège le site contre les injections SQL (une faille de sécurité majeure).

## 🤖 4. Prédiction de l'âge par IA (Script Python Machine Learning)
C'est la fonctionnalité "intelligente" du projet. Elle permet d'estimer l'âge d'un arbre même si cette information n'est pas connue.
#### - Le Modèle :
Utilisation d'un algorithme de Machine Learning appelé SVM (Support Vector Machine)
#### - Le Processus :
a. L'utilisateur sélectionne un arbre dans le tableau.
b. PHP récupère l'identifiant et appelle un script Python (age.py) via la commande shell_exec/
c. Le script Python traite les dimensions de l'arbre (diamètre, hauteur) et renvoie une estimation de l'âge.
d. Le résultat est renvoyé à l'interface via une alerte JavaScript

## 🫧 5. Analyse par clusters
Cette fonctionnalité permet de mieux comprendre la répartition de la végétation en ville.
#### - Objectif :
Identifier des zones de forte densité d'arbres (bosquets, parcs) ou regrouper les arbres par similarités de caractéristiques.
#### - Utilité :
Pour une municipalité, cela permet de voir quelles zones sont bien boisées et lesquelles manquent de verdure.

## 🔌 6. Architecture API interne
Le projet est construit de manière moderne avec une séparation entre les données et l'affichage.
#### => JSON :
Le fichier map_info.php agit comme une petite API. Il ne renvoie pas du texte brut, mais du format JSON. C'est le langage universel pour échanger des données entre un serveur et un navigateur web.
