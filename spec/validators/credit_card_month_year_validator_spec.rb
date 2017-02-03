require 'rails_helper'

RSpec.describe CreditCardMonthYearValidator, type: :validator do

  let(:credit_card) { CreditCardForm.from_model(build :credit_card) }

  describe '#slash_format' do
    it 'valid format' do
      credit_card.month_year = '12/17'
      expect(credit_card).to be_valid
    end
    it 'invalid format' do
      credit_card.month_year = '12\17'
      credit_card.validate(:month_year)
      expect(credit_card.errors.full_messages)
        .to include('Month year ' + I18n.t('validators.credit_card.slash_format'))
    end
  end

  describe '#month_format' do
    it 'valid format' do
      credit_card.month_year = '12/17'
      expect(credit_card).to be_valid
    end
    it 'invalid format' do
      credit_card.month_year = '102/17'
      credit_card.validate(:month_year)
      expect(credit_card.errors.full_messages)
        .to include('Month year ' + I18n.t('validators.credit_card.month_format'))
    end
  end

  describe '#year_format' do
    it 'valid format' do
      credit_card.month_year = '12/17'
      expect(credit_card).to be_valid
    end
    it 'invalid format' do
      credit_card.month_year = '12/1721'
      credit_card.validate(:month_year)
      expect(credit_card.errors.full_messages)
        .to include('Month year ' + I18n.t('validators.credit_card.year_format'))
    end
  end

end
