// Leaflet supports the following colors:
// 'beige', 'black', 'blue', 'cadetblue', 'darkblue', 'darkgreen', 'gray', 'darkpurple', 'darkred', 'green',
// 'lightblue', 'lightgray', 'lightgreen', 'lightred', 'orange', 'pink', 'purple', and 'red'.
// more about leflet style - https://veroviz.org/docs/leaflet_style.html

export function isDarkMode() {
  return document.body.classList.contains("dark");
}

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
  [layerStyleNames.POINTED]: { fillColor: "white", fillOpacity: 0.6 },
  [layerStyleNames.CHOSEN]: { fillColor: "orange", fillOpacity: 0.6 },
  [layerStyleNames.FILTERED]: { fillColor: "purple", fillOpacity: 0.6 },
  [layerStyleNames.DEFAULT]: { fillColor: "", fillOpacity: 0.2 },
};

export const circleMarkerStyle = {
  radius: 10,
  fillOpacity: 0.85,
};

export const defaultPlotStyle = {
  color: isDarkMode() ? plotColor.DARK : plotColor.LIGHT,
  weight: 2,
  fillColor: isDarkMode() ? plotColor.DARK : plotColor.LIGHT,
  fillOpacity: 0.2,
};
