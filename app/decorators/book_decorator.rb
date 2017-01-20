class BookDecorator < Draper::Decorator
  delegate_all

  include ActionView::Helpers::NumberHelper

  def authors_name
    authors.decorate.map(&:full_name).join(', ')
  end

  def publicate_at
    object.created_at.strftime('%Y')
  end

  def main_picture
    object.pictures.first || object.avatar_url.to_s
  end

  def other_picutres
    object.pictures.drop(1)
  end

  def currency_price
    number_to_currency object.price, locale: :eu
  end

  private

  def authors
    @authors ||= object.authors
  end

end
