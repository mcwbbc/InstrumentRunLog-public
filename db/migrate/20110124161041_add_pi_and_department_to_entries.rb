class AddPiAndDepartmentToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :pi, :string
    add_column :entries, :department, :string
  end

  def self.down
    remove_column :entries, :pi
    remove_column :entries, :department
  end
end
