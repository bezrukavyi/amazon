require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature 'Order', :type => :feature do

  let(:user) { create :user }

  before do
    @order = create :order, :checkout_package, state: :processing, user: user
    login_as(user, scope: :user)
    visit order_path(I18n.locale, @order.id)
  end

  scenario 'order items info' do
    @order.order_items.each do |item|
      book = item.book
      expect(page).to have_link(book.title, href: book_path(id: book.id))
      expect(page).to have_content(book.decorate.short_desc)
      expect(page).to have_content(item.quantity)
      expect(page).to have_content(@order.decorate.completed_at)
      expect(page).to have_content(number_to_currency book.price, locale: :eu)
    end
  end

  scenario 'order components info' do
    [:shipping, :billing].each do |address|
      address = @order.send(address)
      expect(page).to have_content(address.name)
      expect(page).to have_content(address.decorate.city_zip)
      expect(page).to have_content(address.country.name)
      expect(page).to have_content(address.phone)
    end
    expect(page).to have_content(@order.delivery.name)
    expect(page).to have_content(@order.delivery.decorate.duration)
    expect(page).to have_content(@order.credit_card.decorate.hidden_number)
    expect(page).to have_content(@order.credit_card.month_year)
  end

  scenario 'order result panel' do
    [:sub_total, :delivery_cost, :coupon_cost, :total_price].each do |price|
      expect(page).to have_content(number_to_currency @order.send(price), locale: :eu)
    end
    expect(page).to have_content(@order.decorate.discount_title)
  end


end
