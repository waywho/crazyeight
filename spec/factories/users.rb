FactoryGirl.define do
	factory :user do
		sequence :email do |n|
			"dummyEmail#{n}@gmail.com"
		end
		password "secretPassword"
		password_confirmation "secretPassword"
	end

	factory :admin, class: User do
	    email "adminEmail@gmail.com"
	    password "secretPassword"
	    password_confirmation "secretPassword"
	    admin true
	end
end