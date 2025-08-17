class GravesController < ApplicationController

  def index
    @graves = Grave.all # 例: すべての墓石情報を取得
  end

  def show
    @grave = Grave.find(params[:id])
  end
  
end
