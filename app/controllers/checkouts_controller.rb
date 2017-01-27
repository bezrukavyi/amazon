class CheckoutsController < ApplicationController
  include Wicked::Wizard
  include AddressableAttrubutes

  steps :address, :delivery, :payment, :confirm, :complete

  before_action :authenticate_user!
  before_action :set_steps_params
  before_action :components

  def show
    Checkout::AccessStep.call(current_order, step) do
      on(:allow) { render_wizard }
      on(:not_allow) { redirect_to checkout_path(previous_step), alert: 'You must end this step' }
    end
  end

  def update
    options = send("#{step}_options")
    Object.const_get("Checkout::Step#{step.capitalize}").call(options) do
      on(:valid) { render_wizard current_order }
      on(:invalid) { render_wizard }
    end
  end

  private

  def components
    send("#{step}_components") if respond_to?("#{step}_components", :private)
  end

  def set_steps_params
    @steps = steps
  end

  def address_components
    object = current_order.any_address? ? current_order : current_user
    set_addresses(object)
    set_countries
  end

  def address_options
    addresses = set_addresses_by_params(params[:order], params[:use_billing])
    { addressable: current_order, addresses: addresses }
  end

  def delivery_components
    @deliveries = current_order.access_deliveries
  end

  def delivery_options
    { order: current_order, delivery_id: params[:delivery_id] }
  end

end
