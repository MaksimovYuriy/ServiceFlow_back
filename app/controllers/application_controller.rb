class ApplicationController < ActionController::Base
  before_action :authenticate!

  include Graphiti::Rails::Responders

  private

  def authenticate!
    token = cookies[:token]

    @current_user = User.from_jwt(token) if token.present?

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
