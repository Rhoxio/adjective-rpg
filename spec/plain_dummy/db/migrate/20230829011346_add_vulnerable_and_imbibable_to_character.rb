class AddVulnerableAndImbibableToCharacter < ActiveRecord::Migration[7.0]
  def up
    # Vulnerable Attributes
    add_column :character, :hitpoints, :integer
    add_column :character, :max_hitpoints, :integer

    # Imbibable Attributes
    add_column :character, :total_experience, :integer
    add_column :character, :level, :integer
  end

  def down
    # Vulnerable Attributes
    remove_column :character, :hitpoints, :integer
    remove_column :character, :max_hitpoints, :integer

    # Imbibable Attributes
    remove_column :character, :total_experience, :integer
    remove_column :character, :level, :integer
  end
end
