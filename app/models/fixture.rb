class Fixture < ApplicationRecord
  belongs_to :round
  belongs_to :session
  belongs_to :channel
  belongs_to :criterium
  belongs_to :home, :class_name => 'Team'
  belongs_to :away, :class_name => 'Team'  
  default_scope { order("date DESC")}  
end
