class AddPoToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :purchase_order, :string
  end

  def self.down
    remove_column :entries, :purchase_order
  end
end
