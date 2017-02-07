module AddressableRelation
  extend ActiveSupport::Concern

  module ClassMethods

    def has_address(address_type)
      has_one :"#{address_type}", -> { where(address_type: address_type) },
        class_name: Address, as: :addressable, dependent: :destroy
      accepts_nested_attributes_for address_type
    end
  end
end
