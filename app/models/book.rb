class Book < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :authors
  has_many :reviews
  has_many :pictures, as: :imageable
  mount_uploader :avatar, ImageUploader

  validates :title, :price, :count, presence: true

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

end
