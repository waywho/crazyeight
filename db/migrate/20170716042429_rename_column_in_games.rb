class RenameColumnInGames < ActiveRecord::Migration[5.0]
  def change
  	rename_column :games, :deck, :play_deck
  end
end
