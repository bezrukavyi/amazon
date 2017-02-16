include Support::Checkout

feature 'Full steps', type: :feature do
  let(:order) { create :order, :with_items }
  let(:user) { create :user, orders: [order] }
  let(:billing_attrs) { attributes_for :address_user, :billing }
  let(:shipping_attrs) { attributes_for :address_user, :shipping }
  let(:card_attr) { attributes_for :credit_card }

  before do
    @delivery = create :delivery
    allow_any_instance_of(CheckoutsController)
      .to receive(:current_order).and_return(order)
  end

  scenario 'User run all steps', js: true do
    login_as(user, scope: :user)
    visit checkout_path(id: :address)
    fill_address('billing_address', billing_attrs, false)
    fill_address('shipping_address', shipping_attrs, false)
    click_button I18n.t('simple_form.titles.save_and_continue')

    first('label', text: @delivery.name).click
    click_button I18n.t('simple_form.titles.save_and_continue')

    fill_credit_card('credit_card_form', attributes_for(:credit_card), false)
    click_button I18n.t('simple_form.titles.save_and_continue')

    check_confirm_step(order)
    click_button I18n.t('checkouts.confirm.place_order')

    expect(page).to have_content(I18n.t('checkouts.complete.thanks_message'))
    expect(page).to have_content(I18n.t('checkouts.complete.email_confirm',
                                        email: user.email))
    expect(page).to have_content(I18n.t('checkouts.complete.order_id',
                                        id: order.id))
  end
end
