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

  context 'Create review' do
    scenario 'success create' do
      within '#review_form' do
        fill_in I18n.t('simple_form.labels.review.title'), with: review_attr[:title]
        fill_in I18n.t('simple_form.labels.review.desc'), with: review_attr[:desc]
        choose('rate_5', visible: false)
        click_button I18n.t('simple_form.titles.save')
      end
      expect(page).to have_content(I18n.t('flash.success.review_create'))
    end

    scenario 'failure create' do
      within '#review_form' do
        fill_in I18n.t('simple_form.labels.review.title'), with: review_attr[:title]
        click_button I18n.t('simple_form.titles.save')
      end
      expect(page).to have_content(I18n.t('flash.failure.review_create'))
    end
  end

  context 'Add to cart' do
    scenario 'Success added' do
      within '#add_to_cart' do
        fill_in ('quantity'), with: 2
        click_button I18n.t('add_to_cart')
      end
      expect(page).to have_content(I18n.t('flash.success.book_add', count: 2))
    end

    scenario 'Failed added' do
      within '#add_to_cart' do
        fill_in ('quantity'), with: 100
        click_button I18n.t('add_to_cart')
      end
      message = ['Quantity', I18n.t('errors.messages.less_than_or_equal_to', count: 99)].join(' ')
      expect(page).to have_content(I18n.t('flash.failure.book_add', errors: message))
    end

  end


end
