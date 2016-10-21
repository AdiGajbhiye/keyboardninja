class GameController < ApplicationController

    def new
        cookies.permanent[:username] = params[:game][:name]
        @game = Game.new
        text_corpus = (I18n.t 'text_corpus').strip.split(" ")
        start_index = rand(text_corpus.size-401)
        @game.wordsArray = text_corpus[start_index, start_index+400]
        @game.players.build(player_params)
        if @game.save
            redirect_to '/game/' + @game[:id].to_s
        end
    end

    def join
        @game = Game.find(game_params[:game_id].to_i)
        cookies.permanent[:username] = params[:game][:name]
        if @game.current?
            if involved_in_game?
                redirect_to '/game/' + @game[:id].to_s
            else
                @player = Player.new(player_params)
                @game.players << @player
                if @game.save
                    redirect_to '/game/' + @game[:id].to_s
                end
            end
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end

    def delete
    end

    def status
        @game = Game.find(params[:id])
        if (involved_in_game? && @game.current?)
            render json: @game.status
        else
            render :nothing => true, :status => 303
            return
        end
    end

    def update
        @game = Game.find(params[:id])
        if (involved_in_game? && @game.current?)
            @game.players.each do |player|
                if player.userId == get_user_id
                    if (!player.attemptedArray.include?(update_params[:position]))
                        player.attemptedArray.push(update_params[:position])
                        error_made = @game.wordsArray[update_params[:position].to_i]+";" != update_params[:typedWord]
                        player.update(error_made, update_params)
                    else
                        raise KeyboardNinja::HTTP_FORBIDDEN
                    end
                end
            end
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end

    def result
        @game = Game.find(params[:id])
        if involved_in_game? && @game.finished?
            @result = @game.result.to_json
        else
            raise KeyboardNinja::HTTP_FORBIDDEN
        end
    end

    def show
        @game = Game.find(params[:id])
        if (involved_in_game? && @game.current?)
            @timeSinceCreate = @game.timeSinceCreate
            @game.players.each do |player|
                if player.userId == get_user_id
                    @current_player_position = player.attemptedArray.size
                    @current_player_mistakes = player.mistakesArray
                end
            end
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
            params.require(:game).require(:name)
            params.require(:game).require(:game_id)
            { :name => params[:game][:name], :game_id => params[:game][:game_id]}
        end

        def update_params
            params.require(:position)
            params.require(:typedWord)
            { :position => params[:position], :typedWord => params[:typedWord] }
        end

        def get_user_id
            session[:userId]
        end

        def involved_in_game?
            @game.players.any? { |player| player.userId == get_user_id}
        end
end
