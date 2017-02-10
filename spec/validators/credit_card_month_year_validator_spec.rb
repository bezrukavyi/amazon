describe CreditCardMonthYearValidator, type: :validator do

  with_model :MockCard do
    table do |t|
      t.string :month_year
    end

    model do
      validates :month_year, credit_card_month_year: true
    end
  end

  let(:credit_card) { MockCard.new(month_year: '12/12') }

  describe '#slash_format' do
    it 'valid format' do
      credit_card.month_year = '12/17'
      expect(credit_card).to be_valid
    end
    context 'invalid' do
      after do
        credit_card.validate(:month_year)
        expect(credit_card.errors.full_messages)
          .to include('Month year ' + I18n.t('validators.credit_card.slash_format'))
      end
      it 'when invalid format' do
        credit_card.month_year = '12\17'
      end
      it 'with empty' do
        credit_card.month_year = nil
      end
    end
  end

  describe '#month_format' do
    it 'valid format' do
      credit_card.month_year = '12/17'
      expect(credit_card).to be_valid
    end
    context 'invalid' do
      after do
        credit_card.validate(:month_year)
        expect(credit_card.errors.full_messages)
          .to include('Month year ' + I18n.t('validators.credit_card.month_format'))
      end
      it 'when invalid format' do
        credit_card.month_year = '102/17'
      end
      it 'with empty' do
        credit_card.month_year = nil
      end
    end
  end

  describe '#year_format' do
    it 'valid format' do
      credit_card.month_year = '12/17'
      expect(credit_card).to be_valid
    end
    context 'invalid' do
      after do
        credit_card.validate(:month_year)
        expect(credit_card.errors.full_messages)
          .to include('Month year ' + I18n.t('validators.credit_card.year_format'))
      end
      it 'when invalid format' do
        credit_card.month_year = '12/1721'
      end
      it 'with empty' do
        credit_card.month_year = nil
      end
    end
  end
end
