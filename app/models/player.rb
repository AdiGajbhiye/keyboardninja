class Player < ApplicationRecord
    belongs_to :game
    serialize :mistakesArray,Array

    def update (error_made, params = {})
        if (self.position == params[:position].to_i)
            logger.debug self.position
            logger.debug params[:position]
            self.position=self.position+1.0
            if error_made
                self.mistakesArray.push(params[:position])
                logger.debug self.mistakesArray
            end
            self.save
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end

    def calculateWpm
        self.wpm = ( self.position - self.mistakesArray.size ) / KeyboardNinja::GAME_DURATION.to_f * 60
        self.save
    end
end
