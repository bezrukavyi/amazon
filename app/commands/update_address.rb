class UpdateAddress < Rectify::Command

  attr_reader :address_form

  def initialize(address_form)
    @address_form = address_form
  end

  def call
    if address_form.valid? && update_object
      broadcast :valid
    else
      broadcast :invalid
    end
  end

  private

  def current_object
    Object.const_get(address_form[:addressable_type])
      .find(address_form[:addressable_id])
  end

  def update_object
    type = address_form[:address_type]
    current_object.update_attributes({ "#{type}_attributes": address_form.to_h })
  end

end
