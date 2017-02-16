describe ProviderMailer, type: :mailer do
  describe '#autorize' do
    let(:user) { create :user }
    let(:mail) do
      described_class.authorize(user: user, provider: 'Facebook',
                                password: 'test').deliver_now
    end

    it 'renders the subject' do
      expect(mail.subject).to eq('Success authorize')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['rspecyaroslav@gmail.com'])
    end

    it 'assigns user email' do
      expect(mail.body.encoded).to match(user.email)
    end

    it 'assigns generated password' do
      expect(mail.body.encoded).to match('test')
    end

    it 'assigns provider' do
      expect(mail.body.encoded)
        .to match(I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook'))
    end
  end
end
