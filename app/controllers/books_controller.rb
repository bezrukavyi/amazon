class BooksController < ApplicationController

  def index
    @categories = Category.all
    @sort_types = Book::SORT_TYPES
    @book_count = Book.count
    @books = default_sort? ? Book.newest : Book.all
    @books = filtered_books(@books).page(params[:page])
  end

  def show
    @book = Book.find_by(id: params[:id])
    redirect_to books_path, notice: 'Not found' unless @book
  end

  private

  def filtered_books(books)
    filtered_params.each do |param, value|
      books = books.public_send(param, value) if value.present?
    end
    books
  end

  def filtered_params
    params.slice(:with_category, :sorted_by)
  end

  def default_sort?
    return true unless params[:sorted_by]
    params[:sorted_by] == :newest
  end

end
