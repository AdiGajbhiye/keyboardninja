class Game < ApplicationRecord
  has_many :players
  serialize :wordsArray,Array

  def timeSinceCreate
    ((DateTime.now - created_at) * 24 * 60 * 60).to_i
  end

  def current?
    now = DateTime.now
    created_at < now && now < (created_at + KeyboardNinja::GAME_DURATION)
  end

  def finished?
    now = DateTime.now
    now > (created_at + KeyboardNinja::GAME_DURATION)
  end

  def status
    if current?
      array = players.collect do |player|
        hash = { :name => player.name, :position => player.position, :errors => player.mistakesArray.size } 
      end
    else
      raise KeyboardNinja::HTTP_FORBIDDEN
    end
    { :players => array, :timeSinceCreate => timeSinceCreate}
  end

  def result
    if finished?
      array = players.collect do |player|
        total_words_typed = player.position + 1
        player.wpm =  ( total_words_typed - player.mistakesArray.size ) / KeyboardNinja::GAME_DURATION
        hash = { :name => player.name, :position => player.position, :errors => player.mistakesArray.size, :wpm => player.wpm } 
      end
    else
      raise KeyboardNinja::HTTP_FORBIDDEN
    end
  end

  def check_made(params = {})
    wordsArray[params[:position]] == params[:typedWord]
  end
end
