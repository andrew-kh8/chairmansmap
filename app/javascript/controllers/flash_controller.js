import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.autoRemove = setTimeout(() => {
      this.remove();
    }, 10000);
  }

  remove() {
    this.element.style.transform = "translateX(100%)";
    this.element.style.opacity = "0";
    this.element.style.transition = "all 0.5s ease-in-out";

    setTimeout(() => {
      this.element.remove();
    }, 500);
  }
}
