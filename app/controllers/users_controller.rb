class UsersController < Devise::RegistrationsController
  before_action :authenticate_user!

  include AddressableAttrubutes
  before_action only: [:edit, :update] { set_addresses(current_user) }
  before_action :set_countries, only: [:edit, :update]

  def update
    params[:address] ? address_update : super
  end

  def destroy
    if params[:agree_cancel]
      super
    else
      redirect_to edit_user_path, alert: t('.confirm_intentions')
    end
  end

  protected

  def update_resource(resource, resource_params)
    type = params[:with_password] ? 'with' : 'without'
    resource.send("update_#{type}_password", resource_params)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :current_password, :first_name, :last_name)
  end

  def after_update_path_for(resource)
    edit_user_path
  end

  private

  def address_update
    address = set_address_by_params(params[:address])
    UpdateAddress.call({ addressable: current_user, addresses: [address] }) do
      on(:valid) { redirect_back fallback_location: root_path, notice: t('devise.registrations.updated'), anchor: 'address' }
      on(:invalid) { render :edit }
    end
  end

end
