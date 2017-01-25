FactoryGirl.define do
  factory :order do
    user

    trait :checkout_package do
      shipping { create :address_order, :shipping }
      billing { create :address_order, :billing }
      delivery
      credit_card
    end

  end
end
