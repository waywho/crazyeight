class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.json :deck

      t.timestamps
    end
  end
end
