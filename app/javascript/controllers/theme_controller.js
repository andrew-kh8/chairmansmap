import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sunIcon", "moonIcon"];
  connect() {}

  toggle() {
    const html = document.body;
    const isDark = html.classList.toggle("dark");
    var maxAge = 365 * 24 * 60 * 60;
    var darkTheme = isDark ? "1" : "0";

    document.cookie = `dark_theme=${darkTheme}; path=/; max-age=${maxAge}`;

    this.sunIconTarget.classList.toggle("hidden", isDark);
    this.moonIconTarget.classList.toggle("hidden", !isDark);
  }
}
