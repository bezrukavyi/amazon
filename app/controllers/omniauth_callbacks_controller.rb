class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.generate_provider(*provider_types)
    provider_types.each do |type|
      define_method("#{type}") do
        provider = Provider.authorize(request.env['omniauth.auth'])
        user_dispatch(provider, type)
      end
    end
  end

  generate_provider :google_oauth2, :facebook

  private

  def user_dispatch(provider, type)
    if provider.present? && provider.user.try(:persisted?)
      sign_in_and_redirect provider.user, event: :authentication
      set_flash_message(:notice, :success, kind: t("devise.providers.#{type}"))
    else
      redirect_to new_user_registration_url
      set_flash_message(:alert, :failure, kind: t("devise.providers.#{type}"))
    end
  end

end
