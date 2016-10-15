class Game < ApplicationRecord
  has_many :players
  serialize :wordsArray,Array

  def timeSinceCreate
    ((Time.now().to_i - created_at.to_time.to_i - + KeyboardNinja::PRE_GAME_WAIT.to_i))
  end

  def current?
    now = DateTime.now
    created_at < now && now < (created_at + KeyboardNinja::GAME_DURATION + KeyboardNinja::PRE_GAME_WAIT)
  end

  def finished?
    now = DateTime.now
    now > (created_at + KeyboardNinja::GAME_DURATION + KeyboardNinja::PRE_GAME_WAIT)
  end

  def status
    array = players.collect do |player|
      hash = { :name => player.name, :position => player.position, :errors => player.mistakesArray.size } 
    end
    { :players => array, :timeSinceCreate => timeSinceCreate}
  end

  def result
    array = players.collect do |player|
      total_words_typed = player.position + 1
      player.wpm =  ( total_words_typed - player.mistakesArray.size ) / KeyboardNinja::GAME_DURATION
      hash = { :name => player.name, :position => player.position, :errors => player.mistakesArray.size, :wpm => player.wpm } 
    end
  end

  def check_made(params = {})
    wordsArray[params[:position]] == params[:typedWord]
  end
end
