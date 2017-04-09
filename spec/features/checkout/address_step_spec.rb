include Support::Address

feature 'Address step', type: :feature do
  let(:billing) { create :address_user, :billing }
  let(:user) { billing.addressable }
  let(:order) { create :order, :with_items, user: user }
  let(:shipping_attrs) { attributes_for :address_user, :shipping }

  background do
    @delivery = create :delivery
    allow_any_instance_of(CheckoutsController)
      .to receive(:current_order).and_return(order)
    login_as(user, scope: :user)
  end

  scenario 'When user not fill shipping address' do
    visit checkout_path(id: :address)
    click_button I18n.t('simple_form.titles.save_and_continue')
    expect(page).to have_content(I18n.t('errors.messages.blank'))
  end

  scenario 'When user have billing address', js: true do
    visit checkout_path(id: :address)
    check_address_fields(user.billing)
    fill_address('shipping_address', shipping_attrs, false)
    click_button I18n.t('simple_form.titles.save_and_continue')
    expect(current_path).to eq checkout_path(id: :delivery)
  end

  scenario 'When user want use billing address as base' do
    visit checkout_path(id: :address)
    first('label', text: I18n.t('checkouts.address.use_base_address')).click
    click_button I18n.t('simple_form.titles.save_and_continue')
    expect(current_path).to eq checkout_path(id: :delivery)
    visit checkout_path(id: :address)
    expect(find('#use_base_address', visible: false)).to be_checked
  end
end
