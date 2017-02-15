module CookiePathable
  extend ActiveSupport::Concern

  def last_catalog_path!(category = nil)
    path = books_path(sorted_by: params[:sorted_by])
    if category
      path = category_path(id: category, sorted_by: params[:sorted_by])
    end
    cookies['last_catalog_path'] = path
  end
end
