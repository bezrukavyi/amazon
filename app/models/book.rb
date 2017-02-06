class Book < ApplicationRecord
  mount_uploader :avatar, ImageUploader

  DIMENSION = ['h', 'w', 'd']

  belongs_to :category, counter_cache: true
  has_many :pictures, as: :imageable
  has_many :reviews, -> { where approved: true }
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :materials

  validates_associated :authors
  validates :title, :price, :count, presence: true
  validates :count, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than: 0 }
  validate :access_dimension

  SORT_TYPES = [:asc_title, :desc_title, :newest, :low_price, :hight_price, :popular]

  scope :sorted_by, -> (type) { type.present? ? send(type) : asc_title }
  scope :asc_title, -> { order(title: :asc) }
  scope :desc_title, -> { order(title: :desc) }
  scope :newest, -> { order(created_at: :desc) }
  scope :low_price, -> { order(price: :asc) }
  scope :hight_price, -> { order(price: :desc) }
  scope :with_authors, -> { includes(:authors) }

  scope :with_category, -> (term) do
    joins(:category).where("lower(categories.title) = ?", term.downcase)
  end

  scope :full_includes, -> do
    with_authors.includes(:pictures, :materials, reviews: :user)
  end

  scope :best_sellers, -> { popular.limit(4) }

  def self.popular
    joins(:orders)
    .where('orders.state': 'delivered')
    .group('order_items.book_id', 'books.id')
    .order('SUM(order_items.quantity) desc')
    .limit(4)
  end

  def in_stock?
    count > 0
  end

  private

  def access_dimension
    dimension.each do |key, value|
      errors.add(:dimension, "not support #{key}") unless DIMENSION.include?(key)
    end
  end

end
