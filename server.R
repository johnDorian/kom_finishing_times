
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(lubridate)
library(dplyr)
library(ggplot2)
library(reshape2)
load("data/race_speed.Rdata")

shinyServer(function(input, output) {
  
  output$finishing_times <- renderPlot({
    pred_race_results <- estimate_finishing_times(input$participants_1, input$distance_1, input$average_1, 
                                                  input$sd_1, 
                                                  input$starting_times_1[1], input$starting_times_1[2])
    pred_race_results$variable <- "race1"
    pred_race_results_2 <- estimate_finishing_times(input$participants_2, input$distance_2, input$average_2, 
                                                    input$sd_2, 
                                                    input$starting_times_2[1], input$starting_times_2[2])
    pred_race_results_2$variable <- "race2"
      full_join(pred_race_results, pred_race_results_2) %>% 
      ggplot() + geom_point(aes(dt, place, colour = variable), size = 3) +
      theme_bw(20) + xlab("Time") + ylab("Contestant placing") + 
      scale_colour_discrete("Race", labels = c("100 km", "100 mile"))

  })
  output$finishing_freq <- renderPlot({
    pred_race_results <- estimate_finishing_times(input$participants_1, input$distance_1, input$average_1, 
                                                  input$sd_1, 
                                                  input$starting_times_1[1], input$starting_times_1[2])
    pred_race_results$variable <- "race1"
    pred_race_results_2 <- estimate_finishing_times(input$participants_2, input$distance_2, input$average_2, 
                                                    input$sd_2, 
                                                    input$starting_times_2[1], input$starting_times_2[2])
    pred_race_results_2$variable <- "race2"
    
    total_line_crosses <- over_the_line(pred_race_results, pred_race_results_2)
  reshape2::melt(total_line_crosses[,1:3], id =  c("dt")) %>% 
    ggplot() + geom_bar(aes(dt, value, fill = variable), 
                        size = 1, stat = "identity") + 
    theme_bw(20) + xlab("Time") + ylab("Finishers (people/ 10 min)") + 
    scale_fill_discrete("Race", labels = c("100 km", "100 mile"))
  
})
})


estimate_finishing_times <- function(participants, race_length, average_speed,
                                     sd_speed, release_start, release_end) {
  
  speed <- rnorm(participants, average_speed, sd_speed)
  leaving_times <- sample(
    seq(release_start, release_end, by = "10 min"), 
    participants, replace = TRUE)
  finishing_time <- leaving_times + (race_length/speed)*60*60
  data.frame(dt = sort(finishing_time), place = 1:participants)
}

over_the_line <- function(race1, race2) {
  race1_result <- race1 %>% 
    group_by(dt = dt - (minute(dt)%%(10)*60+second(dt))) %>% 
    summarise(race1 = n())
  race2_result <- race2 %>% 
    group_by(dt = dt - (minute(dt)%%(10)*60+second(dt))) %>% 
    summarise(race2 = n())
  all_finishers <- full_join(race1_result, race2_result, by = "dt") %>% 
    mutate(race1 = ifelse(is.na(race1), 0 , race1), 
           race2 = ifelse(is.na(race2), 0 , race2),
           total = race1 + race2) %>% 
    arrange(dt)
  all_finishers
}

