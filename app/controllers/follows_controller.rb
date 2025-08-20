class FollowsController < ApplicationController
  def new(user1, user2)
    @follow = Follow.new
  end

  def create
    @follower_user = User.find(follow_params[:follower])

    if @follower_user.follow(User.find(follow_params[:followed]))
      redirect_back_or_to root_path
    else
      redirect_back_or_to root_path
    end
  end

  def destroy
    @follow = Follow.find(params[:id])
    @follow.delete
    redirect_back_or_to root_path
  end

  private

  def follow_params
    params.expect(follow: [ :followed, :follower ])
  end
end
