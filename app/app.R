# Shiny app to explore plots of battery voltage with solar radiation and temperature by AZMet station

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
    
    bslib::navset_card_tab(
      id = "navsetCardTab",
      selected = "billLength",
      title = NULL,
      sidebar = NULL,
      header = NULL,
      footer = NULL,
      height = 450,
      full_screen = TRUE,
      wrapper = card_body,
      
      bslib::nav_panel(
        title = "Scatterplot",
        value = "scatterplot",
        p("scatterplot")
      ),
      
      bslib::nav_panel(
        title = "Time Series",
        value = "timeSeries",
        p("time series")
      ),
      
      bslib::nav_panel(
        title = "Bill Length",
        value = "billLength",
        shiny::plotOutput("bill_length")
      ),
      
      bslib::nav_panel(
        title = "Bill Depth", 
        value = "billDepth",
        shiny::plotOutput("bill_depth")
      ),
      
      bslib::nav_panel(
        title = "Body Mass", 
        value = "bodyMass",
        shiny::plotOutput("body_mass")
      )
    ) |>
      htmltools::tagAppendAttributes(
        #https://getbootstrap.com/docs/5.0/utilities/api/
        class = "border-0 rounded-0 shadow-none"
      ),
    
    fillable = TRUE,
    fillable_mobile = FALSE,
    theme = theme,
    lang = NULL,
    window_title = NA
  ) # bslib::page_sidebar()
) # htmltools::htmlTemplate()


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
