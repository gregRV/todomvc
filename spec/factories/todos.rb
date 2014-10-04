# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :valid_todo, :class => Todo do
  	title 'Some title'
  	body 'Some body'
  end
end
