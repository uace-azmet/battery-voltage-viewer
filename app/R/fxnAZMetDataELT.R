#' `fxnAZMetDataELT.R` AZMet daily data download from API-based database
#' 
#' @param azmetStation - AZMet station name
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `dataAZMetDataELT` - Transformed tibble of requested AZMet daily data


fxnAZMetDataELT <- function(
    azmetStation, 
    startDate, 
    endDate
  ) {
  
  dataAZMetDataELT <- azmetr::az_daily(
    station_id = azmetStation, 
    start_date = startDate, 
    end_date = endDate
  )
  
  # Set identifying metadata and date variables of interest from the following daily data variables: 
  #c("date_doy", "date_year", "datetime", "meta_needs_review", "meta_station_id", "meta_station_name", "meta_version")
  varsID <- c(
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
  varsMeasure <- c(
    "meta_bat_volt_max", 
    "meta_bat_volt_mean", 
    "meta_bat_volt_min", 
    "relative_humidity_max", 
    "relative_humidity_mean", 
    "relative_humidity_min", 
    "sol_rad_total", 
    "temp_air_maxC", 
    "temp_air_meanC", 
    "temp_air_minC"
  )
  
  # For case of empty data return
  if (nrow(dataAZMetDataELT) == 0) {
    dataAZMetDataELT <- data.frame(matrix(
      nrow = 0, 
      ncol = length(c(varsID, varsMeasure))
    ))
    
    colnames(dataAZMetDataELT) <- c(varsID, varsMeasure)
    
    renameColumns <- 
      dplyr::bind_rows(batteryVariables, weatherVariables) %>%
      dplyr::select(variable, name) %>%
      tibble::deframe()
    
    dataAZMetDataELT <- dataAZMetDataELT %>%
      dplyr::select(all_of(c(varsID, varsMeasure))) %>%
      dplyr::rename(!!! renameColumns)
  } else {
    renameColumns <- 
      dplyr::bind_rows(batteryVariables, weatherVariables) %>%
      dplyr::select(variable, name) %>%
      tibble::deframe()
    
    dataAZMetDataELT <- dataAZMetDataELT %>%
      #dplyr::mutate(dplyr::across("wind_2min_timestamp", as.character)) %>%
      dplyr::select(all_of(c(varsID, varsMeasure))) %>%
      dplyr::rename(!!! renameColumns)
  }

  return(dataAZMetDataELT)
}
