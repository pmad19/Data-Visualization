# Design and develop of a data visualization Tool in R
`Spotify Trends Analysis Tool` contains an analysis of the most listened tracks in Spotify, Apple Music and Deezer in 2023. This tool is designed for answer the following questions:

1. Is there any trend in the music features of the most popular tracks? Which songs are atypical even if they are very listened? 
2. What songs are possible viral hits that show a possible drop in the number of streams?
3. How do artists relate to each other when collaborating? 

This visualization tool has been designed above the following dataset located in Kaggle: Most Streamed Spotify Songs 2023. This dataset contains a comprehensive list of the most famous songs of 2023 as listed on Spotify. The dataset offers a wealth of features beyond what is typically available in similar datasets. It provides insights into each song's attributes, popularity, and presence on various music platforms. The dataset includes information such as track name, artist(s) name, release date, Spotify playlists and charts, streaming statistics, Apple Music presence, Deezer presence, Shazam charts, and various audio features.

The tool is divided in three main tabs

## The Seasonal Trends Tab
The user will be able to interact with five types of categories. Firstly, the seasons of the year, which will impact changes in both the histogram and the scatterplot, as well as in the table. Secondly, users can select a specific attribute such as bpm or energy, affecting only the trends in the histogram. Lastly, the user can adjust the number of clusters, influencing both the scatterplot and the outliers, as they adapt to the chosen number of clusters. Additionally, users can view detailed song characteristics by hovering over points in the scatterplot. Finally, within the table, users have the option to navigate through entries based on either the artist's name or the track's name. Additionally, users can specify the number of rows they want to be displayed in the table.

By allowing users to explore changes in the histogram and scatterplot based on seasons, the application enables the examination of trends in music features over different times of the year. Users can identify patterns and variations in popular tracks across seasons, contributing to an understanding of temporal trends.

By focusing on specific attributes like bpm or energy, users can employ a targeted filter to observe how musical styles, represented by trends in the histogram, vary throughout the year. This functionality enables users to discern nuanced changes in song characteristics over different seasons, providing a more detailed understanding of how specific attributes contribute to the overall trends in the most popular tracks.

The ability to adjust the number of clusters influences both the scatterplot and outliers, providing insights into songs that deviate from expected trends. This feature aids in identifying atypical songs that may not follow the general trend despite being highly listened to, thereby addressing the question of which songs are atypical among the most popular tracks. The option to hover over points in the scatterplot and view detailed song characteristics enhances user engagement, allowing for a more immersive and informative exploration of the data.


## The Stream Trends Tab
A specific type of interaction has been chosen to provide users with a comprehensive exploration of potential viral hits and their streaming patterns. The chosen interactive features are as follows:

- **Number of Streams:** Users can interact with the dataset by adjusting the number of streams, allowing for a dynamic examination of songs based on their popularity.
- **Year:** The interactivity extends to the temporal dimension, enabling users to explore trends and variations in viral hits over different years.
- **Artist Name:** Users have the flexibility to interact with the data based on specific artist names, offering insights into the streaming patterns of individual artists.
- **Artist Number:** Interacting with the artist number allows users to explore songs associated with artists, contributing to a more nuanced analysis of streaming behavior.
- **Scatterplot Displayed Records:** Users can customize the scatterplot by selecting the number of songs they wish to appear.

Moreover, the interactive scatterplot provides a user-friendly interface where, by hovering over each data point, detailed information about the respective song becomes available. This includes specifics about the artist, the number of streams, and any other pertinent details. This interactive design not only facilitates a more engaging exploration but also ensures that users can glean insights into the characteristics of each song without navigating away from the visual representation.

In summary, the chosen interaction allows users to dynamically explore the dataset based on multiple parameters, providing a nuanced understanding of potential viral hits and their streaming dynamics.


## The Collaboration Trends Tab
The two types of interaction crafted to investigate the dynamics of artists' relationships in collaborative songs are the next ones:
- **Number of Artists:** In the histogram visualization, users have the capability to adjust the number of artists displayed. This feature allows users to customize the view and focus on a specific range or set of artists based on their preferences or analytical needs.
- **Artist Name:** In the graph visualization, users are required to filter by a specific artist to reveal their collaborative relationships. By selecting a particular artist, the graph dynamically adjusts to showcase connections with other artists in the collaborative network. This interaction allows users to delve into the specific relationships of a chosen artist, providing insights into how they are connected to other musicians in collaborative endeavours.


## More

### Run the App locally
To run it locally, you'll need to install the latest versions of [ggvis](http://ggvis.rstudio.com), [Shiny](http://shiny.rstudio.com), [dplyr](https://github.com/hadley/dplyr), [lubridate](https://cran.r-project.org/web/packages/lubridate), [cluster](https://cran.r-project.org/web/packages/cluster), [DT](https://cran.r-project.org/web/packages/DT), [shinyjs](https://cran.r-project.org/web/packages/shinyjs), [tidyr](https://cran.r-project.org/web/packages/tidyr), [shinythemes](https://cran.r-project.org/web/packages/shinythemes), [dbscan](https://cran.r-project.org/web/packages/dbscan), 
[factoextra](https://cran.r-project.org/web/packages/factoextra), [ggplot2](https://cran.r-project.org/web/packages/ggplot2), [igraph](https://cran.r-project.org/web/packages/igraph), [stringr](https://cran.r-project.org/web/packages/stringr), [shinyWidgets](https://cran.r-project.org/web/packages/shinyWidgets).

```r
install.packages(c('shiny', 'ggvis', 'dplyr', 'lubridate', 'cluster', 'DT', 'shinyjs', 'ggvis', 'tidyr', 'shinythemes', 'dbscan', 'factoextra', 'ggplot2', 'igraph', 'stringr', 'shinyWidgets'))
```

You may need to restart R to make sure the newly-installed packages work properly.

After all these packages are installed, you can run this app by entering the directory, and then running the following in R:

```s
shiny::runApp()
```

### About
This project has been developed for the subject Data Visualization 2023 of the MSc in Data Science at the Universidad Politécnica de Madrid.

#### Authors
DAVID GARCÍA SANZ - @davidgarciasanz01 

FRANCISCO MADRIGAL PUERTAS - @pmad19

JUAN RAMÓN ROMERO GARCÍA - @juanraromero 
