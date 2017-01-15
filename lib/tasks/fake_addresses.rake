require 'ffaker'

namespace :db do
  task fake_addresses: :environment do

    Address.create!(
      first_name: FFaker::Name.first_name,
      last_name: FFaker::Name.last_name,
      name: FFaker::Address.street_name,
      city: 'Dnepr',
      zip: 49000,
      phone: '+380632863823',
      country_id: Country.first.id,
      address_type: 0,
      addressable: User.find_by_email('yaroslav555@gmail.com'))

    Address.create!(
      first_name: FFaker::Name.first_name,
      last_name: FFaker::Name.last_name,
      name: FFaker::Address.street_name,
      city: 'Odessa',
      zip: 49000,
      phone: '+380632863823',
      country_id: Country.first.id,
      address_type: 1,
      addressable: User.find_by_email('yaroslav555@gmail.com'))

  end
end
