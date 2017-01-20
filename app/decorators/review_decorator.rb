class ReviewDecorator < Draper::Decorator
  delegate_all

  def user_name
    user.decorate.full_name
  end

  def created_strf
    created_at.strftime("%d/%m/%y")
  end

end
