FactoryGirl.define do
  factory :user do
    after(:build, &:skip_confirmation_notification!)
    after(:create, &:confirm)

    email { FFaker::Internet.email }
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
