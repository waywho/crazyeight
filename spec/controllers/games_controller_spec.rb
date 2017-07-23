require 'rails_helper'

RSpec.describe GamesController, type: :controller do
	describe "games#index action" do
		before do
			@user = FactoryGirl.create(:user)
			auth_headers = @user.create_new_auth_token
			request.headers.merge!(auth_headers)
		end
		it "should successfully respond" do
			get :index
			expect(response).to have_http_status(:success)
		end

		it "should return all the games in ascending order" do
			2.times do
				FactoryGirl.create(:game, user: @user)
			end
			get :index
			json = JSON.parse(response.body)
			expect(json[0]['id'] < json[1]['id']).to be true
		end
	end

	describe "game#join action" do
		before do
			@game = FactoryGirl.create(:game)
			@user = FactoryGirl.create(:user)
			auth_headers = @user.create_new_auth_token
			request.headers.merge!(auth_headers)	
		end

		it "should receive and update the game with the users in response" do
			user2 = FactoryGirl.create(:user)
			post :join, params: { id: @game.id, game: {player_id: user2.id} }

			json = JSON.parse(response.body)
			expect(json["game_players"][0]["id"]).to eq(user2.id)

		end
	end

	describe "games#show action" do
		before do
			@game = FactoryGirl.create(:game)
		end
		it "should successfully return a game" do
			@user = FactoryGirl.create(:user)
			auth_headers = @user.create_new_auth_token
			request.headers.merge!(auth_headers)	

			get :show, params: { id: @game.id }
			json = JSON.parse(response.body)
			expect(json['id']).to eq(@game.id)
		end

		it "should not let unauthorised user get a successsful response" do
			get :show, params: { id: @game.id }
			json = JSON.parse(response.body)

			expect(response).to have_http_status(:unauthorized)
		end

		it "should show http 404 if game is not found" do
			@user = FactoryGirl.create(:user)
			auth_headers = @user.create_new_auth_token
			request.headers.merge!(auth_headers)
			get :show, params: { id: "hello" }

			expect(response).to have_http_status(:not_found)
		end

		it "should render error messages if game is not found" do
			@user = FactoryGirl.create(:user)
			auth_headers = @user.create_new_auth_token
			request.headers.merge!(auth_headers)
			get :show, params: { id: "hello" }

			json = JSON.parse(response.body)
			expect(json["errors"]).to eq("Cannot find the game")
		end

	end

	describe "games#create action" do
		before do
			@user = FactoryGirl.create(:user)
			auth_headers = @user.create_new_auth_token
			request.headers.merge!(auth_headers)
			post :create, params: { game: { name: 'First'}}
		end
		it "should successfully create and save a new game by the sign-in user" do
			
			game = Game.last
			expect(game.name).to eq('First')
			expect(game.user_id).to eq(@user.id)
		end

		it "should return 200 status-code" do
			expect(response).to be_success
		end

		it "should return the created game in response body" do
			json = JSON.parse(response.body)

			expect(json['name']).to eq("First")
		end
	end

	describe "game#create validation" do
		it "should not let unauthorised user create game" do
			post :create, params: { game: { name: 'Test'}}

			json = JSON.parse(response.body)
			expect(response).to have_http_status(:unauthorized)
		end

		it "should properly deal with validation" do
			@user = FactoryGirl.create(:user)
			auth_headers = @user.create_new_auth_token
			request.headers.merge!(auth_headers)
			post :create, params: { game: { name: ''}}

			json = JSON.parse(response.body)
			expect(response).to have_http_status(:unprocessable_entity)
		end

		it "should return error json on validation error" do
			@user = FactoryGirl.create(:user)
			auth_headers = @user.create_new_auth_token
			request.headers.merge!(auth_headers)
			post :create, params: { game: { name: ''}}

			json = JSON.parse(response.body)
			expect(json["errors"]["name"][0]).to eq("can't be blank")
		end
	end

	describe "game#destroy action" do
		before do
			user1 = FactoryGirl.create(:user)
			@game = FactoryGirl.create(:game, user: user1)
		end
		it "should not let unauthorised user destroy game" do
			delete :destroy, params: { id: @game.id }

			expect(response).to have_http_status(:unauthorized)
		end

		it "should not let user who did not create the game destroy it" do
			user = FactoryGirl.create(:user)
			auth_headers = user.create_new_auth_token
			request.headers.merge!(auth_headers)

			delete :destroy, params: { id: @game.id }
			json = JSON.parse(response.body)
			expect(response).to have_http_status(:forbidden)
			expect(json["errors"]).to eq("you can't")
		end

		it "should render http 404 error if the game cannot be found" do
			user = FactoryGirl.create(:user)
			auth_headers = user.create_new_auth_token
			request.headers.merge!(auth_headers)

			delete :destroy, params: { id: "hello"}
			expect(response).to have_http_status(:not_found)
		end

		it "should render error message if the game cannot be found" do
			user = FactoryGirl.create(:user)
			auth_headers = user.create_new_auth_token
			request.headers.merge!(auth_headers)

			delete :destroy, params: { id: "hello"}

			json = JSON.parse(response.body)
			expect(json["errors"]).to eq("Cannot find the game")
		end

		it "should return no content when game is destroyed" do
			user = FactoryGirl.create(:user)
			game = FactoryGirl.create(:game, user: user)
			
			auth_headers = user.create_new_auth_token
			request.headers.merge!(auth_headers)

			delete :destroy, params: { id: game.id }
			expect(response).to have_http_status(:no_content)
		end
	end
end
