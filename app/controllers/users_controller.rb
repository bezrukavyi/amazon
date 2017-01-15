class UsersController < Devise::RegistrationsController

  include Addressable
  before_action :authenticate_user!
  before_action :set_addresses, only: [:edit, :update]
  before_action :set_countries, only: [:edit, :update]

  def edit
    @address = AddressForm.from_params(params)
  end

  def update
    if params[:with_password]
      super
    else
      params[:address] ? address_update : update_update
    end
  end

  def destroy
    if params[:agree_cancel]
      super
    else
      redirect_to user_edit_path, alert: t('.confirm_intentions')
    end
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

  def set_countries
    @countries = Country.all
  end

end
