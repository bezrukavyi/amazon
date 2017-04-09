class AddressDecorator < PersonDecorator
  delegate_all

  def city_zip
    [city, zip].join(' ')
  end
end
