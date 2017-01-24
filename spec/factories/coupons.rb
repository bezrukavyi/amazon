FactoryGirl.define do
  factory :coupon do
    active true
    code { rand(100000).to_s }
    discount 25

    trait :used do
      active false
    end

  end

end
