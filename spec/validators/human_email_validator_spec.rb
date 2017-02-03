require 'rails_helper'

RSpec.describe HumanEmailValidator, type: :validator do

  let(:user) { create :user }

  it 'valid' do
    user.validate(:email)
    expect(user.errors.full_messages).to be_blank
  end

  describe '#domain_regexp' do
    after do
      user.validate(:email)
      expect(user.errors.full_messages)
        .to include('Email ' + I18n.t('validators.human.email.base_regexp'))
    end
    it 'without @' do
      user.email = 'yaroslav@test'
    end
    it 'domain' do
      user.email = 'yaroslav@test'
    end
    it 'local' do
      user.email = 'yaroslav@test'
    end
  end

  describe '#local_regexp' do
    context 'valid' do
      after do
        user.validate(:email)
        expect(user.errors.full_messages).to be_blank
      end
      it 'middle symbol' do
        user.email = 'yaros.lav@gmail.com'
      end
      it 'end symbol' do
        user.email = 'yaroslav!@gmail.com'
      end
    end

    context 'invalid' do
      after do
        user.validate(:email)
        expect(user.errors.full_messages)
        .to include('Email ' + I18n.t('validators.human.email.symbols_regexp'))
      end
      it 'with twice successive dot' do
        user.email = 'yar..oslav@gmail.com'
      end
      it 'with twice dot' do
        user.email = 'yar.osl.av@gmail.com'
      end
      it 'started with symbol' do
        user.email = '!yaroslav@gmail.com'
      end
    end
  end

  describe '#dot_regexp' do

    context 'invalid' do
      after do
        user.validate(:email)
        expect(user.errors.full_messages)
        .to include('Email ' + I18n.t('validators.human.email.dot_regexp'))
      end
      it 'first dot' do
        user.email = '.yaroslav@gmail.com'
      end
      it 'last dot' do
        user.email = 'yaroslav.@gmail.com'
      end
    end
  end

end
