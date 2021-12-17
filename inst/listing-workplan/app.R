# load all dependencies and data
library(shiny)
library(esapriorities)
library(highcharter)
library(DT)

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

bin_table <- data.frame("Bin" = c(1, 2, 3, 4, 5),
           "Description" = c("Highest priority: Critically imperiled", "Strong status data available", "New science underway", "Conservation efforts underway", "Limited data"))


ui <- fluidPage(
#  shinyjs::useShinyjs(),
  fluidRow(column(1, br()),
           column(1, a(href = "http://www.defenders.org",imageOutput("defenders", height = NULL))),
           column(2, br(),p(tags$b("Defenders of Wildlife"), br(),tags$b("Center for Conservation Innovation"))),
           column(6, h1("ESA Listing Workplan Explorer", align="left")),
           column(5, br())),
  fluidRow(
    column(1, br()),
    column(10, 
      sidebarLayout(
        sidebarPanel(selectInput("scale", label = "Select a Prioritization Scheme", choices = list("Priority Bins"="Priority", "Listing Priority Number"="LPN"), selected="Priority", multiple=FALSE)),
        mainPanel(p("In September 2016, the U.S. Fish and Wildlife Service (FWS) released a 7-year workplan to prioritize
                  species for listing review. FWS uses two different prioritization schemes: a 1-5 priority bin for status 
                  reviews of species awaiting 12-month findings, and the Listing Priority Number (LPN) of species identified as 'candidates' for listing. 
                  We have extracted these records from the FWS workplan and reproduced them below in an interactive chart and table,
                  so you can easily explore the data.  For example, you can mouse over the interactive timeline to see a sample of species scheduled for review in a given 
                  fiscal year. For more details on the 7-year workplan, visit:", a("https://www.fws.gov/endangered/improving_esa/listing_workplan.html")))
      )
    ),
    column(1, br())
  ),
  
  
  fluidRow(
    column(1, br()),
    column(7,
      highchartOutput("timeline")
    ),
    column(3, conditionalPanel(condition = "input.scale == 'Priority'",
      h4("Priority Bin Definitions"),
      tableOutput("btable"),
      p("Detailed bin descriptions available at ", 
        a(href= "https://www.fws.gov/endangered/improving_esa/listing_workplan_prioritization_methodology.html", "FWS workplan page."))
    )),
    column(1, br())
  ),

  
  fluidRow(
    column(1, br()),
    column(10,
    h2("Interactive Workplan Table", align= "center"),
    p("The interactive table below contains data from the full 7-year workplan.  Each row documents a species for which a
      status assessment is pending, and includes information about the type of review action planned, the species' geographic range, 
      and the anticipated fiscal year of status review. Use the sort, search, and filtering tools to explore the data.  
      The filtering tools can be used to select records based on specific criteria. For instance, you can find 
      all pending species in a state, or identify species with a high priority scheduled for review in later years."),
    numericInput("rows","Records per Page:", 10, min = 10, max = 50, step = 10),
    dataTableOutput("dtable")
    ),
    column(1, br())
  ),
  br(),
  fluidRow(column(2),
           column(4, div(HTML('<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">
                              <img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a>
                              <br />
                              This <span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/InteractiveResource" rel="dct:type">work</span>
                              by <a xmlns:cc="http://creativecommons.org/ns" href="http://defenders.org" property="cc:attributionName" rel="cc:attributionURL">Defenders of Wildlife</a>
                              is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
                              <br />'),
                         style = "text-align: center")),
           column(1),
           column(2, div(HTML('<br /> Email questions or comments to <a href = "mailto:esa@defender.org"> esa@defenders.org </a>'), style = "text-align: center"))
           )
)

server <- function(input, output, session) {
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
      hc_title(text = "Timeline of Species Reviews", align = "center")%>%
      hc_xAxis(title = list(text = "Fiscal Year"))%>%
      hc_yAxis(title = list(text = "Number of Species"))%>%
      hc_legend(title = list(text = sprintf("%s<br><em>(click to hide)</em>",input$scale)), 
                layout = "vertical", align = "right", verticalAlign = "top", y = 25, floating = TRUE,
                borderColor = "black", borderWidth = 1, backgroundColor = "white")%>%
      hc_exporting(enabled = TRUE)
  })

  output$dtable <- renderDataTable({
    the_dat <- data_clean[,c(2,3,4,6,7,8,9,10)]
    datatable(the_dat, 
                  rownames = FALSE,
                  class = "cell-border stripe",
                  filter = "top",
                  colnames = c("Species", "Proposed Action", "Lead Office", "Timeframe", "Current Candidate", "Range", "LPN", "Priority Bin"),
                  extensions = "Buttons",
                  options = list( dom = "Bfrtip", buttons = c("copy", "csv", "excel", "print"),
                  pageLength = input$rows)
      )
  })
  

  output$btable <- renderTable({bin_table
    }, include.rownames = FALSE, digits = 0)
  
  output$defenders <- renderImage({
    width <- session$clientData$output_defenders_width
    if (width > 100) {
      width <- 100
    }
    list(src = "01_DOW_LOGO_COLOR_300-01.png",
         contentType = "image/png",
         alt = "Overview of section 7 consultation",
         width=width)
  }, deleteFile=FALSE)
}

shinyApp(ui = ui, server = server)







