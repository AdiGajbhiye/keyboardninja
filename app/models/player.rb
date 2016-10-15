class Player < ApplicationRecord
    belongs_to :game
    serialize :mistakesArray,Array

    def update (error_made, params = {})
        if (position < params[:position])
            position = params[:position]
            if error_made
                mistakesArray.push(params[:typedWord])
            end
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end
end
