class UsersController < ApplicationController
  def index
    @users = User.all

    @follow = Follow.new
  end
  def show
    @user = User.find(params[:id])

    @follow = Follow.new

    @posts = @user.posts.order(created_at: :desc)

    @user_post_likes = current_user.likes.where(likeable: @user.posts).index_by(&:likeable_id)

    @comments = Comment.where(post_id: @user.posts.pluck(:id)).includes(:user)

    @user_comment_likes = current_user.likes.where(likeable: @comments).index_by(&:likeable_id)
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
