class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  scope :not_approved, -> { where(approved: false) }
  scope :approved, -> { where(approved: true) }

end
