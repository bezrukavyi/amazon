class BooksController < ApplicationController
  def index
    @categories = Category.all
    @sort_types = Book::SORT_TYPES
    @books = default_sort? ? Book.newest : Book.all
    filtering_books!
  end

  def show
    @book = Book.find_by(id: params[:id])
    redirect_to books_path, notice: 'Not found' unless @book
  end

  private

  def filtering_books!
    filtering_params = params.slice(:with_category, :sorted_by)
    filtering_params.each do |param, value|
      @books = @books.public_send(param, value) if value.present?
    end
  end

  def default_sort?
    return true unless params[:sorted_by]
    params[:sorted_by] == :newest
  end

end
