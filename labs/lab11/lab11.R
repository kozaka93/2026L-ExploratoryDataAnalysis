#install.packages("palmerpenguins")
library(shiny)
library(palmerpenguins)
library(ggplot2)
library(plotly)
library(bslib)
library(dplyr)
data("penguins")



ui <- fluidPage(
 
  titlePanel("Analiza danych o pingwinach"),
  
  fluidRow(
    column(6, 
           
    ),
    column(6,
           
    ),
  ),
  fluidRow(
    column(6,
           
    ),
    column(6,
           
    )
  ),
  fluidRow(
    column(6, 
           
    ),
    column(6, 
           
    ),
    
  )
)




server <- function(input, output) {
  
 
  
  
  
  
}


shinyApp(ui = ui, server = server)
