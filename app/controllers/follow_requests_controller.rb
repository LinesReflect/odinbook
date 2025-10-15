class FollowRequestsController < ApplicationController
  helper UsersHelper
  def index
    @follow_requests = current_user.sent_follow_requests + current_user.received_follow_requests

    @recieved_follow_requests = current_user.received_follow_requests.includes(:requester).index_by(&:requester)
    @pagy_received, @sent_by_users = pagy(User.where(id: current_user.received_follow_requests.map(&:requester_id)), limit: 12, page_param: "received_page")

    @sent_follow_requests = current_user.sent_follow_requests.includes(:requested).index_by(&:requested)
    @pagy_sent, @sent_to_users = pagy(User.where(id: current_user.sent_follow_requests.map(&:requested_id)), limit: 12, page_param: "sent_page")

    @follow_request = FollowRequest.new

    @follow = Follow.new
  end

  def new
    @follow_request = FollowRequest.new
  end

  def create
    @follow_request = FollowRequest.new(follow_request_params)

    respond_to do |format|
      if @follow_request.save
        @sent_follow_requests = current_user.sent_follow_requests.includes(:requested).index_by(&:requested)
        format.turbo_stream
        format.html { redirect_back_or_to requests_path(current_user) }
      else
        format.html { redirect_back_or_to requests_path(current_user) }
      end
    end
  end

  def destroy
    @follow_request = FollowRequest.find(params[:id])
    @approved = @follow_request.requester.follows?(@follow_request.requested)

    @follow_requests_page = params[:follow_requests_page]

    respond_to do |format|
      if @follow_request.destroy
        format.turbo_stream
        format.html { redirect_back_or_to requests_path(current_user) }
      else
        format.html { redirect_back_or_to requests_path(current_user) }
      end
    end
  end

  private

  def follow_request_params
    params.expect(follow_request: [ :requester_id, :requested_id ])
  end
end
