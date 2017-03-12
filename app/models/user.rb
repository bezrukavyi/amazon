class User < ApplicationRecord
  include Corzinus::Relatable::Address
  include Corzinus::Relatable::Order

  attr_accessor :skip_password_validation

  mount_uploader :avatar, ImageUploader

  has_many :providers, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_addresses
  has_orders

  validates :first_name, :last_name, length: { maximum: 50 }, human_name: :one
  validates :email, length: { maximum: 63 }, presence: true, human_email: true
  validates :password, human_password: true, if: :password_required?

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :confirmable

  def password?
    encrypted_password.present?
  end

  def password_required?
    return false if skip_password_validation
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
