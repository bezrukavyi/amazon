FactoryGirl.define do
  factory :credit_card do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    cvv '123'
    month 12
    number 5274576394259961
    year 2018
    association :user

    trait :invalid do
      first_name nil
    end

  end

end
