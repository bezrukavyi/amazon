FactoryGirl.define do
  factory :book do
    title { FFaker::Book.title }
    desc { FFaker::Book.description }
    price 100.00
    count 200
    category
    authors { create_list :author, 2 }
    dimension { { 'h' => 10.2, 'w' => 10.2, 'd' => 10.1 } }

    trait :invalid do
      title nil
    end
  end
end
