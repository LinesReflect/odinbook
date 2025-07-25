# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  skip_before_action :verify_authenticity_token, only: [ :google_oauth2, :twitter2 ]

  def authorize(kind)
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind
      sign_in_and_redirect user, event: :authentication
    else
      # Useful for debugging login failures. Uncomment for development.
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra") # Removing extra as it can overflow some session stores
      redirect_to new_user_session_url
    end
  end

  def google_oauth2
    authorize("Google")
  end

  def twitter2
    authorize("Twitter")
  end


  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
