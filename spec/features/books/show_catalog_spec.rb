include Support::CheckAttributes

feature 'Show Catalog', type: :feature do
  let(:fantasy) { create :category }
  let(:drama) { create :category }

  background do
    create_list :book, 4
    visit books_path
  end

  scenario 'Must show books title, price, authors' do
    books = Book.all.decorate
    check_title(books)
    check_price(books)
    check_title(books, :authors_name)
  end

  scenario 'Redirect to book' do
    book = Book.first
    find(:xpath, "//a[@href='/books/#{book.id}']").click
    expect(current_path).to eq("/books/#{book.id}")
  end
end
