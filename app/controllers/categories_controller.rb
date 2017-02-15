class CategoriesController < ApplicationController
  def show
    @category = Category.find_by(id: params[:id])
    if @category.blank?
      redirect_to books_path, alert: t('flash.failure.category_found')
    else
      cookies[:last_catalog_path] = category_path(id: @category,
                                                  sorted_by: params[:sorted_by])
      @presenter = Books::IndexPresenter.new(params: params,
                                             category: @category)
      render 'books/index'
    end
  end
end
