class JwtService
  SECRET_KEY = Rails.application.secret_key_base
  ALGORITHM = 'HS256'.freeze
  DEFAULT_EXPIRY = 12.hours
  
  class << self
    def encode(**data)
      data[:exp] = DEFAULT_EXPIRY.from_now.to_i
      JWT.encode(data, SECRET_KEY, ALGORITHM)
    end
    
    def decode(token)
      return nil if token.blank?
      
      begin
        body = JWT.decode(
          token, 
          SECRET_KEY, 
          true, 
          { algorithm: ALGORITHM }
        )[0]
        
        HashWithIndifferentAccess.new(body)
      rescue JWT::ExpiredSignature
        raise StandardError, 'Token has expired'
      rescue JWT::DecodeError
        raise StandardError, 'Invalid token'
      end
    end
    
    def decode_silent(token)
      return nil if token.blank?
      
      begin
        body = JWT.decode(
          token,
          SECRET_KEY,
          true,
          { algorithm: ALGORITHM }
        )[0]
        
        HashWithIndifferentAccess.new(body)
      rescue
        nil
      end
    end
  end
end