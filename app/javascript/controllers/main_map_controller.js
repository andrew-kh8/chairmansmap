import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import { OWMTile } from "../modules/weather/owm_tile";
import {
  layerStyleNames,
  circleMarkerStyle,
  defaultPlotStyle,
  newHunterMarkerStyle,
} from "../modules/map_styles";
import {
  PlotAction,
  plot_number,
  addLayerStyle,
  removeLayerStyle,
} from "../modules/main_map/plot_action";

export default class extends Controller {
  static targets = ["map", "saleStatus", "ownerType"];

  connect() {
    this.wfs_plots_layer = null;

    this.leafletMap = new LeafletMap(this.mapTarget);
    this.map = this.leafletMap.initMap();
    this.layerControls = L.control.layers(null, null).addTo(this.map);

    this.#showAllPlots();
    this.#showHunters();

    new OWMTile(this.layerControls)
      .addWind()
      .addTemp()
      .addClouds()
      .addRain()
      .addSnow();

    this.newHunterMarker = null;
    this.map.on("click", this.handleMapClick.bind(this));
  }

  handleMapClick(event) {
    const locationInput = document.getElementById("hunter_location_location");

    if (locationInput) {
      const latlng = event.latlng;
      locationInput.value = `${latlng.lat} ${latlng.lng}`;

      if (!this.newHunterMarker) {
        this.newHunterMarker = L.marker(latlng, {
          icon: L.divIcon(newHunterMarkerStyle),
        }).addTo(this.map);
      } else {
        this.newHunterMarker.setLatLng(latlng);
      }
    }
  }

  filterPlots() {
    let wfs_plots_layer = this.wfs_plots_layer;

    const params = new URLSearchParams({
      sale_status: this.saleStatusTarget.value,
      owner_type: this.ownerTypeTarget.value,
    });

    fetch(`/api/plots/filter?${params}`)
      .then((response) => response.json())
      .then((data) => {
        Object.values(wfs_plots_layer._layers).forEach((layer) => {
          removeLayerStyle(layer, layerStyleNames.FILTERED);
        });

        if (data.plots) {
          Object.values(wfs_plots_layer._layers)
            .filter((el) => data.plots.includes(plot_number(el.feature)))
            .forEach((layer) => {
              addLayerStyle(layer, layerStyleNames.FILTERED);
            });
        }
      });
  }

  resetFilter() {
    this.saleStatusTarget.value = "не важно";
    this.ownerTypeTarget.value = "не важно";

    Object.values(this.wfs_plots_layer._layers).forEach((layer) => {
      removeLayerStyle(layer, layerStyleNames.FILTERED);
    });
  }

  // private

  #showAllPlots() {
    fetch("/geometry/plots")
      .then((response) => response.json())
      .then((geojson) => {
        let plotAction = new PlotAction();

        this.wfs_plots_layer = L.geoJson(geojson, {
          style: function () {
            return defaultPlotStyle;
          },
          onEachFeature: (feature, layer) => {
            plotAction.call(feature, layer);
          },
        });

        this.wfs_plots_layer.addTo(this.map);
        this.map.fitBounds(this.wfs_plots_layer.getBounds());
        this.layerControls.addOverlay(this.wfs_plots_layer, "Участки");
      });
  }

  #showHunters() {
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
        this.layerControls.addOverlay(wfs_hunter_layer, "Охотники");
      });
  }
}
