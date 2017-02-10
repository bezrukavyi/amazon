describe CreditCardForm, :credit_card_form do
  context 'validation' do
    subject { CreditCardForm.from_model(build(:credit_card)) }

    [:name, :number, :cvv].each do |attribute_name|
      it { should validate_presence_of(attribute_name) }
    end

    [:number, :cvv].each do |attribute_name|
      it { should validate_numericality_of(attribute_name).only_integer }
    end

    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_length_of(:cvv).is_at_least(3).is_at_most(4) }
  end
end
