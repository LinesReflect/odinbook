import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="options"
export default class extends Controller {
  static targets = [ "list" ]

  clicked() {
    if (this.listTarget.style.visibility == "hidden") {
      this.listTarget.style.visibility = "visible"
    }else {
      this.listTarget.style.visibility = "hidden"
    }
  }
}
