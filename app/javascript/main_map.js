console.log("map");

// ------------
// const

var map;
var wfs_plots_layer;
var wfs_hunter_layer;

var zoom = 17;
var coord = {
  lat: 44.50861,
  lng:33.57975
}

var wfs_endpoint = "http://0.0.0.0:8080/geoserver/wfs"

// var local_wms = "https://5781-31-28-228-221.ngrok-free.app/geoserver/wms"
// const pkk = "https://pkk.rosreestr.ru/arcgis/rest/services/PKK6/CadastreObjects/MapServer/export?layers=show%3A21&format=PNG32&bbox={bbox}&bboxSR=102100&imageSR=102100&size=1024%2C1024&transparent=true&f=image"


// end of const
// ------------


// ------------
// functions

function plot_id(plot){
  return Number(plot.id.split(".")[1]);
};

function set_defaultStyle(layer, color = "", opacity = 0.2){
  layer.options.defaultStyle = {fillColor: color, fillOpacity: opacity};
};

function get_defaultStyle(layer){
  return layer.options.defaultStyle || {fillColor: "", fillOpacity: 0.2};
};

function full_name(names){
  return names.surname + " " + names.first_name + " " + names.middle_name
};

function show_update_form(){
  $("#show_data_form").addClass("hidden");
  $("#update_data_form").removeClass("hidden");
};

function hide_update_form(){
  $("#show_data_form").removeClass("hidden");
  $("#update_data_form").addClass("hidden");
};

function get_form_data(){
  return {
    owner:{
      person_id: $("#form_person_id").val()
    },
    plot_data:{
      sale_status: $("#form_sale_status").val(),
      owner_type: $("#form_owner_type").val(),
      description: $("#form_description").val()
    }
  }
};

function set_plot_data(data) {
  $("#plot_number").text(data.number);
  $("#plot_number_kadastr").text(data.plot_datum.kadastr_number);
  $("#owner_fio").text(full_name(data.person));
  $("#owner_tel").text(data.person.tel);
  $("#owner_adr").text(data.person.address);
  $("#owner_type").text(data.plot_datum.owner_type);
  $("#plot_area").text(data.area);
  $("#plot_perimetr").text(data.perimetr);
  $("#plot_sale_status").text(data.plot_datum.sale_status);
  $("#plot_description").text(data.plot_datum.description);

  $("#form_person_id").val(data.number).change();
  $("#open_form_button").removeAttr("disabled");
  $("#update_form").attr("action", "plot/"+data.number);

  $("#form_sale_status option:contains(" + data.plot_datum.sale_status + ")").prop('selected', true);
  $("#form_person_id option:contains(" + full_name(data.person) + ")").prop('selected', true);
  $("#form_owner_type option:contains(" + data.plot_datum.owner_type + ")").prop('selected', true);
  $("#form_description").val(data.plot_datum.description);
};

function update_plot_data(data) {
  $("#owner_fio").text(full_name(data.person));
  $("#owner_tel").text(data.person.tel);
  $("#owner_adr").text(data.person.address);
  $("#owner_type").text(data.plot_datum.owner_type);
  $("#plot_sale_status").text(data.plot_datum.sale_status);
  $("#plot_description").text(data.plot_datum.description);

  $("#show_data_form").removeClass("hidden");
  $("#update_data_form").addClass("hidden");
};

// end of functions
// ------------

$(document).ready(function () {
  map = L.map("map", {
    center: [coord.lat, coord.lng],
    zoom: zoom,
  });

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom:23
  }).addTo(map);

  // var wmsLayer = L.tileLayer.wms(local_wms, {
  //   layers: "web_gis:plots",
  //   format: "image/png",
  //   transparent: true,
  // });
  // wmsLayer.addTo(map);


  wfs_plots_layer = L.Geoserver.wfs(wfs_endpoint, {
    layers: "web_gis:plots",
    onEachFeature: function(feature, layer){
      set_defaultStyle(layer);
      layer.on("mouseover",(function(){
        layer.bindTooltip("№ " + plot_id(feature), {permanent: false}).openTooltip();
        layer.setStyle({fillColor: "red", fillOpacity: 0.5});
      }))
      .on("mouseout", function(){
        layer.setStyle(get_defaultStyle(layer));
      });
      layer.on("click", function () {
        $.get("/plot/" + plot_id(feature),
          {},
          function(data){
            set_plot_data(data)
          }
        )
      });
    }
  });

  wfs_hunter_layer = L.Geoserver.wfs(wfs_endpoint, {
    layers: "web_gis:hunter_locations",
    style: {color: "black",
      fillOpacity: "0",
      opacity: "0.5"}
  });

  wfs_plots_layer.addTo(map);
  wfs_hunter_layer.addTo(map);


  L.control.layers(null, {"Участки": wfs_plots_layer, "Охотники": wfs_hunter_layer}).addTo(map);

  // print coordinates in console
  // map.addEventListener('mousemove', (event) => {
  //   console.log(event.latlng.lat, event.latlng.lng);
  // });

  // map.setView(new L.LatLng(coord.lat, coord.lng), zoom);

  //   var latlng = map.mouseEventToLatLng(event.originalEvent);

  $("#open_form_button").click(show_update_form);
  $("#cancel_data_button").click(hide_update_form);

  $("#update_form").submit(function(form=this){
    $.ajax({
      url: form.currentTarget.action,
      type: 'PATCH',
      data: get_form_data(),
      dataType: "json",
      success: function(result){
        update_plot_data(result)
      },
      error: function(error){
        console.log(error)
      }
    });
    return false;
  });

  $("#filters").click(function(){
    $.get("/plot/filter",
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
          .filter((el) => data.plots.includes(plot_id(el.feature)))
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
