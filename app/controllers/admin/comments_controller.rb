class Admin::CommentsController < Admin::BaseController
  def index
    # 関連するユーザーと投稿の情報を一度に取得してN+1問題を解消
    @comments = Comment.all.includes(:user, :post).order(created_at: :desc)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_path, notice: 'コメントを削除しました。'
  end
end