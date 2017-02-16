include Support::UserAuth

feature 'Checkout login', type: :feature do
  background do
    order = create :order, :with_items
    allow_any_instance_of(CheckoutsController)
      .to receive(:current_order).and_return(order)
  end

  scenario 'When user authenticated' do
    user = create :user
    login_as(user, scope: :user)
    visit checkout_path(id: :address)
    expect(current_path).not_to eq(sign_up_path(type: :fast))
  end

  scenario 'When user choose quik regist' do
    email = FFaker::Internet.email
    visit checkout_path(id: :address)
    expect(page).to have_content I18n.t('users.fast_auth.quik_regist.message')
    fast_auth('quik_regist', email)
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
    expect(current_path).to eq checkout_path(id: :address)
    get_confirm_email(email)
    confirm_account_by_password('edit_user', 'Rspec2222')
    expect(page).to have_content I18n.t('devise.confirmations.confirmed')
  end

  scenario 'When user choose quik regist and write taken email' do
    user = create :user
    visit checkout_path(id: :address)
    fast_auth('quik_regist', user.email)
    expect(page).to have_content I18n.t('errors.messages.taken')
  end

  scenario 'When user choose log_in' do
    user = create :user
    visit checkout_path(id: :address)
    expect(page).to have_content I18n.t('users.fast_auth.login_message')
    sign_in('new_user', email: user.email, password: user.password) do
      click_button I18n.t('users.fast_auth.continue_button')
    end
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
    expect(current_path).to eq checkout_path(id: :address)
  end
end
