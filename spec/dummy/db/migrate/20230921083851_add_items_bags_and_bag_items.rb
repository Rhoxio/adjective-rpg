class AddItemsBagsAndBagItems < ActiveRecord::Migration[7.0]
  def change

    create_table :items do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    create_table :bags do |t|
      t.string :name
      t.timestamps
    end

    create_table :bag_items do |t|
      t.integer :bag_id
      t.integer :item_id
      t.integer :position
      t.integer :stack_size
      t.timestamps
    end

  end
end
