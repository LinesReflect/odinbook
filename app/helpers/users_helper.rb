module UsersHelper
  def current_user_follows(user)
    current_user.follows?(user) && user.follows?(current_user)
  end

  def current_user_requests_to_follow(user)
    current_user.sent_follow_request_to?(user)
  end

  def current_user_not_following_not_requesting(user)
    !current_user_follows(user) && !current_user_requests_to_follow(user)
  end

  def user_requests_to_follow(user)
    user.sent_follow_request_to?(current_user)
  end
end
