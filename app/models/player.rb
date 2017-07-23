class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  def show_hand
  	self.hand.each do |card|
  		card.display_card
  	end
  end

  def play_card(index, declare_suit=nil)
  	# hand = self.hand
    card = self.hand.fetch(index)

  	if card["rank"] == 8
      self.hand.delete_at(index)
      card["suit"] = declare_suit
  		self.add_to_play_pile(card)
  		self.game.move_to_next_player
  	elsif self.game.match?(card)
      self.hand.delete_at(index)
	  	self.add_to_play_pile(card)
      self.game.move_to_next_player
	  else
	  		return false, "Sorry, card doesn't match, can't play this card"
    end
  end

  def pick_from_deck
  	card = self.game.deal
  	add_to_hand(card)
  end

  def add_to_play_pile(card)
  	self.game.play_pile.unshift(card)
  end

  def add_to_hand(card)
  	self.hand.push(card)
  	return true
  end
end
