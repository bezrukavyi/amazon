class UpdateUser < Rectify::Command
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    if update_user
      broadcast :valid
    else
      broadcast :invalid
    end
  end

  private

  def update_user
    type = params[:with_password] ? 'with' : 'without'
    user.send("update_#{type}_password", allowed_params)
  end

  def allowed_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :current_password, :first_name, :last_name)
  end
end
