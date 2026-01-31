import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.tomSelect = new TomSelect(this.element, {
      plugins: {
        remove_button: {},
      },
      create: false,
    });
  }

  disconnect() {
    if (this.tomSelect) {
      this.tomSelect.destroy();
    }
  }
}
