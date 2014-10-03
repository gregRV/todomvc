require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
	describe "#new" do
		it "renders the 'new' template" do
			get "new"
			expect(response).to render_template("new")
		end

		it "assigns a new instance of User" do
			get "new"
			expect(assigns(:user)).to be_instance_of(User)
		end
	end

	describe "#create" do
		context "with valid info" do
			it "it creates a new user" do
			expect {
				post "create", user: {name: 'Alan', email: 'alan@test.com', password: 'alan', password_confirmation: 'alan'}
				}.to change(User, :count).by(1)
			end

			it "redirects to user#show" do
				post "create", user: {name: 'Alan', email: 'alan@test.com', password: 'alan', password_confirmation: 'alan'}
				expect(response).to redirect_to(assigns(:user))
			end
		end

		context "with invalid info" do
			it "does not create a new user" do
				expect {
					post "create", user: {name: '', email: 'alan@test.com', password: 'alan', password_confirmation: 'alan'}
				}.to_not change(User, :count)
			end

			it "renders user#new" do
				post "create", user: {name: '', email: 'alan@test.com', password: 'alan', password_confirmation: 'alan'}
				expect(response).to render_template("new")
			end
		end
	end
end
