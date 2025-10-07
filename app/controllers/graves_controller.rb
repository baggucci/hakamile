class GravesController < ApplicationController
  def index
    @q = Grave.ransack(params[:q])
    @graves = @q.result(distinct: true)
        
    # ジャンル検索
    if params[:genre_name].present?
      @graves = Grave.joins(:genres).where(genres: { name: params[:genre_name] })
    end

    # 都道府県検索
    if params[:prefecture].present?
      @graves = Grave.where(prefecture: params[:prefecture])
    end
  end
  
  def show
      @post = Post.new 
      @grave = Grave.find(params[:id])
      @posts = @grave.posts.includes(:user).order(created_at: :desc)
      @comment = Comment.new 
      @comments = @grave.comments.includes(:user).order(created_at: :desc)
    
      rescue ActiveRecord::RecordNotFound
      redirect_to graves_path, alert: "指定された墓所が見つかりません"
  end

  def search
    # Ransackの検索オブジェクトを生成する (キーワード検索の準備)
      @q = Grave.ransack(params[:q])
      @graves = @q.result(distinct: true)
    # app/views/graves/search.html.erb を表示
    render :search
  end

  private

  def grave_params
    params.require(:grave).permit(:name, :address, :description, :prefecture, :main_image)
  end

end