class CreateFixtures < ActiveRecord::Migration[5.1]
  def change
    create_table :fixtures do |t|
      t.references :round, foreign_key: true
      t.date :date
      t.references :session, foreign_key: true
      t.integer :home_id, foreign_key: true
      t.integer :away_id, foreign_key: true
      t.references :channel, foreign_key: true
      t.references :criterium, foreign_key: true, default: 1

      t.timestamps
    end
  end
end
