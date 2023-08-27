class CreateEnemyWithVulnerableAndImbibable < ActiveRecord::Migration[7.0]
  def change
    create_table :enemy do |t|
      # Vulnerable Attributes
      t.integer :hitpoints
      t.integer :max_hitpoints

      # Vulnerable Attributes
      t.integer :total_experience
      t.integer :level
    end
  end
end
