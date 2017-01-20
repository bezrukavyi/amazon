module BooksHelper
  def category_title
    params[:with_category].blank? ? t('all') : params[:with_category]
  end

  def sort_key
    params[:sorted_by].blank? ? :newest : params[:sorted_by]
  end

  def sort_title
    t(".sorted_by.#{sort_key}")
  end

end
