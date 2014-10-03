FactoryGirl.define do
	factory :valid_user, :class => User do
		name 'Alan'
		email 'alan@test.com'
		password 'alan'
		password_confirmation 'alan'
	end

	factory :invalid_user, :class => User do
		name ''
		email 'bob@test.com'
		password 'bob'
		password_confirmation 'bob'
	end
end