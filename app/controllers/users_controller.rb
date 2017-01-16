class UsersController < Devise::RegistrationsController
  before_action :authenticate_user!

  include AddressableController
  before_action :set_addresses, only: [:edit, :update]

  def update
    if params[:address]
      address_update
    elsif params[:user]
      params[:with_password] ? super : user_update
    end
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

  private

  def user_update
    if current_user.update_attributes(user_params)
      redirect_to user_edit_path, notice: t('.success_updated_email')
    else
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(:email)
  end

end
