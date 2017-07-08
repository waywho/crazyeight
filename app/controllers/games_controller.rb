class GamesController < ApplicationController
	before_action :authenticate_user!

	def index
		games = current_user.games

		render json: games.as_json
	end
end
