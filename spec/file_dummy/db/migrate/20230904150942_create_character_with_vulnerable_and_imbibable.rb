class CreateCharacterWithVulnerableAndImbibable < ActiveRecord::Migration[7.0]
  def change
    create_table :character do |t|
      # Adjective::Vulnerable attributes
      t.integer :hitpoints
      t.integer :max_hitpoints
      # Adjective::Imbibable attributes
      t.integer :level
      t.integer :total_experience
    end
  end
end
