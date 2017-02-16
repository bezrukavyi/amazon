include Support::UserSettings

feature 'Update privacy', type: :feature do
  let(:user) { create :user }

  background do
    login_as(user, scope: :user)
    visit edit_user_path
    click_link I18n.t('privacy')
  end

  scenario 'User fill valid data' do
    fill_user_data('edit_user_data', attributes_for(:user))
    expect(page).to have_content I18n.t('flash.success.privacy_update')
  end

  scenario 'User fill invalid data' do
    fill_user_data('edit_user_data', attributes_for(:user, email: nil))
    expect(page).to have_content I18n.t('flash.failure.privacy_update')
  end

  scenario 'User fill valid password data' do
    new_password = 'Rspec3333'
    fill_password('edit_user_password', password: user.password,
                                        new_password: new_password)
    expect(page).to have_content I18n.t('flash.success.privacy_update')
  end

  scenario 'User fill invalid password data' do
    new_password = 'Rspec3333'
    fill_password('edit_user_password', new_password: new_password)
    expect(page).to have_content I18n.t('flash.failure.privacy_update')
  end
end
