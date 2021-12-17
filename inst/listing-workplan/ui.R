# BSD_2_clause

ui <- fluidPage(
  h1("Workplan Explorer", align="center"),
  fluidRow(
    column(1, br()),
    column(10, 
      sidebarLayout(
        sidebarPanel(
          selectInput("scale", 
                      label = "Select a Priortization Scheme", 
                      choices = list("Priority Bins" = "Priority", 
                                     "Listing Priority Number" = "LPN"), 
                      selected="Priority", multiple=FALSE
          )
        ),
        mainPanel(
          p("The U.S. Fish and Wildlife Service (FWS) released a 7-year workplan 
            used to prioritize ongoing species status reviews. FWS uses two 
            different prioritization schemes; a 1-5 priority bin for status 
            reviews of non-candidate species, and the Listing Priority  Number 
            (LPN) of current candidate species. Mouse over the interactive 
            timeline to see a sample of species scheduled for review in a given 
            fiscal year. For more details on the 7-year workplan, visit:", 
            a("https://www.fws.gov/endangered/improving_esa/listing_workplan.html")
            )
          )
        ),
    highchartOutput2("timeline"),
    plotlyOutput("time2")
    ),
    column(1, br())
  ),
  
  fluidRow(
    column(1, br()),
    column(10,
    h2("Interactive Workplan Table", align= "center"),
    p("The interactive table below contains data from the full 7-year workplan. 
      Each row documents a species for which a status assessment is pending, and 
      includes information about the type of review action planned, the species' 
      geographic range, and the anticipated fiscal year of status review. Use 
      the sort, search, and filtering tools to explore the data. The filtering 
      tools at the bottom of each column can be used to select records based on 
      specific criteria. For instance, finding all pending species in a state, 
      or identifying species with high priority scheduled for review in later 
      years."),
    dataTableOutput("dtable")),
    column(1, br())
  )
)

# shinyApp(ui = ui, server = server)
