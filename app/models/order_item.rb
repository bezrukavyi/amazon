class OrderItem < ApplicationRecord
  belongs_to :book
  belongs_to :order

  default_scope { order(:created_at) }

  validates_numericality_of :quantity, presence: true,
    greater_than: 0, less_than_or_equal_to: 99

  validate :stock_validate

  def sub_total
    @sub_total ||= quantity * book.price
  end

  def update_amount(amount)
    update(quantity: quantity + amount)
  end

  private
  def stock_validate
    return if !errors.blank? || quantity <= book.count
    errors.add(:quantity, 'You cant add more than we have in stock')
  end

end
