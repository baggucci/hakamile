# app/controllers/relationships_controller.rb

class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # フォローする
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow(@user)

    # JSからのリクエストに応答するよう設定
    respond_to do |format|
      format.html { redirect_to @user } # 通常のHTMLリクエストの場合
      format.js                         # JSリクエストの場合 (create.js.erbを呼び出す)
    end
  end

  # フォローを外す
  def destroy
    # ★ user を @user に変更
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    # ★ redirect_back を削除し、JSで応答するよう設定
    respond_to do |format|
      format.html { redirect_to @user } # 通常のHTMLリクエストの場合
      format.js                         # JSリクエストの場合 (destroy.js.erbを呼び出す)
    end
  end
end