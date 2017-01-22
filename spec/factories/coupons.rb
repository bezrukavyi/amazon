FactoryGirl.define do
  factory :coupon do
    active true
    code { rand(100000).to_s }
    discount 25
  end

  factory :used_coupon, parent: :coupon do
    active false
  end
end
