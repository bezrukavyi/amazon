class Country < ApplicationRecord
  validates :name, :code, presence: true

  has_many :deliveries
end
