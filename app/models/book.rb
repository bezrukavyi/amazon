class Book < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :authors

  def self.range_price(verges)
    verges = verges.count <= 1 ? [0, verges.first] : verges
    where('price >= ? AND price <= ?', verges.first, verges.last)
  end

  validates :title, :price, :count, presence: true
end
