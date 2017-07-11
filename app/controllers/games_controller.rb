class GamesController < ApplicationController
	before_action :authenticate_user!

	def index
		games = current_user.games

		render json: games.as_json
	end

	def show
		game = Game.find_by_id(params[:id])
		return render json: render_errors("Cannot find the game"), status: :not_found if game.blank?
		
		render json: game.as_json
	end

	def create
		game = current_user.games.create(game_params)

		if game.valid?
			render json: game, status: :created
		else
			render json: render_errors(game.errors), status: :unprocessable_entity
		end
	end

	def destroy
		game = Game.find_by_id(params[:id])
		return render json: render_errors("Cannot find the game"), status: :not_found if game.blank?
		return render json: render_errors("you can't"), status: :forbidden if game.user != current_user

		game.destroy
		head :no_content
	end

	private

	def game_params
		params.required(:game).permit(:name)
	end

	def render_errors(errors)
		{ errors: errors }
	end

end
