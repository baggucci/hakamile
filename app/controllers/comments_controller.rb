class CommentsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(comment_params)
      @comment.user_id = current_user.id
      
      if @comment.save
        redirect_to post_path(@post), notice: 'コメントを投稿しました。'
      else
        # 失敗した場合、投稿詳細ページの情報を再度取得して表示
        @comments = @post.comments.includes(:user)
        flash.now[:alert] = 'コメントを入力してください'
        render 'posts/show'
      end
    end
  
    def destroy
      @comment = Comment.find(params[:id])
      # 自分のコメントでなければ削除させない
      if @comment.user == current_user
        @comment.destroy
        redirect_to post_path(@comment.post), notice: 'コメントを削除しました。'
      else
        redirect_to post_path(@comment.post), alert: '他人のコメントは削除できません。'
      end
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:body)
    end
  end