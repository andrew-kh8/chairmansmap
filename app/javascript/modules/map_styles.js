// Leaflet supports the following colors:
// 'beige', 'black', 'blue', 'cadetblue', 'darkblue', 'darkgreen', 'gray', 'darkpurple', 'darkred', 'green',
// 'lightblue', 'lightgray', 'lightgreen', 'lightred', 'orange', 'pink', 'purple', and 'red'.
// more about leflet style - https://veroviz.org/docs/leaflet_style.html

export const plotColor = {
  LIGHT: "blue",
  DARK: "green",
};

export const layerStyleNames = Object.freeze({
  POINTED: "pointed",
  CHOSEN: "chosen",
  FILTERED: "filtered",
  DEFAULT: "default",
});

export const layerStyles = {
  [layerStyleNames.POINTED]: { fillColor: "red", fillOpacity: 0.5 },
  [layerStyleNames.CHOSEN]: { fillColor: "orange", fillOpacity: 0.4 },
  [layerStyleNames.FILTERED]: { fillColor: "red", fillOpacity: 0.2 },
  [layerStyleNames.DEFAULT]: { fillColor: "", fillOpacity: 0.2 },
};

export const circleMarkerStyle = {
  radius: 10,
  fillOpacity: 0.85,
};

let plotColorFill = document.body.classList.contains("dark")
  ? plotColor.DARK
  : plotColor.LIGHT;

export const defaultPlotStyle = {
  color: plotColorFill,
  weight: 2,
  fillColor: plotColorFill,
  fillOpacity: 0.2,
};
