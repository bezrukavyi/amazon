FactoryGirl.define do
  factory :author do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    desc 'Some history'

    trait :invalid do
      first_name nil
    end

  end

end
