class UserResource < ApplicationResource
    attribute :email, :string
    attribute :phone, :string
    attribute :active, :boolean
    attribute :role, :string_enum, allow: User.roles.keys

    attribute :password, :string, writable: true, readable: false
    attribute :password_confirmation, :string, writable: true, readable: false
end
