library(shiny)
library(dplyr)
library(lubridate)
library(cluster)
library(DT)
library(shinyjs)
library(ggvis)
library(tidyr)
library(shinythemes)
library(dbscan)
library(factoextra)
library(ggplot2)
library(igraph)
library(stringr)


function(input, output){
  
  filtered_data <- reactive({
    data_filtered <- data_clean[data_clean$season == input$season, ]
    return(data_filtered)
  })
  
  output$outlier_plot_pca <- renderPlotly({
    # Scatter plot with names of outlier songs based on PCA
    pca_data <- detect_outliers_pca(data_clean, attributes, input$season, input$num_clusters)
    
    # Add row position as an identifier
    pca_data$row_id <- seq_len(nrow(pca_data))
    data_clean_filtered <- data_clean[data_clean$season == input$season, ]
    data_clean_filtered$row_id <- seq_len(nrow(data_clean_filtered))
    # Merge pca_data with data_clean using row position and the selected season
    merged_data <- left_join(pca_data, data_clean_filtered, by = "row_id")
    
    # Get a string containing information about all attributes
    merged_data$text_info <- apply(merged_data[, attributes], 1, function(row) {
      paste(names(row), ": ", row, collapse = "<br>")
    })
    
    plot_ly(merged_data, x = ~PC1, y = ~PC2, color = ~factor(cluster), symbol = ~factor(is_outlier)) %>%
      add_markers(size = 3, 
                  hoverinfo = "text",
                  text = ~paste("Track: ", track_name, "<br>Artist: ", artist.s._name, "<br>", text_info)) %>%
      layout(
        title = paste("Clusters and Outliers in", input$season),
        showlegend = TRUE,
        xaxis = list(title = "PC1"),
        yaxis = list(title = "PC2")
      )
  })
  
  output$outlier_table <- renderDataTable({
    # Detect outliers based on PCA
    pca_data <- detect_outliers_pca(data_clean, attributes, input$season, input$num_clusters)
    outliers_index <- which(pca_data$is_outlier)
    outliers_data <- data_clean[data_clean$season == input$season, c("track_name", "artist.s._name",attributes)][outliers_index, ]
    
    return(outliers_data)
  }, options = list(
    lengthMenu = c(5, 10, 15, 20, 25),
    pageLength = 5
  ))
  
  output$histogram_plot <- renderPlot({
    # Histogram by intervals depending on the season and attribute type
    filtered_data <- filtered_data()
    ggplot(filtered_data, aes(x = get(input$feature))) +
      geom_histogram(binwidth = 10, fill = "#1DB954", color = "#191414", alpha = 0.7) +
      xlab("Length") +
      scale_x_continuous(breaks = seq(min(filtered_data[[input$feature]]), max(filtered_data[[input$feature]]), by = 10)) + 
      ggtitle(paste("Histogram of", input$feature, "in", input$season)) +
      theme_minimal() 
  })
  
  
  data_trends <- data %>%
    select(X, track_name, artist.s._name, artist_count, released_year, streams, in_spotify_playlists, in_spotify_charts, 
           in_apple_playlists, in_apple_charts, in_deezer_playlists, in_deezer_charts, in_shazam_charts)
  
  data_input <- reactive({
    minstreams <- input$streams[1]
    maxstreams <- input$streams[2]
    n_artists <- input$n_artists
    minyear <- input$year[1]
    maxyear <- input$year[2]
    
    # Apply filters
    m <- data_trends %>%
      filter(
        streams >= minstreams,
        streams <= maxstreams,
        artist_count >= n_artists,
        released_year >= minyear,
        released_year <= maxyear
      ) %>%
      arrange(streams)
    
    if (!is.null(input$artist) && input$artist != "") {
      artist <- input$artist
      m <- m %>% filter(grepl(artist, artist.s._name))
    }
    
    m <- as.data.frame(m)
  })
  
  output$scatterplot <- renderPlotly({
    data_to_show <- data_input()
    ggplot(data_to_show) +
      aes_string(x = input$xvar, y = input$yvar) +
      geom_point(aes(text= paste("Name: ", track_name, "\nArtist: ", artist.s._name)), colour="black", alpha=1/2) + 
      geom_smooth(method=lm, color = "#1DB954")
  })
  
  output$n_tracks <- renderText({
    data_to_show <- data_input()
    nrow(data_to_show)
  })
  
  output$playlist_table <- renderTable({
    data_to_show <- data_input()
    return(data_to_show)
  })

  # Artist data1 for selection
  artistdata <- reactive({
    data1 <- data
    data1 %>%
      mutate(artist = strsplit(`artist.s._name`, ", ")) %>%
      unnest(artist) %>%
      distinct(artist)
  })
  
  # Update artist select input
  output$artistSelect <- renderUI({
    data1 <- artistdata()
    selectInput("selectedArtist", "Select an Artist", choices = data1$artist)
  })
  
  # Render the collaboration graph
  output$collabGraph <- renderPlot({
    selected_artist <- input$selectedArtist
    data1 <- data
    
    # Process data1 for graph
    artist_songs <- data1[grepl(selected_artist, data1$`artist.s._name`), ]
    edges <- do.call(rbind, lapply(artist_songs$`artist.s._name`, function(song_artists) {
      collaborators <- strsplit(song_artists, ", ")[[1]]
      collaborators <- collaborators[collaborators != selected_artist]
      if (length(collaborators) > 0) {
        data.frame(from = selected_artist, to = collaborators, stringsAsFactors = FALSE)
      }
    }))
    
    graph <- if (nrow(edges) > 0) {
      graph_from_data_frame(edges, directed = FALSE)
    } else {
      make_empty_graph()
    }
    
    plot.igraph(graph, vertex.label = V(graph)$name, vertex.size=15, vertex.color="#1DB954",
                vertex.frame.color = NA, vertex.label.color = "#191414", vertex.label.cex = 1.5,
                edge.arrow.size = 0.5, edge.color = "grey", layout=layout_nicely(graph))
  })
  
  # Generate the histogram plot
  output$collabHist <- renderPlot({
    collaboration_data1 <- data %>%
      filter(str_detect(`artist.s._name`, ", ")) %>%
      separate_rows(`artist.s._name`, sep = ",\\s*") %>%
      count(`artist.s._name`) %>%
      arrange(desc(n)) %>%
      slice_head(n = input$numArtists)
    
    ggplot(collaboration_data1, aes(x = `artist.s._name`, y = n)) +
      geom_col() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      labs(x = "Artists", y = "Number of Collaborations", title = "Number of Collaborations per Artist")
  })
  
}