console.log("one plot");

var map;
var wfs_plots_layer;
var wfs_hunter_layer;
var plot_id;

var zoom = 17;
var coord = {
  lat: 44.50861,
  lng: 33.57975,
};

var wfs_endpoint = document.body.dataset.geoserverUrl + "/wfs";
var layer_name = document.body.dataset.geoserverPlotsLayer;

$(document).ready(function () {
  map = L.map("map", {
    center: [coord.lat, coord.lng],
    zoom: zoom,
    attributionControl: false,
  });
  plot_id = $("#map")[0].dataset.plotId;

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 23,
  }).addTo(map);

  wfs_plots_layer = L.Geoserver.wfs(wfs_endpoint, {
    layers: layer_name,
    CQL_FILTER: "id='" + plot_id + "'",
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

  wfs_plots_layer.addTo(map);
  wfs_hunter_layer.addTo(map);

  L.control.layers(null, { Охотники: wfs_hunter_layer }).addTo(map);
});
