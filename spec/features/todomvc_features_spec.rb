require 'rails_helper'

describe "the signup process" do
	describe "guest can sign up" do
		context "with valid info" do
			it "creates a new user" do
				visit new_user_path
				fill_in "Name", :with => "Alan"
				fill_in "Password", :with => "alan"
				fill_in "Password Confirmation", :with => "alan"
				click_button "Submit"

				expect(page).to have_content("Hello Alan")
			end
		end 
	end
end