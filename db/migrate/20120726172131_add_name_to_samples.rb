class AddNameToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :name, :text
  end

  def self.down
    remove_column :samples, :name
  end
end
