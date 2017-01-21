require 'rails_helper'

RSpec.describe Material, type: :model do

  subject { create :material }

  context 'association' do
    it 'HABM books' do
      expect(subject).to have_and_belong_to_many(:books)
    end
  end
end
