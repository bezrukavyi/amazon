require 'rails_helper'

RSpec.describe Book, type: :model do

  subject { create(:book) }

  context 'validation' do
    it 'when validate' do
      expect(subject).to be_valid
    end
  end

  context 'association' do
    it 'HABM authors' do
      expect(subject).to have_and_belong_to_many(:authors)
    end
    it 'belong to category' do
      expect(subject).to belong_to(:category)
    end
  end

end
