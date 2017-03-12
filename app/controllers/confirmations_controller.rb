class ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.find_by_confirmation_token(token)
    super if resource.password?
  end

  def update
    self.resource = resource_class.confirm_by_token(token)
    if !resource.password? && resource.update_attributes(allowed_params)
      bypass_sign_in resource
      redirect_to corzinus.checkout_path(:address),
                  notice: t('devise.confirmations.confirmed')
    else
      flash_render :show, alert: t('flash.failure.update_password')
    end
  end

  private

  def allowed_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def token
    @token ||= params[:confirmation_token] || params[:user][:confirmation_token]
  end
end
