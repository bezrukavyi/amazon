class UsersController < Devise::RegistrationsController
  include AddressableAttrubutes
  include Rectify::ControllerHelpers

  before_action :authenticate_user!
  before_action only: [:edit, :update] { addresses_by_model(current_user) }
  before_action :set_countries, only: [:edit, :update]

  def new
    super { render('fast_auth') && return if params[:type] == 'fast' }
  end

  def create
    super do
      if params[:type] == 'fast'
        resource.skip_password_validation = true
        resource.save
      end
    end
  end

  def update
    params[:address] ? address_update : update_user
  end

  def destroy
    if params[:agree_cancel]
      super
    else
      redirect_to edit_user_path, alert: t('flash.failure.confirm_intentions')
    end
  end

  private

  def update_user
    UpdateUser.call(current_user, params) do
      on(:valid) do
        bypass_sign_in current_user
        success_update('privacy')
      end
      on(:invalid) { failure_update('privacy') }
    end
  end

  def address_update
    UpdateAddress.call(addressable: current_user, params: params) do
      on(:valid) do
        success_update('address')
      end
      on(:invalid) do |addresses|
        expose addresses
        failure_update('address')
      end
    end
  end

  def failure_update(type)
    flash_render :edit, alert: t("flash.failure.#{type}_update")
  end

  def success_update(type)
    redirect_to edit_user_path, notice: t("flash.success.#{type}_update"),
                                anchor: type
  end
end
