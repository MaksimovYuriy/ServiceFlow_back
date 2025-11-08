class AuthController < ApplicationController
    skip_before_action :authenticate!

    def sign_in
        user = User.find_by(email: sign_in_params[:email])

        if user&.authenticate(sign_in_params[:password])
            token = user.generate_jwt
            render json: successful_response(token)
        else
            render json: error_response, status: :unauthorized
        end
    end

    private

    def sign_in_params
        params.require(:data).require(:attributes).permit(:email, :password)
    end

    def successful_response(token)
        {
            data: {
                type: :auth,
                attributes: {
                    token: token,
                    message: "Successful"
                }
            }
        }
    end

    def error_response
        {
            data: {
                type: :auth,
                attributes: {
                    message: "Invalid credentials"
                }
            }
        }
    end

end
