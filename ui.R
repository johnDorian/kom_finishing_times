
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
load("data/race_speed.Rdata")

shinyUI(fluidPage(
#   tags$head(
#     tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
#   ),
  # Application title
  titlePanel(""),

  # Sidebar with a slider input for number of bins
  fluidRow(
    column(3,
    wellPanel(HTML("<h3>Race 1 options</h3>"),
      sliderInput("participants_1",
                  "Number of riders:",
                  min = 100,
                  max = 500,
                  value = 250),
      numericInput("distance_1", 'Race distance (km):', 100,
                   min = 50, max = 200),
      numericInput("average_1", 
                   'Average Speed (km/h):', 
                   round(race_speed$average[1]), 
                   step = 1,
                   min = 5, max = 50),
      numericInput("sd_1", 
                   'Standard deviation  of Speed (km/h):', 
                   round(race_speed$sd[1], 2), 
                   step = 0.01,
                   min = 1, max = 10),
      sliderInput("starting_times_1",
                  "Start and end of race start:",
                  min = as.POSIXlt("2016-05-01 07:00:00", tz = "UTC"),
                  max = as.POSIXlt("2016-05-01 12:00:00", tz = "UTC"),
                  step = 600,
                  value = as.POSIXlt(c("2016-05-01 08:30:00", "2016-05-01 09:30:00"), tz = "UTC"), 
                  timeFormat = "%T",
                  timezone = "UTC")
    ),
    wellPanel(HTML("<h3>Race 2 options</h3>"),
      sliderInput("participants_2",
                  "Number of riders:",
                  min = 100,
                  max = 500,
                  value = 250),
      numericInput("distance_2", 'Race distance (km):', 160,
                   min = 50, max = 200),
      numericInput("average_2", 
                   'Average Speed (km/h):', 
                   round(race_speed$average[2]), 
                   step = 1,
                   min = 5, max = 50),
      numericInput("sd_2", 
                   'Standard deviation  of Speed (km/h):', 
                   round(race_speed$sd[2], 2), 
                   step = 0.01,
                   min = 1, max = 10),
      sliderInput("starting_times_2",
                  "Start and end of race start:",
                  min = as.POSIXlt("2016-05-01 07:00:00", tz = "UTC"),
                  max = as.POSIXlt("2016-05-01 12:00:00", tz = "UTC"),
                  step = 600,
                  value = as.POSIXlt(c("2016-05-01 08:30:00", "2016-05-01 09:30:00"), tz = "UTC"), 
                  timeFormat = "%T",
                  timezone = "UTC")
    )
    ),
    

    # Show a plot of the generated distribution
  column(9,
         HTML("<h1>Estimated 2016 KOM Finishing Times</h1>"),
    plotOutput("finishing_times", width = "80%"),
    HTML("<h1>Estimated 2016 KOM Finishing Frequency</h1>"),
    plotOutput("finishing_freq", width = "80%")
    
  )
  )
)
)
