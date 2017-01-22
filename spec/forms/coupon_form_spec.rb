require 'rails_helper'

RSpec.describe CouponForm, :address_form do

  let(:coupon) { create :coupon }
  subject { CouponForm.from_model coupon }

  context 'validation' do
    it 'valid object' do
      is_expected.to be_valid
    end
    it 'lower validate if code not exist' do
      subject.code = ''
      is_expected.to be_valid
    end
    it '#exist_coupon' do
      subject.code = 'Test'
      is_expected.not_to be_valid
    end
    it '#exist_coupon' do
      used_coupon = create :used_coupon
      coupon_form = CouponForm.from_model used_coupon
      expect(coupon_form.valid?).to be_falsey
    end
  end

end
