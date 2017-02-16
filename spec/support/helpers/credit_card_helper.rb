require_relative 'check_attributes_helper'

module Support
  module CreditCard
    include CheckAttributes

    def fill_credit_card(form_id, options, with_button = true)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.credit_card.number'), with: options[:number]
        fill_in I18n.t('simple_form.labels.credit_card.name'), with: options[:name]
        fill_in I18n.t('simple_form.labels.credit_card.month_year'), with: options[:month_year]
        fill_in I18n.t('simple_form.labels.credit_card.cvv'), with: options[:cvv]
        click_button I18n.t('simple_form.titles.save') if with_button
      end
    end

    def check_credit_card(credit_card)
      credit_card = credit_card.decorate
      %i(hidden_number month_year).each do |title|
        check_title(credit_card, title)
      end
    end
  end
end
