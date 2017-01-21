class PersonDecorator < Draper::Decorator

  def full_name
    [first_name.capitalize, last_name.capitalize].join(' ')
  end

end
