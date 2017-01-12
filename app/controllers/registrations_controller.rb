class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    params.delete(:password) unless params[:password]
    params.delete(:password_confirmation) unless params[:password_confirmation]
    resource.update_attributes(params)
  end
end
