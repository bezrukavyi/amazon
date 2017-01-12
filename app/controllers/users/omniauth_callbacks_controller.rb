class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.generate_provider(provider_type)
    define_method("#{provider_type}") do
      provider = Provider.with_omniauth(request.env['omniauth.auth'])
      if provider.try(:persisted?)
        sign_in_and_redirect provider.user, event: :authentication
        set_flash_message(:notice, :success, :kind => "#{provider_type}") if is_navigational_format?
      else
        session["devise.#{provider_type}_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  [:google_oauth2, :facebook].each do |provider_type|
    generate_provider(provider_type)
  end

end
