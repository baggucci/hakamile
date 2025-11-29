class HomesController < ApplicationController
  def index
    # 安全な方法でデータを取得
    begin
      @recent_posts = Post.published.includes(:user, :grave).order(created_at: :desc).limit(4)
    rescue
      @recent_posts = []
    end
    
  end
  
  def top
    
    # 検索バー用（Ransack）
    @q = Grave.ransack(params[:q])

    # ジャンル一覧
    @genres = Genre.all

    # 投稿一覧（画像つき）
    @posts = Post.published.with_attached_images.order(created_at: :desc).limit(6)

    begin
      @recent_posts = Post.published.includes(:user, :grave).order(created_at: :desc).limit(4)
    rescue
      @recent_posts = []
    end
    
  end

  def contact
    end
end