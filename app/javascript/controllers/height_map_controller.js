import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { id: String };

  connect() {
    this.showPlot();
  }

  showPlot() {
    const layout = {
      autosize: true,
      margin: {
        l: 20,
        r: 50,
        b: 20,
        t: 30,
      },
    };
    const config = {
      responsive: true,
    };

    fetch(`/geometry/villages/${this.idValue}/height_map`)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        const height_map = data.height_map;
        const path_coords = data.path;

        const heights = {
          x: height_map.x,
          y: height_map.y,
          z: height_map.z,
          type: "surface",
          opacity: 0.5,
        };

        this.element.innerHTML = "";
        Plotly.newPlot(this.element, [heights], layout, config);
      })
      .catch((error) => {
        console.log("error while loading height map", error);
      });
  }
}
