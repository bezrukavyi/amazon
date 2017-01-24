class Category < ApplicationRecord
  has_many :books, dependent: :destroy
  has_many :authors, through: :books

  validates :title, presence: true, uniqueness: true, length: { maximum: 50 }
end
