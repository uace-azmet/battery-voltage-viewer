# "Hard-code" Bootstrap version before deployment
# https://rstudio.github.io/bslib/articles/dashboards/index.html
#bslib::version_default()

theme = 
  bslib::bs_theme(
    version = 5, 
    bootswatch = NULL,
    "input-border-color" = "red"#rgb(0, 0, 0, .125)
  )

