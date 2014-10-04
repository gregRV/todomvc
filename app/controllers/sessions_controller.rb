class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to root_path, notice: "Successfully logged in"
		else
			redirect_to new_session_path, notice: "Login failed"
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path, notice: "Logged out"
	end
end
