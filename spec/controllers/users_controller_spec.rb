require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
	describe "#new" do
		before(:each) do
			get "new"
		end

		it "renders the 'new' template" do
			expect(response).to render_template("new")
		end

		it "assigns a new instance of User" do
			expect(assigns(:user)).to be_instance_of(User)
		end
	end

	describe "#create" do
		context "with valid info" do
			subject {post "create", user: {name: 'Alan', email: 'alan@test.com', password: 'alan', password_confirmation: 'alan'}}

			it "it creates a new user" do
				#use {} here instead of () because
				#subject represents a block
				expect{subject}.to change(User, :count).by(1)
			end

			it "redirects to user#show" do
				#kept following line because the spec
				#needs to refer to :user
				post "create", user: {name: 'Alan', email: 'alan@test.com', password: 'alan', password_confirmation: 'alan'}
				expect(response).to redirect_to(assigns(:user))
			end
		end

		context "with invalid info" do
			subject {post "create", user: {name: '', email: 'alan@test.com', password: 'alan', password_confirmation: 'alan'}}
			it "does not create a new user" do
				expect{subject}.to_not change(User, :count)
			end

			it "renders user#new" do
				expect(subject).to render_template("new")
			end
		end
	end

	describe "#show" do
		it "renders the show template" do
			user = User.create(name: 'alan', email: 'alan@test.com', password: 'alan', password_confirmation: 'alan')
			get "show", id: user.id
			expect(response).to render_template("show")
		end
	end
end
