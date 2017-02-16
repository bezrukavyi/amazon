include ActionView::Helpers::NumberHelper

feature 'Orders', type: :feature do
  let(:user) { create :user }

  before do
    @delivered_order = create :order, :with_items, state: :delivered, user: user
    @processing_order = create :order, :with_items, state: :processing, user: user
    login_as(user, scope: :user)
    visit orders_path
  end

  scenario 'default page' do
    [@delivered_order, @processing_order].each do |order|
      expect(page).to have_content(order.id)
      expect(page).to have_content(I18n.t("orders.index.states.#{order.state}"))
      expect(page).to have_content(order.decorate.completed_at)
      price = number_to_currency order.total_price, locale: :eu
      expect(page).to have_content(price)
    end
  end

end
