class UserDecorator < PersonDecorator
  delegate_all

  def full_name
    super.present? ? super : email
  end

  def name_letter
    full_name.first.capitalize
  end
end
