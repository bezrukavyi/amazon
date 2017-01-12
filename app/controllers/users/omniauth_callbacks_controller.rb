class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.generate_provider(provider)
    define_method("#{provider}") do
      user = Provider.with_omniauth(request.env['omniauth.auth'])
      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, :kind => "#{provider}") if is_navigational_format?
      else
        session["devise.#{provider}_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  [:google_oauth2, :facebook].each do |provider|
    generate_provider(provider)
  end

end
