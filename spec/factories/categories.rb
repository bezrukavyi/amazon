FactoryGirl.define do

  factory :category do
    title { FFaker::Book.genre }

    trait :invalid do
      title nil
    end

  end

end
