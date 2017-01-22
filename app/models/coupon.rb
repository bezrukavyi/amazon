class Coupon < ApplicationRecord
  belongs_to :order, optional: true

  validates :code, presence: true, length: { maximum: 100 }
  validates_numericality_of :discount, presence: true,
    greater_than_or_equal_to: 0, less_than_or_equal_to: 100
end
