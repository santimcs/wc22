class AddYearToResults < ActiveRecord::Migration[5.1]
  def change
    add_column :results, :year, :integer
  end
end
