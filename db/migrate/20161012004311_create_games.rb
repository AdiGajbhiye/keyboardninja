class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.text :wordsArray
      t.timestamps
    end

    create_table :players do |t|
      t.belongs_to :game, index: true
      t.string :name
      t.integer :userId
      t.integer :position
      t.text :mistakesArray
      t.text :attemptedArray
      t.float :wpm
      t.timestamps
    end

  end
end
