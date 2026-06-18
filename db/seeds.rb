# db/seeds.rb
require 'csv'

# Helper method to load teams
def load_teams_for_year(year, csv_file)
  puts "Loading #{year} teams from #{csv_file}..."
  
  CSV.foreach(Rails.root.join("db/#{csv_file}"), headers: true) do |row|
    team = Team.find_or_create_by(
      name: row['name'],
      year: year
    ) do |t|
      t.group = row['group']
      t.ranking = row['ranking'].to_i
      t.flag = row['flag']
    end
    
    # Update if exists but data changed
    unless team.persisted?
      team.update(
        group: row['group'],
        ranking: row['ranking'].to_i,
        flag: row['flag']
      )
    end
    
    # Create standing record for this team
    Standing.find_or_create_by(
      team_id: team.id,
      year: year
    ) do |s|
      s.wins = 0
      s.draws = 0
      s.losses = 0
      s.goals_for = 0
      s.goals_against = 0
      s.points = 0
    end
  end
  
  puts "✅ Loaded #{Team.where(year: year).count} teams for #{year}"
end

# Load 2022 teams
if Team.where(year: 2022).count == 0
  load_teams_for_year(2022, 'teams.csv')
else
  puts "⚠️ 2022 teams already loaded (#{Team.where(year: 2022).count} teams)"
end

# Load 2026 teams
if Team.where(year: 2026).count == 0
#  load_teams_for_year(2026, 'teams_2026.csv')
# Change this line:
#load_teams_for_year(2026, 'teams_2026.csv')
# To:
	load_teams_for_year(2026, 'teams_2026_complete.csv')
else
  puts "⚠️ 2026 teams already loaded (#{Team.where(year: 2026).count} teams)"
end

# Add 2026 knockout rounds
rounds_2026 = [
  { sequence: 1, name: 'Round of 32', year: 2026 },
  { sequence: 2, name: 'Round of 16', year: 2026 },
  { sequence: 3, name: 'Quarter-finals', year: 2026 },
  { sequence: 4, name: 'Semi-finals', year: 2026 },
  { sequence: 5, name: 'Final', year: 2026 }
]

rounds_2026.each do |round_data|
  Round.find_or_create_by(sequence: round_data[:sequence], year: round_data[:year]) do |r|
    r.name = round_data[:name]
  end
end

puts "\n📊 Summary:"
puts "   Teams: #{Team.count} (2022: #{Team.where(year: 2022).count}, 2026: #{Team.where(year: 2026).count})"
puts "   Standings: #{Standing.count}"
puts "   Rounds: #{Round.count}"
puts "\n✅ Seeding complete!"    