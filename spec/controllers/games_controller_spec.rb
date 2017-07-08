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

	describe "game#create action" do
		it "should successfully create and save a new game by the sign-in user" do
			user = FactoryGirl.create(:user)
			auth_headers = user.create_new_auth_token
			request.headers.merge!(auth_headers)
			post :create, params: { game: { name: 'First'}}
			game = Game.last
			expect(game.name).to eq('First')
			expect(game.user_id).to eq(user.id)
		end
	end
end
