module UsersHelper
  def user_avatar(user)
    base_class = 'img-circle logo-size inlide-block pull-left'
    if user.avatar.file.nil?
      content_tag :span, user.decorate.name_letter,
                  class: base_class.concat(' logo-empty')
    else
      image_tag user.avatar.url, class: base_class
    end
  end
end
