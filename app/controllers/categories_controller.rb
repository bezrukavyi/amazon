class CategoriesController < ApplicationController
  include CookiePathable

  load_and_authorize_resource

  def show
    last_catalog_path!(@category)
    @presenter = Books::IndexPresenter.new(params, @category)
    render 'books/index'
  end
end
