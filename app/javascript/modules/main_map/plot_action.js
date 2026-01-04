import { layerStyles, layerStyleNames } from "../map_styles";

export class PlotAction {
  constructor() {
    PlotAction.chosen_layer = null;
  }

  call(feature, layer) {
    layer.bindTooltip("№ " + plot_number(feature), { permanent: false });

    layer
      .on("mouseover", function () {
        layer.openTooltip();
        addLayerStyle(layer, layerStyleNames.POINTED);
      })
      .on("mouseout", function () {
        removeLayerStyle(layer, layerStyleNames.POINTED);
      });

    layer.on("click", function () {
      if (PlotAction.chosen_layer != null) {
        removeLayerStyle(PlotAction.chosen_layer, layerStyleNames.CHOSEN);
      }

      PlotAction.chosen_layer = layer;
      addLayerStyle(PlotAction.chosen_layer, layerStyleNames.CHOSEN);

      Turbo.visit(`/side_panel/plots/${feature.properties.id}`, {
        action: "replace",
        frame: "side_panel_plot_data",
      });
    });
  }
}

export function plot_number(plot) {
  return Number(plot.properties.number);
}

export function addLayerStyle(layer, style) {
  layer.options[style] = true;
  layer.setStyle(layerStyle(layer));
}

export function removeLayerStyle(layer, style) {
  layer.options[style] = false;
  layer.setStyle(layerStyle(layer));
}

export function layerStyle(layer) {
  switch (true) {
    case layer.options.pointed:
      return layerStyles.pointed;
    case layer.options.chosen:
      return layerStyles.chosen;
    case layer.options.filtered:
      return layerStyles.filtered;
    default:
      return layerStyles.default;
  }
}
