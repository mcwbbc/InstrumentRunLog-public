class AddUpdatedByToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :updated_by_id, :integer
  end

  def self.down
    remove_column :entries, :updated_by_id
  end
end
