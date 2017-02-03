require 'rails_helper'

RSpec.describe HumanPasswordValidator, type: :validator do

  let(:user) { create :user }

  it 'valid' do
    user.validate(:password)
  end

  context '#invalid' do
    after do
      user.validate(:password)
      expect(user.errors.full_messages)
        .to include('Password ' + I18n.t('validators.human.password.base_regexp'))
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
    it 'less than 8' do
      user.password = 'Yar5'
    end
  end

end
