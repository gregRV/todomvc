require 'rails_helper'

RSpec.describe TodosController, :type => :controller do
	#do not place lets or subjects in before hooks, it'd be redundant!
	let(:user) { FactoryGirl.create(:valid_user) }
	let(:todo) { FactoryGirl.create(:valid_todo, user_id: user.id) }

	describe "#new" do
		subject { get "new", {user_id: user.id} }

		before(:each) do
			subject
		end

		it "renders the correct template" do
			expect(response).to render_template("new")
		end

		it "assigns identifies the correct User" do
			expect(assigns(:user).id).to eq(user.id)
		end

		it "assigns an empty instance of Todo" do
			expect(assigns(:todo)).to be_a Todo
		end
	end

	describe "#create" do
		before(:each) do
			#stubbing current_user helper method!
			allow(controller).to receive(:current_user) {user}
		end

		context "with valid todo info" do
			#note how params are passed in this POST!
			subject {post "create", {user_id: user.id, todo: FactoryGirl.attributes_for(:valid_todo)}}

			it "creates a new todo" do
				expect{subject}.to change(Todo, :count).by(1)
			end

			it "redirects to todos#show" do
				subject
				expect(response).to redirect_to(:action => :show, :id => assigns(:todo).id)
			end
		end

		context "with invalid todo info" do
			subject {post "create", {user_id: user.id, todo: FactoryGirl.attributes_for(:invalid_todo)}}

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
		subject {get "edit", {user_id: user.id, id: todo.id}}

		context "with valid info" do
			it "renders edit template" do
				#dont forget to stub current_user!
				allow(controller).to receive(:current_user) {user}
				subject
				expect(response).to render_template("edit")
			end

			it "finds the correct todo" do
				subject
				expect(assigns(:todo).id).to eq(todo.id)
			end
		end

		context "with invalid info" do
			before(:each) do
				allow(controller).to receive(:current_user) {nil}
				subject
			end

			it "redirects to todo#show" do
				expect(response).to redirect_to(:action => :show, :user_id => user.id, :id => todo.id)
			end

			it "displays a notice unless logged in" do
				expect(flash[:notice]).to have_content("Access forbidden")
			end
		end
	end

	describe "#update" do
		subject { patch "update", {user_id: user.id, id: todo.id, todo: {title: 'Updated Title'}} }

		context "with valid info" do
			it "updates the todo" do
				expect{
					subject
					#make sure to #reload so changes are saved!
					todo.reload
				}.to change(todo, :title).to("Updated Title")
			end

			it "redirects to todo#show" do
				subject
				#NEED TO CALL redirect_to ON response!! If called on above line as 'subject'
				#will give error "Expected response to be a <redirect>, but was <200>"
				expect(response).to redirect_to(:action => :show, user_id: user.id, :id => todo.id)
			end
		end
	end
end
