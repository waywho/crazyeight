class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  def show_hand
  	self.hand.each do |card|
  		card.display_card
  	end
  end

  def play_card(index, declare_suit=nil)
  	card = self.hand.fetch(index)
  	hand = self.hand.delete_at(index)

  	if card.rank == 8
  		add_to_play_pile(card)
  		@declare_suit = declare_suit
  		return true
  	else
	  	if self.game.match?(card)
	  		card.display_card
	  		self.hand.update_attributes(hand: hand)
	  		add_to_play_pile(card)
	  		return true
	  	else
	  		return false
	  	end
	 end
  end

  def pick_from_deck
  	card = self.game.deal
  	add_to_hand(card)
  end

  def add_to_play_pile(card)
  	new_pile = self.game.play_pile.unshift(card)
  	self.game.update_attributes(play_pile: new_pile)
  	return true
  end

  def add_to_hand(card)
  	new_hand = self.hand << card
  	self.update_attributes(hand: new_hand)
  	return true
  end
end
