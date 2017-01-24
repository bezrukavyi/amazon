require 'rails_helper'

RSpec.describe Review, type: :model do

  subject { build :review }

  context 'associations' do
    it { should belong_to(:book) }
    it { should belong_to(:user) }
  end

  context 'scopes' do

    before do
      @first_review = create :review, approved: false
      @second_review = create :review, approved: true
      @third_review = create :review, approved: true
    end

    it '.not_approved' do
      expect(Review.not_approved).to eq([@first_review])
    end

    it '.approved' do
      expect(Review.approved).to eq([@second_review, @third_review])
    end
  end
end
