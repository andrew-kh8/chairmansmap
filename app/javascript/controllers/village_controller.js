import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import {
  defaultPlotStyle,
  defaultVillageStyle,
  transparentPlotStyle,
} from "../modules/map_styles";

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
    // this.#showVillage();
    // this.#showVillagePlots();
    this.#showPath();
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

  #showPath() {
    fetch(`/geometry/villages/${this.idValue}/height_map`)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        const height_map = data.height_map;
        const path_coords = data.path;

        console.log(path_coords);
        this.lineLayer = L.geoJSON(path_coords, {
          style: {
            color: "blue", // цвет линии
            weight: 3, // толщина
            opacity: 0.8,
          },
        }).addTo(this.map);

        this.map.fitBounds(this.lineLayer.getBounds());
      })
      .catch((error) => {
        console.log("error while loading height map", error);
      });
  }

  #showVillage() {
    fetch(`/geometry/villages/${this.idValue}`)
      .then((response) => response.json())
      .then((geojson) => {
        this.wfs_village_layer = L.geoJson(geojson, {
          style: function () {
            return defaultVillageStyle;
          },
        }).addTo(this.map);

        // this.map.fitBounds(this.wfs_village_layer.getBounds());
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
    this.extraTileBtn.classList.toggle("btn-passive");
    this.extraTileBtn.classList.toggle("btn-active");
    this.wfs_village_layer.setStyle(transparentPlotStyle);
  }

  #removePreviouslySelectedTile() {
    if (this.extraTileLayer) this.#removeExtraTileLayer();
    this.extraTileBtn.classList.toggle("btn-active");
    this.extraTileBtn.classList.toggle("btn-passive");
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
