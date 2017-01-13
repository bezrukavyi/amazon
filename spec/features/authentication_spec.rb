require 'rails_helper'

RSpec.feature 'Authentication', :type => :feature do

  let(:user) { create :user }

  context 'Sign up' do

    scenario 'when user not exist' do
      visit new_user_registration_path
      within '#new_user' do
        fill_in 'Email', with: FFaker::Internet.email
        fill_in 'Password', with: '12345678'
        fill_in 'Password confirmation', with: '12345678'
        click_button 'Sign up'
      end
      expect(page).to have_content I18n.t('devise.registrations.signed_up')
    end

    scenario 'when user has already signed up' do
      visit new_user_registration_path
      login_as(user, scope: :user)
      within '#new_user' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: user.password
        click_button 'Sign up'
      end
      expect(page).to have_content I18n.t('devise.failure.already_authenticated')
    end

    context 'Omniauth' do

      scenario 'success sign up' do
        set_omniauth(:facebook)
        visit new_user_registration_path
        find_by_id('facebook_omniauth').click
        expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'facebook')
      end

      scenario 'failure sign up' do
        set_invalid_omniauth(:facebook)
        visit new_user_registration_path
        find_by_id('facebook_omniauth').click
        expect(page).to have_content I18n.t('devise.omniauth_callbacks.failure', kind: 'Facebook', reason: 'Invalid crendentials')
      end
    end

  end

  context 'Log in' do

    scenario 'when user not exist' do
      visit new_user_session_path
      within '#new_user' do
        fill_in 'Email', with: FFaker::Internet.email
        fill_in 'Password', with: '12345678'
        click_button 'Log in'
      end
      expect(page).to have_content I18n.t('devise.failure.invalid', authentication_keys: 'Email')
    end

    scenario 'when user not singed in' do
      visit new_user_session_path
      within '#new_user' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
      end
      expect(page).to have_content I18n.t('devise.sessions.signed_in')
    end

    scenario 'when user has already signed in' do
      visit new_user_session_path
      login_as(user, scope: :user)
      within '#new_user' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
      end
      expect(page).to have_content I18n.t('devise.failure.already_authenticated')
    end

  end

end
