require 'rails_helper'

RSpec.describe GamesController, type: :controller do
	before do
		user = FactoryGirl.create(:user)
		auth_headers = user.create_new_auth_token
		request.headers.merge!(auth_headers)
	end
	describe "games#index action" do
		it "should successful show the page" do
			
			get :index
			expect(response).to have_http_status(:success)
		end

		# it "should return all the games in ascending order" do
		# 	FactoryGirl.create_list(:game, 2)
		# 	get :index
		# 	json = JSON.parse(response.body)

		# 	expect(json[0]['id'] < json[1]['id']).to be true
		# end
	end

end
