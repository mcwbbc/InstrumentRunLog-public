class AddUnbillableToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :unbillable, :boolean 
  end

  def self.down
    remove_column :entries, :unbillable
  end
end
