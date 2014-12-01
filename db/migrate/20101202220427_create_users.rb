class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :hashed_password
      t.integer :admin
      t.references :lab

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
