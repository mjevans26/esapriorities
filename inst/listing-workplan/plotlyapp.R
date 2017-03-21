# load all dependencies and data
library(shiny)
library(esapriorities)
library(plotly)

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
  fluidRow(
    column(1, br()),
    column(1, 
      a(href = "http://www.defenders.org", 
        imageOutput("defenders", height = NULL))),
    column(2, 
      br(),
      p(tags$b("Defenders of Wildlife"), 
      br(),
      tags$b("Center for Conservation Innovation"))
    ),
    column(6, h1("Workplan Explorer", align="center")),
    column(5, br())),
  fluidRow(
    column(10, 
      sidebarLayout(
        sidebarPanel(selectInput("scale", label = "Select a Priortization Scheme", choices = list("Priority Bins"="Priority", "Listing Priority Number"="LPN"), selected="Priority", multiple=FALSE)),
        mainPanel(p("The U.S. Fish and Wildlife Service (FWS) released a 7-year workplan used to prioritize ongoing
                  species status reviews. FWS uses two different prioritization schemes; a 1-5 priority bin for status 
                  reviews of non-candidate species, and the Listing Priority Number (LPN) of current candidate species. 
                  Mouse over the interactive timeline to see a sample of species scheduled for review in a given 
                  fiscal year. For more details on the 7-year workplan, visit:", a("https://www.fws.gov/endangered/improving_esa/listing_workplan.html")))
      ),
    plotlyOutput("timeline")
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
  
  output$timeline <- renderPlotly({
    gg<- ggplot(tab(),aes(x = Timeframe,
                     y = Freq,
                     group = get(input$scale),
                     text = paste("<b>Species</b>: <br>",Text)))+
           geom_point(aes(colour = factor(get(input$scale))))+
           geom_line(aes(colour = factor(get(input$scale))))+
           ggtitle("Timeline of Species Reviews")+
           xlab("Fiscal year")+
           ylab("Number of Species")+
           scale_color_discrete(name = input$scale)
    p <- plotly_build(gg)
    for(i in 1:length(p$data)){
      p$data[[i]]$text <- gsub("factor\\(get\\(input\\$scale\\)\\): .","",p$data[[i]]$text)
      p$data[[i]]$text <- gsub("get\\(input\\$scale\\)","Priority",p$data[[i]]$text)
      p$data[[i]]$text <- gsub("Freq","\\# of Species",p$data[[i]]$text)
    }
    plot_ly(p)
  })

  output$dtable <- renderDataTable({data_clean[,c(2,3,4,6,7,8,9,10)]})
}

shinyApp(ui = ui, server = server)







