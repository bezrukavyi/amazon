class BooksController < ApplicationController
  def index
    @categories = Category.all
    @books = Book.all
    @sort_types = Book::SORT_TYPES
    filtering_params.each do |param, value|
      @books = @books.public_send(param, value) if value.present?
    end
  end

  def show
    @book = Book.find_by(id: params[:id])
    redirect_to books_path, notice: 'Not found' unless @book
  end

  private

  def filtering_params
    params.slice(:with_category, :sorted_by)
  end

end
