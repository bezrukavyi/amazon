FactoryGirl.define do
  factory :credit_card do
    order nil
    number "MyString"
    cvv "MyString"
    first_name "MyString"
    last_name "MyString"
    month 1
    year 1
  end
end
