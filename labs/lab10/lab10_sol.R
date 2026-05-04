library(shiny)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  titlePanel("Interaktywna Eksploracja Aut"),
  
  sidebarLayout(
    sidebarPanel(
      ### Zadanie 3 & 9 ###
      sliderInput(inputId = "cyl",
                  label = "Wybierz zakres liczby cylindrów:",
                  min = min(mpg$cyl),
                  max = max(mpg$cyl),
                  # value = min(mpg$cyl), # wersja dla Zadania 3
                  value = c(min(mpg$cyl), max(mpg$cyl)), # wersja dla Zadania 9
                  step = 1),
      ### Koniec - Zadanie 3 & 9 ###
      
      ### Zadanie 5 ###
      selectInput(inputId = "prod",
                  label = "Wybierz producenta:",
                  choices = unique(mpg$manufacturer)),
      ### Koniec - Zadanie 5 ###
      
      ### Zadanie 7 ###
      radioButtons( inputId = "color",
                    label = "Koloruj punkty według:",
                    choices = c("Klasa samochodu" = "class", 
                                "Rodzaj napędu" = "drv"))
      ### Koniec - Zadanie 7 ###
    ),
    

    
    mainPanel(
      ### Zadanie 4 ###
      plotOutput("point_plot"),
      ### Koniec - Zadanie 4 ###
      
      ### Zadanie 8 ###
      textOutput("tekst")
      ### Koniec - Zadanie 8 ###
    )
  )
)


server <- function(input, output) {
  
  ### Przygotowanie danych ###
  filtered_data <- reactive({
    mpg %>%
      ### Zadanie 5 ###
      filter(manufacturer == input$prod) %>%
      ### Koniec - Zadanie 5 ###
      ### Zadanie 3 & 9 ###
      # filter(cyl <= input$cyl) # wersja dla Zadania 3
      filter(cyl >= input$cyl[1], cyl <= input$cyl[2]) # wersja dla Zadania 9
      ### Koniec - Zadanie 3 & 9 ###
  })
  
  
  ### Zadanie 4 ###
  output$point_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = displ, y = hwy)) +
      geom_point(
        ### Zadanie 7 ###
        aes(color = .data[[input$color]])
        ### Koniec - Zadanie 7 ###
      ) +
      labs(title = paste("Modele marki:", input$prod),
           x = "Pojemność silnika [l]",
           y = "Zużycie paliwa na autostradzie [mpg]",
           color = "Legenda") +
      theme_minimal()
  })
  ### Koniec - Zadanie 4 ###
  
  ### Zadanie 8 ###
  output$tekst <- renderText(
    paste(
      "Średnie zużycie paliwa na autostradzie dla wybranych modeli marki",
      input$prod,
      "wynosi:",
      round(mean(mpg$hwy[mpg$manufacturer == input$prod]), 2),
      "mpg."
    )
  )
  ### Koniec - Zadanie 8 ###
}

# Run the application
shinyApp(ui = ui, server = server)
