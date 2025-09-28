class UserSearchesController < ApplicationController
  def show
    # Userモデルに対してRansackで検索を実行
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end
end