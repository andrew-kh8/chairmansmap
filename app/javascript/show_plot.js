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

  fetch("/geometry/hunters")
    .then((response) => response.json())
    .then((geojson) => {
      wfs_hunter_layer = L.geoJson(geojson, {
        pointToLayer: function (feature, latlng) {
          return new L.CircleMarker(latlng, {
            radius: 10,
            fillOpacity: 0.85,
          });
        },
        onEachFeature: function (feature, layer) {
          layer.bindTooltip(feature.properties.date);
        },
      }).addTo(map);

      wfs_hunter_layer.addTo(map);
      L.control.layers(null, { Охотники: wfs_hunter_layer }).addTo(map);
    });
});
