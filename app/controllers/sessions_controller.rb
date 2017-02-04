class SessionsController < Devise::SessionsController

  def new
    super { render 'fast_auth' and return if params[:fast_auth] }
  end

end
