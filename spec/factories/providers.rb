FactoryGirl.define do
  factory :provider do
    name 'google'
    uid '12345678'
    association :user
  end
end
