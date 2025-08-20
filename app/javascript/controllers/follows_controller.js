import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static target = ["followers"]

    connect(){
        console.log("NIGA")
    }

    follow() {
        alert("Hey from Stimulus");    
    }

    show() {
        console.log("GAWDDDDDD")
    }
}

