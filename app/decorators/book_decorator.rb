class BookDecorator < Draper::Decorator
  delegate_all

  include ActionView::Helpers::NumberHelper

  def authors_name
    authors.decorate.map(&:full_name).join(', ')
  end

  def publicate_at
    created_at.strftime('%Y')
  end

  def main_picture
    pictures.first || avatar_url.to_s
  end

  def other_picutres
    pictures.drop(1)
  end

  def currency_price
    number_to_currency price, locale: :eu
  end

end
