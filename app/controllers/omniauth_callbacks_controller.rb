class OmniauthCallbacksController < ApplicationController
  def vkontakte
    puts request.env["omniauth.auth"].inspect
    @user = User.find_for_vkontakte_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      #set_flash_message(:notice, :success, :kind => "Vkontakte") if is_navigational_format?
    else      
      session["devise.vkontakte_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
