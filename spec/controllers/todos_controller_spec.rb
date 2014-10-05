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

	describe "#edit" do
		it "renders edit template" do
			user = FactoryGirl.create(:valid_user)
			todo = FactoryGirl.create(:valid_todo, user_id: user.id)
			#dont forget to stub current_user!
			allow(controller).to receive(:current_user) {user}
			get "edit", {user_id: user.id, id: todo.id}
			expect(response).to render_template("edit")
		end

		it "finds the correct todo" do
			user = FactoryGirl.create(:valid_user)
			todo = FactoryGirl.create(:valid_todo, user_id: user.id)
			get "edit", {user_id: user.id, id: todo.id}
			expect(assigns(:todo).id).to eq(todo.id)
		end

		it "redirects to todo#show" do
			user = FactoryGirl.create(:valid_user)
			todo = FactoryGirl.create(:valid_todo, user_id: user.id)
			allow(controller).to receive(:current_user) {nil}
			get "edit", {user_id: user.id, id: todo.id}
			expect(response).to redirect_to(:action => :show, :user_id => user.id, :id => todo.id)
		end

		it "displays a notice unless logged in" do
			user = FactoryGirl.create(:valid_user)
			todo = FactoryGirl.create(:valid_todo, user_id: user.id)
			allow(controller).to receive(:current_user) {nil}
			get "edit", {user_id: user.id, id: todo.id}
			expect(flash[:notice]).to have_content("Access forbidden")
		end
	end

	describe "#update" do
		context "with valid info" do
			it "updates the todo" do
				user = FactoryGirl.create(:valid_user)
				todo = FactoryGirl.create(:valid_todo, user_id: user.id)
				expect{
					patch "update", {user_id: user.id, id: todo.id, todo: {title: 'Updated Title'}}
					todo.reload
				}.to change(todo, :title).to("Updated Title")
			end

			it "redirects to todo#show" do
				user = FactoryGirl.create(:valid_user)
				todo = FactoryGirl.create(:valid_todo, user_id: user.id)
				patch "update", {user_id: user.id, id: todo.id, todo: {title: 'Updated Title'}}
				#NEED TO CALL redirect_to ON response!! If called on above line as 'subject'
				#will give error "Expected response to be a <redirect>, but was <200>"
				expect(response).to redirect_to(:action => :show, user_id: user.id, :id => todo.id)
			end
		end
	end
end
