FactoryGirl.define do

  factory :address do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    address { FFaker::AddressUS.street_address }
    zip { FFaker::AddressUS.zip_code }
    phone '0632863823'
    city { FFaker::AddressUS.city }
    country_id { create(:country).id }
  end

  factory :shipping_address, parent: :address do
    address_type 1
  end

  factory :billing_address, parent: :address do
    address_type 0
  end
end
