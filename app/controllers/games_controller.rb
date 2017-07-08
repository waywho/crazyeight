class GamesController < ApplicationController
	before_action :authenticate_user!

	def index
		games = current_user.games

		render json: games.as_json
	end

	def create
		game = current_user.games.create(game_params)
	end

	private

	def game_params
		params.required(:game).permit(:name)
	end
end
