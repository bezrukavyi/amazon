class Delivery < ApplicationRecord
  has_many :orders
  belongs_to :country

  validates :min_days, :max_days, :name, :price, presence: true
  validates :min_days, :max_days, numericality: { greater_than: 0 }
  validates_uniqueness_of :name, scope: :country
  validate :access_max_days

  private

  def access_max_days
    if min_days > max_days
      errors.add(:min_days, 'cant be greater than max days')
    end
  end
end
