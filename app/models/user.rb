class User < ApplicationRecord
  include AddressableRelation

  mount_uploader :avatar, ImageUploader

  has_many :providers, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :first_name, :last_name, length: { maximum: 50 }, human_name: :one
  validates :email, length: { maximum: 63 }, human_email: true

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :omniauthable

  Address::TYPES.each do |type|
    has_address type
    accepts_nested_attributes_for type
  end

  def order_in_processing
    @order_in_processing ||= orders.processing.last || orders.create
  end

  def complete_order
    @complete_order ||= orders.in_progress.last
  end

  def purchase(book_id)
    orders.delivered.joins(:order_items).where('order_items.book_id = ?', book_id)
  end

  def buy_book?(book_id)
    purchase(book_id).any?
  end

end
