require 'rails_helper'

RSpec.feature 'BookPage', :type => :feature do

  let(:review_attr) { attributes_for :review }
  let(:user) { create :user }
  let(:book) { create :book }

  before do
    login_as(user, scope: :user)
    visit book_path(id: book.id)
  end

  scenario 'Default page' do
    expect(page).to have_content(book.title)
  end

  scenario 'Create review' do
    within '#review_form' do
      fill_in I18n.t('simple_form.labels.review.title'), with: review_attr[:title]
      fill_in I18n.t('simple_form.labels.review.grade'), with: review_attr[:grade]
      fill_in I18n.t('simple_form.labels.review.desc'), with: review_attr[:desc]
      click_button I18n.t('simple_form.titles.save')
    end
    expect(page).to have_content(I18n.t('books.show.review_created'))
  end


end
