class CouponForm < Rectify::Form

  STRING_ATTRS = [:title, :desc]
  INTEGER_ATTRS = [:grade, :book_id, :user_id]

  attribute :code, String

  validate :exist_coupon
  validate :activated_coupon

  private

  def exist_coupon
    return if code.blank? || !current_coupon.blank?
    errors.add(:code, 'Not found this coupon')
  end

  def activated_coupon
    return if code.blank? || !errors.blank? || current_coupon.try(:active?)
    errors.add(:code, 'This coupon was used')
  end

  private

  def current_coupon
    @current_coupon ||= Coupon.find_by_code(code)
  end

end
