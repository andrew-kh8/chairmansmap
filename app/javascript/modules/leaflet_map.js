export class LeafletMap {
  constructor(container, isDarkMode, options = {}) {
    this.isDarkMode = isDarkMode;
    if (options["attributionControl"] == undefined) {
      options["attributionControl"] = false;
    }

    this.map = L.map(container, options);
  }

  initMap() {
    this.tile = this.isDarkMode
      ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
      : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";

    L.tileLayer(this.tile, {
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 23,
    }).addTo(this.map);

    return this.map;
  }
}
