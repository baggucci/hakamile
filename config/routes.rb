Rails.application.routes.draw do
  # get 'posts/index'
  # get 'posts/show'
  # get 'posts/new'
  # get 'posts/edit'
  root 'homes#top'
  get 'about' => 'homes#about'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts
end