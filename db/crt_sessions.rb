require 'csv'

class CrtSessions < ActiveRecord::Base

	CSV.foreach(Rails.root.join("db/sessions.csv"), headers: true) do |row|
    	Session.find_or_create_by(
        sequence: row[0],
	    time: row[1])
	end

end