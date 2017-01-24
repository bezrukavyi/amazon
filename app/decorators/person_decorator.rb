class PersonDecorator < Draper::Decorator

  def full_name
    [first_name, last_name].join(' ').titleize
  end

end
