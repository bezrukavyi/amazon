require 'rails_helper'

RSpec.feature 'Settings', :type => :feature do

  let(:billing_attr) { attributes_for :address_user, :billing }
  let(:password) { 'Test77777' }
  let(:user) { create :user, password: password, password_confirmation: password }

  before do
    create :country
    login_as(user, scope: :user)
  end

  context 'Valid update' do

    scenario 'billing update' do
      visit edit_user_path
      click_link I18n.t('address')
      within('form', id: 'billing_address') do
        fill_in I18n.t('simple_form.labels.address.first_name'), with: billing_attr[:first_name]
        fill_in I18n.t('simple_form.labels.address.last_name'), with: billing_attr[:last_name]
        fill_in I18n.t('simple_form.labels.address.name'), with: billing_attr[:name]
        fill_in I18n.t('simple_form.labels.address.city'), with: billing_attr[:city]
        fill_in I18n.t('simple_form.labels.address.zip'), with: billing_attr[:zip]
        fill_in I18n.t('simple_form.labels.address.phone'), with: billing_attr[:phone]
        find('#country_id_billing_address').find(:xpath, 'option[2]').select_option
        click_button I18n.t('simple_form.titles.save')
      end
      expect(page).to have_content  I18n.t('flash.success.address_update')
    end

    scenario 'email update' do
      visit edit_user_path
      click_link I18n.t('privacy')
      within '#edit_user_email' do
        fill_in I18n.t('simple_form.labels.user.email'), with: 'rspec777@gmail.com'
        click_button I18n.t('simple_form.titles.save')
      end
      expect(page).to have_content  I18n.t('flash.success.user_update')
    end

    scenario 'password update' do
      new_password = 'Rspec5555'
      visit edit_user_path
      click_link I18n.t('privacy')
      within '#edit_user_password' do
        fill_in I18n.t('simple_form.labels.user.current_password').first, with: password
        fill_in I18n.t('simple_form.labels.user.password'), with: new_password
        fill_in I18n.t('simple_form.labels.user.password_confirmation'), with: new_password
        click_button I18n.t('simple_form.titles.save')
      end
      expect(page).to have_content I18n.t('flash.success.user_update')
    end

  end

  context 'Invalid update' do

    scenario 'billing update' do
      visit edit_user_path
      click_link I18n.t('address')
      within('form', id: 'billing_address') do
        fill_in I18n.t('simple_form.labels.address.first_name'), with: nil
        click_button I18n.t('simple_form.titles.save')
      end
      expect(page).to have_content I18n.t('flash.failure.address_update')
      expect(page).to have_content I18n.t('errors.messages.blank')
    end

    scenario 'email update' do
      visit edit_user_path
      click_link I18n.t('privacy')
      within '#edit_user_email' do
        fill_in I18n.t('simple_form.labels.user.email'), with: nil
        click_button I18n.t('simple_form.titles.save')
      end
      expect(page).to have_content I18n.t('flash.failure.user_update')
      expect(page).to have_content I18n.t('errors.messages.blank')
    end

    scenario 'password update' do
      new_password = 'rspec555'
      visit edit_user_path
      click_link I18n.t('privacy')
      within '#edit_user_password' do
        fill_in I18n.t('simple_form.labels.user.current_password').first, with: nil
        click_button I18n.t('simple_form.titles.save')
      end
      expect(page).to have_content I18n.t('flash.failure.user_update')
      expect(page).to have_content I18n.t('errors.messages.blank')
    end

  end


end
