class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.generate_provider(provider_type)
    define_method("#{provider_type}") do
      provider = Provider.authorize(request.env['omniauth.auth'])
      user = provider.user
      if user.try(:persisted?)
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: t("devise.providers.#{provider_type}"))
      else
        session["devise.#{provider_type}_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
        set_flash_message(:notice, :failure, kind: t("devise.providers.#{provider_type}"))
      end
    end
  end

  [:google_oauth2, :facebook].each do |type|
    generate_provider(type)
  end

end
