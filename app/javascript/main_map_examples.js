// const pkk = "https://pkk.rosreestr.ru/arcgis/rest/services/PKK6/CadastreObjects/MapServer/export?layers=show%3A21&format=PNG32&bbox={bbox}&bboxSR=102100&imageSR=102100&size=1024%2C1024&transparent=true&f=image"

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
