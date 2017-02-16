FactoryGirl.define do
  factory :order do
    user

    trait :with_items do
      order_items { create_list(:order_item, 2) }
    end

    trait :checkout_package do
      order_items { create_list(:order_item, 2) }
      coupon
      shipping { create :address_order, :shipping }
      billing { create :address_order, :billing }
      delivery
      credit_card
    end
  end
end
