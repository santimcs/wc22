class Result < ApplicationRecord
    belongs_to :fixture
  default_scope { order("id DESC")}
# before_save :assign_points
# before_destroy :deduct_points
  
  private

  def assign_points

    home_wins = 0
    home_losses = 0
    home_draws = 0
    home_points = 0
    away_wins = 0
    away_losses = 0
    away_draws = 0  
    away_points = 0 
    if self.home_goals > self.away_goals
      home_wins = 1
      away_losses = 1
      home_points = 3
      away_points = 0 
    elsif self.home_goals < self.away_goals
      away_wins = 1
      home_losses = 1
      home_points = 0
      away_points = 3
    elsif self.home_goals = self.away_goals
      home_draws = 1  
      away_draws = 1  
      home_points = 1
      away_points = 1   
    end
          
    standing = Standing.find_by_team_id(self.fixture.home_id)
    standing.wins = standing.wins + home_wins
    standing.losses = standing.losses + home_losses
    standing.draws = standing.draws + home_draws  
    standing.goals_for = standing.goals_for + self.home_goals
    standing.goals_against = standing.goals_against + self.away_goals 
    standing.points = standing.points + home_points       
    standing.save   

    standing = Standing.find_by_team_id(self.fixture.away_id)
    standing.wins = standing.wins + away_wins
    standing.losses = standing.losses + away_losses
    standing.draws = standing.draws + away_draws  
    standing.goals_for = standing.goals_for + self.away_goals
    standing.goals_against = standing.goals_against + self.home_goals 
    standing.points = standing.points + away_points
    standing.save
  end       

  
  def deduct_points
  
    home_wins = 0
    home_losses = 0
    home_draws = 0
    away_wins = 0
    away_losses = 0
    away_draws = 0    
    if self.home_goals > self.away_goals
      home_wins = 1
      away_losses = 1
      home_points = 3
      away_points = 0
    elsif self.home_goals < self.away_goals
      away_wins = 1
      home_losses = 1
      home_points = 0
      away_points = 3
    elsif self.home_goals = self.away_goals
      home_draws = 1  
      away_draws = 1  
      home_points = 1
      away_points = 1   
    end
    
    standing = Standing.find_by_team_id(self.fixture.home_id)
    standing.wins = standing.wins - home_wins
    standing.losses = standing.losses - home_losses
    standing.draws = standing.draws - home_draws  
    standing.goals_for = standing.goals_for - self.home_goals
    standing.goals_against = standing.goals_against - self.away_goals 
    standing.points = standing.points - home_points       
    standing.save   

    standing = Standing.find_by_team_id(self.fixture.away_id)
    standing.wins = standing.wins - away_wins
    standing.losses = standing.losses - away_losses
    standing.draws = standing.draws - away_draws  
    standing.goals_for = standing.goals_for - self.away_goals
    standing.goals_against = standing.goals_against - self.home_goals 
    standing.points = standing.points - away_points       
    standing.save
  end 
end
