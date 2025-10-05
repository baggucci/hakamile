
class Admin::PostsController < Admin::BaseController
  def index
    @posts = Post.all.includes(:user, :grave).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
    render 'posts/show' 

  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: '投稿を削除しました。'
  end
end