class OrderItem < ApplicationRecord
  belongs_to :book
  belongs_to :order

  validates_numericality_of :quantity, greater_than: 0
end
