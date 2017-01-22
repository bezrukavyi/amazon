FactoryGirl.define do
  factory :credit_card do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    cvv '123'
    month 12
    number '111111111111111'
    year 2016
    association :user
  end

  factory :invalid_credit_card, parent: :credit_card do
    first_name nil
  end
end
