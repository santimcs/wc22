require 'csv'
class UpdFlags < ActiveRecord::Base
	records_ins = 0
	records_upd = 0
	CSV.foreach(Rails.root.join("db/teams.csv"), { col_sep: ',', headers: true}) do |row|
		teams = Team.where(name: row[0])
		team = teams.first
		if team
			team.flag = row[3]
			team.save
			records_upd += 1
		end
	end
	printf "%2d records added, %2d records updated.", records_ins, records_upd
end