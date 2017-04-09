class ProviderMailer < ApplicationMailer
  def authorize(options)
    @user = options[:user]
    @password = options[:password]
    @provider = options[:provider]
    mail to: @user.email, subject: 'Success authorize'
  end
end
