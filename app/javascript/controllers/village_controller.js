import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import { defaultPlotStyle } from "../modules/map_styles";

export default class extends Controller {
  static values = {
    id: String,
  };

  static targets = ["map"];

  connect() {
    this.leafletMap = new LeafletMap(this.mapTarget);
    this.map = this.leafletMap.initMap();

    this.#showVillage();
  }

  #showVillage() {
    fetch(`/geometry/villages/${this.idValue}`)
      .then((response) => response.json())
      .then((geojson) => {
        this.wfs_village_layer = L.geoJson(geojson, {
          style: function () {
            return defaultPlotStyle;
          },
        }).addTo(this.map);

        this.map.fitBounds(this.wfs_village_layer.getBounds());
      });
  }
}
