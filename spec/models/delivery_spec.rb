require 'rails_helper'

RSpec.describe Delivery, type: :model do

  subject { create :delivery }

  context 'validation' do

    context 'valid' do
      it 'valid of uniq name and different country' do
        country_first = create :country
        country_second = create :country
        name = 'Rspec'
        delivery_first = create :delivery, name: name, country: country_first
        delivery_second = build :delivery, name: name, country: country_second
        expect(delivery_second).to be_valid
      end
    end

    context 'invalid' do
      it 'when min_days is less 0' do
        subject.min_days = -1
        expect(subject).not_to be_valid
      end
      it 'when max_days is less 0' do
        subject.max_days = -1
        expect(subject).not_to be_valid
      end
      it 'when not uniq name and country' do
        country = create :country
        name = 'Rspec'
        delivery_first = create :delivery, name: name, country: country
        delivery_second = build :delivery, name: name, country: country
        expect(delivery_second).not_to be_valid
      end
      it '#min_days_cannot_be_greater_than_max_days' do
        delivery = build :delivery, min_days: 10, max_days: 5
        expect(delivery).not_to be_valid
      end
    end
  end
end
