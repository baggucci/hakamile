class SearchesController < ApplicationController
  # 検索フォームを表示するためのアクション
  def new
    @grave_q = Grave.ransack(params[:grave_q])
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
    
      # 緯度(latitude)と経度(longitude)。longitude:1度で約111km
      nearby_graves = Grave.where(latitude: (lat - 1)..(lat + 1), longitude: (lng - 1)..(lng + 1))
      @graves = nearby_graves.sort_by do |grave|
        Geocoder::Calculations.distance_between([lat, lng], [grave.latitude, grave.longitude])
      end
    
    else
      @graves = Grave.none
    end
  end
end