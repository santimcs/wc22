class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :group
      t.integer :ranking
      t.string :flag

    end
    add_index :teams, :name, unique: true  

  end
end
