include Support::Order

feature 'User update order item', type: :feature do
  let(:user) { create :user }
  let(:order) { create :order, :with_items, user: user }
  let(:items) { order.order_items }

  before do
    allow_any_instance_of(CartsController)
      .to receive(:current_order).and_return(order)
    visit edit_cart_path
  end

  context 'Success update quantity' do
    scenario 'desktop form' do
      fill_order('update_order', [3, 1])
      expect(page).to have_content(I18n.t('flash.success.cart_update'))
    end
    scenario 'mobile form' do
      fill_order('update_order_mobile', 5)
      expect(page).to have_content(I18n.t('flash.success.cart_update'))
    end
  end

  context 'Failure update quantity' do
    scenario 'desktop form' do
      fill_order('update_order', 1000)
      expect(page).to have_content(I18n.t('flash.failure.cart_update'))
    end
    scenario 'mobile form' do
      fill_order('update_order_mobile', 1000)
      expect(page).to have_content(I18n.t('flash.failure.cart_update'))
    end
  end

  scenario 'Destroy item', js: true do
    delete_link = "//a[@href='/order_items/#{items.first.id}']"
    page.first(:xpath, delete_link).click
    expect(page).to have_content(I18n.t('flash.success.book_destroy',
                                        title: items.first.book.title))
  end
end
