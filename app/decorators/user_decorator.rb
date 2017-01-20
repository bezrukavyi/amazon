class UserDecorator < PersonDecorator
  delegate_all

  def full_name
    super.present? ? super : object.email
  end

end