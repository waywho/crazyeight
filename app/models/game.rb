class Game < ApplicationRecord
  belongs_to :user
  has_many :players
  has_many :game_players, through: :players, source: :user
  validates :name, presence: true
  after_create :start_deck
  
  SUITS = [:hearts, :diamonds, :club, :spades]

	def start_deck
		cards = []
	  	ranks = ["ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "jack", "king", "queen"]
	  	suits = [:hearts, :diamonds, :club, :spades]
	  	ranks.each do |rank|
	  		suits.each do |suit|
	  			cards << Card.new(rank, suit)
	  		end
	  	end
		cards.shuffle!
		self.update_attributes(play_deck: cards)
	end

	def starter
		cards = self.play_deck
		card = cards.shift
		self.play_pile.nil? ? play_pile = [] : play_pile = self.play_pile
		until card['rank'] != 8
			cards.insert(rand(1..cards.length), card)
			cards.shuffle!
			card = cards.shift
		end
		play_pile << card
		self.update_attributes(play_deck: cards, play_pile: play_pile)
		return card
	end

	def deal
		card = self.play_deck.shift
		return card
	end

	def deal_hands
		self.players.each do |player|
			player_hand = []
			5.times {player_hand << self.play_deck.shift}
			player.update_attributes(hand: player_hand)
		end
	end

	def move_to_next_player
		current_player = self.current_player
		return_next_player = false
		self.players.each do |player|
			if return_next_player
				next_player = player
				break
			end

			if player.id == current_player
				return_next_player == true
			end
			set_current_player(next_player.id)
		end
	end

	def set_current_player(player_id)
		self.update_attributes(current_player: player.id)
	end

	def get_current_player
		self.current_player
	end

	def match?(card)
		if card["rank"] == 8
			return true
		else
			top_card = self.play_pile.first
			if card["suit"] == top_card["suit"] || card["rank"] == top_card["rank"]
				return true
			else
				return false
			end
		end
	end

	def win?(player)
		player.hand.nil?
		return true
	end
end
