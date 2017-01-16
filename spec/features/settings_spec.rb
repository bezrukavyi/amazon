require 'rails_helper'

RSpec.feature 'Settings', :type => :feature do

  context 'Settings page' do
    let(:billing_attr) { attributes_for :billing_address }
    let(:password) { 'test555' }
    let(:user) { create :user, password: password, password_confirmation: password }
    before do
      create :country
      login_as(user, scope: :user)
    end

    context 'Valid update' do

      scenario 'billing update' do
        visit user_edit_path
        click_link I18n.t('address')
        within '#billing_address' do
          fill_in I18n.t('simple_form.labels.address.first_name'), with: billing_attr[:first_name]
          fill_in I18n.t('simple_form.labels.address.last_name'), with: billing_attr[:last_name]
          fill_in I18n.t('simple_form.labels.address.name'), with: billing_attr[:name]
          fill_in I18n.t('simple_form.labels.address.city'), with: billing_attr[:city]
          fill_in I18n.t('simple_form.labels.address.zip'), with: billing_attr[:zip]
          fill_in I18n.t('simple_form.labels.address.phone'), with: billing_attr[:phone]
          find('#country_id_billing_address').find(:country_id, 'option[2]').select_option
          click_button I18n.t('simple_form.titles.save')
        end
        expect(page).to have_content I18n.t('devise.registrations.updated')
      end

      scenario 'email update' do
        visit user_edit_path
        click_link I18n.t('privacy')
        within '#edit_user_email' do
          fill_in I18n.t('simple_form.labels.user.email'), with: 'rspec1@gmail.com'
          click_button I18n.t('simple_form.titles.save')
        end
        expect(page).to have_content I18n.t('users.success_updated_email')
      end

      scenario 'password update' do
        new_password = 'rspec555'
        visit user_edit_path
        click_link I18n.t('privacy')
        within '#edit_user_password' do
          fill_in I18n.t('simple_form.labels.user.current_password').first, with: password
          fill_in I18n.t('simple_form.labels.user.password'), with: new_password
          fill_in I18n.t('simple_form.labels.user.password_confirmation'), with: new_password
          click_button I18n.t('simple_form.titles.save')
        end
        expect(page).to have_content I18n.t('devise.registrations.updated')
      end

    end

    context 'Invalid update' do

      scenario 'billing update' do
        visit user_edit_path
        click_link I18n.t('address')
        within '#billing_address' do
          fill_in I18n.t('simple_form.labels.address.first_name'), with: ''
          click_button I18n.t('simple_form.titles.save')
        end
        expect(page).to have_content "can't be blank"
      end

      scenario 'email update' do
        visit user_edit_path
        click_link I18n.t('privacy')
        within '#edit_user_email' do
          fill_in I18n.t('simple_form.labels.user.email'), with: ''
          click_button I18n.t('simple_form.titles.save')
        end
        expect(page).to have_content "can't be blank"
      end

      scenario 'password update' do
        new_password = 'rspec555'
        visit user_edit_path
        click_link I18n.t('privacy')
        within '#edit_user_password' do
          fill_in I18n.t('simple_form.labels.user.current_password').first, with: ''
          click_button I18n.t('simple_form.titles.save')
        end
        expect(page).to have_content "can't be blank"
      end

    end

  end

end
