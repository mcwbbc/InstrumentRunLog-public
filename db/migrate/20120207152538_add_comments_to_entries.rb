class AddCommentsToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :comments, :text
  end

  def self.down
    remove_column :entries, :comments
  end
end
