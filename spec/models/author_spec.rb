require 'rails_helper'

RSpec.describe Author, type: :model do
  subject { build(:author) }

  context 'validation' do
    it 'when validate' do
      expect(subject).to be_valid
    end
  end

  context 'association' do
    it 'HABM books' do
      expect(subject).to have_and_belong_to_many(:books)
    end
  end
end
