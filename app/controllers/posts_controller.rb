class PostsController < ApplicationController
  def index
    @posts = Post.user_feed(current_user).includes(:poster).order(created_at: :desc).limit(10)

    post_ids = @posts.map(&:id)

    @comments = Comment.where(post_id: post_ids).includes(:user)

    @user_post_likes = current_user.likes.where(likeable_type: "Post", likeable_id: post_ids).index_by(&:likeable_id)

    @user_comment_likes = current_user.likes.where(likeable_type: "Comment", likeable_id: @comments.pluck(:id)).index_by(&:likeable_id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
  def post_params
    params.expect(post: [ :body, :poster_id ])
  end
end
