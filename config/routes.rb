Rails.application.routes.draw do
  namespace :admin do
    get 'reports/index'
    get 'reports/show'
    get 'reports/update'
  end
  namespace :admin do
    get 'genres/index'
    get 'genres/create'
    get 'genres/edit'
    get 'genres/update'
    get 'genres/destroy'
  end
  namespace :admin do
    get 'comments/index'
    get 'comments/destroy'
  end
  namespace :admin do
    get 'posts/index'
    get 'posts/show'
    get 'posts/destroy'
  end
  get 'graves/index'
  get 'graves/show'
# devise_for :admins #ここは削除
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }
  
  root 'homes#top'
  get 'about' => 'homes#about'
  devise_for :users
  resources :posts
  resources :graves, only: [:index, :show,]  # 墓所管理


   # --- ここからマイページ関連のルートを追加 ---
   get 'mypage' => 'users#mypage'
   get 'mypage/edit' => 'users#edit', as: 'edit_mypage' # プロフィール編集画面
   patch 'mypage' => 'users#update'                    # プロフィール更新処理
   # --- ここまで ---

   resources :posts do
    # ↓ postsリソースの中にcommentsリソースをネストさせる
    resources :comments, only: [:create, :destroy]
  end

  resources :graves do
    # graveにネストさせる形でcommentsのルーティングを追加
    resources :comments, only: [:create, :destroy]
  end
  
 # 管理者向け機能のURLを /admin/... に統一
 namespace :admin do
  root to: 'homes#top' # 管理者トップページ
  get 'dashboards', to: 'dashboards#index'

  resources :graves, only: [:edit, :new, :create, :index, :show, :update, :destroy]  # 墓所管理
  resources :users, only: [:index, :show, :update, :destroy] # ユーザー管理
  resources :posts, only: [:index, :show, :destroy] # 投稿管理
  resources :reports, only: [:index, :show, :update] # 通報管理
  resources :genres, except: [:new, :show] # ジャンル管理

  resources :comments, only: [:index, :destroy]
  resources :reports, only: [:index, :show, :update]
  end
end