require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
	describe "#new" do
		it "renders the correct view" do
			get "new"
			expect(response).to render_template("new")
		end
	end

	describe "#create" do
		context "with valid user info" do
			before(:each) do
				@user = FactoryGirl.create(:valid_user)
				post "create", email: @user.email, password: @user.password
			end

			it "creates a new session" do
				expect(session[:user_id]).not_to be_nil
			end

			it "redirects to root path" do
				expect(response).to redirect_to("/")
			end

			it "displays a notice" do
				expect(flash[:notice]).to have_content("Successfully logged in")
			end
		end

		context "with invalid user info" do
			before(:each) do
				post "create", email: '', password: ''
			end

			it "redirects to new session path" do
				expect(response).to redirect_to("/sessions/new")
			end

			it "displays a notice" do
				expect(flash[:notice]).to have_content("Login failed")
			end
		end
	end

	describe "#destroy" do
		before(:each) do
			#first hash is params, second is session
			delete "destroy", { id: 1 }, { user_id: 2 }
		end
		it "sets session[:user_id] to nil" do
			expect(session[:user_id]).to be_nil
		end

		it "redirects to root path" do
			expect(response).to redirect_to("/")
		end
	end
end