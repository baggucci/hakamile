Rails.application.routes.draw do
# devise_for :admins #ここは削除
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }
  
  root 'homes#top'
  get 'about' => 'homes#about'
  devise_for :users
  resources :posts

   # --- ここからマイページ関連のルートを追加 ---
   get 'mypage' => 'users#mypage'
   get 'mypage/edit' => 'users#edit', as: 'edit_mypage' # プロフィール編集画面
   patch 'mypage' => 'users#update'                    # プロフィール更新処理
   # --- ここまで ---

 # 管理者向け機能のURLを /admin/... に統一
 namespace :admin do
  root to: 'homes#top' # 管理者トップページ
  resources :graves, only: [:edit, :new, :create, :index, :show, :update, :destroy]  # 墓所管理
  resources :users, only: [:index, :show, :update, :destroy] # ユーザー管理
  resources :posts, only: [:index, :show, :destroy] # 投稿管理
  resources :reports, only: [:index, :show, :update] # 通報管理
  resources :genres, except: [:new, :show] # ジャンル管理
  get 'dashboards', to: 'dashboards#index'

  end
end