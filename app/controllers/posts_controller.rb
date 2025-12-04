
class PostsController < ApplicationController
  # edit, update, destroyアクションの前に、対象の投稿データを取得し、本人確認を行う
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy] # 編集・更新・削除権限の確認
  before_action :authenticate_user!

  def index
    @posts = Post.visible_for(current_user, params[:page])
  end

  def show
    # @post は before_action で設定されているので重複取得を削除
    @comment = Comment.new
  end

  def new
    if params[:grave_id].present?
      @grave = Grave.find(params[:grave_id])
      @post = Post.new(grave: @grave)
    else
      @post = Post.new
      @graves = Grave.all
    end
  end

  def edit
        # @postはbefore_actionで設定済み
  end

  def create
    begin
      @post = Post.create_for_user(current_user, post_params.to_h)
      redirect_to grave_path(@post.grave), notice: '墓参日記を投稿しました。'
    rescue ActiveRecord::RecordInvalid
      if post_params[:grave_id].present?
        @grave = Grave.find_by(id: post_params[:grave_id])
      end
      @graves = Grave.all
      flash.now[:alert] = '投稿に失敗しました。'
      render :new, status: :unprocessable_entity
    end
  end

   # PATCH /posts/:id
   def update
    if @post.update_with_deleted_images(post_params.to_h, params[:delete_image_ids])
      redirect_to @post, notice: '投稿が更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  def destroy
    # @postはbefore_actionで設定済み
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました。"
  end

  def liked
    @liked_posts = current_user.liked_posts.order(created_at: :desc)
  end

  private

  # Strong Parameters
  def post_params
    params.require(:post).permit(:title, :body, :grave_id, :status, images:[])
  end

  # 対象の投稿データを取得する
  def set_post
    @post = Post.find(params[:id])
  end

    # 投稿者本人であるかを確認する
    def ensure_correct_user
      # ログインユーザーと投稿のユーザーが一致しない場合はリダイレクト
      unless @post.user == current_user
        redirect_to posts_path, alert: "他のユーザーの投稿は編集・削除できません。"
      end
    end

end
