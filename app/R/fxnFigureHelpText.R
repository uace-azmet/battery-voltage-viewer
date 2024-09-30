#' `fxnFigureHelpText.R` - Build help text for figure
#' 
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `figureHelpText` - Help text for figure


fxnFigureHelpText <- function(
    startDate, 
    endDate
  ) {
  
  figureHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Data are from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), ". Hover over data for variable values and click or tap on legend items to toggle data visibility. Select from the icons to the right of the graph for additional functionality."
      ), 
      
      class = "figure-help-text"
    )
  
  return(figureHelpText)
}
