class UsersController < Devise::RegistrationsController
  before_action :authenticate_user!

  include AddressableAttrubutes
  before_action only: [:edit, :update] { set_addresses(current_user) }
  before_action :set_countries, only: [:edit, :update]

  def new
    super { render 'fast_auth' and return if params[:fast_auth] }
  end

  def create
    super do
      if params[:fast_auth]
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
    type = params[:with_password] ? 'with' : 'without'
    if current_user.send("update_#{type}_password", allowed_params)
      bypass_sign_in current_user
      redirect_to edit_user_path, notice: t('flash.success.user_update'), anchor: 'privacy'
    else
      flash_render :edit, alert: t('flash.failure.user_update')
    end
  end

  def address_update
    address = set_address_by_params(params[:address])
    UpdateAddress.call({ addressable: current_user, addresses: [address] }) do
      on(:valid) { redirect_to edit_user_path, notice: t('flash.success.address_update'), anchor: 'address' }
      on(:invalid) { flash_render :edit, alert: t('flash.failure.address_update') }
    end
  end

  def allowed_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :current_password, :first_name, :last_name)
  end

end
