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
			subject {post "create", user: FactoryGirl.attributes_for(:valid_user)}

			it "it creates a new user" do
				#use {} here instead of () because
				#subject represents a block
				expect{subject}.to change(User, :count).by(1)
			end

			it "redirects to user#show" do
				#kept following line because the spec
				#needs to refer to :user
				post "create", user: FactoryGirl.attributes_for(:valid_user)
				expect(response).to redirect_to(assigns(:user))
			end
		end

		context "with invalid info" do
			subject {post "create", user: FactoryGirl.attributes_for(:invalid_user)}
			it "does not create a new user" do
				expect{subject}.to_not change(User, :count)
			end

			it "renders user#new" do
				#tried using {} instead of () for  subject here
				#but error says must pass an argument rather than a block
				#for this matcher (render_template)
				expect(subject).to render_template("new")
			end
		end
	end

	describe "#show" do
		it "renders the show template" do
			user = FactoryGirl.create(:valid_user)
			get "show", id: user.id
			expect(response).to render_template("show")
		end
	end
end
