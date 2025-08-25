library(sf)
library(mapview)
library(leaflet)
library(readxl)
library(leaflet.extras)
library(htmlwidgets)

pump <- read.csv2("C:/Users/GIEZENTH/Documents/DATA/pumptrack.csv")

pumpsf <- st_as_sf(pump, coords = c("lon", "lat"), crs = 4326)

mapview(pumpsf)

coords <- st_coordinates(pumpsf)
pumpsf$lng <- coords[, 1]  # longitude
pumpsf$lat <- coords[, 2]  # latitude

library(leaflet)

# Carte avec trois fonds de carte et un sélecteur
pumptracksf <-leaflet(pumpsf) %>%
  addTiles(group = "OpenStreetMap") %>%  # OSM classique
  addProviderTiles("CartoDB.DarkMatter", group = "DarkMatter") %>%  # Fond sombre
  addProviderTiles("Esri.WorldImagery", group = "Satellite ESRI") %>%  # Satellite

  # Ajout des marqueurs
  addMarkers(~lng, ~lat, popup = ~original_Localité, group = "Pumptrack") %>%
  addSearchOSM() %>% 
  
  
  # Contrôle de couches (sélecteur de fonds)
  addLayersControl(
    baseGroups = c("OpenStreetMap", "DarkMatter", "Satellite ESRI"),
    overlayGroups = c("Pumptrack"),
    options = layersControlOptions(collapsed = FALSE)) %>% 
      
    
      addMarkers(
        lng = 6.25, lat = 46.38,
        popup = "🚤 Barracuda",
        label = "Clique et déplace-moi !",
        options = markerOptions(draggable = TRUE),
        icon = makeIcon(
          iconUrl = "https://toppng.com/uploads/preview/sailboat-png-11553974022d5h2tyaw4e.png",  # Icône bateau
          iconWidth = 30, iconHeight = 30
        )) %>%   

       addControl(
          html = "<div style='padding: 8px; background: rgba(0,0,0,0.5); border-radius: 5px;'>
              <h3 style='color: white; margin: 0;'>Carte des pumptracks</h3>
            </div>",
          position = "topright"
        )
  

pumptracksf

saveWidget(pumptracksf, "indexx.html", selfcontained = TRUE)
