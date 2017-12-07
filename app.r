source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
      ),
    
    mainPanel(plotOutput("map"))
  )
  )

# Server logic ----
server <- function(input, output) {
  
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    color <- switch(input$var, 
                    "Percent White" = "blue",
                    "Percent Black" = "green",
                    "Percent Hispanic" = "red",
                    "Percent Asian" = "yellow")
    
    legend <- switch(input$var, 
                     "Percent White" = "Percent White",
                     "Percent Black" = "Percent Black",
                     "Percent Hispanic" = "Percent Hispanic",
                     "Percent Asian" = "Percent Asian")
    
    
    
    percent_map(var = data, color = color, legend.title = legend,
                input$range[1], input$range[2])
  })
}


# Run app ----
shinyApp(ui, server)