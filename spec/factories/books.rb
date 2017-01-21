FactoryGirl.define do
  factory :book do
    title { FFaker::Book.title }
    desc { FFaker::Book.description }
    price 100.00
    count 200
    category { build(:category) }
    authors { [build(:author), build(:author)] }
    dimension { { "h": 10.2,"w": 10.2,"d": 10.1 } }
  end

  factory :invalid_book, parent: :book do
    title nil
  end

end
