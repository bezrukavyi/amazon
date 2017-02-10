describe HumanPasswordValidator, type: :validator do

  with_model :MockUser do
    table do |t|
      t.string :password
    end

    model do
      validates :password, human_password: true
    end
  end

  let(:user) { MockUser.new(password: 'Password555') }

  context '#invalid' do
    after do
      user.validate(:password)
      expect(user.errors.full_messages)
        .to include('Password ' + I18n.t('validators.human.password.base_regexp'))
    end
    it 'when empty' do
      user.password = nil
    end
    it 'without A-Z' do
      user.password = 'yaroslav5555'
    end
    it 'without a-z' do
      user.password = 'YAROSLAV5555'
    end
    it 'without 0-9' do
      user.password = 'YAROSLAVyaroslav'
    end
  end

  describe '.generate_password' do
    it 'valid password' do
      expect(HumanPasswordValidator.generate_password).to match(HumanPasswordValidator::INSPECTION)
    end
    it 'lenght 50' do
      expect(HumanPasswordValidator.generate_password.length).to eq(50)
    end
  end

end
