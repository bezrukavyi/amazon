include Support::UserAuth

feature 'Sign up', type: :feature do
  scenario "User haven't account" do
    visit new_user_registration_path
    user_attrs = attributes_for(:user)
    sign_up 'new_user', user_attrs
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
    get_confirm_email(user_attrs[:email])
    expect(page).to have_content I18n.t('devise.confirmations.confirmed')
  end

  scenario 'User fill taken email' do
    user = create :user
    visit new_user_registration_path
    sign_up 'new_user', attributes_for(:user, email: user.email)
    expect(page).to have_content I18n.t('errors.messages.taken')
  end

  scenario 'User has already signed up' do
    visit new_user_registration_path
    sign_up 'new_user', attributes_for(:user)
    visit new_user_registration_path
    expect(page)
      .to have_content I18n.t('devise.failure.already_authenticated')
  end
end
