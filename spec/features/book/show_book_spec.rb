include Support::CheckAttributes
include Support::Book

feature 'Show book' do
  let(:book) { create(:book).decorate }
  background do
    visit book_path(id: book.id)
  end

  scenario 'Must show book attributes' do
    check_title(book)
    check_price(book)
    check_title(book, :authors_name)
    check_title(book, :materials_name)
    check_title(book, :publicate_at)
  end

  scenario "Show full book's description", js: true do
    book = create(:book, :long_desc).decorate
    visit book_path(id: book.id)
    check_title(book, :short_desc)
    check_title(book, :desc, false)
    find('.desc_button', text: I18n.t('books.show.read_more')).click
    check_title(book, :short_desc, false)
    check_title(book, :desc)
    find('.desc_button', text: I18n.t('books.show.hide')).click
    check_title(book, :short_desc)
    check_title(book, :desc, false)
  end
end
