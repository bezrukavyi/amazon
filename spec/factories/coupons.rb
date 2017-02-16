FactoryGirl.define do
  factory :coupon do
    code { rand(1_000_000).to_s }
    discount 25

    trait :used do
      order
    end
  end
end
