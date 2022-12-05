class Session < ApplicationRecord
	def format_time
      time.strftime("%H:%M")
  	end
end
