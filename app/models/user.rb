class User < ActiveRecord::Base
	validates :name, :email, presence: true

	has_many :todos

	has_secure_password
end
