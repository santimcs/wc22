# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

CSV.foreach(Rails.root.join("db/teams.csv"), headers: true) do |row|
    Team.find_or_create_by(
        name: row[0],
        group: row[1],
        ranking: row[2],
        flag: row[3])
end

sql = "INSERT INTO standings 
		(team_id,wins,draws,losses,goals_for,goals_against,points,created_at,updated_at)
	   SELECT id,0,0,0,0,0,0,now(),now() FROM teams ORDER BY id"
results = ActiveRecord::Base.connection.execute(sql)     