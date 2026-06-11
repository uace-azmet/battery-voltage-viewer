#' `fxn_azDaily.R` AZMet daily data download from API-based database
#' 
#' @param azmetStation - AZMet station name
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `azDaily` - Transformed tibble of requested AZMet daily data


fxn_azDaily <- 
  function(azmetStation, startDate, endDate) {
    
    azDaily <- azmetr::az_daily(
      station_id = azmetStation, 
      start_date = startDate, 
      end_date = endDate
    )
    
    # For case of empty data return
    if (nrow(azDaily) == 0) {
      azDaily <- data.frame(matrix(
        nrow = 0, 
        ncol = length(c(dailyVarsID, dailyVarsMeasure))
      ))
      
      colnames(azDaily) <- c(dailyVarsID, dailyVarsMeasure)
      
      renameColumns <- 
        dplyr::bind_rows(batteryVariables, weatherVariables) %>%
        dplyr::select(variable, name) %>%
        tibble::deframe()
      
      azDaily <- azDaily %>%
        dplyr::select(all_of(c(dailyVarsID, dailyVarsMeasure))) %>%
        dplyr::rename(!!! renameColumns)
    } else {
      renameColumns <- 
        dplyr::bind_rows(batteryVariables, weatherVariables) %>%
        dplyr::select(variable, name) %>%
        tibble::deframe()
      
      azDaily <- azDaily %>%
        #dplyr::mutate(dplyr::across("wind_2min_timestamp", as.character)) %>%
        dplyr::select(all_of(c(dailyVarsID, dailyVarsMeasure))) %>%
        dplyr::rename(!!! renameColumns)
    }
  
    return(azDaily)
  }
