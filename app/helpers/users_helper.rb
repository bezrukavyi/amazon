module UsersHelper
  def user_avatar(user)
    if user.avatar.file.nil?
      content_tag :span, user.decorate.name_letter,
                  class: 'img-circle logo-size inlide-block pull-left logo-empty'
    else
      image_tag user.avatar.url, class: 'img-circle logo-size inlide-block pull-left'
    end
  end
end
