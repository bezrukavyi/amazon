FactoryGirl.define do
  factory :country do
    name { FFaker::Address.country }
    code '380'
  end
end
