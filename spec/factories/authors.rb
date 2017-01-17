FactoryGirl.define do
  factory :author do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    desc 'Some history'
  end

  factory :invalid_author, parent: :author do
    first_name nil
  end
end
