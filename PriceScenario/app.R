library(shiny)
library(shinydashboard)
library(dygraphs)
library(datasets)

# sidebar -----------------------------------------------------------------


sidebar <- dashboardSidebar(sidebarMenu(
  menuItem(
    "Introduction",
    tabName = "intro",
    icon = icon("power-off")
  ), # 1st Menu item 
  menuItem(
    "Pricing Scenarios",
    tabName = "pricing",
    icon = icon("donate")
  ), # 2nd menu item
  menuItem(
    "Company Flex Profile",
    tabName = "profile",
    icon = icon("building")
  )
))


# body --------------------------------------------------------------------

intro1 <- "This is a simple mock-up for the simulation model to calculate the impact of Flex market for a company"

body <- dashboardBody(
  # Here start the dashboard application
  tabItems(
    
    tabItem(tabName = "intro",
            h2("Flexible Electricity Market", 
               style = "font-weight: 250; color: #4d3a7d;"),
            p(intro1,
              style = "font-weight: 120;")),

# Pricing Tabs ------------------------------------------------------------
# In this tabs we can see the building blocks for the input mechanism
# The substation also contains physical capacity limit of the susbstation
    
    tabItem(tabName = "pricing",
            br(),
            fluidRow(
              column(width = 4,
              box(title = "Pricing Scenarios", 
                   height = 300,
                   br(),
                   "You may select your pricing options here",
                   br(),
                   radioButtons("priceScen", "Pricing Options:",
                                c("Time of Use" = "timing",
                                  "Critical Peak" = "unif",
                                  "Real-Time Pricing" = "rtp",
                                  "Flat Pricing" = "flat")),
                  actionButton("sims", "Simulate Now", icon = icon("play-circle"))
                                     
            ), # box 1 closing bracket
            box(title = "Substation Capacity", status = "warning", 
                height = 300, solidHeader = TRUE, # line for the substation hard constraints 
                br(),
                sliderInput("substation", "Substation Capacity (in kVA):",
                            min = 50, max = 100, value = 60, step = 5),
                sliderInput("kwhPrice", "Normal Capacity Price (in Eurocent per kVA):",
                            min = 1, max = 80, value = 12, step = 1)
            ), # box 2 closing bracket
            
            box(title = "Capacity Pricing",  
                height = 300, # line for the substation hard constraints 
                br(),
                numericInput("safe", "Normal Zone Limit (in kVA):", 200, min = 100, max  = 300, step = 10),
                numericInput("warning", "Warning Zone Limit (in kVA):", 250, min = 150, max = 350, step = 10),
                numericInput("danger", "Dangerous Zone Limit (in kVA):", 350, min = 250, max = 450, step = 10)
            ),
            
            box(title = "Capacity Pricing Range",
                height = 300,
                plotOutput("capPrice"))
            
            ), # end of column1 
            
            fluidRow(
            column(width = 7,
            box(title = "Monthly Chart", height = 500, width = 12,
                dygraphOutput("balance")),
            infoBox(title = "Energy Expenditure", icon = icon("donate"), value = paste0(200, "\u20AC"), color = "orange"),
            infoBox(title = "Energy Exported to Grid", icon = icon("plug"), value = paste0(300, "kWh"), color = "orange"),
            infoBox(title = "Flex Production used", icon = icon("charging-station"), value = paste0(200, "kWh"), color = "orange")
            ))
            )  # box 3 closing bracket and fluid row

            
            ),  # tabitem closing bracket

  tabItem(tabName = "profile",
        box(width = 3, status = "warning", solidHeader = TRUE,
            title = "Company VRE Production",
            checkboxInput("flexp", "Participating in Flex", value = FALSE),
            numericInput("panels", "Solar Panels Installed (in kWp):", 20, min = 0, max = 999, step = 1),
            numericInput("solaryeild", "Solar Panel Production yield (in kWh per kWp):", 850, min = 0, max = 2000, step = 50)
        ),
        
        fluidRow(
          column(width = 8,
                
                 box(width = 10, height = 500,
                     status = "primary", solidHeader = TRUE,
                     title = "Market Price Condition",
                     dygraphOutput("pricing"))
                 )
        )
        
        
        )

  ) # tabitems closing

) # dashboarbody closing


# UI panel ---------------------------------------------------------


ui <- dashboardPage(
  dashboardHeader(title = "Pricing Options Effect"),
  sidebar = sidebar,
  body = body
)


# Execution block ---------------------------------------------------------


server <- function(input, output) {


# capacity page section ---------------------------------------------------

  dsetBalance <- reactive({
    cbind(mdeaths, fdeaths)
    })
  
  output$balance <- renderDygraph({
    dygraph(dsetBalance()) %>% 
    dySeries("mdeaths", label = "Consumption") %>%
      dySeries("fdeaths", label = "Production") %>%
      dyOptions(stackedGraph = TRUE) %>%
      dyRangeSelector(height = 20)
  })
  
  predicted <- reactive({
  hw <- HoltWinters(ldeaths)
  predict(hw, n.ahead = 36, 
          prediction.interval = TRUE,
          level = as.numeric(0.95))
  })
  
  output$pricing <- renderDygraph({
    dygraph(predicted(), main = "Predicted Pricing/Days") %>%
      dySeries(c("lwr", "fit", "upr"), label = "Cent per kWh") 
  })
  

# data capacity -----------------------------------------------------------

  # plotBase <- reactive({
  #   
  #   input$safe
  #   
  # })
  # 
  # output$capPrice <- renderPlot({
  #   
  #   
  #   
  # })
  
}

shinyApp(ui, server)
