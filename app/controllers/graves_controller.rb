class GravesController < ApplicationController
  def index
    @graves = Grave.all

    # ヘッダーのキーワード検索をqueryパラメーターで処理
    if params[:query].present?
      @graves = Grave.where('name LIKE ?', "%#{params[:query]}%")
    else
      @graves = Grave.all
    end    
    
    if params[:search].present?
      @graves = @graves.where("name LIKE ?", "%#{params[:search]}%")
    end
    
    # ジャンル検索
    if params[:genre_name].present?
      @graves = Grave.joins(:genres).where(genres: { name: params[:genre_name] })
    end

    # 都道府県検索
    if params[:prefecture].present?
      @graves = Grave.where(prefecture: params[:prefecture])
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
      @posts = @grave.posts.includes(:user).order(created_at: :desc)
      @comment = Comment.new 
      @comments = @grave.comments.includes(:user).order(created_at: :desc)
    
      rescue ActiveRecord::RecordNotFound
      redirect_to graves_path, alert: "指定された墓所が見つかりません"
    end

  
end