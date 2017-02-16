include Support::UserSettings

feature 'Destroy account', type: :feature do
  let(:user) { create :user }

  background do
    login_as(user, scope: :user)
    visit edit_user_path
    click_link I18n.t('privacy')
  end

  scenario 'User remove account with confirm' do
    destroy_account('destroy_account', true)
    expect(page).to have_content I18n.t('devise.registrations.destroyed')
  end

  scenario 'User remove account without confirm' do
    destroy_account('destroy_account')
    expect(page).to have_content I18n.t('flash.failure.confirm_intentions')
  end
end
