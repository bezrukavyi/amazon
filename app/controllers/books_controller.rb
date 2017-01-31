class BooksController < ApplicationController
  before_action :authenticate_user!, only: :update
  before_action :set_book, only: [:show, :update]
  before_action :set_reviews, only: [:show, :update]

  def index
    @sort_types = Book::SORT_TYPES
    @book_count = Book.count
    @books = Book.filter_with(filter_option).page(params[:page]).with_authors
  end

  def show
    @review_form = ReviewForm.new
  end

  def update
    @review_form = ReviewForm.from_params(review_params)
    CreateReview.call(@review_form) do
      on(:valid) { redirect_to book_path(params[:id]), notice: t('books.show.review_created') }
      on(:invalid) { render :show }
    end
  end

  private

  def filter_option
    { with_category: params[:with_category], sorted_by: params[:sorted_by] }
  end

  def review_params
    params[:review].merge({ user_id: current_user.id, book_id: @book.id })
  end

  def set_book
    @book = Book.full_includes.find_by(id: params[:id]).try(:decorate)
    redirect_to books_path, alert: t('books.show.not_found') unless @book
  end

  def set_reviews
    @reviews = @book.reviews
  end

end
