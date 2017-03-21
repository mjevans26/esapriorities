shinyServer(function(input, output, session) {
  tab <- reactive({
    switch(input$scale, 
           "Priority" = priority_timetable, 
           "LPN" = LPN_timetable)
  })
  
  output$timeline <- renderHighchart2({
    hchart(tab(),
           "line",
           x = Timeframe,
           y = Freq,
           group = tab()[[input$scale]]) %>%
    # hc_add_series_labels_values(tab(),)
    hc_colors(substr(viridis(5), 0, 7))
  })

  output$time2 <- renderPlotly({
    cur_dat <- tab()
    grp <- cur_dat[[input$scale]]
    cur_dat$bins <- grp
    bin <- factor(cur_dat[[input$scale]])
    gg <- ggplot(data = cur_dat,
                 aes(x = Timeframe, 
                     y = Freq, 
                     group = bins,
                     text = paste0("<b>Species</b>: <br>", Text)))+
          geom_point(aes(colour = bin))+
          geom_line(aes(colour = bin)) +
          ggtitle("Timeline of Species Reviews")+
          xlab("Fiscal year")+
          ylab("Number of Species")+
          scale_color_viridis(discrete = TRUE) +
          theme_hc()
    # return(ggplotly(gg))
    p <- plotly_build(gg)
    for(i in 1:length(p$x$data)){
      p$x$data[[i]]$text <- gsub("Freq", "\\# of Species", p$x$data[[i]]$text)
      p$x$data[[i]]$text <- gsub("bins: [0-9]<br>", "", p$x$data[[i]]$text)
    }
    p
  })

  output$dtable <- renderDataTable({data_clean[,c(2,3,4,6,7,8,9,10)]})
})

