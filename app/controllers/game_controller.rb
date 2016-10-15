class GameController < ApplicationController

    def new
        @game = Game.new
        @game.wordsArray = ['Am', 'increasing', 'at', 'contrasted', 'in', 'favourable', 'he', 'considered', 'astonished.', 'As', 'if', 'made', 'held', 'in', 'an', 'shot.', 'By', 'it', 'enough', 'to', 'valley', 'desire', 'do.', 'Mrs', 'chief', 'great', 'maids', 'these', 'which', 'are', 'ham', 'match', 'she.', 'Abode', 'to', 'tried', 'do', 'thing', 'maids.', 'Doubtful', 'disposed', 'returned', 'rejoiced', 'to', 'dashwood', 'is', 'so', 'up.']
        @game.players.build(player_params)
        if @game.save
            redirect_to '/game/' + @game[:id].to_s
        end
    end

    def join
        @game = Game.find(game_params[:game_id])
        if involved_in_game?
            redirect_to '/game/' + @game[:id].to_s
        else
            @player = Player.new(player_params)
            @game.players << @player
            if @game.save
                redirect_to '/game/' + @game[:id].to_s
            end
        end
    end

    def delete
    end

    def status
        @game = Game.find(params[:id])
        if involved_in_game?
            render json: @game.status
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end

    def update
        @game = Game.find(params[:id])
        if involved_in_game?
            @game.players each do |player|
                if player.userId == get_user_id
                    player.update(@game.check_made?, game_params)
                end
            end
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end

    def result
        @game = Game.find(params[:id])
        if involved_in_game?
            render json: @game.result
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end

    def show
        @game = Game.find(params[:id])
        if (involved_in_game? && @game.current?)
            @timeSinceCreate = @game.timeSinceCreate
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end

    private
        def player_params
            params.require(:game).require(:name)
            { :name => params[:game][:name], :userId => get_user_id, :position => 0, :wpm => 0.0, :mistakesArray=> [] }
        end

        def game_params
            params.require(:game).require(:game_id)
        end

        def update_params
            params.require(:position).require(:typedWord)
        end

        def get_user_id
            session[:userId]
        end

        def involved_in_game?
            @game.players.any? { |player| player.userId == get_user_id}
        end
end
