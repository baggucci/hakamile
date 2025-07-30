class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy] # 編集・更新・削除権限の確認
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params) # ログインユーザーに関連付けて投稿を生成

    if @post.save
      redirect_to @post, notice: '投稿が作成されました。'
    else
      # 保存に失敗した場合
      flash.now[:alert] = '投稿の作成に失敗しました。入力内容を確認してください。' # エラーメッセージをセット
      render :new # newビューを再表示
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  resources :posts

end
