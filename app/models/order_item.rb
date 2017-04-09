class OrderItem < ApplicationRecord
  default_scope { order(:created_at) }

  belongs_to :book
  belongs_to :order

  before_validation :destroy_if_empty

  validates :quantity, presence: true,
                       numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 99 }

  validate :stock_validate

  def sub_total
    @sub_total ||= quantity * book.price
  end

  private

  def destroy_if_empty
    destroy if persisted? && quantity.zero?
  end

  def stock_validate
    return if errors.present? || quantity <= book.count
    errors.add(:quantity, I18n.t('validators.order_item.stock'))
  end
end
