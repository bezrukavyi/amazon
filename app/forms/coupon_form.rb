class CouponForm < Rectify::Form
  attribute :code, String

  validate :exist_coupon
  validate :activated_coupon

  private

  def exist_coupon
    return if code.blank? || !current_coupon.blank?
    errors.add(:code, I18n.t('simple_form.error_notification.not_found.coupon'))
  end

  def activated_coupon
    return if code.blank? || !errors.blank? || current_coupon.try(:active?)
    errors.add(:code, I18n.t('simple_form.error_notification.coupon_used'))
  end

  def current_coupon
    @current_coupon ||= Coupon.find_by_code(code)
  end
end
