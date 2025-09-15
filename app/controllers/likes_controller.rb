class LikesController < ApplicationController
  before_action :set_likeable, only: [ :index ]
  def index
    @likes = @likeable.likes.order(created_at: :desc)
  end
  def new
    @like = Like.new
  end

  def create
    likeable_type = params[:like][:likeable_type]
    likeable_id = params[:like][:likeable_id]
    @likeable = likeable_type.constantize.find(likeable_id)
    @like = @likeable.likes.new(user: current_user)

    respond_to do |format|
      if @like.save
        @likeable.is_a?(Post) ? Post.increment_counter(:likes_count, @likeable.id) : Comment.increment_counter(:likes_count, @likeable.id)
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = Like.find(params[:id])

    respond_to do |format|
      if @like.delete
        @like.likeable.is_a?(Post) ? Post.decrement_counter(:likes_count, @like.likeable.id) : Comment.decrement_counter(:likes_count, @like.likeable.id)
        format.turbo_stream
      else
        format.html { render :destroy, status: :unprocessable_entity }
      end
    end
  end

  private

  def like_params
    params.expect(like: [ :likeable_type, :likeable_id ])
  end

  def set_likeable
    if params[:post_id]
      @likeable = Post.find(params[:post_id])
    elsif params[:comment_id]
      @likeable = Comment.find(params[:comment_id])
    end
  end
end
