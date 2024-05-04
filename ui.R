#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

local_cievs <- import("municipios_Rede_CIEVS.xlsx")
glimpse(local_cievs)

local_cievs <- na.omit(local_cievs)



ui <- fluidPage(
  titlePanel("Mapa de Municípios"),
  leafletOutput("mapa")
)