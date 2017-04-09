include Support::Address

feature 'Update Address', type: :feature do
  let(:user) { create :user }
  let(:billing_attr) { attributes_for :address_user, :billing }

  background do
    create_list :country, 3
    login_as(user, scope: :user)
  end

  scenario 'User fill valid billing data' do
    visit edit_user_path
    click_link I18n.t('address')
    fill_address('billing_address', attributes_for(:address_user, :billing))
    expect(page).to have_content I18n.t('flash.success.address_update')
  end

  scenario 'User fill invalid billing data' do
    visit edit_user_path
    click_link I18n.t('address')
    fill_address('billing_address', attributes_for(:address_user, :shipping))
    expect(page).to have_content I18n.t('flash.success.address_update')
  end

  scenario 'User fill invalid data' do
    visit edit_user_path
    click_link I18n.t('address')
    fill_address('shipping_address', attributes_for(:address_user, :invalid))
    expect(page).to have_content I18n.t('flash.failure.address_update')
  end
end
