#' `fxn_scatterplotTitle.R` - Build title for scatterplot tab
#' 
#' @param inData - daily AZMet data from `azDaily()`
#' @return `scatterplotTitle` - Title for scatterplot tab


fxn_scatterplotTitle <- 
  function(inData) {
    
    scatterplotTitle <- 
      htmltools::p(
        htmltools::HTML(
          paste0(
            bsicons::bs_icon("graph-up", class = "bolder-icon"),
            htmltools::HTML("&nbsp;&nbsp;"),
            toupper(
              paste0(
                "<strong>Daily data from ", gsub(" 0", " ", format(min(inData$datetime), "%B %d, %Y")), " through ", gsub(" 0", " ", format(max(inData$datetime), "%B %d, %Y")), " across the network</strong>"
              )
            ),
            htmltools::HTML("&nbsp;")
          )
        ),
        
        bslib::tooltip(
          bsicons::bs_icon("info-circle"),
          "Hover over data for variable values and click or tap on legend items to toggle data visibility. Select from the icons to the right of the graph for additional functionality.",
          id = "infoScatterplotTitle",
          placement = "right"
        ),
        
        class = "scatterplot-title"
      )
    
    return(scatterplotTitle)
  }
