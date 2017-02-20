include Support::Order

feature 'User update coupon', type: :feature do
  let(:user) { create :user }
  let(:order) { create :order, :with_items, user: user }
  let(:coupon) { create :coupon }

  before do
    allow_any_instance_of(CartsController)
      .to receive(:current_order).and_return(order)
    visit edit_cart_path
  end

  scenario 'User fill with valid code' do
    fill_coupon('update_order', coupon.code)
    expect(page).to have_content(I18n.t('flash.success.cart_update'))
    coupon_title = "#{I18n.t('carts.edit.coupon')} (#{coupon.discount}%):"
    expect(page).to have_no_content(coupon.code)
    expect(page).to have_content(coupon_title)
  end

  scenario 'User fill with invalid code' do
    code = 'Code10101'
    fill_coupon('update_order', code)
    expect(page).to have_content(I18n.t('flash.failure.cart_update'))
    expect(first('#order_coupon_code').value).to eq(code)
    not_found = I18n.t('simple_form.error_notification.not_found.coupon')
    expect(page).to have_content(not_found)
  end
end
