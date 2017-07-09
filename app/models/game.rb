class Game < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :players, class_name: "User", foreign_key: "player_id"
  validates :name, presence: true

end
