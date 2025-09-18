class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    # current_user.likes.create(post_id: @post.id) でも可
    like = Like.new(user_id: current_user.id, post_id: @post.id)
    like.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = Like.find_by(user_id: current_user.id, post_id: @post.id)
    like.destroy
  end
end