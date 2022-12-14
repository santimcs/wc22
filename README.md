![Qatar World Cup](./app/assets/images/logo.png)

cd\ruby  
rails \_5.1.7\_ new wc22 --skip-turbolinks --skip-spring --skip-test-unit -d postgresql   
cd wc22  

*Edit config/database.yml*  

	username: postgres   
	password: admin

rails db:create

rails g controller pages home

*Edit config/routes.rb*  
*You can have the root of your site routed with "root"*

	root 'pages#home'

*Edit Gemfile*  
    
	gem 'bootstrap-sass'

bundle update

*Edit app/assets/stylesheets/pages.scss*  
  
	@import "bootstrap";

## Bootsrap  
*Edit app/views/pages/home.html.erb to check that bootstrap is included or not*   

	<div class ="page-header text-center" >   
  		<h1>Home</h1>  
	</div>  

rails g model team name group ranking:integer flag  
  
*Edit db/migrate/migration file*    

	add_index :teams, :name, unique: true  
  
rails db:migrate

## Standings table
rails g model standing team:belongs_to wins:integer draws:integer losses:integer goals_for:integer goals_against:integer points:integer

rails g scaffold standing team:references wins:integer draws:integer losses:integer goals_for:integer goals_against:integer points:integer --skip-migration

*Edit db/seeds.rb*

	require 'csv'

	CSV.foreach(Rails.root.join("db/teams.csv"), headers: true) do |row|
		Team.find_or_create_by(
			name: row[0],
			group: row[1],
			ranking: row[2],
			flag: row[3])
	end

	sql = "INSERT INTO standings 		(team_id,wins,draws,losses,goals_for,goals_against,points,created_at,updated_at)
	SELECT id,0,0,0,0,0,0,now(),now() FROM teams ORDER BY id"
	results = ActiveRecord::Base.connection.execute(sql) 

rails db:seed

rails g scaffold team name group ranking flag --skip-migration 

*Edit app/views/teams/show.html.erb*

	<%= image_tag @team.flag %>

*Edit app/views/teams/index.html.erb*

	<td><%= image_tag team.flag %></td>

## Sessions table
rails g model session sequence:integer time:time

*Create db/crt_sessions.rb*

	require 'csv'
	class CrtSessions < ActiveRecord::Base
	CSV.foreach(Rails.root.join("db/sessions.csv"), headers: true) do |row|
		Session.find_or_create_by(
			sequence: row[0],
			time: row[1])
		end
	end

*Create db/sessions.csv*

	sequence,time
	1,17:00
	2,19:00
	3,20:00
	4,21:00
	5,22:00
	6,23:00
	7,01:00
	8,02:00

rails runner db/crt_sessions.rb

*Edit app/models/session.rb*

	def format_time
		time.strftime("%H:%M")
	end

## Rounds table

rails g model round sequence:integer name

*Edit db/migrate/migration file*

rails db:migrate

*Create db/rounds.csv*

	sequence,name
	1,RD1
	2,RD2
	3,QF
	4,SF
	5,3RD
	6,FIN

*Create db/crt_rounds.rb*

	require 'csv'

	class CrtRounds < ActiveRecord::Base

  	CSV.foreach(Rails.root.join("db/rounds.csv"), headers: true) do |row|
		Round.find_or_create_by(
			sequence: row[0],
			name: row[1])
		end
	end

rails runner db/crt_rounds.rb

## Criteria table
rails g scaffold criterium show_date:date

rails db:migrate

## Channels table
rails g scaffold channel number:integer name logo url

rails db:migrate

## Fixtures table
rails g model fixture round:references date:date session:references home_id:integer away_id:integer channel:references criterium:references

*Edit db/migrate/migration file*

	t.integer :home_id, foreign_key: true
	t.integer :away_id, foreign_key: true
	t.references :channel, foreign_key: true
	t.references :criterium, foreign_key: true, default: 1

rails db:migrate

*Edit app/models/fixture.rb*

	belongs_to :home, :class_name => 'Team'
	belongs_to :away, :class_name => 'Team'

rails g scaffold fixture date:date session:integer home_id:integer channel:integer away_id:integer --skip-migration

*Edit app/views/fixtures/_form.html.erb*

	<div class="field">
		<%= form.label :round_id %>
		<%= form.collection_select :round_id, Round.order("sequence asc"), :id, :name %>
	</div>

	<div class="field">
		<%= form.label :date %>
		<%= form.date_select :date, order: [:day, :month, :year] %>
	</div>

	<div class="field">
		<%= form.label :session_id %>
		<%= form.collection_select :session_id, Session.order("sequence ASC"), :id, :format_time %>
	</div>

	<div class="form-group">
		<%= form.label :home_id %>
		<%= form.collection_select :home_id, Team.all, :id, :name %>
	</div>

	<div class="form-group">
		<%= form.label :away_id %>
		<%= form.collection_select :away_id, Team.all, :id, :name %>
	</div>
	
	<div class="field">
		<%= form.label :channel_id %>
		<%= form.collection_select :channel_id, Channel.order("number ASC"), :id, :name %>
	</div>


*Edit app/views/fixtures/index.html.erb*

	<td><%= fixture.date.strftime("%a, %b %d") %></td>
	<td><%= image_tag fixture.home.flag, width: "50", height: "25" %></td>
	<td><%= link_to fixture.channel.name, "http://"+fixture.channel.url, target: "_new", class: "btn btn-info" %></td>   

*Edit app/controllers/fixtures_controller.rb*

	def list_fixtures
		@fixtures = Fixture.left_joins(:criterium).where("fixtures.date >= criteria.show_date")
	end

*Edit config/routes.rb*

	get "/list_fixtures", to: 'fixtures#list_fixtures'

## Results table
rails g scaffold result fixture:references home_goals:integer away_goals:integer 

rails db:migrate

*Edit app/models/result.rb*

	class Result < ApplicationRecord
   		belongs_to :fixture
		before_save :assign_points
		before_destroy :deduct_points
  		
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
          
    		standing = Standing.find_by_team_id(self.fixture.home_id)							standing.wins = standing.wins + home_wins
				standing.losses = standing.losses + home_losses
				standing.draws = standing.draws + home_draws 
 				standing.goals_for = standing.goals_for + self.home_goals
				standing.goals_against = standing.goals_against + 				self.away_goals 
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

## DataTable
*Edit gem file*

  gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'

bundle update

### Run the install generator:
rails generate jquery:datatables:install bootstrap3

*This will add to the corresponding asset files*

\### app/assets/javascripts/application.js  

	//= require dataTables/jquery.dataTables  
	//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap  

### app/assets/stylesheets/application.css  

	\*= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

*Edit app/views/results/index.html.erb*  

	<table id="results" class="table table-striped table-hover">

*Edit app/assets/javascripts/results.coffee*

	jQuery ->
		$('#results').dataTable({
		pagingType: 'full_numbers', 
        order: [[ 0, "desc" ]]
      })

  // Optional, if you want full pagination controls.

  // Check dataTables documentation to learn more about available options.

[DataTable website](http://datatables.net/reference/option/pagingType)

*If dataTable not work, must add following gem to Gemfile*  
\### Use jquery as the JavaScript library

	gem 'jquery-rails'

bundle update

*Edit app/views/teams/index.html.erb*

	<div class ="page-header text-center" > 
  		<%= link_to 'New Team', new_team_path,
  		:class => "btn btn-success pull-right"  %>
  		<h1>Teams</h1>
	</div>

	<table id="teams" class="table table-striped table-hover"> 
	<!-- start of buttons -->
		<td><%= link_to 'Show', fixture, :class => "btn btn-success btn-xs active"  %></td>
		<td><%= link_to 'Edit', edit_fixture_path(fixture), :class => "btn btn-warning btn-xs active" %></td>
		<td><%= link_to 'Destroy', fixture, method: :delete, data: { confirm: 'Are you sure?' }, :class => "btn btn-danger btn-xs active" %></td>

rails g scaffold matchday round matchday fm_date:date to_date:date 

rails db:migrate

rails g model fixture matchday:references home:references away:references

*Edit db/migrate/migration file*
	t.integer :home_id, foreign_key: true
	t.integer :away_id, foreign_key: true

rails db:migrate

rails g migration AddDayToFixture day:integer

rails db:migrate

rails g scaffold fixture matchday_id:integer home_id:integer away_id:integer day:integer --skip-migration 
        
rails g scaffold fixture home_id:integer away_id:integer 

*Edit app/model/fixture.rb*

  	belongs_to :home, :class_name => 'Team'  
	belongs_to :away, :class_name => 'Team'

rails db:migrate

rails g scaffold result fixture:references home_goals:integer away_goals:integer 

rails db:migrate

rails g scaffold standing team:references wins:integer draws:integer losses:integer
goals_for:integer goals_against:integer points:integer  

rails db:migrate

*Edit db/seeds.rb*

	20.times{ |i| Standing.where(team_id: i, wins: 0, draws: 0, losses: 0,
  	goals_for: 0, goals_against: 0, points: 0).first_or_create}

rails db:seed

*Edit app/model/result.rb*
	
	belongs_to :fixture
  	before_save :assign_points
  	before_destroy :deduct_points
  
  	private

  	def assign_point
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
          
    standing = Standing.find(self.fixture.home_id)
    standing.wins = standing.wins + home_wins
    standing.losses = standing.losses + home_losses
    standing.draws = standing.draws + home_draws  
    standing.goals_for = standing.goals_for + self.home_goals
    standing.goals_against = standing.goals_against + self.away_goals 
    standing.points = standing.points + home_points       
    standing.save   

    standing = Standing.find(self.fixture.away_id)
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
    
    standing = Standing.find(self.fixture.home_id)
    standing.wins = standing.wins - home_wins
    standing.losses = standing.losses - home_losses
    standing.draws = standing.draws - home_draws  
    standing.goals_for = standing.goals_for - self.home_goals
    standing.goals_against = standing.goals_against - self.away_goals 
    standing.points = standing.points - home_points       
    standing.save   

    standing = Standing.find(self.fixture.away_id)
    standing.wins = standing.wins - away_wins
    standing.losses = standing.losses - away_losses
    standing.draws = standing.draws - away_draws  
    standing.goals_for = standing.goals_for - self.away_goals
    standing.goals_against = standing.goals_against - self.home_goals 
    standing.points = standing.points - away_points       
    standing.save
  end       

## Create menu
*Edit views\layouts\application.html.erb*

  <body>
    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">

        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a href="#" class="navbar-brand">Euro 2016</a>
        </div> <!--end navbar-header -->

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><%= link_to 'Home', root_path %></li>
            <li><%= link_to 'Fixtures', fixtures_path %></li>    
            <li><%= link_to 'Results', results_path %></li>
            <li><%= link_to 'Standings', standings_path %></li>    
          </ul>
        </div><!--end of collapse navbar-collapse -->

      </div> <!-- end of container -->
    </nav>  <!-- End of nav element --> 
    <div class="container bodyContent"> <!-- from Bootstrap for Rails -->
      <%= yield %>
    </div> <!-- end of container -->

  </body>


*Edit app/assets/stylesheet/application.css.scss to increase space between menu and content*

  .bodyContent {
  margin-top: 50px;
  } 

rails g scaffold Score fixture:references side minute:integer plus:integer kind

rails g model Criterium show_date:date 

(Singular form of Criteria) 
(Naming show_date instead of date to prevent same column name in more than one
table. But that's unneccessary as we can prefix table name, e.g. criterium.date)

*If want to rename column* 

rails g migration change_date_to_show_date
	rename_column :criteria, :date, :show_date

rails g migration add_criterium_id_to_fixtures
	add_column :fixtures, :criterium_id, :integer

*Using psql to update criterium_id to 1*

	UPDATE fixtures SET criterium_id = 1;

*Edit app/model/fixture.rb*

	belongs_to :criterium

*Edit app/controllers/fixtures_controller.rb*

	@fixtures = Fixture.joins(:criterium).where("fixtures.date >= criteria.show_date")

*If collapsible menu doesn't work, must copy bootstap.min.js to app\assets\javascripts folder*
