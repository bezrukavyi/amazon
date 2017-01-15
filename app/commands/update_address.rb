class UpdateAddress < Rectify::Command

  attr_reader :params

  def initialize(params)
    @params = params.to_h
  end

  def call
    type = params[:address_type]
    if current_object.update_attributes({ "#{type}_attributes": params })
      broadcast :valid
    else
      broadcast :invalid
    end
  end

  private

  def current_object
    model_type = params[:addressable_type]
    model_id = params[:addressable_id]
    Object.const_get(model_type).find(model_id)
  end

end
