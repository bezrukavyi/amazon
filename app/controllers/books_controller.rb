class BooksController < ApplicationController
  include CookiePathable
  include Rectify::ControllerHelpers

  before_action :authenticate_user!, only: :update
  before_action :set_book, only: [:show, :update]
  before_action :set_reviews, only: [:show, :update]

  def index
    last_catalog_path!
    @presenter = Books::IndexPresenter.new(params)
  end

  def show
    session_user_return unless current_user
    @review_form = ReviewForm.new
  end

  def update
    CreateReview.call(user: current_user, book: @book, params: params) do
      on(:valid) do |book|
        redirect_to book, notice: t('flash.success.review_create')
      end
      on(:invalid) do |review_form|
        expose review_form: review_form
        flash_render :show, alert: t('flash.failure.review_create')
      end
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
end
