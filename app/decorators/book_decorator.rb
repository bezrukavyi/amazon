class BookDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  delegate_all
  decorates_association :authors
  decorates_association :reviews

  MAIN_PARAMS = [:category_name, :count, :publicate_at, :parse_dimension,
                 :materials_name].freeze

  def authors_name
    authors.map(&:full_name).join(', ')
  end

  def materials_name
    materials.map(&:name).join(', ').capitalize
  end

  def publicate_at
    created_at.strftime('%Y')
  end

  def main_picture
    pictures.first.try(:path) || avatar_url.to_s
  end

  def other_picutres
    pictures.drop(1)
  end

  def currency_price
    number_to_currency price, locale: :eu
  end

  def category_name
    category.title
  end

  def short_desc
    truncate desc, length: 200
  end

  def long_desc?
    desc.length > 200
  end

  def parse_dimension
    dimension.map do |key, value|
      [I18n.t("books.show.dimensions.#{key}"), value].join(':')
    end.join(' x ')
  end

  def disabled_class
    'disabled' unless in_stock?
  end
end
