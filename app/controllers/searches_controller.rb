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

    if params[:genre_name].present?
      @graves = @graves.joins(:genres).where(genres: { name: params[:genre_name] })
    end

    if params[:prefecture].present?
      @graves = @graves.where(prefecture: params[:prefecture])
    end

  end

end