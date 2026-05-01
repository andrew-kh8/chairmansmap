import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { id: String };

  connect() {
    this.showPlot();
  }

  showPlot() {
    var layout = {
      margin: {
        l: 20,
        r: 50,
        b: 20,
        t: 30,
      },
    };

    fetch(`/geometry/villages/${this.idValue}/height_map`)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        const trace = {
          x: data.x,
          y: data.y,
          z: data.z,
          type: "surface",
        };

        Plotly.newPlot(this.element, [trace], layout);
      })
      .catch((error) => {
        console.log("error while loading height map");
      });
  }
}
