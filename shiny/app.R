#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(rio)
library(here)
library(shiny)
library(readxl)
library(dplyr)
library(rio)
library(leaflet)
library(jsonlite)
library(rjson)
library(RCurl)

local_cievs <- read_excel("municipios_Rede_CIEVS.xlsx")
local_cievs <- na.omit(local_cievs)
# transformar as coordenadas em valor numérico

local_cievs$latitude <- as.numeric(local_cievs$latitude)
local_cievs$longitude <- as.numeric(local_cievs$longitude)



ui <- fluidPage(
  titlePanel("Rede Cievs"),
  
  # img(src="cievs_nacional.png"),
  # 
  # selectInput("unidades",
  #             "Selecione a Unidade:",
  #             choices = unique(local_cievs$Unidades)),
  # 
  
  
  checkboxGroupButtons(
    inputId = "somevalue1",
    label = "Make a choice: ",
    choices = c("A", "B", "C")
  ),
  
  fluidRow (column(width = 6, leafletOutput("mapa", height = 500)),
           column(width = 6, leafletOutput("mapa_icon", height = 500)))
  #downloadButton("download_mapa", "Baixar Mapa")
                                                                                                                                         
  
)


### server 

server <- function(input, output) {
  
  output$mapa <- renderLeaflet({
    
    # criar os vetores da funcao
    cor = c()
    nrow(local_cievs)
    
    # criar uma funcao do tipo for para as cores
    
    for (i in 1 : nrow (local_cievs)){
      
      if(local_cievs$tipo[i] == 1){
        cor[i] = "blue"} 
      
      else if (local_cievs$tipo[i] == 2){
        cor[i] = "orange"}  
      
      else if (local_cievs$tipo[i] == 3){
        cor[i] = "red"}  
      
      else if (local_cievs$tipo[i] == 4){
        cor[i] = "green"}  
      
      else if (local_cievs$tipo[i] == 5){
        cor[i] = "purple"}  
    }
    
    
    
    icone = awesomeIcons(icon = "home", 
                         iconColor = "white", 
                         markerColor = cor) #marcadores da livraria
    
    leaflet() %>% 
      setView(lng = -51, lat = -27.50, zoom = 7) %>% # Coordenadas do mapa de SC
      addTiles () %>% 
      #addProviderTiles(providers$CartoDB) %>% 
      addAwesomeMarkers(local_cievs$longitude, 
                        local_cievs$latitude,
                        icon= icone,
                        popup = local_cievs$nome,
                        label = local_cievs$Unidades
                       )
    
    
  })
  
  
  output$mapa_icon <- renderLeaflet({
    
    # criar os vetores da funcao
    cor = c()
    nrow(local_cievs)
    
    # criar uma funcao do tipo for para as cores
    
    for (i in 1 : nrow (local_cievs)){
      
      if(local_cievs$tipo[i] == 1){
        cor[i] = "blue"} 
      
      else if (local_cievs$tipo[i] == 2){
        cor[i] = "orange"}  
      
      else if (local_cievs$tipo[i] == 3){
        cor[i] = "red"}  
      
      else if (local_cievs$tipo[i] == 4){
        cor[i] = "green"}  
      
      else if (local_cievs$tipo[i] == 5){
        cor[i] = "purple"}  
       }
    
    
    
icone = awesomeIcons(icon = "home", 
                         iconColor = "white", 
                         markerColor = cor) #marcadores da livraria
    
    leaflet() %>% 
      setView(lng = -51, lat = -27.50, zoom = 7) %>% # Coordenadas do mapa de SC
      addTiles () %>% 
      #addProviderTiles(providers$CartoDB) %>% 
       addAwesomeMarkers(local_cievs$longitude, 
                        local_cievs$latitude,
                        icon= icone,
                        popup = local_cievs$nome,
                        label = local_cievs$Unidades,
                        clusterOptions = markerClusterOptions())

  
  })
  
  # output$download_mapa <- downloadHandler(
  #   filename = function() {
  #     paste("mapa_", input$unidades, ".png", sep = "")
  #   },
  #   content = function(file) {
  #     mapshot(output$mapa, file = file, format = "png")
  #   }
  # )
}

shinyApp(ui, server)


