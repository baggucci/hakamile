class PostsController < ApplicationController
  # edit, update, destroyアクションの前に、対象の投稿データを取得し、本人確認を行う
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy] # 編集・更新・削除権限の確認
  before_action :authenticate_user!

  def index
        # 公開されている投稿を新しい順にすべて取得
        @posts = Post.where(status: :published).order(created_at: :desc)

  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new  

  end

  def new
    @grave = Grave.find(params[:grave_id]) # リンクから渡されたgrave_idを受け取る
    @post = Post.new
  end
  
  def edit
        # @postはbefore_actionで設定済み
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to grave_path(@post.grave), notice: '墓参日記を投稿しました。'
    else
      # 失敗した場合、newアクションで使った@graveを再設定してnewページを再表示
      @grave = Grave.find(post_params[:grave_id])
      flash.now[:alert] = '投稿に失敗しました。'
      render :new
    end
  end

   # PATCH /posts/:id
   def update
    # @postはbefore_actionで設定済み
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました。"
    else
      # 更新失敗時にエラーメッセージを表示して編集フォームを再表示
      flash.now[:alert] = "更新に失敗しました。必須項目を確認してください。"
      render :edit
    end
  end

  # DELETE /posts/:id
  def destroy
    # @postはbefore_actionで設定済み
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました。"
  end

  private

  # Strong Parameters
  def post_params
    params.require(:post).permit(:title, :body, :grave_id, :status, :images[])
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
