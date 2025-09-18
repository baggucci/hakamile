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
      @graves = @graves.near([lat, lng], 100) # 100km圏内（geocodergemが必要）
    else
      # 通常の一覧表示（位置情報が送られてこなかった場合）
      @graves = Grave.all
    end
    
  end
  
  def show
      @post = Post.new  # 👈 この行を追加、または確認してください
      @grave = Grave.find(params[:id])
      @posts = @grave.posts.includes(:user).order(created_at: :desc)
      @comment = Comment.new 
      @comments = @grave.comments.includes(:user).order(created_at: :desc)
    
      rescue ActiveRecord::RecordNotFound
      redirect_to graves_path, alert: "指定された墓所が見つかりません"
  end

  def search
      latitude = params[:latitude]
      longitude = params[:longitude]
  
      if latitude.present? && longitude.present?
        # Geocoderのnearメソッドで近くの墓所を検索します (例: 10km以内)
        # @graves = Grave.near([latitude, longitude], 10, units: :km)

        # Geokitのwithinメソッドで近くの墓所を検索します (例: 10km以内)
        @graves = Grave.within(100, origin: [latitude, longitude])

      else
        @graves = Grave.all
        flash.now[:alert] = "位置情報が取得できませんでした。"
      end
      
      # index.html.erb などのビューを使って検索結果を表示します
      render :index
  end

  private

  def grave_params
    # :main_image を追加
    params.require(:grave).permit(:name, :address, :description, :prefecture, :main_image)
  end

end