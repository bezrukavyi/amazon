FactoryGirl.define do

  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    after(:build)   { |user| user.skip_confirmation_notification! }
    after(:create)  { |user| user.confirm }

    email { FactoryGirl.generate(:email) }
    first_name 'Ivan'
    last_name 'Ivan'
    password 'Test55555'
    password_confirmation 'Test55555'

    trait :full_package do
      credit_cards { [create(:credit_card)] }
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
