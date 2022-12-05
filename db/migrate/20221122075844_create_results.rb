class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.references :fixture, foreign_key: true
      t.integer :home_goals
      t.integer :away_goals

      t.timestamps
    end
  end
end
