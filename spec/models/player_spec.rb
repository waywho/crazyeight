require 'rails_helper'

RSpec.describe Player, type: :model do

	before do
		user = FactoryGirl.create(:user)
		@game = FactoryGirl.create(:game, user: user)
		players = FactoryGirl.create_list(:user, 3)

		players.each do |user|
			FactoryGirl.create(:player, game: @game, user: user)
		end
		@game.deal_hands
		@game.starter
	end

	it "should play the card from the hand the user picked to play" do
		# puts @game.play_pile.first["rank"]
		player = @game.players.first
		player_hand = player.hand.length

		if player.play_card(4)
			expect(player.hand.length < player_hand).to be true
		else
			expect(player.hand.length == player_hand).to be true
		end
	end

	it "should add played card to play pile if match" do
		# puts @game.play_pile.first["rank"]
		@game.starter
		player = @game.players.first
		pile_length = player.game.play_pile.length

		if player.play_card(2)
			expect(player.game.play_pile.length > pile_length).to be true
		else
			expect(player.game.play_pile.length == pile_length).to be true
		end
	end

	it "should allow player to play any 8 card and declare a suit" do
		@game.starter

		
	end
end
