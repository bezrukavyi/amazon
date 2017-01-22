require 'rails_helper'

RSpec.describe CreditCard, type: :model do

  subject { create(:credit_card) }

  context 'association' do
    it 'belongs to user' do
      expect(subject).to belong_to(:user)
    end
  end
end
