class SearchesController < ApplicationController
  
  # 検索フォームを表示するためのアクション
  def new
    # お墓検索フォーム用のRansackオブジェクト
    @grave_q = Grave.ransack(params[:grave_q])

    # ユーザー検索フォーム用のRansackオブジェクト
    @user_q = User.ransack(params[:user_q])

  end

  # 検索を実行して結果を表示するためのアクション
  def show
    @q = Grave.ransack(params[:q])
    @graves = @q.result(distinct: true)
    @users = @q.result(distinct: true)
    latitude = params[:latitude]
    longitude = params[:longitude]

    if params[:genre_name].present?
      @graves = @graves.joins(:genres).where(genres: { name: params[:genre_name] })
    end

    if params[:prefecture].present?
      @graves = @graves.where(prefecture: params[:prefecture])
    end

    
    if latitude.present? && longitude.present?
      lat = latitude.to_f
      lng = longitude.to_f
    
      # まず近くの墓をざっくり取得
      nearby_graves = Grave.where(latitude: (lat - 1)..(lat + 1), longitude: (lng - 1)..(lng + 1))
    
      # Rubyで距離を計算して、近い順に並べ替える.Geocoder は内部で distance という仮想カラム を生成します。
      # 使わない！（SELECT graves.*, distance ... というSQLを発行する）
      @graves = nearby_graves.sort_by do |grave|
        Geocoder::Calculations.distance_between([lat, lng], [grave.latitude, grave.longitude])
      end
    
    else
      @graves = Grave.none
    end
  end

  # def search
  #   # パラメータから緯度(latitude)と経度(longitude)を取得
  #   latitude = params[:latitude]
  #   longitude = params[:longitude]

  #   if latitude.present? && longitude.present?
  #     # nearメソッドで検索
  #     # [緯度, 経度], 距離(km), 単位を指定
  #     @graves = Grave.near([latitude, longitude], 100, units: :km)
  #   else
  #     # 緯度経度が送られてこなかった場合は全ての墓所を表示する、などの処理
  #     @graves = Grave.all
  #   end
  # end

end