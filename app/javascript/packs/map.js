// app/javascript/packs/map.js

// グローバルスコープに関数を定義
window.initMap = function() {
    const mapElement = document.getElementById('map');
    if (!mapElement) return;
  
    const latitude = parseFloat(mapElement.dataset.latitude);
    const longitude = parseFloat(mapElement.dataset.longitude);
  
    if (isNaN(latitude) || isNaN(longitude)) {
      mapElement.innerHTML = "位置情報が登録されていません。";
      return;
    }
  
    const location = { lat: latitude, lng: longitude };
  
    const map = new google.maps.Map(mapElement, {
      zoom: 15,
      center: location,
    });
  
    new google.maps.Marker({
      position: location,
      map: map,
    });
  };
  