class CouponForm < Rectify::Form
  attribute :code, String

  validate :exist_coupon
  validate :activated_coupon

  def valid?(order = nil)
    super
    check_order(order) if order.present?
    errors.empty?
  end

  private

  def exist_coupon
    return if code.blank? || !current_coupon.blank?
    errors.add(:code, I18n.t('validators.coupon.not_found'))
  end

  def activated_coupon
    return if code.blank? || !errors.blank? || current_coupon.try(:active?)
    errors.add(:code, I18n.t('validators.coupon.used'))
  end

  def check_order(order)
    return if code.blank? || order.coupon.blank?
    errors.add(:code, I18n.t('validators.coupon.check_order'))
  end

  def current_coupon
    @current_coupon ||= Coupon.find_by_code(code)
  end
end
