require 'rails_helper'

RSpec.describe CreditCardForm, :credit_card_form do

  context 'validation' do
    subject { CreditCardForm.from_model(build :credit_card) }

    [:name, :number, :cvv].each do |attribute_name|
      it { should validate_presence_of(attribute_name) }
    end

    [:number, :cvv].each do |attribute_name|
      it { should validate_numericality_of(attribute_name).only_integer }
    end

    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_length_of(:cvv).is_equal_to(3) }

    context 'month_year MM/YY' do

      describe '#slash_format' do
        it 'valid format' do
          subject.month_year = '12/17'
          expect(subject).to be_valid
        end
        it 'invalid format' do
          subject.month_year = '12\17'
          expect(subject).not_to be_valid
        end
      end

      describe '#month_format' do
        it 'valid format' do
          subject.month_year = '12/17'
          expect(subject).to be_valid
        end
        it 'invalid format' do
          subject.month_year = '102/17'
          expect(subject).not_to be_valid
        end
      end

      describe '#year_format' do
        it 'valid format' do
          subject.month_year = '12/17'
          expect(subject).to be_valid
        end
        it 'invalid format' do
          subject.month_year = '102/1721'
          expect(subject).not_to be_valid
        end
      end
    end

  end

end
