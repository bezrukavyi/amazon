include Support::UserAuth

feature 'Forgot password?', type: :feature do
  let(:user) { create :user }
  background do
    visit new_user_session_path
    click_link I18n.t('simple_form.titles.forgot_password?')
  end

  scenario 'User fill email' do
    email_instruct('new_user', user.email)
    expect(page).to have_content I18n.t('devise.passwords.send_instructions')
  end

  scenario 'User fill invalid email' do
    email_instruct('new_user', attributes_for(:user)[:email])
    expect(page).to have_content I18n.t('errors.messages.not_found')
  end

  scenario 'Reset password' do
    email_instruct('new_user', user.email)
    open_email(user.email)
    current_email.click_link 'Change my password'
    reset_password('new_user', attributes_for(:user)[:password])
    expect(page).to have_content I18n.t('devise.passwords.updated')
  end
end
