import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="resize"
export default class extends Controller {
  static targets = ["comment", "min", "max"]

  size() {
    if (this.commentTarget.style.display == "none") {
      this.maximize()
    }else {
      this.minimize()
    }
  }

  minimize() {
    this.commentTarget.style.display = "none"
    this.minTarget.style.display = "none"
    this.maxTarget.style.display = "block"
  }

  maximize() {
    this.commentTarget.style.display = "block"
    this.maxTarget.style.display = "none"
    this.minTarget.style.display = "block"
  }
}
