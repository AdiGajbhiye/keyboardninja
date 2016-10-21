class Player < ApplicationRecord
    belongs_to :game
    serialize :mistakesArray,Array
    serialize :attemptedArray,Array

    def update (error_made, params = {})
        if error_made
            self.mistakesArray.push(params[:position])
        end
        self.save
    end

    def calculateWpm
        self.wpm = ( self.attemptedArray.size - self.mistakesArray.size ) / KeyboardNinja::GAME_DURATION.to_f * 60
        self.save
    end
end
