class UsersController < Devise::RegistrationsController
  before_action :authenticate_user!

  include AddressableController
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

end
