# ---------------------------------------------
# Analyse des Symptômes - Préparation et Fréquences

# Description : Ce script importe des données sur les symptômes depuis un fichier Excel,
#               nettoie les données, compte les occurrences et calcule les fréquences des symptômes.
#               Les résultats sont ensuite exportés dans un fichier CSV.
# ---------------------------------------------

# Installer et charger les packages nécessaires
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(readxl)
library(stringr)
library(dplyr)
library(ggplot2)

# ---------------------------------------------
# 1. Importation des données
# ---------------------------------------------
# Définir le chemin d'accès dynamique (utilisez 'file.choose()' pour une sélection manuelle)
file_path <- file.choose()  # Ouvrir une fenêtre pour choisir le fichier
data <- read_excel(file_path)  # Importer les données Excel

# Afficher un aperçu des données pour validation
View(data)  # Afficher dans l'interface RStudio
print(paste("Nombre total de lignes dans les données :", nrow(data)))

# Vérifier que la colonne 'Symptômes' existe
if (!"Symptômes" %in% colnames(data)) {
  stop("Erreur : La colonne 'Symptômes' est manquante dans les données importées.")
}

# ---------------------------------------------
# 2. Nettoyage des données
# ---------------------------------------------
data <- data %>%
  filter(!is.na(Symptômes)) %>%  # Retirer les lignes où 'Symptômes' est vide
  mutate(Symptômes = str_trim(Symptômes))  # Supprimer les espaces inutiles

# ---------------------------------------------
# 3. Analyse des données
# ---------------------------------------------
# Étape 1 : Compter les occurrences de chaque symptôme
symptomes_comptage <- data %>%
  count(Symptômes) %>%  # Compter le nombre d'occurrences de chaque symptôme
  arrange(desc(n))  # Trier par fréquence décroissante

# Étape 2 : Calculer les fréquences (proportions)
total_reponses <- nrow(data)  # Nombre total de réponses
symptomes_comptage <- symptomes_comptage %>%
  mutate(frequence = n / total_reponses)  # Ajouter une colonne de fréquence

# Afficher les résultats
print(symptomes_comptage)

# ---------------------------------------------
# 4. Export des résultats
# ---------------------------------------------
# Exporter les résultats dans un fichier CSV
write.csv(symptomes_comptage, "frequences_symptomes.csv", row.names = FALSE)
print("Les résultats ont été exportés dans 'frequences_symptomes.csv'.")

