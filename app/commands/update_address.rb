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
    model_type = address_form[:addressable_type]
    model_id = address_form[:addressable_id]
    Object.const_get(model_type).find(model_id)
  end

  def update_object
    type = address_form[:address_type]
    current_object.update_attributes({ "#{type}_attributes": address_form.to_h })
  end

end
