require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
	describe "#current_user" do
		context "if session exists" do
			it "returns the current user" do
				user = FactoryGirl.create(:valid_user)
				session[:user_id] = user.id
				#calling current_user method on controller!
				controller.send(:current_user)
				expect(assigns(:current_user)).to be_a(User)
			end
		end

		context "if session does not exist" do
			it "returns nil" do
				controller.send(:current_user)
				expect(assigns(:current_user)).to be_nil
			end
		end
	end
end