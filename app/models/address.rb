class Address < ApplicationRecord
  enum address_type: [:billing, :shipping]

  belongs_to :addressable, polymorphic: true
  belongs_to :country
end
