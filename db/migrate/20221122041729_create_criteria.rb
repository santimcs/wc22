class CreateCriteria < ActiveRecord::Migration[5.1]
  def change
    create_table :criteria do |t|
      t.date :show_date

      t.timestamps
    end
  end
end
