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
#library(lubridate)
library(shiny)
#library(vroom)

# Functions
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##DEF.R", local = TRUE)

data(penguins, package = "palmerpenguins")

cards <- list(
  card(
    full_screen = TRUE,
    card_header("Bill Length"),
    plotOutput("bill_length")
  ),
  card(
    full_screen = TRUE,
    card_header("Bill depth"),
    plotOutput("bill_depth")
  ),
  card(
    full_screen = TRUE,
    card_header("Body Mass"),
    plotOutput("body_mass")
  )
)

color_by <- bslib::sidebar(
  shiny::varSelectInput(
    "color_by", "Color by",
    penguins[c("species", "island", "sex")],
    selected = "species"
  ),
  width = 400,
  position = "left",
  gap = 0,
  padding = 0
)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageSidebar = bslib::page_sidebar(
    
    title = NULL,
    
    bsTheme = bslib::bs_theme(
      version = version_default(),
      bootswatch = NULL
    ),
    
    sidebar = color_by,
    navset_card_underline(
      title = "Histograms by species",
      nav_panel("Bill Length", plotOutput("bill_length")),
      nav_panel("Bill Depth", plotOutput("bill_depth")),
      nav_panel("Body Mass", plotOutput("body_mass"))
    )
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
