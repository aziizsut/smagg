#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

library(dygraphs)

ui1 <- fluidPage(
    
    titlePanel("Predicted Deaths from Lung Disease (UK)"),
    
    sidebarLayout(
        sidebarPanel(
            numericInput("months", label = "Months to Predict", 
                         value = 72, min = 12, max = 144, step = 12),
            selectInput("interval", label = "Prediction Interval",
                        choices = c("0.80", "0.90", "0.95", "0.99"),
                        selected = "0.95"),
            checkboxInput("showgrid", label = "Show Grid", value = TRUE)
        ),
        mainPanel(
            dygraphOutput("dygraph")
        )
    )
)

library(datasets)

server1 <- function(input, output) {
    
    predicted <- reactive({
        hw <- HoltWinters(ldeaths)
        predict(hw, n.ahead = input$months, 
                prediction.interval = TRUE,
                level = as.numeric(input$interval))
    })
    
    output$dygraph <- renderDygraph({
        dygraph(predicted(), main = "Predicted Deaths/Month") %>%
            dySeries(c("lwr", "fit", "upr"), label = "Deaths") %>%
            dyOptions(drawGrid = input$showgrid)
    })
    
}

# Run the application 
shinyApp(ui = ui1, server = server1)
