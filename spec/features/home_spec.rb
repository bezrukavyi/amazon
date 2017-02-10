feature 'Home', type: :feature do
  before do
    @mobile = create :category, title: 'Mobile'
    @web_design = create :category, title: 'Web design'
    @mob_book = create :book, category: @mobile
    @second_mob_book = create :book, category: @mobile
    @web_book = create :book, category: @web_design
    @second_web_book = create :book, category: @web_design
    create :order, order_items: [create(:order_item, book_id: @mob_book.id)], state: :delivered
    create :order, order_items: [create(:order_item, book_id: @web_book.id)], state: :delivered
  end

  context 'root page' do
    before do
      visit root_path
    end
    scenario 'latest books' do
      expect(page).to have_content(@second_mob_book.title)
      expect(page).not_to have_content(@web_book.title)
      click_button(I18n.t('buy_now'), match: :first)
      expect(page).to have_content(I18n.t('flash.success.book_add', count: 1))
    end
    scenario 'get started' do
      path = books_path(with_category: @mobile.title)
      expect(page).to have_link(I18n.t('main_pages.home.get_started'), href: path)
    end
    scenario 'best sellers' do
      expect(page).to have_content(@mob_book.title)
      expect(page).not_to have_content(@web_book.title)
    end
  end

  context 'home page by category' do
    before do
      visit home_path(category: @web_design.decorate.title_key)
    end
    scenario 'latest books' do
      expect(page).to have_content(@second_web_book.title)
      expect(page).not_to have_content(@mob_book.title)
      click_button(I18n.t('buy_now'), match: :first)
      expect(page).to have_content(I18n.t('flash.success.book_add', count: 1))
    end
    scenario 'get started' do
      path = books_path(with_category: @web_design.title)
      expect(page).to have_link(I18n.t('main_pages.home.get_started'), href: path)
    end
    scenario 'best sellers' do
      expect(page).to have_content(@web_book.title)
      expect(page).not_to have_content(@mob_book.title)
    end
  end
end
