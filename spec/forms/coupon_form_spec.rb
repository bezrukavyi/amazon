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
      subject.valid?
      expect(subject.errors.full_messages).to include('Code ' + I18n.t('simple_form.error_notification.not_found.coupon'))
    end
    it '#activated_coupon' do
      used_coupon = create :coupon, :used
      coupon_form = CouponForm.from_model used_coupon
      coupon_form.valid?
      expect(coupon_form.errors.full_messages).to include('Code ' + I18n.t('simple_form.error_notification.coupon_used'))
    end
  end

end
