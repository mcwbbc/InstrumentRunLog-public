class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.date :date_run
      t.references :user
      t.references :project
      t.string :instrument
      t.integer :blank_runs
      t.integer :blank_gradient

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
