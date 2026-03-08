import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import { defaultPlotStyle, transparentPlotStyle } from "../modules/map_styles";

export default class extends Controller {
  static values = {
    id: String,
  };

  static targets = ["map", "tile"];
  tileReg = /{z}\/{x}\/{y}/;

  connect() {
    this.leafletMap = new LeafletMap(this.mapTarget);
    this.map = this.leafletMap.initMap();

    this.extraTileBtn = null;
    this.extraTileLayer = null;
    this.#showVillage();
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
    if (this.tileReg.test(tile_url)) {
      this.extraTileLayer = L.tileLayer(tile_url);
      this.extraTileLayer.addTo(this.map);
    } else {
      fetch(tile_url)
        .then((response) => response.arrayBuffer())
        .then((arrayBuffer) => {
          parseGeoraster(arrayBuffer).then((georaster) => {
            this.extraTileLayer = new GeoRasterLayer({
              georaster: georaster,
              opacity: 0.7,
              pixelValuesToColorFn: (values) => {
                switch (true) {
                  case values[0] <= 0.0:
                    return "rgba(0,0,0,0)"; // красный
                  case values[0] <= 0.1:
                    return "rgb(255,64,0)";
                  case values[0] <= 0.2:
                    return "rgb(255,128,0)";
                  case values[0] <= 0.3:
                    return "rgb(255,192,0)";
                  case values[0] <= 0.4:
                    return "rgb(255,255,0)"; // жёлтый
                  case values[0] <= 0.5:
                    return "rgb(192,255,0)";
                  case values[0] <= 0.6:
                    return "rgb(128,255,0)";
                  case values[0] <= 0.7:
                    return "rgb(64,255,0)";
                  case values[0] <= 1.0:
                    return "rgb(0,255,0)"; // зелёный
                  default:
                    return "rgb(0,0,0)"; // fallback (чёрный)
                }
              },
              resolution: 64, // optional parameter for adjusting display resolution
            });

            this.extraTileLayer.addTo(this.map);
          });
        });
    }
  }

  #removeExtraTileLayer() {
    this.map.removeLayer(this.extraTileLayer);
    this.extraTileLayer = null;
  }
}
