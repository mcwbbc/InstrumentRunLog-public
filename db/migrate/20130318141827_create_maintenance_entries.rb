class CreateMaintenanceEntries < ActiveRecord::Migration
  def self.up
    create_table :maintenance_entries do |t|
      t.integer :minutes
      t.text :notes
      t.references :user
      t.references :instrument
      t.datetime :date_conducted
      t.timestamps
    end
  end

  def self.down
    drop_table :maintenance_entries
  end
end
