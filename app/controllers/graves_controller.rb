class GravesController < ApplicationController
  def index
    @graves = Grave.all
    
    if params[:search].present?
      @graves = @graves.where("name ILIKE ?", "%#{params[:search]}%")
    end
    
    if params[:category].present?
      @graves = @graves.where(category: params[:category])
    end
    
    if params[:latitude].present? && params[:longitude].present?
      # 位置情報による検索ロジック
      lat = params[:latitude].to_f
      lng = params[:longitude].to_f
      @graves = @graves.near([lat, lng], 10) # 10km圏内（geocodergemが必要）
    end
    
    @graves = @graves.page(params[:page]).per(12)
  end
  
  def show

      @grave = Grave.find(params[:id])
      
      # postsアソシエーションが存在するかチェック
      if @grave.respond_to?(:posts)
        @posts = @grave.posts.includes(:user).order(created_at: :desc)
      else
        @posts = Post.where(grave_id: @grave.id).includes(:user).order(created_at: :desc)
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to graves_path, alert: "指定された墓所が見つかりません"
    end

  
end