FactoryGirl.define do
  factory :review do
    title "MyString"
    desc "MyText"
    grade 4
    user_id { create(:user).id }
    book_id { create(:book).id }
  end

  factory :invalid_review, parent: :review do
    title nil
  end
end
