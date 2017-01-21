class Book < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :materials
  has_many :reviews
  has_many :pictures, as: :imageable
  mount_uploader :avatar, ImageUploader

  validates_associated :authors
  validates :title, :price, :count, presence: true
  validates_numericality_of :count, greater_than_or_equal_to: 0
  validates_numericality_of :price, greater_than: 0

  validate :access_dimension

  SORT_TYPES = [:asc_title, :desc_title, :newest, :low_price, :hight_price]

  scope :with_category, -> (term) do
    joins(:category).where("lower(categories.title) like '#{term.downcase}'")
  end

  scope :asc_title, -> { order(title: :asc) }
  scope :desc_title, -> { order(title: :desc) }
  scope :newest, -> { order(created_at: :desc) }
  scope :low_price, -> { order(price: :asc) }
  scope :hight_price, -> { order(price: :desc) }

  def self.sorted_by(type)
    send(type)
  end

  def in_stock?
    count > 0
  end

  private

  def access_dimension
    valid_dimension = ['h', 'w', 'd']
    dimension.each do |key, value|
      errors.add(:dimension, "not support #{key}") unless valid_dimension.include?(key)
    end
  end

end
