include Support::UserSettings

feature 'Update privacy', type: :feature do
  let(:user) do
    password = 'Rspec2222'
    create :user, password: password, password_confirmation: password
  end

  background do
    login_as(user, scope: :user)
    visit edit_user_path
    click_link I18n.t('privacy')
  end

  scenario 'User fill valid data' do
    fill_email('edit_user_data', attributes_for(:user))
    expect(page).to have_content I18n.t('flash.success.privacy_update')
  end

  scenario 'User fill invalid data' do
    fill_email('edit_user_data', attributes_for(:user, email: nil))
    expect(page).to have_content I18n.t('flash.failure.privacy_update')
  end

  scenario 'User fill valid password data' do
    new_password = 'Rspec3333'
    fill_password('edit_user_password', password: 'Rspec2222',
                                        new_password: new_password)
    expect(page).to have_content I18n.t('flash.success.privacy_update')
  end

  scenario 'User fill invalid password data' do
    new_password = 'Rspec3333'
    fill_password('edit_user_password', new_password: new_password)
    expect(page).to have_content I18n.t('flash.failure.privacy_update')
  end
end
