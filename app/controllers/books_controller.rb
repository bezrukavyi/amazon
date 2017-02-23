class BooksController < ApplicationController
  include CookiePathable
  include Rectify::ControllerHelpers

  load_and_authorize_resource only: [:update, :show]
  before_action :decorate_book, only: [:show, :update]

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

  def decorate_book
    @book = @book.decorate
  end
end
