FactoryGirl.define do
  factory :review do
    title "MyString"
    desc "MyText"
    grade 4
    user_id { create(:user).id }
    book_id { create(:book).id }

    trait :invalid do
      title nil
    end
  end

end
