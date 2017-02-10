class CheckoutsController < ApplicationController
  include Wicked::Wizard
  include AddressableAttrubutes

  steps :address, :delivery, :payment, :confirm, :complete

  before_action :fast_authenticate_user!
  before_action :set_step_components

  def show
    Checkout::AccessStep.call(current_order, current_user, step) do
      on(:allow) { render_wizard }
      on(:not_allow) { redirect_to checkout_path(previous_step), alert: t('flash.failure.step') }
      on(:empty_cart) { redirect_to books_path, alert: t('flash.failure.empty_cart') }
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

  def set_step_components
    @steps = steps
    send("#{step}_components") if respond_to?("#{step}_components", :private)
  end

  def address_components
    object = current_order.any_address? ? current_order : current_user
    set_addresses_by_model(object)
    set_countries
  end

  def delivery_components
    @deliveries = current_order.access_deliveries
  end

  def payment_components
    @payment_form = CreditCardForm.from_model(current_order.credit_card)
  end

  def complete_components
    @completed_order = current_user.complete_order
  end

  def address_options
    { addressable: current_order, addresses: set_addresses_by_params(params[:order]) }
  end

  def delivery_options
    { order: current_order, delivery_id: params[:delivery_id] }
  end

  def payment_options
    @payment_form = CreditCardForm.from_params(params[:order][:credit_card_attributes])
    { order: current_order, payment_form: @payment_form }
  end

  def confirm_options
    { order: current_order, user: current_user, confirm: params[:confirm] }
  end
end
