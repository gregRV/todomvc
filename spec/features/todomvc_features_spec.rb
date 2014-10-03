require 'rails_helper'

describe "the signup process" do
	describe "guest can sign up" do
		context "with valid info" do
			it "creates a new user" do
				visit new_user_path
				fill_in "Name", :with => "Alan"
				fill_in "Email", :with => "alan@test.com"
				fill_in "Password", :with => "alan"
				fill_in "Password Confirmation", :with => "alan"
				click_button "Submit"

				expect(page).to have_content("Hello Alan")
			end
		end

		context "with missing info" do
			it "does not create a new user without a name" do
				visit new_user_path
				fill_in "Name", :with => ""
				fill_in "Password", :with => "alan"
				fill_in "Password Confirmation", :with => "alan"

				expect{click_button "Submit"}.to_not change(User, :count)
			end
		end
	end
end