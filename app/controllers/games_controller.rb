class GamesController < ApplicationController
	before_action :authenticate_user!

	def index
		games = current_user.games

		render json: games.as_json
	end

	def create
		game = current_user.games.create(game_params)

		if user_signed_in?
			if game.valid?
				render json: game, status: :created
			else
				render json: render_errors(game), status: :unprocessable_entity
			end
		else
			render json: render_errors(game)
		end
	end

	private

	def game_params
		params.required(:game).permit(:name)
	end

	def render_errors(game)
		{ errors: game.errors }
	end
end
