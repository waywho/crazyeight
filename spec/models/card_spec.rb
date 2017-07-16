require 'rails_helper'

RSpec.describe Card, type: :model do
	before do
		@card = Card.new(8, :heart)
	end

	it "should create instance card" do
		expect(@card.rank).to eq(8)
		expect(@card.suit).to eq(:heart)
	end

	it "should show card" do
		string = @card.display_card

		expect(string).to eq("8 of heart")
	end
end
