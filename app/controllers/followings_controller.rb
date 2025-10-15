class FollowingsController < ApplicationController
  before_action :set_user

  def index
    @pagy, @followings = pagy(@user.followings.with_attached_avatar, limit: 28)

    @sent_follow_requests = FollowRequest.where(requested: @followings, requester: current_user).includes(:requested).index_by(&:requested)

    @follow_request = FollowRequest.new
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end
end
