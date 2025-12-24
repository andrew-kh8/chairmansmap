console.log("map");

// ------------
// const

var map;
var wfs_plots_layer;
var wfs_hunter_layer;
var layerControls;

var zoom = 17;
var coord = {
  lat: 44.50861,
  lng:33.57975
}

var wfs_endpoint = document.body.dataset.geoserverUrl + "/wfs";
var layer_name = document.body.dataset.geoserverPlotsLayer;

var chosen_layer = null;

// var local_wms = "https://5781-31-28-228-221.ngrok-free.app/geoserver/wms"
// const pkk = "https://pkk.rosreestr.ru/arcgis/rest/services/PKK6/CadastreObjects/MapServer/export?layers=show%3A21&format=PNG32&bbox={bbox}&bboxSR=102100&imageSR=102100&size=1024%2C1024&transparent=true&f=image"


// end of const
// ------------


// ------------
// functions

function plot_id(plot){
  return plot.id.split(".")[1];
};

function plot_number(plot){
  return Number(plot.properties.number);
};

function set_defaultStyle(layer, color = "", opacity = 0.2){
  layer.options.defaultStyle = {fillColor: color, fillOpacity: opacity};
};

function get_defaultStyle(layer){
  return layer.options.defaultStyle || {fillColor: "", fillOpacity: 0.2};
};

// end of functions
// ------------

$(document).ready(function () {
  map = L.map("map", {
    center: [coord.lat, coord.lng],
    zoom: zoom,
    attributionControl: false,
  });

  layerControls = L.control.layers(null, null).addTo(map);
  var isDarkMode = $(document.body).hasClass('dark');
  var tile = (isDarkMode) ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" :"https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";

  L.tileLayer(tile, {
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom:23
  }).addTo(map);

  // var wmsLayer = L.tileLayer.wms(local_wms, {
  //   layers: layer_name,
  //   format: "image/png",
  //   transparent: true,
  // });
  // wmsLayer.addTo(map);

  wfs_plots_layer = L.Geoserver.wfs(wfs_endpoint, {
    layers: layer_name,
    onEachFeature: function(feature, layer){
      set_defaultStyle(layer);
      layer.on("mouseover",(function(){
        layer.bindTooltip("№ " + plot_number(feature), {permanent: false}).openTooltip();
        layer.setStyle({fillColor: "red", fillOpacity: 0.5});
      }))
      .on("mouseout", function(){
        layer.setStyle(get_defaultStyle(layer));
      });
      layer.on("click", function () {
        if (chosen_layer != null) {
          set_defaultStyle(chosen_layer);
          chosen_layer.setStyle(get_defaultStyle(chosen_layer));
        }
        chosen_layer = layer;
        set_defaultStyle(chosen_layer, "red");
        chosen_layer.setStyle({fillColor: "red", fillOpacity: 0.5});

        Turbo.visit(`/side_panel/plots/${plot_id(feature)}`, { action: "replace", frame: "side_panel_plot_data" });
      });
    }
  });

  wfs_plots_layer.addTo(map);
  layerControls.addOverlay(wfs_plots_layer, "Участки");

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
      layerControls.addOverlay(wfs_hunter_layer, "Охотники");
    });


  // print coordinates in console
  // map.addEventListener('mousemove', (event) => {
  //   console.log(event.latlng.lat, event.latlng.lng);
  // });

  // map.setView(new L.LatLng(coord.lat, coord.lng), zoom);

  //   var latlng = map.mouseEventToLatLng(event.originalEvent);


  $("#filters").click(function(){
    $.get("/api/plots/filter",
      {
        sale_status: $("#filter_sale_status").val(),
        owner_type: $("#filter_owner_type").val()
      },
      function(data){
        Object.values(wfs_plots_layer._layers).forEach((r) => {
          r.setStyle({fillColor: ""});
          set_defaultStyle(r);
        });

        if (data.plots){
          Object.values(wfs_plots_layer._layers)
          .filter((el) => data.plots.includes(plot_number(el.feature)))
          .forEach((r) => {
            r.setStyle({fillColor: "red"});
            set_defaultStyle(r, "red");
          });
        }
      }
    )
  });

  $("#reset_filters").click(function(){
    $("#filter_sale_status option:contains('не важно')").prop('selected', true);
    $("#filter_owner_type option:contains('не важно')").prop('selected', true);

    Object.values(wfs_plots_layer._layers).forEach((r) => {
      r.setStyle({fillColor: ""});
      set_defaultStyle(r);
    });
  });

  // --------------------------
  // end of work section
  // --------------------------

  // another background map
  // L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
  //       attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
  //   }).addTo(map);

  // L.geoJSON(wmsLayer, {onEachFeature: function(feature, layer){}}).addTo(map);

  // --------------------------
  // https://github.com/storuky/map/blob/master/app/assets/javascripts/application.js

  // -----------------------------
  // yandex example
  // var center = [67.6755, 33.936];

  // 	var map = L.map('map', {
  // 		center: center,
  // 		zoom: 10,
  // 		zoomAnimation: true
  // 	});

  //   L.yandex() // 'map' is default
  // 			.addTo(map)

  // map.attributionControl
  // 	.setPosition('bottomleft')
  // 	.setPrefix('');

  // function traffic () {
  // 	// https://tech.yandex.ru/maps/jsbox/2.1/traffic_provider
  // 	var actualProvider = new ymaps.traffic.provider.Actual({}, { infoLayerShown: true });
  // 	actualProvider.setMap(this._yandex);
  // }

  // var baseLayers = {
  // 	'Yandex map': L.yandex() // 'map' is default
  // 		.addTo(map),
  // 	'Yandex map + Traffic': L.yandex('map')
  // 		.on('load', traffic),
  // 	'Yandex satellite':  L.yandex({ type: 'satellite' }), // type can be set in options
  // 	'Yandex hybrid':     L.yandex('hybrid'),
  // 	'OSM': L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  // 		attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  // 	})
  // };

  // var overlays = {'Traffic': L.yandex('overlay').on('load', traffic)};

  // L.control.layers(baseLayers, overlays, {collapsed: false}).addTo(map);
  // var marker = L.marker(center, { draggable: true }).addTo(map);
  // map.locate({ setView: true, maxZoom: 14 })
  // 	.on('locationfound',function (e) {
  // 		marker.setLatLng(e.latlng);
  // 	});
});
