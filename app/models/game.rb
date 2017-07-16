class Game < ApplicationRecord
  belongs_to :user
  has_many :players
  has_many :game_players, through: :players, source: :user
  validates :name, presence: true
  after_create :start_deck

  SUITS = [:hearts, :diamonds, :club, :spades]

	def start_deck
		cards = Deck.new
		cards.shuffle
		self.update_attributes(deck: cards)
	end

	def starter
		cards = self.play_deck
		card = cards.shift
		until card.rank != 8
			cards.insert(rand(1..cards.length), card)
			cards.shuffle
			card = cards.shift
		end
		self.update_attributes(deck: cards)
	end

	def deal
		cards = self.play_deck
		card = cards.shift
		self.update_attributes(deck: cards)
		return card
	end

	def deal_hands
		self.players.each do |player|
			player_hand = []
			5.times {player_hand << self.deal}
			player.update_attributes(hand: player_hand)
		end
	end

	def match?(card)
		if card.rank == 8
			return true
		else
			top_card = self.play_pile.first
			if card.suit == top_card.suit || card.rank == top_card.rank
				return true
			else
				return false
			end
		end
	end
end
