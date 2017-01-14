class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable

  validates :first_name, :last_name, length: { maximum: 50 }
  validates :email, length: { maximum: 63 }

  has_many :providers, dependent: :destroy

  include Addressing
  has_address :billing
  has_address :shipping


end
