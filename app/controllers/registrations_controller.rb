class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  private
  def user_params
    params(:user).permit(:first_name, :last_name, :address)
  end

end
