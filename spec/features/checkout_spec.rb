require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature 'Checkout', :type => :feature do

  let(:coupon) { create :coupon }
  let(:order) { create :order, :with_items, coupon: coupon }
  let(:user) { create :user, orders: [order] }
  let(:billing_attr) { attributes_for :address_user, :billing }
  let(:card_attr) { attributes_for :credit_card }

  before do
    @delivery = create :delivery
    allow_any_instance_of(CheckoutsController)
    .to receive(:current_order).and_return(order)
  end

  context 'checkout fill', js: true do
    before do
      login_as(user, scope: :user)
    end
    scenario 'all steps' do
      visit checkout_path(id: :address)
      within('div', id: 'billing_address') do
        fill_in I18n.t('simple_form.labels.address.first_name'), with: billing_attr[:first_name]
        fill_in I18n.t('simple_form.labels.address.last_name'), with: billing_attr[:last_name]
        fill_in I18n.t('simple_form.labels.address.name'), with: billing_attr[:name]
        fill_in I18n.t('simple_form.labels.address.city'), with: billing_attr[:city]
        fill_in I18n.t('simple_form.labels.address.zip'), with: billing_attr[:zip]
        fill_in I18n.t('simple_form.labels.address.phone'), with: billing_attr[:phone]
        find('#country_id_billing_address').find(:xpath, 'option[2]').select_option
      end
      first('label', text: I18n.t('checkouts.address.use_billing')).click
      click_button I18n.t('simple_form.titles.save_and_continue')


      first('label', text: @delivery.name).click
      click_button I18n.t('simple_form.titles.save_and_continue')

      within '#credit_card_form' do
        fill_in I18n.t('simple_form.labels.credit_card.number'), with: card_attr[:number]
        fill_in I18n.t('simple_form.labels.credit_card.name'), with: card_attr[:name]
        fill_in I18n.t('simple_form.labels.credit_card.month_year'), with: card_attr[:month_year]
        fill_in I18n.t('simple_form.labels.credit_card.cvv'), with: card_attr[:cvv]
      end
      click_button I18n.t('simple_form.titles.save_and_continue')

      click_button I18n.t('checkouts.confirm.place_order')

      expect(page).to have_content(I18n.t('checkouts.complete.thanks_message'))
      expect(page).to have_content(I18n.t('checkouts.complete.email_confirm', email: user.email))
      expect(page).to have_content(I18n.t('checkouts.complete.order_id', id: order.id))

    end
  end

  scenario 'When user have billing address' do
    address = create :address_user, :billing
    user = address.addressable
    order = create :order, :with_items, user: user
    allow_any_instance_of(CheckoutsController).to receive(:current_order).and_return(order)
    login_as(user, scope: :user)
    visit checkout_path(id: :address)
    within('div', id: 'billing_address') do
      expect(find_field(I18n.t('simple_form.labels.address.first_name')).value).to eq(address.first_name)
      expect(find_field(I18n.t('simple_form.labels.address.last_name')).value).to eq(address.last_name)
      expect(find_field(I18n.t('simple_form.labels.address.name')).value).to eq(address.name)
      expect(find_field(I18n.t('simple_form.labels.address.city')).value).to eq(address.city)
      expect(find_field(I18n.t('simple_form.labels.address.zip')).value).to eq(address.zip)
      expect(find_field(I18n.t('simple_form.labels.address.phone')).value).to eq(address.phone)
    end
    first('label', text: I18n.t('checkouts.address.use_billing')).click
    click_button I18n.t('simple_form.titles.save_and_continue')

    expect(current_path).to eq checkout_path(id: :delivery)
  end

  context 'Checkout login' do
    scenario 'quik regist' do
      visit checkout_path(id: :address)
      expect(page).to have_content I18n.t('users.fast_auth.quik_regist.message')
      within '#quik_regist' do
        fill_in I18n.t('simple_form.labels.user.email'), with: FFaker::Internet.email
        click_button I18n.t('users.fast_auth.continue_button')
      end
      expect(page).to have_content I18n.t('devise.registrations.signed_up')
      expect(current_path).to eq checkout_path(id: :address)
    end

    scenario 'simple log_in' do
      user = create :user
      visit checkout_path(id: :address)
      expect(page).to have_content I18n.t('users.fast_auth.login_message')
      within '#new_user' do
        fill_in I18n.t('simple_form.labels.user.email'), with: user.email
        fill_in I18n.t('simple_form.labels.user.password'), with: user.password
        click_button I18n.t('users.fast_auth.continue_button')
      end
      expect(page).to have_content I18n.t('devise.sessions.signed_in')
      expect(current_path).to eq checkout_path(id: :address)
    end

  end

end
