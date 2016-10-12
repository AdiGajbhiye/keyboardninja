class Game < ApplicationRecord
  GAME_DURATION = 1.minutes
  has_many :players
  serialize :wordsArray,Array

  def current?
    now = DateTime.now
    created_at < now && now < (created_at + GAME_DURATION)
  end

  def finished?
    now = DateTime.now
    now > (created_at + GAME_DURATION)
  end

end
