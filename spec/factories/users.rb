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
  end

  factory :invalid_user, parent: :user do
    first_name nil
  end

  factory :admin, parent: :user do
    admin true
  end

end
