describe Delivery, type: :model do
  subject { build :delivery }

  context 'association' do
    it { should have_many :orders }
    it { should belong_to :country }
  end

  context 'validation' do
    %i(min_days max_days name price).each do |attribute_name|
      it { should validate_presence_of(attribute_name) }
    end

    it { should validate_numericality_of(:min_days).is_greater_than(0) }
    it { should validate_numericality_of(:max_days).is_greater_than(0) }

    context 'validetion of uniq name and different country' do
      it 'valid' do
        country_first = create :country
        country_second = create :country
        name = 'Rspec'
        create :delivery, name: name, country: country_first
        delivery = build :delivery, name: name, country: country_second
        expect(delivery).to be_valid
      end

      it 'invalid' do
        country = create :country
        name = 'Rspec'
        create :delivery, name: name, country: country
        delivery = build :delivery, name: name, country: country
        expect(delivery).not_to be_valid
      end
    end

    describe '#access_max_days' do
      it 'valid' do
        delivery = build :delivery, min_days: 10, max_days: 11
        expect(delivery).to be_valid
      end
      it 'invalid' do
        delivery = build :delivery, min_days: 10, max_days: 5
        delivery.valid?
        expect(delivery.errors.full_messages).to include('Min days ' +
          I18n.t('validators.delivery.access_max_days'))
      end
    end
  end
end
