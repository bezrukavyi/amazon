class Book < ApplicationRecord
  mount_uploader :avatar, ImageUploader

  DIMENSION = %w(h w d).freeze

  belongs_to :category, counter_cache: true
  has_one :inventory, as: :productable, class_name: 'Corzinus::Inventory'
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :materials
  has_many :pictures, as: :imageable
  has_many :reviews, -> { where state: 'approved' }
  has_many :order_items, class_name: 'Corzinus::OrderItem', as: :productable
  has_many :orders, through: :order_items

  validates_associated :authors
  validates :title, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  validate :access_dimension

  SORT_TYPES = [:asc_title, :desc_title, :newest, :low_price, :hight_price,
                :popular].freeze

  scope :sorted_by, ->(type) { type.present? ? send(type) : asc_title }
  scope :asc_title, -> { order(title: :asc) }
  scope :desc_title, -> { order(title: :desc) }
  scope :newest, -> { order(created_at: :desc) }
  scope :low_price, -> { order(price: :asc) }
  scope :hight_price, -> { order(price: :desc) }
  scope :with_authors, -> { includes(:authors) }
  scope :best_sellers, -> { popular.limit(4) }

  def self.full_joins
    joins(:authors, :pictures, :materials, reviews: :user)
  end

  def self.with_category(term)
    joins(:category).where('lower(categories.title) = ?', term.downcase)
  end

  def self.popular
    joins(:orders)
      .where('corzinus_orders.state' => 'delivered')
      .group('corzinus_order_items.productable_id', 'books.id')
      .order('SUM(corzinus_order_items.quantity) desc')
      .limit(4)
  end

  def in_stock?
    return false if inventory.blank?
    inventory.count.positive?
  end

  private

  def access_dimension
    dimension.each do |key, _|
      next if DIMENSION.include?(key)
      errors.add(:dimension, "not support #{key}")
    end
  end
end
