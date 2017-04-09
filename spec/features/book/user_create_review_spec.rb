include Support::Book

feature 'User create review', type: :feature do
  let(:user) { create :user }
  let(:book) { create :book }

  background do
    login_as(user, scope: :user)
    visit book_path(id: book.id)
  end

  scenario 'User fill valid data' do
    fill_review('review_form', attributes_for(:review))
    expect(page).to have_content(I18n.t('flash.success.review_create'))
  end

  scenario 'User fill invalid data' do
    fill_review('review_form', attributes_for(:review, :invalid))
    expect(page).to have_content(I18n.t('flash.failure.review_create'))
  end

  scenario 'User not auth' do
    logout(:user)
    visit book_path(id: book.id)
    expect(page).to have_no_css('#review_form')
    expect(page).to have_content I18n.t('books.show.auth_review')
    expect(page).to have_link I18n.t('simple_form.titles.log_in')
  end
end
