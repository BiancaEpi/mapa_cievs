# mapa cievs 

# Instalando pacotes ------------------------------------------------------
# install.packages("geobr")
library(geobr)
library(dplyr)
library(sf)
library(ggplot2)
library(rio)
library(leaflet)
library(readxl)
library(jsonlite)
library(rjson)
library(RCurl)


# importar base -----------------------------------------------------------

#local_cievs <- read_excel("/home/biancab/Documentos/Rstudio/projetos/mapa_cievs/municipios_Rede_CIEVS.xlsx")


local_cievs <- read_excel("municipios_Rede_CIEVS.xlsx")
glimpse(local_cievs)

local_cievs <- na.omit(local_cievs)

#filtrar so os cievs
# local_cievs <- local_cievs %>% 
# filter(Unidades == "CIEVS")


# transformar as coordenadas em valor numérico

local_cievs$latitude <- as.numeric(local_cievs$latitude)
local_cievs$longitude <- as.numeric(local_cievs$longitude)



# transform the data frame from plain one to spatial
body <- local_cievs %>% 
  sf::st_as_sf(coords = c("latitude", "longitude"), # columns with geometry
               crs = 4326) # WGS84 is a sensible default...



# camada do mapa 
mapa <- leaflet(local_cievs) %>%
  setView(lng = -51, lat = -27.50, zoom = 7) %>% # Coordenadas do mapa de SC
  addTiles() %>%  #mapa padrão
  addProviderTiles(providers$CartoDB) # tipo de mapa

mapa

# para colocar marcadores com cores diferentes

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
  
  
  
      
cor # verificar a distribuicao de cores


icone = awesomeIcons(icon = "home", 
                     iconColor = "white", 
                     markerColor = cor) #marcadores da livraria

leaflet() %>% 
  setView(lng = -51, lat = -27.50, zoom = 7) %>% # Coordenadas do mapa de SC
  addTiles () %>% 
  addProviderTiles(providers$CartoDB) %>% 
  
  addAwesomeMarkers(local_cievs$longitude, 
                    local_cievs$latitude,
                    icon= icone,
                    popup = local_cievs$nome,
                    label = local_cievs$Unidades,
                    clusterOptions = markerClusterOptions()) # com clusters


  





# marcadores coloridos ----------------------------------------------------

dados_filtrados <- local_cievs[local_cievs$Unidades == input$unidades, ]

# Camada do mapa
mapa <- leaflet(dados_filtrados) %>%
  setView(lng = -51, lat = -27.50, zoom = 7) %>% # Coordenadas do mapa de SC
  addTiles() %>%  # Adicionar azulejos de mapa padrão
  addProviderTiles(providers$CartoDB)

# Criar uma paleta de cores
cores <- colorFactor(palette = c("orange", "red", "blue", "green",  "purple"), domain = local_cievs$Unidades)

# Adicionar marcadores coloridos no mapa
mapa <- mapa %>%
  addCircleMarkers(data = dados_filtrados, 
                   lng = ~longitude, 
                   lat = ~latitude, 
                   color = ~cores(Unidades), 
                   popup = ~nome,
                   label = ~ nome,
                   radius = ifelse(dados_filtrados$Unidades == 1,10,6)
  )

# Exibir mapa
mapa

