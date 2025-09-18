import { Controller } from "@hotwired/stimulus"
import "./controllers" // ← この行がStimulusコントローラーを読み込むために必要

export default class extends Controller {
  connect() {
    console.log("LocationSearchController connected!");
  }
  
  search(event) {
    event.preventDefault();
    const button = event.currentTarget;
    const originalText = button.innerHTML;
    button.disabled = true;
    button.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>検索中...';

    if (!navigator.geolocation) {
      alert("お使いのブラウザは位置情報取得に対応していません。");
      button.disabled = false;
      button.innerHTML = originalText;
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const lat = position.coords.latitude;
        const lon = position.coords.longitude;
        
        // ★★★★★ 取得した緯度経度を付けて /graves にリダイレクト ★★★★★
        window.location.href = `/graves?latitude=${lat}&longitude=${lon}`;
      },
      (error) => {
        console.error("位置情報の取得エラー:", error);
        alert("位置情報の取得に失敗しました。ブラウザの許可設定を確認してください。");
        button.disabled = false;
        button.innerHTML = originalText;
      }
    );
  }
}