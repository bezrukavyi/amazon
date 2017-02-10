class Provider < ApplicationRecord
  belongs_to :user

  scope :find_by_omniauth, -> (auth) do
    where(name: auth.provider, uid: auth.uid)
  end

  def self.authorize(auth)
    provider = find_by_omniauth(auth)
    return provider.first if provider.present?
    password = HumanPasswordValidator.generate_password
    user = set_user(auth, password)
    skip_confirm = user.new_record?
    return unless user.skip_confirmation! && user.save
    if skip_confirm
      ProviderMailer.authorize(user: user, provider: auth.provider, password: password).deliver
    end
    user.providers.create(name: auth.provider, uid: auth.uid)
  end

  def self.set_user(auth, password)
    User.find_or_initialize_by(email: auth.info.email) do |user|
      user.password = password
      user.remote_avatar_url = parse_image(auth)
      user.first_name = parse_name(auth).first
      user.last_name = parse_name(auth).last
    end
  end

  def self.parse_image(auth)
    return unless image = auth.info['image']
    image.gsub('http://', 'https://')
  end

  def self.parse_name(auth)
    return [] unless name = auth.info['name']
    name.split(' ')
  end
end
