class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :game, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :user_score
      t.json :hand

      t.timestamps
    end
  end
end
