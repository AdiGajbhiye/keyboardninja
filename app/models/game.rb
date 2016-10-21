class Game < ApplicationRecord
  has_many :players
  serialize :wordsArray,Array

  def timeSinceCreate
    ((Time.now().to_i - self.created_at.to_time.to_i - + KeyboardNinja::PRE_GAME_WAIT.to_i))
  end

  def current?
    now = DateTime.now
    self.created_at < now && now < (self.created_at + KeyboardNinja::GAME_DURATION + KeyboardNinja::PRE_GAME_WAIT)
  end

  def finished?
    now = DateTime.now
    now > (self.created_at + KeyboardNinja::GAME_DURATION + KeyboardNinja::PRE_GAME_WAIT)
  end

  def status
    array = self.players.collect do |player|
      hash = { :name => player.name, :position => player.attemptedArray.size, :errors => player.mistakesArray.size } 
    end
    array = array.sort_by { |k| k[:name] }
    { :players => array, :timeSinceCreate => timeSinceCreate}
  end

  def result
    array = self.players.collect do |player|
      player.calculateWpm
      hash = { :name => player.name, :position => -1, :errors => player.mistakesArray.size, :wpm => player.wpm }
    end
    array = array.sort_by { |k| k[:wpm] }
    array = array.reverse
    array.each_with_index do | item, index |
      item[:position] = index
    end
  end

end
