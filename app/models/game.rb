class Game < ApplicationRecord
  has_many :players
  serialize :wordsArray,Array
end
