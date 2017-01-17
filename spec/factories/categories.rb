FactoryGirl.define do
  factory :category do
    title { FFaker::Book.genre }
  end
  factory :invalid_category, parent: :category do
    title nil
  end
end
