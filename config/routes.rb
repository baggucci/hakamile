Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :password], controllers: { sessions: 'admin/sessions' }
  devise_for :users

  root 'homes#top'
  get 'about' => 'homes#about'
  get 'inquiries/complete' => 'inquiries#complete'

  resources :graves, only: [:index, :show]  # 墓所管理
  resources :inquiries, only: [:new, :create]
  resources :users, only: [:show]

  # マイページ関連
  get 'mypage' => 'users#mypage'
  get 'mypage/edit' => 'users#edit', as: 'edit_mypage'
  patch 'mypage' => 'users#update'

  resources :posts do
    collection { get :liked }
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  resources :graves do
    resources :comments, only: [:create, :destroy]
    resources :reports, only: [:new, :create]
    resources :posts, only: [:new, :create, :show, :edit, :update, :destroy], shallow: true
  end

  # 検索
  resource :search, only: [:new, :show], controller: 'searches'
  resource :user_search, only: [:show], controller: 'user_searches'

  resources :users do
    member { get :following, :followers }
  end
  resources :relationships, only: [:create, :destroy]

  # ゲストユーザー
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  # 管理者用
  namespace :admin do
    root to: 'homes#top'
    get 'dashboards', to: 'dashboards#index'

    resources :graves
    resources :users, only: [:index, :show, :update, :destroy]
    resources :posts, only: [:index, :show, :destroy]
    resources :reports, only: [:index, :show, :update]
    resources :genres, except: [:new, :show]
    resources :comments, only: [:index, :destroy]
    resources :inquiries, only: [:index, :show, :update]
  end
end
