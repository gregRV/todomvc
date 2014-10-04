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
			it "creates a new todo" do
				user = FactoryGirl.create(:valid_user)
				#stubbing current_user helper method!
				allow(controller).to receive(:current_user) {user}
				#note how params are passed in this POST!
				expect{
					post "create", {user_id: user.id, todo: {title: 'First Title', body: 'First Todo'}}
				}.to change(Todo, :count).by(1)
			end

			it "redirects to todos#show" do
				user = FactoryGirl.create(:valid_user)
				#stubbing current_user helper method!
				allow(controller).to receive(:current_user) {user}
				#note how params are passed in this POST!
				post "create", {user_id: user.id, todo: {title: 'First Title', body: 'First Todo'}}
				expect(response).to redirect_to(:action => :show, :id => assigns(:todo).id)
			end
		end
	end
end
