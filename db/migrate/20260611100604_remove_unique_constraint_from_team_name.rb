class RemoveUniqueConstraintFromTeamName < ActiveRecord::Migration[5.1]
  def change
    # Remove the old unique index on name
    remove_index :teams, name: "index_teams_on_name"
    
    # Add new unique index on name and year together
    add_index :teams, [:name, :year], unique: true
  end
end
