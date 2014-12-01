class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.integer :digests
      t.integer :runs
      t.integer :gradient
      t.float :sample_price
      t.float :digest_price
      t.float :hour_price
      t.string :category
      t.references :entry

      t.timestamps
    end
  end

  def self.down
    drop_table :samples
  end
end
