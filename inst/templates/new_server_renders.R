output$<%=name%>_plot <- renderPlot({
  ggplot(<%=name%>_data()) +
    geom_point(aes(dist, speed))
})
