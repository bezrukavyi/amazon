require 'rails_helper'

RSpec.describe HumanNameValidator, type: :validator do

  describe '#one' do
    let(:user) { create :user }

    it 'valid' do
      user.validate(:first_name)
      expect(user.errors.full_messages).to be_blank
    end

    context 'invalid' do
      after do
        user.validate(:first_name)
        expect(user.errors.full_messages)
          .to include('First name ' + I18n.t('validators.human.name.base_regexp'))
      end

      it 'without end numeric' do
        user.first_name = 'yaroslav5'
      end
      it 'with spec sumbols' do
        user.first_name = 'yarosl%av'
      end
      it 'with space' do
        user.first_name = 'yaro slav'
      end
    end
  end

  describe '#few' do
    let(:credit_card) { CreditCardForm.from_model(build :credit_card) }

    it 'valid' do
      credit_card.name = 'Yaroslav Bezr'
      credit_card.validate(:name)
      expect(credit_card.errors.full_messages).to be_blank
    end

    context 'invalid' do
      after do
        credit_card.validate(:name)
        expect(credit_card.errors.full_messages)
          .to include('Name ' + I18n.t('validators.human.name.base_regexp'))
      end

      it 'with spec sumbols' do
        credit_card.name = 'yaroslav#fdasfd'
      end
      it 'with numeric' do
        credit_card.name = 'yaro323'
      end
    end
  end

end
