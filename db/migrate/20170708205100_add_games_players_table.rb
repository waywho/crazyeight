class AddGamesPlayersTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :games_players do |t|
  		t.belongs_to :games, index: true
  		t.integer :player_id, index: true
  	end
  end
end
