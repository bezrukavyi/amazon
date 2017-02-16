include Support::CheckAttributes

feature 'Catalog Filter', type: :feature do
  let(:fantasy) { create :category }
  let(:drama) { create :category }

  background do
    create_list :book, 2, category: fantasy
    create_list :book, 3, category: drama
  end

  scenario 'with fantasy books' do
    visit books_path
    check_title(fantasy.books)
    check_title(drama.books)
    within '#filter_book' do
      click_link(fantasy.title)
    end
    check_title(fantasy.books)
    check_title(drama.books, :title, false)
  end
end
