import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import { defaultPlotStyle } from "../modules/map_styles";

export default class extends Controller {
  static values = {
    id: String,
  };

  static targets = ["map", "tile"];
  btnClasses = [
    "text-white",
    "dark:text-white",
    "bg-btn-green",
    "dark:bg-btn-green",
  ];

  connect() {
    this.leafletMap = new LeafletMap(this.mapTarget);
    this.map = this.leafletMap.initMap();

    this.extraTileBtn = null;
    this.extraTileLayer = null;
    this.#showVillage();
  }

  showTile(event) {
    this.#removeExtraTileLayer();

    if (this.extraTileBtn) {
      this.extraTileBtn.classList.remove(...this.btnClasses);
    }

    if (this.extraTileBtn === event.currentTarget) {
      this.extraTileBtn = null;
      return;
    }

    this.extraTileBtn = event.currentTarget;
    this.#addExtraTileLayer();
    this.extraTileBtn.classList.add(...this.btnClasses);
  }

  // private

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

  #addExtraTileLayer() {
    this.extraTileLayer = L.tileLayer(this.extraTileBtn.dataset.tileValue);
    this.extraTileLayer.addTo(this.map);
  }

  #removeExtraTileLayer() {
    if (this.extraTileLayer) {
      this.map.removeLayer(this.extraTileLayer);
      this.extraTileLayer = null;
    }
  }
}
