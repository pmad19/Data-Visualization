# Import Data
data <- read.csv("spotify-2023.csv", fileEncoding = "ISO-8859-13")

data$released_year <- as.integer(data$released_year)
attributes <- c("bpm", "danceability_.", "valence_.", "energy_.", "acousticness_.", "instrumentalness_.", "liveness_.", "speechiness_.",
                "in_spotify_playlists", "in_apple_playlists", "in_deezer_playlists")
for (attribute in attributes) {
  data[[attribute]] <- as.numeric(as.character(data[[attribute]]))
}

# Remove rows with NA values
data_clean <- data[complete.cases(data), ]


# Global variables for second view page

# Variables that can be put on the x ax
x_vars <- c(
  "Streams" = "streams",
  "Spotify Playlists" = "in_spotify_playlists",
  "Apple Playlists" = "in_apple_playlists",
  "Deezer Playlists" = "in_deezer_playlists"
)

# Variables that can be put on the y ax
y_vars <- c(
  "Streams" = "streams",
  "Spotify Playlists" = "in_spotify_playlists",
  "Apple Playlists" = "in_apple_playlists",
  "Deezer Playlists" = "in_deezer_playlists"
)

detect_outliers_pca <- function(data, attributes, season, num_clusters) {
  data_season <- data[data$season == season, attributes]
  
  # Apply PCA
  pca_result <- prcomp(data_season, scale. = TRUE, rank = 2)
  pca_data <- data.frame(PC1 = pca_result$x[, 1], PC2 = pca_result$x[, 2])  # Two principal components
  
  # Perform clustering with K-Means on PCA results
  kmeans_result <- kmeans(pca_data, centers = num_clusters)  # Use the number of clusters selected by the user
  pca_data$cluster <- kmeans_result$cluster
  
  # Calculate Euclidean distances from original points to their projections in PCA
  distances <- apply(pca_data[, c("PC1", "PC2")], 1, function(row) {
    sqrt(sum((row - pca_data[, c("PC1", "PC2")])^2))
  })
  
  # Define threshold for outliers (you can adjust this value)
  threshold <- quantile(distances, 1/num_clusters + 0.55)
  
  # Identify outliers
  outliers_index <- which(distances > threshold)
  
  # Create a column indicating whether it is an outlier or not
  pca_data$is_outlier <- FALSE
  pca_data$is_outlier[outliers_index] <- TRUE
  
  return(pca_data)
}