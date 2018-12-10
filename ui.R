#############################################################
# NAME:        ui.R
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
# rm(list = ls())
library(shinydashboard)
library(shiny)
data <- readRDS('data/data.rds')

#### header ####
header <- dashboardHeader(
  title = "R-Ladies Demo"
)

#### sidebar ####
sidebar <- dashboardSidebar(
  tags$head(tags$style(HTML('.shiny-server-account { display: none; }'))),

  sidebarMenu(
    menuItem("Figure Options", tabName = "dashboard", icon = icon("dashboard")),

    br(),
    p(tags$b('Figure 1')),
    # figure 1 metric
    selectizeInput(
      "metric1",
      "Choose a metric:",
      unique(data$metric) ),

    # figure 1 drug type
    selectizeInput(
      "drug_type1",
      "Choose a drug type:",
      c('All Drugs'='',unique(data$drug_type)) ),

    # figure 1 normalization type
    selectizeInput(
      "normal_type1",
      "Aggregate or Ratio/1000:",
      unique(data$normal_type) ),

    p(tags$b('Figure 2')),
    # figure 2 metric
    selectizeInput(
      "metric2",
      "Choose a metric:",
      unique(data$metric) ),

    # figure 2 drug type
    selectizeInput(
      "drug_type2",
      "Choose a drug type:",
      c('All Drugs'='',unique(data$drug_type)) ),

    # figure 2 normalization type
    selectizeInput(
      "normal_type2",
      "Aggregate or Ratio/1000:",
      unique(data$normal_type) )
  )
)

#### body ####
body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "axial_style.css")
  ),
  tabItems(
    tabItem(tabName = 'dashboard',
              fluidRow(

                # Figure 1
                column(6, plotOutput(outputId = "p1")),

                # Figure 2
                column(6, plotOutput(outputId = "p2"))
              ),
              fluidRow(
                column(1),
                column(10,
                HTML('<font size="3"><br><br><b>About:</b> This is a brief report on patterns of Medicare Part D drug prescriptions and fatal drug overdoses in 2016. <br>
                     <br><b>Purpose:</b> The purpose of this report is to demonstrate some of the ways that we explore and visualize data at axialHealthcare, not necessarily to showcase comprehensive analyses on the subject matter. In fact, some of the analyses would be quite primitive given limited data resources.<br>
                     <br><b>Data sources:</b> The state-level summary of drug prescriptions data were retrieved from <a href="https://data.cms.gov/Medicare-Part-D/Part-D-Prescriber-State-Summary-Report-Calendar-Ye/hjv3-puc7">data.cms.gov</a>. The fatal drug overdoses data were retrieved from <a href="https://www.cdc.gov/nchs/pressroom/sosmap/drug_poisoning_mortality/drug_poisoning.htm">CDC</a>.<br>
                     <br><b>Author:</b> Jianhong (May) Shen. Research Data Scientist, axialHealthcare.
                     </font>') ),
                column(1)
              )
            )

    )
    )

#### page ####
dashboardPage( header, sidebar, body)
