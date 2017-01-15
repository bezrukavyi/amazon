class Provider < ApplicationRecord
  belongs_to :user

  scope :find_by_omniauth, -> (auth) do
    where(name: auth.provider, uid: auth.uid)
  end

  def self.authorize(auth)
    provider = find_by_omniauth(auth)
    return provider.first if provider.present?
    user = User.where(email: auth.info.email).first_or_create do |user|
      generated_password = Devise.friendly_token.first(8)
      user.password = generated_password
    end
    user.providers.create(name: auth.provider, uid: auth.uid)
  end

end
