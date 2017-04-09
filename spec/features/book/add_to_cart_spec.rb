include Support::Order

feature 'Add to cart', type: :feature do
  let(:book) { create(:book).decorate }
  background do
    visit book_path(id: book.id)
  end

  scenario 'Success added' do
    add_to_cart('add_to_cart', 2)
    expect(page).to have_content(I18n.t('flash.success.book_add', count: 2))
  end

  scenario 'Failed added' do
    add_to_cart('add_to_cart', 100)
    error = I18n.t('errors.messages.less_than_or_equal_to', count: 99)
    expect(page).to have_content(I18n.t('flash.failure.book_add',
                                        errors: "Quantity #{error}"))
  end
end
