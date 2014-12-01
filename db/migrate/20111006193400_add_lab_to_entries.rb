class AddLabToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :lab_id, :integer
  end

  def self.down
    remove_column :entries, :lab_id
  end
end
