require 'rails_helper'

RSpec.describe Game, type: :model do
	before do
		@user = FactoryGirl.create(:user)
		@game = FactoryGirl.create(:game, user: @user)
	end
	
	it "should add a new deck after a new game is created" do
		expect(@game.play_deck.nil?).to eq(false)
	end

	it "should add a starter card into a play pile" do
		card = @game.starter
		starter_pile = @game.play_pile
		expect(starter_pile.nil?).to eq(false)
	end

	it "should put out a starter card that is not ranked 8" do
		card = @game.starter
		expect(card["rank"]).not_to eq(8)
	end

	it "should deal a hand of 5 cards to all players" do
		users = FactoryGirl.create_list(:user, 3)

		users.each do |user|
			FactoryGirl.create(:player, game: @game, user: user)
		end

		@game.deal_hands

		@game.players.each_with_index do |player, index|
			expect(player.hand.count).to eq(5)
		end
	end

	it "should have the remaining deck stored" do
		users = FactoryGirl.create_list(:user, 3)

		users.each do |user|
			FactoryGirl.create(:player, game: @game, user: user)
		end

		@game.deal_hands

		dealt_cards = users.length * 5

		expect(@game.play_deck.length).to eq(52 - dealt_cards)
	end
end
