FactoryGirl.define do

  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    email { FactoryGirl.generate(:email) }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    password 'test555'
    password_confirmation 'test555'

    trait :full_package do
      credit_card
      shipping { create :address_user, :shipping }
      billing { create :address_user, :billing }
    end

    trait :invalid do
      first_name nil
    end

    trait :admin do
      admin true
    end

  end

end
