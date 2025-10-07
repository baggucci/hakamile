  // idを指定してボタン要素を取得
  const searchBtn = document.getElementById('search-by-location-btn');

  // ボタンがクリックされた時の処理
  searchBtn.addEventListener('click', (event) => {
    event.preventDefault(); // リンクのデフォルト動作（画面遷移）を一旦停止

    // ブラウザが位置情報取得機能に対応しているかチェック
    if (navigator.geolocation) {
      // 位置情報を取得する
      navigator.geolocation.getCurrentPosition(
        (position) => {
          // 成功した場合
          const latitude = position.coords.latitude;
          const longitude = position.coords.longitude;

          // 取得した緯度経度をパラメータにつけてsearchページに遷移
          window.location.href = `/search?latitude=${latitude}&longitude=${longitude}`;
        },
        (error) => {
          // 失敗した場合
          console.error("位置情報の取得に失敗しました: ", error);
          alert('位置情報の取得に失敗しました。ブラウザの設定を確認してください。');
        }
      );
    } else {
      alert('お使いのブラウザは位置情報取得機能に対応していません。');
    }
  });