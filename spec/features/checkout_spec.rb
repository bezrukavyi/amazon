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
    login_as(user, scope: :user)
    allow_any_instance_of(CheckoutsController)
    .to receive(:current_order).and_return(order)
  end

  context 'checkout fill', js: true do
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

      click_button I18n.t('simple_form.titles.save_and_continue')

      expect(page).to have_content(I18n.t('checkouts.complete.thanks_message'))
      expect(page).to have_content(I18n.t('checkouts.complete.email_confirm', email: user.email))
      expect(page).to have_content(I18n.t('checkouts.complete.order_id', id: order.id))

    end
  end

end
