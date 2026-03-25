import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import { defaultPlotStyle, transparentPlotStyle } from "../modules/map_styles";

export default class extends Controller {
  static values = {
    id: String,
  };

  static targets = ["map", "tile"];

  connect() {
    this.leafletMap = new LeafletMap(this.mapTarget);
    this.map = this.leafletMap.initMap();

    this.extraTileBtn = null;
    this.extraTileLayer = null;
    this.#showVillage();
    this.#showVillagePlots();
  }

  showTile(event) {
    if (this.extraTileBtn) this.#removePreviouslySelectedTile();

    if (this.extraTileBtn === event.currentTarget) {
      this.extraTileBtn = null;
      this.wfs_village_layer.setStyle(defaultPlotStyle);

      return;
    }

    this.extraTileBtn = event.currentTarget;
    this.#addNewTile();
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

  #showVillagePlots() {
    fetch(`/geometry/villages/${this.idValue}/plots`)
      .then((response) => response.json())
      .then((geojson) => {
        this.wfs_plots_layer = L.geoJson(geojson, {
          style: function () {
            return defaultPlotStyle;
          },
        });

        this.wfs_plots_layer.addTo(this.map);
      });
  }

  #addNewTile() {
    this.#addExtraTileLayer();
    this.extraTileBtn.classList.toggle("passive_btn_colors");
    this.extraTileBtn.classList.toggle("active_btn_colors");
    this.wfs_village_layer.setStyle(transparentPlotStyle);
  }

  #removePreviouslySelectedTile() {
    if (this.extraTileLayer) this.#removeExtraTileLayer();
    this.extraTileBtn.classList.toggle("active_btn_colors");
    this.extraTileBtn.classList.toggle("passive_btn_colors");
  }

  #addExtraTileLayer() {
    let tile_url = this.extraTileBtn.dataset.tileValue;
    this.extraTileLayer = L.tileLayer(tile_url);
    this.extraTileLayer.addTo(this.map);
  }

  #removeExtraTileLayer() {
    this.map.removeLayer(this.extraTileLayer);
    this.extraTileLayer = null;
  }
}
