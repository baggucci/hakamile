import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "./hakamile"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

function initApp() {
  // Search
  const searchBtn = document.querySelector('.search-btn');
  const searchInput = document.querySelector('.search-input');

  // Location
  const locationBtn = document.querySelector('.location-btn');
  if (locationBtn && !locationBtn.dataset.hasLocationHandler) {
    locationBtn.addEventListener('click', handleLocationSearch);
    locationBtn.dataset.hasLocationHandler = "true";
  }

  // Card interactions
  if (typeof initializeCardInteractions === 'function') {
    initializeCardInteractions();
  }
}

function handleLocationSearch(event) {
  const btn = event.currentTarget || event.target;
  const originalText = btn.innerHTML;
  btn.innerHTML = '<span class="loading-spinner me-2"></span>取得中...';
  btn.disabled = true;

  if (!('geolocation' in navigator)) {
    btn.innerHTML = originalText;
    btn.disabled = false;
    return;
  }

  navigator.geolocation.getCurrentPosition(
    function(position) {
      const form = document.createElement('form');
      form.method = 'GET';
      form.action = '/graves';

      const latInput = document.createElement('input');
      latInput.type = 'hidden';
      latInput.name = 'latitude';
      latInput.value = position.coords.latitude;

      const lngInput = document.createElement('input');
      lngInput.type = 'hidden';
      lngInput.name = 'longitude';
      lngInput.value = position.coords.longitude;

      form.appendChild(latInput);
      form.appendChild(lngInput);
      document.body.appendChild(form);
      form.submit();
    },
    function(error) {
      btn.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i>取得失敗';
      setTimeout(() => {
        btn.innerHTML = originalText;
        btn.disabled = false;
      }, 2000);
    }
  );
}

// Turbolinks を使っているならこれでページごとに初期化
document.addEventListener('turbolinks:load', initApp);
// 保険で最初のロードだけでも確実に動かしたければ
document.addEventListener('DOMContentLoaded', initApp);
