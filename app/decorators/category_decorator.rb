class CategoryDecorator < PersonDecorator
  delegate_all

  def title_key
    title.split(' ').join('_').downcase
  end

  def current?(param)
    return false if param.blank?
    title.downcase.eql?(param.downcase)
  end

end
