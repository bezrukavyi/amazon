FactoryGirl.define do
  factory :credit_card do
    name 'Ivan Ivan'
    cvv '123'
    month_year '12/17'
    number 5274576394259961
    association :user

    trait :invalid do
      name nil
    end

  end

end
