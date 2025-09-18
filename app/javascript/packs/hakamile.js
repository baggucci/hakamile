import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// Hakamile specific
import "./hakamile"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// 先ほど作成したJavaScriptの内容をここに配置
document.addEventListener('DOMContentLoaded', function() {
    // Search functionality
    const searchBtn = document.querySelector('.search-btn');
    const searchInput = document.querySelector('.search-input');
    
    // Location functionality
    const locationBtn = document.querySelector('.location-btn');
    if (locationBtn) {
        locationBtn.addEventListener('click', handleLocationSearch);
    }
    
    // Card interactions
    initializeCardInteractions();
    
    // 以下、先ほどのJavaScriptの残りの内容
});

// Rails UJSとの統合
function handleLocationSearch() {
    if ('geolocation' in navigator) {
        const btn = this;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<span class="loading-spinner me-2"></span>取得中...';
        btn.disabled = true;
        
        navigator.geolocation.getCurrentPosition(
            function(position) {
                // Railsのフォームを使用して位置情報を送信
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
}

