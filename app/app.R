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
        
        shiny::htmlOutput(outputId = "pageBottomText") # Common, regardless of card tab
      )
  )


# Server --------------------


server <- 
  function(input, output, session) {
    
    shinyjs::useShinyjs(html = TRUE)
    shinyjs::hideElement(id = "navsetCardTabSidebar")
    
    
    # Observables -----
    
    shiny::observeEvent(azDaily(), {
      shinyjs::showElement(id = "navsetCardTab")
      showNavsetCardTab(TRUE)
    })
    
    shiny::observeEvent(input$azmetStationScatterplot, {
      azmetStation(input$azmetStationScatterplot)
      
      shiny::updateSelectInput(
        inputId = "azmetStationTimeSeries",
        label = "AZMet Station",
        choices = c("Select a station..." = "", sort(azmetStationMetadata$meta_station_name)),
        selected = azmetStation() # Reactive value initialized in `_global.R`
      )
    })

    shiny::observeEvent(input$azmetStationTimeSeries, {
      azmetStation(input$azmetStationTimeSeries)
      
      shiny::updateSelectInput(
        inputId = "azmetStationScatterplot",
        label = "AZMet Station",
        choices = c("Select a station..." = "", sort(azmetStationMetadata$meta_station_name)),
        selected = azmetStation() # Reactive value initialized in `_global.R`
      )
    })
    
    shiny::observeEvent(input$batteryVariableScatterplot, {
      batteryVariable(input$batteryVariableScatterplot)
      
      shiny::updateSelectInput(
        inputId = "batteryVariableTimeSeries",
        label = "Battery Variable",
        choices = c("Select a variable..." = "", sort(batteryVariables$variable)),
        selected = batteryVariable() # Reactive value initialized in `_global.R`
      )
    })
    
    shiny::observeEvent(input$batteryVariableTimeSeries, {
      batteryVariable(input$batteryVariableTimeSeries)
      
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
    })
    
    shiny::observeEvent(input$weatherVariableScatterplot, {
      weatherVariable(input$weatherVariableScatterplot)
      
      shiny::updateSelectInput(
        inputId = "weatherVariableTimeSeries",
        label = "Weather Variable",
        choices = c("Select a variable..." = "", sort(weatherVariables$variable)),
        selected = weatherVariable() # Reactive value initialized in `_global.R`
      )
    })
    
    shiny::observeEvent(input$weatherVariableTimeSeries, {
      weatherVariable(input$weatherVariableTimeSeries)
      
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
    
    scatterplotTitle <-
      shiny::reactive({
        shiny::req(azmetStation(), batteryVariable(), weatherVariable())
        
        fxn_scatterplotTitle(
          startDate = input$startDate,
          endDate = input$endDate
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
    
    timeSeriesTitle <-
      shiny::reactive({
        shiny::req(azmetStation(), batteryVariable(), weatherVariable())
        
        fxn_timeSeriesTitle(
          startDate = input$startDate,
          endDate = input$endDate
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
    
    output$scatterplotTitle <- 
      shiny::renderUI({
        scatterplotTitle()
      })
    
    output$timeSeries <- 
      plotly::renderPlotly(timeSeries())
    
    output$timeSeriesTitle <- 
      shiny::renderUI({
        timeSeriesTitle()
      })
  }


# Run --------------------


shiny::shinyApp(ui = ui, server = server)
