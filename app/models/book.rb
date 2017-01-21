class Book < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :materials
  has_many :reviews
  has_many :pictures, as: :imageable
  mount_uploader :avatar, ImageUploader

  validates :title, :price, :count, presence: true
  validates_associated :authors
  validate :access_dimension

  SORT_TYPES = [:newest, :low_price, :hight_price]

  scope :with_category, -> (term) do
    joins(:category).where("lower(categories.title) like '#{term.downcase}'")
  end

  scope :newest, -> { order(created_at: :desc) }
  scope :low_price, -> { order(price: :asc) }
  scope :hight_price, -> { order(price: :desc) }

  def self.sorted_by(type)
    send(type)
  end

  private

  def access_dimension
    valid_dimension = ['h', 'w', 'd']
    dimension.each do |key, value|
      errors.add(:dimension, "not support #{key}") unless valid_dimension.include?(key)
    end
  end

end
