class Card
	attr_accessor :rank, :suit

	def initialize(rank, suit)
		@rank = rank
		@suit = suit
	end

	def display_card
		"#{self.rank} of #{self.suit}"
	end
end
