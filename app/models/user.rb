class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable

  has_many :providers, dependent: :destroy
  has_many :reviews
  has_many :orders
  has_one :credit_card
  mount_uploader :avatar, ImageUploader

  validates :first_name, :last_name, length: { maximum: 50 }
  validates :email, length: { maximum: 63 }

  include AddressableRelation
  Address::TYPES.each do |type|
    has_address type
    accepts_nested_attributes_for type
  end

  def order_in_processing
    orders.processing.first || orders.create
  end

  def complete_order
    @complete_order ||= orders.in_progress.last
  end

end
