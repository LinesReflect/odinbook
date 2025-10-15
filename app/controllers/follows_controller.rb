class FollowsController < ApplicationController
  def new
    @follow = Follow.new
  end

  def create
    @follow = Follow.new(follow_params)
    @follow_request = FollowRequest.find(params[:follow][:follow_request])

    respond_to do |format|
      if @follow.save
        @follow_request.destroy
        format.turbo_stream
        format.html { redirect_to user_path(@follow.follower) }
      end
    end
  end

  def destroy
    @follow = Follow.find(params[:id])
    @follow.delete
  end

  private

  def follow_params
    params.expect(follow: [ :followed_id, :follower_id ])
  end
end
