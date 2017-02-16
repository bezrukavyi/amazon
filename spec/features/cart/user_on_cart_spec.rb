include Support::CheckAttributes

feature 'User on cart', type: :feature do
  let(:user) { create :user }
  let(:empty_order) { create :order, user: user }
  let(:full_order) { create :order, :with_items, user: user }
  let(:items) { full_order.order_items }
  let(:books) { items.map(&:book) }

  scenario 'When user have order items' do
    allow_any_instance_of(CartsController).to receive(:current_order)
      .and_return(full_order)
    visit edit_cart_path
    expect(page).to have_content(I18n.t('carts.edit.title'))
    expect(page).to have_no_content(I18n.t('carts.edit.empty_message'))
    check_title(books)
    check_price(books)
    check_price(items, :sub_total)
    check_title(items, :quantity)
    check_price(full_order, :sub_total)
    check_price(full_order, :sub_total)
  end

  scenario 'When user have empty cart' do
    allow_any_instance_of(CartsController).to receive(:current_order)
      .and_return(empty_order)
    visit edit_cart_path
    expect(page).to have_content(I18n.t('carts.edit.empty_message'))
    expect(page).not_to have_content(I18n.t('carts.edit.update_cart'))
  end
end
