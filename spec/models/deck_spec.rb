require 'rails_helper'

RSpec.describe Deck, type: :model do

	before do
		@deck = Deck.new
	end

	it "should initialize a deck" do
		expect(@deck.cards.size).to eq(52)
	end

	it "should shuffle the card" do
		sorted_deck = Deck.new

		@deck.shuffle
		num = rand(0..52)

		expect(@deck.cards[num]).not_to eq(sorted_deck.cards[num])
	end
end
