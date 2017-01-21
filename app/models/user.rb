class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable

  has_many :providers, dependent: :destroy
  has_many :reviews
  mount_uploader :avatar, ImageUploader

  validates :first_name, :last_name, length: { maximum: 50 }
  validates :email, length: { maximum: 63 }

  include AddressableRelation
  Address.address_types.keys.each do |type|
    has_address type
    accepts_nested_attributes_for type
  end

end
