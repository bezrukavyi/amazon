include Support::CheckAttributes

feature 'Show books', type: :feature do
  before do
    @mobile = create :category, title: 'Mobile'
    @web_design = create :category, title: 'Web design'
    @mob_book = create :book, category: @mobile
    @web_book = create :book, category: @web_design
    create :order, order_items: [create(:order_item, book_id: @mob_book.id)],
                   state: :delivered
    create :order, order_items: [create(:order_item, book_id: @web_book.id)],
                   state: :delivered
  end

  background do
    visit root_path
  end

  context 'When user on default page' do
    scenario 'Must exist latest books' do
      check_title(@mob_book)
      check_title(@web_book, :title, false)
    end
    scenario 'Must exist get started' do
      path = category_path(id: @mobile.id)
      link = I18n.t('main_pages.home.get_started', with: @mobile.title,
                                                   href: path)
      expect(page).to have_link(link)
    end
  end

  context 'When user choose category', js: true do
    before do
      find('.dropdown-toggle', text: I18n.t('home')).click
      click_link @web_design.title
    end
    scenario 'Must exist latest books' do
      expect(page).to have_content(@web_book.title)
      expect(page).not_to have_content(@mob_book.title)
    end
    scenario 'Must exist get started' do
      path = category_path(id: @web_design.id)
      link = I18n.t('main_pages.home.get_started', with: @web_design.title,
                                                   href: path)
      expect(page).to have_link(link)
    end
  end
end
