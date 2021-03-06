class User < ApplicationRecord
  include AddressableRelation

  attr_accessor :skip_password_validation

  mount_uploader :avatar, ImageUploader

  has_many :providers, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :orders, dependent: :nullify

  Address::TYPES.each { |type| has_address type }

  validates :first_name, :last_name, length: { maximum: 50 }, human_name: :one
  validates :email, length: { maximum: 63 }, presence: true, human_email: true
  validates :password, human_password: true, if: :password_required?

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :confirmable

  def order_in_processing
    @order_in_processing ||= orders.processing.last || orders.create
  end

  def complete_order
    @complete_order ||= orders.in_progress.last
  end

  def purchase(book_id)
    orders.delivered.joins(:order_items).where('order_items.book_id = ?',
                                               book_id)
  end

  def bought_book?(book_id)
    purchase(book_id).any?
  end

  def password?
    encrypted_password.present?
  end

  def password_required?
    return false if skip_password_validation
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
