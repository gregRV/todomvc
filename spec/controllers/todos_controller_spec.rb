require 'rails_helper'

RSpec.describe TodosController, :type => :controller do
	describe "#new" do
		it "renders the correct template" do
			user = FactoryGirl.create(:valid_user)
			get "new", {user_id: user.id}
			expect(response).to render_template("new")
		end

		it "assigns identifies the correct User" do
			user = FactoryGirl.create(:valid_user)
			get "new", {user_id: user.id}
			expect(assigns(:user).id).to eq(user.id)
		end

		it "assigns an empty instance of Todo" do
			user = FactoryGirl.create(:valid_user)
			get "new", {user_id: user.id}
			expect(assigns(:todo)).to be_a Todo
		end
	end

	describe "#create" do
		context "with valid todo info" do
			before(:each) do
				@user = FactoryGirl.create(:valid_user)
				#stubbing current_user helper method!
				allow(controller).to receive(:current_user) {@user}
			end

			#note how params are passed in this POST!
			subject {post "create", {user_id: @user.id, todo: FactoryGirl.attributes_for(:valid_todo)}}

			it "creates a new todo" do
				expect{subject}.to change(Todo, :count).by(1)
			end

			it "redirects to todos#show" do
				subject
				expect(response).to redirect_to(:action => :show, :id => assigns(:todo).id)
			end
		end

		context "with invalid todo info" do
			before(:each) do
				@user = FactoryGirl.create(:valid_user)
				allow(controller).to receive(:current_user) {@user}
			end

			subject {post "create", {user_id: @user.id, todo: FactoryGirl.attributes_for(:invalid_todo)}}

			it "does not create a new todo" do
				expect{subject}.not_to change(Todo, :count)
			end

			it "redirects to root path" do
				subject
				expect(response).to redirect_to(root_path)
			end
		end
	end
end
