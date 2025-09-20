class UsersController < ApplicationController
  def index
    ids = Rails.cache.fetch("random_ids", expires_in: 1.hour) do
      User.where.not(id: current_user.id).limit(100).pluck(:id).shuffle
    end

    @pagy, @users = pagy(User.where(id: ids).order_as_specified(id: ids), limit: 28)

    @follow = Follow.new
  end
  def show
    @user = User.find(params[:id])

    @follow = Follow.new

    @pagy, @posts = pagy(@user.posts.order(created_at: :desc), limit: 10)

    @user_post_likes = current_user.likes.where(likeable: @user.posts).index_by(&:likeable_id)

    @comments = Comment.where(post_id: @user.posts.pluck(:id)).includes(:user)

    @user_comment_likes = current_user.likes.where(likeable: @comments).index_by(&:likeable_id)

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.save
      redirect_back_or_to root_path
    else
      redirect_to root_path
    end
  end
end
