class MainPagesController < ApplicationController
  def home
    @category_title = category_title
    books = Book.with_category(@category_title).includes(:authors)
    @carousel_books = books.newest.limit(4)
    @best_sellers = books.best_sellers
    @best_sellers = @carousel_books if @best_sellers.blank?
  end

  private

  def category_title
    category = params[:category] || Category::HOME.to_s
    category.split('_').join(' ').capitalize
  end
end
