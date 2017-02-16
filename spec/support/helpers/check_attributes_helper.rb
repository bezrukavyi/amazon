module Support
  module CheckAttributes
    include ActionView::Helpers::NumberHelper

    def check_price(objects, name = :price, exist = true)
      objects = check_objects(objects)
      objects.each do |object|
        value = number_to_currency(object.send(name), locale: :eu)
        exist_value(value, exist)
      end
    end

    def check_title(objects, name = :title, exist = true)
      objects = check_objects(objects)
      objects.each do |object|
        exist_value(object.send(name), exist)
      end
    end

    def check_field(objects, type, title)
      objects = check_objects(objects)
      objects.each do |object|
        field_label = I18n.t("simple_form.labels.#{type}.#{title}")
        expect(page).to have_field(field_label, with: object.send(title))
      end
    end

    def exist_value(value, exist)
      if exist
        expect(page).to have_content(value)
      else
        expect(page).to have_no_content(value)
      end
    end

    private
    def check_objects(objects)
      objects.respond_to?(:each) ? objects : [objects]
    end
  end
end
