require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature 'Cart', :type => :feature do

  let(:first_book) { create :book, price: 100.00 }
  let(:second_book) { create :book, price: 50.00 }
  let(:coupon) { create :coupon }
  let(:first_item) { create :order_item, book: first_book, quantity: 2 }
  let(:second_item) { create :order_item, book: second_book, quantity: 2 }
  let(:order) { create :order, order_items: [first_item, second_item] }

  before do
    allow_any_instance_of(CartsController).to receive(:current_order).and_return(order)
    visit edit_cart_path
  end

  def check_price(*values)
    values.each do |value|
      expect(page).to have_content(number_to_currency value, locale: :eu)
    end
  end

  scenario 'default page' do
    expect(page).to have_content(I18n.t('carts.edit.title'))
    expect(page).to have_content(first_book.title)
    expect(page).to have_content(second_book.title)

    check_price(first_book.price, second_book.price, first_item.sub_total,
    second_item.sub_total, order.sub_total)

    order.order_items.each do |item|
      expect(find_field("order_order_items_attributes_2_quantity").value)
      .to eq item.quantity.to_s
    end
  end

  context 'Update order item' do
    scenario 'success update quantity' do
      within "#edit_order_#{order.id}" do
        fill_in ("order_order_items_attributes_2_quantity"), with: 3
        fill_in ("order_order_items_attributes_3_quantity"), with: 1
        click_button I18n.t('carts.edit.update_cart')
      end
      expect(page).to have_content(I18n.t('flash.success.cart_update'))
    end

    scenario 'failed update quantity' do
      within "#edit_order_#{order.id}" do
        fill_in ("order_order_items_attributes_2_quantity"), with: 1001
        click_button I18n.t('carts.edit.update_cart')
      end
      expect(page).to have_content(I18n.t('flash.failure.cart_update'))
    end
  end

  context 'Update coupon' do
    scenario 'success update coupon' do
      within "#edit_order_#{order.id}" do
        fill_in ("order_coupon_code"), with: coupon.code
        click_button I18n.t('carts.edit.update_cart')
      end
      expect(page).to have_content(I18n.t('flash.success.cart_update'))
      expect(page).to have_content("#{I18n.t('carts.edit.coupon')} (#{coupon.discount}%):")
    end

    scenario 'failed update coupon' do
      within "#edit_order_#{order.id}" do
        fill_in ("order_coupon_code"), with: 'Code10101'
        click_button I18n.t('carts.edit.update_cart')
      end
      expect(page).to have_content(I18n.t('flash.failure.cart_update'))
      expect(page).to have_content('Not found this coupon')
    end
  end

  scenario 'destroy order item' do
    delete_link = page.first(:xpath, "//a[@href='/order_items/#{first_item.id}']")
    delete_link.click
    expect(delete_link['data-confirm']).to eq I18n.t('sure?')
  end

  scenario 'empty cart' do
    empty_order = create :order
    allow_any_instance_of(CartsController).to receive(:current_order).and_return(empty_order)
    visit edit_cart_path
    expect(page).to have_content(I18n.t('carts.edit.empty_message'))
    expect(page).not_to have_content(I18n.t('carts.edit.update_cart'))
  end

end
