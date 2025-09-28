class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.likes.create(post_id: @post.id)
    @post.reload   # ← これが重要
    respond_to do |format|
      format.js # create.js.erb を呼び出す
      format.html { redirect_to @post }
    end
  end

  def destroy
    like = current_user.likes.find_by(post_id: @post.id)
    like&.destroy
    @post.reload   # ← これが重要
    respond_to do |format|
      format.js # destroy.js.erb を呼び出す
      format.html { redirect_to @post }
    end
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

end