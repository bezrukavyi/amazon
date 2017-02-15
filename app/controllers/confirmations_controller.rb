class ConfirmationsController < Devise::ConfirmationsController
  before_action :set_resource, only: [:show, :update]

  def show
    super if resource.password?
  end

  def update
    if !resource.password? && resource.update_attributes(allowed_params)
      bypass_sign_in resource
      redirect_to checkout_path(:address),
                  notice: t('devise.confirmations.confirmed')
    else
      flash_render :show, alert: t('flash.failure.update_password')
    end
  end

  private

  def allowed_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_resource
    token = params[:confirmation_token] || params[:user][:confirmation_token]
    self.resource = resource_class.confirm_by_token(token)
  end
end
