include Support::Order
include Support::CheckAttributes

feature 'Filter orders', type: :feature, js: true do
  let(:user) { create :user }

  background do
    @delivered_order = create(:order, :with_items, state: :delivered,
                                                   user: user).decorate
    @processing_order = create(:order, :with_items, state: :processing,
                                                    user: user).decorate
    login_as(user, scope: :user)
    visit orders_path
  end

  scenario 'User choose state of orders that exist' do
    state = I18n.t("orders.index.states.#{@delivered_order.state}")
    another_state = I18n.t("orders.index.states.#{@processing_order.state}")
    choose_state(state)
    expect(page).to have_content(state)
    check_title(@delivered_order, :id)
    check_title(@delivered_order, :completed_at)
    check_price(@delivered_order, :total_price)

    expect(page).to have_no_content(another_state)
  end

  scenario 'User choose state of orders that not exist' do
    state = I18n.t('orders.index.states.in_transit')
    choose_state(state)
    expect(page).to have_content(state)
    orders = user.orders.decorate
    check_title(@delivered_order, :completed_at, false)
    check_price(orders, :total_price, false)
  end

  scenario 'User choose all states' do
    state = I18n.t('orders.index.states.all')
    choose_state(state)
    expect(page).to have_content(state)
    orders = user.orders.decorate
    check_title(@delivered_order, :completed_at)
    check_price(orders, :total_price)
  end
end
