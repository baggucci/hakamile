class Admin::UsersController < Admin::BaseController
    def index
      @users = User.all
    end
    
    def show
      @user = User.find(params[:id])
      @posts = @user.posts 
      render 'users/show'

    end
  
    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: 'ユーザーを削除しました。'
    end
  end