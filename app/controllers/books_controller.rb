class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  before_action :set_book, only: [:show, :update]
  before_action :set_reviews, only: [:show, :update]

  def index
    @categories = Category.all
    @sort_types = Book::SORT_TYPES
    @book_count = Book.count
    @books = filtered_books.page(params[:page])
  end

  def show
    @review_form = ReviewForm.new
    redirect_to books_path, notice: 'Not found any' unless @book
  end

  def update
    @review_form = ReviewForm.from_params(review_params)
    CreateReview.call(@review_form) do
      on(:valid) { redirect_to book_path(params[:id]), notice: 'Review created' }
      on(:invalid) { render :show }
    end
  end

  private

  def filtered_params
    params.slice(:with_category, :sorted_by)
  end

  def filtered_books
    books = default_sort? ? Book.newest : Book.all
    filtered_params.each do |param, value|
      books = books.public_send(param, value) if value.present?
    end
    books
  end

  def review_params
    params[:review].merge({ user_id: current_user.id, book_id: @book.id })
  end

  def default_sort?
    return true unless params[:sorted_by]
    params[:sorted_by] == :newest
  end

  def set_book
    @book = Book.find_by(id: params[:id])
  end

  def set_reviews
    @reviews = @book.reviews.approved
  end

end
