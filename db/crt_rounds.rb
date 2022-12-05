require 'csv'

class CrtRounds < ActiveRecord::Base

	CSV.foreach(Rails.root.join("db/rounds.csv"), headers: true) do |row|
    	Round.find_or_create_by(
        sequence: row[0],
	    name: row[1])
	end

end