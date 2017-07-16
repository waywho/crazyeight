class AddColumnToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :play_pile, :json
  end
end
