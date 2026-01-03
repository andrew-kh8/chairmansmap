import { Controller } from "@hotwired/stimulus";
import { LeafletMap } from "../modules/leaflet_map";
import {
  PlotAction,
  set_defaultStyle,
  plot_number,
  removeStyle,
} from "../modules/main_map/plot_action";

export default class extends Controller {
  static targets = ["map", "saleStatus", "ownerType"];

  connect() {
    console.log("main-map");
    this.isDarkMode = $(document.body).hasClass("dark");
    this.plotColor = this.isDarkMode ? "green" : "blue";
    this.wfs_plots_layer = 1;

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
        removeStyle(wfs_plots_layer);

        if (data.plots) {
          Object.values(wfs_plots_layer._layers)
            .filter((el) => data.plots.includes(plot_number(el.feature)))
            .forEach((r) => {
              set_defaultStyle(r, "red");
              r.options.filtered = true;
              r.setStyle({ fillColor: "red" });
            });
        }
      }
    );
  }

  resetFilter() {
    this.saleStatusTarget.value = "не важно";
    this.ownerTypeTarget.value = "не важно";

    removeStyle(this.wfs_plots_layer);
  }

  // private

  showAllPlots() {
    fetch("/geometry/plots")
      .then((response) => response.json())
      .then((geojson) => {
        const plotColor = this.plotColor;

        let plotAction = new PlotAction();
        this.wfs_plots_layer = L.geoJson(geojson, {
          style: function (feature) {
            return {
              color: plotColor,
              weight: 2,
              fillColor: plotColor,
              fillOpacity: 0.2,
            };
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
            return new L.CircleMarker(latlng, {
              radius: 10,
              fillOpacity: 0.85,
            });
          },
          onEachFeature: function (feature, layer) {
            layer.bindTooltip(feature.properties.date);
          },
        }).addTo(this.map);

        wfs_hunter_layer.addTo(this.map);
        this.layerControls.addOverlay(wfs_hunter_layer, "Охотники");
      });
  }
}
