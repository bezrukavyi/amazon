module BooksHelper
  def category_title
    params[:with_category].blank? ? t('all') : params[:with_category]
  end

  def sort_key
    params[:sorted_by].blank? ? Book::SORT_TYPES.first : params[:sorted_by]
  end

  def sort_title
    t(".sorted_by.#{sort_key}")
  end

  def user_avatar(user)
    if user.avatar.file.nil?
      content_tag :span, user.decorate.name_letter,
      class: 'img-circle logo-size inlide-block pull-left logo-empty'
    else
      image_tag user.avatar.url, class: 'img-circle logo-size inlide-block pull-left'
    end
  end

end
