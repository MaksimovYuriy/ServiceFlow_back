class JwtService
    SECRET_KEY = Rails.application.secret_key_base
    
    def initialize(action, **data)
        @data = data
        @action = action
    end

    def call
        case @action
        when :encode
            encode
        when :decode
            decode
        else
            raise StandardError, 'Unknown jwt action'
        end
    end

    private

    def encode
        @data[:exp] = 12.hours.from_now.to_i
        JWT.encode(@data, SECRET_KEY)
    end

    def decode
        body = JWT.decode(@data[:token], SECRET_KEY)[0]
        HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature
        raise StandardError, 'Token has expired'
    rescue JWT::DecodeError
        raise StandardError, 'Invalid token'
    end
    
end