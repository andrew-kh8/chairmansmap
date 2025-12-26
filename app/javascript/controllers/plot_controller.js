import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";

export default class extends Controller {
  static values = {
    id: String,
  };

  static targets = ["map"];

  connect() {
    this.isDarkMode = $(document.body).hasClass("dark");
    this.plotColor = this.isDarkMode ? "green" : "blue";

    this.leafletMap = new LeafletMap(this.mapTarget, this.isDarkMode);
    this.map = this.leafletMap.initMap();

    this.showPlot();
    this.showHunters();
  }

  showPlot() {
    fetch(`/geometry/plots/${this.idValue}`)
      .then((response) => response.json())
      .then((geojson) => {
        const plotColor = this.plotColor;

        L.geoJson(geojson, {
          style: function (feature) {
            return {
              color: plotColor,
              weight: 2,
              fillColor: plotColor,
              fillOpacity: 0.2,
            };
          },
        }).addTo(this.map);

        this.map.setView(geojson.features[0].properties.centroid, 19);
      });
  }

  showHunters() {
    fetch("/geometry/hunters")
      .then((response) => response.json())
      .then((geojson) => {
        let wfs_hunter_layer = L.geoJson(geojson, {
          pointToLayer: function (feature, latlng) {
            return new L.CircleMarker(latlng, {
              radius: 10,
              fillOpacity: 0.85,
            });
          },
          onEachFeature: function (feature, layer) {
            layer.bindTooltip(feature.properties.date);
          },
        });

        wfs_hunter_layer.addTo(this.map);
        L.control.layers(null, { Охотники: wfs_hunter_layer }).addTo(this.map);
      });
  }
}
