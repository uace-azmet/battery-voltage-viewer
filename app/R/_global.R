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


azmetStation <- shiny::reactiveVal(value = NULL)

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

batteryVariable <- shiny::reactiveVal(value = NULL)

batteryVariables <- 
  tibble::tibble(
    name = 
      c("meta_bat_volt_max", "meta_bat_volt_mean", "meta_bat_volt_min"),
    
    variable = 
      c("Voltage maximum (V)", "Voltage average (V)", "Voltage minimum (V)")
  )

# Set identifying metadata and date variables of interest from the following daily data variables: 
#c("date_doy", "date_year", "datetime", "meta_needs_review", "meta_station_id", "meta_station_name", "meta_version")
dailyVarsID <- c(
  "meta_needs_review", 
  "meta_station_id", 
  "meta_station_name", 
  "meta_version", 
  "date_doy", 
  "date_year", 
  "datetime"
)

# Set measured and derived daily variables of interest from the following daily data variables:
# c("chill_hours_0C", "chill_hours_20C", "chill_hours_32F", "chill_hours_45F", "chill_hours_68F", "chill_hours_7C", "dwpt_mean", "dwpt_meanF", "eto_azmet","eto_azmet_in", "eto_pen_mon", "eto_pen_mon_in", "heat_units_10C", "heat_units_13C", "heat_units_3413C", "heat_units_45F", "heat_units_50F", "heat_units_55F", "heat_units_7C", "heat_units_9455F", "heatstress_cotton_meanC", "heatstress_cotton_meanF", "meta_bat_volt_max", "meta_bat_volt_mean", "meta_bat_volt_min", "precip_total_in", "precip_total_mm", "relative_humidity_max", "relative_humidity_mean", "relative_humidity_min", "sol_rad_total", "sol_rad_total_ly", "temp_air_maxC", "temp_air_maxF", "temp_air_meanC", "temp_air_meanF", "temp_air_minC", "temp_air_minF", "temp_soil_10cm_maxC", "temp_soil_10cm_maxF", "temp_soil_10cm_meanC",  "temp_soil_10cm_meanF", "temp_soil_10cm_minC", "temp_soil_10cm_minF", "temp_soil_50cm_maxC", "temp_soil_50cm_maxF", "temp_soil_50cm_meanC", "temp_soil_50cm_meanF", "temp_soil_50cm_minC", "temp_soil_50cm_minF", "vp_actual_max", "vp_actual_mean", "vp_actual_min", "vp_deficit_mean", "wind_2min_spd_max_mph", "wind_2min_spd_max_mps", "wind_2min_spd_mean_mph", "wind_2min_spd_mean_mps", "wind_2min_timestamp", "wind_2min_vector_dir", "wind_spd_max_mph", "wind_spd_max_mps", "wind_spd_mean_mph", "wind_spd_mean_mps", "wind_vector_dir", "wind_vector_dir_stand_dev", "wind_vector_magnitude", "wind_vector_magnitude_mph")
dailyVarsMeasure <- c(
  "meta_bat_volt_max", 
  "meta_bat_volt_mean", 
  "meta_bat_volt_min", 
  "relative_humidity_max", 
  "relative_humidity_mean", 
  "relative_humidity_min", 
  "sol_rad_total", 
  "temp_air_maxC", 
  "temp_air_meanC", 
  "temp_air_minC",
  "dwpt_mean"
)

showNavsetCardTab <- shiny::reactiveVal(FALSE)
# showNavsetCardTabSidebar <- shiny::reactiveVal(FALSE)
# showPageBottomText <- shiny::reactiveVal(FALSE)

weatherVariable <- shiny::reactiveVal(value = NULL)

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
        "temp_air_minC",
        "dwpt_mean"
      ),
    
    variable = 
      c(
        "Relative Humidity maximum (%)", 
        "Relative Humidity average (%)", 
        "Relative Humidity minimum (%)", 
        "Solar Radiation total (MJ/m^2)",
        "Air Temperature maximum (°C)", 
        "Air Temperature average (°C)", 
        "Air Temperature minimum (°C)",
        "Dew Point Temperature (°C)"
      )
  )
