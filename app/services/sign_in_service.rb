class SignInService
  class InvalidCredentials < StandardError; end

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def call
    user = User.find_by(email: @email)
    raise InvalidCredentials, 'Invalid credentials' unless user&.authenticate(@password)

    user.generate_jwt
  end
end
