# app/controllers/public/users_controller.rb
class UsersController < ApplicationController
    # ログインしていないユーザーはログインページにリダイレクト
    before_action :authenticate_user!
    before_action :set_current_user, only: [:mypage, :edit, :update]
  
    # GET /mypage
    # マイページ（自身の投稿一覧）を表示
    def mypage
      # @userにはログイン中のユーザー情報がセットされている
      @posts = @user.posts.order(created_at: :desc)
    end
  
    # GET /mypage/edit
    # プロフィール編集フォームを表示
    def edit
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
  
    private
  
    def set_current_user
      @user = current_user
    end
    
    def user_params
      params.require(:user).permit(:name, :profile)
    end
  end
  