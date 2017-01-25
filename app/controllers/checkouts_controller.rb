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
    if current_order.shipping || current_order.billing
      set_addresses(current_order)
    else
      set_addresses(current_user)
    end
    set_countries
  end

  def address_options
    set_addresses_by_params(params[:order])
    { addressable: current_order, addresses: all_addresses }
  end

end
