FactoryGirl.define do

  factory :address do
    first_name 'Ivan'
    last_name 'Ivan'
    name FFaker::Address.street_name
    city 'Dnepr'
    zip 49000
    phone '+380632863823'
    country_id { create(:country).id }
  end

  factory :address_user, parent: :address do
    addressable { create :user }

    trait :shipping do
      address_type :shipping
    end

    trait :billing do
      address_type :billing
    end

    trait :invalid do
      first_name nil
      address_type :billing
    end
  end

  factory :address_order, parent: :address_user do
    addressable { create :order }
  end


end
