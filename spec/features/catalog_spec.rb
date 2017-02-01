require 'rails_helper'

RSpec.feature 'Catalog', :type => :feature do

  let(:fantasy) { create :category }
  let(:drama) { create :category }

  before do
    create :book, category: fantasy
    create :book, category: fantasy
    create :book, category: drama
    visit books_path
  end

  scenario 'default page' do
    Book.all.map(&:title).each do |title|
      expect(page).to have_content(title)
    end
  end

  context 'Filter', js: true do
    before do
      within '#filter_book' do
        first('label', text: fantasy.title).click
      end
    end

    scenario 'with fantasy books' do
      Book.where(category: fantasy).map(&:title).each do |title|
        expect(page).to have_content(title)
      end
    end

    scenario 'without drama book' do
      Book.where(category: drama).map(&:title).each do |title|
        expect(page).not_to have_content(title)
      end
    end
  end

  scenario 'Add to cart' do
    book = Book.first
    find("#add_to_cart_#{book.id}").click
    expect(page).to have_content(I18n.t('flash.success.book_add', count: 1))
  end

  scenario 'Redirect to book' do
    book = Book.first
    find(:xpath, "//a[@href='/books/#{book.id}']").click
    expect(current_path).to eq("/books/#{book.id}")
  end

end
