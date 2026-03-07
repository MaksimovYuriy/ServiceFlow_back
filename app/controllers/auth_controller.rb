class AuthController < ApplicationController
  skip_before_action :authenticate!

  def sign_in
    token = SignInService.new(
      email: sign_in_params[:email],
      password: sign_in_params[:password]
    ).call

    render json: {
      data: { type: :auth, attributes: { token: token, message: 'Successful' } }
    }
  rescue SignInService::InvalidCredentials
    render json: {
      data: { type: :auth, attributes: { message: 'Invalid credentials' } }
    }, status: :unauthorized
  end

  private

  def sign_in_params
    params.require(:data).require(:attributes).permit(:email, :password)
  end
end
