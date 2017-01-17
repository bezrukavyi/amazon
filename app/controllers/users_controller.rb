class UsersController < Devise::RegistrationsController
  before_action :authenticate_user!

  include AddressableAttrubutes
  before_action :set_countries, only: [:edit, :update]
  before_action :set_addresses, only: [:edit, :update]

  def update
    params[:address] ? address_update : super
  end

  def destroy
    if params[:agree_cancel]
      super
    else
      redirect_to user_edit_path, alert: t('.confirm_intentions')
    end
  end

  protected

  def after_update_path_for(resource)
    user_edit_path
  end

  def update_resource(resource, resource_params)
    type = params[:with_password] ? 'with' : 'without'
    resource.send("update_#{type}_password", resource_params)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :current_password)
  end

  private

  def address_update
    form = AddressForm.from_params(params)
    type = form.address_type
    send("#{type}=", form)
    UpdateAddress.call(send("#{type}")) do
      on(:valid) { redirect_back fallback_location: root_path, notice: t('devise.registrations.updated') }
      on(:invalid) { render :edit }
    end
  end

end
