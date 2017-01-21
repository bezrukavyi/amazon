class Material < ApplicationRecord
  has_and_belongs_to_many :books
  validates :name, length: { maximum: 100 }

  before_update :downcase_name

  private

  def downcase_name
    self.name.downcase!
  end

end
