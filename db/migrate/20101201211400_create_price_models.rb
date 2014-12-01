class CreatePriceModels < ActiveRecord::Migration
  def self.up
    create_table :price_models do |t|
      t.references :instrument
      t.references :category
      t.float :digest_price
      t.float :hour_price
      t.float :sample_price
      t.date :effective_date
      t.date :retire_date

      t.timestamps
    end
  end

  def self.down
    drop_table :price_models
  end
end
