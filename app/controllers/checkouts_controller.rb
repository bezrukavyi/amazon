class CheckoutsController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :set_steps_params

  include AddressableAttrubutes
  before_action only: [:show, :update] { set_addresses(current_order) }
  before_action :set_countries, only: [:show, :update]

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    AccessStep.call(current_order, step) do
      on(:allow) { render_wizard }
      on(:not_allow) { redirect_to checkout_path(previous_step), alert: 'You must end this step' }
    end
  end

  def update
    addresses = addresses_forms(current_order)
    options = { order: current_order, params: params, addresses: addresses }
    Object.const_get("Checkout#{step.capitalize}").call(options) do
      on(:valid) { render_wizard current_order }
      on(:invalid) { render_wizard }
    end
  end

  private

  def set_steps_params
    @steps = steps
  end

end
