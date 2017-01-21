FactoryGirl.define do

  factory :delivery do
    name { "#{FFaker::Address.country} Standart Post" }
    price 9.99
    min_days 5
    max_days 10
    country_id { create(:country).id }
  end

  factory :invalid_delivery, parent: :delivery do
    name nil
  end

end
