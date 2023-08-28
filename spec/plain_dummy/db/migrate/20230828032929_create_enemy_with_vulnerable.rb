class CreateEnemyWithVulnerable < ActiveRecord::Migration[7.0]
  def change
    create_table :enemy do |t|
      # Vulnerable Attributes
      t.integer :hitpoints
      t.integer :max_hitpoints
    end
  end
end
