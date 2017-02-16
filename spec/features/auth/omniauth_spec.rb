include Support::OmniauthHelper

feature 'Omniauth', type: :feature do
  scenario 'success sign up' do
    set_omniauth(:facebook)
    visit new_user_registration_path
    find_by_id('facebook_omniauth').click
    omni_message = I18n.t('devise.omniauth_callbacks.success',
                          kind: I18n.t('devise.providers.facebook'))
    expect(page).to have_content(omni_message)
  end

  scenario 'failure sign up' do
    set_invalid_omniauth(:facebook)
    visit new_user_registration_path
    find_by_id('facebook_omniauth').click
    omni_message = I18n.t('devise.omniauth_callbacks.failure',
                          kind: I18n.t('devise.providers.facebook'),
                          reason: 'Invalid crendentials')
    expect(page).to have_content(omni_message)
  end
end
