class Provider < ApplicationRecord
  belongs_to :user

  def self.authorize(auth)
    provider = find_by(name: auth.provider, uid: auth.uid)
    return provider if provider.present?
    password = HumanPasswordValidator.generate_password
    user = user_by_auth(auth, password)
    if user.new_record? && user.save
      ProviderMailer.authorize(user: user, provider: auth.provider,
                               password: password).deliver
    end
    user.providers.create(name: auth.provider, uid: auth.uid)
  end

  def self.user_by_auth(auth, password)
    User.find_or_initialize_by(email: auth.info.email) do |user|
      user.password = password
      user.remote_avatar_url = parse_image(auth.info['image'])
      name = parse_name(auth.info['name'])
      user.first_name = name.first
      user.last_name = name.last
      user.skip_confirmation!
    end
  end

  def self.parse_image(image)
    return unless image
    image.gsub('http://', 'https://')
  end

  def self.parse_name(name)
    return [] unless name
    name.split(' ')
  end
end
