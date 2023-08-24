class CreateAllAdjectiveTables < ActiveRecord::Migration[7.0]
  def change
    create_table :actors do |t|
      t.string :name

      t.timestamps
    end
  end
end