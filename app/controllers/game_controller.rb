class GameController < ApplicationController
    HTTP_FORBIDDEN = "403"
    def new
        @game = Game.new
        @game.wordsArray = ['Am', 'increasing', 'at', 'contrasted', 'in', 'favourable', 'he', 'considered', 'astonished.', 'As', 'if', 'made', 'held', 'in', 'an', 'shot.', 'By', 'it', 'enough', 'to', 'valley', 'desire', 'do.', 'Mrs', 'chief', 'great', 'maids', 'these', 'which', 'are', 'ham', 'match', 'she.', 'Abode', 'to', 'tried', 'do', 'thing', 'maids.', 'Doubtful', 'disposed', 'returned', 'rejoiced', 'to', 'dashwood', 'is', 'so', 'up.']
        @game.players.build(player_params)
        if @game.save
            redirect_to '/game/' + @game[:id].to_s
        end
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

    def show
        @game = Game.find(params[:id])
    end

    private
        def player_params
            params.require(:game).permit(:name)
        end

        def game_params
            params.require(:game).permit(:id)
        end

end
