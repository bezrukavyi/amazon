# Preview all emails at http://localhost:3000/rails/mailers/provider
class ProviderPreview < ActionMailer::Preview
  def authorize
    ProviderMailer.authorize(user: User.last, provider: 'Facebook',
                             password: 'test')
  end
end
