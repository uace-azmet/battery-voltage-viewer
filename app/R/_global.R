# Libraries --------------------


library(azmetr)
library(bslib)
library(dplyr)
library(htmltools)
library(lubridate)
library(magrittr)
library(plotly)
library(shiny)
library(shinyjs)
library(tibble)
# library(vroom)


# Files --------------------


# Functions
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##_DEF.R", local = TRUE)


# Variables --------------------


azmetStationMetadata <- azmetr::station_info |>
  dplyr::mutate(end_date = NA) |> # Placeholder until inactive stations are in API and `azmetr`
  dplyr::mutate(
    end_date = dplyr::if_else(
      status == "active",
      lubridate::today(tzone = "America/Phoenix") - 1,
      end_date
    )
  ) |>
  dplyr::filter(status == "active") |>
  dplyr::arrange(meta_station_name)

batVoltStartDate <- lubridate::date("2021-01-01")

batteryVariables <- 
  tibble::tibble(
    name = 
      c("meta_bat_volt_max", "meta_bat_volt_mean", "meta_bat_volt_min"),
    
    variable = 
      c("Voltage maximum (V)", "Voltage average (V)", "Voltage minimum (V)")
  )

showNavsetCardTab <- shiny::reactiveVal(FALSE)
# showNavsetCardTabSidebar <- shiny::reactiveVal(FALSE)
# showPageBottomText <- shiny::reactiveVal(FALSE)

weatherVariables <- 
  tibble::tibble(
    name = 
      c(
        "relative_humidity_max", 
        "relative_humidity_mean", 
        "relative_humidity_min", 
        "sol_rad_total",
        "temp_air_maxC", 
        "temp_air_meanC", 
        "temp_air_minC"
      ),
    
    variable = 
      c(
        "Relative Humidity maximum (%)", 
        "Relative Humidity average (%)", 
        "Relative Humidity minimum (%)", 
        "Solar Radiation total (MJ/m^2)",
        "Air Temperature maximum (°C)", 
        "Air Temperature average (°C)", 
        "Air Temperature minimum (°C)"
      )
  )
