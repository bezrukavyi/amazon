describe Delivery, type: :model do

  subject { build :delivery }

  context 'association' do
    it { should have_many :orders }
    it { should belong_to :country }
  end

  context 'validation' do
    [:min_days, :max_days, :name, :price].each do |attribute_name|
      it { should validate_presence_of(attribute_name) }
    end

    it { should validate_numericality_of(:min_days).is_greater_than(0) }
    it { should validate_numericality_of(:max_days).is_greater_than(0) }

    context 'validetion of uniq name and different country' do
      it 'valid' do
        country_first = create :country
        country_second = create :country
        name = 'Rspec'
        delivery_first = create :delivery, name: name, country: country_first
        delivery_second = build :delivery, name: name, country: country_second
        expect(delivery_second).to be_valid
      end

      it 'invalid' do
        country = create :country
        name = 'Rspec'
        delivery_first = create :delivery, name: name, country: country
        delivery_second = build :delivery, name: name, country: country
        expect(delivery_second).not_to be_valid
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
        expect(delivery.errors.full_messages).to include('Min days ' + I18n.t('simple_form.error_notification.delivery.access_max_days'))
      end
    end
  end

end
