class AuthController < ApplicationController
  TOKEN_TTL = 12.hours

  skip_before_action :authenticate!, only: %i[sign_in sign_out]

  def sign_in
    token = SignInService.new(
      email: sign_in_params[:email],
      password: sign_in_params[:password]
    ).call

    set_auth_cookie(token)

    render json: {
      data: { type: :auth, attributes: { message: 'Successful' } }
    }
  rescue SignInService::InvalidCredentials
    render json: {
      data: { type: :auth, attributes: { message: 'Invalid credentials' } }
    }, status: :unauthorized
  end

  def sign_out
    cookies.delete(:token, same_site: :lax)
    render json: {
      data: { type: :auth, attributes: { message: 'Signed out' } }
    }
  end

  def me
    render json: {
      data: {
        type: :user,
        id: @current_user.id.to_s,
        attributes: {
          email: @current_user.email,
          phone: @current_user.phone,
          active: @current_user.active
        }
      }
    }
  end

  private

  def sign_in_params
    params.require(:data).require(:attributes).permit(:email, :password)
  end

  def set_auth_cookie(token)
    cookies[:token] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
      expires: TOKEN_TTL.from_now
    }
  end
end
