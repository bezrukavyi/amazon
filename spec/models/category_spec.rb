require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build :category }

  context 'association' do
    it { should have_many :books }
    it { should have_many :authors }
  end

  context 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(50) }
    it { should validate_uniqueness_of(:title) }
  end
end
