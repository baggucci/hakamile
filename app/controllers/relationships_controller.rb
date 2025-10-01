class RelationshipsController < ApplicationController
    before_action :authenticate_user! # Deviseなどでのログイン認証
  
    # フォローする
    def create
      @user = User.find(params[:relationship][:followed_id])
      current_user.follow(@user)

    end
  
    # フォローを外す
    def destroy
      user = Relationship.find(params[:id]).followed
      current_user.unfollow(user)
      redirect_back(fallback_location: root_path)
    end
  end