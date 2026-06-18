class AddYearToTables < ActiveRecord::Migration[5.1]
  def change
    # Add year to teams
    add_column :teams, :year, :integer, default: 2022, null: false
    add_index :teams, [:year, :group]
    add_index :teams, [:year, :name], unique: true
    
    # Add year to standings
    add_column :standings, :year, :integer, default: 2022, null: false
    add_index :standings, [:team_id, :year], unique: true
    
    # Add year to fixtures
    add_column :fixtures, :year, :integer, default: 2022, null: false
    add_index :fixtures, :year
    
    # Add year to rounds
    add_column :rounds, :year, :integer, default: 2022, null: false
  end
end