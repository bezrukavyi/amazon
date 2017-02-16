include Support::Address
include Support::CreditCard
include Support::Delivery

feature 'Show Order', type: :feature do
  let(:user) { create :user }
  let(:order) do
    create(:order, :checkout_package, state: :processing, user: user).decorate
  end
  let(:items) { order.order_items }

  background do
    login_as(user, scope: :user)
    visit order_path(I18n.locale, order.id)
  end

  scenario 'User on page order' do
    check_order_items(order)
    check_price(order, :sub_total)
    check_price(order, :completed_at)
    check_address(order.addresses)
    check_credit_card(order.credit_card)
    check_delivery(order.delivery)
  end

  scenario 'User want go to another order which not belong' do
    another_order = create :order, user: create(:user)
    visit order_path(I18n.locale, another_order.id)
    expect(page).to have_content(I18n.t('flash.failure.order_found'))
  end
end
