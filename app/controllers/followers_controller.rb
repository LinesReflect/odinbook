class FollowersController < ApplicationController
  before_action :set_user

  def index
    @pagy, @followers = pagy(@user.followers.with_attached_avatar, limit: 28)

    @sent_follow_requests = @user.sent_follow_requests.where(requested: @followers, requester: current_user).includes(:requested).index_by(&:requested)

    @follow_request = FollowRequest.new
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end
end
