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

let hunterMarkerSize = 32;
export const newHunterMarkerStyle = {
  className: "marker",
  html: `
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="${hunterMarkerSize}" height="${hunterMarkerSize}">
        <circle cx="512" cy="512" r="480" fill="green" opacity=".9"/>
        <path fill="#D6F527" d="M952 474H829.8C812.5 327.6 696.4 211.5 550 194.2V72c0-4.4-3.6-8-8-8h-60c-4.4 0-8 3.6-8 8v122.2C327.6 211.5 211.5 327.6 194.2 474H72c-4.4 0-8 3.6-8 8v60c0 4.4 3.6 8 8 8h122.2C211.5 696.4 327.6 812.5 474 829.8V952c0 4.4 3.6 8 8 8h60c4.4 0 8-3.6 8-8V829.8C696.4 812.5 812.5 696.4 829.8 550H952c4.4 0 8-3.6 8-8v-60c0-4.4-3.6-8-8-8M512 756c-134.8 0-244-109.2-244-244s109.2-244 244-244 244 109.2 244 244-109.2 244-244 244"/>
        <path fill="#D6F527" d="M512 392c-32.1 0-62.1 12.4-84.8 35.2-22.7 22.7-35.2 52.7-35.2 84.8s12.5 62.1 35.2 84.8C449.9 619.4 480 632 512 632s62.1-12.5 84.8-35.2C619.4 574.1 632 544 632 512s-12.5-62.1-35.2-84.8C574.1 404.4 544.1 392 512 392"/>
        </svg>`,
  iconSize: [hunterMarkerSize, hunterMarkerSize],
  iconAnchor: [hunterMarkerSize / 2, hunterMarkerSize / 2],
  popupAnchor: [0, -(hunterMarkerSize / 2)],
};
