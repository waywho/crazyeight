class Deck
	attr_accessor :cards

	def initialize
	  	@cards = []
	  	ranks = ["ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "jack", "king", "queen"]
	  	suits = [:hearts, :diamonds, :club, :spades]
	  	ranks.each do |rank|
	  		suits.each do |suit|
	  			@cards << Card.new(rank, suit)
	  		end
	  	end
	  	return @cards
	end

	def shuffle
		self.cards.shuffle!
	end

	def show_cards
		self.cards.each {|x| puts x.display_card}
	end

end
