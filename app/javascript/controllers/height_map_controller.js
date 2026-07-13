import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { id: String };

  connect() {
    this.element.classList.add("w-full", "h-full", "min-h-0");
    this.element.style.width = "100%";
    this.element.style.height = "100%";

    this.resizePlot = () => {
      if (this.element.querySelector(".js-plotly-plot")) {
        Plotly.Plots.resize(this.element);
      }
    };

    window.addEventListener("resize", this.resizePlot);
    this.testPlot();
    // this.showPlot();
  }

  disconnect() {
    window.removeEventListener("resize", this.resizePlot);
  }

  testPlot() {
    const layout = {
      autosize: true,
      margin: {
        l: 0,
        r: 0,
        b: 0,
        t: 0,
      },
      // xaxis: { scaleanchor: "y", scaleratio: 1 },
    };
    const config = {
      responsive: true,
    };

    const data = [
      {
        type: "surface",
        x: [1, 2, 3, 4, 5],
        y: [1, 2, 3, 4, 5],
        z: [
          [1, 2, 3, 4, 5],
          [2, 3, 4, 5, null],
          [3, 4, 5, 6, 7],
          [4, 5, 6, 7, null], // дырка справа внизу
          [5, 6, 7, 8, 9],
        ],
        colorscale: "Viridis",
        showscale: true,
      },
    ];

    this.element.innerHTML = "";
    Plotly.newPlot(this.element, data, layout, config);
  }

  showPlot() {
    const layout = {
      autosize: true,
      margin: {
        l: 0,
        r: 0,
        b: 0,
        t: 0,
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
        Plotly.newPlot(this.element, [heights, path], layout, config).then(
          () => {
            Plotly.Plots.resize(this.element);
          },
        );
      })
      .catch((error) => {
        console.log("error while loading height map", error);
      });
  }
}
