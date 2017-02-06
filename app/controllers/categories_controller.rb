class CategoriesController < ApplicationController

  before_action :set_category

  def show
    @sort_types = Book::SORT_TYPES
    @book_count = Book.count
    @books = Book.sorted_by(params[:sorted_by]).page(params[:page]).with_authors.where(category: @category)
    render 'books/index'
  end

  private
  def set_category
    @category = Category.find_by(id: params[:id])
    redirect_to books_path, alert: t('flash.failure.category_found') unless @category
  end

end
