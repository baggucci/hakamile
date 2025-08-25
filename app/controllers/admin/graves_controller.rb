class Admin::GravesController < ApplicationController
 # show, edit, update, destroyアクションの前に、対象のデータを@graveにセットする
 before_action :set_grave, only: [:show, :edit, :update, :destroy]

 # GET /admin/graves
 # 墓所の一覧を表示
 def index
   @graves = Grave.all.order(created_at: :desc)
 end

 # GET /admin/graves/:id
 # 特定の墓所の詳細を表示
 def show
   # @graveはbefore_actionでセット済み
 end
 
 # GET /admin/graves/new
 # 新規登録フォームを表示
 def new
   @grave = Grave.new
 end

  # フォームから送信されたデータを保存
  def create
    @grave = Grave.new(grave_params)
    if @grave.save
      redirect_to admin_graves_path, notice: '新しい墓所情報を登録しました。' # 成功したら一覧ページへ
    else
      flash.now[:alert] = '登録に失敗しました。'
      render :new # 失敗したらフォームを再表示
    end
  end

 # PATCH /admin/graves/:id
  # フォームから送信されたデータで更新
  def update
    # @graveはbefore_actionでセット済み
    if @grave.update(grave_params)
      redirect_to admin_grave_path(@grave), notice: '墓所情報を更新しました。'
    else
      flash.now[:alert] = '更新に失敗しました。必須項目を確認してください。'
      render :edit
    end
  end

  # DELETE /admin/graves/:id
  # データを削除
  def destroy
    # @graveはbefore_actionでセット済み
    @grave.destroy
    redirect_to admin_graves_path, notice: '墓所情報を削除しました。'
  end  
  
  private

  # Strong Parametersで許可するカラムを定義
  def grave_params
    params.require(:grave).permit(
      :name,     # 人名 [cite: 77]
      :address,         # 住所 [cite: 79]
      :prefecture,      # 所在地都道府県 [cite: 81]
      :description,     # 説明文 [cite: 83]
      :latitude,        # 緯度 [cite: 85]
      :longitude,       # 経度 [cite: 87]
      genre_ids: []      # 関連付けるジャンルのID（複数選択を想定）[cite: 116, 129]
    )
  end

   # idを元にデータベースからデータを取得する共通処理
   def set_grave
    @grave = Grave.find(params[:id])
  end
end