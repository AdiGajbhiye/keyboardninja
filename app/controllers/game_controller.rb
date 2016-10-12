class GameController < ApplicationController
    def new
        @game = Game.new
        @game.players.build(player_params)
        @game.save
    end

    def join
        @game = Game.find(game_params[:id])
        @player = Player.new(player_params)
        @game.players << @player
        @game.save
    end

    def delete
    end

    def getStatus
    end

    def postPosition
    end

    def getResult
    end

    def player_params
        params.require(:game).permit(:name)
    end

    def game_params
        params.require(:game).permit(:id)
    end
end
