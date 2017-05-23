library("ggmap")
library("leaflet")
place<-ggmap::geocode("São Paulo")
m<-leaflet(place) %>% addTiles() %>% setView(place$lon,place$lat,zoom=10)
marker<-makeIcon(
  iconUrl = "http://www.clker.com/cliparts/F/w/l/C/e/W/map-marker.svg",
  iconWidth = 38, iconHeight = 60,
  iconAnchorX = 22, iconAnchorY = 94)
addMarkers(data=csv,lat=runif(100,-24,-23),lng=runif(100,-47,-46),map=m,icon=marker)