class OrderDecorator < Draper::Decorator
  delegate_all

  def discount_title
    title = I18n.t('carts.edit.coupon')
    coupon ? "#{title} (#{coupon.discount}%):" : "#{title}:"
  end

  def created_strf
    created_at.strftime("%B, %d, %Y")
  end

end
