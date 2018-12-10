#############################################################
# NAME:        server.R
# ONELINER:    R shiny app demo for R-Ladies
# CLIENT:
# LANGUAGE:    R (version 3.4.3)
# EXECUTABLE:  ?
# AUTHOR:      May Shen
# EMAIL:       mshen@axialhealthcare.com
# CREATED:     2018-12-04
#
# DEPENDENCIES:
#     R packages: shiny, shinydashboard
# HARDCODINGS:
#
# PARAMETERIZATIONS:
#
# MODIFIED:    Check GitHub for history.
# JIRA Ticket:
# Confluence Page:
#
# DESCRIPTION:
#   R Shiny app demo
# reference this for customizing icons https://gist.github.com/leonawicz/0fab3796b02a62b7f3bd0c02a171f0b7
#############################################################
#### Environment Prep ####
library(maps)
library(ggplot2)
library(dplyr)
library(shiny)
data <- readRDS('data/data.rds')

shinyServer(function(input, output, session) {

  ## update select input based on interactions
  observe({
    drug_type_1 <- unique(data$drug_type[data$metric == input$metric1])
    names(drug_type_1) <- drug_type_1

    # update drug type options
    updateSelectizeInput(session, "drug_type1",
                      label = "Choose a drug type:",
                      choices = drug_type_1 )

    drug_type_2 <- unique(data$drug_type[data$metric == input$metric2])
    names(drug_type_2) <- drug_type_2

    # update drug type options
    updateSelectizeInput(session, "drug_type2",
                         label = "Choose a drug type:",
                         choices = drug_type_2 )
  })

  ## a function to generate plot
  f_plot <- function(metric_i, drug_i, norm_i) {
    title_i <- ifelse(metric_i == 'Fatal Drug Overdose', metric_i,
                      paste(metric_i, drug_i, sep = ' - '))
    legend_i <- ifelse(norm_i == 'Aggregate', 'State Aggregate', 'State Ratio Per Thousand')

    # map data
    all_states <- map_data("state")

    plot <- data %>%
      filter(metric == metric_i, normal_type == norm_i, drug_type == drug_i) %>%
      mutate( state = tolower(`State Name`) ) %>%
      merge( all_states, by.x="state", by.y="region" ) %>%
      select(-subregion, -order) %>%
      ggplot() +
      geom_map(map = all_states, aes( x = long, y = lat, map_id = state,fill = value) )  +
      geom_text( data = data.frame( state.center, state.abb ),
                 aes( x = x, y=y,label = state.abb), size = 3) +
      scale_fill_continuous( low = 'gray85', high = 'darkred',
                             guide = guide_colorbar(ticks = FALSE, barheight = 1,
                                                    barwidth = 10, title.vjust = .8,
                                                    values = c(0.2,0.3))) +
      labs(title = title_i, fill = legend_i) +
      theme(axis.text = element_blank(),
            axis.title = element_blank(),
            axis.ticks = element_blank(),
            legend.position = "bottom" )
    return(plot)
  }

  ## Figure 1 output
  output$p1 <- renderPlot({
    p_1 <- f_plot(input$metric1, input$drug_type1, input$normal_type1)
    print(p_1)
  })

  ## Figure 2 output
  output$p2 <- renderPlot({
    p_2 <-  f_plot(input$metric2, input$drug_type2, input$normal_type2)
    print(p_2)
  })

})
