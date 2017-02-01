module BooksHelper
  def category_title
    type = params[:with_category].blank? ? :all : params[:with_category]
    t("books.index.sorted_by.#{type}")
  end

  def sort_key
    params[:sorted_by].blank? ? Book::SORT_TYPES.first : params[:sorted_by]
  end

  def sort_title
    t("books.index.sorted_by.#{sort_key}")
  end

end
