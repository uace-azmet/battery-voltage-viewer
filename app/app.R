# Explore graphs that compare battery voltage with weather variables by station


# UI --------------------


ui <- 
  htmltools::htmlTemplate(
    filename = "azmet-shiny-template.html",
    
    pageBatteryVoltageViewer = 
      bslib::page(
        title = NULL,
        theme = theme, # `scr##_theme.R`
        
        bslib::layout_sidebar(
          sidebar = pageSidebar, # `scr##_pageSidebar.R`
          shiny::uiOutput(outputId = "navsetCardTab")
        ),
        
        shiny::htmlOutput(outputId = "figureHelpText"),
        shiny::htmlOutput(outputId = "pageBottomText") # Common, regardless of card tab
      )
  )


# Server --------------------


server <- 
  function(input, output, session) {
    shinyjs::useShinyjs(html = TRUE)
    # shinyjs::hideElement(id = "navsetCardTabSidebar")
    # shinyjs::hideElement(id = "pageBottomText")
    
    
    # Observables -----
    
    shiny::observeEvent(input$azmetStationScatterplot, {
      azmetStation(input$azmetStationScatterplot)
      print(paste0("Station Scatterplot: ", azmetStation()))
      
      shiny::updateSelectInput(
        inputId = "azmetStationTimeSeries",
        label = "AZMet Station",
        choices = c("Select a station..." = "", sort(azmetStationMetadata$meta_station_name)),
        selected = azmetStation() # Reactive value initialized in `_global.R`
      )
    })

    shiny::observeEvent(input$azmetStationTimeSeries, {
      azmetStation(input$azmetStationTimeSeries)
      print(paste0("Station Time Series: ", azmetStation()))
      
      shiny::updateSelectInput(
        inputId = "azmetStationScatterplot",
        label = "AZMet Station",
        choices = c("Select a station..." = "", sort(azmetStationMetadata$meta_station_name)),
        selected = azmetStation() # Reactive value initialized in `_global.R`
      )
    })
    
    shiny::observeEvent(input$batteryVariableScatterplot, {
      batteryVariable(input$batteryVariableScatterplot)
      print(paste0("Battery Scatterplot: ", batteryVariable()))
      
      shiny::updateSelectInput(
        inputId = "batteryVariableTimeSeries",
        label = "Battery Variable",
        choices = c("Select a variable..." = "", sort(batteryVariables$variable)),
        selected = batteryVariable() # Reactive value initialized in `_global.R`
      )
    })
    
    shiny::observeEvent(input$batteryVariableTimeSeries, {
      batteryVariable(input$batteryVariableTimeSeries)
      print(paste0("Battery Time Series: ", batteryVariable()))
      
      shiny::updateSelectInput(
        inputId = "batteryVariableScatterplot",
        label = "Battery Variable",
        choices = c("Select a variable..." = "", sort(batteryVariables$variable)),
        selected = batteryVariable() # Reactive value initialized in `_global.R`
      )
    })
    
    shiny::observeEvent(input$navsetCardTab, {
      if (input$navsetCardTab == "scatterplot") {
        bslib::toggle_sidebar(id = "sidebarScatterplot", open = input$sidebarTimeSeries)
      } else if (input$navsetCardTab == "timeSeries") {
        bslib::toggle_sidebar(id = "sidebarTimeSeries", open = input$sidebarScatterplot)
      }
    })
    
    shiny::observeEvent(input$retrieveData, {
      if (input$startDate > input$endDate) {
        shiny::showModal(datepickerErrorModal) # `scr##_datepickerErrorModal.R`
      }
      
      shinyjs::showElement(id = "navsetCardTab")
      # shinyjs::showElement(id = "navsetCardTabSidebar")
      # shinyjs::showElement(id = "pageBottomText")
      
      showNavsetCardTab(TRUE)
      # showNavsetCardTabSidebar(TRUE)
      # showPageBottomText(TRUE)
    })
    
    shiny::observeEvent(input$weatherVariableScatterplot, {
      weatherVariable(input$weatherVariableScatterplot)
      print(paste0("Weather Scatterplot: ", weatherVariable()))
      
      shiny::updateSelectInput(
        inputId = "weatherVariableTimeSeries",
        label = "Weather Variable",
        choices = c("Select a variable..." = "", sort(weatherVariables$variable)),
        selected = weatherVariable() # Reactive value initialized in `_global.R`
      )
    })
    
    shiny::observeEvent(input$weatherVariableTimeSeries, {
      weatherVariable(input$weatherVariableTimeSeries)
      print(paste0("Weather Time Series: ", weatherVariable()))
      
      shiny::updateSelectInput(
        inputId = "weatherVariableScatterplot",
        label = "Weather Variable",
        choices = c("Select a variable..." = "", sort(weatherVariables$variable)),
        selected = weatherVariable() # Reactive value initialized in `_global.R`
      )
    })
    
    
    # Reactives -----
    
    azDaily <- 
      shiny::eventReactive(input$retrieveData, {
        shiny::validate(
          shiny::need(
            expr = input$startDate <= input$endDate,
            message = FALSE
          )
        )
        
        idRetrievingData <- shiny::showNotification(
          ui = "Retrieving data . . .", 
          action = NULL, 
          duration = NULL, 
          closeButton = FALSE,
          id = "idRetrievingData",
          type = "message"
        )
        
        on.exit(shiny::removeNotification(id = idRetrievingData), add = TRUE)
        
        fxn_azDaily(
          azmetStation = NULL, 
          startDate = input$startDate, 
          endDate = input$endDate
        )
      })
    
    figureHelpText <- 
      shiny::eventReactive(azDaily(), {
        fxn_figureHelpText(
          startDate = input$startDate,
          endDate = input$endDate
        )
      })
    
    pageBottomText <- 
      shiny::eventReactive(azDaily(), {
        fxn_pageBottomText()
      })
    
    scatterplot <- 
      shiny::reactive({
        shiny::req(azmetStation(), batteryVariable(), weatherVariable())
        
        fxn_scatterplot(
          inData = azDaily(),
          azmetStation = input$azmetStationScatterplot,
          batteryVariable = input$batteryVariableScatterplot,
          weatherVariable = input$weatherVariableScatterplot
        )
      })
    
    timeSeries <- 
      shiny::reactive({
        shiny::req(azmetStation(), batteryVariable(), weatherVariable())
        
        fxn_timeSeries(
          inData = azDaily(),
          azmetStation = input$azmetStationTimeSeries,
          batteryVariable = input$batteryVariableTimeSeries,
          weatherVariable = input$weatherVariableTimeSeries
        )
      })
    
    
    # Outputs -----
    
    output$figureHelpText <- 
      shiny::renderUI({
        figureHelpText()
      })
    
    output$navsetCardTab <- 
      shiny::renderUI({
        shiny::req(showNavsetCardTab())
        navsetCardTab # `scr##_navsetCardTab.R`
      })
    
    output$pageBottomText <-
      shiny::renderUI({
        pageBottomText()
      })
    
    output$scatterplot <- 
      plotly::renderPlotly(scatterplot())
    
    output$timeSeries <- 
      plotly::renderPlotly(timeSeries())
  }


# Run --------------------


shiny::shinyApp(ui = ui, server = server)
