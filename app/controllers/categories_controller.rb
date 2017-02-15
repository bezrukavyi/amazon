class CategoriesController < ApplicationController
  include CookiePathable

  def show
    @category = Category.find_by(id: params[:id])
    if @category.blank?
      redirect_to books_path, alert: t('flash.failure.category_found')
    else
      last_catalog_path!(@category)
      @presenter = Books::IndexPresenter.new(params, @category)
      render 'books/index'
    end
  end
end
