require 'rails_helper'

RSpec.describe CreditCardForm, :credit_card_form do

  context 'validation' do
    subject { CreditCardForm.from_model(build :credit_card) }

    it 'valud factory' do
      expect(subject).to be_valid
    end

    [:name:number, :cvv, :year, :month].each do |attribute_name|
      it { should validate_presence_of(attribute_name) }
    end

    [:number, :cvv].each do |attribute_name|
      it { should validate_numericality_of(attribute_name).only_integer }
    end


    it { should validate_length_of(:name).is_at_most(100) }


    it { should validate_length_of(:cvv).is_equal_to(3) }

    it { should validate_numericality_of(:month).is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:month).is_less_than_or_equal_to(12) }

    describe '#greater_than_or_equal_to_current_year' do
      it 'valid' do
        subject.year = Time.now.year + 1
        expect(subject).to be_valid
      end
      it 'invalid' do
        subject.year = Time.now.year - 1
        expect(subject).not_to be_valid
      end
    end

    describe '#less_than_or_equal_to_five_years_from_now' do
      it 'valid' do
        subject.year = Time.now.year + 4
        expect(subject).to be_valid
      end
      it 'invalid' do
        subject.year = Time.now.year + 6
        expect(subject).not_to be_valid
      end
    end

  end

end
