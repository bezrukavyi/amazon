class Coupon < ApplicationRecord
  belongs_to :order, optional: true

  validates :code, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :discount, presence: true
  validates :discount, numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 100 }

  def active?
    order.blank?
  end
end
