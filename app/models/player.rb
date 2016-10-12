class Player < ApplicationRecord
    belongs_to :game
    serialize :mistakesArray,Array
end
