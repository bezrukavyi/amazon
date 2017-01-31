class OrderItem < ApplicationRecord
  default_scope { order(:created_at) }

  belongs_to :book
  belongs_to :order

  validates :quantity, presence: true, numericality: { greater_than: 0,
    less_than_or_equal_to: 99 }
  validate :stock_validate

  def sub_total
    @sub_total ||= quantity * book.price
  end

  private

  def stock_validate
    return if !errors.blank? || quantity <= book.count
    errors.add(:quantity, 'You cant add more than we have in stock')
  end

end
