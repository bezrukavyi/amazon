class Provider < ApplicationRecord
  belongs_to :user

  scope :find_by_omniauth, -> (auth) do
    where(name: auth.provider, uid: auth.uid)
  end

  def self.authorize(auth)
    provider = find_by_omniauth(auth)
    return provider.first if provider.present?
    user = User.where(email: auth.info.email).first_or_create do |user|
      user.password = generate_password
      user.remote_avatar_url = parse_image(auth)
      user.first_name = parse_name(auth).first
      user.last_name = parse_name(auth).last
    end
    user.providers.create(name: auth.provider, uid: auth.uid)
  end

  private

  def self.parse_image(auth)
    return unless image = auth.info['image']
    image.gsub('http://','https://')
  end

  def self.parse_name(auth)
    return [] unless name = auth.info['name']
    name.split(' ')
  end

  def self.generate_password
    Devise.friendly_token.first(8)
  end

end
