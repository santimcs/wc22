# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20260612164408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "logo"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "criteria", force: :cascade do |t|
    t.date "show_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fixtures", force: :cascade do |t|
    t.bigint "round_id"
    t.date "date"
    t.bigint "session_id"
    t.integer "home_id"
    t.integer "away_id"
    t.bigint "channel_id"
    t.bigint "criterium_id", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", default: 2022, null: false
    t.index ["channel_id"], name: "index_fixtures_on_channel_id"
    t.index ["criterium_id"], name: "index_fixtures_on_criterium_id"
    t.index ["round_id"], name: "index_fixtures_on_round_id"
    t.index ["session_id"], name: "index_fixtures_on_session_id"
    t.index ["year"], name: "index_fixtures_on_year"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "fixture_id"
    t.integer "home_goals"
    t.integer "away_goals"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["fixture_id"], name: "index_results_on_fixture_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "sequence"
    t.string "name"
    t.integer "year", default: 2022, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "sequence"
    t.time "time"
  end

  create_table "standings", force: :cascade do |t|
    t.bigint "team_id"
    t.integer "wins"
    t.integer "draws"
    t.integer "losses"
    t.integer "goals_for"
    t.integer "goals_against"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", default: 2022, null: false
    t.index ["team_id", "year"], name: "index_standings_on_team_id_and_year", unique: true
    t.index ["team_id"], name: "index_standings_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "group"
    t.integer "ranking"
    t.string "flag"
    t.integer "year", default: 2022, null: false
    t.index ["name", "year"], name: "index_teams_on_name_and_year", unique: true
    t.index ["year", "group"], name: "index_teams_on_year_and_group"
    t.index ["year", "name"], name: "index_teams_on_year_and_name", unique: true
  end

  create_table "temp_table", id: false, force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "W"
    t.bigint "D"
    t.bigint "L"
    t.bigint "GF"
    t.bigint "GA"
    t.bigint "Pts"
  end

  add_foreign_key "fixtures", "channels"
  add_foreign_key "fixtures", "criteria"
  add_foreign_key "fixtures", "rounds"
  add_foreign_key "fixtures", "sessions"
  add_foreign_key "results", "fixtures"
  add_foreign_key "standings", "teams"
end
