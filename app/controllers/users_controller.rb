class UsersController < ApplicationController
  def index
    ids = Rails.cache.fetch("random_ids", expires_in: 1.hour) do
      User.where.not(id: current_user.id).limit(100).pluck(:id).shuffle
    end

    @pagy, @users = pagy(User.where(id: ids).with_attached_avatar.order_as_specified(id: ids), limit: 28)

    @sent_follow_requests = FollowRequest.where(requested: ids, requester: current_user).includes(:requested).index_by(&:requested)

    @follow_request = FollowRequest.new
  end
  def show
    @user = User.find(params[:id])

    @follow_request_from_current_user = FollowRequest.find_by(requested: @user, requester: current_user)
    @follow_request_to_current_user = FollowRequest.find_by(requested: current_user, requester: @user)

    @follow_request = FollowRequest.new

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
