# 🌲Arborescence de St Quentin
Arborescence de St Quentin est une application interactive développée dans le cadre du projet de fin d'année (A3). Elle permet de recenser, visualiser et analyser la végétation de la ville de St Quentin, tout en intégrant des outils de prédiction basés sur l'inteeligence artificielle. 

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

## 📋 2.Visualisation dynamique des données (Tableau AJAX)

## ➕ 3.Système d'Ajout d'Arbre

## 🤖 4. Prédiction de l'âge par IA (Script Python Machine Learning)

## 🫧 5. Analyse par clusters

## 🔌 6. Architecture API interne
