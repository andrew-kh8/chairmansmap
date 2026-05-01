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
        const height_map = data.height_map;
        const path_coords = data.path;

        const heights = {
          x: height_map.x,
          y: height_map.y,
          z: height_map.z,
          type: "surface",
        };
        const path = {
          type: "scatter3d",
          mode: "lines+markers",
          x: path_coords.x,
          y: path_coords.y,
          z: path_coords.z,
          opacity: 1,
          line: {
            width: 6,
          },
          marker: {
            size: 3.5,
            color: 1,
            colorscale: "Greens",
            cmin: -20,
            cmax: 50,
          },
        };

        this.element.innerHTML = "";
        Plotly.newPlot(this.element, [heights, path], layout);
      })
      .catch((error) => {
        console.log("error while loading height map", error);
      });
  }
}
