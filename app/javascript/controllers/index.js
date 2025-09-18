import { Application } from "@hotwired/stimulus"

const application = Application.start()

// デバッグ設定 (開発中は true にすると便利です)
application.debug = true
window.Stimulus = application

export { application }  