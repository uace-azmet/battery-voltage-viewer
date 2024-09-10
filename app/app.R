# Shiny app to explore graphs that compare battery voltage with weather variables by AZMet station

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->


# Libraries
#library(azmetr)
library(bslib)
library(dplyr)
library(ggplot2)
library(htmltools)
library(lubridate)
library(magrittr)
library(palmerpenguins)
library(shiny)
library(tibble)
library(vroom)

# Functions
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageSidebar = bslib::page_sidebar(
    title = NULL,
    sidebar = sidebar,
    
    navsetCardTab,
    
    fillable = TRUE,
    fillable_mobile = FALSE,
    theme = theme,
    lang = NULL,
    window_title = NA
  )
)


# Server --------------------

server <- function(input, output, session) {
  
  # Reactive events -----
  
  # Outputs -----
  
  gg_plot <- reactive({
    ggplot(penguins) +
      geom_density(aes(fill = !!input$color_by), alpha = 0.2) +
      theme_bw(base_size = 16) +
      theme(axis.title = element_blank())
  })
  
  output$bill_length <- renderPlot(gg_plot() + aes(bill_length_mm))
  output$bill_depth <- renderPlot(gg_plot() + aes(bill_depth_mm))
  output$body_mass <- renderPlot(gg_plot() + aes(body_mass_g))
}

# Run --------------------

shinyApp(ui = ui, server = server)
