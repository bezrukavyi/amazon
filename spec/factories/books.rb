FactoryGirl.define do
  factory :book do
    title { FFaker::Book.title }
    desc { FFaker::Book.description }
    price 100.00
    count 200
    category { build(:category) }
    authors { [build(:author), build(:author)] }
  end

  factory :invalid_book, parent: :book do
    title nil
  end
end
