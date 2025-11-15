import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "result", "submit"];
  static values = { url: String };

  connect() {
    this.disableButton();
    console.log("cadastral_number 2");
  }

  check() {
    const cadastral_number = this.inputTarget.value.trim();

    if (!cadastral_number) {
      this.showResult("Поле не может быть пустым", "error");
      this.disableButton();
      return;
    }

    this.showResult("Проверяем...", "loading");
    fetch(
      "/api/plots/check_cadastral_number?" +
        new URLSearchParams({ cadastral_number: cadastral_number })
    )
      .then((response) => {
        if (response.ok) {
          return response.json().then((data) => {
            this.active_submit();
            this.showResult(data.message || "✓ Данные корректны", "success");
          });
        } else if (response.status === 404) {
          this.disableButton();
          this.showResult("Данные не найдены", "error");
        } else {
          this.disableButton();
          this.showResult("Ошибка при проверке", "error");
        }
      })
      .catch((error) => {
        console.log("Error:", error);
        this.showResult("Ошибка при проверке", "error");
      });
  }

  showResult(message, type) {
    this.resultTarget.textContent = message;
    this.resultTarget.className = `text-sm mt-2 ${
      type === "success"
        ? "text-green-600"
        : type === "error"
        ? "text-red-600"
        : "text-gray-600"
    }`;
  }

  active_submit() {
    this.submitTarget.disabled = false;
    this.submitTarget.classList.remove(
      "bg-gray-400",
      "text-gray-200",
      "cursor-not-allowed"
    );
    this.submitTarget.classList.add(
      "bg-indigo-500",
      "text-white",
      "cursor-pointer",
      "hover:bg-indigo-600"
    );
  }

  disableButton() {
    this.submitTarget.disabled = true;
    this.submitTarget.classList.remove(
      "bg-indigo-500",
      "text-white",
      "cursor-pointer",
      "hover:bg-indigo-600"
    );
    this.submitTarget.classList.add(
      "bg-gray-400",
      "text-gray-200",
      "cursor-not-allowed"
    );
  }
}
