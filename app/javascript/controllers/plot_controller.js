import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import { circleMarkerStyle, defaultPlotStyle } from "../modules/map_styles";

export default class extends Controller {
  static values = {
    id: String,
  };

  static targets = ["map"];

  connect() {
    this.leafletMap = new LeafletMap(this.mapTarget);
    this.map = this.leafletMap.initMap();

    this.showPlot();
    this.showHunters();
  }

  showPlot() {
    fetch(`/geometry/plots/${this.idValue}`)
      .then((response) => response.json())
      .then((geojson) => {
        L.geoJson(geojson, {
          style: function () {
            return defaultPlotStyle;
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
          pointToLayer: function (_feature, latlng) {
            return new L.CircleMarker(latlng, circleMarkerStyle);
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
