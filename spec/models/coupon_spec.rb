describe Coupon, type: :model do
  subject { build :coupon }

  context 'associations' do
    it { should belong_to :order }
  end

  context 'validation' do
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_length_of(:code).is_at_most(100) }

    it { should validate_presence_of(:discount) }
    it do
      should validate_numericality_of(:discount).is_greater_than_or_equal_to(0)
    end
    it do
      should validate_numericality_of(:discount).is_less_than_or_equal_to(100)
    end
  end
end
