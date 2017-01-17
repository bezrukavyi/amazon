class Book < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :authors

  SORT_TYPES = [:newest, :low_price, :hight_price]

  default_scope { newest }

  scope :with_category, -> (term) do
    joins(:category).where("lower(categories.title) like '#{term.downcase}'")
  end
  scope :newest, -> { order('created_at DESC') }
  scope :low_price, -> { order('price ASC') }
  scope :hight_price, -> { order('price DESC') }

  validates :title, :price, :count, presence: true

  def self.sorted_by(type)
    send(type)
  end

end
