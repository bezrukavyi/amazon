require_relative 'check_attributes_helper'

module Support
  module Delivery
    include CheckAttributes

    def check_delivery(delivery)
      delivery = delivery.decorate
      %i(name duration).each do |title|
        check_title(delivery, title)
      end
    end
  end
end
