class Provider < ApplicationRecord
  belongs_to :user

  def self.get_omniauth_user(auth)
    provider = where(name: auth.provider, uid: auth.uid).first
    return provider.user if provider

    user = User.where(email: auth.info.email).first_or_create do |user|
      user.password ||= Devise.friendly_token[0,20]
      user.providers.create_with_auth(auth)
    end
  end

  private

  def self.create_with_auth(auth)
    Provider.create(
      name: auth.provider,
      uid: auth.uid)
  end

end
