console.log("one plot");

var map;
var wfs_hunter_layer;
var plot_id;

var zoom = 17;
var coord = {
  lat: 44.50861,
  lng: 33.57975,
};

var wfs_endpoint = document.body.dataset.geoserverUrl + "/wfs";

$(document).ready(function () {
  map = L.map("map", {
    center: [coord.lat, coord.lng],
    zoom: zoom,
    attributionControl: false,
  });
  plot_id = $("#map")[0].dataset.plotId;

  var isDarkMode = $(document.body).hasClass("dark");
  var plotColor = isDarkMode ? "green" : "blue";
  var tile = isDarkMode
    ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
    : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";

  L.tileLayer(tile, {
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 23,
  }).addTo(map);

  fetch(`/plots/${plot_id}/geometry`)
    .then((response) => response.json())
    .then((geojson) => {
      L.geoJson(geojson, {
        style: function (feature) {
          return {
            color: plotColor,
            weight: 2,
            fillColor: plotColor,
            fillOpacity: 0.2,
          };
        },
      }).addTo(map);

      map.setView(geojson.features[0].properties.centroid, 19);
    });

  wfs_hunter_layer = L.Geoserver.wfs(wfs_endpoint, {
    layers: "web_gis:hunter_locations",
    onEachFeature: function (feature, layer) {
      layer.on("mouseover", function () {
        layer
          .bindTooltip(
            new Date(feature.properties.date).toLocaleString("ru-RU")
          )
          .openTooltip();
      });
    },
    style: { color: "black", fillOpacity: "0", opacity: "0.5" },
  });

  wfs_hunter_layer.addTo(map);

  L.control.layers(null, { Охотники: wfs_hunter_layer }).addTo(map);
});
