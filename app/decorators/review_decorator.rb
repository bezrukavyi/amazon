class ReviewDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def user_name
    user.full_name
  end

  def created_strf
    created_at.strftime("%d/%m/%y")
  end

end
