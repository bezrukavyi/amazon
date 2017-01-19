class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    @categories = Category.all
    @sort_types = Book::SORT_TYPES
    @book_count = Book.count
    @books = default_sort? ? Book.newest : Book.all
    @books = filtered_books(@books).page(params[:page])
  end

  def show
    @review = AddressForm.new
    @book = Book.find_by(id: params[:id])
    redirect_to books_path, notice: 'Not found any' unless @book
  end

  def update
    @review = ReviewForm.from_params(params)
    CreateReview.call(@review) do
      on(:valid) { redirect_back fallback_location: root_path, notice: 'Review created' }
      on(:invalid) { render :edit }
    end
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
