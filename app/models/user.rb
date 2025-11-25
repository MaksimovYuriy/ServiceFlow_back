class User < ApplicationRecord
    has_secure_password

    validates :email, presence: true, uniqueness: true

    def generate_jwt
        JwtService.new(:encode, id: id, email: email, phone: phone, active: active).call
    end

    def self.from_jwt(token)
        payload = JwtService.new(:decode, token: token).call
        find(payload[:id]) if payload
    end

    private

    def downcase_email
        self.email = email.downcase_email if email.present?
    end 
end
