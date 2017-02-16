require_relative 'check_attributes_helper'

module Support
  module CreditCard
    include CheckAttributes

    def check_credit_card(credit_card)
      credit_card = credit_card.decorate
      %i(hidden_number month_year).each do |title|
        check_title(credit_card, title)
      end
    end
  end
end
