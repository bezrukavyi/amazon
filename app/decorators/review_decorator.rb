class ReviewDecorator < Draper::Decorator
  delegate_all

  def user_name
    user.decorate.full_name
  end

  def user
    @user ||= object.user
  end

  def created_at
    object.created_at.strftime("%d/%m/%y")
  end

end
