class UsersController < ApplicationController
  def index
    @users = User.all
    @follow = Follow.new
  end
  def show
    @user = User.find(params[:id])
    @follow = Follow.new
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
