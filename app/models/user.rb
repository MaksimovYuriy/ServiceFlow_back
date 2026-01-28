class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  def generate_jwt
    JwtService.encode(id: id, email: email, phone: phone, active: active)
  end

  def self.from_jwt(token)
    payload = JwtService.decode_silent(token)
    find(payload[:id]) if payload
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end 
end