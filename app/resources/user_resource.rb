class UserResource < ApplicationResource
    attribute :email, :string
    attribute :phone, :string
    attribute :active, :boolean

    attribute :password, :string, writable: true, readable: false
    attribute :password_confirmation, :string, writable: true, readable: false
end
