include Support::UserAuth

feature 'Sign in', type: :feature do
  scenario 'When user success sign in' do
    user = create :user
    visit new_user_session_path
    sign_in('new_user', email: user.email, password: user.password)
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end

  scenario 'When user fill invalid data' do
    user = create :user
    visit new_user_session_path
    sign_in('new_user', email: nil, password: user.password)
    expect(page).to have_content I18n.t('devise.failure.invalid',
                                        authentication_keys: 'Email')
  end

  scenario 'When user has already signed in' do
    user = create :user
    login_as(user, scope: :user)
    visit new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.already_authenticated')
  end
end
