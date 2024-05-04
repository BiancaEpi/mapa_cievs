
server <- function(input, output) {
  
 
  
   output$mapa <- renderLeaflet({
     
    
    mapa <- leaflet() %>%
      setView(lng = -49.4918, lat = -28.9356, zoom = 10) %>% # Coordenadas iniciais do mapa
      addTiles() # Adicionar azulejos de mapa padrão
    
    
    
    for (i in 1:nrow(local_cievs)) {
      mapa <- mapa %>%
        addMarkers(lng = local_cievs$longitude[i], 
                   lat = local_cievs$longitude[i], 
                   popup = local_cievs$nome[i])}
    
    
    # Retornar o mapa
    mapa
  })
}

shinyApp(ui, server)

