export class PlotAction {
  // static chosen_layer;
  constructor() {
    PlotAction.chosen_layer = null;
  }

  call(feature, layer) {
    set_defaultStyle(layer);
    layer.bindTooltip("№ " + plot_number(feature), { permanent: false });

    layer
      .on("mouseover", function () {
        layer.openTooltip();
        layer.setStyle({ fillColor: "white", fillOpacity: 0.5 });
      })
      .on("mouseout", function () {
        layer.setStyle(get_defaultStyle(layer));
      });

    layer.on("click", function () {
      if (PlotAction.chosen_layer != null) {
        set_defaultStyle(PlotAction.chosen_layer);
        PlotAction.chosen_layer.setStyle(
          get_defaultStyle(PlotAction.chosen_layer)
        );
      }

      PlotAction.chosen_layer = layer;
      set_defaultStyle(PlotAction.chosen_layer, "white");
      PlotAction.chosen_layer.setStyle({
        fillColor: "white",
        fillOpacity: 0.5,
      });

      Turbo.visit(`/side_panel/plots/${feature.properties.id}`, {
        action: "replace",
        frame: "side_panel_plot_data",
      });
    });

    function get_defaultStyle(layer) {
      return layer.options.defaultStyle || { fillColor: "", fillOpacity: 0.2 };
    }
  }
}

export function plot_number(plot) {
  return Number(plot.properties.number);
}

export function set_defaultStyle(layer, color = "", opacity = 0.2) {
  layer.options.defaultStyle = { fillColor: color, fillOpacity: opacity };
}

export function removeStyle(wfs_layer) {
  Object.values(wfs_layer._layers).forEach((r) => {
    r.setStyle({ fillColor: "" });
    r.options.filtered = false;
    set_defaultStyle(r);
  });
}
