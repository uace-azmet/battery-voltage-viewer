# Shiny app to explore plots of battery voltage with solar radiation and temperature by AZMet station

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->


# Libraries
#library(azmetr)
library(bslib)
#library(dplyr)
library(htmltools)
#library(lubridate)
library(shiny)
#library(vroom)

# Functions
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  #pageFillable = bslib::page_fillable(
  #  h2("Diamond Plots")
  #)
  
  theme = bslib::bs_theme(
    version = version_default(),
    preset = NULL,
    #...,
    bg = NULL,
    fg = NULL,
    primary = NULL,
    secondary = NULL,
    success = NULL,
    info = NULL,
    warning = NULL,
    danger = NULL,
    base_font = NULL,
    code_font = NULL,
    heading_font = NULL,
    font_scale = NULL,
    bootswatch = "bootstrap"
  ),
  
  pageSidebar = bslib::page_sidebar(
    title = NULL,
    sidebar = "Sidebar",
    bslib::card(
      bslib::card_header("Summary")
    ),
    bslib::card(
      bslib::card_header("Table")
    )
  )
  #sidebarLayout = sidebarLayout(
  #  position = "left",
    
  #  sidebarPanel(
  #    id = "sidebarPanel",
  #    width = 4,
      
  #    verticalLayout(
  #      selectInput("dataset", label = "Dataset", choices = ls("package:datasets"))
  #    )
  #  ), # sidebarPanel()
    #sidebar = bslib::sidebar(
    #  id = "sidebar",
    #  open = TRUE,
    #  position = "left",
    #  width = 250,
    #), # sidebar()
    
    #mainPanel(
    #  id = "mainPanel",
    #  width = 8,
    
    #  verbatimTextOutput("summary"),
    #  tableOutput("table")
    #) # mainPanel()
  #) # sidebarLayout()
  #sidebar = bslib::sidebar(
  #  id = "sidebar",
  #  open = TRUE,
  #  position = "left",
  #  width = 250,
  #) # sidebar()
) # htmltools::htmlTemplate()


# Server --------------------

server <- function(input, output, session) {
  
  # Reactive events -----
  
  # Outputs -----
  
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
}

# Run --------------------

shinyApp(ui = ui, server = server)
#shinyApp(ui = ui, function(input, output) {})
