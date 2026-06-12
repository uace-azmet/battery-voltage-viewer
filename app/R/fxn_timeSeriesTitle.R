#' `fxn_timeSeriesTitle.R` - Build title for time series tab
#' 
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `timeSeriesTitle` - Title for time series tab


fxn_timeSeriesTitle <- function(startDate, endDate) {
  timeSeriesTitle <- 
    htmltools::p(
      htmltools::HTML(
        paste0(
          bsicons::bs_icon("graph-up", class = "bolder-icon"),
          htmltools::HTML("&nbsp;&nbsp;"),
          toupper(
            paste0(
              "<strong>Daily data from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " across the network</strong>"
            )
          ),
          htmltools::HTML("&nbsp;")
        )
      ),
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        "Hover over data for variable values and click or tap on legend items to toggle data visibility. Select from the icons to the right of the graph for additional functionality.",
        id = "infotimeSeriesTitle",
        placement = "right"
      ),
      
      class = "time-series-title"
    )
  
  return(timeSeriesTitle)
}
