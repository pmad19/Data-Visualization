library(shiny)
library(dplyr)
library(lubridate)
library(cluster)
library(DT)
library(shinyjs)
library(plotly)
library(ggvis)
library(shinythemes)
library(dbscan)
library(factoextra)
library(ggplot2)
library(igraph)
library(stringr)
library(shinyWidgets)


fluidPage(
  chooseSliderSkin("Modern"),
  navbarPage(img(src = "Spotify_Logo_RGB_Green.png", height = 30, width = 100), theme = shinytheme("flatly"),
             tabPanel("Seasonal Trends", fluid = TRUE,icon = icon("calendar"),
                      useShinyjs(),
                      titlePanel("Spotify Seasonal Trends Analysis"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("season", "Select Season", choices = unique(data_clean$season)),
                          selectInput("feature", "Select Attribute to Analyze", choices = attributes),
                          numericInput("num_clusters", "Number of Clusters:", value = 3, min = 3, max = 7)
                        ),
                        mainPanel(
                          plotOutput("histogram_plot"),
                          plotlyOutput("outlier_plot_pca"),
                          dataTableOutput("outlier_table")
                        )
                      )
             ),
             
             tabPanel("Streams Trends", fluid = TRUE, icon = icon("music"),
                      titlePanel("Spotify Streams-Playlists Trends Analysis"),
                      fluidRow(
                        column(3,
                               wellPanel(
                                 h4("Filter"),
                                 sliderInput("streams", "Number of streams",
                                             0, 4000000000, value = c(0, 4000000000), sep = ""),
                                 sliderInput("year", "Year released", 1930, 2023, value = c(1930, 2023),
                                             sep = ""),
                                 sliderInput("n_artists", "Minimum number of artist in the track",
                                             1, max(data$artist_count), 1, step = 1),
                                 textInput("artist", "Artist name contains (e.g., Bizarrap)"),
                               ),
                               wellPanel(
                                 selectInput("xvar", "X-axis variable", x_vars, selected = "Streams"),
                                 selectInput("yvar", "Y-axis variable", y_vars, selected = "in_spotify_playlists"),
                                 tags$small(paste0(
                                   "Note: The playlist number expresses the number of times the song is in a playlist on a platform.",
                                   " The number of streams expresses the total number of streams in Spotify"
                                 ))
                               )
                        ),
                        column(9,
                               plotlyOutput("scatterplot"),
                               wellPanel(
                                 span("Number of tracks selected:",
                                      textOutput("n_tracks")
                                 )
                               ),
                               tableOutput('playlist_table')
                        )
                      )
             ),
             tabPanel("Collaborations Trends", fluid = TRUE, icon = icon("user"),
                      titlePanel("Spotify Artist Collaboration Analysis"),
                      sidebarLayout(
                        sidebarPanel(
                          uiOutput("artistSelect"),  # Dynamic UI for selecting an artist
                          sliderInput("numArtists",
                                      "Number of Artists:",
                                      min = 1,
                                      max = 100,  # Adjust based on your data1set
                                      value = 10)
                        ),
                        mainPanel(
                          plotOutput("collabGraph"),
                          plotOutput("collabHist")
                        )
                      )
             
             )
  )
  
)