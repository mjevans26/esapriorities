# load all dependencies and data
library(shiny)
library(esapriorities)
#load("data/data.rda")
#load("data/data_states.rda")
data(data)
data(data_states)
# create summary tables for plotting timelines of reviews
priority_timetable <- with(data, table(Timeframe, Priority))
LPN_timetable <- with(data, table(Timeframe, LPN))

ui <- fluidPage(
  
  titlePanel("Workplan Explorer"),
  
  fluidRow(
    sidebarLayout(
      sidebarPanel(selectInput("scale", label = "Select a Priortization Scheme", choices = list("Priority", "LPN"), selected="Priority", multiple=FALSE)),
      mainPanel(p("The U.S. Fish and Wildlife Service (FWS) released a 7-year workplan used to prioritize ongoing
                  species status reviews. FWS uses two different prioritization schemes; a 1-5 priority bin for status 
                  reviews of non-candidate species, and the Listing Priority Number (LPN) for current candidate species. 
                  Use the to see the timeline of species reviews by level of priority under each system. For more details on the
                  7-year workplan, visit", a("https://www.fws.gov/endangered/improving_esa/listing_workplan.html")))
    ),
    plotOutput("timeline")
  ),
  
  fluidRow(
    h2("Interactive Workplan Table", align= "center"),
    p("The interactive table below contains data from the full 7-year workplan.  Each row documents a species for which a
      status assessment is pending, and includes information about the type of review action planned, the species' geographic range, 
      and the anticipated fiscal year of status review. Use the sort, search, and filtering tools to explore the data.  
      The filtering tools at the bottom of each column can be used to select records based on specific criteria. For instance, 
      finding all pending species in a state, or identifying species with high priority scheduled for review in later years."),
    dataTableOutput("dtable")
  )
)

server <- function(input, output) {
  tab <- reactive({switch(input$scale, "Priority" = priority_timetable, "LPN" = LPN_timetable)
  })
  
  output$timeline <- renderPlot({
   matplot(tab(), lwd = 2, pch = 1, main = "Timeline of Species Reviews", ylab = "Number of Reviews", xlab = "Fiscal Year", xaxt = "n", col = 1:ncol(tab()))
   matlines(tab(), lty = 1, lwd = 2)
   axis(side = 1, at = 1:nrow(tab()), labels = rownames(tab()))
   legend(x = "topright", title = input$scale, legend = c(colnames(tab())), lty = 1, lwd = 2, col = 1:ncol(tab()))
  })
  output$dtable <- renderDataTable({data[,c(2,3,4,6,7,8,9,10)]})
}

shinyApp(ui = ui, server = server)






