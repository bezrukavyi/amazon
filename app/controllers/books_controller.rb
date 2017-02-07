class BooksController < ApplicationController
  before_action :authenticate_user!, only: :update
  before_action :set_book, only: [:show, :update]
  before_action :set_reviews, only: [:show, :update]

  def index
    cookies[:last_catalog_path] = books_path(sorted_by: params[:sorted_by])
    @presenter = Books::IndexPresenter.new(params: params)
  end

  def show
    @review_form = ReviewForm.new
  end

  def update
    @review_form = ReviewForm.from_params(review_params)
    CreateReview.call(current_user, @review_form) do
      on(:valid) { redirect_to book_path(params[:id]), notice: t('flash.success.review_create') }
      on(:invalid) { flash_render :show, alert: t('flash.failure.review_create') }
    end
  end

  private

  def set_book
    @book = Book.full_includes.find_by(id: params[:id]).try(:decorate)
    redirect_to books_path, alert: t('flash.failure.book_found') unless @book
  end

  def set_reviews
    @reviews = @book.reviews
  end

  def review_params
    params[:review].merge({ user_id: current_user.id, book_id: @book.id })
  end

end
