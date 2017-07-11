class Game < ApplicationRecord
  belongs_to :user
  has_many :matches
  has_many :players, through: :matches, source: :user
  validates :name, presence: true

end
