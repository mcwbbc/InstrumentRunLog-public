class AddInvoiceIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :invoice_id, :integer
  end

  def self.down
    remove_column :entries, :invoice_id
  end
end
