class Picture < ApplicationRecord
  belongs_to :book, optional: true
  mount_uploader :path, ImageUploader
end
