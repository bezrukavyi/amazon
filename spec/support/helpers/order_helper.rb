module Support
  module Order
    def fill_order(form_id, values)
      values = [values] unless values.respond_to?(:each)
      within "##{form_id}" do
        values.each_with_index do |value, index|
          fill_in "order_order_items_attributes_#{index}_quantity", with: value
        end
        click_button I18n.t('carts.edit.update_cart')
      end
    end

    def fill_coupon(form_id, code)
      within "##{form_id}" do
        fill_in 'order_coupon_code', with: code
        click_button I18n.t('carts.edit.update_cart')
      end
    end

    def add_to_cart(form_id, quantity = nil)
      within "##{form_id}" do
        fill_in('quantity', with: quantity) if quantity.present?
        click_button I18n.t('add_to_cart')
      end
    end

    def choose_state(state)
      find('#order_types').click
      find('label', text: state).click
    end
  end
end
