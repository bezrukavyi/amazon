module BooksHelper
  def category_sorted_path(category)
    main_app.category_path(id: category.id, sorted_by: params[:sorted_by])
  end

  def category_title(category)
    category.blank? ? t('books.index.sorted_by.all') : category.title
  end

  def sort_key
    params[:sorted_by].blank? ? Book::SORT_TYPES.first : params[:sorted_by]
  end

  def sort_title
    t("books.index.sorted_by.#{sort_key}")
  end

  def last_catalog_path
    cookies['last_catalog_path'] || books_path
  end
end
