export class OWMTile {
  constructor(layerControls = null) {
    this.layerControls = layerControls;
  }

  addClouds() {
    return this.#addLayer("clouds", "Облака");
  }

  addRain() {
    return this.#addLayer("rain_cls", "Дождь");
  }

  addSnow() {
    return this.#addLayer("snow", "Снег");
  }

  addTemp() {
    return this.#addLayer("temp", "Температура");
  }

  addWind() {
    return this.#addLayer("wind", "Ветер");
  }

  //   private

  #initOwmMap(layer_name) {
    const apiKey = document.querySelector(
      "meta[name='openweather-api-key']",
    ).content;

    let tile = `https://{s}.tile.openweathermap.org/map/${layer_name}/{z}/{x}/{y}.png?appid=${apiKey}`;
    let layer = L.tileLayer(tile, {
      minZoom: 1,
      maxZoom: 23,
    });
    return layer;
  }

  #addLayer(layerName, name) {
    let map = this.#initOwmMap(layerName);

    if (this.layerControls !== null) {
      this.layerControls.addOverlay(map, name);
      return this;
    } else {
      return map;
    }
  }
}
