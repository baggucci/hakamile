class GravesController < ApplicationController
  def index
    @q = Grave.ransack(params[:q])
    @graves = @q.result(distinct: true)
     
    # ヘッダーのキーワード検索をqueryパラメーターで処理
    # if params[:query].present?
    #   @graves = Grave.where('name LIKE ?', "%#{params[:query]}%")
    # else
    #   @graves = Grave.all
    # end       
    # if params[:search].present?
    #   @graves = @graves.where("name LIKE ?", "%#{params[:search]}%")
    # end
    
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
      @graves = @graves.near([lat, lng], 100) # 100km圏内（geocodergemが必要）
    else
      # 通常の一覧表示（位置情報が送られてこなかった場合）
      @graves = Grave.all
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

  def nearby
    latitude = params[:latitude]
    longitude = params[:longitude]

    if latitude.blank? || longitude.blank?
      flash.now[:alert] = "位置情報を取得できませんでした。もう一度お試しください。"
      @graves = []
      render :nearby and return
    end

    @graves = Grave.within_100km(latitude, longitude)

    if @graves.empty?
      flash.now[:alert] = "近くにお墓は見つかりませんでした。"
    end

    render :nearby
  end


  private

  def grave_params
    # :main_image を追加
    params.require(:grave).permit(:name, :address, :description, :prefecture, :main_image)
  end

end