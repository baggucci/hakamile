Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  namespace :admin do
    get 'inquiries/index'
    get 'inquiries/show'
    get 'inquiries/update'
  end
  get 'reports/new'
  get 'reports/create'
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
  get 'inquiries/complete' => 'inquiries#complete'
  
  devise_for :users
  resources :posts
  resources :graves, only: [:index, :show,]  # 墓所管理
  resources :inquiries, only: [:new, :create]


  # --- ここからマイページ関連のルートを追加 ---
  get 'mypage' => 'users#mypage'
  get 'mypage/edit' => 'users#edit', as: 'edit_mypage' # プロフィール編集画面
  patch 'mypage' => 'users#update'                    # プロフィール更新処理
  # --- ここまで ---

  resources :posts do
    # ↓ postsリソースの中にcommentsリソースをネストさせる
    resources :comments, only: [:create, :destroy]
    # resources :reports, only: [:new, :create]
    resource :likes, only: [:create, :destroy] # favorites を likes に変更
    
  end

  resources :posts, only: [:index] # 投稿一覧のみ独立させる


  resources :graves do
    # graveにネストさせる形でcommentsのルーティングを追加
    resources :comments, only: [:create, :destroy]
    resources :reports, only: [:new, :create]
    resources :posts, only: [:new, :create, :show, :edit, :update, :destroy], shallow: true
    resources :graves do
      collection do
        get 'search' # graves/search というURLでアクセスできるようにする
      end
    end
  end

# ゲストユーザー用
devise_scope :user do
  post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
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
  resources :inquiries, only: [:index, :show, :update] 
  
  end
end