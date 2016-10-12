class GameController < ApplicationController
    HTTP_FORBIDDEN = "403"
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

    def status
        @game = Game.find(params[:id])
        if @game.current?
            render json: @game
        else
            raise HTTP_FORBIDDEN
        end
    end

    def update
    end

    def result
        @game = Game.find(params[:id])
        if @game.finished?
            render json: @game
        else
            raise HTTP_FORBIDDEN
        end
    end

    def player_params
        params.require(:game).permit(:name)
    end

    def game_params
        params.require(:game).permit(:id)
    end
end
