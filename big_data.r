# Appellations des librairies utiles pour le projet
library (dplyr) # pour suppression (fonction subset)
library(Hmisc) # installation nécessaire pour l'utiliser, utilisé pour la fonction describe
library(ggplot2) # pour créer des histogrammes
library(tidyr) # pour compléter des cellules vides
library(gridExtra) # pour séparer l'écran graphique en 2
library(stringr) # pour manipuler les chaînes de caractères
library(scales) # pour formater les étiquettes du pie chart
library(questionr) # pour la création de tableaux de synthèse

# ---------------------- Fonctionnalité 1 ----------------------

# Séparation en colonnes
data <- read.csv2(file = "Patrimoine_Arboré_(RO).csv",header=TRUE,sep=',',dec='.',stringsAsFactors = TRUE)
# Suppressions des arbres mesurant 0 cm
data2 <- subset(data,haut_tot!=0)
data2<-subset(data2,tronc_diam!=0)
# Suppressions des lignes en double
data3 <- distinct(data2)
# Suppressions des valeurs manquantes dans la colonne 'tronc_diam'
data3<-subset(data3,tronc_diam!='')
data3<-subset(data3,haut_tronc!='')

# Suppression de colonnes
data4<-data3 %>% select(-one_of('created_user','src_geo','fk_port','fk_pied','fk_situation','fk_revetement','commentaire_environnement','dte_plantation','clc_nbr_diag','dte_abattage','fk_nomtech','last_edited_user','last_edited_date','villeca','nomfrancais','nomlatin','CreationDate','Creator','EditDate','Editor'))

# Description des variables quantitatives, pas assez précis pour les variables qualitatives
summary(data4)
# Description des variables qualitatives plus précises
describe(data4)

# Données vides
data4<- data4 %>%
  arrange(OBJECTID) %>%
  fill(created_date,.direction="down")
data4<- data4 %>%
  fill(clc_quartier,.direction="down")

data5 <- data4
# On enlève le "Quartier" et ses déterminants au début des noms de quartiers
data5 <- data5 %>%
  mutate(across(everything(), ~ str_replace_all(., c("Quartier" = "", "du " = "", "de " = "", "l'" = ""))))

# On remplace les mots "enlevé", "éssouché"
data5$fk_arb_etat <- str_replace_all(data3$fk_arb_etat , c("Essouché" = "ABATTU","Non essouché"="ABATTU","REMPLACÉ"="ABATTU","SUPPRIMÉ"="ABATTU"))

# Suppressions des secteurs où on ne peut pas retrouver le nom du quartier correspondant
data5<-subset(data5,clc_secteur!='')
data5<-subset(data5,fk_stadedev!='')
data5<-subset(data5,remarquable!='')
data5<-subset(data5,age_estim!='')
data5<-subset(data5,clc_quartier!='')
data5<-subset(data5,feuillage!='')
data5<-subset(data5,clc_secteur!="Déchetterie route d'Omissy")
data5<-subset(data5,clc_secteur!='Déchetterie route Chauny')
data5<-subset(data5,clc_secteur != "Bassin Ep Maison la culture")
data5<-subset(data5,clc_secteur != "Bassin Ep parking Mairie")
data5<-subset(data5,clc_secteur != "Bassin Ep rue Aguste Delaune")
data5<-subset(data5,clc_secteur!='Gricourt')
data5<-subset(data5,clc_secteur!='Zone Rinqueval')
data5<-subset(data5,clc_secteur!='Zone industrielle le Royeux (A.Europe)')
data5<-subset(data5,clc_secteur!='Zone industrielle le Royeux (G.Eiffel)')
data5<-subset(data5,clc_secteur!='Zone industrielle le Royeux (basssin)')
data5<-subset(data5,clc_secteur!='Zone industrielle le Royeux (G.Pompidou)')
data5<-subset (data5,clc_secteur != 'Griourt')
data5<-subset(data5,clc_secteur!='Giratoire RN 44')

data5<-subset(data5,age_estim!='')

# On met tout en minuscule dans la colonne fk_stadedev
data5$fk_stadedev <- str_to_lower(data5$fk_stadedev)

# On enlève la valeur aberrante dans 'age_estim'
data5<-subset(data5,age_estim !='2010')

cor(data3$haut_tronc, data3$haut_tot,method="pearson")
# On obtient une valeur de corrélation de 0.49
# 2 valeurs en corrélation positivement
cor(data3$haut_tronc, data3$haut_tot,method="pearson")

# Histogramme sur haut_tot
h1 <- ggplot(data4, aes(x=haut_tot)) + geom_histogram(color="black", fill="red") + ggtitle("Hauteur des arbres")
# Histogramme sur tronc_diam
h2 <- ggplot(data4, aes(x=tronc_diam)) + geom_histogram(color="black", fill="blue") + ggtitle("Diamètre des troncs")
# Afficher les 2 graphiques
grid.arrange(h1, h2, nrow=1)

# Décrire chaque variable (quantitative, qualitative), graphe
# faire Asfactors
# Diagramme en bâtons : qualitative
# Histogramme : quantitative

# ---------------------- Fonctionnalité 2 ----------------------

# Diagramme en bâtons de la quantité d'arbre en fonction du quartier
# On compte le nombre d'arbres en place par quartier
arbres_quartier <- data5 %>%
  filter(fk_arb_etat == "EN PLACE") %>%
  group_by(clc_quartier) %>%
  count(clc_quartier) %>%
  ungroup()
# On affiche le diagramme en bâtons du nombre d'arbres en fonction du quartier
h3 <- ggplot(data5, aes(x=clc_quartier)) + 
  geom_bar(color="black", fill="purple") + 
  ggtitle("Nombre d'arbres par quartier")+
  xlab("Quartier") +
  ylab("Nombre d'arbres")
h3

# Diagramme en bâtons du nombre d'arbres par secteur et par quartier si nb>=150
# On cherche tous les secteurs où les arbres en place ont un nombre supérieur
# ou égal à 150
secteurs_gardes <- data5 %>%
  filter(fk_arb_etat == "EN PLACE") %>%  # Filtrer les arbres "EN PLACE"
  group_by(clc_secteur) %>%
  filter((count = n())>=100) %>%
  ungroup()

# On affiche le diagramme en bâtons
h4 <- ggplot(secteurs_gardes, aes(x = clc_secteur)) +
  geom_bar(color = "black", fill = "purple") +
  facet_wrap(~ clc_quartier, scales = "free_x") +
  ggtitle("Nombre d'arbres par secteur et par quartier")
h4

# Calculer les proportions des valeurs dans fk_stadedev tout en excluant les valeurs vides
proportion <- data5 %>%
  filter(fk_arb_etat == "EN PLACE") %>%
  filter(fk_stadedev != "") %>%
  count(fk_stadedev) %>%
  mutate(proportion = n / sum(n))
proportion

# Ajouter la position de l'étiquette pour un graphique
data6 <- proportion %>%
  arrange(desc(proportion)) %>%
  mutate(lab.ypos = cumsum(proportion) - 0.5 * proportion)


# Répartition des arbres en fonction de leurs développements
couleurs <- c("adulte"="green4","jeune"="chartreuse2","senescent"="blue",'vieux'='red')
h5 <- ggplot(proportion, aes(x = "", y = proportion, fill = fk_stadedev)) +
  geom_bar(width = 1, stat = "identity", color = "black") +
  coord_polar("y", start = 0) +
  #geom_text(aes(y = lab.ypos, label = scales::percent(proportion)), color = "white") +
  ggtitle("Répartition des arbres en fonction de leur développement")+
  scale_fill_manual(values = couleurs) +
  theme_void()
h5

# Compter le nombre d'arbres abattus et en place par quartier
arbres_abattus <- data5 %>%
  filter(fk_arb_etat == "ABATTU") %>%
  count(clc_quartier) %>%
  mutate(etat = "ABATTU")

arbres_en_place <- data5 %>%
  filter(fk_arb_etat == "EN PLACE") %>%
  count(clc_quartier) %>%
  mutate(etat = "EN PLACE")

# Combiner les données
arbres_etat <- bind_rows(arbres_abattus, arbres_en_place)

# Graphe du nombre d'arbres abattus et en place par quartier
couleurz <- c("ABATTU" = "red", "EN PLACE" = "blue")

h6 <- ggplot(arbres_etat, aes(x = clc_quartier, y = n, fill = etat)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  scale_fill_manual(values = couleurz) +
  labs(
    title = "Nombre d'arbres abattus et en place par quartier",
    x = "Quartier",
    y = "Nombre d'arbres",
    fill = "État"
  ) +
  theme_minimal()
h6

# Compter le nombre d'arbres remarquables et non remarquable par quartier
arbres_remarquables <- data5 %>%
  filter(remarquable == "Oui") %>%
  count(clc_quartier) %>%
  mutate(etat1 = "Remarquable")

arbres_non_remarquables <- data5 %>%
  filter(remarquable == "Non") %>%
  count(clc_quartier) %>%
  mutate(etat1 = "Non remarquable")

# Combiner les données
arbres_r <- bind_rows(arbres_remarquables, arbres_non_remarquables)

# Graphe du nombre d'arbres abattus et en place par quartier
couleur <- c("Remarquable" = "red", "Non remarquable" = "blue")

h7 <- ggplot(arbres_r, aes(x = clc_quartier, y = n, fill = etat1)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  scale_fill_manual(values = couleur) +
  labs(
    title = "Nombre d'arbres remarquables et non remarquables par quartier",
    x = "Quartier",
    y = "Nombre d'arbres",
    fill = "État"
  ) +
  theme_minimal()
h7

# ---------------------- Fonctionnalité 3 ----------------------
describe(data5)

# ---------------------- Fonctionnalité 4 ----------------------
# Lien entre les variables pour l'estimation de l'âge

# Coefficient de corrélation entre l'âge estimé et la hauteur du tronc
cor(as.integer(data5$age_estim), as.integer(data5$haut_tronc),method='pearson')
# Nous obtenons en sortie un coefficient de corrélation d'environ 0.51
# donc l'âge estimé et la hauteur du tronc évoluent dans le même sens

# Coefficient de corrélation entre l'âge estimé et le diamètre du tronc
cor(as.integer(data5$age_estim), as.integer(data5$tronc_diam),method='pearson')
# Nous obtenons en sortie un coefficient de corrélation d'environ 0.76
# donc l'âge estimé et le diamètre du tronc évoluent dans le même sens
# Donc le diamètre du tronc est une variable plus importante que la hauteur du 
# tronc dans l'estimation de l'âge de l'arbre

# Coefficent de corrélation entre l'âge estimé et la hauteur de l'arbre
cor(as.integer(data5$age_estim), as.integer(data5$haut_tot),method='pearson')
# Nous obtenons en sortie un coefficient de corrélation d'environ 0.57
# donc l'âge estimé et la hauteur de l'arbre évoluent dans le même sens

# Analyses bivariées
# Nuage de points entre le diamètre du tronc et l'âge estimé
plot(data5$age_estim, data5$tronc_diam, pch=16, col='steelblue',
     main="Nuage de points du diamètre du tronc en fonction de l'âge estimé",
     xlab='Age estimé', ylab='Diamètre du tronc')
# On obtient une corrélation linéaire  moyenne, on voit bien une pente mais 
# la dispersion des points reste importante. Pour avoir une meilleure 
# corrélation linéaire, nous devrions prendre en compte les espèces des arbres

plot(data5$age_estim, data5$haut_tronc, pch=16, col='steelblue',
     main="Nuage de points de la hauteur du tronc en fonction de l'âge estimé",
     xlab='Age estimé', ylab='Hauteur du tronc')

plot(data5$age_estim, data5$haut_tot, pch=16, col='steelblue',
     main="Nuage de points de la hauteur de l'arbre en fonction de l'âge estimé",
     xlab='Age estimé', ylab="Hauteur de l'arbre")

plot(data5$haut_tronc, data5$diam_tronc, pch=16, col='steelblue',
     main="Nuage de points de la hauteur du tronc en fonction du diamètre du tronc",
     xlab='Hauteur du tronc', ylab="Diamètre du tronc")

# Etude des relations entre variables qualitatives
# Création du tableau croisé (quartier et remarquable)
tableau1<-table(data5$clc_quartier, data5$remarquable)
tableau1
#lprop(tableau1) # calcul pourcentage par ligne
cprop(tableau1) # calcul pourcentage par colonne
# Test d'indépendance du Khi2
chisq.test(tableau1)

tableau2 <- table(data5$clc_quartier,data5$fk_stadedev)
tableau2
chisq.test(tableau2)

# ---------------------- Fonctionnalité 5 ----------------------

# Etude de régression sur l'âge
# Régression linéaire : diamètre/hauteur des troncs
# On met as.integer autour des noms des variables
# car les données sont des caractères
b1<-cov(as.numeric(data5$haut_tot),(as.numeric(data5$tronc_diam))/1000)/var(as.numeric(data5$haut_tot))
b0<-mean(as.numeric(data5$tronc_diam))-mean(as.numeric(data5$haut_tot))*b1
modele<-lm((as.numeric(tronc_diam))/1000~as.numeric(haut_tot),data=data5)
modele
plot(as.numeric(data5$haut_tronc),(as.numeric(data5$tronc_diam))/1000,xlab="Hauteur des troncs",ylab="Diamètre des troncs",main="Droite de régression diamètre/hauteur des troncs")
abline(modele,col="red") # permet d'avoir la droite de régression linéaire du modèle
abline(b0,b1,col="red") # permet d'avoir la droite de régression linéaire grâce aux coefficients

# Régression linéaire : diamètre des troncs / âge estimé des arbres
b1<-cov(as.numeric(data5$tronc_diam),as.numeric(data5$age_estim))/var(as.numeric(data5$tronc_diam))
b0<-mean(as.numeric(data5$age_estim))-mean(as.numeric(data5$tronc_diam))*b1
modele<-lm(as.numeric(age_estim)~as.numeric(tronc_diam),data=data5)
modele
plot(as.numeric(data5$tronc_diam),as.numeric(data5$age_estim),xlab="Diamètre des troncs",ylab="Âge estimé des arbres",main="Droite de régression diamètre des troncs/âge estimé des arbres")
abline(modele,col="red") # permet d'avoir la droite de régression linéaire sur le graphe
abline(b0,b1,col="red")
R2<-cor(as.integer(data5$tronc_diam),as.integer(data5$age_estim))^2
R2ajuste<-R2-(1-R2)/(length(as.integer(data5$tronc_diam))-1-1)
summary(modele)
R2<-cor(as.integer(data5$haut_tot),as.integer(data5$tronc_diam))^2
R2ajuste<-R2-(1-R2)/(length(as.integer(data5$haut_tot))-1-1)


# Régression logistique sur les arbres à abattre
data7<-data5
data7$arbre_abattre<- as.integer(str_replace_all(data5$fk_arb_etat,c("ABATTU"="1","EN PLACE"="0")))
#data7$remarquable<- as.integer(str_replace_all(data5$remarquable,c("Non"="0","Oui"="1")))

#model<-glm(arbre_abattre~as.integer(age_estim)+as.integer(tronc_diam),data=data7,family=binomial)
model<-glm(arbre_abattre~as.integer(tronc_diam),data=data7,family=binomial)
X<-data.frame(as.integer(data7$tronc_diame))
plot(as.integer(data7$tronc_diam),data7$arbre_abattre)
curve(predict(model,A= x,type="response"))


