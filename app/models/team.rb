class Team < ApplicationRecord
  has_many :standings
  has_many :home_fixtures, class_name: 'Fixture', foreign_key: 'home_id'
  has_many :away_fixtures, class_name: 'Fixture', foreign_key: 'away_id'
  
  validates :name, presence: true
  validates :year, presence: true, inclusion: { in: [2022, 2026] }
  
  scope :for_year, ->(year) { where(year: year) }
  scope :wc2022, -> { where(year: 2022) }
  scope :wc2026, -> { where(year: 2026) }
  
  def display_name
    name == 'Korea Republic' ? 'South Korea' : name
  end
  
  def squad_url(current_year = year)
    base_url = "https://en.m.wikipedia.org/wiki/#{current_year}_FIFA_World_Cup_squads#"
    "#{base_url}#{CGI.escape(display_name.tr(' ', '_'))}"
  end
end