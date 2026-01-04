import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import {
  plotColor,
  layerStyleNames,
  circleMarkerStyle,
  defaultPlotStyle,
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
    console.log("main-map");
    this.isDarkMode = document.body.classList.contains("dark");
    this.plotColor = this.isDarkMode ? plotColor.DARK : plotColor.LIGHT;
    this.wfs_plots_layer = null;

    this.leafletMap = new LeafletMap(this.mapTarget, this.isDarkMode, {
      zoom: 17,
      center: [44.50861, 33.57975],
    });
    this.map = this.leafletMap.initMap();
    this.layerControls = L.control.layers(null, null).addTo(this.map);

    this.showAllPlots();
    this.showHunters();
  }

  filterPlots() {
    let wfs_plots_layer = this.wfs_plots_layer;

    $.get(
      "/api/plots/filter",
      {
        sale_status: this.saleStatusTarget.value,
        owner_type: this.ownerTypeTarget.value,
      },
      function (data) {
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
      }
    );
  }

  resetFilter() {
    this.saleStatusTarget.value = "не важно";
    this.ownerTypeTarget.value = "не важно";

    Object.values(this.wfs_plots_layer._layers).forEach((layer) => {
      removeLayerStyle(layer, layerStyleNames.FILTERED);
    });
  }

  // private

  showAllPlots() {
    fetch("/geometry/plots")
      .then((response) => response.json())
      .then((geojson) => {
        let plotAction = new PlotAction();

        this.wfs_plots_layer = L.geoJson(geojson, {
          style: function (feature) {
            return defaultPlotStyle;
          },
          onEachFeature: (feature, layer) => {
            plotAction.call(feature, layer);
          },
        });

        this.wfs_plots_layer.addTo(this.map);
        this.layerControls.addOverlay(this.wfs_plots_layer, "Участки");
      });
  }

  showHunters() {
    fetch("/geometry/hunters")
      .then((response) => response.json())
      .then((geojson) => {
        let wfs_hunter_layer = L.geoJson(geojson, {
          pointToLayer: function (feature, latlng) {
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
