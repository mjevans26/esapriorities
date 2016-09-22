# load all dependencies and data
library(shiny)
library(esapriorities)
library(highcharter)

data("data_clean")
data("data_states")

# create summary tables for plotting timelines of reviews
priority_timetable <- as.data.frame(with(data_clean, table(Timeframe, Priority)))
priority_timetable$Priority <- as.numeric(priority_timetable$Priority)
priority_timetable$Species <- sapply(1:length(priority_timetable$Timeframe), function(x,y,z) z$Species.name[which(z$Timeframe == y[x,1] & z$Priority == y[x,2])], y = priority_timetable, z = data_clean)
priority_timetable$Text <- sapply(1:length(priority_timetable$Timeframe), function(x,y,z) paste(z$Species.name[which(z$Timeframe == y[x,1] & z$Priority == y[x,2])][1:5],collapse="<br>"), y = priority_timetable, z = data_clean)
priority_timetable$Text <- gsub("<br>NA", "", priority_timetable$Text)

LPN_timetable <- as.data.frame(with(data_clean, table(Timeframe, LPN)))
LPN_timetable$LPN <- as.numeric(as.character(LPN_timetable$LPN))
LPN_timetable$Species <- sapply(1:length(LPN_timetable$Timeframe), function(x,y,z) z$Species.name[which(z$Timeframe == y[x,1] & z$LPN == y[x,2])], y = LPN_timetable, z = data_clean)
LPN_timetable$Text <- sapply(1:length(LPN_timetable$Timeframe), function(x,y,z) paste(z$Species.name[which(z$Timeframe == y[x,1] & z$LPN == y[x,2])][1:5],collapse="<br>"), y = LPN_timetable, z = data_clean)
LPN_timetable$Text <- gsub("<br>NA", "", LPN_timetable$Text)

ui <- fluidPage(
  h1("Workplan Explorer", align="center"),
  fluidRow(
    column(1, br()),
    column(10, 
      sidebarLayout(
        sidebarPanel(selectInput("scale", label = "Select a Priortization Scheme", choices = list("Priority Bins"="Priority", "Listing Priority Number"="LPN"), selected="Priority", multiple=FALSE)),
        mainPanel(p("The U.S. Fish and Wildlife Service (FWS) released a 7-year workplan used to prioritize ongoing
                  species status reviews. FWS uses two different prioritization schemes; a 1-5 priority bin for status 
                  reviews of non-candidate species, and the Listing Priority Number (LPN) of current candidate species. 
                  Mouse over the interactive timeline to see a sample of species scheduled for review in a given 
                  fiscal year. For more details on the 7-year workplan, visit:", a("https://www.fws.gov/endangered/improving_esa/listing_workplan.html")))
      ),
    highchartOutput("timeline")
    ),
    column(1, br())
  ),
  
  fluidRow(
    column(1, br()),
    column(10,
    h2("Interactive Workplan Table", align= "center"),
    p("The interactive table below contains data from the full 7-year workplan.  Each row documents a species for which a
      status assessment is pending, and includes information about the type of review action planned, the species' geographic range, 
      and the anticipated fiscal year of status review. Use the sort, search, and filtering tools to explore the data.  
      The filtering tools at the bottom of each column can be used to select records based on specific criteria. For instance, 
      finding all pending species in a state, or identifying species with high priority scheduled for review in later years."),
    dataTableOutput("dtable")
    ),
    column(1, br())
  )
)

server <- function(input, output) {
  tab <- reactive({
    switch(input$scale, 
           "Priority" = priority_timetable, 
           "LPN" = LPN_timetable)
  })
  
  output$timeline <- renderHighchart({
    cht <- hchart(tab(), "line", x = Timeframe, y = Freq, group = tab()[[input$scale]])%>%
      hc_tooltip(pointFormat = sprintf("%s: {point.%s}<br>
                                  # Species: {point.y}<br>
                                  <b>Species:<\b><br>
                                  {point.Text}", input$scale, input$scale))%>%
      hc_title(text = "Timeline of Species Reivews", align = "center")%>%
      hc_xAxis(title = list(text = "Fiscal Year"))%>%
      hc_yAxis(title = list(text = "Number of Species"))%>%
      hc_legend(title = list(text = sprintf("%s<br><em>(click to hide)</em>",input$scale)), 
                layout = "vertical", align = "right", verticalAlign = "top", y = 100)
  })

  output$dtable <- renderDataTable({data_clean[,c(2,3,4,6,7,8,9,10)]})
}

shinyApp(ui = ui, server = server)







