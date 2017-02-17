include Support::Order

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
    check_order_info(order)
  end

  scenario 'User want go to another order which not belong' do
    another_order = create :order, user: create(:user)
    visit order_path(I18n.locale, another_order.id)
    expect(page).to have_content(I18n.t('flash.failure.order_found'))
  end
end
