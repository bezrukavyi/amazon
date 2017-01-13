module Support
  module OmniauthHelper
    def set_omniauth(provider)

      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
        provider: provider.to_s,
        uid: '1337',
        info: { email: 'jon@test.com' }
      })

      set_request(provider)

    end

    def set_invalid_omniauth(provider)
      credentials = { provider: provider.to_sym, invalid: :invalid_crendentials }
      OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
      set_request(provider)
    end

    private
    def set_request(provider)
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # If using Devise
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[provider.to_sym]
    end

  end
end
