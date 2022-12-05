class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :channels do |t|
      t.integer :number
      t.string :name
      t.string :logo
      t.string :url

      t.timestamps
    end
  end
end
