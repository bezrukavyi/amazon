require_relative 'check_attributes_helper'

module Support
  module Address
    include CheckAttributes

    def fill_address(type, options, with_button = true)
      within "##{type}" do
        fill_in I18n.t('simple_form.labels.address.first_name'), with: options[:first_name]
        fill_in I18n.t('simple_form.labels.address.last_name'), with: options[:last_name]
        fill_in I18n.t('simple_form.labels.address.name'), with: options[:name]
        fill_in I18n.t('simple_form.labels.address.city'), with: options[:city]
        fill_in I18n.t('simple_form.labels.address.zip'), with: options[:zip]
        fill_in I18n.t('simple_form.labels.address.phone'), with: options[:phone]
        find("#country_id_#{type}").find(:xpath, 'option[2]').select_option
        click_button I18n.t('simple_form.titles.save') if with_button
      end
    end

    def check_address(addresses)
      %i(first_name last_name name city zip phone).each do |title|
        check_title(addresses, title)
      end
    end
  end
end
