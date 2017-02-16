module Support
  module CheckAttributes
    include ActionView::Helpers::NumberHelper

    def check_price(objects, name = :price, exist = true)
      objects = [objects] unless objects.respond_to?(:each)
      objects.each do |object|
        value = number_to_currency(object.send(name), locale: :eu)
        exist_value(value, exist)
      end
    end

    def check_title(objects, name = :title, exist = true)
      objects = [objects] unless objects.respond_to?(:each)
      objects.each do |object|
        exist_value(object.send(name), exist)
      end
    end

    def exist_value(value, exist)
      if exist
        expect(page).to have_content(value)
      else
        expect(page).to have_no_content(value)
      end
    end
  end
end
