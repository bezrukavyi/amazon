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

  def update_resource(resource, resource_params)
    type = params[:with_password] ? 'with' : 'without'
    resource.send("update_#{type}_password", resource_params)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :current_password, :first_name, :last_name)
  end

  def after_update_path_for(resource)
    user_edit_path
  end

  private

  def address_update
    form = AddressForm.from_params(address_params)
    type = form.address_type
    send("#{type}=", form)
    UpdateAddress.call(send("#{type}")) do
      on(:valid) { redirect_back fallback_location: root_path, notice: t('devise.registrations.updated'), anchor: 'address' }
      on(:invalid) { render :edit }
    end
  end

  def address_params
    params[:address].merge({ addressable_id: current_user.id, addressable_type: 'User' })
  end

end
