class UsersController < Devise::RegistrationsController
  before_action :authenticate_user!

  include AddressableAttrubutes
  before_action only: [:edit, :update] { set_addresses(current_user) }
  before_action :set_countries, only: [:edit, :update]

  def update
    params[:address] ? address_update : update_user
  end

  def destroy
    if params[:agree_cancel]
      super
    else
      redirect_to edit_user_path, alert: t('.confirm_intentions')
    end
  end

  private

  def allowed_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :current_password, :first_name, :last_name)
  end

  def update_user
    type = params[:with_password] ? 'with' : 'without'
    if current_user.send("update_#{type}_password", allowed_params)
      bypass_sign_in current_user
      success_update('privacy')
    else
      failure_update
    end
  end

  def address_update
    address = set_address_by_params(params[:address])
    UpdateAddress.call({ addressable: current_user, addresses: [address] }) do
      on(:valid) { success_update('address') }
      on(:invalid) { failure_update }
    end
  end

  def failure_update
    flash[:alert] = t('devise.failure.updated')
    render :edit
  end

  def success_update(type)
    redirect_to edit_user_path, notice: t('devise.registrations.updated'), anchor: type
  end

end
