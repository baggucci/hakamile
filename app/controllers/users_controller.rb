# app/controllers/public/users_controller.rb
class UsersController < ApplicationController
    # ログインしていないユーザーはログインページにリダイレクト
    before_action :authenticate_user!
    before_action :set_current_user, only: [:mypage, :edit, :update]
    before_action :ensure_guest_user, only: [:edit]
 
    # GET /mypage
    # マイページ（自身の投稿一覧）を表示
    def mypage
      # @userにはログイン中のユーザー情報がセットされている
      @posts = @user.posts.order(created_at: :desc)
    end
  
    # GET /mypage/edit
    # プロフィール編集フォームを表示
    def edit
      @user = current_user

      # @userにはログイン中のユーザー情報がセットされている
    end
  
    # PATCH /mypage
    # プロフィール情報を更新
    def update
      if @user.update(user_params)
        redirect_to mypage_path, notice: 'プロフィールを更新しました。'
      else
        render :edit
      end
    end
    
    # GET /users/:id
    # (参考)他のユーザーのプロフィールページ
    def show
      @user = User.find(params[:id])
      @posts = @user.posts.order(created_at: :desc)
    end

    def guest_sign_in
      sign_in User.guest
      redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
    end

    # フォロー/フォロワーの一覧を表示するためのアクション
    def following
      @user  = User.find(params[:id])
      @users = @user.following
    end
  
    def followers
      @user  = User.find(params[:id])
      @users = @user.followers
    end
  
    private
  
    def set_current_user
      @user = current_user
    end
    
    def user_params
      params.require(:user).permit(:name, :profile)
    end

    def ensure_guest_user
#      @user = User.find(params[:id])
      if @user.guest_user?
        redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      end
    end  

  end
  