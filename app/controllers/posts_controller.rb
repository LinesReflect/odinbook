class PostsController < ApplicationController
  def index
    @pagy, @posts = pagy(Post.user_feed(current_user).includes(:poster).order(created_at: :desc), limit: 10)

    post_ids = @posts.map(&:id)

    @comments = Comment.where(post_id: post_ids).includes(:user)

    @user_post_likes = current_user.likes.where(likeable_type: "Post", likeable_id: post_ids).index_by(&:likeable_id)

    @user_comment_likes = current_user.likes.where(likeable_type: "Comment", likeable_id: @comments.pluck(:id)).index_by(&:likeable_id)

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def new
    @post = Post.new

    @context = params[:context]
  end

  def create
    @post = Post.new(post_params)
    @context = params[:context]

    respond_to do |format|
      if @post.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @post = Post.find(params[:id])

    @user_comment_likes = current_user.likes.where(likeable_type: "Comment", likeable_id: @post.comments.pluck(:id)).index_by(&:likeable_id)
  end

  def destroy
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.delete
        format.turbo_stream
      end
    end
  end

  private
  def post_params
    params.expect(post: [ :body, :poster_id ])
  end
end
